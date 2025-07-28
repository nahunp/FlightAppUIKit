import Foundation

struct OpenSkyResponseDTO: Decodable {
    let time: Int
    let states: [[Any?]]
}
