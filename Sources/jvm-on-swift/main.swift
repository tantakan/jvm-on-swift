import Foundation

private func main(arguments: [String]) {
    let arguments = arguments.dropFirst()
    guard let path = arguments.first, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        fatalError("Cannot load file")
    }
    Class(data).execute()
}

main(arguments: CommandLine.arguments)
