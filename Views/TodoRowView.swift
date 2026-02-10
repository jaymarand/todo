import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .gray : .primary)
                
                Text(item.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        TodoRowView(item: TodoItem(title: "Sample Todo"), onToggle: {})
            .previewLayout(.sizeThatFits)
    }
}
