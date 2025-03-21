//
//  NavbarView.swift
//  cubeTimer
//
//  Created by Oleksii on 02.01.2025.
//
//
import SwiftUI
import Foundation

//class SharedState: ObservableObject {
//    @Published var solvesArray: [Solve] = []
//    @Published var selectedTab: Int = 0
//}
//
//struct NavbarView: View {
//    @EnvironmentObject var dataManager: DataManager
//    @StateObject var themeManager = ThemeManager.shared
//    @StateObject var sharedState = SharedState()
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Group {
//                if sharedState.selectedTab == 0 {
//                    ScrambleView()
//                } else if sharedState.selectedTab == 1 {
//                    RecordsView()
//                } else if sharedState.selectedTab == 2 {
//                    StatisticsView(solvesArray: $sharedState.solvesArray)
//                } else if sharedState.selectedTab == 3 {
//                    SettingsView()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//            HStack {
//                TabBarButton(icon: "timer", label: "Timer", tab: 0, selectedTab: $sharedState.selectedTab)
//                TabBarButton(icon: "square.grid.2x2", label: "Records", tab: 1, selectedTab: $sharedState.selectedTab)
//                TabBarButton(icon: "chart.bar.xaxis", label: "Statistics", badge: dataManager.solvesCount, tab: 2, selectedTab: $sharedState.selectedTab)
//                TabBarButton(icon: "gearshape", label: "Settings", tab: 3, selectedTab: $sharedState.selectedTab)
//            }
//            .padding(.vertical, 8)
//            .background(Color(red: 16 / 255, green: 17 / 255, blue: 18 / 255))
//        }
//        .onReceive(dataManager.$solvesCount, perform: { _ in
//            fetchSolves()
//        })
//        .onAppear {
//            fetchSolves()
//            themeManager.loadCurrentTheme()
//        }
//        .accentColor(.red)
//    }
//
//    private func fetchSolves() {
//        do {
//            try dataManager.fetchAllSolves { solves in
//                sharedState.solvesArray = solves ?? []
//            }
//        } catch {
//            print("Error fetching solves")
//        }
//    }
//}
//
//struct TabBarButton: View {
//    let icon: String
//    let label: String
//    var badge: Int? = nil
//    let tab: Int
//    @Binding var selectedTab: Int
//
//    var body: some View {
//        Button(action: {
//            selectedTab = tab
//        }) {
//            VStack {
//                ZStack(alignment: .topTrailing) {
//                    Image(systemName: icon)
//                        .font(.system(size: 35))
//                    if let badge = badge, badge > 0 {
//                        Text("\(badge)")
//                            .font(.system(size: 13))
//                            .padding(4)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .clipShape(Circle())
//                            .offset(x: 8, y: -6)
//                    }
//                }
//                Text(label)
//                    .font(.system(size: 12))
//            }
//            .foregroundColor(selectedTab == tab ? .red : .gray)
//            .frame(maxWidth: .infinity)
//        }
//    }
//}

class SharedState: ObservableObject {
    @Published var solvesArray: [Solve] = []
    @Published var selectedTab: Int = 0
}

struct NavbarView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var themeManager = ThemeManager.shared
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
            UITabBar.appearance().backgroundColor = themeManager.currentTheme.bgcolor.uiColor()
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
        .accentColor(.red)
    }

    private func fetchSolves() {
        do {
            try dataManager.fetchAllSolves { solves in
                sharedState.solvesArray = solves ?? []
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
