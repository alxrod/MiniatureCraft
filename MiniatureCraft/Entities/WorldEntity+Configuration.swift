//
//  WorldEntity+Configuration.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/22/24.
//

import SwiftUI


extension WorldEntity {
    /// Configuration information for Earth entities.
    struct Configuration {

        var worldType: WorldType
        var rotation: simd_quatf = .init(angle: 0, axis: [0, 1, 0])
        var speed: Float = 0
        var isPaused: Bool = false
        var position: SIMD3<Float> = .zero
        var volumeSize: SIMD3<Float> = SIMD3(0.6,0.55,0.6)
    
        var showSun: Bool = true
        var sunIntensity: Float = 13
        var sunAngle: Angle = .degrees(90)

        var currentSpeed: Float {
            isPaused ? 0 : speed
        }
        
        var currentSunIntensity: Float? {
            showSun ? sunIntensity : nil
        }
        
        mutating func setPosition(_ newPosition: SIMD3<Float>) {
            position = newPosition
        }
        
        static var worldDefault: Configuration = .init(worldType: WorldType.spruce_mountain)

    }

}

enum WorldType: String, Identifiable, CaseIterable, Equatable {
    case village, jungle, spruce_mountain, mansion, desert
    var id: Self { self }
    
    var fileName: String { rawValue }
    
    var displayName: String {
        switch self {
        case .jungle: "The Jungle"
        case .village: "The Village"
        case .spruce_mountain: "A Spruce Mountain"
        case .mansion: "The Mansion"
        case .desert: "The Desert"
        }
    }
    
    var description: String {
        switch self {
        case .jungle: "A wild jungle full of bamboo, massive trees, vines, and leaves"
        case .village: "A quiet village sprawling across a field"
        case .spruce_mountain: "A tail mountain admist a spruce forest with cascading waterfalls and snow"
        case .mansion: "An ominous mansion deep in a dark forest"
        case .desert: "The Desert"
        }
    }
}




