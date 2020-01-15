import Foundation

class ConstantPoolMethodref: ConstantPool {
    let class_index: Data
    let name_and_type_index: Data
    
    override class var infoBytes: Int {
        return 4
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        var tmpData = data
        class_index = tmpData.pop(2)
        name_and_type_index = tmpData.pop(2)
        super.init(tag, data)
    }
}
