//
//  ImmersiveWorldToggle.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/28/24.
//

import SwiftUI

struct ImmersiveWorldToggle: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model

        Toggle(Module.immersiveWorld.callToAction, isOn: $model.isShowingImmersiveWorld)
            .onChange(of: model.isShowingImmersiveWorld) { _, isShowing in
                Task {
                    if isShowing {
                        await openImmersiveSpace(id: Module.immersiveWorld.name)
                    } else {
                        await dismissImmersiveSpace()
                    }
                }
            }
            .toggleStyle(.button)
    }
}

#Preview {
    ImmersiveWorldToggle()
        .environment(ViewModel())
}
