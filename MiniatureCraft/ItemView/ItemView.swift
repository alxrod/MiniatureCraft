//
//  ItemView.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 2/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

private let modelDepth: Double = 200

struct ItemView: View {
    var worldType: WorldType
    
    var orientation: SIMD3<Double> = .zero

    var body: some View {
        Model3D(named: worldType.fileName, bundle: realityKitContentBundle) { model in
            model.resizable()
                .scaledToFit()
                .rotation3DEffect(
                    Rotation3D(
                        eulerAngles: .init(angles: orientation, order: .xyz)
                    )
                )
                .frame(depth: modelDepth)
                .offset(z: -modelDepth / 2)
                .accessibilitySortPriority(1)
        } placeholder: {
            ProgressView()
                .offset(z: -modelDepth * 0.75)
        }
    }
}
