import SwiftUI
import Combine

struct CarouselView: View {
    
    let worldTypes: [WorldType] = WorldType.allCases
    
    @Environment(ViewModel.self) private var model
    @State private var selectedWorldType: WorldType? = nil
    @State private var scrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var activeScrolling: Bool = false
    
    @State private var scrollDirection: CGFloat = 1.0
    
    @StateObject private var timerManager = TimerManager()

    private let itemWidth: CGFloat = 200
    private let itemSpacing: CGFloat = 20
    private let itemPadding: CGFloat = 10
    private var totalItemWidth: CGFloat { itemWidth + itemSpacing + itemPadding}
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    func calcWorldType(_ offset: CGFloat, dir: CGFloat) -> Int {
        var newWorldTypeIndex = Int(floor( (scrollOffset-5) / totalItemWidth))
        if (scrollDirection > 0) {
            newWorldTypeIndex = Int(ceil( (scrollOffset-5) / totalItemWidth))
        }
        return newWorldTypeIndex
    }
    
    func calcOffset(_ worldTypeIndex: Int) -> CGFloat{
        return (totalItemWidth * CGFloat(worldTypeIndex)) - 5
    }
    
    func updateSelection(_ newType: WorldType, _ scrollViewReader: ScrollViewProxy) {
        if let index = worldTypes.firstIndex(of: newType) {
            print("Found index")
            if newType != self.selectedWorldType {
                print("Setting selection to index for type \(newType)")
                withAnimation {
                    scrollViewReader.scrollTo(index, anchor: .center)
                }
                scrollOffset = calcOffset(index)
                scrollDirection = 0
                
                self.selectedWorldType = newType
                
            }
        }
    }
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollViewReader in
                    HStack(spacing: itemSpacing) {
                        ForEach(worldTypes.indices, id: \.self) { index in
                            ZStack(alignment: .center) { // Wrap the ItemView in a ZStack
                                // Use GeometryReader to read the frame of the content within ZStack if needed
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(self.selectedWorldType == worldTypes[index] ? Color.white : Color.gray, lineWidth: 2) // Customize the border color and line width here
                                    .frame(width: itemWidth+itemPadding, height: itemWidth+itemPadding)
                                    .onTapGesture {
                                        withAnimation {
                                            scrollViewReader.scrollTo(index, anchor: .center)
                                            activeScrolling = false
                                        }
                                        model.worldConfig.worldType = worldTypes[index]
                                        self.selectedWorldType = worldTypes[index]
                                    }
                                
                                GeometryReader { itemGeometry in
                                    ItemView(worldType: worldTypes[index], orientation: [0, 0, 0])
                                        .frame(width: itemWidth, height: itemWidth)
                                        .onTapGesture {
                                            withAnimation {
                                                scrollViewReader.scrollTo(index, anchor: .center)
                                                activeScrolling = false
                                            }
                                            model.worldConfig.worldType = worldTypes[index]
                                            self.selectedWorldType = worldTypes[index]
                                        }
                                        .id(index)
                                        .contentMargins(itemPadding)
                                }
                                .padding(itemPadding/2)
                                .frame(width: itemWidth+itemPadding, height: itemWidth+itemPadding) // Set the frame for the GeometryReader
                            }
                            .frame(width: itemWidth+itemPadding, height: itemWidth+itemPadding)
                        }
                    }
                    .onAppear {
                        // Pass bindings to the scrollOffset and lastScrollOffset
                        updateSelection(model.worldConfig.worldType, scrollViewReader)
                        
                        timerManager.setupTimer {
                            // This action is called when the timer detects what it considers the end of scrolling
                            guard let selectedWorldType = selectedWorldType else {return}
                            
                            if scrollOffset > lastScrollOffset {
                                scrollDirection = 1.0
                                activeScrolling = true
                            } else if scrollOffset < lastScrollOffset{
                                scrollDirection = -1.0
                                activeScrolling = true
                            }
                            
                            
                            let newWorldTypeIndex = calcWorldType(scrollOffset, dir: scrollDirection)
//                            print("Offset was \(scrollOffset), going in direction \(scrollDirection) and snappign to index \(newWorldTypeIndex)")
    
                            if scrollDirection != 0 {
                                
                                if newWorldTypeIndex >= 0 && newWorldTypeIndex < worldTypes.count {
                                    // Ensure the calculated index is within the bounds
                                    DispatchQueue.main.async {
                                        self.selectedWorldType = worldTypes[newWorldTypeIndex]
                                    }
                                }
                            }
//                                print("Scroll ended, selected index \(newWorldTypeIndex) from offset \(scrollOffset)")
                            
                            if lastScrollOffset == scrollOffset && Int(scrollOffset-5) % Int(totalItemWidth) != 0  && activeScrolling{
                                print("Scrolling to selection \(newWorldTypeIndex) siDude nce zero scroll direction and not in line up with offset of \(scrollOffset)")
                                withAnimation {
                                    scrollViewReader.scrollTo(newWorldTypeIndex, anchor: .center)
                                }
                                model.worldConfig.worldType = selectedWorldType
                                scrollOffset = calcOffset(newWorldTypeIndex)
                                print("Setting offset to \(scrollOffset)")
                                scrollDirection = 0
                            }
                            lastScrollOffset = scrollOffset
                            
                            
                        }
                    }
                    .padding(.horizontal, fullView.size.width / 2 - itemWidth / 2)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("ScrollView")).origin.x)
                    })
                    .onChange(of: model.worldConfig.worldType) {
                        updateSelection(model.worldConfig.worldType, scrollViewReader)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .gesture(
                DragGesture()
                    .onEnded { _ in
                        print("Drag ended")
                    }
            )
            .coordinateSpace(name: "ScrollView")
            .onPreferenceChange(ViewOffsetKey.self) { offset in
//                print("Changed offset to \(offset) in preferenceChnaged")
                scrollOffset = offset // Now this will be triggered with the correct scroll offset
            }
        }
        .frame(height: totalItemWidth+20)
    }
}

// PreferenceKey to store and update the ScrollView's offset
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

class TimerManager: ObservableObject {
    var timer: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    var cancellable: Set<AnyCancellable> = []
    
    func setupTimer(action: @escaping () -> Void) {
        timer.autoconnect()
            .sink { _ in
                action()
            }
            .store(in: &cancellable)
    }
}
