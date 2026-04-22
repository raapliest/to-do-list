import Foundation
import SwiftUI
import FirebaseFirestore

class TodoViewModel: ObservableObject {
	@Published var todos: [Todo] = []
	
	private let db = Firestore.firestore()
	
	func addTodo(title: String) {
		let newTodo = Todo(id: UUID(), title: title, isCompleted: false)
		
		db.collection("todos").addDocument(data: [
			"title": newTodo.title,
			"isCompleted": newTodo.isCompleted,
			"id": newTodo.id.uuidString
		]) { error in
			if let error = error {
				print("Error adding document: \(error)")
			}
		}
	}
	
	func updateTodo(todo: Todo, newTitle: String) {
		db.collection("todos").whereField("id", isEqualTo: todo.id.uuidString)
			.getDocuments { snapshot, error in
				guard let document = snapshot?.documents.first else {
					print("Document not found for update!")
					return
				}
				document.reference.updateData(["title": newTitle]) { error in
					if let error = error {
						print("Error updating title: \(error)")
					}
				}
			}
	}
	
	func toggleCompletion(todo: Todo) {
		let newValue = !todo.isCompleted
		
		db.collection("todos").whereField("id", isEqualTo: todo.id.uuidString)
			.getDocuments { snapshot, error in
				guard let document = snapshot?.documents.first else {
					print("Document not found for toggle!")
					return
				}
				document.reference.updateData(["isCompleted": newValue]) { error in
					if let error = error {
						print("Error toggling completion: \(error)")
					} else {
						print("Updated isCompleted to: \(newValue)")
					}
				}
			}
	}
	
	func deleteTodo(at offsets: IndexSet) {
		offsets.forEach { index in
			let todo = todos[index]
			
			db.collection("todos").whereField("id", isEqualTo: todo.id.uuidString)
				.getDocuments { snapshot, error in
					guard let document = snapshot?.documents.first else {
						print("Document not found for delete!")
						return
					}
					document.reference.delete { error in
						if let error = error {
							print("Error deleting document: \(error)")
						}
					}
				}
		}
	}
	
	init() {
		db.collection("todos").addSnapshotListener { snapshot, error in
			guard let documents = snapshot?.documents else {
				print("Error fetching documents: \(String(describing: error))")
				return
			}
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
}
