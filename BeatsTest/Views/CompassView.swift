import AVFoundation
import SwiftUI

struct CompassView: View {
    @ObservedObject var time = TimeController.shared
    @ObservedObject var compassController = CompassController()

    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                    .foregroundStyle(.black)
                    .frame(width: 300, height: 350)
                VStack{
                    Text("Espaços sobrando: \(compassController.compass.remainingSize)")
                        .foregroundStyle(.white)
                    HStack{
                        Spacer()
                        TextField("", text: compassController.pulseCountStringBinding)
                            .frame(width: 10)
                            .foregroundStyle(.white)
                        Text("/")
                            .foregroundStyle(.white)
                        TextField("", text: compassController.pulseDurationStringBinding)
                            .frame(width: 10)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Tempo = \(time.beats.truncatingRemainder(dividingBy: Double(compassController.compass.pulseCount))+1)")
                        .foregroundStyle(.white)
                    ScrollView(.horizontal){
                        HStack{
                            ForEach (compassController.compass.notes, id: \.self){ note in
                                VStack(spacing: 0){
                                    Text(note.name)
                                        .font(.system(size: 10))
                                        .foregroundStyle(.white)
                                    Image(note.imageName)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    }.frame(width: 300)
                    
                    
                    ZStack{
                        Rectangle()
                        HStack{
                            ForEach(1...compassController.compass.pulseCount, id: \.self) { i in
                                Rectangle()
                                    .frame(width: 240/CGFloat(compassController.compass.pulseCount), height: 50)
                                    .foregroundStyle(.green)
                                    .opacity(Int(time.beats.truncatingRemainder(dividingBy: Double(compassController.compass.pulseCount))+1) == i ? 1.0 : 0.0)
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
                Text(String(time.BPM))
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                Button("-"){
                    time.setBeatsPerMinute(time.BPM - 1)
                    time.resetTimer()
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
                .padding(.horizontal)
                Button("+"){
                    time.setBeatsPerMinute(time.BPM + 1)
                    time.resetTimer()
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

                        Image(nota.imageName)
                            .onTapGesture {
                                _ = compassController.addNote(note: nota)
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
