//
//  APageHomeHeaderView.swift
//  PrimeLoanPH
//
//  首页表头：设计稿 Assets/APage（mpagetopbg、Group2119900432、erji、Framebnoitce、券 Banner、监管卡等）
//

import UIKit

private enum APageHeroLayout {
    /// Group2119900432 设计稿尺寸（宽 × 高）
    static let designWidth: CGFloat = 278
    static let designHeight: CGFloat = 59
}

final class APageHomeHeaderView: UIView {

    var onLoanApply: ((Int) -> Void)?
    var onServiceTap: (() -> Void)?

    private let topBackgroundView = UIImageView()
    /// 大卡 `networks` Logo，叠在 mpagetopbg 上
    private let largeCardIconImageView = UIImageView()
    private let topNavStack = UIStackView()
    private let brandTitleLabel = UILabel()
    private let serviceButton = UIButton(type: .system)
    private let heroImageView = UIImageView()
    private let findingCarouselView = APageFindingCarouselView()
    private let bannerView = UIImageView()
    private let largeLoanCardView = APageLargeLoanCardView()
    private let regulatoryImageView = UIImageView()
    private let bannerCardStack = UIStackView()

    private var bannerHeightConstraint: NSLayoutConstraint?
    private var topBackgroundHeightConstraint: NSLayoutConstraint?
    private var shapes: PBShapesPayload?
    private var bannerLink: String?
    private var bannerExpectsRemoteImage = false
    /// 与大卡 `pivotal` 一致，券图 / 监管卡点击走同一进件逻辑
    private var largeCardProductId: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor.pbColorBackHexStr("#FBF6E7")

        topBackgroundView.image = UIImage(named: APageAsset.topBackground)
        // mpagetopbg：等比缩放填充容器，不拉伸变形；留白处见背景色 #FBF6E7
        topBackgroundView.contentMode = .scaleAspectFill
        topBackgroundView.clipsToBounds = true
        topBackgroundView.backgroundColor = .clear

        brandTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        brandTitleLabel.textColor = UIColor.pbColorBackHexStr("#26252A")
        brandTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        largeCardIconImageView.contentMode = .scaleAspectFit
        largeCardIconImageView.layer.cornerRadius = 6
        largeCardIconImageView.clipsToBounds = true
        largeCardIconImageView.isHidden = true

        topNavStack.axis = .horizontal
        topNavStack.spacing = 8
        topNavStack.alignment = .center
        topNavStack.addArrangedSubview(largeCardIconImageView)
        topNavStack.addArrangedSubview(brandTitleLabel)

        serviceButton.setImage(UIImage(named: APageAsset.serviceHeadset)?.withRenderingMode(.alwaysOriginal), for: .normal)
        serviceButton.tintColor = UIColor.pbColorBackHexStr("#5C4033")
        serviceButton.addTarget(self, action: #selector(tappedService), for: .touchUpInside)
        serviceButton.accessibilityLabel = "Service"

        heroImageView.image = UIImage(named: APageAsset.heroHeadline)
        heroImageView.contentMode = .scaleAspectFit

        bannerView.contentMode = .scaleAspectFill
        bannerView.clipsToBounds = true
        bannerView.layer.cornerRadius = APageLayout.ratio(22)
        bannerView.isUserInteractionEnabled = true
        bannerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedBannerSameAsLargeCard)))

        regulatoryImageView.image = UIImage(named: APageAsset.regulatoryCard)
        regulatoryImageView.contentMode = .scaleAspectFit
        regulatoryImageView.layer.cornerRadius = 12
        regulatoryImageView.clipsToBounds = true
        regulatoryImageView.backgroundColor = .clear
        regulatoryImageView.isUserInteractionEnabled = true
        regulatoryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRegulatorySameAsLargeCard)))
        if let reg = UIImage(named: APageAsset.regulatoryCard), reg.size.width > 0 {
            regulatoryImageView.heightAnchor.constraint(
                equalTo: regulatoryImageView.widthAnchor,
                multiplier: reg.size.height / reg.size.width
            ).isActive = true
        }

        largeLoanCardView.isHidden = true
        bannerView.isHidden = true
        findingCarouselView.isHidden = true

        largeLoanCardView.onApply = { [weak self] pid in
            self?.onLoanApply?(pid)
        }

        bannerCardStack.axis = .vertical
        bannerCardStack.spacing = 12
        bannerCardStack.alignment = .fill
        bannerCardStack.addArrangedSubview(largeLoanCardView)
        bannerCardStack.addArrangedSubview(findingCarouselView)
        bannerCardStack.addArrangedSubview(bannerView)
        bannerCardStack.addArrangedSubview(regulatoryImageView)

        addSubview(topBackgroundView)
        addSubview(heroImageView)
        addSubview(bannerCardStack)
        addSubview(topNavStack)
        addSubview(serviceButton)

        [topBackgroundView, topNavStack, largeCardIconImageView, brandTitleLabel, serviceButton, heroImageView, findingCarouselView, bannerView, largeLoanCardView, regulatoryImageView, bannerCardStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let heroAspect = APageHeroLayout.designHeight / APageHeroLayout.designWidth

        let topBgH = topBackgroundView.heightAnchor.constraint(equalToConstant: APageLayout.ratio(240))
        topBackgroundHeightConstraint = topBgH

        let findH = findingCarouselView.heightAnchor.constraint(equalToConstant: APageLayout.ratio(36))
        
        NSLayoutConstraint.activate([
            topBgH,
            topBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            serviceButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            serviceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            serviceButton.widthAnchor.constraint(equalToConstant: 44),
            serviceButton.heightAnchor.constraint(equalToConstant: 44),
            serviceButton.centerYAnchor.constraint(equalTo: topNavStack.centerYAnchor),

            
            topNavStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 55),
            topNavStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topNavStack.trailingAnchor.constraint(lessThanOrEqualTo: serviceButton.leadingAnchor, constant: -8),

            largeCardIconImageView.widthAnchor.constraint(equalToConstant: 36),
            largeCardIconImageView.heightAnchor.constraint(equalToConstant: 36),

            heroImageView.topAnchor.constraint(equalTo: topNavStack.bottomAnchor, constant: 10),
            heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            heroImageView.widthAnchor.constraint(equalToConstant: 278),
            heroImageView.heightAnchor.constraint(equalToConstant: 59),

            bannerCardStack.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: APageLayout.ratio(12)),
            bannerCardStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            bannerCardStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            bannerCardStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

        ])

        let bh = bannerView.heightAnchor.constraint(equalToConstant: 0)
        bannerHeightConstraint = bh
        bh.isActive = true
    }

    func configure(
        response: PBReviewsResponse?,
        largeCard: PBDrawConclusionPayload?,
        banner: PBDrawConclusionPayload?
    ) {
        shapes = response?.theoretical?.shapes
        findingCarouselView.setFindingMessages(response?.theoretical?.finding)

        bannerExpectsRemoteImage = false
        if let b = banner, let urlStr = b.examine, !urlStr.isEmpty {
            bannerView.isHidden = false
            bannerHeightConstraint?.constant = APageLayout.ratio(88)
            bannerLink = (b.translated?.isEmpty == false) ? b.translated : nil
            bannerExpectsRemoteImage = true
            bannerView.image = nil
            loadURL(urlStr, into: bannerView)
        } else if UIImage(named: APageAsset.promoCouponFallback) != nil {
            bannerView.isHidden = false
            bannerView.image = UIImage(named: APageAsset.promoCouponFallback)
            bannerHeightConstraint?.constant = APageLayout.ratio(88)
            bannerLink = (banner?.translated?.isEmpty == false) ? banner?.translated : nil
        } else {
            bannerView.isHidden = true
            bannerHeightConstraint?.constant = 0
            bannerLink = nil
            bannerView.image = nil
        }

        // 无接口 `srb`/`src` 时用本地大卡壳（`mpagecard` 底图，见 `PBDrawConclusionPayload.aPageHomeLargeCardShell`）
        let card = largeCard ?? .aPageHomeLargeCardShell
        largeCardProductId = card.pivotal ?? 0
        largeLoanCardView.isHidden = false
        largeLoanCardView.configure(model: card)
        let iconURL = card.networks?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !iconURL.isEmpty {
            largeCardIconImageView.isHidden = false
            loadIconURL(iconURL, into: largeCardIconImageView)
        } else {
            largeCardIconImageView.isHidden = true
            largeCardIconImageView.image = nil
        }
        brandTitleLabel.text = card.courses

        regulatoryImageView.isHidden = UIImage(named: APageAsset.regulatoryCard) == nil

        let fullW = bounds.width > 0 ? bounds.width : (superview?.bounds.width ?? UIScreen.main.bounds.width)
        let heroW = max(0, fullW - 32)
        let heroH = heroW * (APageHeroLayout.designHeight / APageHeroLayout.designWidth)
        let navHeroApprox = safeAreaInsets.top + 52 + heroH + 24
        // mpagetopbg：按资源宽高比铺满宽度时的高度，并与导航+主标语区取较大值，避免裁切过多
        var topBgH = max(APageLayout.ratio(200), navHeroApprox)
        if let img = UIImage(named: APageAsset.topBackground), img.size.width > 0 {
            let naturalH = fullW * (img.size.height / img.size.width)
            topBgH = max(topBgH, naturalH)
        }
        topBackgroundHeightConstraint?.constant = topBgH

        setNeedsLayout()
        layoutIfNeeded()
    }

    func preferredHeight(width: CGFloat) -> CGFloat {
        layoutIfNeeded()
        let size = systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return ceil(size.height)
    }

    /// 券图 Group2119900452（及远程 Banner）：点击与大卡「进件」一致
    @objc private func tappedBannerSameAsLargeCard() {
        onLoanApply?(largeCardProductId)
    }

    /// 监管说明 Group2119900448：点击与大卡「进件」一致
    @objc private func tappedRegulatorySameAsLargeCard() {
        onLoanApply?(largeCardProductId)
    }

    @objc private func tappedService() {
        onServiceTap?()
    }

    func resolvedBannerURL() -> String? {
        if let t = bannerLink, !t.isEmpty { return t }
        if let e = shapes?.experiences, !e.isEmpty { return e }
        return nil
    }

    func resolvedServiceURL() -> String? {
        if let o = shapes?.objectives, !o.isEmpty { return o }
        if let c = shapes?.chapters, !c.isEmpty { return c }
        return nil
    }

    private func loadIconURL(_ string: String, into imageView: UIImageView) {
        guard let url = URL(string: string) else {
            imageView.image = nil
            return
        }
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { imageView?.image = img }
        }.resume()
    }

    private func loadURL(_ string: String, into imageView: UIImageView) {
        guard let url = URL(string: string) else {
            if bannerExpectsRemoteImage {
                imageView.image = UIImage(named: APageAsset.promoCouponFallback)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
            guard let data, let img = UIImage(data: data) else {
                DispatchQueue.main.async {
                    if self?.bannerExpectsRemoteImage == true {
                        imageView?.image = UIImage(named: APageAsset.promoCouponFallback)
                    }
                }
                return
            }
            DispatchQueue.main.async { imageView?.image = img }
        }.resume()
    }
}
