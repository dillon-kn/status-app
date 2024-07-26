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

    init() {
        $searchText
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] text in
                    self?.searchUsers(username: text)
                }
                .store(in: &cancellables)
        }

    func searchUsers(username: String) {
        guard !username.isEmpty else {
            self.searchResults = []
            return
        }
        
        db.collection("usernames")
            .whereField("username", isGreaterThanOrEqualTo: username)
            .whereField("username", isLessThanOrEqualTo: username + "\u{f8ff}")
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                    print("Error fetching documents: \(error.localizedDescription)")
                } else {
                    print("Query successful.")
                    let userIDs = querySnapshot?.documents.compactMap { document in
                        document.data()["uID"] as? String
                    } ?? []
                    print("Fetched user IDs: \(userIDs)")
                    
                    self?.fetchUsers(userIDs: userIDs)
                }
            }
    }
    
    private func fetchUsers(userIDs: [String]) {
        guard !userIDs.isEmpty else {
            self.searchResults = []
            return
        }
        
        var fetchedUsers = [User]()
        let dispatchGroup = DispatchGroup()
        
        for userID in userIDs {
            dispatchGroup.enter()
            db.collection("users").document(userID).getDocument { documentSnapshot, error in
                if let document = documentSnapshot, document.exists {
                    if let user = try? document.data(as: User.self) {
                        fetchedUsers.append(user)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.searchResults = fetchedUsers
        }
    }
}
