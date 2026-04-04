//
//  APageFindingCarouselView.swift
//  PrimeLoanPH
//
//  theoretical.finding 公告条：单条静态展示，多条定时自动轮播（淡入淡出）
//

import UIKit

final class APageFindingCarouselView: UIView {

    /// 轮播间隔（秒），仅多条时生效
    var autoScrollInterval: TimeInterval = 2.0

    /// 切换动画时长
    var transitionDuration: TimeInterval = 0.35

    private let clipView = UIView()
    private let pillStack = UIStackView()
    private let iconView = UIImageView()
    private let textLabel = UILabel()

    private var messages: [String] = []
    private var currentIndex = 0
    private var autoTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        stopAutoPlay()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            resumeAutoPlayIfNeeded()
        } else {
            stopAutoPlay()
        }
    }

    private func setup() {
        clipsToBounds = true

        clipView.backgroundColor = .clear
        clipView.clipsToBounds = true
        clipView.translatesAutoresizingMaskIntoConstraints = false

        if let img = UIImage(named: APageAsset.noticeSpeaker) {
            iconView.image = img.withRenderingMode(.alwaysTemplate)
        }
        iconView.tintColor = UIColor.pbColorBackHexStr("#6B4A2A")
        iconView.contentMode = .scaleAspectFit

        textLabel.font = .systemFont(ofSize: 11, weight: .medium)
        textLabel.textColor = UIColor.pbColorBackHexStr("#4A4A4A")
        textLabel.numberOfLines = 1
        textLabel.lineBreakMode = .byTruncatingTail

        pillStack.axis = .horizontal
        pillStack.spacing = 6
        pillStack.alignment = .center
        pillStack.isLayoutMarginsRelativeArrangement = true
        pillStack.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 12)
        pillStack.backgroundColor = .white
        pillStack.layer.cornerRadius = APageLayout.ratio(16)
        pillStack.layer.borderWidth = 1
        pillStack.layer.borderColor = UIColor.pbColorBackHexStr("#E8E8E8").cgColor
        pillStack.layer.masksToBounds = true
        pillStack.addArrangedSubview(iconView)
        pillStack.addArrangedSubview(textLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16)
        ])

        addSubview(clipView)
        clipView.addSubview(pillStack)
        pillStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            clipView.topAnchor.constraint(equalTo: topAnchor),
            clipView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clipView.trailingAnchor.constraint(equalTo: trailingAnchor),
            clipView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pillStack.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
            pillStack.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
            pillStack.topAnchor.constraint(equalTo: clipView.topAnchor),
            pillStack.bottomAnchor.constraint(equalTo: clipView.bottomAnchor)
        ])
    }

    /// 绑定接口 `finding` 字符串数组
    func setFindingMessages(_ raw: [String]?) {
        stopAutoPlay()
        let trimmed = (raw ?? []).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        messages = trimmed
        currentIndex = 0

        guard !trimmed.isEmpty else {
            isHidden = true
            textLabel.text = nil
            return
        }

        isHidden = false
        applyCurrentText(animated: false)
        if trimmed.count > 1 {
            startAutoPlay()
        }
    }

    private func applyCurrentText(animated: Bool) {
        let text = messages[currentIndex]
        guard animated else {
            textLabel.text = text
            return
        }
        UIView.transition(
            with: pillStack,
            duration: transitionDuration,
            options: .transitionCrossDissolve,
            animations: { self.textLabel.text = text }
        )
    }

    private func advanceToNext() {
        guard messages.count > 1 else { return }
        currentIndex = (currentIndex + 1) % messages.count
        applyCurrentText(animated: true)
    }

    private func startAutoPlay() {
        stopAutoPlay()
        guard messages.count > 1, window != nil else { return }
        let interval = max(1.5, autoScrollInterval)
        let t = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.advanceToNext()
        }
        RunLoop.main.add(t, forMode: .common)
        autoTimer = t
    }

    private func stopAutoPlay() {
        autoTimer?.invalidate()
        autoTimer = nil
    }

    private func resumeAutoPlayIfNeeded() {
        guard messages.count > 1, autoTimer == nil else { return }
        startAutoPlay()
    }
}
