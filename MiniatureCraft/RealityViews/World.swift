//
//  WorldView.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/22/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct World: View {
    @Environment(ViewModel.self) private var model
    var animateUpdates: Bool = true
    

    /// The Earth entity that the view creates and stores for later updates.
    @State private var worldEntity: WorldEntity?

    var body: some View {
        RealityView { content in
            // Create an earth entity with tilt, rotation, a moon, and so on.
            let worldEntity = await WorldEntity(
                configuration: model.worldConfig)
            content.add(worldEntity)

            // Store for later updates.
            self.worldEntity = worldEntity

        } update: { content in
            // Reconfigure everything when any configuration changes.
            worldEntity?.update(
                configuration: model.worldConfig,
                animateUpdates: animateUpdates)
        }
        .onChange(of: model.worldConfig.worldType) {
            Task {
                await worldEntity?.changeWorld(to: model.worldConfig)
            }
        }
        .dragRotation()
//        .border(Color.red) Good for debugging
        
    }
}

#Preview {
    World().environment(ViewModel())
}
