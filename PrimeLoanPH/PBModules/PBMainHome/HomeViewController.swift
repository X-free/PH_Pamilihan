//
//  HomeViewController.swift
//  PrimeLoanPH
//
//  首页：off/reviews → draw；默认大卡（srb）；存在 reviewed==src 时顶部改小卡 UI（conclusion 首条 + ScardGroup9900486）；列表 reviewed==srd 的 conclusion 为小卡列表
//

import UIKit

private let kNotiLoginSuccess = Notification.Name("PB_NotiLoginThanSuccess")
private let kNotiLogoutToHome = Notification.Name("PB_NotiLogoutThanToHome")

@objc(HomeViewController)
final class HomeViewController: PPTableViewController {

    private var didAppearOnce = false
    /// 与 ObjC 一致：仅首次进入时的请求展示全屏 Loading，之后依赖下拉刷新
    private var allowBlockingLoad = true
    private var homePayload: PBReviewsResponse?
    private var largeCardModel: PBDrawConclusionPayload?
    /// `reviewed == src` 时顶部小卡：对应该项 `conclusion` 第一条
    private var smallCardHeroModel: PBDrawConclusionPayload?
    private var bannerModel: PBDrawConclusionPayload?
    /// `reviewed == srd`：`conclusion` 为小卡列表数据
    private var productRows: [PBDrawConclusionPayload] = []

    private lazy var aPageHeader: APageHomeHeaderView = {
        let v = APageHomeHeaderView()
        v.onLoanApply = { [weak self] pid in
            self?.applyProduct(pid: pid)
        }
        v.onServiceTap = { [weak self] in
            self?.openService()
        }
        return v
    }()

    private var tableTopConstraint: NSLayoutConstraint?

    /// iOS 18 上 QMUITips/QMUIToastView 会 maskView 断言崩溃，首页改用系统遮罩。
    private var nativeLoadOverlay: UIView?

    @objc public override init(pbTableViewOfGroupStyle tableViewIsGroupStyle: Bool) {
        super.init(pbTableViewOfGroupStyle: tableViewIsGroupStyle)
    }

    /// 必须实现且只能走 `super.init(nibName:bundle:)`：`PPTableViewController` 的 `[super init]` 会调到
    /// `initWithNibName:bundle:`。若用 convenience 再 `self.init(pbTableViewOfGroupStyle:)` 会与此形成无限递归。
    @objc public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar = false
        view.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")
        tableView.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")
        tableView.separatorStyle = .none
        ppShowTableViewHeaderRefresh = true

        pinTableViewUnderStatusBar()

        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSuccess), name: kNotiLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: kNotiLogoutToHome, object: nil)

        ppStartDelays()
        requestHomeReviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didAppearOnce {
            requestHomeReviews()
            scheduleReports()
        }
        didAppearOnce = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTableHeaderIfNeeded()
    }

    deinit {
        let overlay = nativeLoadOverlay
        nativeLoadOverlay = nil
        if let overlay {
            DispatchQueue.main.async {
                overlay.removeFromSuperview()
            }
        }
        NotificationCenter.default.removeObserver(self)
    }

    private func pinTableViewUnderStatusBar() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        tableTopConstraint = top
        NSLayoutConstraint.activate([
            top,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        updateTableTopInset()
    }

    private func updateTableTopInset() {
        let inset = view.safeAreaInsets.top > 0 ? view.safeAreaInsets.top : 20
        tableTopConstraint?.constant = -inset
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateTableTopInset()
    }

    private func ppStartDelays() {
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeLocation)
        perform(#selector(delayedLocation), with: nil, afterDelay: 5)
        perform(#selector(delayedDevice), with: nil, afterDelay: 3)
        perform(#selector(delayedGoogle), with: nil, afterDelay: 6)
        perform(#selector(delayedAddress), with: nil, afterDelay: 7)
    }

    @objc private func delayedLocation() {
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeLocation)
    }

    @objc private func delayedDevice() {
        PB_idf_helper.instanceOnly().pb_t_enquryIDFA_ask()
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeDeviceInfo)
    }

    @objc private func delayedGoogle() {
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeGooleMarket)
    }

    @objc private func delayedAddress() {
        PB_APP_Control.pb_t_toRequestAdressDataSuccess(afterCallBack: { _ in })
    }

    private func appHomeURLString() -> String {
        let root = PB_AskRootUrlHelper.instanceOnly().pb_root_url
        return root + "off/reviews"
    }

    private func homeLoadingHostView() -> UIView {
        if let w = view.window { return w }
        if #available(iOS 13.0, *) {
            for case let scene as UIWindowScene in UIApplication.shared.connectedScenes {
                if let w = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first {
                    return w
                }
            }
        }
        return view
    }

    private func showNativeHomeLoading() {
        let run = { [weak self] in
            guard let self else { return }
            self.hideNativeHomeLoading()
            let host = self.homeLoadingHostView()
            let dim = UIView(frame: host.bounds)
            dim.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dim.backgroundColor = UIColor.black.withAlphaComponent(0.22)
            dim.isUserInteractionEnabled = true
            let spin: UIActivityIndicatorView
            if #available(iOS 13.0, *) {
                spin = UIActivityIndicatorView(style: .large)
                spin.color = .white
            } else {
                spin = UIActivityIndicatorView(style: .whiteLarge)
            }
            spin.translatesAutoresizingMaskIntoConstraints = false
            dim.addSubview(spin)
            NSLayoutConstraint.activate([
                spin.centerXAnchor.constraint(equalTo: dim.centerXAnchor),
                spin.centerYAnchor.constraint(equalTo: dim.centerYAnchor)
            ])
            spin.startAnimating()
            host.addSubview(dim)
            self.nativeLoadOverlay = dim
        }
        if Thread.isMainThread {
            run()
        } else {
            DispatchQueue.main.async(execute: run)
        }
    }

    private func hideNativeHomeLoading() {
        let run = { [weak self] in
            self?.nativeLoadOverlay?.removeFromSuperview()
            self?.nativeLoadOverlay = nil
        }
        if Thread.isMainThread {
            run()
        } else {
            DispatchQueue.main.async(execute: run)
        }
    }

    private func presentHomeAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self, self.presentedViewController == nil else { return }
            let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    private func requestHomeReviews() {
        if allowBlockingLoad {
            showNativeHomeLoading()
        }
        let url = appHomeURLString()
        PB_RequestHelper.pb_instance().pb_getRequest(withUrlStr: url, params: [:], commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideNativeHomeLoading()
                self.allowBlockingLoad = false
                let dict: [String: Any]? = {
                    if let d = result as? [String: Any] { return d }
                    if let nsd = result as NSDictionary? { return nsd as? [String: Any] }
                    return nil
                }()
                if let dict {
                    do {
                        let model = try PBReviewsResponse.decode(from: dict)
                        self.applyHome(model)
                    } catch {
                        self.presentHomeAlert(message: "Parse error")
                    }
                }
                self.ppTableViewEndAllRefresh()
            }
        }, failure: { [weak self] _, _, msg in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideNativeHomeLoading()
                self.allowBlockingLoad = false
                if !msg.isEmpty {
                    self.presentHomeAlert(message: msg)
                }
                self.ppTableViewEndAllRefresh()
            }
        })
    }

    private func applyHome(_ model: PBReviewsResponse) {
        homePayload = model
        largeCardModel = nil
        smallCardHeroModel = nil
        bannerModel = nil
        productRows.removeAll()

        guard let draw = model.theoretical?.draw else {
            layoutTableHeaderIfNeeded()
            tableView.reloadData()
            return
        }

        for item in draw {
            let type = (item.reviewed ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            switch type {
            case PBHomeDrawReviewed.largeCard:
                if largeCardModel == nil, let first = item.conclusion?.first {
                    largeCardModel = first
                }
            case PBHomeDrawReviewed.smallCard:
                if smallCardHeroModel == nil, let first = item.conclusion?.first {
                    smallCardHeroModel = first
                }
            case PBHomeDrawReviewed.banner:
                if bannerModel == nil, let first = item.conclusion?.first {
                    bannerModel = first
                }
            case PBHomeDrawReviewed.productList:
                if let list = item.conclusion {
                    productRows.append(contentsOf: list)
                }
            default:
                break
            }
        }

        layoutTableHeaderIfNeeded()
        tableView.reloadData()
    }

    private func layoutTableHeaderIfNeeded() {
        let w = view.bounds.width
        guard w > 0 else { return }
        aPageHeader.configure(
            response: homePayload,
            largeCard: largeCardModel,
            smallCardHero: smallCardHeroModel,
            banner: bannerModel
        )
        let h = aPageHeader.preferredHeight(width: w)
        aPageHeader.frame = CGRect(x: 0, y: 0, width: w, height: h)
        tableView.tableHeaderView = aPageHeader
    }

    private func applyProduct(pid: Int) {
        guard pid > 0 else { return }
        guard PB_APP_Control.pb_t_presentLoginVC(withTargetVC: self) else { return }
        PB_APP_Control.pb_t_toRequestProductIsCanEnterAllow(withProductID: pid, fromVC: self)
    }

    private func openService() {
        guard PB_APP_Control.pb_t_presentLoginVC(withTargetVC: self) else { return }
        guard let link = aPageHeader.resolvedServiceURL(), !link.isEmpty else { return }
        PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: self)
    }

    @objc private func onLoginSuccess() {
        requestHomeReviews()
        scheduleReports()
    }

    @objc private func onLogout() {
        requestHomeReviews()
    }

    private func scheduleReports() {
        perform(#selector(reportLocationDelayed), with: nil, afterDelay: 2)
        perform(#selector(reportDeviceDelayed), with: nil, afterDelay: 3)
        perform(#selector(reportGoogleDelayed), with: nil, afterDelay: 4)
    }

    @objc private func reportLocationDelayed() {
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeLocation)
    }

    @objc private func reportDeviceDelayed() {
        PB_idf_helper.instanceOnly().pb_t_enquryIDFA_ask()
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeDeviceInfo)
    }

    @objc private func reportGoogleDelayed() {
        PB_APP_Control.instanceOnly().pb_t_toRePortDataToServe(withType: .pb_t_UploadDateTypeGooleMarket)
    }

    // MARK: - Refresh (PPTableViewController)

    override func pb_t_de_TableViewHeaderRefreshMethod() {
        requestHomeReviews()
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productRows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = APageHomeSmallProductCell.reuseId
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as? APageHomeSmallProductCell
            ?? APageHomeSmallProductCell(style: .default, reuseIdentifier: id)
        let m = productRows[indexPath.row]
        cell.configure(model: m)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pid = productRows[indexPath.row].pivotal ?? 0
        guard pid > 0 else { return }
        applyProduct(pid: pid)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        APageLayout.ratio(176)
    }
}

// MARK: - `reviewed == srd` 列表：白底小卡；整卡点击进件（`didSelectRow`）；底栏仅样式；底行 questioning:naldic | simply:announced

final class APageHomeSmallProductCell: UITableViewCell {

    static let reuseId = "pb.home.small.product"

    private let cardContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let amountCaptionLabel = UILabel()
    private let amountLabel = UILabel()
    /// 底行左：`questioning` + ":" + `naldic`
    private let bottomLeftLabel = UILabel()
    /// 底行右：`simply` + ":" + `announced`
    private let bottomRightLabel = UILabel()
    private let bottomInterpRow = UIStackView()
    /// 底行左右「两头对齐」之间的弹性占位
    private let bottomRowSpacer = UIView()
    private let applyButton = UIButton(type: .system)

    private var iconLoadTask: URLSessionDataTask?
    /// 避免异步回调与复用后错位上图
    private var iconExpectedURL: String = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 12
        cardContainer.clipsToBounds = true
        cardContainer.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = APageLayout.ratio(8)
        iconImageView.backgroundColor = UIColor.pbColorBackHexStr("#F0F0F0")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: APageLayout.ratio(15), weight: .semibold)
        titleLabel.textColor = UIColor.pbColorBackHexStr("#26252A")
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        amountCaptionLabel.font = .systemFont(ofSize: APageLayout.ratio(12), weight: .regular)
        amountCaptionLabel.textColor = UIColor.pbColorBackHexStr("#8C8C8C")
        amountCaptionLabel.translatesAutoresizingMaskIntoConstraints = false

        amountLabel.font = .systemFont(ofSize: APageLayout.ratio(24), weight: .bold)
        amountLabel.textColor = UIColor.pbColorBackHexStr("#26252A")
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        [bottomLeftLabel, bottomRightLabel].forEach {
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        bottomLeftLabel.textAlignment = .left
        bottomRightLabel.textAlignment = .right

        bottomRowSpacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        bottomRowSpacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

        bottomInterpRow.addArrangedSubview(bottomLeftLabel)
        bottomInterpRow.addArrangedSubview(bottomRowSpacer)
        bottomInterpRow.addArrangedSubview(bottomRightLabel)
        bottomInterpRow.axis = .horizontal
        bottomInterpRow.spacing = APageLayout.ratio(8)
        bottomInterpRow.alignment = .top
        bottomInterpRow.distribution = .fill
        bottomInterpRow.translatesAutoresizingMaskIntoConstraints = false

        applyButton.titleLabel?.font = .systemFont(ofSize: APageLayout.ratio(14), weight: .semibold)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = APageLayout.ratio(18)
        applyButton.clipsToBounds = true
        applyButton.setTitle("", for: .normal)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        if let capImg = UIImage(named: APageAsset.primaryButtonBg) {
            let inset = capImg.size.width * 0.45
            let resizable = capImg.resizableImage(
                withCapInsets: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset),
                resizingMode: .stretch
            )
            applyButton.setBackgroundImage(resizable, for: .normal)
        } else {
            applyButton.backgroundColor = UIColor.pbColorBackHexStr("#5C4033")
        }
        applyButton.setContentHuggingPriority(.required, for: .horizontal)
        applyButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        // 整卡点击由 TableView `didSelectRow` 处理；底部仅视觉样式，不作为独立按钮
        applyButton.isUserInteractionEnabled = false

        let amountBlock = UIStackView(arrangedSubviews: [amountCaptionLabel, amountLabel])
        amountBlock.axis = .vertical
        amountBlock.spacing = APageLayout.ratio(4)
        amountBlock.alignment = .leading
        amountBlock.translatesAutoresizingMaskIntoConstraints = false
        amountBlock.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let topRow = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        topRow.axis = .horizontal
        topRow.spacing = APageLayout.ratio(10)
        topRow.alignment = .center
        topRow.translatesAutoresizingMaskIntoConstraints = false

        let middleRow = UIStackView(arrangedSubviews: [amountBlock, applyButton])
        middleRow.axis = .horizontal
        middleRow.spacing = APageLayout.ratio(10)
        middleRow.alignment = .center
        middleRow.distribution = .fill
        middleRow.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardContainer)
        cardContainer.addSubview(topRow)
        cardContainer.addSubview(middleRow)
        cardContainer.addSubview(bottomInterpRow)

        let pad = APageLayout.ratio(12)
        let iconSide = APageLayout.ratio(40)
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            topRow.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: pad),
            topRow.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: pad),
            topRow.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -pad),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSide),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSide),

            middleRow.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: APageLayout.ratio(10)),
            middleRow.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: pad),
            middleRow.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -pad),

            bottomInterpRow.topAnchor.constraint(equalTo: middleRow.bottomAnchor, constant: APageLayout.ratio(10)),
            bottomInterpRow.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: pad),
            bottomInterpRow.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -pad),

            applyButton.widthAnchor.constraint(equalToConstant: APageLayout.ratio(88)),
            applyButton.heightAnchor.constraint(equalToConstant: APageLayout.ratio(36))
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func linePlaceholderIfEmpty(_ s: String?) -> String {
        let t = (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? "\u{00A0}" : t
    }

    /// 与大卡期限/费率行一致：标题（含冒号）11 Regular `#8C8C8C`，数值 13 Semibold `#3B332C`
    private static func listCardFooterLine(title: String?, value: String?) -> NSAttributedString? {
        let t = (title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let v = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty && v.isEmpty { return nil }
        let titleFont = UIFont.systemFont(ofSize: APageLayout.ratio(11), weight: .regular)
        let valueFont = UIFont.systemFont(ofSize: APageLayout.ratio(13), weight: .semibold)
        let titleColor = UIColor.pbColorBackHexStr("#8C8C8C")
        let valueColor = UIColor.pbColorBackHexStr("#3B332C")
        let m = NSMutableAttributedString()
        if !t.isEmpty {
            m.append(NSAttributedString(string: t, attributes: [
                .font: titleFont,
                .foregroundColor: titleColor
            ]))
            m.append(NSAttributedString(string: ":", attributes: [
                .font: titleFont,
                .foregroundColor: titleColor
            ]))
            if !v.isEmpty {
                m.append(NSAttributedString(string: " ", attributes: [
                    .font: valueFont,
                    .foregroundColor: valueColor
                ]))
            }
        }
        if !v.isEmpty {
            m.append(NSAttributedString(string: v, attributes: [
                .font: valueFont,
                .foregroundColor: valueColor
            ]))
        }
        return m
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconLoadTask?.cancel()
        iconLoadTask = nil
        iconExpectedURL = ""
        iconImageView.image = nil
    }

    func configure(model: PBDrawConclusionPayload) {
        titleLabel.text = Self.linePlaceholderIfEmpty(model.courses)
        amountCaptionLabel.text = Self.linePlaceholderIfEmpty(model.powerful)
        amountLabel.text = Self.linePlaceholderIfEmpty(model.voice)

        bottomLeftLabel.attributedText = Self.listCardFooterLine(title: model.questioning, value: model.naldic)
        bottomRightLabel.attributedText = Self.listCardFooterLine(title: model.simply, value: model.announced)
        let hasBottom = bottomLeftLabel.attributedText != nil || bottomRightLabel.attributedText != nil
        bottomInterpRow.isHidden = !hasBottom

        let btnRaw = (model.lobbying?.isEmpty == false) ? model.lobbying! : ""
        let btn = btnRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        applyButton.setTitle(btn.isEmpty ? "\u{00A0}" : btn, for: .normal)

        iconLoadTask?.cancel()
        iconLoadTask = nil
        let raw = model.networks?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        iconExpectedURL = raw
        if raw.isEmpty {
            iconImageView.image = nil
        } else if let url = URL(string: raw) {
            iconLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let img = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard let self, self.iconExpectedURL == raw else { return }
                    self.iconImageView.image = img
                }
            }
            iconLoadTask?.resume()
        } else {
            iconImageView.image = nil
        }
    }
}
