import SwiftUI

struct TodoRowView: View {
	@Binding var todo: Todo
	var onToggle: () -> Void
	var onUpdate: (String) -> Void
	
	@State private var isEditing = false
	@State private var editedText = ""
	
	var body: some View {
		HStack {
			Button {
				onToggle()
			} label: {
				Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
					.foregroundColor(todo.isCompleted ? .green : .gray)
			}
			
			if isEditing {
				TextField("Edit task", text: $editedText)
					.onSubmit {
						onUpdate(editedText)
						isEditing = false
					}
			} else {
				Text(todo.title)
					.strikethrough(todo.isCompleted)
					.foregroundColor(todo.isCompleted ? .gray : .primary)
			}
			
			Spacer()
			
			Button {
				editedText = todo.title
				isEditing.toggle()
			} label: {
				Image(systemName: "pencil")
			}
		}
	}
}
