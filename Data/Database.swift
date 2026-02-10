import Foundation
import SQLite3

class Database {
    static let shared = Database()
    var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createTable()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Todo.sqlite")
        
        // Ensure directory exists
        try? FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS todos(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            createdAt REAL NOT NULL,
            completedAt REAL
        );
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                // Table created
            } else {
                print("Todo table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
}
