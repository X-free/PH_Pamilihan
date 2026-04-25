//
//  APageLargeLoanCardView.swift
//  PrimeLoanPH
//
//  largeCardModel：mpagecard 左右 16、343:337；文案与流程叠在背景图上，容器 clear
//

import UIKit

private enum APageLargeCardLayout {
    static let mpagecardAspectWidth: CGFloat = 343
    static let mpagecardAspectHeight: CGFloat = 337
    /// `ScardGroup9900486` 与资源一致（@2x 686×586），宽:高 = 343:293
    static let smallCardAspectWidth: CGFloat = 343
    static let smallCardAspectHeight: CGFloat = 293
    static let mpagecardHorizontalInset: CGFloat = 16
    static let contentInset: CGFloat = 12
    /// `courses` 标题距 mpagecard 顶（大卡）
    static let coursesTitleTop: CGFloat = 32
    /// 小卡 `ScardGroup9900486` 上产品名称距底图顶
    static let coursesTitleTopSmall: CGFloat = 32
    /// 小卡 Apply 按钮底距 `ScardGroup9900486` 底
    static let applyButtonBottomInsetSmall: CGFloat = 22
}

enum APageLoanCardSkin {
    /// `reviewed == srb`：大卡 `mpagecard`
    case large
    /// `reviewed == src`：小卡 `ScardGroup9900486`，布局与大卡一致
    case small
}

final class APageLargeLoanCardView: UIView {

    var onApply: ((Int) -> Void)?

    private let surfaceView = UIView()
    private let backgroundImageView = UIImageView()
    private let processImageView = UIImageView()
    /// 对应接口 `courses`，大卡顶部标题
    private let coursesTitleLabel = UILabel()
    private let captionAmountLabel = UILabel()
    private let amountLabel = UILabel()
    private let termTitleLabel = UILabel()
    private let termValueLabel = UILabel()

    private let rateTitleLabel = UILabel()
    private let rateValueLabel = UILabel()

    private let applyButton = UIButton(type: .system)
    /// 整卡点击进件时关闭栈与按钮自身命中，由 `cardTapGesture` 统一响应
    private let mainStack = UIStackView()

    private var productId: Int = 0
    private var backgroundAspectConstraint: NSLayoutConstraint?
    private var coursesTitleTopConstraint: NSLayoutConstraint?
    /// 大卡：主栈底 ≤ 底图底 − contentInset；小卡：主栈底 = 底图底 − `applyButtonBottomInsetSmall`（按钮即栈尾）
    private var mainStackBottomLessConstraint: NSLayoutConstraint?
    private var mainStackBottomSmallEqualConstraint: NSLayoutConstraint?
    /// 与 `setup` 里默认大卡比例一致，仅在 `configure` 切换 `skin` 时更新约束
    private var appliedCardSkin: APageLoanCardSkin = .large
    /// 大卡 / 小卡：整卡区域点击进件（与底部 Apply 文案同一回调）
    private let cardTapGesture = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.09
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 14

        surfaceView.backgroundColor = .clear
        surfaceView.layer.cornerRadius = 12
        surfaceView.clipsToBounds = true
        surfaceView.translatesAutoresizingMaskIntoConstraints = false

        backgroundImageView.image = UIImage(named: APageAsset.cardTopAccent)
        // 小卡底图约束宽高比与 PNG 一致；AspectFit 等比绘制（比例一致时即铺满）
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        processImageView.image = UIImage(named: APageAsset.processSteps)
        processImageView.contentMode = .scaleAspectFit
        processImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        if let p = UIImage(named: APageAsset.processSteps), p.size.width > 0 {
            processImageView.heightAnchor.constraint(equalTo: processImageView.widthAnchor, multiplier: p.size.height / p.size.width).isActive = true
        }

        coursesTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        coursesTitleLabel.textColor = UIColor.pbColorBackHexStr("#26252A")
        coursesTitleLabel.textAlignment = .center
        coursesTitleLabel.numberOfLines = 2
        coursesTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        captionAmountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        captionAmountLabel.textColor = UIColor.pbColorBackHexStr("#8C8C8C")
        captionAmountLabel.textAlignment = .center

        amountLabel.font = .systemFont(ofSize: 36, weight: .bold)
        amountLabel.textColor = UIColor.pbColorBackHexStr("#26252A")
        amountLabel.textAlignment = .center

        [termTitleLabel, rateTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .regular)
            $0.textColor = UIColor.pbColorBackHexStr("#8C8C8C")
        }
        [termValueLabel, rateValueLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .semibold)
            $0.textColor = UIColor.pbColorBackHexStr("#3B332C")
        }

        applyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = APageLayout.ratio(22)
        applyButton.clipsToBounds = true
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
        applyButton.addTarget(self, action: #selector(tapApply), for: .touchUpInside)

        cardTapGesture.addTarget(self, action: #selector(tapApply))
        cardTapGesture.isEnabled = false
        cardTapGesture.cancelsTouchesInView = false

        let termStack = UIStackView(arrangedSubviews: [termTitleLabel, termValueLabel])
        termStack.axis = .horizontal
        termStack.spacing = 6
        termStack.alignment = .center

        let rateStack = UIStackView(arrangedSubviews: [rateTitleLabel, rateValueLabel])
        rateStack.axis = .horizontal
        rateStack.spacing = 6
        rateStack.alignment = .center

        let metricsRow = UIStackView(arrangedSubviews: [termStack, rateStack])
        metricsRow.axis = .horizontal
        metricsRow.spacing = 16
        metricsRow.distribution = .fillEqually

        [
            processImageView,
            captionAmountLabel,
            amountLabel,
            metricsRow,
            applyButton
        ].forEach { mainStack.addArrangedSubview($0) }
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.backgroundColor = .clear
        mainStack.isUserInteractionEnabled = true

        mainStack.setCustomSpacing(22, after: processImageView)
        
        addSubview(surfaceView)
        surfaceView.addSubview(backgroundImageView)
        surfaceView.addSubview(mainStack)
        surfaceView.addSubview(coursesTitleLabel)

        let inset = APageLargeCardLayout.mpagecardHorizontalInset
        let pad = APageLargeCardLayout.contentInset
        let arLarge = APageLargeCardLayout.mpagecardAspectHeight / APageLargeCardLayout.mpagecardAspectWidth
        let titleTop = APageLargeCardLayout.coursesTitleTop

        let aspect = backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: arLarge)
        aspect.priority = .required
        backgroundAspectConstraint = aspect

        // 主内容区：大卡底边不超过底图；小卡栈底对齐底图（按钮距底 22）
        let mainStackBottomLo = mainStack.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -pad)
        mainStackBottomLessConstraint = mainStackBottomLo
        let mainStackBottomSmallEq = mainStack.bottomAnchor.constraint(
            equalTo: backgroundImageView.bottomAnchor,
            constant: -APageLargeCardLayout.applyButtonBottomInsetSmall
        )
        mainStackBottomSmallEqualConstraint = mainStackBottomSmallEq
        mainStackBottomSmallEq.isActive = false

        let titleTopC = coursesTitleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: titleTop)
        coursesTitleTopConstraint = titleTopC

        NSLayoutConstraint.activate([
            surfaceView.topAnchor.constraint(equalTo: topAnchor),
            surfaceView.leadingAnchor.constraint(equalTo: leadingAnchor),
            surfaceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            surfaceView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            bottomAnchor.constraint(equalTo: surfaceView.bottomAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: surfaceView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: surfaceView.leadingAnchor, constant: inset),
            backgroundImageView.trailingAnchor.constraint(equalTo: surfaceView.trailingAnchor, constant: -inset),
            aspect,

            titleTopC,
            coursesTitleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: pad),
            coursesTitleLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -pad),

            mainStack.topAnchor.constraint(equalTo: coursesTitleLabel.bottomAnchor, constant: 18),
            mainStack.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: pad),
            mainStack.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -pad),
            mainStackBottomLo,

            applyButton.heightAnchor.constraint(equalToConstant: APageLayout.ratio(44))
        ])

        addGestureRecognizer(cardTapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }

    func configure(model: PBDrawConclusionPayload, skin: APageLoanCardSkin = .large) {
        let bgName: String = {
            switch skin {
            case .large: return APageAsset.cardTopAccent
            case .small: return APageAsset.smallCardBackground
            }
        }()
        backgroundImageView.image = UIImage(named: bgName) ?? UIImage(named: APageAsset.cardTopAccent)
        // 小卡：去掉大卡「流程三图」等大卡专属元素
        processImageView.isHidden = (skin == .small)

        let ar: CGFloat = {
            switch skin {
            case .large:
                return APageLargeCardLayout.mpagecardAspectHeight / APageLargeCardLayout.mpagecardAspectWidth
            case .small:
                return APageLargeCardLayout.smallCardAspectHeight / APageLargeCardLayout.smallCardAspectWidth
            }
        }()
        if appliedCardSkin != skin {
            appliedCardSkin = skin
            backgroundAspectConstraint?.isActive = false
            let next = backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: ar)
            next.priority = .required
            next.isActive = true
            backgroundAspectConstraint = next
        }

        coursesTitleTopConstraint?.constant = (skin == .small) ? APageLargeCardLayout.coursesTitleTopSmall : APageLargeCardLayout.coursesTitleTop
        if skin == .small {
            mainStackBottomLessConstraint?.isActive = false
            mainStackBottomSmallEqualConstraint?.isActive = true
        } else {
            mainStackBottomSmallEqualConstraint?.isActive = false
            mainStackBottomLessConstraint?.isActive = true
        }
        amountLabel.font = (skin == .small) ? .systemFont(ofSize: 45, weight: .bold) : .systemFont(ofSize: 36, weight: .bold)

        productId = model.pivotal ?? 0
        coursesTitleLabel.text = Self.linePlaceholderIfEmpty(model.courses)
        captionAmountLabel.text = Self.linePlaceholderIfEmpty(model.powerful)
        amountLabel.text = Self.linePlaceholderIfEmpty(model.voice)
        termTitleLabel.text = Self.linePlaceholderIfEmpty(model.questioning)
        termValueLabel.text = Self.linePlaceholderIfEmpty(model.naldic)
        rateTitleLabel.text = Self.linePlaceholderIfEmpty(model.simply)
        rateValueLabel.text = Self.linePlaceholderIfEmpty(model.opposition)
        let lobby = (model.lobbying ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        applyButton.setTitle(lobby.isEmpty ? "\u{00A0}" : lobby, for: .normal)

        let isSmallHero = (skin == .small)
        // 大卡、小卡均整卡可点，避免仅按钮一条热区
        applyButton.isUserInteractionEnabled = false
        mainStack.isUserInteractionEnabled = false
        cardTapGesture.isEnabled = true
    }

    /// 空文案时用不换行空格占位，避免标签行高塌缩
    private static func linePlaceholderIfEmpty(_ s: String?) -> String {
        let t = (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? "\u{00A0}" : t
    }

    @objc private func tapApply() {
        onApply?(productId)
    }

    private func loadURL(_ string: String?, into imageView: UIImageView) {
        guard let s = string?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty, let url = URL(string: s) else {
            imageView.image = nil
            return
        }
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { imageView?.image = img }
        }.resume()
    }
}
