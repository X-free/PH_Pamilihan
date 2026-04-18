//
//  CertifyNorForms.swift
//  PrimeLoanPH
//

import Combine
import SwiftUI
import UIKit
// BRPickerView is an Obj-C CocoaPod: use PB_BR helpers and types via PrimeLoanPH-Bridging-Header.h — do not `import BRPickerView` (no Swift module).

// MARK: - Layout (aligned with PPBaseViewController nav)

private enum CertifyNorLayout {
    static var navigationChromeHeight: CGFloat {
        let sh = UIScreen.main.bounds.height
        return (sh >= 812 ? 44 : 20) + 64
    }
}

/// `Roundedrectangle` 切图九宫拉伸，与 `PPVeCardsViewController` Next 一致。
private func certifyNorNextButtonBackgroundImage() -> UIImage? {
    guard let raw = UIImage(named: "Roundedrectangle") else { return nil }
    let w = raw.size.width
    let h = raw.size.height
    guard w > 2, h > 2 else { return raw }
    let capX = floor(w / 2) - 1
    let capY = floor(h / 2) - 1
    return raw.resizableImage(withCapInsets: UIEdgeInsets(top: capY, left: capX, bottom: capY, right: capX), resizingMode: .stretch)
}

// MARK: - Kind / configuration

enum CertifyNorKind {
    case personal
    case work
    case bank

    var navTitle: String {
        switch self {
        case .personal: return "Personal Information"
        case .work: return "Job Information"
        case .bank: return "Bank Card Info"
        }
    }

    var cardBannerTitle: String {
        navTitle
    }

    var fetchURL: String {
        switch self {
        case .personal: return PB_API_V2UserInfoFetchURL()
        case .work: return PB_API_V3JobInfoFetchURL()
        case .bank: return PB_API_V5BankInfoFetchURL()
        }
    }

    var submitURL: String {
        switch self {
        case .personal: return PB_API_V2UserInfoSubmitURL()
        case .work: return PB_API_V3JobInfoSubmitURL()
        case .bank: return PB_API_V5BankSubmitURL()
        }
    }

    /// Maps to legacy `rejection` risk codes (PPVeInfo 5 / Work 6 / Bank 8).
    var riskStepCode: String {
        switch self {
        case .personal: return "5"
        case .work: return "6"
        case .bank: return "8"
        }
    }
}

// MARK: - Rows store (avoid replacing `UIHostingController.rootView` so `ScrollView` keeps offset)

private final class CertifyNorFormRowsStore: ObservableObject {
    var rows: [PPVeNorInfoMceachronModel] = []

    func replaceAll(_ r: [PPVeNorInfoMceachronModel]) {
        rows = r
        objectWillChange.send()
    }

    /// NSObject element mutations do not trigger `ObservableObject`; call after picker / text edits.
    func notify() {
        objectWillChange.send()
    }
}

// MARK: - SwiftUI

private struct CertifyNorFormSwiftUIView: View {

    let cream = Color(UIColor.pbColorBackHexStr("#FBF6E7"))
    /// Fig.2 card orange strip (`#F3814C`).
    let bannerOrange = Color(UIColor.pbColorBackHexStr("#F3814C"))

    /// Right inset of orange bar vs white card — background shows in this band (Fig.2).
    private var bannerRightGap: CGFloat { PB_RatioSwift(52) }
    /// Outer white card radius (Fig.2 ~12).
    private var cardCornerRadius: CGFloat { PB_RatioSwift(12) }
    /// Orange bar top-left & top-right radius (Fig.2 tab strip).
    private var orangeBarCornerRadius: CGFloat { PB_RatioSwift(12) }

    /// Row titles, field text, and filled selection captions.
    private var listContentGreen: Color { Color(UIColor.pbColorBackHexStr("#16360F")) }

    @ObservedObject var rowsStore: CertifyNorFormRowsStore

    let bannerTitle: String
    let onTapRow: (Int) -> Void
    let onTextCommit: (Int, String) -> Void

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    cardBlock
                        .padding(.horizontal, PB_RatioSwift(14))
                        .padding(.top, PB_RatioSwift(12))

                    Spacer(minLength: PB_RatioSwift(96))
                }
                .padding(.bottom, geo.safeAreaInsets.bottom + PB_RatioSwift(24))
            }
            .background(cream.ignoresSafeArea())
        }
    }

    private var cardBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            orangeBannerHeader

            VStack(alignment: .leading, spacing: PB_RatioSwift(10)) {
                Text("Please rest assured that our system has 3 layers of protection and your information is very safe.")
                    .font(.system(size: PB_RatioSwift(12)))
                    .foregroundColor(bannerOrange)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, PB_RatioSwift(14))
                    .padding(.horizontal, PB_RatioSwift(12))

                VStack(alignment: .leading, spacing: PB_RatioSwift(10)) {
                    ForEach(Array(rowsStore.rows.enumerated()), id: \.offset) { idx, model in
                        rowView(index: idx, model: model)
                    }
                }
                .padding(.horizontal, PB_RatioSwift(12))
            }
            .padding(.bottom, PB_RatioSwift(14))
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    /// Fig.2: rectangular orange strip, **top-left + top-right** rounded, **52pt** clear band on the right (no circle cutout); title **leading**.
    private var orangeBannerHeader: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let gap = bannerRightGap
            let orangeWidth = max(0, w - gap)

            ZStack(alignment: .leading) {
                Color.white

                RoundedCorner(radius: orangeBarCornerRadius, corners: [.topLeft, .topRight])
                    .fill(bannerOrange)
                    .frame(width: orangeWidth, height: h)

                Text(bannerTitle)
                    .font(.system(size: PB_RatioSwift(17), weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.85)
                    .lineLimit(2)
                    .padding(.leading, PB_RatioSwift(16))
                    .padding(.trailing, PB_RatioSwift(12))
                    .frame(width: orangeWidth, height: h, alignment: .leading)
            }
        }
        .frame(height: PB_RatioSwift(48))
    }

    private func rowView(index idx: Int, model: PPVeNorInfoMceachronModel) -> some View {
        let kind = (model.blair ?? "") as String
        let title = (model.age ?? "") as String
        let rawStem = (model.stemming ?? "") as String

        /// `sea` 单选：`stemming` 与某项 `reviewed`（字符串相等）一致时显示 `celebrating`，否则显示 `stemming` 原文。
        let echoed: String = {
            if kind == "sea" { return seaEchoDisplay(for: model) }
            return rawStem
        }()
        let captionForRow: String = {
            if kind == "sea" {
                if !echoed.isEmpty { return echoed }
                return fieldCaption(kind: kind, display: "", importance: model.importance)
            }
            return fieldCaption(kind: kind, display: rawStem, importance: model.importance)
        }()
        let captionLooksEmpty: Bool = {
            if kind == "sea" { return echoed.isEmpty }
            return rawStem.isEmpty
        }()

        return VStack(alignment: .leading, spacing: PB_RatioSwift(6)) {
            Text(title.isEmpty ? " " : title)
                .font(.system(size: PB_RatioSwift(14), weight: .semibold))
                .foregroundColor(listContentGreen)

            if kind == "seb" {
                TextField(
                    textFieldPlaceholder(for: model),
                    text: Binding(
                        get: { model.stemming ?? "" },
                        set: { newVal in
                            model.stemming = newVal
                            onTextCommit(idx, newVal)
                        }
                    )
                )
                .font(.system(size: PB_RatioSwift(15)))
                .foregroundColor(listContentGreen)
                .keyboardType(model.underachieving == 1 ? .numberPad : .default)
                .padding(.horizontal, PB_RatioSwift(14))
                .padding(.vertical, PB_RatioSwift(12))
                .background(Color(UIColor.pbColorBackHexStr("#F3F3F3")))
                .clipShape(RoundedRectangle(cornerRadius: PB_RatioSwift(10), style: .continuous))
            } else {
                Button {
                    onTapRow(idx)
                } label: {
                    HStack {
                        Text(captionForRow)
                            .font(.system(size: PB_RatioSwift(15)))
                            .foregroundColor(captionLooksEmpty ? Color(UIColor.pbColorBackHexStr("#8C8C8C")) : listContentGreen)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.down")
                            .font(.system(size: PB_RatioSwift(13), weight: .semibold))
                            .foregroundColor(Color(UIColor.pbColorBackHexStr("#8C8C8C")))
                    }
                    .padding(.horizontal, PB_RatioSwift(14))
                    .padding(.vertical, PB_RatioSwift(12))
                    .background(Color(UIColor.pbColorBackHexStr("#F3F3F3")))
                    .clipShape(RoundedRectangle(cornerRadius: PB_RatioSwift(10), style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func textFieldPlaceholder(for model: PPVeNorInfoMceachronModel) -> String {
        let imp = (model.importance ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !imp.isEmpty { return imp }
        let hi = (model.highly ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !hi.isEmpty { return hi }
        return "Please enter"
    }

    private func seaEchoDisplay(for model: PPVeNorInfoMceachronModel) -> String {
        let stem = (model.stemming ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if stem.isEmpty { return "" }
        guard let opts = model.identified else { return stem }
        for opt in opts {
            let reviewedKey = String(opt.reviewed)
            if stem == reviewedKey {
                let cel = (opt.celebrating ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                return cel.isEmpty ? stem : cel
            }
        }
        return stem
    }

    private func fieldCaption(kind: String, display: String, importance: String?) -> String {
        if !display.isEmpty { return display }
        let imp = (importance ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !imp.isEmpty { return imp }
        if kind == "sec" { return "" }
        return "Please select"
    }
}

/// Local PB_Ratio for SwiftUI `CGFloat` (matches `PB_Ratio` macro intent).
private func PB_RatioSwift(_ x: Double) -> CGFloat {
    CGFloat(x * (UIScreen.main.bounds.width / 375.0))
}

/// Rounded specific corners (iOS 16+ uses `.rect` — keep simple full card clip on banner already).
private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Shell controller (shared logic)

class CertifyNorFormShellController: PPBaseViewController {

    private let kind: CertifyNorKind
    private var hosting: UIHostingController<CertifyNorFormSwiftUIView>?
    private let rowsStore = CertifyNorFormRowsStore()
    private var submitParams = NSMutableDictionary()
    private var addressSelectIndexes: [NSNumber] = [
        NSNumber(value: 0), NSNumber(value: 0), NSNumber(value: 0)
    ]
    private var currentKeyCode = ""

    /// When a `UITextField` / `UITextView` gains focus while a string or address picker is still on-screen, the picker mask stays in the window and blocks the form (above SwiftUI but under the keyboard).
    private var textInputBeginObserverTokens: [NSObjectProtocol] = []

    private var reportStart = ""
    private var reportEnd = ""

    private lazy var stringPickerView: BRStringPickerView = {
        let raw = PB_BR.pb_to_getCustomStringPickerView()
        let picker = (raw as? BRStringPickerView) ?? BRStringPickerView(pickerMode: .componentSingle)
        picker.isAutoSelect = true
        return picker
    }()

    private lazy var addressPickerView: BRAddressPickerView = {
        let raw = PB_BR.pb_to_getAdressCustomPickerView()
        let picker = (raw as? BRAddressPickerView) ?? BRAddressPickerView(pickerMode: .area)
        picker.isAutoSelect = true
        return picker
    }()

    init(kind: CertifyNorKind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.kind = .personal
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar = true
        showBackBtn = true
        navTitle = kind.navTitle
        // UI: yellow nav (`PP_AppColor` #FFDB3F), black title + dark back icon on yellow.
        navBgColr = UIColor.pbColorBackHexStr("#FFDB3F")
        useDarkNavBackIcon = true
        view.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")

        reportStart = PB_timeHelper.pb_t_getCurrentStampTimeString()
        reportEnd = ""
        submitParams = NSMutableDictionary(dictionary: ["foundation": pId])

        let host = UIHostingController(rootView: makeRootView())
        host.view.backgroundColor = .clear
        hosting = host
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)

        let nextBtn = UIButton(type: .custom)
        nextBtn.setBackgroundImage(certifyNorNextButtonBackgroundImage(), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: PB_RatioSwift(16), weight: .medium)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.addTarget(self, action: #selector(onNextTap), for: .touchUpInside)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextBtn)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor, constant: CertifyNorLayout.navigationChromeHeight),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nextBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -PB_RatioSwift(15)),
            nextBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - PB_RatioSwift(47) * 2),
            nextBtn.heightAnchor.constraint(equalToConstant: PB_RatioSwift(44))
        ])
        host.didMove(toParent: self)

        pb_registerDismissPickersOnTextInputBegin()

        requestList()
    }

    deinit {
        textInputBeginObserverTokens.forEach { NotificationCenter.default.removeObserver($0) }
    }

    /// Removes BRPickerView overlays only when still attached (avoids redundant `dismiss` on never-shown lazy pickers).
    private func pb_dismissOverlayPickersIfPresent() {
        if stringPickerView.superview != nil {
            stringPickerView.dismiss()
        }
        if addressPickerView.superview != nil {
            addressPickerView.dismiss()
        }
    }

    private func pb_registerDismissPickersOnTextInputBegin() {
        let handler: (Notification) -> Void = { [weak self] note in
            guard let self else { return }
            guard let v = note.object as? UIView, v.isDescendant(of: self.view) else { return }
            self.pb_dismissOverlayPickersIfPresent()
        }
        textInputBeginObserverTokens = [
            NotificationCenter.default.addObserver(forName: UITextField.textDidBeginEditingNotification, object: nil, queue: .main, using: handler),
            NotificationCenter.default.addObserver(forName: UITextView.textDidBeginEditingNotification, object: nil, queue: .main, using: handler)
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            pb_dismissOverlayPickersIfPresent()
        }
    }

    private func makeRootView() -> CertifyNorFormSwiftUIView {
        CertifyNorFormSwiftUIView(
            rowsStore: rowsStore,
            bannerTitle: kind.cardBannerTitle,
            onTapRow: { [weak self] idx in self?.handleTapRow(idx) },
            onTextCommit: { [weak self] idx, text in
                self?.commitText(index: idx, text: text)
            }
        )
    }

    private func requestList() {
        PB_NativeTipsHelper.pb_showLoading(in: view)
        let params: [String: Any] = ["foundation": pId]
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: kind.fetchURL, params: params, commplete: { [weak self] result, _ in
            PB_NativeTipsHelper.pb_hideAllLoading()
            guard let self else { return }
            if let result, let model = PPVeNorInfoModel.yy_model(withJSON: result) {
                let arr = model.theoretical?.mceachron as? [PPVeNorInfoMceachronModel] ?? []
                self.rowsStore.replaceAll(arr)
            } else {
                self.rowsStore.replaceAll([])
            }
            self.refreshSubmitParams()
            self.setupPickersIfNeeded()
        }, failure: { _, _, msg in
            PB_NativeTipsHelper.pb_hideAllLoading()
            if let m = msg as String?, !m.isEmpty {
                PB_NativeTipsHelper.pb_presentAlert(withMessage: m)
            }
        })
    }

    private func setupPickersIfNeeded() {
        stringPickerView.resultModelBlock = { [weak self] resultModel in
            guard let self, let resultModel else { return }
            self.applyStringPick(resultModel)
        }
        addressPickerView.resultBlock = { [weak self] province, city, area in
            guard let self else { return }
            self.applyAddressPick(province: province, city: city, area: area)
        }
    }

    private func handleTapRow(_ index: Int) {
        view.endEditing(true)
        pb_dismissOverlayPickersIfPresent()
        guard index >= 0, index < rowsStore.rows.count else { return }
        let model = rowsStore.rows[index]
        currentKeyCode = model.defines ?? ""
        let type = model.blair ?? ""
        if type == "sea" {
            var strings: [String] = []
            let identified = model.identified ?? []
            for opt in identified {
                strings.append(opt.celebrating ?? "")
            }
            let stem = (model.stemming ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            var selectIndex = 0
            if !stem.isEmpty {
                for (j, opt) in identified.enumerated() {
                    let cel = (opt.celebrating ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                    if stem == String(opt.reviewed) || stem == cel {
                        selectIndex = j
                        break
                    }
                }
            } else {
                for (j, opt) in identified.enumerated() where opt.select {
                    selectIndex = j
                    break
                }
            }
            stringPickerView.dataSourceArr = strings.map { $0 as Any }
            stringPickerView.selectIndex = selectIndex
            stringPickerView.title = model.age ?? ""
            stringPickerView.show()
            PB_BR.pb_applyStringPickerOptionTitleUI(stringPickerView)
        } else if type == "sec" {
            addressPickerView.title = model.age ?? ""
            if PB_APP_Control.instanceOnly().adressArray.count == 0 {
                PB_NativeTipsHelper.pb_presentAlert(withMessage: "city adress is on request...")
                PB_APP_Control.pb_t_toRequestAdressDataSuccess(afterCallBack: { [weak self] _ in
                    self?.showAddressPicker()
                })
            } else {
                showAddressPicker()
            }
        }
    }

    private func showAddressPicker() {
        let addrSrc = PB_APP_Control.instanceOnly().adressArray
        addressPickerView.dataSourceArr = (0..<addrSrc.count).map { addrSrc.object(at: $0) as Any }
        addressPickerView.selectIndexs = addressSelectIndexes as [NSNumber]
        addressPickerView.show()
        PB_BR.pb_applyAddressPickerOptionTitleUI(addressPickerView)
    }

    private func applyStringPick(_ resultModel: BRResultModel) {
        for i in 0..<rowsStore.rows.count {
            guard (rowsStore.rows[i].defines ?? "") == currentKeyCode else { continue }
            let m = rowsStore.rows[i]
            let optCount = m.identified?.count ?? 0
            for j in 0..<optCount {
                guard let opt = m.identified?[j] else { continue }
                let picked = (j == resultModel.index)
                opt.select = picked
                if picked {
                    // 存 reviewed 字符串，便于与下发数据一致；列表回显由 seaEchoDisplay 映射为 celebrating
                    rowsStore.rows[i].stemming = String(opt.reviewed)
                    rowsStore.rows[i].choice = opt.reviewed
                }
            }
        }
        refreshSubmitParams()
        rowsStore.notify()
    }

    private func applyAddressPick(province: BRProvinceModel?, city: BRCityModel?, area: BRAreaModel?) {
        var result = ""
        if let province {
            addressSelectIndexes[0] = NSNumber(value: province.index)
            result = province.name ?? ""
        }
        if let city {
            addressSelectIndexes[1] = NSNumber(value: city.index)
            result = result.isEmpty ? (city.name ?? "") : "\(result)|\(city.name ?? "")"
        }
        if let area {
            addressSelectIndexes[2] = NSNumber(value: area.index)
            result = result.isEmpty ? (area.name ?? "") : "\(result)|\(area.name ?? "")"
        }
        for i in 0..<rowsStore.rows.count {
            if (rowsStore.rows[i].defines ?? "") == currentKeyCode {
                rowsStore.rows[i].stemming = result
            }
        }
        refreshSubmitParams()
        rowsStore.notify()
    }

    private func commitText(index: Int, text: String) {
        guard index >= 0, index < rowsStore.rows.count else { return }
        rowsStore.rows[index].stemming = text
        refreshSubmitParams()
        rowsStore.notify()
    }

    private func refreshSubmitParams() {
        for i in 0..<rowsStore.rows.count {
            let model = rowsStore.rows[i]
            let code = model.defines ?? ""
            let type = model.blair ?? ""
            var value = ""
            if type == "sea" {
                let stemTrim = (model.stemming ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if model.choice == 0, !stemTrim.isEmpty {
                    for opt in model.identified ?? [] {
                        let cel = (opt.celebrating ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        if stemTrim == String(opt.reviewed) || stemTrim == cel {
                            model.choice = opt.reviewed
                            break
                        }
                    }
                }
                value = "\(model.choice)"
            } else if type == "seb" || type == "sec" {
                value = model.stemming ?? ""
            }
            if !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                submitParams[code] = value
            } else {
                submitParams.removeObject(forKey: code)
            }
        }
    }

    @objc private func onNextTap() {
        view.endEditing(true)
        switch kind {
        case .personal, .work:
            submitPersonalOrWork()
        case .bank:
            submitBank()
        }
    }

    private func submitPersonalOrWork() {
        PB_NativeTipsHelper.pb_showLoading(in: view)
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: kind.submitURL, params: submitParams as NSDictionary, commplete: { [weak self] result, _ in
            PB_NativeTipsHelper.pb_hideAllLoading()
            guard let self else { return }
            if result != nil {
                self.reportRisk()
                PB_APP_Control.pb_t_toRequestProductDetailThanGoToNextStepOption(withProductID: self.pId, oId: self.oId, fromVC: self, successBlock: { _ in
                    PB_GetVC.pb_to_removeFromNavigation(self)
                })
            }
        }, failure: { _, _, msg in
            PB_NativeTipsHelper.pb_hideAllLoading()
            if let m = msg as String?, !m.isEmpty {
                PB_NativeTipsHelper.pb_presentAlert(withMessage: m)
            }
        })
    }

    private func submitBank() {
        PB_NativeTipsHelper.pb_showLoading(in: view)
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: kind.submitURL, params: submitParams as NSDictionary, commplete: { [weak self] result, _ in
            PB_NativeTipsHelper.pb_hideAllLoading()
            guard let self else { return }
            if result != nil {
                self.reportRisk()
                self.goToProductDetailAfterBank()
            }
        }, failure: { _, _, msg in
            PB_NativeTipsHelper.pb_hideAllLoading()
            if let m = msg as String?, !m.isEmpty {
                PB_NativeTipsHelper.pb_presentAlert(withMessage: m)
            }
        })
    }

    private func goToProductDetailAfterBank() {
        guard let nav = navigationController else { return }
        for vc in nav.viewControllers {
            if vc is PPGoodsDetailViewController {
                nav.popToViewController(vc, animated: true)
                return
            }
        }
        let vc = PPGoodsDetailViewController(pbTableViewOfGroupStyle: false)
        vc.goodsId = pId
        nav.pushViewController(vc, animated: true)
        PB_GetVC.pb_to_removeFromNavigation(self)
    }

    private func reportRisk() {
        reportEnd = PB_timeHelper.pb_t_getCurrentStampTimeString()
        let risk: [String: Any] = [
            "speak": reportStart,
            "advantage": reportEnd,
            "rejection": kind.riskStepCode
        ]
        PB_APP_Control.instanceOnly().pb_t_toRePortRiskDataToServe(risk as [AnyHashable: Any])
    }

    // MARK: - Exposed to ObjC (routing)

    @objc var pId: String = ""
    @objc var oId: String = ""
}

// MARK: - Three entry VCs (ObjC names preserved)

@objc(PPVeInfoViewController)
final class PPVeInfoViewController: CertifyNorFormShellController {
    @objc(initWithPBTableViewOfGroupStyle:)
    convenience init(pbTableViewOfGroupStyle: Bool) {
        self.init(kind: .personal)
    }
}

@objc(PPVeWorkInfoViewController)
final class PPVeWorkInfoViewController: CertifyNorFormShellController {
    @objc(initWithPBTableViewOfGroupStyle:)
    convenience init(pbTableViewOfGroupStyle: Bool) {
        self.init(kind: .work)
    }
}

@objc(PPVeBankViewController)
final class PPVeBankViewController: CertifyNorFormShellController {
    @objc(initWithPBTableViewOfGroupStyle:)
    convenience init(pbTableViewOfGroupStyle: Bool) {
        self.init(kind: .bank)
    }
}
