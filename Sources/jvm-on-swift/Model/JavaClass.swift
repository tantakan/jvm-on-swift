import Foundation

class JavaClass {
    let magic: Data
    let minor_version: Data
    let major_version: Data
    let constant_pool_count: Int
    let constant_pool: [ConstantPool]
    let access_flags: Data
    let this_class: Data
    let super_class: Data
    let interfaces_count: Int
    let interfaces: [Data]
    let fields_count: Int
    let fields: [Data]
    let methods_count: Int
    let methods: [MethodInfo]
    let attributes_count: Int
    let attributes: [AttributeInfo]
    
    init(_ data: Data) {
        var classData = data
        magic = classData.pop(4)
        minor_version = classData.pop(2)
        major_version = classData.pop(2)
        
        constant_pool_count = classData.pop(2)
        var constant_pool: [ConstantPool] = []
        for _ in 1..<constant_pool_count {
            let tag = ConstantPoolTag(classData.pop(1))
            let type = tag.infoType
            let constant = type.init(tag, classData.pop(type.infoBytes))
            constant_pool.append(constant)
            if constant.needMoreBytes != 0 {
                constant.loadMore(classData.pop(constant.needMoreBytes))
            }
        }
        self.constant_pool = constant_pool
        
        access_flags = classData.pop(2)
        this_class = classData.pop(2)
        super_class = classData.pop(2)
        
        interfaces_count = classData.pop(2)
        var interfaces: [Data] = []
        for _ in 0..<interfaces_count {
            interfaces.append(classData.pop(2))
        }
        self.interfaces = interfaces
        
        fields_count = classData.pop(2)
        // TODO: Implement fields later
        fields = []
        
        methods_count = classData.pop(2)
        var methods: [MethodInfo] = []
        for _ in 0..<methods_count {
            var method = MethodInfo(classData.pop(8))
            for _ in 0..<method.attributes_count {
                var attribute = AttributeInfo(classData.pop(6))
                attribute.initInfo(classData.pop(attribute.attribute_length))
                method.addAttributeInfo(attribute)
            }
            methods.append(method)
        }
        self.methods = methods
        
        attributes_count = classData.pop(2)
        var attributes: [AttributeInfo] = []
        for _ in 0..<attributes_count {
            var attribute = AttributeInfo(classData.pop(6))
            attribute.initInfo(classData.pop(attribute.attribute_length))
            attributes.append(attribute)
        }
        self.attributes = attributes
    }
}

extension JavaClass {
    func execute() {
        methods.forEach { method in
            let pool = constant_pool.first {
                ($0 as? ConstantPoolNameAndType)?.name_index == method.name_index
            }
            printData(pool!.info)
        }
    }
}
