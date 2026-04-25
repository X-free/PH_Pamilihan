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
    /// 与设计稿一致；无单独统计接口时数字留空，点击跳转 Order 对应 segment（identical 与 segment 下标 0/1/2 一致）
    @Published var statApply: String = ""
    @Published var statRepay: String = ""
    @Published var statFinished: String = ""

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
                        // 手机号：接口 `inspiring.userphone`（`theoretical.inspiring` 或根级 `inspiring`）
                        let nested = model.theoretical?.inspiring?.userphone
                        let root = model.inspiring?.userphone
                        let raw = [nested, root]
                            .compactMap { s -> String? in
                                guard let s, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
                                return s.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .first
                        if let raw {
                            self.phoneDisplay = raw
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

    func openOrderSegment(_ index: Int, host: PPBaseViewController) {
        guard PB_APP_Control.pb_t_presentLoginVC(withTargetVC: host) else { return }
        PB_APP_Control.selectOrderTab(segment: index, from: host)
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
