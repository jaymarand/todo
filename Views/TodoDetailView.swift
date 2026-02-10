import SwiftUI

struct TodoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TodoViewModel
    
    @State private var title: String
    @State private var isCompleted: Bool
    
    let itemId: UUID
    
    init(viewModel: TodoViewModel, item: TodoItem) {
        self.viewModel = viewModel
        self.itemId = item.id
        _title = State(initialValue: item.title)
        _isCompleted = State(initialValue: item.isCompleted)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Todo Info")) {
                TextField("Title", text: $title)
                    .onChange(of: title) { newValue in
                        viewModel.updateTitle(id: itemId, title: newValue)
                    }
                
                Toggle("Completed", isOn: $isCompleted)
                    .onChange(of: isCompleted) { newValue in
                        viewModel.toggleCompleted(id: itemId)
                    }
            }
            
            Section {
                Button(role: .destructive) {
                    viewModel.delete(id: itemId)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete Todo")
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
