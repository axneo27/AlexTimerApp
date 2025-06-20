//
//  FirestoreRecordInfo.swift
//  cubeTimer
//
//  Created by Oleksii on 19.06.2025.
//
import SwiftUI

struct FirestoreRecordInfo: View {
    @State var record: FirestoreSharedRecord // lastUpdate, sender, discipline
    @Binding var recordPresented: FirestoreSharedRecord?
    var documentID: String
    var onTap: (String) async -> Void
    var onTap2: (String) -> Void
    
    var body: some View {
        VStack {
            Text("From: \(record.senderEmail)")
                .font(.system(size: 18))
            Text("Discipline: \(record.bestSingle?.discipline ?? "no Discipline")")
                .font(.system(size: 18))
            HStack {
                Text("Last update: ")
                    .font(.system(size: 18))
                Text(record.lastUpdate, format: Date.FormatStyle()
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year(.defaultDigits)
                    .hour(.twoDigits(amPM: .omitted))
                    .minute(.twoDigits)
                    .locale(Locale(identifier: "en_GB")))

                    .font(.system(size: 18))
            }
        }
        .overlay(alignment: .topLeading) {
            if record.alreadySeen == false {
                Image(systemName: "circle.fill")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.red)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { // here fix
            if recordPresented == nil {
                if !self.record.alreadySeen {
                    onTap2(documentID)
                    Task {
                        await onTap(documentID)
                    }
                }
                recordPresented = self.record
                self.record.alreadySeen = true
            }
        }
    }
}

struct FirestoreSharedRecord_Previews: PreviewProvider {
    static var sampleRecord: FirestoreSharedRecord! = .init(alreadySeen: false, bestAO12: nil, bestAO5: nil, bestSingle: FirestoreBestSingle(date: Date(), discipline: "3x3", result: 3.333, solve: FirestoreSolve(result: 4.4444, scramble: "R U R' U'")), lastUpdate: Date(), receiverEmail: "astrofymchuk@gmail.com", senderEmail: "friend@gmail.com")
    @State static var s: FirestoreSharedRecord? = nil
    static var f: (String) async -> Void = {_ in 
        
    }
    static var f2: (String) -> Void = {_ in
        
    }
    static var previews: some View {
        FirestoreRecordInfo(record: sampleRecord, recordPresented: $s, documentID: "adsfadsf", onTap: f, onTap2: f2)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
