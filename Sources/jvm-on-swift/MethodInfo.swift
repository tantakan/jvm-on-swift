import Foundation

struct MethodInfo {
    var access_flags: Data
    var name_index: Data
    var descriptor_index: Data
    var attributes_count: Int
    var attributes: [Data]
}
