//
//  PPSubOrderViewController.swift
//  PrimeLoanPH
//

import UIKit

private let kOrderLoginSuccessNoti = Notification.Name("PB_NotiLoginThanSuccess")

@objc(PPSubOrderViewController)
final class PPSubOrderViewController: PPTableViewController {

    /// WMPageController / 父类 PPOrderViewController KVC 注入 statutory：7=Apply，6=Repayment，5=Finished
    @objc var keyId: Int = 7

    private var dataRows: [PPOrderDrawModel] = []
    private var orderPageFirstFlag = false

    private var nativeLoadOverlay: UIView?
    private var lastEmptyLayoutWidth: CGFloat = 0

    private let cream = UIColor.pbColorBackHexStr("#FBF6E7")
    @objc public override init(pbTableViewOfGroupStyle tableViewIsGroupStyle: Bool) {
        super.init(pbTableViewOfGroupStyle: tableViewIsGroupStyle)
    }

    @objc public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar = false
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = pbRatio(145)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(PPOrderTableViewCell.self, forCellReuseIdentifier: PB_t_OrderTableViewCellKey_de)
        tableView.register(OrderListEmptyAorderCell.self, forCellReuseIdentifier: OrderListEmptyAorderCell.reuseId)

        ppShowTableViewHeaderRefresh = true
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSuccessNoti), name: kOrderLoginSuccessNoti, object: nil)

        requestMethod()
    }

    /// 供父控制器 `PPOrderViewController` 切换 segment 后触发列表刷新（ObjC `performSelector`）
    @objc func pp_reloadOrderList() {
        requestMethod()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard dataRows.isEmpty, tableView.numberOfSections > 0,
              tableView.numberOfRows(inSection: 0) == 1 else { return }
        let w = view.bounds.width
        guard w > 1, abs(w - lastEmptyLayoutWidth) > 0.5 else { return }
        lastEmptyLayoutWidth = w
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if orderPageFirstFlag, PB_APP_Control.instanceOnly().pb_t_hasLogin {
            requestMethod()
        }
        orderPageFirstFlag = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: kOrderLoginSuccessNoti, object: nil)
        nativeLoadOverlay?.removeFromSuperview()
    }

    // MARK: - Network

    @objc private func onLoginSuccessNoti() {
        requestMethod()
    }

    override func pb_t_de_TableViewHeaderRefreshMethod() {
        requestMethod()
    }

    private func requestMethod() {
        if orderPageFirstFlag == false {
            showNativeOrderLoading()
        }
        let params: [String: Any] = [
            "statutory": keyId,
            "statement": 1,
            "differentiate": 1000
        ]
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: PB_API_MyOrderListURL(), params: params, commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideNativeOrderLoading()
                self.dataRows = []
                if let result = result, let model = PPOrderModel.yy_model(withJSON: result) {
                    if let draw = model.theoretical?.draw as? [Any] {
                        for item in draw {
                            if let row = item as? PPOrderDrawModel {
                                self.dataRows.append(row)
                            }
                        }
                    }
                }
                self.ppTableViewEndAllRefresh()
                self.tableView.reloadData()
            }
        }, failure: { [weak self] _, _, errorStr in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideNativeOrderLoading()
                self.presentOrderAlert(message: errorStr)
                self.ppTableViewEndAllRefresh()
            }
        })
    }

    private func showNativeOrderLoading() {
        let run = { [weak self] in
            guard let self else { return }
            self.hideNativeOrderLoading()
            let dim = UIView(frame: self.view.bounds)
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
            self.view.addSubview(dim)
            self.nativeLoadOverlay = dim
        }
        if Thread.isMainThread {
            run()
        } else {
            DispatchQueue.main.async(execute: run)
        }
    }

    private func hideNativeOrderLoading() {
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

    private func presentOrderAlert(message: String) {
        guard !message.isEmpty else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self, self.presentedViewController == nil else { return }
            let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRows.isEmpty ? 1 : dataRows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !dataRows.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: PB_t_OrderTableViewCellKey_de, for: indexPath) as! PPOrderTableViewCell
            cell.pb_config(withCellData: dataRows[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderListEmptyAorderCell.reuseId, for: indexPath) as! OrderListEmptyAorderCell
        cell.configure(onLoan: { [weak self] in
            self?.handleGoForLoan()
        })
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !dataRows.isEmpty {
            return UITableView.automaticDimension
        }
        return emptyPlaceholderRowHeight()
    }

    /// 空态占满列表可视区域（顶图与 segment 在父控制器上，此处为纯列表区）
    private func emptyPlaceholderRowHeight() -> CGFloat {
        let usable = view.bounds.height - view.safeAreaInsets.bottom
        if usable > 200 {
            return max(usable, 360)
        }
        return max(400, UIScreen.main.bounds.height - 120)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !PB_APP_Control.pb_t_presentLoginVC(withTargetVC: self) {
            return
        }
        guard !dataRows.isEmpty else { return }
        let model = dataRows[indexPath.row]
        let link = model.cases ?? ""
        PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: self)
    }

    private func handleGoForLoan() {
        tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: true)
    }

    private func pbRatio(_ x: CGFloat) -> CGFloat {
        x * (UIScreen.main.bounds.width / 375.0)
    }
}

// MARK: - Empty state（Aorder: emptyinbox + Roundengle）

private final class OrderListEmptyAorderCell: UITableViewCell {

    static let reuseId = "OrderListEmptyAorderCell"

    private let boxView = UIImageView()
    private let tipLabel = UILabel()
    private let loanButton = UIButton(type: .custom)
    private let mainStack = UIStackView()
    private let boxWrap = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        boxView.image = UIImage(named: "emptyinbox")
        boxView.contentMode = .scaleAspectFit
        boxView.translatesAutoresizingMaskIntoConstraints = false

        boxWrap.translatesAutoresizingMaskIntoConstraints = false
        boxWrap.addSubview(boxView)

        tipLabel.text = "No more thing"
        tipLabel.font = .systemFont(ofSize: 16, weight: .regular)
        tipLabel.textColor = UIColor.pbColorBackHexStr("#8A8A8A")
        tipLabel.textAlignment = .center
        tipLabel.numberOfLines = 0

        loanButton.setTitle("Go for a loan", for: .normal)
        loanButton.setTitleColor(.white, for: .normal)
        loanButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        loanButton.layer.cornerRadius = 26
        loanButton.layer.masksToBounds = true
        if let bg = OrderListEmptyAorderCell.resizableRoundengle() {
            loanButton.setBackgroundImage(bg, for: .normal)
        } else {
            loanButton.backgroundColor = UIColor.pbColorBackHexStr("#3D2918")
        }

        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 14
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(boxWrap)
        mainStack.addArrangedSubview(tipLabel)
        mainStack.addArrangedSubview(loanButton)

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            boxView.centerXAnchor.constraint(equalTo: boxWrap.centerXAnchor),
            boxView.topAnchor.constraint(equalTo: boxWrap.topAnchor),
            boxView.bottomAnchor.constraint(equalTo: boxWrap.bottomAnchor),
            boxView.widthAnchor.constraint(lessThanOrEqualTo: boxWrap.widthAnchor),
            boxView.heightAnchor.constraint(equalToConstant: 176),

            loanButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var onLoanTap: (() -> Void)?

    func configure(onLoan: @escaping () -> Void) {
        onLoanTap = onLoan
        loanButton.removeTarget(self, action: #selector(tapLoan), for: .touchUpInside)
        loanButton.addTarget(self, action: #selector(tapLoan), for: .touchUpInside)
    }

    @objc private func tapLoan() {
        onLoanTap?()
    }

    private static func resizableRoundengle() -> UIImage? {
        guard let img = UIImage(named: "Roundengle") else { return nil }
        let sz = img.size
        let insetX = sz.width / 2.0 - 0.5
        let insetY = sz.height / 2.0 - 0.5
        return img.resizableImage(
            withCapInsets: UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX),
            resizingMode: .stretch
        )
    }
}
