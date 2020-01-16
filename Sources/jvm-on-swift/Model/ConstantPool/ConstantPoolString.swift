import Foundation

class ConstantPoolString: ConstantPool {
    let string_index: Int
    
    override class var infoBytes: Int {
        return 2
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        string_index = data.toInt()
        super.init(tag, data)
    }
}
