import Foundation

class Compass: ObservableObject{
    @Published var pulse: Int
    @Published var pulseDuration: Int
    @Published var notes: [Note]
    
    init(pulse: Int, pulseDuration: Int, notes: [Note]) {
        self.pulse = pulse
        self.pulseDuration = pulseDuration
        self.notes = notes
    }
    
    func CompassFormula() -> String{
        return "\(pulse)/\(pulseDuration)"
    }
    
    func CompassSize() -> Double{
        return Double(pulse/pulseDuration)
    }
    
    func NotesSize() -> Double{
        var totalDuration = 0.0
        for note in notes{
            totalDuration += note.duration
        }
        return totalDuration
    }
    
    func RemainingSize() -> Double {
        CompassSize() - NotesSize()
    }
    
    func AddNote(note: Note) -> Bool{
        if note.duration <= RemainingSize(){
            notes.append(note)
            return true
        }else{
            print("Não cabeu")
            return false
        }
    }
    
    func RemoveNote(){
        notes.removeLast()
    }
    
    func RemoveAllNotes(){
        notes.removeAll()
    }
}
