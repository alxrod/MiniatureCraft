//
//  ImmersiveWorldView.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/27/24.
//

import SwiftUI
import RealityKit

struct ImmersiveWorldView: View {
    @State private var entity: WorldEntity?

    var body: some View {
        contentView
            .task {
                await entity = WorldEntity(configuration: .worldDefault)
            }
    }

    @ViewBuilder
    private var contentView: some View {
        if let entity {
            RealityView { content in
                print("ADDING ENTITY")
//                let bounds = entity.world.model!.mesh.bounds.extents * entity.world.scale
//                // Position the object 2 meters in front of the user
//                // with the bottom of the object touching the floor.
                entity.position = SIMD3(0, 1.75, -2)
                print(entity.position)
                
                content.add(entity)
            }
            .enableMovingEntity(entity)
        } else {
            ProgressView()
        }
    }
}
