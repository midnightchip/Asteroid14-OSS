import Asteroid14C
import SwiftUI
import Cephei

struct CompleteSetup: View {
    @State var subtitleOpacity: Double = 0
    @State var titleOpacity: Double = 0
    @State var moveToLockscreen: Bool = false
    @ObservedObject var prefs = AsteroidPrefs()
    // kick off weather model
    let weatherModel = WeatherModel.shared
    var body: some View {
        NavigationView {
            ZStack {
                WelcomeScreenAnimationView()
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .ignoresSafeArea()
                VStack {
                    Spacer()

                    Text("Complete")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                titleOpacity = 1
                            }
                        }

                    Text("All setup up!\nThanks for using Asteroid!")
                        .font(.subheadline)
                        .opacity(subtitleOpacity)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1)) {
                                subtitleOpacity = 1
                            }
                        }

                    Text("Created by MidnightChips")
                        .font(.subheadline)
                        .opacity(subtitleOpacity)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1)) {
                                subtitleOpacity = 1
                            }
                        }

                    Spacer()
                    Button("Finish") {
                        prefs.completedSetup = true
                        startRespring()
                    }.customButton()
                }.padding()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}
