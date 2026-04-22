//
//  AuthViewModel.swift
//  To Do List
//
//  Created by 10 on 2026/4/22.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
	@Published var user: User? = nil
	@Published var errorMessage: String = ""
	
	init() {
		self.user = Auth.auth().currentUser
	}
	
	func register(email: String, password: String) {
		Auth.auth().createUser(withEmail: email, password: password) { result, error in
			DispatchQueue.main.async {
				if let error = error {
					self.errorMessage = error.localizedDescription
					return
				}
				self.user = result?.user
			}
		}
	}
	
	func login(email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) { result, error in
			DispatchQueue.main.async {
				if let error = error {
					self.errorMessage = error.localizedDescription
					return
				}
				self.user = result?.user
			}
		}
	}
	
	func logout() {
		try? Auth.auth().signOut()
		DispatchQueue.main.async {
			self.user = nil
		}
	}
}
