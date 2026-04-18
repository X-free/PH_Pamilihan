//
//  HomeViewController.swift
//  PrimeLoanPH
//
//  首页：off/reviews → 解析 draw；reviewed == srb 展示大卡；无 srb 时用 src 回退到大卡，保证首页默认有大卡区
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
    private var bannerModel: PBDrawConclusionPayload?
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
        bannerModel = nil
        productRows.removeAll()

        guard let draw = model.theoretical?.draw else {
            layoutTableHeaderIfNeeded()
            tableView.reloadData()
            return
        }

        var smallCardFallback: PBDrawConclusionPayload?

        for item in draw {
            let type = (item.reviewed ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            switch type {
            case PBHomeDrawReviewed.largeCard:
                if largeCardModel == nil, let first = item.conclusion?.first {
                    largeCardModel = first
                }
            case PBHomeDrawReviewed.smallCard:
                if smallCardFallback == nil, let first = item.conclusion?.first {
                    smallCardFallback = first
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

        if largeCardModel == nil {
            largeCardModel = smallCardFallback
        }

        layoutTableHeaderIfNeeded()
        tableView.reloadData()
    }

    private func layoutTableHeaderIfNeeded() {
        let w = view.bounds.width
        guard w > 0 else { return }
        aPageHeader.configure(response: homePayload, largeCard: largeCardModel, banner: bannerModel)
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
        let id = "pb.home.product.cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: id)
        let m = productRows[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = m.courses
        cell.detailTextLabel?.text = m.voice
        cell.detailTextLabel?.textColor = UIColor.pbColorBackHexStr("#8C8C8C")
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pid = productRows[indexPath.row].pivotal ?? 0
        guard pid > 0 else { return }
        applyProduct(pid: pid)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        APageLayout.ratio(72)
    }
}
