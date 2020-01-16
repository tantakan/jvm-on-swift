import Foundation

struct JavaClass {
    let name: String
    let staticFields: [JavaStaticField]
    let methods: [JavaMethod]
}

struct JavaStaticField {
    let name: String
    let field: Any
}

struct JavaMethod {
    let name: String
    let invoke: ((_ args: Any...) -> Void)
}
