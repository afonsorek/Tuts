import AVFoundation
import SwiftUI

struct CompassView: View {
    @ObservedObject var time = TimeController.shared
    
    @State private var Selected: [String] = []
    @State private var SelectedBPM : String = "60"
    @State private var animation = 0.0
    
    let soundController = SoundController()
    @StateObject var compass = Compass(pulseCount: 4, pulseDuration: 4, notes: [])
    @State var lastBeat : Double = 0

    var body: some View {
        let pulseStringBinding = Binding(
            get: {String(self.compass.pulseCount)},
            set: {
                self.compass.pulseCount = Int($0) ?? self.compass.pulseCount
                time.RepublishTimer()
                lastBeat = 0
            }
        )
        let pulseDurationStringBinding = Binding(
            get: {String(self.compass.pulseDuration)},
            set: {
                self.compass.pulseDuration = Int($0) ?? self.compass.pulseDuration
                time.RepublishTimer()
                lastBeat = 0
            }
        )
        
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                    .foregroundStyle(.black)
                    .frame(width: 300, height: 350)
                VStack{
                    Text("Espaços sobrando: \(compass.remainingSize)")
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
                    Text("Tempo = \(time.beats.truncatingRemainder(dividingBy: Double(compass.pulseCount))+1)")
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
                            ForEach(1...compass.pulseCount, id: \.self) { i in
                                Rectangle()
                                    .frame(width: 240/CGFloat(compass.pulseCount), height: 50)
                                    .foregroundStyle(.green)
                                    .opacity(Int(time.beats.truncatingRemainder(dividingBy: Double(compass.pulseCount))+1) == i ? 1.0 : 0.0)
                            }
                        }
                    }
                    .frame(width: 270, height: 50)
                    .foregroundStyle(.white)
                }
            }
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
                    ForEach(NotesData.notes.sorted(by: {$0.duration > $1.duration }), id: \.self) { nota in

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
        .onAppear {
            time.timerListeners.append({beat in
                let truncatedBeat = beat.truncatingRemainder(dividingBy: Double(compass.pulseCount))
                for noteBeat in compass.noteBeats {
                    if truncatedBeat/Double(compass.pulseDuration) == noteBeat {
                        soundController.playBeat()
                    }
                }
            })
        }
    }
}


#Preview {
    CompassView()
}
