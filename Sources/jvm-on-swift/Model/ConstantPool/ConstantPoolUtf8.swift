import Foundation

class ConstantPoolUtf8: ConstantPool {
    let length: Int
    var str: String = ""
    
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
    
    override func loadMore(_ data: Data) {
        super.loadMore(data)
        str = data.toEncodedString()
    }
}
