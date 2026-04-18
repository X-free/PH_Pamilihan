//
//  APageAsset.swift
//  PrimeLoanPH
//
//  Assets.xcassets/APage 设计稿资源名（与 Xcode 中 imageset 一致）
//

import UIKit

enum APageLayout {
    static var scale: CGFloat { UIScreen.main.bounds.width / 375.0 }
    static func ratio(_ x: CGFloat) -> CGFloat { x * scale }
}

enum APageAsset {
    static let topBackground = "mpagetopbg"
    static let serviceHeadset = "erji"
    /// 主标题区：Ultra-high loan limit + Fast / High pass rate / Safety
    static let heroHeadline = "Group2119900432"
    /// 大卡主背景（`APageLargeLoanCardView`）
    static let cardTopAccent = "mpagecard"
    /// 大卡内：Submit — Get Loan — Disburse
    static let processSteps = "Group2119900481"
    /// 主按钮棕色渐变底
    static let primaryButtonBg = "Rect34626999"
    static let noticeSpeaker = "Framebnoitce"
    /// 无运营 Banner URL 时首页默认券图（与接口 `sre` 互斥时走本地）
    static let promoCouponFallback = "Group2119900452"
    /// 监管说明整卡（含文案与四枚 Logo）
    static let regulatoryCard = "Group2119900448"
}
