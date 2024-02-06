/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An entity that represents the Earth and all its moving parts.
*/

import RealityKit
import SwiftUI
import RealityKitContent

/// An entity that represents the Earth and all its moving parts.
class WorldEntity: Entity {
    
    // MARK: - Sub-entities
    
    /// The model that draws the Earth's surface features.
    private let rotator: Entity = Entity()
    public var world: ModelEntity = ModelEntity()
    private var entityAdjustment: SIMD3<Float> = .zero
    private var scaleFactor: Float = 0.3
    
    private var currentSunIntensity: Float? = nil
    
    
    // MARK: - Initializers
    /// Creates a new blank earth entity.
    @MainActor required init() {
        super.init()
    }

    init(
        configuration: Configuration
    ) async {
        super.init()
        
        // Load the earth and pole models.
        guard let scene = await RealityKitContent.entity(named: configuration.worldType.fileName) else { return }
        
        let world = RealityKitContent.findMainModelEntity(in: scene)
        
        if world != nil {
            self.world = world!
        } else {
            return
        }
        
        self.world.components.set(InputTargetComponent())
        self.world.generateCollisionShapes(recursive: true)
        // Attach to the Earth to a set of entities that enable axial
        // tilt and a configured amount of rotation around the axis.
        let world_bounds = self.world.model!.mesh.bounds.extents * self.world.scale
        let diagonal = sqrt(pow(world_bounds.x, 2) + pow(world_bounds.z, 2))
        self.scaleFactor = configuration.volumeSize.x / diagonal
        let y_shift = -1*world_bounds.y * self.scaleFactor * 0.55
        
        self.entityAdjustment = (SIMD3<Float>(0, y_shift, 0))
        
        rotator.addChild(self.world)
        
        rotator.generateCollisionShapes(recursive: true)
                // Give the rotator an InputTargetComponent.
        rotator.components.set(InputTargetComponent())
        
        self.addChild(rotator)
        
        // Attach the pole to the Earth to ensure that it
        // moves, tilts, rotates, and scales with the Earth.
        
        // The Moon's orbit isn't affected by the tilt of the Earth, so attach
        // the Moon to the root entity.
        
        // Configure everything for the first time.
        update(
            configuration: configuration,
            animateUpdates: false)
    }

    // MARK: - Updates
    
    /// Updates all the entity's configurable elements.
    ///
    /// - Parameters:
    ///   - configuration: Information about how to configure the Earth.
    ///   - animateUpdates: A Boolean that indicates whether changes to certain
    ///     configuration values should be animated.
    func update(
        configuration: Configuration,
        animateUpdates: Bool
    ) {
        
        world.sunPositionComponent = SunPositionComponent(Float(configuration.sunAngle.radians))
        
        // Set a static rotation of the tilted Earth, driven from the configuration.
        rotator.orientation = configuration.rotation
        
        // Set the speed of the Earth's automatic rotation on it's axis.
        if var rotation: RotationComponent = world.components[RotationComponent.self] {
            rotation.speed = configuration.currentSpeed
            world.components[RotationComponent.self] = rotation
        } else {
            world.components.set(RotationComponent(speed: configuration.currentSpeed))
        }
        
        if configuration.currentSunIntensity != currentSunIntensity {
            setSunlight(intensity: configuration.currentSunIntensity)
            currentSunIntensity = configuration.currentSunIntensity
        }
        
        // Scale and position the entire entity.
        move(
            to: Transform(
                scale: SIMD3(repeating: self.scaleFactor),
                rotation: orientation,
                translation: self.entityAdjustment + configuration.position),
            relativeTo: parent)
    }
}


func makeNonReflective(_ entity: Entity) {
    if var modelComponent = entity.components[ModelComponent.self] {
        for i in 0..<modelComponent.materials.count {
            var material = modelComponent.materials[i]

            // Check if the material is a SimpleMaterial and modify it
            if var simpleMaterial = material as? SimpleMaterial {
                simpleMaterial.metallic = MaterialScalarParameter(floatLiteral: 0.0) // Non-reflective
                simpleMaterial.roughness = MaterialScalarParameter(floatLiteral: 1.0) // Maximum roughness
                
                // Update the material in the array
                modelComponent.materials[i] = simpleMaterial
            }
        }

        // Update the ModelComponent of the entity
        entity.components[ModelComponent.self] = modelComponent
    }

    // Recursively modify child entities
    for child in entity.children {
        makeNonReflective(child)
    }
}

extension WorldEntity {
    func changeWorld(to newConfiguration: Configuration) async {
        // Remove the old world entity from the rotator to prepare for the new world.
        self.world.removeFromParent()

        // Load the new world model based on the new configuration.
        guard let newScene = await RealityKitContent.entity(named: newConfiguration.worldType.fileName) else {
            print("Failed to load the new world model.")
            return
        }
        
        guard let newWorld = RealityKitContent.findMainModelEntity(in: newScene) else {
            print("Failed to find the main model entity in the new world.")
            return
        }
        
        // Prepare the new world entity similar to the initialization process.
        newWorld.components.set(InputTargetComponent())
        newWorld.generateCollisionShapes(recursive: true)
        
        // Calculate the new scale factor and y_shift based on the new world bounds.
        let newWorldBounds = newWorld.model!.mesh.bounds.extents * newWorld.scale
        let newDiagonal = sqrt(pow(newWorldBounds.x, 2) + pow(newWorldBounds.z, 2))
        let newScaleFactor = newConfiguration.volumeSize.x / newDiagonal
        let newYShift = -1 * newWorldBounds.y * newScaleFactor * 0.55
        
        // Update entity adjustment for the new world entity.
        self.entityAdjustment = (SIMD3<Float>(0, newYShift, 0))
        self.scaleFactor = newScaleFactor
        
        // Update the world property and add the new world to the rotator.
        self.world = newWorld
        rotator.addChild(self.world)
        
        // Assuming rotator's collision shapes and input target component need to be updated as well.
        rotator.generateCollisionShapes(recursive: true)
        rotator.components.set(InputTargetComponent())
        
        // Update the rest of the entity hierarchy as needed, similar to the initial setup.
        // For example, if you have additional entities like moons or poles that depend on the world entity, update them here.
        
        // Finally, apply the new configuration to reflect any additional changes.
        update(configuration: newConfiguration, animateUpdates: true)
    }
}
