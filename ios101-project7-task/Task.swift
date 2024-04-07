//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    // Key for UserDefaults
    static let myKeys = "FavoriteTasks"
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        // Save the array of tasks
        let starters = UserDefaults.standard
        // Encoding tasks to data
        do {
            let encodedTasks = try JSONEncoder().encode(tasks)
            // Saving encoded data to UserDefaults with a fixed key
            starters.set(encodedTasks, forKey: myKeys)
        } catch {
            print("Error encoding tasks: \(error.localizedDescription)")
        }
    }
    
    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        // Get the array of saved tasks from UserDefaults
        let starters = UserDefaults.standard
        if let savedTasks = starters.data(forKey: myKeys) {
            // Decode saved data back to tasks
            do {
                let tasks = try JSONDecoder().decode([Task].self, from: savedTasks)
                return tasks
            } catch {
                print("Error decoding tasks: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    // Add a new task or update an existing task with the current task.
    func save() {
        // Save the current task
        var mytasks = Task.getTasks()
        if let ind = mytasks.firstIndex(where: { $0.id == self.id }) {
            // Update existing task
            mytasks.remove(at: ind)
            mytasks.insert(self, at: ind)
        } else {
            // Add new task
            mytasks.append(self)
        }
        // Saving updated array of tasks
        Task.save(mytasks)
    }
 }
