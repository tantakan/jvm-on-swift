import Foundation

class ConstantPoolNameAndType: ConstantPool {
    var name_index: Data
    var descriptor_index: Data
    
    override class var infoBytes: Int {
        return 4
    }
    
    required init(_ tag: ConstantPoolTag, _ data: Data) {
        var poolData = data
        name_index = poolData.pop(2)
        descriptor_index = poolData.pop(2)
        
        super.init(tag, data)
    }
}
