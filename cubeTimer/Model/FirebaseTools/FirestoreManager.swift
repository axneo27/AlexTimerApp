//
//  FirestoreManager.swift
//  cubeTimer
//
//  Created by Oleksii on 11.06.2025.
//

import FirebaseFirestore
import FirebaseAuth

public final class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    private init() {}
    
    private var firestoreDB = Firestore.firestore()
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
    
}
