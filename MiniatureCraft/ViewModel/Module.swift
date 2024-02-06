/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The modules that the app can present.
*/


import Foundation

/// A description of the modules that the app can present.
enum Module: String, Identifiable, CaseIterable, Equatable {
    case world, immersiveWorld
    var id: Self { self }
    var name: String { rawValue.capitalized }
    
    var callToAction: String {
        switch self {
        case .world: "View World"
        case .immersiveWorld: "View Immersive World"
        }
    }
}
