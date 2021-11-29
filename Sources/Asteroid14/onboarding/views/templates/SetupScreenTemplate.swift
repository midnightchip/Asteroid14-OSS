import SwiftUI

struct SetupTemplate<HeaderContent: View, ExplainContent: View, ActionContent: View>: View {
    @ViewBuilder let headerView: HeaderContent
    @ViewBuilder let explainView: ExplainContent
    @ViewBuilder let actionView: ActionContent
    var body: some View {
        ScrollView {
            HStack {
                headerView
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .topLeading)
                .background(Color(UIColor.secondarySystemBackground))
            Spacer()
            explainView
            Spacer()
            actionView
        }.edgesIgnoringSafeArea(.horizontal)
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarHidden(true)
    }
}
