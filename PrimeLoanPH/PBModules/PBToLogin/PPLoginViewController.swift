//
//  PPLoginViewController.swift
//  PrimeLoanPH
//

import UIKit

@objc(PPLoginViewController)
final class PPLoginViewController: PPBaseViewController {

    private var countdownTimer: Timer?
    private var countdownSeconds = 0

    private var reportStartTime = ""
    private var reportEndTime = ""

    /// iOS 18+ QMUITips 使用 maskView 会触发断言崩溃，发码流程改用系统遮罩
    private var nativeLoadOverlay: UIView?
    private var didApplyInitialPhoneFirstResponder = false

    private let topBackgroundView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let backButton = UIButton(type: .system)
    private let navTitleLabel = UILabel()

    private let phoneIconView = UIImageView()
    private let phoneTitleLabel = UILabel()
    private let phoneTextField = UITextField()
    private let phoneSeparator = UIView()

    private let codeIconView = UIImageView()
    private let codeTitleLabel = UILabel()
    private let codeTextField = UITextField()
    private let getCodeButton = UIButton(type: .custom)
    private let codeSeparator = UIView()
    private let getCodeGradient = CAGradientLayer()

    private let loginButton = UIButton(type: .custom)

    private let agreeCheckbox = UIButton(type: .custom)
    private let privacyPrefixLabel = UILabel()
    private let privacyLinkButton = UIButton(type: .system)
    private let privacyRowStack = UIStackView()
    private let privacyOuterStack = UIStackView()

    private let accentOrange = UIColor.pbColorBackHexStr("#FF7A2E")
    private let accentOrangeEnd = UIColor.pbColorBackHexStr("#FFB84D")
    private let placeholderColor = UIColor.pbColorBackHexStr("#B8B8B8")
    private let separatorColor = UIColor.pbColorBackHexStr("#2C2C2C")
    private let inputFieldTextColor = UIColor.pbColorBackHexStr("#3B332C")

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isDismiss = true
        showNavBar = false
        view.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")

        PB_idf_helper.instanceOnly().pb_t_enquryIDFA_ask()

        buildLayout()
        wireActions()
        agreeCheckbox.isSelected = true
        updateCheckboxImages()
        refreshLoginButtonState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didApplyInitialPhoneFirstResponder else { return }
        didApplyInitialPhoneFirstResponder = true
        DispatchQueue.main.async { [weak self] in
            self?.phoneTextField.becomeFirstResponder()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutGradients()
    }

    deinit {
        countdownTimer?.invalidate()
        nativeLoadOverlay?.removeFromSuperview()
    }

    private func showNativeLoading() {
        let run = { [weak self] in
            guard let self else { return }
            self.hideNativeLoading()
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

    private func hideNativeLoading() {
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

    // MARK: - UI

    /// 与 `PB_OrdtopbgHeightToWidthRatio`（ObjC `PPHelper.h`）一致：高/宽 = 400/375
    private enum Ordtopbg {
        static let heightWidthRatio: CGFloat = 400.0 / 375.0
    }

    private func buildLayout() {
        topBackgroundView.image = UIImage(named: "ordtopbg")
        topBackgroundView.contentMode = .scaleAspectFill
        topBackgroundView.clipsToBounds = true
        topBackgroundView.backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalTo: topBackgroundView.widthAnchor, multiplier: Ordtopbg.heightWidthRatio),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48)
        ])

        let navRow = makeNavRow()
        contentStack.addArrangedSubview(navRow)
        contentStack.setCustomSpacing(20, after: navRow)

        let welcome = UILabel()
        welcome.text = "Welcome to Pamilihan Peso"
        welcome.font = .systemFont(ofSize: 22, weight: .bold)
        welcome.textColor = .black
        welcome.numberOfLines = 0
        contentStack.addArrangedSubview(welcome)
        contentStack.setCustomSpacing(28, after: welcome)

        contentStack.addArrangedSubview(makePhoneSection())
        contentStack.setCustomSpacing(24, after: contentStack.arrangedSubviews.last!)

        contentStack.addArrangedSubview(makeCodeSection())
        contentStack.setCustomSpacing(36, after: contentStack.arrangedSubviews.last!)

        configureLoginButton()
        contentStack.addArrangedSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        contentStack.setCustomSpacing(20, after: loginButton)

        configurePrivacyRow()
        privacyOuterStack.axis = .vertical
        privacyOuterStack.alignment = .center
        privacyOuterStack.addArrangedSubview(privacyRowStack)
        contentStack.addArrangedSubview(privacyOuterStack)
    }

    private func makeNavRow() -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        backButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            if let sym = UIImage(systemName: "chevron.left") {
                backButton.setImage(sym.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
            }
        }
        if backButton.image(for: .normal) == nil {
            if let backImg = UIImage(named: "icon_return_white")?.withRenderingMode(.alwaysTemplate) {
                backButton.setImage(backImg, for: .normal)
                backButton.tintColor = .black
            } else {
                backButton.setTitle("‹", for: .normal)
                backButton.setTitleColor(.black, for: .normal)
                backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
            }
        }
        backButton.accessibilityLabel = "Back"

        navTitleLabel.text = "Login"
        navTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        navTitleLabel.textColor = .black
        navTitleLabel.textAlignment = .center
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(backButton)
        row.addSubview(navTitleLabel)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: -4),
            backButton.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            navTitleLabel.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        return row
    }

    private func makePhoneSection() -> UIView {
        let wrap = UIView()
        let header = makeFieldHeader(iconName: "Frameshuj", title: "Phone number", iconView: phoneIconView, titleLabel: phoneTitleLabel)

        phoneTextField.font = .systemFont(ofSize: 16)
        phoneTextField.textColor = inputFieldTextColor
        phoneTextField.keyboardType = .phonePad
        phoneTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter mobile number",
            attributes: [.foregroundColor: placeholderColor]
        )

        let tfRow = UIStackView(arrangedSubviews: [phoneTextField])
        tfRow.axis = .horizontal
        tfRow.spacing = 8
        tfRow.alignment = .center

        phoneSeparator.backgroundColor = separatorColor
        phoneSeparator.translatesAutoresizingMaskIntoConstraints = false
        phoneSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let v = UIStackView(arrangedSubviews: [header, tfRow, phoneSeparator])
        v.axis = .vertical
        v.spacing = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: wrap.topAnchor),
            v.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: wrap.bottomAnchor)
        ])
        return wrap
    }

    private func makeCodeSection() -> UIView {
        let wrap = UIView()
        let header = makeFieldHeader(iconName: "Framedun", title: "Verification code", iconView: codeIconView, titleLabel: codeTitleLabel)

        codeTextField.font = .systemFont(ofSize: 16)
        codeTextField.textColor = inputFieldTextColor
        codeTextField.keyboardType = .numberPad
        codeTextField.attributedPlaceholder = NSAttributedString(
            string: "Verification code",
            attributes: [.foregroundColor: placeholderColor]
        )

        getCodeButton.setTitle("Get code", for: .normal)
        getCodeButton.setTitleColor(.white, for: .normal)
        getCodeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        getCodeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        getCodeButton.translatesAutoresizingMaskIntoConstraints = false
        getCodeButton.widthAnchor.constraint(equalToConstant: 105).isActive = true
        getCodeButton.layer.cornerRadius = 18
        getCodeButton.layer.masksToBounds = true
        getCodeGradient.colors = [accentOrange.cgColor, accentOrangeEnd.cgColor]
        getCodeGradient.startPoint = CGPoint(x: 0, y: 0.5)
        getCodeGradient.endPoint = CGPoint(x: 1, y: 0.5)
        getCodeGradient.cornerRadius = 18
        getCodeButton.layer.insertSublayer(getCodeGradient, at: 0)

        let codeRow = UIStackView(arrangedSubviews: [codeTextField, getCodeButton])
        codeRow.axis = .horizontal
        codeRow.spacing = 12
        codeRow.alignment = .center

        codeSeparator.backgroundColor = separatorColor
        codeSeparator.translatesAutoresizingMaskIntoConstraints = false
        codeSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let v = UIStackView(arrangedSubviews: [header, codeRow, codeSeparator])
        v.axis = .vertical
        v.spacing = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: wrap.topAnchor),
            v.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: wrap.bottomAnchor)
        ])
        return wrap
    }

    private func makeFieldHeader(iconName: String, title: String, iconView: UIImageView, titleLabel: UILabel) -> UIStackView {
        iconView.image = UIImage(named: iconName)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 22).isActive = true

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .black

        let h = UIStackView(arrangedSubviews: [iconView, titleLabel])
        h.axis = .horizontal
        h.spacing = 8
        h.alignment = .center
        return h
    }

    private func configureLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        loginButton.adjustsImageWhenHighlighted = true
        if let bg = Self.resizableLoginRoundengleBackground() {
            loginButton.setBackgroundImage(bg, for: .normal)
            loginButton.setBackgroundImage(bg, for: .disabled)
        } else {
            loginButton.backgroundColor = UIColor.pbColorBackHexStr("#3D2918")
            loginButton.layer.cornerRadius = 26
            loginButton.layer.masksToBounds = true
        }
    }

    /// `Aorder/Roundengle` 拉伸铺满登录按钮，保留四角圆角
    private static func resizableLoginRoundengleBackground() -> UIImage? {
        guard let img = UIImage(named: "Roundengle") else { return nil }
        let sz = img.size
        let insetX = sz.width / 2.0 - 0.5
        let insetY = sz.height / 2.0 - 0.5
        return img.resizableImage(
            withCapInsets: UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX),
            resizingMode: .stretch
        )
    }

    private func configurePrivacyRow() {
        agreeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        agreeCheckbox.adjustsImageWhenHighlighted = false
        updateCheckboxImages()
        agreeCheckbox.widthAnchor.constraint(equalToConstant: 14).isActive = true
        agreeCheckbox.heightAnchor.constraint(equalToConstant: 14).isActive = true

        privacyPrefixLabel.text = "I consent to the "
        privacyPrefixLabel.font = .systemFont(ofSize: 13)
        privacyPrefixLabel.textColor = UIColor.pbColorBackHexStr("#333333")

        let linkTitle = "Privacy Agreement"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: accentOrange,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        privacyLinkButton.setAttributedTitle(NSAttributedString(string: linkTitle, attributes: attrs), for: .normal)

        privacyRowStack.axis = .horizontal
        privacyRowStack.spacing = 6
        privacyRowStack.alignment = .center
        privacyRowStack.distribution = .fill
        privacyRowStack.addArrangedSubview(agreeCheckbox)
        privacyRowStack.addArrangedSubview(privacyPrefixLabel)
        privacyRowStack.addArrangedSubview(privacyLinkButton)
        privacyRowStack.setCustomSpacing(5, after: agreeCheckbox)
    }

    private func layoutGradients() {
        getCodeGradient.frame = getCodeButton.bounds
    }

    private func updateCheckboxImages() {
        let name = agreeCheckbox.isSelected ? "Group00733" : "Group00734"
        agreeCheckbox.setImage(UIImage(named: name), for: .normal)
        agreeCheckbox.setImage(UIImage(named: name), for: .highlighted)
    }

    private func wireActions() {
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        getCodeButton.addTarget(self, action: #selector(onGetCode), for: .touchUpInside)
        let voiceLongPress = UILongPressGestureRecognizer(target: self, action: #selector(onVoiceCodeLongPress(_:)))
        voiceLongPress.minimumPressDuration = 0.45
        getCodeButton.addGestureRecognizer(voiceLongPress)
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        agreeCheckbox.addTarget(self, action: #selector(onAgreeToggle), for: .touchUpInside)
        privacyLinkButton.addTarget(self, action: #selector(onPrivacyLink), for: .touchUpInside)

        phoneTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        codeTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
    }

    // MARK: - Actions

    @objc private func onBack() {
        dismiss(animated: true)
    }

    @objc private func onGetCode() {
        sendCode(url: PB_API_LoginMessageURL())
    }

    /// 长按「Get code」走语音验证码 `off/defines`（与短信共用手机号前置校验）
    @objc private func onVoiceCodeLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        sendCode(url: PB_API_LoginVoiceMessageURL())
    }

    @objc private func onAgreeToggle() {
        agreeCheckbox.isSelected.toggle()
        updateCheckboxImages()
        refreshLoginButtonState()
    }

    @objc private func onPrivacyLink() {
        PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: PB_API_H5PrivacyPolicyURL(), fromVC: self)
    }

    @objc private func onTextChanged(_ field: UITextField) {
        field.text = field.text?.replacingOccurrences(of: " ", with: "")
        refreshLoginButtonState()
    }

    @objc private func onLogin() {
        view.endEditing(true)
        guard agreeCheckbox.isSelected else {
            PB_NativeTipsHelper.pb_presentAlert(withMessage: "please consent to the Privacy Agreement")
            return
        }
        let phone = (phoneTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let code = (codeTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phone.isEmpty else {
            PB_NativeTipsHelper.pb_presentAlert(withMessage: "please enter mobile number")
            return
        }
        guard !code.isEmpty else {
            PB_NativeTipsHelper.pb_presentAlert(withMessage: "please enter verification code")
            return
        }
        PB_APP_Control.pb_t_requestToLogin(withPhone: phone, code: code, targetVC: self) { [weak self] _ in
            self?.reportRiskAfterLogin()
        }
    }

    // MARK: - Network (parity with ObjC)

    private func sendCode(url: String) {
        let trimmed = (phoneTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            PB_NativeTipsHelper.pb_presentAlert(withMessage: "please enter mobile number")
            return
        }
        let params = ["questions": trimmed] as [String: Any]
        showNativeLoading()
        PB_RequestHelper.pb_instance().pb_postRequest(withUrlStr: url, params: params, commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.reloadReportStartTime()
                self.hideNativeLoading()
                if let result = result {
                    if let model = PPSendCodeModel.yy_model(withJSON: result) {
                        let own = model.theoretical?.conclusion?.own ?? 0
                        if own > 0 {
                            self.beginCountdown(seconds: own)
                        } else {
                            self.beginCountdown(seconds: 60)
                        }
                        if let msg = model.concepts, !msg.isEmpty {
                            PB_NativeTipsHelper.pb_presentAlert(withMessage: msg)
                        }
                        self.codeTextField.becomeFirstResponder()
                    }
                }
            }
        }, failure: { [weak self] _, _, errorStr in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideNativeLoading()
                PB_NativeTipsHelper.pb_presentAlert(withMessage: errorStr)
                self.reloadReportStartTime()
            }
        })
    }

    private func reloadReportStartTime() {
        reportStartTime = PB_timeHelper.pb_t_getCurrentStampTimeString()
    }

    private func reportRiskAfterLogin() {
        reportEndTime = PB_timeHelper.pb_t_getCurrentStampTimeString()
        let riskDict: [String: Any] = [
            "speak": "\(reportStartTime)",
            "advantage": "\(reportEndTime)",
            "rejection": "1"
        ]
        PB_APP_Control.instanceOnly().pb_t_toRePortRiskDataToServe(riskDict)
    }

    // MARK: - Countdown

    private func beginCountdown(seconds: Int) {
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownSeconds = seconds
        refreshCodeButtonTitle()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            self?.tickCountdown(timer: t)
        }
        RunLoop.main.add(countdownTimer!, forMode: .common)
        refreshLoginButtonState()
    }

    private func tickCountdown(timer: Timer) {
        countdownSeconds -= 1
        if countdownSeconds > 0 {
            getCodeButton.setTitle("\(countdownSeconds) s", for: .normal)
            getCodeButton.isEnabled = false
            getCodeButton.alpha = 0.6
        } else {
            timer.invalidate()
            countdownTimer = nil
            getCodeButton.setTitle("Get code", for: .normal)
            getCodeButton.isEnabled = true
            getCodeButton.alpha = 1
            refreshLoginButtonState()
        }
    }

    private func refreshCodeButtonTitle() {
        if countdownSeconds > 0 {
            getCodeButton.setTitle("\(countdownSeconds) s", for: .normal)
            getCodeButton.isEnabled = false
            getCodeButton.alpha = 0.6
        } else {
            getCodeButton.setTitle("Get code", for: .normal)
            getCodeButton.isEnabled = true
            getCodeButton.alpha = 1
        }
    }

    private func refreshLoginButtonState() {
//        let ok = agreeCheckbox.isSelected
//            && !(phoneTextField.text ?? "").isEmpty
//            && !(codeTextField.text ?? "").isEmpty
//        loginButton.isEnabled = ok
//        loginButton.alpha = ok ? 1 : 0.45
//        if countdownSeconds > 0 {
//            getCodeButton.isEnabled = false
//            getCodeButton.alpha = 0.6
//        } else {
//            getCodeButton.isEnabled = true
//            getCodeButton.alpha = 1
//        }
    }
}
