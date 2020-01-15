import Foundation

struct ConstantPoolTag {
    let tag: Int
    
    var infoType: ConstantPool.Type {
        switch tag {
        case 1:     // CONSTANT_Utf8
            return ConstantPoolUtf8.self
        case 7:     // CONSTANT_Class
            return ConstantPoolClass.self
        case 8:     // CONSTANT_String
            return ConstantPoolString.self
        case 9:     // CONSTANT_Fieldref
            return ConstantPoolFieldref.self
        case 10:    // CONSTANT_Methodref
            return ConstantPoolMethodref.self
        case 12:    // CONSTANT_NameAndType
            return ConstantPoolNameAndType.self
        default:    // UNKNOWN
            return ConstantPool.self
        }
    }
    
    init(_ tag: Int) {
        self.tag = tag
    }
}
