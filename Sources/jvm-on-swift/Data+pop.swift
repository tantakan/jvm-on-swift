import Foundation

extension Data {
    mutating func pop(_ bytes: Int) -> Data {
        var result: [UInt8] = []
        for _ in 0..<bytes {
            if let element = popFirst() {
                result.append(element)
            }
        }
        return Data(result)
    }
    
    mutating func pop(_ bytes: Int) -> Int {
        return Int(pop(bytes).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
    }
    
    mutating func pop() -> UInt8 {
        return popFirst() ?? 0
    }
}
