import Foundation

private func main(arguments: [String]) {
    let arguments = arguments.dropFirst()
    guard let path = arguments.first else {
        return
    }
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let jClass = JavaClass(data)
    printData(data)
    printData(jClass.this_class)
}

func printData(_ data: Data) {
    print(data.compactMap({ String(format: "%02x", $0)}).joined())
}

main(arguments: CommandLine.arguments)
