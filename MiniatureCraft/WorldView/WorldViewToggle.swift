//
//  WorldViewToggle.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/22/24.
//

import SwiftUI

/// A toggle that activates or deactivates the globe volume.
struct WorldViewToggle: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        @Bindable var model = model

        Toggle(Module.world.callToAction, isOn: $model.isShowingWorld)
            .onChange(of: model.isShowingWorld) { _, isShowing in
                if isShowing {
                    openWindow(id: Module.world.name)
                } else {
                    dismissWindow(id: Module.world.name)
                }
            }
            .toggleStyle(.button)
    }
}

#Preview {
    WorldViewToggle()
        .environment(ViewModel())
}
