import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: TodoViewModel
	@State private var newTodoText = ""
	
	var body: some View {
		NavigationView {
			VStack {
				// Input field
				HStack {
					TextField("Add new task...", text: $newTodoText)
						.textFieldStyle(RoundedBorderTextFieldStyle())
					
					Button("Add") {
						guard !newTodoText.isEmpty else { return }
						viewModel.addTodo(title: newTodoText)
						newTodoText = ""
					}
				}
				.padding()
				
				// Task list
				List {
					ForEach(Array(viewModel.todos.enumerated()), id: \.element.id) { index, todo in
						TodoRowView(
							todo: $viewModel.todos[index],
							onToggle: { viewModel.toggleCompletion(todo: todo) },
							onUpdate: { newTitle in viewModel.updateTodo(todo: todo, newTitle: newTitle) }
						)
					}
					.onDelete(perform: viewModel.deleteTodo)
				}
			}
			.navigationTitle("To-Do List")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: TodoViewModel())
	}
}
