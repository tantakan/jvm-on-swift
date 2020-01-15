import Foundation

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
