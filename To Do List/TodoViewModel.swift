import Foundation
import FirebaseFirestore
import FirebaseAuth

class TodoViewModel: ObservableObject {
	@Published var todos: [Todo] = []
	private let db = Firestore.firestore()
	private var listener: ListenerRegistration?
	
	func startListening(userID: String) {
		listener?.remove()
		listener = db.collection("users").document(userID).collection("todos")
			.addSnapshotListener { snapshot, error in
				guard let documents = snapshot?.documents else { return }
				DispatchQueue.main.async {
					self.todos = documents.map { doc -> Todo in
						let data = doc.data()
						return Todo(
							id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
							title: data["title"] as? String ?? "",
							isCompleted: data["isCompleted"] as? Bool ?? false
						)
					}
				}
			}
	}
	
	func stopListening() {
		listener?.remove()
		todos = []
	}
	
	func addTodo(title: String, userID: String) {
		let newTodo = Todo(id: UUID(), title: title, isCompleted: false)
		db.collection("users").document(userID).collection("todos")
			.addDocument(data: [
				"title": newTodo.title,
				"isCompleted": newTodo.isCompleted,
				"id": newTodo.id.uuidString
			])
	}
	
	func updateTodo(todo: Todo, newTitle: String, userID: String) {
		db.collection("users").document(userID).collection("todos")
			.whereField("id", isEqualTo: todo.id.uuidString)
			.getDocuments { snapshot, error in
				guard let document = snapshot?.documents.first else { return }
				document.reference.updateData(["title": newTitle])
			}
	}
	
	func toggleCompletion(todo: Todo, userID: String) {
		let newValue = !todo.isCompleted
		db.collection("users").document(userID).collection("todos")
			.whereField("id", isEqualTo: todo.id.uuidString)
			.getDocuments { snapshot, error in
				guard let document = snapshot?.documents.first else {
					print("Document not found!")
					return
				}
				document.reference.updateData(["isCompleted": newValue])
			}
	}
	
	func deleteTodo(at offsets: IndexSet, userID: String) {
		offsets.forEach { index in
			let todo = todos[index]
			db.collection("users").document(userID).collection("todos")
				.whereField("id", isEqualTo: todo.id.uuidString)
				.getDocuments { snapshot, error in
					guard let document = snapshot?.documents.first else { return }
					document.reference.delete()
				}
		}
	}
}
