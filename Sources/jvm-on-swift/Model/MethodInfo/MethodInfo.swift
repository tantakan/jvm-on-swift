import Foundation

struct MethodInfo {
    var access_flags: Data
    var name_index: Int
    var descriptor_index: Int
    var attributes_count: Int
    var attributes: [AttributeInfo]
    
    init(_ data: Data) {
        var methodInfoData = data
        access_flags = methodInfoData.pop(2)
        name_index = methodInfoData.pop(2).toInt()
        descriptor_index = methodInfoData.pop(2).toInt()
        attributes_count = methodInfoData.pop(2).toInt()
        attributes = []
    }
    
    mutating func addAttributeInfo(_ info: AttributeInfo) {
        attributes.append(info)
    }
}
