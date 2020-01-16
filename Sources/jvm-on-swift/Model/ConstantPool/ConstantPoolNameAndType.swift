import Foundation

class ConstantPoolNameAndType: ConstantPool {
    var name_index: Int
    var descriptor_index: Int
    
    override class var infoBytes: Int {
        return 4
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        var poolData = data
        name_index = poolData.pop(2).toInt()
        descriptor_index = poolData.pop(2).toInt()
        super.init(tag, data)
    }
}
