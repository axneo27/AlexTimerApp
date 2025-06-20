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
    @EnvironmentObject var dataManager: DataManager
    
    @State private var isMenuOpen = false
    @State private var err: String = ""
    
    @State private var isSignedIn = Auth.auth().currentUser != nil
    @State private var isShowingUsersList: Bool = false
    
    @State private var usersList: [FirestoreUser] = []
    
    @State private var selectedUserReceiver: FirestoreUser?
    @State private var selectedDisciplineToShare: Discipline = .all
    
    @State var offset: CGFloat = .zero
    private let defaultHeaderHeight: CGFloat = 65
    
    @State private var showNoUserSelected: Bool = false
    
    var body: some View {
        StickyHeader(defaultHeaderHeight: defaultHeaderHeight,
                                  offset: $offset,
                                  headerView: headerView,
                                  scrollView: scrollableView)
//        .onChange(of: selectedUserReceiver) { newValue in
//            print(newValue?.email ?? "")
//        }
        .onReceive(firestoreManager.$newReceivedSharedRecords, perform: {newReceivedRecords in
            
        })
        .alert(isPresented: $showNoUserSelected, content: {
            Alert(title: Text("No receiver selected"),
                  message: Text("Please select a user receiver"),
                  dismissButton: .default(Text("OK"), action: {}))
        })
        .onAppear {
            let _ = Auth.auth().addStateDidChangeListener { _, user in
                isSignedIn = user != nil
            }
        }
    }
    
    func headerView() -> some View {
        Text("Settings")
            .frame(maxWidth: .infinity, minHeight: defaultHeaderHeight)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(themeManager.currentTheme.secondaryColor.color)
    }
    
    func scrollableView() -> some View {
        ScrollView {
            VStack {
                
                sectorName("Appearance")
                    .padding(.top, 10)
                
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
                
                ClickableButton(text: isSignedIn ? "Signed In" : "Sign in with Google",
                action: signInGoogle, color: themeManager.currentTheme.secondaryColor.color,
                image: "person.badge.key.fill", imageColor: isSignedIn ? .green : .gray)
                
                ClickableButton(text: "Sign out",
                action: signOut, color: themeManager.currentTheme.secondaryColor.color,
                                image: "door.left.hand.open")
                
                HStack {
                    ClickableButton(text: isShowingUsersList ? "Cancel" : "Share records", action: {
                        withAnimation {
                            if isShowingUsersList {
                                cancel()
                            }
                            else {
                                shareRecords()
                            }
                        }
                    }, color: themeManager.currentTheme.secondaryColor.color, image: isShowingUsersList ? "xmark.circle.fill" : "square.and.arrow.up",
                                    imageColor: isShowingUsersList ? .red : .white)
                    
                    if isShowingUsersList { // SUBMIT
                        ClickableButton(text: "Submit", action: submit, color: themeManager.currentTheme.secondaryColor.color, image: "checkmark.circle.fill", imageColor: .green)
                        .transition(.asymmetric(insertion: .slide, removal: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: isShowingUsersList)
                    }
                }
                
                // Button("testShare", action: {
                //     print("clicked test")
                //     Task {
                //         await firestoreManager.addTestSharedRecordForCurrentUser(for: .three, dataManager.getRecordsForDiscipline)
                //     }
                // })
                
                if isShowingUsersList {
                    VStack {
                        PuzzleMenu(Puzzle: $selectedDisciplineToShare)
                        searchUserList()
                    }
                    .padding(.bottom, 80)
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: isShowingUsersList)
                }
                
                
                Spacer()
                
            }
        }
    }
    
    private func submit() {
        if selectedUserReceiver == nil {
            showNoUserSelected = true
            return //
        }
        Task {
             let _ = await firestoreManager.createSharedRecords(receiverEmail: selectedUserReceiver?.email ?? "noEmail" , for: selectedDisciplineToShare, dataManager.getRecordsForDiscipline)
            isShowingUsersList = false
        }
    }
    
    private func cancel() {
        selectedUserReceiver = nil
        selectedDisciplineToShare = .all
        isShowingUsersList = false
    }
    
    private func shareRecords() {
        Task {
            usersList = await firestoreManager.getAllUsers()
            selectedDisciplineToShare = .three
            isShowingUsersList = true
        }
    }
    
    private func signInGoogle() {
        print("clicked sign in")
        Task {
            do {
                print("signing in...")
                try await Authentication().googleOauth()
            } catch AuthenticationError.runtimeError(let errorMessage) {
                err = errorMessage
                print(err)
            }
        }
    }
    
    private func signOut() {
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
        UsersSearchList(usersList, $selectedUserReceiver)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .frame(maxWidth: 320, minHeight: 400)
            .transition(.opacity)
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
    static var previews: some View {
        SettingsView().environmentObject(DataManager.shared)
    }
}
