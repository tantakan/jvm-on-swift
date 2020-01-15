import Foundation

struct JavaClass {
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
    let methods: [Data]
    let attributes_count: Int
    let attributes: Data
    
    init(_ data: Data) {
        var classData = data
        magic = classData.pop(4)
        minor_version = classData.pop(2)
        major_version = classData.pop(2)
        
        constant_pool_count = Int(classData.pop(2).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        var constant_pool: [ConstantPool] = []
        for _ in 1..<constant_pool_count {
            let tag = ConstantPoolTag(classData.pop())
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
        
        interfaces_count = Int(classData.pop(2).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        var interfaces: [Data] = []
        for _ in 0..<interfaces_count {
            interfaces.append(classData.pop(2))
        }
        self.interfaces = interfaces
        
        fields_count = Int(classData.pop(2).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        // TODO: Implement fields later
        fields = []
        
        methods_count = Int(classData.pop(2).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        var methods: [Data] = []
        print(methods_count)
        for _ in 0..<methods_count {
            methods.append(classData.pop(2))
        }
        self.methods = methods
        
        attributes_count = Int(classData.pop(2).compactMap({ String(format: "%02d", $0)}).joined()) ?? 0
        attributes = data
    }
}
