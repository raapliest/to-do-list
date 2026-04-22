import SwiftUI

struct ContentView: View {
	@ObservedObject var authViewModel: AuthViewModel
	@ObservedObject var viewModel: TodoViewModel
	@State private var newTodoText = ""
	
	var body: some View {
		Group {
			if let user = authViewModel.user {
				NavigationView {
					VStack {
						HStack {
							TextField("Add new task...", text: $newTodoText)
								.textFieldStyle(RoundedBorderTextFieldStyle())
							Button("Add") {
								guard !newTodoText.isEmpty else { return }
								viewModel.addTodo(title: newTodoText, userID: user.uid)
								newTodoText = ""
							}
						}
						.padding()
						
						List {
							ForEach(Array(viewModel.todos.enumerated()), id: \.element.id) { index, todo in
								TodoRowView(
									todo: $viewModel.todos[index],
									onToggle: { viewModel.toggleCompletion(todo: todo, userID: user.uid) },
									onUpdate: { newTitle in viewModel.updateTodo(todo: todo, newTitle: newTitle, userID: user.uid) }
								)
							}
							.onDelete { offsets in
								viewModel.deleteTodo(at: offsets, userID: user.uid)
							}
						}
					}
					.navigationTitle("To-Do List")
					.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							Button("Logout") {
								authViewModel.logout()
								viewModel.stopListening()
							}
						}
					}
					.onAppear {
						viewModel.startListening(userID: user.uid)
					}
				}
			} else {
				LoginView(authViewModel: authViewModel)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(authViewModel: AuthViewModel(), viewModel: TodoViewModel())
	}
}
