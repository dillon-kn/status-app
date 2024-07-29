//
//  FriendSearchViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/26/24.
//

import Foundation
import Combine
import FirebaseFirestore

class FriendSearchViewViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults = [User]()
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var db = Firestore.firestore()

    func search() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        print("Searching for: \(trimmed)")
        db.collection("usernames")
            .whereField("username", isGreaterThanOrEqualTo: trimmed)
            .whereField("username", isLessThanOrEqualTo: trimmed + "\u{f8ff}")
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                } else {
                    print("QuerySnapshot: \(querySnapshot?.documents ?? [])") // Add this line
                    let userIDs = querySnapshot?.documents.compactMap { document in
                        document.data()["id"] as? String
                    } ?? []
                    print("Found user IDs: \(userIDs)")
                    self?.fetchUsers(userIDs: userIDs)
                }
            }
    }

    private func fetchUsers(userIDs: [String]) {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        var fetchedUsers = [User]()

        for userID in userIDs {
            print("Fetching user with ID: \(userID)")
            group.enter()
            db.collection("users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let user = try? document.data(as: User.self) {
                        fetchedUsers.append(user)
                        print("Fetched user: \(user)")
                    } else {
                        print("Failed to decode user for document ID: \(userID)")
                    }
                } else {
                    print("No document found for user ID: \(userID)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.searchResults = fetchedUsers
            print("All users fetched: \(fetchedUsers)")
        }
    }
}
