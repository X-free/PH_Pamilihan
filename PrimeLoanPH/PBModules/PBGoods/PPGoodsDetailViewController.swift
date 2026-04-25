//
//  PPGoodsDetailViewController.swift
//  PrimeLoanPH
//

import SwiftUI
import UIKit

final class GoodsDetailViewState: ObservableObject {
    @Published var productTitle: String = ""
    /// 原固定文案「Maximum loan amount」，对应接口 `addressed.aiming`
    @Published var amountCaptionText: String = ""
    @Published var amountText: String = ""
    /// 左列标题：`rich.can.age`；数值：`rich.can.view`
    @Published var loanTermTitle: String = ""
    @Published var loanTermValue: String = ""
    /// 右列标题：`rich.subtractive.age`；数值：`rich.subtractive.view`
    @Published var interestRateTitle: String = ""
    @Published var interestRateValue: String = ""
    @Published var logoURLs: [String] = []
    @Published var steps: [PPDetailValuingModel] = []
    @Published var showAgreement: Bool = false
    @Published var agreementChecked: Bool = true
    @Published var applyTitle: String = ""

    var applyEnabled: Bool {
        !showAgreement || agreementChecked
    }
}

@objc(PPGoodsDetailViewController)
final class PPGoodsDetailViewController: PPBaseViewController {

    @objc var goodsId: String = ""

    private let state = GoodsDetailViewState()
    private var dataModel: PPDetailModel?
    private var nextStep: String = ""
    private var orderNo: String = ""
    private var didAppearOnce = false
    private var hostingController: UIHostingController<GoodsDetailRootView>?

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

        
        showNavBar = true
        showBackBtn = true
        navTitle = ""

        let pageBg = UIColor.pbColorBackHexStr("#FBF6E7")
        view.backgroundColor = pageBg
        navigationController?.view.backgroundColor = pageBg

        let root = GoodsDetailRootView(
            state: state,
            onStepTap: { [weak self] idx in self?.handleStepTap(index: idx) },
            onAgreementTap: { [weak self] in self?.openAgreement() },
            onAgreementToggle: { [weak self] in
                guard let self else { return }
                self.state.agreementChecked.toggle()
            },
            onApplyTap: { [weak self] in self?.handleApply() }
        )

        let host = UIHostingController(rootView: root)
        host.view.backgroundColor = .clear
        host.view.clipsToBounds = true
        hostingController = host
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: pb_navigationBarContainerView.bottomAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        host.didMove(toParent: self)
        pp_bringCustomNavigationBarToFront()

        requestDetail(showLoading: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if didAppearOnce {
            requestDetail(showLoading: true)
        }
        didAppearOnce = true
    }

    private func requestDetail(showLoading: Bool) {
        if showLoading, let content = hostingController?.view {
            PB_NativeTipsHelper.pb_showLoading(in: content)
        }

        let params: [String: Any] = [
            "foundation": goodsId
        ]
        let url = PB_API_ProductDetailInfoURL() as String
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: url, params: params, commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                self?.pp_bringCustomNavigationBarToFront()
                guard let self else { return }
                guard let result else { return }
                if let model = PPDetailModel.yy_model(withJSON: result) {
                    self.applyDetailModel(model)
                }
            }
        }, failure: { [weak self] _, _, msg in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                self?.pp_bringCustomNavigationBarToFront()
                let text = (msg as String?) ?? ""
                if !text.isEmpty {
                    PB_NativeTipsHelper.pb_presentAlert(withMessage: text)
                }
            }
        })
    }

    private func applyDetailModel(_ model: PPDetailModel) {
        dataModel = model
        let addressed = model.theoretical.addressed
        let rich = addressed?.rich

        let coursesTitle = (addressed?.courses ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.productTitle = coursesTitle
        navTitle = coursesTitle

        let aiming = (addressed?.aiming ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.amountCaptionText = aiming
        let unit = (addressed?.trend ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let issue = (addressed?.issue ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.amountText = unit + issue

        state.loanTermTitle = (rich?.can?.age ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.loanTermValue = (rich?.can?.view ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.interestRateTitle = (rich?.subtractive?.age ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        state.interestRateValue = (rich?.subtractive?.view ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        state.steps = (model.theoretical.valuing as? [PPDetailValuingModel]) ?? []
        state.applyTitle = (addressed?.lobbying?.isEmpty == false) ? (addressed?.lobbying ?? "") : ""

        let agreementURL = model.theoretical.ethnic?.funds ?? ""
        state.showAgreement = !agreementURL.isEmpty
        state.agreementChecked = true

        if let logos = addressed?.currently as? [String] {
            state.logoURLs = logos.filter { !$0.isEmpty }
        } else {
            state.logoURLs = []
        }

        nextStep = model.theoretical.grant?.availability ?? ""
        orderNo = addressed?.enough ?? ""
    }

    private func openAgreement() {
        guard let url = dataModel?.theoretical.ethnic?.funds, !url.isEmpty else { return }
        PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: url, fromVC: self)
    }

    private func handleStepTap(index: Int) {
        guard index >= 0 && index < state.steps.count else { return }
        let model = state.steps[index]
        if model.acknowledges != 1 {
            handleApply()
            return
        }

        if model.availability == "ste" {
            let link = model.translated ?? ""
            if link.isEmpty {
                handleApply()
            } else {
                PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: self)
            }
            return
        }

        toAuthVC(stepId: model.availability ?? "")
    }

    private func toAuthVC(stepId: String) {
        guard !stepId.isEmpty else { return }
        let productId = dataModel?.theoretical.addressed?.pivotal ?? ""
        let oId = dataModel?.theoretical.addressed?.enough ?? ""
        PB_APP_Control.pb_t_toCertifyStepIndex(withProductId: productId, oId: oId, stepStr: stepId, fromVC: self)
    }

    private func handleApply() {
        guard state.applyEnabled else { return }
        guard let model = dataModel else { return }

        let steps = (model.theoretical.valuing as? [PPDetailValuingModel]) ?? []
        guard !steps.isEmpty else { return }

        let hasAllComplete = !steps.contains { $0.acknowledges == 0 }
        if hasAllComplete {
//            let alert = UIAlertController(title: "Notice", message: "Are you sure you want to apply now?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { [weak self] _ in
//                self?.requestToBorrow()
//            }))
//            present(alert, animated: true)
            
            requestToBorrow()
            return
        }

        guard !nextStep.isEmpty else { return }
        if nextStep == "ste" {
            let link = dataModel?.theoretical.grant?.translated ?? ""
            if !link.isEmpty {
                PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: self)
            }
        } else {
            toAuthVC(stepId: nextStep)
        }
    }

    private func requestToBorrow() {
        if let content = hostingController?.view {
            PB_NativeTipsHelper.pb_showLoading(in: content)
        }

        let params: [String: Any] = [
            "aged": dataModel?.theoretical.addressed?.enough ?? "",
            "issue": dataModel?.theoretical.addressed?.issue ?? "",
            "narratives": dataModel?.theoretical.addressed?.narratives ?? "",
            "drury": dataModel?.theoretical.addressed?.drury ?? ""
        ]

        let url = PB_API_MyOrderListItemLinkURL() as String
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: url, params: params, commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                self?.pp_bringCustomNavigationBarToFront()
                guard let self else { return }
                if let theoretical = result?["theoretical"] as? [String: Any],
                   let link = theoretical["translated"] as? String,
                   !link.isEmpty {
                    self.reportRiskFromStep()
                    
                    self.navigationController?.popViewController(animated: false)

                    if let tvc = PB_GetVC.pb_to_getCurrentViewController() as? PPBaseViewController {
                        PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: tvc)

                    }

                }
            }
        }, failure: { [weak self] _, _, msg in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                self?.pp_bringCustomNavigationBarToFront()
                let text = (msg as String?) ?? ""
                if !text.isEmpty {
                    PB_NativeTipsHelper.pb_presentAlert(withMessage: text)
                }
            }
        })
    }

    private func reportRiskFromStep() {
        let order = dataModel?.theoretical.addressed?.enough ?? orderNo
        let stamp = PB_timeHelper.pb_t_getCurrentStampTimeString()
        let risk: [String: Any] = [
            "speak": stamp,
            "advantage": stamp,
            "rejection": "9",
            "constraining": order
        ]
        PB_APP_Control.instanceOnly().pb_t_toRePortRiskDataToServe(risk)
    }
}
