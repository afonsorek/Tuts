import AVFoundation
import SwiftUI
//8==B

struct CompassView: View {
    @ObservedObject var time = TimeController.shared
    @ObservedObject var compassController = CompassController()
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        SwiftUI.Group{
            if orientation.isPortrait || orientation.isFlat{
                PortraitView(compassController: compassController)
            }
            else if orientation.isLandscape{
                LandscapeView(compassController: compassController)
            }
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.15, green: 0.1, blue: 0.24), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.28, green: 0.19, blue: 0.46), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .onRotate { newOrientation in
            if !newOrientation.isFlat{
                orientation = newOrientation
            }
        }
        .onAppear{
            orientation = UIDevice.current.orientation
        }
    }
}

#Preview {
    CompassView()
}
