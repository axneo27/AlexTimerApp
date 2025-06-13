//
//  SettingsView.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct SettingsView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var inspectionData = InspectionData.shared
    @ObservedObject var firestoreManager: FirestoreManager = .shared
    
    @State private var isMenuOpen = false
    @State private var err: String = ""
    
    @State private var isSignedIn = Auth.auth().currentUser != nil
    
    var body: some View {
        VStack {
            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: 60)
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(themeManager.currentTheme.secondaryColor.color)
            
            sectorName("Appearance")
            
            settingsSector(
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    VStack {
                        HStack {
                            Text("Themes")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                            Spacer()
                            Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                                .rotationEffect(.degrees(isMenuOpen ? 0 : 360))
                                .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                                .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                                .font(.headline)
                        }
                        .padding()

                        if isMenuOpen {
                            VStack(spacing: 8) {
                                themeButton(for: Theme1(), label: "Theme 1")
                                themeButton(for: Theme2(), label: "Theme 2")
                            }
                        }
                    }
                }
            )
            
            sectorName("Timer")
            
            settingsSector(
                Toggle(isOn: $inspectionData.inspectionEnabled) { 
                    Text("Enable 15-second inspection")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                }
                .padding()
            )
            
            sectorName("Network")
            
            Button(action: {
                print("clicked sign in")
                Task {
                    do {
                        print("do")
                        try await Authentication().googleOauth()
                    } catch AuthenticationError.runtimeError(let errorMessage) {
                        err = errorMessage
                        print(err)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "person.badge.key.fill")
                        .foregroundColor(isSignedIn ? .green : .gray)
                        .transition(.opacity)
                    Text(isSignedIn ? "Signed In" : "Sign in with Google")
                }.padding(8)
            }
            .buttonStyle(.borderedProminent)
            .tint(themeManager.currentTheme.secondaryColor.color)
            
            Button(action: {
                print("clicked sign out")
                Task {
                    await firestoreManager.deleteUserFromFirestore()
                    let firebaseAuth = Auth.auth()
                        do {
                            GIDSignIn.sharedInstance.signOut()
                            try await GIDSignIn.sharedInstance.disconnect()
                            
                            try firebaseAuth.signOut()
                            
                            print("Successfully signed out")
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                }
            }) {
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.white)
                        .transition(.opacity)
                    Text("Sign out")
                }.padding(8)
            }
            .buttonStyle(.borderedProminent)
            .tint(themeManager.currentTheme.secondaryColor.color)
            
            ShareRecordsButton(action: {
                //
            }, color: themeManager.currentTheme.secondaryColor.color)
            
            Spacer()
            
            
        }
        .onAppear {
            let _ = Auth.auth().addStateDidChangeListener { _, user in
                isSignedIn = user != nil
            }
        }
    }
    
    private func settingsSector(_ content: some View) -> some View {
        VStack {
            content
        }
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: 320)
    }

    private func themeButton(for theme: Theme, label: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                themeManager.changeTheme(to: theme)
                isMenuOpen = false
            }
        }) {
            HStack {
                Text(label)
                    .foregroundColor(theme.secondaryColor.color)
                    .font(.headline)
                Spacer()
                Image(systemName: "bookmark.fill")
                    .foregroundColor(theme.secondaryColor.color)
            }
            .padding()
            .background(.gray.opacity(0.05))
        }
    }
    
    private func searchUserList() -> some View {
        Text("users")
    }
    
    private func sectorName(_ str: String) -> some View {
        HStack {
            Text(str)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 55)
                .padding()
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var userLoggedIn: Bool = false
    static var previews: some View {
        SettingsView()
    }
}
