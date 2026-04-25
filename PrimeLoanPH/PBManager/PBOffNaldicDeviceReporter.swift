//
//  PBOffNaldicDeviceReporter.swift
//  PrimeLoanPH
//
//  off/naldic：设备信息上报。采集字典由 `PBMainInfoHelper`（ObjC 名 `PB_mainInfo_helper`）提供，JSON 与 `POST` 在 Swift 中完成。
//

import Foundation

@objc(PBOffNaldicDeviceReporter)
public final class PBOffNaldicDeviceReporter: NSObject {

    /// 拉取 `PBMainInfoHelper` 聚合字段 → JSON → `POST off/naldic`，body 键 `theoretical`
    @objc public static func uploadCollectedDeviceInfo() {
        guard let raw = PBMainInfoHelper.instanceOnly().pb_t_getMainInfoDictData() as? [String: Any] else {
            return
        }
        guard JSONSerialization.isValidJSONObject(raw) else {
            return
        }
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: raw, options: [.prettyPrinted])
        } catch {
            return
        }
        guard let json = String(data: data, encoding: .utf8) else {
            return
        }
#if DEBUG
        print("设备信息上报参数(naldic): \(json)")
#endif
        let params: [String: Any] = ["theoretical": json]
        PB_RequestHelper.pb_instance().pb_postRequest(
            withUrlStr: PB_API_ReportDeviceInfoURL(),
            params: params,
            commplete: { _, _ in },
            failure: { _, _, _ in }
        )
    }
}
