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
        
        constant_pool_count = classData.pop(2).toInt()
        var constant_pool: [ConstantPool] = [ConstantPool()]
        for _ in 1..<constant_pool_count {
            let tag = ConstantPoolTag(classData.pop(1).toInt())
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
        
        interfaces_count = classData.pop(2).toInt()
        var interfaces: [Data] = []
        for _ in 0..<interfaces_count {
            interfaces.append(classData.pop(2))
        }
        self.interfaces = interfaces
        
        fields_count = classData.pop(2).toInt()
        // TODO: Implement fields later
        fields = []
        
        methods_count = classData.pop(2).toInt()
        var methods: [MethodInfo] = []
        for _ in 0..<methods_count {
            var method = MethodInfo(classData.pop(8))
            for _ in 0..<method.attributes_count {
                let attribute = CodeAttributeInfo(classData.pop(6))
                attribute.initInfo(classData.pop(attribute.attribute_length))
                method.addAttributeInfo(attribute)
            }
            methods.append(method)
        }
        self.methods = methods
        
        attributes_count = classData.pop(2).toInt()
        var attributes: [AttributeInfo] = []
        for _ in 0..<attributes_count {
            let attribute = AttributeInfo(classData.pop(6))
            attribute.initInfo(classData.pop(attribute.attribute_length))
            attributes.append(attribute)
        }
        self.attributes = attributes
        
        guard "cafebabe" == magic.toHexString() else {
            fatalError("Illegal class data \(magic.toHexString())")
        }
        
        guard classData.popFirst() == nil else {
            fatalError("Parse error")
        }
    }
}

extension JavaClass {
    func execute() {
        // Class info
        constant_pool
            .compactMap({ pool -> ConstantPoolClass? in
                return pool as? ConstantPoolClass
            })
            .compactMap({ pool -> ConstantPoolUtf8? in
                return constant_pool[pool.name_index] as? ConstantPoolUtf8
            })
            .forEach({ pool in
                print(pool.str)
            })
        
        // Method info
        methods
            .compactMap({ method -> ConstantPoolUtf8? in
                return constant_pool[method.name_index] as? ConstantPoolUtf8
            })
            .forEach({ pool in
                print(pool.str)
            })
        
        guard let mainMethod = findMainMethod() else {
            return
        }
        
        print(mainMethod.attributes)
        mainMethod
            .attributes
            .forEach({ attribute in
                executeCode(attribute.code)
            })
    }
    
    func executeCode(_ code: Data) {
        printData(code)
        var codeData = code
        while var byte = codeData.popFirst() {
            let instruction = Data(bytes: &byte, count: 1).toInt()
            switch instruction {
            case 0x12:  // ldc
                let operand = codeData.pop(1)
                printData(operand)
            case 0xb1:  // return
                return
            case 0xb2:  // getstatic
                let operand = codeData.pop(2)
                printData(operand)
            case 0xb6:  // invokevirtual
                let operand = codeData.pop(2)
                printData(operand)
            default:
                fatalError("Unknown instruction \(instruction)")
            }
        }
    }
    
    func findMainMethod() -> MethodInfo? {
        return methods.first { method -> Bool in
            guard let pool = constant_pool[method.name_index] as? ConstantPoolUtf8 else {
                return false
            }
            return pool.str == "main"
        }
    }
}
