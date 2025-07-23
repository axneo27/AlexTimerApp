//
//  FirebaseAnalyticsManager.swift
//  cubeTimer
//
//  Created by Oleksii on 24.06.2025.
//

import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth

final class FirebaseAnalyticsManager {
    static let shared = FirebaseAnalyticsManager()
    private init() {}
    
    public func logShareEvent(_ receiver: String, _ discipline: Discipline) {
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot get shared records from firestore. User is nil")
            return
        }
        FirebaseAnalytics.Analytics.logEvent("records_shared", parameters: [
            "senderEmail": curUser.email ?? "unknown",
            "discipline": Puzzlenames[discipline]!,
            "receiverEmail": receiver
        ])
        print("LOGGED SHARE EVENT to Analytics")
    }
    
    public func logUserLogin() {
        guard let curUser = Auth.auth().currentUser else {
            print("Cannot get shared records from firestore. User is nil")
            return
        }
        FirebaseAnalytics.Analytics.logEvent("user_login", parameters: [
            "userEmail": curUser.email ?? "unknown"
        ])
        print("LOGGED USER LOGIN EVENT to Analytics")
    }
}
