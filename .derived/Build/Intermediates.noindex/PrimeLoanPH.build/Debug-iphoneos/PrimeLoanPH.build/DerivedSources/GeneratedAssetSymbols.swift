import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "Face recognition" asset catalog image resource.
    static let faceRecognition = ImageResource(name: "Face recognition", bundle: resourceBundle)

    /// The "Framebnoitce" asset catalog image resource.
    static let framebnoitce = ImageResource(name: "Framebnoitce", bundle: resourceBundle)

    /// The "Framedun" asset catalog image resource.
    static let framedun = ImageResource(name: "Framedun", bundle: resourceBundle)

    /// The "Frameshuj" asset catalog image resource.
    static let frameshuj = ImageResource(name: "Frameshuj", bundle: resourceBundle)

    /// The "Group 1171275258" asset catalog image resource.
    static let group1171275258 = ImageResource(name: "Group 1171275258", bundle: resourceBundle)

    /// The "Group 1171275259" asset catalog image resource.
    static let group1171275259 = ImageResource(name: "Group 1171275259", bundle: resourceBundle)

    /// The "Group 1171275260" asset catalog image resource.
    static let group1171275260 = ImageResource(name: "Group 1171275260", bundle: resourceBundle)

    /// The "Group 1171275261" asset catalog image resource.
    static let group1171275261 = ImageResource(name: "Group 1171275261", bundle: resourceBundle)

    /// The "Group 1171275880" asset catalog image resource.
    static let group1171275880 = ImageResource(name: "Group 1171275880", bundle: resourceBundle)

    /// The "Group 1171276120" asset catalog image resource.
    static let group1171276120 = ImageResource(name: "Group 1171276120", bundle: resourceBundle)

    /// The "Group 1171276126" asset catalog image resource.
    static let group1171276126 = ImageResource(name: "Group 1171276126", bundle: resourceBundle)

    /// The "Group 1171276127" asset catalog image resource.
    static let group1171276127 = ImageResource(name: "Group 1171276127", bundle: resourceBundle)

    /// The "Group 1171276128" asset catalog image resource.
    static let group1171276128 = ImageResource(name: "Group 1171276128", bundle: resourceBundle)

    /// The "Group 1171276130" asset catalog image resource.
    static let group1171276130 = ImageResource(name: "Group 1171276130", bundle: resourceBundle)

    /// The "Group 1171276133" asset catalog image resource.
    static let group1171276133 = ImageResource(name: "Group 1171276133", bundle: resourceBundle)

    /// The "Group 1171276136" asset catalog image resource.
    static let group1171276136 = ImageResource(name: "Group 1171276136", bundle: resourceBundle)

    /// The "Group00733" asset catalog image resource.
    static let group00733 = ImageResource(name: "Group00733", bundle: resourceBundle)

    /// The "Group00734" asset catalog image resource.
    static let group00734 = ImageResource(name: "Group00734", bundle: resourceBundle)

    /// The "Group2119900432" asset catalog image resource.
    static let group2119900432 = ImageResource(name: "Group2119900432", bundle: resourceBundle)

    /// The "Group2119900448" asset catalog image resource.
    static let group2119900448 = ImageResource(name: "Group2119900448", bundle: resourceBundle)

    /// The "Group2119900452" asset catalog image resource.
    static let group2119900452 = ImageResource(name: "Group2119900452", bundle: resourceBundle)

    /// The "Group2119900481" asset catalog image resource.
    static let group2119900481 = ImageResource(name: "Group2119900481", bundle: resourceBundle)

    /// The "Mask group" asset catalog image resource.
    static let maskGroup = ImageResource(name: "Mask group", bundle: resourceBundle)

    /// The "PAN" asset catalog image resource.
    static let PAN = ImageResource(name: "PAN", bundle: resourceBundle)

    /// The "PAN_pop_sample_right" asset catalog image resource.
    static let panPopSampleRight = ImageResource(name: "PAN_pop_sample_right", bundle: resourceBundle)

    /// The "PAN_pop_sample_wrong" asset catalog image resource.
    static let panPopSampleWrong = ImageResource(name: "PAN_pop_sample_wrong", bundle: resourceBundle)

    /// The "PRC" asset catalog image resource.
    static let PRC = ImageResource(name: "PRC", bundle: resourceBundle)

    /// The "Rect34626999" asset catalog image resource.
    static let rect34626999 = ImageResource(name: "Rect34626999", bundle: resourceBundle)

    /// The "Rectangle 3641" asset catalog image resource.
    static let rectangle3641 = ImageResource(name: "Rectangle 3641", bundle: resourceBundle)

    /// The "Roundengle" asset catalog image resource.
    static let roundengle = ImageResource(name: "Roundengle", bundle: resourceBundle)

    /// The "Step_1" asset catalog image resource.
    static let step1 = ImageResource(name: "Step_1", bundle: resourceBundle)

    /// The "Step_2" asset catalog image resource.
    static let step2 = ImageResource(name: "Step_2", bundle: resourceBundle)

    /// The "Step_logo_1" asset catalog image resource.
    static let stepLogo1 = ImageResource(name: "Step_logo_1", bundle: resourceBundle)

    /// The "Step_logo_2" asset catalog image resource.
    static let stepLogo2 = ImageResource(name: "Step_logo_2", bundle: resourceBundle)

    /// The "agree" asset catalog image resource.
    static let agree = ImageResource(name: "agree", bundle: resourceBundle)

    /// The "amountUnit" asset catalog image resource.
    static let amountUnit = ImageResource(name: "amountUnit", bundle: resourceBundle)

    /// The "amount_bg" asset catalog image resource.
    static let amountBg = ImageResource(name: "amount_bg", bundle: resourceBundle)

    /// The "arrowMore_bluemvp" asset catalog image resource.
    static let arrowMoreBluemvp = ImageResource(name: "arrowMore_bluemvp", bundle: resourceBundle)

    /// The "auth_cardTip" asset catalog image resource.
    static let authCardTip = ImageResource(name: "auth_cardTip", bundle: resourceBundle)

    /// The "bbbblue" asset catalog image resource.
    static let bbbblue = ImageResource(name: "bbbblue", bundle: resourceBundle)

    /// The "big_1" asset catalog image resource.
    static let big1 = ImageResource(name: "big_1", bundle: resourceBundle)

    /// The "big_2" asset catalog image resource.
    static let big2 = ImageResource(name: "big_2", bundle: resourceBundle)

    /// The "big_3" asset catalog image resource.
    static let big3 = ImageResource(name: "big_3", bundle: resourceBundle)

    /// The "cardNo_pop_sample" asset catalog image resource.
    static let cardNoPopSample = ImageResource(name: "cardNo_pop_sample", bundle: resourceBundle)

    /// The "detail_bg" asset catalog image resource.
    static let detailBg = ImageResource(name: "detail_bg", bundle: resourceBundle)

    /// The "emptyinbox" asset catalog image resource.
    static let emptyinbox = ImageResource(name: "emptyinbox", bundle: resourceBundle)

    /// The "erji" asset catalog image resource.
    static let erji = ImageResource(name: "erji", bundle: resourceBundle)

    /// The "faceBorderHold" asset catalog image resource.
    static let faceBorderHold = ImageResource(name: "faceBorderHold", bundle: resourceBundle)

    /// The "face_pop_sample_right" asset catalog image resource.
    static let facePopSampleRight = ImageResource(name: "face_pop_sample_right", bundle: resourceBundle)

    /// The "face_pop_sample_wrong" asset catalog image resource.
    static let facePopSampleWrong = ImageResource(name: "face_pop_sample_wrong", bundle: resourceBundle)

    /// The "grayGLayer" asset catalog image resource.
    static let grayGLayer = ImageResource(name: "grayGLayer", bundle: resourceBundle)

    /// The "hhh_card" asset catalog image resource.
    static let hhhCard = ImageResource(name: "hhh_card", bundle: resourceBundle)

    /// The "home_big" asset catalog image resource.
    static let homeBig = ImageResource(name: "home_big", bundle: resourceBundle)

    /// The "home_notice" asset catalog image resource.
    static let homeNotice = ImageResource(name: "home_notice", bundle: resourceBundle)

    /// The "home_small_bg" asset catalog image resource.
    static let homeSmallBg = ImageResource(name: "home_small_bg", bundle: resourceBundle)

    /// The "icn_head" asset catalog image resource.
    static let icnHead = ImageResource(name: "icn_head", bundle: resourceBundle)

    /// The "icon_Applying" asset catalog image resource.
    static let iconApplying = ImageResource(name: "icon_Applying", bundle: resourceBundle)

    /// The "icon_Hi" asset catalog image resource.
    static let iconHi = ImageResource(name: "icon_Hi", bundle: resourceBundle)

    /// The "icon_ID" asset catalog image resource.
    static let iconID = ImageResource(name: "icon_ID", bundle: resourceBundle)

    #warning("The \"icon_ID \" image asset name resolves to the symbol \"iconID\" which already exists. Try renaming the asset.")

    /// The "icon_Me_active" asset catalog image resource.
    static let iconMeActive = ImageResource(name: "icon_Me_active", bundle: resourceBundle)

    /// The "icon_Me_default" asset catalog image resource.
    static let iconMeDefault = ImageResource(name: "icon_Me_default", bundle: resourceBundle)

    /// The "icon_Not Repay" asset catalog image resource.
    static let iconNotRepay = ImageResource(name: "icon_Not Repay", bundle: resourceBundle)

    /// The "icon_VOZ" asset catalog image resource.
    static let iconVOZ = ImageResource(name: "icon_VOZ", bundle: resourceBundle)

    /// The "icon_apply" asset catalog image resource.
    static let iconApply = ImageResource(name: "icon_apply", bundle: resourceBundle)

    /// The "icon_bank" asset catalog image resource.
    static let iconBank = ImageResource(name: "icon_bank", bundle: resourceBundle)

    /// The "icon_close_x" asset catalog image resource.
    static let iconCloseX = ImageResource(name: "icon_close_x", bundle: resourceBundle)

    /// The "icon_completed" asset catalog image resource.
    static let iconCompleted = ImageResource(name: "icon_completed", bundle: resourceBundle)

    /// The "icon_completed_order" asset catalog image resource.
    static let iconCompletedOrder = ImageResource(name: "icon_completed_order", bundle: resourceBundle)

    /// The "icon_finished" asset catalog image resource.
    static let iconFinished = ImageResource(name: "icon_finished", bundle: resourceBundle)

    /// The "icon_home_actice" asset catalog image resource.
    static let iconHomeActice = ImageResource(name: "icon_home_actice", bundle: resourceBundle)

    /// The "icon_home_default" asset catalog image resource.
    static let iconHomeDefault = ImageResource(name: "icon_home_default", bundle: resourceBundle)

    /// The "icon_moreDown_gray" asset catalog image resource.
    static let iconMoreDownGray = ImageResource(name: "icon_moreDown_gray", bundle: resourceBundle)

    /// The "icon_moreUp_gray" asset catalog image resource.
    static let iconMoreUpGray = ImageResource(name: "icon_moreUp_gray", bundle: resourceBundle)

    /// The "icon_more_blue" asset catalog image resource.
    static let iconMoreBlue = ImageResource(name: "icon_more_blue", bundle: resourceBundle)

    /// The "icon_more_gray" asset catalog image resource.
    static let iconMoreGray = ImageResource(name: "icon_more_gray", bundle: resourceBundle)

    /// The "icon_no record" asset catalog image resource.
    static let iconNoRecord = ImageResource(name: "icon_no record", bundle: resourceBundle)

    /// The "icon_order_active" asset catalog image resource.
    static let iconOrderActive = ImageResource(name: "icon_order_active", bundle: resourceBundle)

    /// The "icon_order_default" asset catalog image resource.
    static let iconOrderDefault = ImageResource(name: "icon_order_default", bundle: resourceBundle)

    /// The "icon_repayment" asset catalog image resource.
    static let iconRepayment = ImageResource(name: "icon_repayment", bundle: resourceBundle)

    /// The "icon_return_black" asset catalog image resource.
    static let iconReturnBlack = ImageResource(name: "icon_return_black", bundle: resourceBundle)

    /// The "icon_return_white" asset catalog image resource.
    static let iconReturnWhite = ImageResource(name: "icon_return_white", bundle: resourceBundle)

    /// The "icon_select" asset catalog image resource.
    static let iconSelect = ImageResource(name: "icon_select", bundle: resourceBundle)

    /// The "icon_warn_brown" asset catalog image resource.
    static let iconWarnBrown = ImageResource(name: "icon_warn_brown", bundle: resourceBundle)

    /// The "icon_warn_red" asset catalog image resource.
    static let iconWarnRed = ImageResource(name: "icon_warn_red", bundle: resourceBundle)

    /// The "loa_n_pop_sample" asset catalog image resource.
    static let loaNPopSample = ImageResource(name: "loa_n_pop_sample", bundle: resourceBundle)

    /// The "login bg" asset catalog image resource.
    static let loginBg = ImageResource(name: "login bg", bundle: resourceBundle)

    /// The "logo_Group" asset catalog image resource.
    static let logoGroup = ImageResource(name: "logo_Group", bundle: resourceBundle)

    /// The "logo_bbbBlue" asset catalog image resource.
    static let logoBbbBlue = ImageResource(name: "logo_bbbBlue", bundle: resourceBundle)

    /// The "logo_mvp80" asset catalog image resource.
    static let logoMvp80 = ImageResource(name: "logo_mvp80", bundle: resourceBundle)

    /// The "logout_pop_tip" asset catalog image resource.
    static let logoutPopTip = ImageResource(name: "logout_pop_tip", bundle: resourceBundle)

    /// The "main_back_icon" asset catalog image resource.
    static let mainBackIcon = ImageResource(name: "main_back_icon", bundle: resourceBundle)

    /// The "mpagecard" asset catalog image resource.
    static let mpagecard = ImageResource(name: "mpagecard", bundle: resourceBundle)

    /// The "mpagetopbg" asset catalog image resource.
    static let mpagetopbg = ImageResource(name: "mpagetopbg", bundle: resourceBundle)

    /// The "notAgree" asset catalog image resource.
    static let notAgree = ImageResource(name: "notAgree", bundle: resourceBundle)

    /// The "ordtopbg" asset catalog image resource.
    static let ordtopbg = ImageResource(name: "ordtopbg", bundle: resourceBundle)

    /// The "pLogo" asset catalog image resource.
    static let pLogo = ImageResource(name: "pLogo", bundle: resourceBundle)

    /// The "payBackTipLogo" asset catalog image resource.
    static let payBackTipLogo = ImageResource(name: "payBackTipLogo", bundle: resourceBundle)

    /// The "rate_bg" asset catalog image resource.
    static let rateBg = ImageResource(name: "rate_bg", bundle: resourceBundle)

    /// The "roup19900371" asset catalog image resource.
    static let roup19900371 = ImageResource(name: "roup19900371", bundle: resourceBundle)

    /// The "roup2119900498" asset catalog image resource.
    static let roup2119900498 = ImageResource(name: "roup2119900498", bundle: resourceBundle)

    /// The "rpiofileicon" asset catalog image resource.
    static let rpiofileicon = ImageResource(name: "rpiofileicon", bundle: resourceBundle)

    /// The "signin_icon_select" asset catalog image resource.
    static let signinIconSelect = ImageResource(name: "signin_icon_select", bundle: resourceBundle)

    /// The "signin_icon_selected" asset catalog image resource.
    static let signinIconSelected = ImageResource(name: "signin_icon_selected", bundle: resourceBundle)

    /// The "top_mvpBg" asset catalog image resource.
    static let topMvpBg = ImageResource(name: "top_mvpBg", bundle: resourceBundle)

    /// The "tp_btn" asset catalog image resource.
    static let tpBtn = ImageResource(name: "tp_btn", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif