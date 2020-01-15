import Foundation

class ConstantPoolUtf8: ConstantPool {
    let length: Int
    
    override class var infoBytes: Int {
        return 2
    }
    
    override var needMoreBytes: Int {
        return length
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        length = Int(data.compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        super.init(tag, data)
    }
}
