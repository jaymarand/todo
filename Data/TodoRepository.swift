import Foundation
import SQLite3

class TodoRepository {
    private let db: OpaquePointer?
    
    init(db: OpaquePointer?) {
        self.db = db
    }
    
    // MARK: - Read
    
    func getAllTodos() -> [TodoItem] {
        var todos: [TodoItem] = []
        let queryStatementString = "SELECT * FROM todos;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let idString = String(cString: sqlite3_column_text(queryStatement, 0))
                let title = String(cString: sqlite3_column_text(queryStatement, 1))
                let isCompletedInt = sqlite3_column_int(queryStatement, 2)
                let createdAtDouble = sqlite3_column_double(queryStatement, 3)
                let completedAtDouble = sqlite3_column_double(queryStatement, 4) // Returns 0.0 if NULL
                
                // Check if completedAt is actually NULL
                var completedAt: Date? = nil
                if sqlite3_column_type(queryStatement, 4) != SQLITE_NULL {
                     completedAt = Date(timeIntervalSince1970: completedAtDouble)
                }

                if let id = UUID(uuidString: idString) {
                    let todo = TodoItem(
                        id: id,
                        title: title,
                        isCompleted: isCompletedInt == 1,
                        createdAt: Date(timeIntervalSince1970: createdAtDouble),
                        completedAt: completedAt
                    )
                    todos.append(todo)
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return todos
    }
    
    // MARK: - Create
    
    func insert(title: String) {
        let insertStatementString = "INSERT INTO todos (id, title, isCompleted, createdAt, completedAt) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let id = UUID()
            let idString = id.uuidString
            let titleString = title as NSString
            let createdAt = Date().timeIntervalSince1970
            
            sqlite3_bind_text(insertStatement, 1, (idString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, titleString.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, 0) // isCompleted
            sqlite3_bind_double(insertStatement, 4, createdAt)
            sqlite3_bind_null(insertStatement, 5) // completedAt
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    // MARK: - Update
    
    func updateTitle(id: UUID, newTitle: String) {
        let updateStatementString = "UPDATE todos SET title = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newTitle as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (id.uuidString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated title.")
            } else {
                print("Could not update title.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    func toggleCompleted(id: UUID, isCompleted: Bool) {
        let updateStatementString = "UPDATE todos SET isCompleted = ?, completedAt = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            let isCompletedInt: Int32 = isCompleted ? 1 : 0
            sqlite3_bind_int(updateStatement, 1, isCompletedInt)
            
            if isCompleted {
                sqlite3_bind_double(updateStatement, 2, Date().timeIntervalSince1970)
            } else {
                sqlite3_bind_null(updateStatement, 2)
            }
            
            sqlite3_bind_text(updateStatement, 3, (id.uuidString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated completion status.")
            } else {
                print("Could not update completion status.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    // MARK: - Delete
    
    func delete(id: UUID) {
        let deleteStatementString = "DELETE FROM todos WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id.uuidString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}
