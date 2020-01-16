import Foundation

class ConstantPoolClass: ConstantPool {
    let name_index: Int
    
    override class var infoBytes: Int {
        return 2
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        name_index = data.toInt()
        super.init(tag, data)
    }
}
