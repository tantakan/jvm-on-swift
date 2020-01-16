import Foundation

extension Data {
    mutating func pop(_ bytes: Int) -> Data {
        var result: [UInt8] = []
        for _ in 0..<bytes {
            guard let byte = popFirst() else {
                fatalError("no data")
            }
            result.append(byte)
        }
        return Data(result)
    }
    
    func toInt() -> Int {
        return Int(toString()) ?? 0
    }
    
    func toString() -> String {
        return compactMap({ String(format: "%02d", $0)}).joined()
    }
    
    func toHexString() -> String {
        return compactMap({ String(format: "%02x", $0)}).joined()
    }
    
    func toEncodedString() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}
