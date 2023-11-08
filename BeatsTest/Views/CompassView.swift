import AVFoundation
import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

func getNoteColor(name: String) -> Color{
    switch name{
    case "Semibreve":
        return .yellow
    case "Minima":
        return Color(red: 0.41, green: 0.84, blue: 0.34)
    case "Seminima":
        return Color(red: 0.15, green: 0.74, blue: 1)
    case "Colcheia":
        return Color(red: 0.84, green: 0.52, blue: 0.99)
    case "Semicolcheia":
        return Color(red: 0.87, green: 0.35, blue: 0.6)
    default:
        return .white
    }
}



struct CompassView: View {
    @State private var orientation = UIDeviceOrientation.unknown
    @ObservedObject var time: TimeController = TimeController.shared
    
    @State private var Selected: [String] = [""]
    @State private var SelectedBPM : String = "60"
    @State private var animation = 0.0
    
    let soundManager = SoundManager()
    @StateObject var compass = Compass(pulse: 4, pulseDuration: 4, notes: [])
    
    //Define as notas e o tempo respectivo de cada uma
//    let notas: [String:Double] = ["Semibreve" : 1, "Minima" : 1/2, "Seminima" : 1/4, "Colcheia" : 1/8, "Semicolcheia" : 1/16, "Fusa" : 1/32, "Semifusa" : 1/64, "Quartifusa" : 1/128]
    let notas: [Note] = [
        Note(name: "Semibreve", duration: 1),
        Note(name: "Minima", duration: 1/2),
        Note(name: "Seminima", duration: 1/4),
        Note(name: "Colcheia", duration: 1/8),
        Note(name: "Semicolcheia", duration: 1/16),
        Note(name: "Fusa", duration: 1/32),
        Note(name: "Semifusa", duration: 1/64),
        Note(name: "Quartifusa", duration: 1/128)
    ]

    var body: some View {
        let pulseStringBinding = Binding(
            get: {String(self.compass.pulse)},
            set: {
                self.compass.pulse = Int($0) ?? self.compass.pulse
                time.RepublishTimer()
            }
        )
        let pulseDurationStringBinding = Binding(
            get: {String(self.compass.pulseDuration)},
            set: {
                self.compass.pulseDuration = Int($0) ?? self.compass.pulseDuration
                time.RepublishTimer()
            }
        )
        
        Group{
            if orientation.isPortrait || orientation.isFlat{
                VStack{
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                            .foregroundStyle(.black)
                            .frame(width: 300, height: 350)
                        VStack{
                            Text("Espaços sobrando: \(compass.RemainingSize())")
                                .foregroundStyle(.white)
                            HStack{
                                Spacer()
                                TextField("", text: pulseStringBinding)
                                    .frame(width: 10)
                                    .foregroundStyle(.white)
                                Text("/")
                                    .foregroundStyle(.white)
                                TextField("", text: pulseDurationStringBinding)
                                    .frame(width: 10)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            Text("Tempo = \(Int(time.beats.truncatingRemainder(dividingBy: Double(compass.pulse))+1))")
                                .foregroundStyle(.white)
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach (Selected, id: \.self){ selected in
                                        VStack(spacing: 0){
                                            Text(selected)
                                                .font(.system(size: 10))
                                                .foregroundStyle(.white)
                                            Image("\(selected)-Nota")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                }
                            }.frame(width: 300)
                            
                            
                            ZStack{
                                Rectangle()
                                HStack{
                                    ForEach(1...compass.pulse, id: \.self) { i in
                                        Rectangle()
                                            .frame(width: 240/CGFloat(compass.pulse), height: 50)
                                            .foregroundStyle(.green)
                                            .opacity(Int(time.beats.truncatingRemainder(dividingBy: Double(compass.pulse))+1) == i ? 1.0 : 0.0)
                                    }
                                }
                            }
                            .frame(width: 270, height: 50)
                            .foregroundStyle(.white)
                        }
                    }
        //                    .dropDestination(for: String.self) { items, _ in
        //
        //                        print("Itens do drop: \(items)")
        //
        //                        let itemsSplit = items[0].components(separatedBy: ":")
        //
        //                        print(itemsSplit)
        //
        //                        Selected = itemsSplit.first ?? ""
        //
        //                        soundManager.stopAll()
        //
        //                        if Int(time.beats.truncatingRemainder(dividingBy: Double(compass.pulse))+1) == 1{
        //                            soundManager.playLoop(sound: .beat, split: itemsSplit.last ?? "", tempo: compass.CompassFormula(), check: 0)
        //                        }else {
        //                            soundManager.playLoop(sound: .beat, split: itemsSplit.last ?? "", tempo: compass.CompassFormula(), check: 0)
        //                        }
        //
        //
        //                        return true
        //                    }
                            .foregroundStyle(.black)
                            .frame(height: 400)
                    HStack{
                        Spacer()
                        TextField("BPM", text: $SelectedBPM)
                            .frame(width: 100)
                            .multilineTextAlignment(.center)
                            .disabled(true)
                        Button("-"){
                            SelectedBPM = String(Int(SelectedBPM)!-1)
                            time.setBeatsPerMinute(Double(SelectedBPM) ?? time.BPM)
                        }
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                        Button("+"){
                            SelectedBPM = String((Int(SelectedBPM) ?? Int(time.BPM))+1)
                            time.setBeatsPerMinute(Double(SelectedBPM) ?? time.BPM)
                        }
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(notas.sorted(by: {$0.duration > $1.duration }), id: \.self) { nota in

                                Image("\(nota.name)-Nota")
                                    .onTapGesture {
                                        if compass.AddNote(note: nota){
                                            Selected.append(nota.name)
                                        }
                                    }
                                    .draggable("\(String(nota.name)):\(String(nota.duration))")
                                    
                            }
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.bottom, 50)
                    .scrollIndicators(.hidden)
                }
                .frame(maxHeight: .infinity)
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
            } else if orientation.isLandscape{
                let screenSize = UIScreen.main.bounds
                ZStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)
                            .opacity(0.1)
                        HStack(){
                            Spacer()
                            ForEach((2...compass.pulse), id: \.self){ _ in
                                Rectangle()
                                    .stroke(Color(red: 0.61, green: 0.61, blue: 0.61), style: StrokeStyle(lineWidth: 1, dash: [3]))
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity)
                                Spacer()
                            }
                        }
                        HStack(alignment: .center, spacing: 5){
                            ForEach(compass.notes, id: \.self) { nota in
                                ZStack{
                                    Rectangle()
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 2))
                                        .cornerRadius(20)
                                        .foregroundStyle(getNoteColor(name: nota.name))
                                    VStack(spacing: 13){
                                        Circle()
                                            .frame(width: 30)
                                        Rectangle()
                                            .frame(height: 1)
                                            .padding(.horizontal, 10)
                                        Image("\(nota.name)")
                                            .colorInvert()
                                            .scaleEffect(0.7)
                                            .frame(height: 30)
                                            .padding(.top, 10)
                                    }
                                }
                                .frame(width: screenSize.width*0.75*(Double(compass.pulse) * nota.duration)/Double(compass.pulse), height: UIScreen.main.bounds.height*0.4)
//                                .frame(width: 370*(Double(compass.pulse) * nota.duration)/Double(compass.pulse), height: 104)
                            }
                            Spacer()
                                .frame(minWidth: 0)
                                .background(Color.green)
                        }
                        .padding(.horizontal, 13)
                    }
                    .frame(width: screenSize.width*0.8, height: screenSize.height*0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .circular))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            }
        }
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
