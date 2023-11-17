import AVFoundation
import SwiftUI
//8==B

struct CompassView: View {
    @ObservedObject var time = TimeController.shared
    @ObservedObject var configController = ConfigController.shared
    @ObservedObject var compassController = CompassController()
    
    @State var mostrandoTela = 0
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        SwiftUI.Group{
            if RotationController.isShowMode(orientation: orientation){
                LandscapeView(compassController: compassController)
            }
            else {
                ZStack {
                    PortraitView(mostrandoTela: $mostrandoTela, compassController: compassController)
                        .transition(.opacity)
                    if mostrandoTela == 1 {
                        ConfigView(mostrandoTela: $mostrandoTela)
                            .transition(.move(edge: .trailing))
                    }
                }

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
                RotationController.forceScreenOrientation()
            }
            if RotationController.isValidOrientation(orientation: newOrientation) {
                orientation = newOrientation
                if (RotationController.isEditMode()) {
                    time.stopTimer()
                }
            }
            RotationController.shared.updateScreenRect()
        }
        .onAppear{
            orientation = RotationController.isValidOrientation() ? UIDevice.current.orientation : .portrait
        }
    }
}

#Preview {
    CompassView()
}
