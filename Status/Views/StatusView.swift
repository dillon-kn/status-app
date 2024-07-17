import SwiftUI

struct StatusView: View {
    @StateObject var viewModel = StatusViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center) {
                    Text("right now, i'm...")
                        .font(.title2)
                        .padding(.top, 50)
                    
                    Text(viewModel.currentStatus)
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                        .padding()
                        .foregroundStyle(Color(hex: colorModel.forestGreen))


                    Button(action: {
                        viewModel.showingUpdateStatusView = true
                    }) {
                        Text("Update Status")
                            .padding()
                            .background(Color(hex: colorModel.forestGreen))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding(.vertical, 50)
                
                Spacer()

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
                                .foregroundColor(Color(hex: colorModel.forestGreen))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    List {
                        FriendStatusView(name: "you", status: viewModel.currentStatus)
                        FriendStatusView(name: "Esaw", status: "odds?")
                        FriendStatusView(name: "Naveen", status: "recalibrating")
                        FriendStatusView(name: "Shreyas", status: "grinding")
                        FriendStatusView(name: "Amogh", status: "amogging")
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingUpdateStatusView) {
                UpdateStatusView()
            }
            .padding(.top, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: colorModel.beige))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // dismiss keyboard when done
            }
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(userID: "")
    }
}
