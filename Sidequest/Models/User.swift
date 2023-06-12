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
    
    init(response: UserResponse) {
        self.id = UUID(uuidString: response.id)!
        self.firstName = response.firstName
        self.lastName = response.lastName
        self.phoneNumber = response.phoneNumber
        friendIds = []
    }
    
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

class RegisterDto: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let password: String
    
    init(firstName: String, lastName: String, phoneNumber: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.password = password
    }
}

class UserResponse: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var fullName: String {
        get {
            "\(firstName) \(lastName)"
        }
    }
    var phoneNumber: String
    
    init() {
        id = "0"
        firstName = ""
        lastName = ""
        phoneNumber = ""
    }
}

class FriendRequest: Codable {
    var sender: UserResponse
    var recipient: UserResponse
}
