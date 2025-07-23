//
//  ReceivedRecordsView.swift
//  cubeTimer
//
//  Created by Oleksii on 18.06.2025.
//
import SwiftUI

struct ReceivedRecordsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @StateObject private var firestoreManager: FirestoreManager = .shared
    
    @State var offset: CGFloat = .zero
    private let defaultHeaderHeight: CGFloat = 65
    
    @State private var isRecordInfoPresented: Bool = false
    @State private var presentedRecord: FirestoreSharedRecord? = nil
    
    @State private var allReceivedRecords: [String : FirestoreSharedRecord] = [:]
//    ["44393A0D-FBB8-424A-883F-1F5F3A54CB9F": FirestoreSharedRecord(alreadySeen: false, bestAO12: nil, bestAO5: Optional(cubeTimer.FirestoreBestAO(date: Date(), discipline: "3x3", result: Optional(6.275000095367432), solves: [cubeTimer.FirestoreSolve(result: 7.215000152587891, scramble: "B2 L2 U\' B L F\' R\' L B F\' L B D R2 U D\' L\' R U D2 L B\' F\' L2 "), cubeTimer.FirestoreSolve(result: 6.414000034332275, scramble: "D2 F U B2 D\' R B\' L\' F U\' L2 R2 B U R2 D2 F B R L2 B2 R F\' U "), cubeTimer.FirestoreSolve(result: 6.196000099182129, scramble: "F\' R\' L\' B\' F\' D\' B F2 R\' U D F2 U\' D B2 U\' R F B\' D F B\' R U "), cubeTimer.FirestoreSolve(result: 5.264999866485596, scramble: "D B2 L D\' U\' R D B L D B\' U2 R B2 D2 L2 F D2 U\' L D F2 U B2 "), cubeTimer.FirestoreSolve(result: 6.215000152587891, scramble: "R L2 F\' U\' R2 L\' B\' U F B\' D2 F R2 B L D\' B2 F2 L2 B R L\' U2 R\' ")])), bestSingle: Optional(cubeTimer.FirestoreBestSingle(date: Date(), discipline: "3x3", result: Optional(5.264999866485596), solve: Optional(cubeTimer.FirestoreSolve(result: 5.264999866485596, scramble: "D B2 L D\' U\' R D B L D B\' U2 R B2 D2 L2 F D2 U\' L D F2 U B2 ")))), lastUpdate: Date(), receiverEmail: "astrofymchuk@gmail.com", senderEmail: "user123@gmail.com")]
    
    var body: some View {
        StickyHeader(defaultHeaderHeight: defaultHeaderHeight,
                                  offset: $offset,
                                  headerView: headerView,
                                  scrollView: scrollableView)
        .sheet(isPresented: $isRecordInfoPresented) {
            NavigationStack {
                if let pR = presentedRecord {
                    AddRecordInfo(bestSingle: pR.bestSingle, bestAO5: pR.bestAO5, bestAO12: pR.bestAO12, shownDiscipline: Puzzlenames.getByString(pR.bestSingle!.discipline)!)
                }
            }
            .presentationDetents([
                .fraction(0.7),
                .height(800)
            ])
        }
        .onAppear {
            Task {
                await firestoreManager.getSeenSharedRecordsFromFirestore()
            }
        }
        .onChange(of: presentedRecord) {newValue in
            if newValue != nil {
                isRecordInfoPresented = true
                //
            }
        }
        .onChange(of: isRecordInfoPresented) {newValue in
            if !newValue {
                presentedRecord = nil
            }
        }
        .onReceive(firestoreManager.$newReceivedSharedRecords) { newValue in
            print("received new shared records. count: \(newValue.count)")
            for (k, v) in newValue {
                allReceivedRecords[k] = v
            }
        }
        .onReceive(firestoreManager.$seenSharedRecords) { newValue in
            print("received seen shared records. count: \(newValue.count)")
            for (k, v) in newValue {
                allReceivedRecords[k] = v
                print(allReceivedRecords)
            }
        }
        
    }
    
    func headerView() -> some View {
        Text("Received")
            .frame(maxWidth: .infinity, minHeight: defaultHeaderHeight)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(themeManager.currentTheme.secondaryColor.color)
    }
    
    func scrollableView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(allReceivedRecords.keys.sorted(by: {allReceivedRecords[$0]!.lastUpdate > allReceivedRecords[$1]!.lastUpdate}), id: \.self) { docID in
                    VStack {
                        HStack {
                            Spacer()
                            FirestoreRecordInfo(record: allReceivedRecords[docID]!, recordPresented: $presentedRecord, documentID: docID, onTap: firestoreManager.markSharedRecordAsSeen, onTap2: removeNewReceivedRecord)
                            Spacer()
                        }
                        .padding(15)
                    }
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(maxWidth: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 20)
                    .frame(maxWidth: 350)
                }
            }
        }
    }
    
    func removeNewReceivedRecord(_ id: String) { //
        if let newReceived = firestoreManager.newReceivedSharedRecords[id] {
            firestoreManager.seenSharedRecords[id] = newReceived
            firestoreManager.newReceivedSharedRecords.removeValue(forKey: id)
        }
        
    }
}

#Preview {
    ReceivedRecordsView()
}
