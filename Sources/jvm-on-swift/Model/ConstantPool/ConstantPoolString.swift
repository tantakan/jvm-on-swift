import Foundation

class ConstantPoolString: ConstantPool {
    let string_index: Data
    
    override class var infoBytes: Int {
        return 2
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        string_index = data
        super.init(tag, data)
    }
}
