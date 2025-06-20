//
//  FirestoreManager.swift
//  cubeTimer
//
//  Created by Oleksii on 11.06.2025.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

public final class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    private init() {}
    
    private var firestoreDB = Firestore.firestore()
    //both go as parameters to settings view from navbar
    @Published var newReceivedSharedRecords: [String : FirestoreSharedRecord] = [:] // (in settingsview) onReceive: add to message box
    @Published var seenSharedRecords: [String : FirestoreSharedRecord] = [:] // goes straight to WHOLE message box (both seen and unseen)
    
    private var newSharedRecordsListener: ListenerRegistration?
    
    @MainActor
    public func getSeenSharedRecordsFromFirestore() async { // called in view
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot get shared records from firestore. User is nil")
            return
        }
        do {
            print("Doing request on firestore for seen shared records")
            let snapshot = try await firestoreDB.collection("sharedRecords")
                .whereField("receiverEmail", isEqualTo: curUser.email as Any)
                .whereField("alreadySeen", isEqualTo: true as Any)
                .order(by: "lastUpdate", descending: true).getDocuments() // here fix
            
            try snapshot.documents.forEach {doc in
                let sharedRecord = try doc.data(as: FirestoreSharedRecord.self)
                self.seenSharedRecords[doc.documentID] = sharedRecord
            }
            print("Snapshot documents count: \(snapshot.documents.count)")
            
        } catch {
            print("Error getting seen shared records: \(error)")
        }
    }
    
    public func addUserToFirestoreAfterLogin() async {
        do {
            guard let curUser = Auth.auth().currentUser else {
                print("Cannot add user to firestore. User is nil")
                return
            }
            try await firestoreDB.collection("users").document(curUser.uid).setData([
                "name": curUser.displayName ?? "Anonymous",
                "email": curUser.email ?? "Anonymous@example.com",
                "date": Date()
            ])
            print("User data successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    public func deleteUserFromFirestore() async {
        
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot delete user from firestore. User is nil")
            return
        }
        
        do {
          try await firestoreDB.collection("users").document(curUser.uid).delete()
          print("User data successfully removed!")
        } catch {
          print("Error removing user document: \(error)")
        }
    }
    
    @MainActor
    public func getAllUsers() async -> [FirestoreUser] {
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot get users from firestore. User is nil")
            return []
        }
        do {
            var users: [FirestoreUser] = []
            let snapshot: QuerySnapshot = try await firestoreDB.collection("users").getDocuments()
            try snapshot.documents.forEach { u in
                print(u.data())
                if u["email"] as? String != curUser.email { //
                    let user = try u.data(as: FirestoreUser.self)
                    users.append(user)
                }
            }
            return users
            
        }
        catch {
            print("Error getting users from firebase: \(error)")
            return []
        }
    }
    
    private func sharedRecordExists(for receiverUser: String, _ dis: Discipline) async -> String? {
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot check if shared record exists. User is nil")
            return nil
        }
        do {
            let snapshot = try await firestoreDB.collection("sharedRecords")
                .whereField("receiverEmail", isEqualTo: receiverUser as Any)
                .whereField("senderEmail", isEqualTo: curUser.email as Any)
                .whereField("bestSingle.discipline", isEqualTo: Puzzlenames[dis] as Any)
                .getDocuments()
            
            if snapshot.documents.isEmpty {
                return nil
            }
            return snapshot.documents.first?.documentID
            
        } catch {
            print("Error cheching if shared record exists: \(error)")
            return nil
        }
    }
    
    //(dis: Discipline, completion: @escaping ([String : Record?]) -> Void) -> Void
    public func createSharedRecords(receiverEmail: String, for discipline: Discipline,
    _ getRecordsForDiscipline: @escaping (Discipline, @escaping ([String : Record?]) -> Void) async -> Void)
    async -> Bool { // MARK: added check if shared record to the same user with the same discipline already exists
        var ress: Bool = false
        return await Task.detached(priority: .utility) {
            guard let curUser = Auth.auth().currentUser else {
                print("Cannot add share records to firestore. User is nil")
                return false
            }
            guard receiverEmail != curUser.email else {
                print("Cannot share records with yourself")
                return false
            } // maybe redundant
            
            await getRecordsForDiscipline(discipline) { res in //
                Task {
                    do {
                        let ao12Solves = res["ao12"]??.solves?.array as? [Solve]
                        let dictSolvesAO12: [[String: Any]] = self.getDictFromSolvesArr(ao12Solves ?? [])
                        
                        let ao5Solves = res["ao5"]??.solves?.array as? [Solve]
                        let dictSolvesAO5: [[String: Any]] = self.getDictFromSolvesArr(ao5Solves ?? [])
                        
                        let singleSolve = res["single"]??.solves?.array.first as? Solve
                        let dictSingle = ["result": singleSolve?.result as Any, "scramble": singleSolve?.scramble as Any]
                        
                        let docID: String? = await self.sharedRecordExists(for: receiverEmail, discipline) // here
                    
                        try await self.firestoreDB.collection("sharedRecords").document(docID ?? UUID().uuidString).setData([
                            "bestAO12": [
                                "date": res["ao12"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["ao12"]??.result as Any,
                                "solves": dictSolvesAO12
                            ],
                            "bestAO5": [
                                "date": res["ao5"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["ao5"]??.result as Any,
                                "solves": dictSolvesAO5
                            ],
                            "bestSingle": [
                                "date": res["single"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["single"]??.result as Any,
                                "solve": dictSingle
                            ],
                            "lastUpdate": Date() as Any,
                            "receiverEmail": receiverEmail,
                            "senderEmail": curUser.email as Any, //
                            "alreadySeen": false as Any //
                        ])
                        print("Shared records document added successfully")
                        ress = true
                    }
                    catch {
                        print("Error adding shared records to firestore: \(error)")
                        ress = false
                        return
                    }
                }
            }
            return ress
        }.value
    }
    
    private func getDictFromSolvesArr(_ solves: [Solve]) -> [[String: Any]] {
        var dictSolves: [[String: Any]] = []
        for solve in solves {
            dictSolves.append(["result": solve.result as Any, "scramble": solve.scramble as Any])
        }
        return dictSolves
    }
    
    private func addSharedRecordsListener() -> (any ListenerRegistration)? {
        
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot create firestore listener: user is not logged in")
            return nil
        }
        
        return firestoreDB.collection("sharedRecords") // started
        .whereField("receiverEmail", isEqualTo: curUser.email as Any)
        .whereField("alreadySeen", isEqualTo: false as Any)
        .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("Error fetching documents: \(error!)")
              return
            }
            do {
                if !documents.isEmpty {
                    try documents.forEach {doc in
                        let sharedRecord = try doc.data(as: FirestoreSharedRecord.self)
                        self?.newReceivedSharedRecords[doc.documentID] = sharedRecord
                    }
                }
            } catch {
                print("Error decoding sharedRecords snapshot: \(error)")
            }
        }
        // listener.remove(whenCanceled: true)
    }
    
    public func startListeningForSharedRecords() {
        guard newSharedRecordsListener == nil else { return }
        newSharedRecordsListener = addSharedRecordsListener()
    }
    
    public func stopListeningForSharedRecords() {
        newSharedRecordsListener?.remove()
        newSharedRecordsListener = nil
        newReceivedSharedRecords.removeAll()
    }
    
    public func markSharedRecordsAsSeen() {
        // MARK: going to clear dictionary in settings view after user opens message box
        newReceivedSharedRecords.keys.forEach {sharedRecordID in
            Task {
                do {
                    try await firestoreDB.collection("sharedRecords")
                        .document(sharedRecordID).updateData(["alreadySeen": true])
                    print("Shared records documents successfully rewritten!")
                } catch {
                    print("Error getting seen shared records: \(error)")
                }
            }
        }
    }
    
    public func markSharedRecordAsSeen(for sharedRecordID: String) async {
        do {
            try await firestoreDB.collection("sharedRecords")
                .document(sharedRecordID).updateData(["alreadySeen": true])
            print("Shared records document successfully rewritten!")
        } catch {
            print("Error getting seen shared records: \(error)")
        }
    }
    
    //MARK: for testing purposes
    public func addTestSharedRecordForCurrentUser(for discipline: Discipline,
    _ getRecordsForDiscipline: @escaping (Discipline, @escaping ([String : Record?]) -> Void) async -> Void)
    async -> Bool {
        var ress: Bool = false
        return await Task.detached(priority: .utility) {
            guard let curUser = Auth.auth().currentUser else {
                print("Cannot add share records to firestore. User is nil")
                return false
            }
            
            await getRecordsForDiscipline(discipline) { res in //
                Task {
                    do {
                        let ao12Solves = res["ao12"]??.solves?.array as? [Solve]
                        let dictSolvesAO12: [[String: Any]] = self.getDictFromSolvesArr(ao12Solves ?? [])
                        
                        let ao5Solves = res["ao5"]??.solves?.array as? [Solve]
                        let dictSolvesAO5: [[String: Any]] = self.getDictFromSolvesArr(ao5Solves ?? [])
                        
                        let singleSolve = res["single"]??.solves?.array.first as? Solve
                        let dictSingle = ["result": singleSolve?.result as Any, "scramble": singleSolve?.scramble as Any]
                        
                        try await self.firestoreDB.collection("sharedRecords").document(UUID().uuidString).setData([
                            "bestAO12": [
                                "date": res["ao12"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["ao12"]??.result as Any,
                                "solves": dictSolvesAO12
                            ],
                            "bestAO5": [
                                "date": res["ao5"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["ao5"]??.result as Any,
                                "solves": dictSolvesAO5
                            ],
                            "bestSingle": [
                                "date": res["single"]??.date ?? Date() as Any,
                                "discipline": Puzzlenames[discipline] ?? "noPuzzle" as Any,
                                "result": res["single"]??.result as Any,
                                "solve": dictSingle
                            ],
                            "lastUpdate": Date() as Any,
                            "receiverEmail": curUser.email as Any,
                            "senderEmail": "user123@gmail.com" as Any, //
                            "alreadySeen": false as Any //
                        ])
                        print("Shared records document (test) added successfully")
                        ress = true
                    }
                    catch {
                        print("Error adding shared records to firestore (test): \(error)")
                        ress = false
                        return
                    }
                }
            }
            return ress
        }.value
    }

}

public struct FirestoreUser: Codable, Identifiable, Hashable {
    public let id = UUID()
    
    let date: Date
    let name: String
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case date
        case name
        case email
    }
}

public struct FirestoreSharedRecord : Codable, Hashable { // TODO: put discipline in just SHARED_RECORD.
    var alreadySeen: Bool
    
    let bestAO12: FirestoreBestAO?
    let bestAO5: FirestoreBestAO?
    let bestSingle: FirestoreBestSingle?
    
    let lastUpdate: Date
    let receiverEmail: String
    let senderEmail: String
}

public struct FirestoreBestAO : Codable, Hashable {
    let date: Date?
    let discipline: String
    let result: Double?
    let solves: [FirestoreSolve]
}

public struct FirestoreBestSingle: Codable, Hashable {
    let date: Date?
    let discipline: String
    let result: Double?
    let solve: FirestoreSolve?
}

public struct FirestoreSolve: Codable, Hashable {
    let result: Double
    let scramble: String
}
