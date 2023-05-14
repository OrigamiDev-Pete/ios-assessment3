//
//  Quest.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import Foundation
import UIKit

class Quest: Identifiable {
    let id: UUID
    var title: String
    var content: String
    let authorId: UUID
    var assigned: [UUID]
    var compeletedBy: UUID? = nil
    var endTime: Date
    
    init(title: String, content: String, authorId: UUID, assigned: [UUID], completedBy: UUID?, endTime: Date) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.authorId = authorId
        self.assigned = assigned
        self.endTime = endTime
    }
    
    func getStatus(fromUserPerspective user: User) -> (QuestStatus) {
        if compeletedBy == nil && endTime < Date.now {
            return .overdue
        }
        
        if let compeletedBy = compeletedBy {
            if compeletedBy == user.id {
                return .complete
            } else {
                return .lost
            }
        }
        
        return .active
    }
}

enum QuestStatus {
    case active
    case complete
    case lost
    case overdue
    
    func getStatusUIDetails() -> (UIColor, String) {
        switch self {
        case .active:
            return (UIColor.systemGreen, "Active")
        case .complete:
            return (UIColor.systemBlue, "Complete")
        case .lost:
            return (UIColor.systemRed, "Lost")
        case .overdue:
            return (UIColor.systemRed, "Overdue")
        }
        
    }
}
