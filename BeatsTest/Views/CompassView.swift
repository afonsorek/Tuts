import AVFoundation
import SwiftUI
//8==B

struct CompassView: View {
    @ObservedObject var time = TimeController.shared
    @ObservedObject var configController = ConfigController.shared
    @ObservedObject var compassController = CompassController()
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        SwiftUI.Group{
            if configController.config.orientationLock || orientation.isLandscape{
                LandscapeView(compassController: compassController)
            }
            else if orientation.isPortrait || orientation.isFlat {
                PortraitView(compassController: compassController)
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
            if configController.config.orientationLock {
                configController.forceScreenOrientation()
            }
            if !(newOrientation.isFlat || newOrientation.rawValue == 2) {
                orientation = newOrientation
                
                if (!configController.config.orientationLock && newOrientation.isPortrait) {
                    time.stopTimer()
                }
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
