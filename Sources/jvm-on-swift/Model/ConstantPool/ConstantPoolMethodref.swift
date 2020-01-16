import Foundation

class ConstantPoolMethodref: ConstantPool {
    let class_index: Int
    let name_and_type_index: Int
    
    override class var infoBytes: Int {
        return 4
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        var tmpData = data
        class_index = tmpData.pop(2).toInt()
        name_and_type_index = tmpData.pop(2).toInt()
        super.init(tag, data)
    }
}
