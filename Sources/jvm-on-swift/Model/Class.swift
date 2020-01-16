import Foundation

class Class {
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
    
    let javaClasses: [JavaClass] = [
        .init(
            name: "java/lang/System",
            staticFields: [
                .init(
                    name: "out",
                    field: FileHandle.standardOutput
                )
            ],
            methods: []
        ),
        .init(
            name: "java/io/PrintStream",
            staticFields: [],
            methods: [
                .init(
                    name: "println",
                    invoke: ({ (_ args: Any...) in
                        let field = args[0] as! JavaStaticField
                        let out = field.field as! FileHandle
                        out.write(args[1] as! Data)
                    })
                )
            ]
        )
    ]
    
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

extension Class {
    func execute() {
        guard let mainMethod = findMainMethod() else {
            return
        }
        
        mainMethod
            .attributes
            .forEach({ attribute in
                executeCode(attribute.code)
            })
    }
    
    func executeCode(_ code: Data) {
        var indexStack: [Int] = []
        var codeData = code
        while var byte = codeData.popFirst() {
            let instruction = Data(bytes: &byte, count: 1).toInt()
            switch instruction {
            case 0x12:  // ldc
                indexStack.append(codeData.pop(1).toInt())
            case 0xb1:  // return
                return
            case 0xb2:  // getstatic
                indexStack.append(codeData.pop(2).toInt())
            case 0xb6:  // invokevirtual
                // Method
                let operand = codeData.pop(2).toInt()
                let methodRef = constant_pool[operand] as! ConstantPoolMethodref
                let methodClassInfo = constant_pool[methodRef.class_index] as! ConstantPoolClass
                let methodClassName = (constant_pool[methodClassInfo.name_index] as! ConstantPoolUtf8).str
                let methodNameAndType = constant_pool[methodRef.name_and_type_index] as! ConstantPoolNameAndType
                let methodName = (constant_pool[methodNameAndType.name_index] as! ConstantPoolUtf8).str
                let method = javaClasses
                    .first(where: {
                        $0.name == methodClassName
                    })!
                    .methods
                    .first(where: {
                        $0.name == methodName
                    })!
                
                // Args
                let desc = (constant_pool[methodNameAndType.descriptor_index] as! ConstantPoolUtf8).str
                var arg0: Data
                if desc.contains(";") {
                    let arg0Id = indexStack.popLast()!
                    let stringPool = constant_pool[arg0Id] as! ConstantPoolString
                    arg0 = (constant_pool[stringPool.string_index] as! ConstantPoolUtf8).info
                } else {
                    // TODO
                    arg0 = Data()
                }
                
                // Receiver
                let receiverId = indexStack.popLast()!
                let fieldRef = constant_pool[receiverId] as! ConstantPoolFieldref
                let fieldClassInfo = constant_pool[fieldRef.class_index] as! ConstantPoolClass
                let fieldClassName = (constant_pool[fieldClassInfo.name_index] as! ConstantPoolUtf8).str
                let fieldNameAndType = constant_pool[fieldRef.name_and_type_index] as! ConstantPoolNameAndType
                let fieldName = (constant_pool[fieldNameAndType.name_index] as! ConstantPoolUtf8).str
                let receiver = javaClasses
                    .first(where: {
                        $0.name == fieldClassName
                    })!
                    .staticFields
                    .first(where: {
                        $0.name == fieldName
                    })!
                
                method.invoke(receiver, arg0)
            default:
                fatalError("Unknown instruction \(String(format: "%02x", instruction))")
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
