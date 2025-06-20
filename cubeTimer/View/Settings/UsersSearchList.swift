//
//  UsersSearchList.swift
//  cubeTimer
//
//  Created by Oleksii on 16.06.2025.
//
import SwiftUI

struct UsersSearchList: View {
    
    @State private var searchText = ""
    @Binding var selectedUser: FirestoreUser?

    var users: [FirestoreUser]
    
    init(_ users: [FirestoreUser], _ SU: Binding<FirestoreUser?>) {
        self.users = users
        _selectedUser = SU
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedUser) {
                ForEach(users.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.email.localizedCaseInsensitiveContains(searchText)}, id: \.self)
                { user in
                        Text(user.email)
                }
            }
            .navigationTitle("Select a user")
            .searchable(text: $searchText)
            .textInputAutocapitalization(.never)
        }
    }
}

struct UsersSearchList_Previews: PreviewProvider {
    static var users: [FirestoreUser] = [
        FirestoreUser(date: Date().addingTimeInterval(-1000000), name: "sss", email: "dassssssdhgfdhfdhd"),
        .init(date: Date(), name: "asd", email: "asd"),
        .init(date: Date(), name: "asd", email: "asd"),
        .init(date: Date(), name: "asd", email: "asd"),
        .init(date: Date(), name: "asd", email: "asd"),
    ]
    @State static var selectedUser: FirestoreUser? = nil
    static var previews: some View {
        UsersSearchList(users, $selectedUser)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
