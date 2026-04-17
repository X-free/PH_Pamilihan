//
//  PPSettingViewController.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

@objc(PPSettingViewController)
final class PPSettingViewController: PPBaseViewController {

    private var hostingController: UIHostingController<SettingRootView>?
    private weak var logoutOverlay: UIView?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar = false
        view.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")

        let ver = PB_getAppInfoHelper.pb_to_getMyAppVersionString()
        let root = SettingRootView(
            versionText: ver,
            onBack: { [weak self] in self?.handleBack() },
            onExit: { [weak self] in self?.showLogoutOverlay() },
            onAccountCancellation: { [weak self] in self?.pushAccountCancellation() }
        )
        let hosting = UIHostingController(rootView: root)
        hosting.view.backgroundColor = .clear
        hostingController = hosting
        addChild(hosting)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hosting.view)
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        hosting.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 覆盖基类的 `edgesForExtendedLayout = .none`，让顶部背景图贴到页面最上方。
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
    }

    /// 与 `PPBaseViewController.popController` 行为一致，避免 Swift 对 `popController` 的导入名差异
    private func handleBack() {
        if isDismiss {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func pushAccountCancellation() {
        let vc = PPResignViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showLogoutOverlay() {
        guard logoutOverlay == nil else { return }
        let dim = UIView()
        dim.translatesAutoresizingMaskIntoConstraints = false
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        view.addSubview(dim)
        NSLayoutConstraint.activate([
            dim.topAnchor.constraint(equalTo: view.topAnchor),
            dim.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dim.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dim.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let dialogImageView = UIImageView(image: UIImage(named: "noticelogout"))
        dialogImageView.translatesAutoresizingMaskIntoConstraints = false
        dialogImageView.contentMode = .scaleAspectFit
        dialogImageView.isUserInteractionEnabled = true
        dim.addSubview(dialogImageView)
        NSLayoutConstraint.activate([
            dialogImageView.centerXAnchor.constraint(equalTo: dim.centerXAnchor),
            dialogImageView.centerYAnchor.constraint(equalTo: dim.centerYAnchor, constant: -20),
            dialogImageView.leadingAnchor.constraint(greaterThanOrEqualTo: dim.leadingAnchor, constant: 16),
            dialogImageView.trailingAnchor.constraint(lessThanOrEqualTo: dim.trailingAnchor, constant: -16)
        ])

        // 关闭按钮点击区域（左上角）
        let closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeLogoutOverlayTapped), for: .touchUpInside)
        dialogImageView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: dialogImageView.leadingAnchor, constant: 8),
            closeButton.topAnchor.constraint(equalTo: dialogImageView.topAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Logout 按钮点击区域（底部按钮）
        let logoutButton = UIButton(type: .custom)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = .clear
        logoutButton.addTarget(self, action: #selector(confirmLogoutTapped), for: .touchUpInside)
        dialogImageView.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: dialogImageView.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: dialogImageView.trailingAnchor, constant: -30),
            logoutButton.bottomAnchor.constraint(equalTo: dialogImageView.bottomAnchor, constant: -14),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        logoutOverlay = dim
    }

    @objc private func closeLogoutOverlayTapped() {
        removeLogoutOverlay()
    }

    @objc private func confirmLogoutTapped() {
        removeLogoutOverlay()
        requestLogout()
    }

    private func removeLogoutOverlay() {
        logoutOverlay?.removeFromSuperview()
        logoutOverlay = nil
    }

    private func requestLogout() {
        PB_NativeTipsHelper.pb_showLoading(in: view)
        let url = PB_API_LogoutURL() as String
        PB_RequestHelper.pb_instance().pb_getRequest(withUrlStr: url, params: [:], commplete: { _, _ in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                PB_APP_Control.pb_t_toLogoutAntToHomeMyAccount()
            }
        }, failure: { _, _, msg in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                let text = (msg as String?) ?? ""
                if !text.isEmpty {
                    PB_NativeTipsHelper.pb_presentAlert(withMessage: text)
                }
                PB_APP_Control.pb_t_toLogoutAntToHomeMyAccount()
            }
        })
    }
}
