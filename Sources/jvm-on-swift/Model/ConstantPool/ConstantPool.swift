import Foundation

protocol ConstantPoolProtocol {
    var tag: ConstantPoolTag { get set }
    var info: Data { get set }
    var needMoreBytes: Int { get }
    static var infoBytes: Int { get }
    func loadMore(_ data: Data)
}

class ConstantPool: ConstantPoolProtocol {
    var tag: ConstantPoolTag
    var info: Data
    
    var needMoreBytes: Int {
        return 0
    }
    
    class var infoBytes: Int {
        return 0
    }
    
    func loadMore(_ data: Data) {
        info.append(data)
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        self.tag = tag
        info = data
    }
}
