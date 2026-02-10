import SwiftUI

struct AddTodoSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TodoViewModel
    
    @State private var title: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                    .focused($isFocused)
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTodo(title: title)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }
}
