//
//  LoginView.swift
//  To Do List
//
//  Created by 10 on 2026/4/22.
//

import Foundation
import SwiftUI

struct LoginView: View {
	@ObservedObject var authViewModel: AuthViewModel
	@State private var email = ""
	@State private var password = ""
	@State private var isRegistering = false
	
	var body: some View {
		VStack(spacing: 20) {
			Text(isRegistering ? "Register" : "Login")
				.font(.largeTitle)
				.bold()
			
			TextField("Email", text: $email)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.autocapitalization(.none)
				.keyboardType(.emailAddress)
			
			SecureField("Password", text: $password)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			
			if !authViewModel.errorMessage.isEmpty {
				Text(authViewModel.errorMessage)
					.foregroundColor(.red)
					.font(.caption)
			}
			
			Button(isRegistering ? "Register" : "Login") {
				if isRegistering {
					authViewModel.register(email: email, password: password)
				} else {
					authViewModel.login(email: email, password: password)
				}
			}
			.buttonStyle(.borderedProminent)
			
			Button(isRegistering ? "Already have an account? Login" : "Don't have an account? Register") {
				isRegistering.toggle()
				authViewModel.errorMessage = ""
			}
			.font(.caption)
		}
		.padding()
	}
}
