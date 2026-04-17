//
//  MeViewController.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

private let kNotiLoginSuccess = Notification.Name("PB_NotiLoginThanSuccess")

@objc(MeViewController)
final class MeViewController: PPBaseViewController {

    private let viewModel = MeViewModel()
    private var hostingController: UIHostingController<MeRootView>?

    /// 与 `PPTableViewController` / TabBar 中 `initWithPBTableViewOfGroupStyle:` 保持一致（Swift 默认会生成 `initWithPbTableViewOfGroupStyle:`）
    @objc(initWithPBTableViewOfGroupStyle:)
    convenience init(pbTableViewOfGroupStyle: Bool) {
        self.init(nibName: nil, bundle: nil)
    }

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

        let root = MeRootView(
            viewModel: viewModel,
            onStatTap: { [weak self] index in
                guard let self else { return }
                self.viewModel.openOrderSegment(index, host: self)
            },
            onRowTap: { [weak self] row in
                guard let self else { return }
                self.viewModel.openMenuLink(row, host: self)
            },
            onRefreshAsync: { [weak self] in
                guard let self else { return }
                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    self.viewModel.load(host: self, showBlockingLoading: false) {
                        continuation.resume()
                    }
                }
            }
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

        viewModel.load(host: self, showBlockingLoading: true, completion: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSuccess), name: kNotiLoginSuccess, object: nil)
    }

    @objc private func onLoginSuccess() {
        viewModel.load(host: self, showBlockingLoading: false, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasAppearedOnce {
            viewModel.load(host: self, showBlockingLoading: false, completion: nil)
        }
        hasAppearedOnce = true
    }

    private var hasAppearedOnce = false

    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotiLoginSuccess, object: nil)
    }
}
