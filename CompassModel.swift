import Foundation

class Compass: ObservableObject{
    @Published var pulseCount: Int
    @Published var pulseDuration: Int
    @Published var notes: [Note]
    
    init(pulseCount: Int, pulseDuration: Int, notes: [Note]) {
        self.pulseCount = pulseCount
        self.pulseDuration = pulseDuration
        self.notes = notes
    }
    
    // Computed variables
    var compassFormula : String {
        "\(pulseCount)/\(pulseDuration)"
    }
    var compassSize : Double {
        Double(pulseCount)/Double(pulseDuration)
    }
    var noteBeats : [Double] {
        var result : [Double] = []
        var sum : Double = 0
        for note in notes {
            result.append(sum)
            sum += note.duration
        }
        return result
    }
    var notesSize : Double {
        var totalDuration = 0.0
        for note in notes{
            totalDuration += note.duration
        }
        return totalDuration
    }
    var remainingSize : Double {
        compassSize - notesSize
    }
    
    // Public functions
    func AddNote(note: Note) -> Bool{
        if note.duration <= remainingSize{
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
