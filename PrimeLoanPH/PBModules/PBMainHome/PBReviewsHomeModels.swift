//
//  PBReviewsHomeModels.swift
//  PrimeLoanPH
//
//  off/reviews 响应：宽松解码（数字当字符串、finding 混合元素等）
//

import Foundation

/// 值映射：首页 draw.reviewed（与接口文档 7. 一致）
enum PBHomeDrawReviewed {
    static let banner = "sre"
    static let largeCard = "srb"
    static let smallCard = "src"
    static let productList = "srd"
}

// MARK: - 宽松解码

extension KeyedDecodingContainerProtocol {
    /// 接口常把数字当字符串或反过来
    func decodeLooseStringIfPresent(forKey key: Key) throws -> String? {
        guard contains(key) else { return nil }
        if try decodeNil(forKey: key) { return nil }
        if let v = try? decode(String.self, forKey: key) { return v }
        if let v = try? decode(Int.self, forKey: key) { return String(v) }
        if let v = try? decode(Int64.self, forKey: key) { return String(v) }
        if let v = try? decode(Double.self, forKey: key) {
            if v.truncatingRemainder(dividingBy: 1) == 0 { return String(Int(v)) }
            return String(v)
        }
        if let v = try? decode(Bool.self, forKey: key) { return v ? "1" : "0" }
        return nil
    }
}

/// 用于跳过 finding 里非字符串元素，避免整段解析失败
private struct PBSkipJSONValue: Decodable {
    init(from decoder: Decoder) throws {
        if var unkeyed = try? decoder.unkeyedContainer() {
            while !unkeyed.isAtEnd {
                _ = try? unkeyed.decode(PBSkipJSONValue.self)
            }
            return
        }
        if var keyed = try? decoder.container(keyedBy: PBDynamicCodingKey.self) {
            for k in keyed.allKeys {
                _ = try? keyed.decode(PBSkipJSONValue.self, forKey: k)
            }
            return
        }
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { return }
        if (try? c.decode(Bool.self)) != nil { return }
        if (try? c.decode(String.self)) != nil { return }
        if (try? c.decode(Int.self)) != nil { return }
        if (try? c.decode(Int64.self)) != nil { return }
        if (try? c.decode(Double.self)) != nil { return }
    }
}

private struct PBDynamicCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
}

// MARK: - 模型

struct PBReviewsResponse: Decodable {
    var defines: String?
    var concepts: String?
    var theoretical: PBTheoreticalPayload?

    private enum CodingKeys: String, CodingKey {
        case defines, concepts, theoretical
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        defines = try c.decodeLooseStringIfPresent(forKey: .defines)
        concepts = try c.decodeLooseStringIfPresent(forKey: .concepts)
        theoretical = try c.decodeIfPresent(PBTheoreticalPayload.self, forKey: .theoretical)
    }
}

struct PBTheoreticalPayload: Decodable {
    var shapes: PBShapesPayload?
    var legislation: String?
    var finding: [String]?
    var draw: [PBDrawItemPayload]?
    /// 与 ObjC PPHomeTheoreticalModel.ethnic 对齐，避免缺字段导致失败时可选即可
    var ethnic: PBEthnicPayload?

    private enum CodingKeys: String, CodingKey {
        case shapes, legislation, finding, draw, ethnic
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        shapes = try c.decodeIfPresent(PBShapesPayload.self, forKey: .shapes)
        legislation = try c.decodeLooseStringIfPresent(forKey: .legislation)
        ethnic = try c.decodeIfPresent(PBEthnicPayload.self, forKey: .ethnic)
        draw = try c.decodeIfPresent([PBDrawItemPayload].self, forKey: .draw)
        finding = try PBTheoreticalPayload.decodeFinding(from: c)
    }

    private static func decodeFinding(from c: KeyedDecodingContainer<CodingKeys>) throws -> [String]? {
        guard c.contains(.finding) else { return nil }
        if try c.decodeNil(forKey: .finding) { return nil }
        var nested = try c.nestedUnkeyedContainer(forKey: .finding)
        var out: [String] = []
        while !nested.isAtEnd {
            if let s = try? nested.decode(String.self) {
                out.append(s)
            } else if let i = try? nested.decode(Int.self) {
                out.append(String(i))
            } else if let d = try? nested.decode(Double.self) {
                out.append(String(d))
            } else if (try? nested.decode(PBSkipJSONValue.self)) != nil {
                continue
            } else {
                break
            }
        }
        return out
    }
}

struct PBEthnicPayload: Decodable {
    var age: String?
    var funds: String?

    private enum CodingKeys: String, CodingKey {
        case age, funds
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        age = try c.decodeLooseStringIfPresent(forKey: .age)
        funds = try c.decodeLooseStringIfPresent(forKey: .funds)
    }
}

struct PBShapesPayload: Decodable {
    var experiences: String?
    var chapters: String?
    var objectives: String?
    var undoubtedly: String?

    private enum CodingKeys: String, CodingKey {
        case experiences, chapters, objectives, undoubtedly
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        experiences = try c.decodeLooseStringIfPresent(forKey: .experiences)
        chapters = try c.decodeLooseStringIfPresent(forKey: .chapters)
        objectives = try c.decodeLooseStringIfPresent(forKey: .objectives)
        undoubtedly = try c.decodeLooseStringIfPresent(forKey: .undoubtedly)
    }
}

struct PBDrawItemPayload: Decodable {
    var reviewed: String?
    var conclusion: [PBDrawConclusionPayload]?

    private enum CodingKeys: String, CodingKey {
        case reviewed, conclusion
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        reviewed = try c.decodeLooseStringIfPresent(forKey: .reviewed)
        if let arr = try? c.decodeIfPresent([PBDrawConclusionPayload].self, forKey: .conclusion) {
            conclusion = arr
        } else if let one = try? c.decodeIfPresent(PBDrawConclusionPayload.self, forKey: .conclusion) {
            conclusion = [one]
        } else {
            conclusion = nil
        }
    }
}

struct PBDrawConclusionPayload: Decodable {
    var translated: String?
    var examine: String?
    var courses: String?
    var networks: String?
    var lobbying: String?
    var voice: String?
    var powerful: String?
    var naldic: String?
    var questioning: String?
    var opposition: String?
    var simply: String?
    var discourage: String?
    var consequently: String?
    var announced: String?
    var pivotal: Int?

    private enum CodingKeys: String, CodingKey {
        case translated, examine, courses, networks, lobbying, voice, powerful
        case naldic, questioning, opposition, simply, discourage, consequently
        case announced, pivotal
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        translated = try c.decodeLooseStringIfPresent(forKey: .translated)
        examine = try c.decodeLooseStringIfPresent(forKey: .examine)
        courses = try c.decodeLooseStringIfPresent(forKey: .courses)
        networks = try c.decodeLooseStringIfPresent(forKey: .networks)
        lobbying = try c.decodeLooseStringIfPresent(forKey: .lobbying)
        voice = try c.decodeLooseStringIfPresent(forKey: .voice)
        powerful = try c.decodeLooseStringIfPresent(forKey: .powerful)
        naldic = try c.decodeLooseStringIfPresent(forKey: .naldic)
        questioning = try c.decodeLooseStringIfPresent(forKey: .questioning)
        opposition = try c.decodeLooseStringIfPresent(forKey: .opposition)
        simply = try c.decodeLooseStringIfPresent(forKey: .simply)
        discourage = try c.decodeLooseStringIfPresent(forKey: .discourage)
        consequently = try c.decodeLooseStringIfPresent(forKey: .consequently)
        announced = try c.decodeLooseStringIfPresent(forKey: .announced)

        if let i = try? c.decodeIfPresent(Int.self, forKey: .pivotal) {
            pivotal = i
        } else if let s = try? c.decodeLooseStringIfPresent(forKey: .pivotal), let i = Int(s) {
            pivotal = i
        } else if let d = try? c.decodeIfPresent(Double.self, forKey: .pivotal) {
            pivotal = Int(d)
        } else {
            pivotal = nil
        }
    }
}

extension PBReviewsResponse {
    static func decode(from dict: [String: Any]) throws -> PBReviewsResponse {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        return try JSONDecoder().decode(PBReviewsResponse.self, from: data)
    }
}
