import Foundation

private func main(arguments: [String]) {
    let arguments = arguments.dropFirst()
    guard let path = arguments.first, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        fatalError("Cannot load file")
    }
    let javaClass = JavaClass(data)
    javaClass.execute()
}

func printData(_ data: Data) {
    print(data.compactMap({ String(format: "%02x", $0)}).joined())
}

main(arguments: CommandLine.arguments)
