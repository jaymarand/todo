import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.currentFilter) {
                    ForEach(TodoFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.currentFilter) { newValue in
                    viewModel.setFilter(newValue)
                }
                
                if viewModel.items.isEmpty {
                    Spacer()
                    Text("No \(viewModel.currentFilter.rawValue.lowercased()) todos")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            NavigationLink(destination: TodoDetailView(viewModel: viewModel, item: item)) {
                                TodoRowView(item: item) {
                                    withAnimation {
                                        viewModel.toggleCompleted(id: item.id)
                                    }
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    withAnimation {
                                        viewModel.toggleCompleted(id: item.id)
                                    }
                                } label: {
                                    Label(item.isCompleted ? "Mark Active" : "Complete", systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark")
                                }
                                .tint(item.isCompleted ? .orange : .green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.delete(id: item.id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTodoSheet(viewModel: viewModel)
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
