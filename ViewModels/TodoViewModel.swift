import Foundation
import Combine

enum TodoFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
    
    var id: String { self.rawValue }
}

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    @Published var currentFilter: TodoFilter = .all
    
    private let repository: TodoRepository
    
    init(repository: TodoRepository = TodoRepository(db: Database.shared.db)) {
        self.repository = repository
        loadTodos()
    }
    
    func setFilter(_ filter: TodoFilter) {
        self.currentFilter = filter
        loadTodos()
    }
    
    func loadTodos() {
        let allItems = repository.getAllTodos()
        
        var filteredItems: [TodoItem]
        
        switch currentFilter {
        case .all:
            filteredItems = allItems
        case .active:
            filteredItems = allItems.filter { !$0.isCompleted }
        case .completed:
            filteredItems = allItems.filter { $0.isCompleted }
        }
        
        self.items = filteredItems.sorted {
            if $0.isCompleted != $1.isCompleted {
                // Active first
                return !$0.isCompleted
            }
            
            if $0.isCompleted {
                // Completed: sorted by completedAt desc
                let date0 = $0.completedAt ?? Date.distantPast
                let date1 = $1.completedAt ?? Date.distantPast
                return date0 > date1
            } else {
                // Active: sorted by createdAt desc
                return $0.createdAt > $1.createdAt
            }
        }
    }
    
    func addTodo(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        repository.insert(title: trimmedTitle)
        loadTodos()
    }
    
    func toggleCompleted(id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            let item = items[index]
            let newState = !item.isCompleted
            repository.toggleCompleted(id: id, isCompleted: newState)
            loadTodos()
        }
    }
    
    func updateTitle(id: UUID, title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        repository.updateTitle(id: id, newTitle: trimmedTitle)
        loadTodos()
    }
    
    func delete(id: UUID) {
        repository.delete(id: id)
        loadTodos()
    }
}
