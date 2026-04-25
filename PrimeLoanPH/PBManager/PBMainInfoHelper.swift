//
//  PBMainInfoHelper.swift
//  PrimeLoanPH
//
//  原 `PB_mainInfo_helper`（设备信息采集）Swift 实现；对外类名仍为 `PB_mainInfo_helper` 供 ObjC / 现有调用处使用。
//

import UIKit
import Foundation
import CoreTelephony
import SystemConfiguration
import CFNetwork
import Darwin
import NetworkExtension

private let kHistoryWifiUserDefaultsKey = "PB_T_HistoryWifiEnquryKey"

/// ObjC 类名保持 `PB_mainInfo_helper`，与 Prefix / `PBOffNaldicDeviceReporter` 等一致
@objc(PB_mainInfo_helper)
public final class PBMainInfoHelper: NSObject {

    @objc public static let shared = PBMainInfoHelper()

    @objc public static func instanceOnly() -> PBMainInfoHelper { shared }

    @objc(pb_t_getMainInfoDictData)
    public func pb_t_getMainInfoDictData() -> NSDictionary {
        var result: [String: Any] = [:]

        let access: [String: Any] = [
            "consideration": str(pb_t_getMaxMemoryString()),
            "taken": str(pb_t_getAvailableMemoryString()),
            "homogeneous": str(pb_t_getMaxDiskString()),
            "group": str(pb_t_getAvailableDiskString())
        ]
        result["access"] = access

        let batteryState = pb_t_getBatteryIsFullString()
        let seems: [String: Any] = [
            "conflated": str(pb_t_getBatteryLeftPercentString()),
            "seems": str(batteryState),
            "mainstreamed": batteryState == "Charging" ? "1" : "0"
        ]
        result["seems"] = seems

        let identities: [String: Any] = [
            "ethno": str(pb_t_getSystemVersionString()),
            "removed": str(pb_t_getCurDeviceInfoTypeNameString()),
            "distinct": str(PB_getAppInfoHelper.pb_t0_getPhoneDeviceTypeNameString()),
            "difference": str(pb_t_getPixelHeightString()),
            "disregarded": str(pb_t_getPixelWidthString()),
            "ultimately": str(pb_t_getDevicePhysicalSizeString()),
            "cultural": str(pb_t_getPhysicalSizeString())
        ]
        result["identities"] = identities

        let signal = PB_getAppInfoHelper.pb_to_getSignalNum()
        let rhetoric: [String: Any] = [
            "highlight": str(pb_t_getIsTheSimulatorString()),
            "contradictions": str(pb_t_getDeviceIsJailbrokenString()),
            "living": signal <= 0 ? "" : NSNumber(value: signal)
        ]
        result["rhetoric"] = rhetoric

        let fundamental: [String: Any] = [
            "underpinned": str(pb_t_getGMTimeZoneString()),
            "surgeries": str(pb_t_getHasOpenAndUseProxy()),
            "doctors": str(pb_t_getHasUseTheVPN()),
            "visitor": str(pb_t_getDeviceMobileCardType()),
            "conceptualised": str(PB_idf_helper.instanceOnly().pb_t_getIdfvOnlyString()),
            "via": str(pb_t_getTheAppLanguage()),
            "getting": str(pb_t_toGetNetworkTypeString()),
            "advise": str(pb_t_getDeviceTypeNumberString()),
            "vein": str(pb_t_getWaiWangNetIPString()),
            "baker": str(PB_idf_helper.instanceOnly().pb_t_getIDFAOnlyString())
        ]
        result["fundamental"] = fundamental

        result["similar"] = pb_t_getCurrentConnectWifiInfoDict() as NSDictionary
        return result as NSDictionary
    }

    // MARK: - String helpers

    private func str(_ any: Any?) -> String {
        guard let any else { return "" }
        if let s = any as? String { return s }
        if let s = any as? NSString { return s as String }
        return String(describing: any)
    }

    // MARK: - Memory / disk

    private func pb_t_getAvailableMemoryString() -> String {
        var size = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        var hostPort = mach_host_self()
        var pageSize: vm_size_t = 0
        host_page_size(hostPort, &pageSize)
        var vminfo = vm_statistics64()
        let kr = withUnsafeMutablePointer(to: &vminfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &size)
            }
        }
        guard kr == KERN_SUCCESS else { return "0" }
        let freeSize = UInt64(vminfo.free_count + vminfo.external_page_count + vminfo.purgeable_count - vminfo.speculative_count) * UInt64(pageSize)
        return "\(freeSize)"
    }

    private func pb_t_getMaxMemoryString() -> String {
        let total = ProcessInfo.processInfo.physicalMemory
        return "\(total)"
    }

    private func pb_t_getMaxDiskString() -> String {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let space = (attrs[.systemSize] as? NSNumber)?.int64Value ?? -1
            return "\(max(space, -1))"
        } catch {
            return "-1"
        }
    }

    private func pb_t_getAvailableDiskString() -> String {
        let url = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        if let cap = try? url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
            return "\(cap)"
        }
        return "0"
    }

    // MARK: - Battery

    private func pb_t_getBatteryLeftPercentString() -> String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        let pct = String(format: "%.0f", Double(level) * 100.0)
        return pct.replacingOccurrences(of: "-", with: "")
    }

    private func pb_t_getBatteryIsFullString() -> String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
        case .charging:
            return UIDevice.current.batteryLevel == 1 ? "Fully charged" : "Charging"
        case .full:
            return "Fully charged"
        case .unplugged:
            return "Unplugged"
        default:
            return "Unknown"
        }
    }

    // MARK: - System / screen

    private func pb_t_getSystemVersionString() -> String {
        UIDevice.current.systemVersion
    }

    private func pb_t_getCurDeviceInfoTypeNameString() -> String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return "iPhone"
        case .pad: return "iPad"
        default: return "diomOther"
        }
    }

    private func pb_t_getPixelHeightString() -> String {
        let s = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        return String(format: "%.0f", Double(s.height * scale))
    }

    private func pb_t_getPixelWidthString() -> String {
        let s = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        return String(format: "%.0f", Double(s.width * scale))
    }

    private func pb_t_getPhysicalSizeString() -> String {
        let deviceTName = PB_getAppInfoHelper.pb_t0_getPhoneDeviceTypeNameString() as String
        switch deviceTName {
        case "iphoneSE": return "4"
        case "iPhone6", "iPhone6s", "iPhone7", "iPhone8", "iphoneSE2": return "4.7"
        case "iPhone12Mini", "iPhone13Mini": return "5.4"
        case "iPhone6Plus", "iPhone6sPlus", "iPhone7Plus", "iPhone8Plus": return "5.5"
        case "iPhoneX", "iPhoneXS", "iPhone11Pro": return "5.8"
        case "iPhoneXR", "iPhone11", "iPhone12", "iPhone12Pro", "iPhone13", "iPhone13Pro", "iPhone14", "iPhone14Pro": return "6.1"
        case "iPhoneXS_MAX", "iPhone11ProMax": return "6.5"
        case "iPhone12ProMax", "iPhone13ProMax", "iPhone14Plus", "iPhone14ProMax": return "6.7"
        default:
            let scale = Double(UIScreen.main.scale)
            let ppi = scale * (UIDevice.current.userInterfaceIdiom == .pad ? 132.0 : 163.0)
            let width = Double(UIScreen.main.bounds.size.width * UIScreen.main.scale)
            let height = Double(UIScreen.main.bounds.size.height * UIScreen.main.scale)
            let horizontal = width / ppi
            let vertical = height / ppi
            let diagonal = sqrt(horizontal * horizontal + vertical * vertical)
            return String(format: "%.1f", diagonal)
        }
    }

    private func pb_t_getDevicePhysicalSizeString() -> String {
        let rect = UIScreen.main.bounds
        return String(format: "%.0fX%.0f", Double(rect.size.width), Double(rect.size.height))
    }

    // MARK: - Simulator / jailbreak

    private func pb_t_getIsTheSimulatorString() -> String {
        #if targetEnvironment(simulator)
        return "1"
        #else
        return "0"
        #endif
    }

    private func pb_t_getDeviceIsJailbrokenString() -> String {
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        for p in paths where FileManager.default.fileExists(atPath: p) {
            return "1"
        }
        return "0"
    }

    private func pb_t_getGMTimeZoneString() -> String {
        TimeZone.current.identifier
    }

    private func pb_t_getHasOpenAndUseProxy() -> String {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let url = URL(string: "http://www.baidu.com") as CFURL?,
              let proxies = CFNetworkCopyProxiesForURL(url, proxySettings as CFDictionary).takeRetainedValue() as? [[String: Any]],
              let first = proxies.first,
              let type = first[kCFProxyTypeKey as String] as? String else {
            return "0"
        }
        return type == "kCFProxyTypeNone" ? "0" : "1"
    }

    private func pb_t_getHasUseTheVPN() -> String {
        guard let dict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let scoped = dict["__SCOPED__"] as? [String: Any] else {
            return "0"
        }
        for key in scoped.keys {
            let lower = key.lowercased()
            if lower.contains("tap") || lower.contains("tun") || lower.contains("ipsec") || lower.contains("ppp") {
                return "1"
            }
        }
        return "0"
    }

    private func pb_t_getDeviceMobileCardType() -> String {
        let info = CTTelephonyNetworkInfo()
        let carrier = info.subscriberCellularProvider
        guard let code = carrier?.mobileNetworkCode else { return "" }
        switch code {
        case "00", "02", "07": return "移动运营商"
        case "01", "06": return "联通运营商"
        case "03", "05": return "电信运营商"
        case "20": return "铁通运营商"
        default: return ""
        }
    }

    private func pb_t_getTheAppLanguage() -> String {
        guard let first = Locale.preferredLanguages.first else { return "" }
        return first.split(separator: "-").first.map(String.init) ?? first
    }

    private func pb_t_toGetNetworkTypeString() -> String {
        // 不用 `NetworkStatus` 枚举：`import NetworkExtension` 后 Swift 会解析到 NE 的 `NetworkStatus`，与 Reachability 冲突。
        guard let reach = Reachability.forInternetConnection() else { return "5G" }
        if !reach.isReachable() {
            return "NONE"
        }
        if reach.isReachableViaWiFi() {
            return "WIFI"
        }
        if reach.isReachableViaWWAN() {
            let info = CTTelephonyNetworkInfo()
            guard let current = info.currentRadioAccessTechnology else { return "5G" }
            switch current {
            case CTRadioAccessTechnologyGPRS: return "GPRS"
            case CTRadioAccessTechnologyEdge: return "2.75G EDGE"
            case CTRadioAccessTechnologyWCDMA: return "3G"
            case CTRadioAccessTechnologyHSDPA: return "3.5G HSDPA"
            case CTRadioAccessTechnologyHSUPA: return "3.5G HSUPA"
            case CTRadioAccessTechnologyCDMA1x: return "2G"
            case CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB: return "3G"
            case CTRadioAccessTechnologyeHRPD: return "HRPD"
            case CTRadioAccessTechnologyLTE: return "4G"
            default:
                if #available(iOS 14.1, *) {
                    if current == CTRadioAccessTechnologyNRNSA { return "5G NSA" }
                    if current == CTRadioAccessTechnologyNR { return "5G" }
                }
                return "5G"
            }
        }
        return "5G"
    }

    private func pb_t_getDeviceTypeNumberString() -> String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return "1"
        case .pad: return "2"
        default: return ""
        }
    }

    // MARK: - IP

    private func pb_t_devicewifiIPAddressString() -> String {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return "" }
        defer { freeifaddrs(first) }
        var ptr: UnsafeMutablePointer<ifaddrs>? = first
        while let addr = ptr {
            let ifa = addr.pointee
            guard let sa = ifa.ifa_addr, sa.pointee.sa_family == UInt8(AF_INET) else {
                ptr = ifa.ifa_next
                continue
            }
            let name = String(cString: ifa.ifa_name)
            if name == "en0" {
                var sin = sa.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
                var buf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                _ = withUnsafePointer(to: &sin.sin_addr) {
                    inet_ntop(AF_INET, $0, &buf, socklen_t(INET_ADDRSTRLEN))
                }
                return String(cString: buf)
            }
            ptr = ifa.ifa_next
        }
        return ""
    }

    private func pb_t_getDeviceIPString() -> String {
        let ips = collectUpIPv4Addresses()
        return ips.last ?? ""
    }

    private func collectUpIPv4Addresses() -> [String] {
        var list: [String] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return [] }
        defer { freeifaddrs(first) }
        var ptr: UnsafeMutablePointer<ifaddrs>? = first
        while let addr = ptr {
            let ifa = addr.pointee
            guard let sa = ifa.ifa_addr, sa.pointee.sa_family == UInt8(AF_INET) else {
                ptr = ifa.ifa_next
                continue
            }
            let flags = Int32(ifa.ifa_flags)
            guard (flags & IFF_UP) != 0 else {
                ptr = ifa.ifa_next
                continue
            }
            let name = String(cString: ifa.ifa_name)
            if name != "lo0" {
                var sin = sa.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
                var buf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                _ = withUnsafePointer(to: &sin.sin_addr) {
                    inet_ntop(AF_INET, $0, &buf, socklen_t(INET_ADDRSTRLEN))
                }
                let s = String(cString: buf)
                if !s.isEmpty { list.append(s) }
            }
            ptr = ifa.ifa_next
        }
        return list
    }

    private func pb_t_getWaiWangNetIPString() -> String {
        let wifi = pb_t_devicewifiIPAddressString()
        if !wifi.isEmpty { return wifi }
        let other = pb_t_getDeviceIPString()
        if !other.isEmpty { return other }
        return "Unknown"
    }

    // MARK: - Wi‑Fi（`NEHotspotNetwork.fetchCurrent`：SSID / BSSID，需 `com.apple.developer.networking.wifi-info`）

    private func pb_t_getCurrentConnectWifiInfoDict() -> [String: Any] {
        var finalDic: [String: Any] = [:]
        if #available(iOS 14.0, *) {
            if let hotspot = fetchCurrentHotspotNetworkSync() {
                let ssid = hotspot.ssid
                let bssid = hotspot.bssid
                finalDic["hearing"] = bssid
                finalDic["reading"] = bssid
                finalDic["celebrating"] = ssid
                finalDic["either"] = ssid
            }
        }
        #if DEBUG
        print("dicCurrent Wi-Fi = \(finalDic)")
        #endif

        var history = (UserDefaults.standard.array(forKey: kHistoryWifiUserDefaultsKey) as? [[String: Any]]) ?? []
        if !history.isEmpty {
            var hasExist = false
            let curName: String = {
                guard let v = finalDic["celebrating"] else { return "" }
                return "\(v)"
            }()
            for item in history {
                let wifiName = "\(item["celebrating"] ?? "")"
                if !finalDic.isEmpty, wifiName == curName {
                    hasExist = true
                    break
                }
            }
            if !hasExist, !finalDic.isEmpty, !NSString.pb_CheckIsEmpty(finalDic["celebrating"]) {
                history.append(finalDic)
                UserDefaults.standard.set(history, forKey: kHistoryWifiUserDefaultsKey)
            }
        } else {
            if !finalDic.isEmpty, !NSString.pb_CheckIsEmpty(finalDic["celebrating"]) {
                history.append(finalDic)
            }
            UserDefaults.standard.set(history, forKey: kHistoryWifiUserDefaultsKey)
        }

        return wrapWifiResult(final: finalDic, history: history)
    }

    /// `fetchCurrent` 的 completion 可能在主队列执行；若在主线程用 `Semaphore.wait` 会死锁，故主线程用 RunLoop 短转等待。
    @available(iOS 14.0, *)
    private func fetchCurrentHotspotNetworkSync() -> NEHotspotNetwork? {
        var hotspot: NEHotspotNetwork?
        var completed = false
        let lock = NSLock()
        var offMainSem: DispatchSemaphore?
        if !Thread.isMainThread {
            offMainSem = DispatchSemaphore(value: 0)
        }
        NEHotspotNetwork.fetchCurrent { nw in
            lock.lock()
            hotspot = nw
            completed = true
            lock.unlock()
            offMainSem?.signal()
        }
        let deadline = Date().addingTimeInterval(1.5)
        if Thread.isMainThread {
            while Date() < deadline {
                lock.lock()
                let done = completed
                lock.unlock()
                if done { break }
                RunLoop.main.run(mode: .default, before: Date().addingTimeInterval(0.05))
            }
        } else {
            _ = offMainSem?.wait(timeout: .now() + 1.5)
        }
        lock.lock()
        defer { lock.unlock() }
        return hotspot
    }

    private func wrapWifiResult(final: [String: Any], history: [[String: Any]]) -> [String: Any] {
        [
            "each": history.count,
            "minutes": final,
            "read": history
        ]
    }
}
