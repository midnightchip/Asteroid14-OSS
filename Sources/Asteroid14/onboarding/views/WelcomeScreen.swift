import Asteroid14C
import SwiftUI

struct WelcomeView: View {
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
                VStack {
                    Spacer()
                    Text("Welcome to")
                        .font(.subheadline)
                        .opacity(subtitleOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1)) {
                                subtitleOpacity = 1
                            }
                        }

                    Text("Asteroid")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                titleOpacity = 1
                            }
                        }

                    Spacer()
                    VStack {
                        Button("Continue") {
                            moveToLockscreen.toggle()
                        }.customButton()
                        Button("Skip Setup") {
                            prefs.completedSetup = true
                            startRespring()
                        }.customButton()
                    }
                    NavigationLink(destination: LockScreenSetup(), isActive: $moveToLockscreen) {
                        EmptyView()
                    }
                }.padding()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct ButtonModifier: ViewModifier {
    var fillColor: Color? = .accentColor
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(fillColor ?? .accentColor))
            .padding(.bottom)
    }
}

extension View {
    func customButton(fillColor: Color? = nil) -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier(fillColor: fillColor))
    }

    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
