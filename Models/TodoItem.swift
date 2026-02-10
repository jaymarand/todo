import Foundation

/// Represents a single Todo item.
struct TodoItem: Identifiable, Codable {
    /// Unique identifier for the todo item.
    let id: UUID
    
    /// The title or description of the todo.
    var title: String
    
    /// Whether the todo is completed.
    var isCompleted: Bool
    
    /// The specific point in time when the todo was created.
    let createdAt: Date
    
    /// The specific point in time when the todo was completed.
    var completedAt: Date?
    
    /// Initializes a new TodoItem.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID).
    ///   - title: The title of the todo.
    ///   - isCompleted: Initial completion state (defaults to false).
    ///   - createdAt: Creation date (defaults to current date).
    ///   - completedAt: Completion date (defaults to nil).
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date(), completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}
