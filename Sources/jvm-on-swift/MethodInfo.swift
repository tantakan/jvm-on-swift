import Foundation

struct MethodInfo {
    var access_flags: Data
    var name_index: Data
    var descriptor_index: Data
    var attributes_count: Int
    var attributes: [AttributeInfo]
    
    init(_ data: Data) {
        var methodInfoData = data
        access_flags = methodInfoData.pop(2)
        name_index = methodInfoData.pop(2)
        descriptor_index = methodInfoData.pop(2)
        attributes_count = methodInfoData.pop(2)
        attributes = []
    }
    
    mutating func addAttributeInfo(_ info: AttributeInfo) {
        attributes.append(info)
    }
}

struct AttributeInfo {
    var attribute_name_index: Data
    var attribute_length: Int
    var info: [UInt8]
    
    init(_ data: Data) {
        var attributeInfoData = data
        attribute_name_index = attributeInfoData.pop(2)
        attribute_length = attributeInfoData.pop(4)
        info = []
    }
    
    mutating func initInfo(_ info: Data) {
        self.info = [UInt8](info)
    }
}
