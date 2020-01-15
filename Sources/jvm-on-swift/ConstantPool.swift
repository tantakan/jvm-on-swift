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

class ConstantPoolMethodref: ConstantPool {
    override class var infoBytes: Int {
        return 4
    }
}

class ConstantPoolFieldref: ConstantPool {
    override class var infoBytes: Int {
        return 4
    }
}

class ConstantPoolString: ConstantPool {
    override class var infoBytes: Int {
        return 2
    }
}

class ConstantPoolClass: ConstantPool {
    override class var infoBytes: Int {
        return 2
    }
}

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

class ConstantPoolNameAndType: ConstantPool {
    override class var infoBytes: Int {
        return 4
    }
}

struct ConstantPoolTag {
    let tag: UInt8
    
    var infoType: ConstantPool.Type {
        switch tag {
        case 12:    // CONSTANT_NameAndType
            return ConstantPoolNameAndType.self
        case 10:    // CONSTANT_Methodref
            return ConstantPoolMethodref.self
        case 9:     // CONSTANT_Fieldref
            return ConstantPoolFieldref.self
        case 8:     // CONSTANT_String
            return ConstantPoolString.self
        case 7:     // CONSTANT_Class
            return ConstantPoolClass.self
        case 1:     // CONSTANT_Utf8
            return ConstantPoolUtf8.self
        default:    // UNKNOWN
            return ConstantPool.self
        }
    }
    
    init(_ tag: UInt8) {
        self.tag = tag
    }
}
