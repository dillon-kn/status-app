import SwiftUI

struct StatusView: View {
    @StateObject var viewModel = StatusViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("right now, i'm...")
                    .font(.title2)
                    .padding(.top, 50)

                VStack {
                    TextEditor(text: $viewModel.currentStatus)
                        .padding()
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .frame(minWidth: 100, maxWidth: 350, minHeight: 10, maxHeight: 70)
                        .multilineTextAlignment(.center)
                        .onChange(of: viewModel.currentStatus) {
                            viewModel.currentStatus = viewModel.currentStatus.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "")
                            if viewModel.currentStatus.count > 35 {
                                viewModel.currentStatus = String(viewModel.currentStatus.prefix(35))
                            }
                        }

                    Button(action: {
                        // Handle status submission
                        print("Status submitted: \(viewModel.currentStatus)")
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }

            // Friends status section
            VStack(alignment: .leading) {
                HStack {
                    Text("Friends")
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        // Add friend action
                        
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .padding(.trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)

                List {
                    FriendStatusView(name: "you", status: viewModel.currentStatus)
                    FriendStatusView(name: "Jonathan", status: "tennis")
                    FriendStatusView(name: "Naveen", status: "recalibrating")
                    FriendStatusView(name: "Shreyas", status: "grinding")
                    FriendStatusView(name: "Amogh", status: "amogging")
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: colorModel.beige))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
