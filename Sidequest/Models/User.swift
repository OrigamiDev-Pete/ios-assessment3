//
//  User.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import Foundation

class User: Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    var fullName: String {
        get {
            "\(firstName) \(lastName)"
        }
    }
    let phoneNumber: String
    var friendIds: [UUID]
    
    init(firstName: String, lastName: String, phoneNumber: String, friendIds: [UUID]) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.friendIds = friendIds
    }
    
    init(id: UUID, firstName: String, lastName: String, phoneNumber: String, friendIds: [UUID]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.friendIds = friendIds
    }
}
