import Foundation

protocol AttributeInfoProtocol {
    var attribute_name_index: Int { get set }
    var attribute_length: Int { get set }
    var info: Data { get set }
    func initInfo(_ info: Data)
}

class AttributeInfo: AttributeInfoProtocol {
    var attribute_name_index: Int
    var attribute_length: Int
    var info: Data
    
    required init(_ data: Data) {
        var attributeInfoData = data
        attribute_name_index = attributeInfoData.pop(2).toInt()
        attribute_length = attributeInfoData.pop(4).toInt()
        info = Data()
    }
    
    func initInfo(_ info: Data) {
        self.info = info
    }
}

class CodeAttributeInfo: AttributeInfo {
    var max_stack: Data
    var max_locals: Data
    var code_length: Int
    var code: Data
    var exception_table_length: Int
    var exception_table: [ExceptionTable]
    var attributes_count: Int
    var attributes: [AttributeInfo]
    
    required init(_ data: Data) {
        max_stack = Data()
        max_locals = Data()
        code_length = 0
        code = Data()
        exception_table_length = 0
        exception_table = []
        attributes_count = 0
        attributes = []
        
        super.init(data)
    }
    
    override func initInfo(_ info: Data) {
        var codeData = info
        attribute_name_index = codeData.pop(2).toInt()
        attribute_length = codeData.pop(4).toInt()
        max_stack = codeData.pop(2)
        max_locals = codeData.pop(2)
        code_length = codeData.pop(4).toInt()
        code = codeData.pop(code_length)
        
        exception_table_length = codeData.pop(2).toInt()
        // TODO: Implement later
        exception_table = []
        
        attributes_count = codeData.pop(2).toInt()
        // TODO: Implement later
        attributes = []
    }
}

struct ExceptionTable {}
