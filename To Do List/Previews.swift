import SwiftUI

struct Previews: PreviewProvider {
	static var previews: some View {
		ContentView(authViewModel: AuthViewModel(), viewModel: TodoViewModel())
	}
}
