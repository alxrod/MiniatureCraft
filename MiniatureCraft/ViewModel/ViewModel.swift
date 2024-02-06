/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The stored data for the app.
*/

import SwiftUI

/// The data that the app uses to configure its views.
@Observable
class ViewModel {
    
    // MARK: - Navigation
    var navigationPath: [Module] = []
    var titleText: String = ""
    var isTitleFinished: Bool = false
    var finalTitle: String = "Hello World"

    // MARK: - World
    var isShowingWorld: Bool = false
    var worldConfig: WorldEntity.Configuration = .worldDefault
    
    var selectedWorldType: WorldType? = nil
    var isWorldRotating: Bool = false
    
    // MARK: - ImmersiveWorld
    var isShowingImmersiveWorld: Bool = false
    
}
