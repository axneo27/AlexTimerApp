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
        firestoreManager.seenSharedRecords[id] = firestoreManager.newReceivedSharedRecords[id]!
        firestoreManager.newReceivedSharedRecords.removeValue(forKey: id)
    }
}

#Preview {
    ReceivedRecordsView()
}
