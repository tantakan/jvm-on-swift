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
