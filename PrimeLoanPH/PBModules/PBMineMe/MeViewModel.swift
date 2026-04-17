//
//  MeViewModel.swift
//  PrimeLoanPH
//

import Foundation
import SwiftUI
import UIKit

final class MeViewModel: ObservableObject {
    @Published var phoneDisplay: String = " "
    @Published var menuRows: [MeMenuRow] = []
    /// 与设计稿一致；无单独统计接口时展示占位，点击仍跳转 Order 对应 segment
    @Published var statApply: String = "0"
    @Published var statRepay: String = "93"
    @Published var statFinished: String = "99+"

    func load(host: PPBaseViewController, showBlockingLoading: Bool, completion: (() -> Void)? = nil) {
        if showBlockingLoading {
            PB_NativeTipsHelper.pb_showLoading(in: host.view)
        }
        let url = PB_API_MineMenuURL() as String
        PB_RequestHelper.pb_instance().pb_getRequest(withUrlStr: url, params: [:], commplete: { [weak self] result, _ in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                completion?()
                guard let self else { return }
                if let dict = result {
                    if let model = PPMeModel.yy_model(withJSON: dict) {
                        if let phone = model.theoretical?.inspiring?.userphone {
                            self.phoneDisplay = Self.maskPhone(phone)
                        }
                        if let draw = model.theoretical?.draw as? [Any] {
                            var rows: [MeMenuRow] = []
                            for item in draw {
                                if let m = item as? PPMeDrawModel {
                                    rows.append(
                                        MeMenuRow(
                                            title: m.age ?? "",
                                            iconURL: m.shapes ?? "",
                                            link: m.translated ?? ""
                                        )
                                    )
                                }
                            }
                            self.menuRows = rows
                        }
                    }
                }
            }
        }, failure: { _, _, msg in
            DispatchQueue.main.async {
                PB_NativeTipsHelper.pb_hideAllLoading()
                completion?()
                let text = (msg as String?) ?? ""
                if !text.isEmpty {
                    PB_NativeTipsHelper.pb_presentAlert(withMessage: text)
                }
            }
        })
    }

    /// 展示类似 63 **** 1618
    private static func maskPhone(_ raw: String) -> String {
        let digits = String(raw.filter(\.isNumber))
        guard digits.count >= 4 else { return raw.isEmpty ? " " : raw }
        let last4 = String(digits.suffix(4))
        if digits.count <= 6 {
            return "**** \(last4)"
        }
        let prefixLen = min(2, digits.count - 4)
        let prefix = String(digits.prefix(prefixLen))
        return "\(prefix) **** \(last4)"
    }

    func openOrderSegment(_ index: Int, host: PPBaseViewController) {
        let link = "pml://loan.org/sfd?identical=\(index + 1)"
        if PB_APP_Control.pb_t_presentLoginVC(withTargetVC: host) {
            PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: link, fromVC: host)
        }
    }

    func openMenuLink(_ row: MeMenuRow, host: PPBaseViewController) {
        guard !row.link.isEmpty else { return }
        if PB_APP_Control.pb_t_presentLoginVC(withTargetVC: host) {
            PB_APP_Control.pb_t_goToModule(withJudgeTypeStr: row.link, fromVC: host)
        }
    }
}

struct MeMenuRow: Identifiable {
    let id = UUID()
    let title: String
    let iconURL: String
    let link: String
}
