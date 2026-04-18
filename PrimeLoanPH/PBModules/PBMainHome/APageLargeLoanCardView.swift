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
    static let mpagecardHorizontalInset: CGFloat = 16
    static let contentInset: CGFloat = 12
    /// `courses` 标题距 mpagecard 顶
    static let coursesTitleTop: CGFloat = 32
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

    private var productId: Int = 0

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
        backgroundImageView.contentMode = .scaleAspectFill
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

        let mainStack = UIStackView(arrangedSubviews: [
            processImageView,
            captionAmountLabel,
            amountLabel,
            metricsRow,
            applyButton
        ])
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
        let ar = APageLargeCardLayout.mpagecardAspectHeight / APageLargeCardLayout.mpagecardAspectWidth
        let titleTop = APageLargeCardLayout.coursesTitleTop

        NSLayoutConstraint.activate([
            surfaceView.topAnchor.constraint(equalTo: topAnchor),
            surfaceView.leadingAnchor.constraint(equalTo: leadingAnchor),
            surfaceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            surfaceView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            bottomAnchor.constraint(equalTo: surfaceView.bottomAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: surfaceView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: surfaceView.leadingAnchor, constant: inset),
            backgroundImageView.trailingAnchor.constraint(equalTo: surfaceView.trailingAnchor, constant: -inset),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: ar),

            coursesTitleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: titleTop),
            coursesTitleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: pad),
            coursesTitleLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -pad),

            mainStack.topAnchor.constraint(equalTo: coursesTitleLabel.bottomAnchor, constant: 18),
            mainStack.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: pad),
            mainStack.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -pad),
            mainStack.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -pad),

            applyButton.heightAnchor.constraint(equalToConstant: APageLayout.ratio(44))
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }

    func configure(model: PBDrawConclusionPayload) {
        productId = model.pivotal ?? 0
        coursesTitleLabel.text = model.courses
        captionAmountLabel.text = model.powerful
        amountLabel.text = model.voice
        termTitleLabel.text = model.questioning
        termValueLabel.text = model.naldic
        rateTitleLabel.text = model.simply
        rateValueLabel.text = model.opposition
        applyButton.setTitle(model.lobbying ?? "", for: .normal)
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
