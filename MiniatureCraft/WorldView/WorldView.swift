/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The globe content for a volume.
*/

import SwiftUI
import RealityKit
import RealityKitContent

/// The globe content for a volume.
struct WorldView: View {
    @Environment(ViewModel.self) private var model

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .controlPanelGuide, vertical: .top)) {
            World(
                animateUpdates: true
            )
            .environment(model)
//            .alignmentGuide(.controlPanelGuide) { context in
//                context[HorizontalAlignment.center]
//            }

            
//            GlobeControls()
//                .offset(y: -70)
        }
//        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .onChange(of: model.isWorldRotating) { _, isRotating in
            model.worldConfig.speed = isRotating ? 0.1 : 0
        }
        .onDisappear {
            model.isShowingWorld = false
        }
    }
}

extension HorizontalAlignment {
    /// A custom alignment to center the control panel under the globe.
    private struct ControlPanelAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    /// A custom alignment guide to center the control panel under the globe.
    static let controlPanelGuide = HorizontalAlignment(
        ControlPanelAlignment.self
    )
}

#Preview {
    WorldView()
        .environment(ViewModel())
}
