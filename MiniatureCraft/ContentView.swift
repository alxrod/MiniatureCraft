//
//  ContentView.swift
//  MiniatureCraft
//
//  Created by Alex Rodriguez on 1/20/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @Environment(ViewModel.self) private var model

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            Text("Check out your world!")
            CarouselView()
            WorldViewToggle()
        }
        .padding(70)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
