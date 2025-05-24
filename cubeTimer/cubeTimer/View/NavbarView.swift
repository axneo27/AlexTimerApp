//
//  NavbarView.swift
//  cubeTimer
//
//  Created by Oleksii on 02.01.2025.
//
//
import SwiftUI
import Foundation

class SharedState: ObservableObject {
    @Published var solvesArray: [Solve] = []
    @Published var selectedTab: Int = 0
}

struct NavbarView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var themeManager = ThemeManager.shared
    @StateObject var sharedState = SharedState()
    
    var body: some View {
        TabView(selection: $sharedState.selectedTab) {
            ScrambleView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
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

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
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
            
            
        }
        .accentColor(.red)
    }

    private func fetchSolves() {
        do {
            try dataManager.fetchAllSolves { solves in
                sharedState.solvesArray = solves ?? []
                sharedState.solvesArray.sort{$0.date! < $1.date!}
            }
        } catch {
            print("Error fetching solves")
        }
    }
}

struct NavbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavbarView().environmentObject(DataManager.shared)
    }
}
