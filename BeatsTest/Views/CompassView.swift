import AVFoundation
import SwiftUI

struct CompassView: View {
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
        
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                    .foregroundStyle(.black)
                    .frame(width: 300, height: 350)
                VStack{
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
                    HStack{
                        ForEach (Selected, id: \.self){ selected in
                            VStack(spacing: 0){
                                Text(selected)
                                    .font(.system(size: CGFloat(40/Selected.count)))
                                    .foregroundStyle(.white)
                                Image("\(selected)-Nota")
                                    .resizable()
                                    .frame(width: CGFloat(40/Selected.count), height: CGFloat(40/Selected.count))
                            }
                        }
                    }
                    
                    
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
    }
}


#Preview {
    CompassView()
}
