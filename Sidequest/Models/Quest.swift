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
    let title: String
    let content: String
    var status: QuestStatus = .active
    let authorId: UUID
    var assigned: [UUID]
    let endTime: Date
    
    init(title: String, content: String, authorId: UUID, assigned: [UUID], endTime: Date) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.authorId = authorId
        self.assigned = assigned
        self.endTime = endTime
    }
   
}

enum QuestStatus {
    case active
    case complete
    case overdue
    
    func getStatusUIDetails() -> (UIColor, String) {
        switch self {
        case .active:
            return (UIColor.systemGreen, "Active")
        case .complete:
            return (UIColor.systemBlue, "Complete")
        case .overdue:
            return (UIColor.systemRed, "Failed")
        }
        
    }
}
