//
//  NavbarView.swift
//  cubeTimer
//
//  Created by Oleksii on 02.01.2025.
//
//

import SwiftUI
import Foundation
import FirebaseAuth
import GoogleSignIn

@MainActor  // main thread
class SharedState: ObservableObject {
    @Published var solvesArray: [Solve] = []
    @Published var selectedTab: Int = 0
    @Published var userLoggedIn = (Auth.auth().currentUser != nil)
}

struct NavbarView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var themeManager = ThemeManager.shared
    @StateObject var firestoreManager: FirestoreManager = .shared
    @StateObject var sharedState = SharedState()
    
    var body: some View {
        TabView(selection: $sharedState.selectedTab) {
            ScrambleView()
                .tabItem {
                    Label("StopWatch", systemImage: "timer")
                }
                .tag(0)

            RecordsView()
                .tabItem {
                    Label("Records", systemImage: "square.grid.2x2")
                }
                .tag(1)
                .badge(dataManager.recordsCount)

            StatisticsView(solvesArray: $sharedState.solvesArray)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                }
                .tag(2)
                .badge(dataManager.solvesCount)
                .onOpenURL { url in
                    Task {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                }
            
            ReceivedRecordsView()
                .tabItem {
                    Label("Received", systemImage: "square.and.arrow.down")
                }
                .tag(3)
                .badge(firestoreManager.newReceivedSharedRecords.count)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(4)
        }
        .onReceive(dataManager.$solvesCount) { _ in
            fetchSolves()
        }
        .onAppear {
            fetchSolves()
            themeManager.loadCurrentTheme()

            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = themeManager.currentTheme.bgcolor.uiColor()
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            
            let _ = Auth.auth().addStateDidChangeListener { auth, user in
                Task {
                    if user != nil {
                        DispatchQueue.main.async {
                            sharedState.userLoggedIn = true
                            print(sharedState.userLoggedIn)
                        }
                        print("user is Logged in")
                        print(user?.email ?? "no email")
                        print(user?.displayName ?? "no displayName")
                        
                        await firestoreManager.addUserToFirestoreAfterLogin()
                        await firestoreManager.getSeenSharedRecordsFromFirestore()
                        
                        firestoreManager.startListeningForSharedRecords()
                    } else {
                        DispatchQueue.main.async {
                            sharedState.userLoggedIn = false
                            print(sharedState.userLoggedIn)
                        }
                        firestoreManager.stopListeningForSharedRecords()
                        print("user is not Logged in")
                    }
                }
            }
        }
    }

    @MainActor
    private func fetchSolves() {
        do {
            try dataManager.fetchAllSolves { solves in
                sharedState.solvesArray = solves ?? []
                sharedState.solvesArray.sort {
                    guard let date0 = $0.date, let date1 = $1.date else { return false }
                    return date0 < date1
                }
            }
        } catch {
            print("Error fetching solves")
        }
    }
}

extension UITabBarController { // 
    override open func viewDidLoad() {
        let standardAppearance = UITabBarAppearance()
        
        standardAppearance.stackedItemPositioning = .centered
        standardAppearance.stackedItemSpacing = 20
        standardAppearance.stackedItemWidth = 60
        
        tabBar.standardAppearance = standardAppearance
    }
}

struct NavbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavbarView().environmentObject(DataManager.shared)
    }
}

//nw_endpoint_flow_failed_with_error [C4 2a00:1450:401b:805::200a.443 failed parent-flow (unsatisfied (No network route))] already failing, returning
//nw_connection_get_connected_socket_block_invoke [C4] Client called nw_connection_get_connected_socket on unconnected nw_connection
//TCP Conn 0x12c474400 Failed : error 0:50 [50] sometimes ????
