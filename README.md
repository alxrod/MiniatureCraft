# Minecraft in the Vision Pro

[Notion: read the full descripton on my notion page here](https://marbled-tarn-a59.notion.site/Minecraft-in-the-Vision-Pro-fe7ecf8bc2364daabc11d02f76f8e023?pvs=4)

## Inspiration:

When I first got the Vision Pro on Friday, one of my favorite first experiences was the dinosaur demo. Getting a chance to see 3D models up close in such high resolution gives a sense of depth and intuitiveness I’ve never experienced before. 

Over the weekend I knew I wanted to do a project that leveraged 3D assets, but I am not an expert 3D designer so I knew I wasn’t going to be able to build all the necessary models in just a couple of days. Instead, I turned to my favorite video game growing up: [Minecraft](https://www.minecraft.net/en-us). Minecraft’s world generation did all of the heavy lifting of creating fascinating 3D models. All I had to do was write a script to convert world files into USDZ’s and build a visionOS app to showcase the awesome depth and detail in the models.

# Converting World Files into USDZ:

Currently, the workflow for converting Minecraft worlds is simple:

1. Log into Minecraft and find your world of choice
2. Use the Minecraft coordinate system to record the coordinates of opposite diagonals of the volume you want to bring into Vision Pro
3. Run my bash script `[convert_world.sh](https://github.com/alxrod/MiniatureCraft/blob/main/convert_world.sh)` to turn the world into a USDZ file
4. Add the file to the Xcode project and add it to the WorldTypes in `[MiniatureCraft/MiniatureCraft/Entities/WorldEntity+Configuration.swift](https://github.com/alxrod/MiniatureCraft/blob/main/MiniatureCraft/Entities/WorldEntity%2BConfiguration.swift)`

To create this conversion script, I relied on two main software packages.

- **[Jmc2Obj](https://www.jmc2obj.net/)** to convert Minecraft world files to .obj and .mtl files
- Apple’s [usdzconvert](https://developer.apple.com/augmented-reality/tools/) to then convert those object files into USDZ’s compatible with the Vision Pro

The conversion script provides all the necessary parameters for **Jmc2Obj** and **usdzconvert** to generate crisp Minecraft models with the correct material properties to look as they do in the game.

# Building the Vision Pro App

The app itself consists of two views: a window showing all available world models and a volume where you can interact with the models themselves.

The window embeds each model in a custom-built carousel letting you either tap on worlds to select them or scroll through and snap to whichever one you are looking at. Whenever you are ready to choose your world, clicking View World brings up a volume for you to inspect the environment

You can position the model wherever you want as well as use the spatial drag gesture to rotate the world around its Y axis. If you select a different world in the window, the volume will update to the new one while still maintaining its orientation.

# Technical Challenges in this Project:

- The conversion script had to be **tuned** specifically because Minecraft textures are meant to be **flat and non-reflective**
- Working with rotating the volume taught me how to work with **Spatial Drag Gestures** as well as how to **translate gesture movement into 3D rotation** around a specified axis (seen in the [DragRotationModifier.swift](https://github.com/alxrod/MiniatureCraft/blob/main/MiniatureCraft/WorldView/Modifiers/DragRotationModifier.swift) file adapted from the HelloWorld tutorial)
- I had to build the [CarouselView.swift](https://github.com/alxrod/MiniatureCraft/blob/main/MiniatureCraft/ItemView/CarouselView.swift) from the ground up.
    - The CarouselView shows a horizontal ScrollView of different Model3Ds of the worlds themselves
    - I designed it to have two key interactions:
        - **Look and tap gesture** to select one of the worlds
        - **Drag gestures** to slide through a horizontal scroll view that would then **snap** to the centered world and select it.
    - Getting both of these interactions to work fluidly in the VisionPro took a custom solution: ScrollViews do not let you apply DragGestures to measure how far you have dragged. This means that you could not calculate the offset to apply a snapping scroll effect to select worlds.
        - To solve this I built a **timer system paired with geometry readers** to check the geometry readers offset receptively and detect changes as a drag. From there I was able to convert an offset to the corresponding world in the horizontal view and apply the snaps.
- I also had to connect the 3d model shown in the volume to the App and Windows ViewModel and have reload logic to replace the volume’s world when you selected a different world in the window. This required having a separate parent entity to track rotation and an inner child world entity with the actual USDZ file that you could swap as you selected different worlds.

# Conclusions

- There is a lot of power in apps that rely on **generated 3D models. I**t is hard for a team of graphic designers to keep up with the pace engineers can build in this platform. I’m very excited to experiment with more generated models as well as **data visualization tasks** that can automatically turn data into 3D interactable models.
- 3D experiences in the headset have an unparalleled wow factor, in showing other people this demo and other 3D ones, it is what you can do with volumes and immersive spaces that really draw people in. When you put effort into making spatial gestures work well with the 3D volumes, it feels like magic. That is what truly feels like you are interacting with an entirely new kind of computer.

# **Thank you for reading up on my project!**