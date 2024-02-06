//
//  MiniatureCraftApp.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/20/24.
//

import SwiftUI
import RealityKitContent

@main
struct MiniatureCraftApp: App {
    
    @State private var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .defaultSize(width: 0.45, height: 0.4, depth: 0, in: .meters)
        
        
        WindowGroup(id: Module.world.name) {
            WorldView()
                .environment(model)
        }
        .windowStyle(.volumetric)
        .defaultSize(
            width: CGFloat(WorldEntity.Configuration.worldDefault.volumeSize.x),
            height: CGFloat(WorldEntity.Configuration.worldDefault.volumeSize.y),
            depth: CGFloat(WorldEntity.Configuration.worldDefault.volumeSize.z),
            in: .meters)
    
        ImmersiveSpace(id: Module.immersiveWorld.name) {
            ImmersiveWorldView()
        }.immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
    
    init() {
        RotationComponent.registerComponent()
        RotationSystem.registerSystem()
        SunPositionComponent.registerComponent()
        SunPositionSystem.registerSystem()
    }
}
