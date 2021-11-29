import Asteroid14C
import SwiftUI

struct LocationSelector: View {
    @Binding var selectedIndex: Int
    @Binding var presented: Bool
    let locations: [City?]? = {
        let cities = WeatherModel.shared.allCities
        let cleanedCities = cities?.filter { $0.name != nil }
        return cleanedCities
    }()

    let unpurgedLocations: [City?]? = WeatherModel.shared.allCities
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(locations ?? [], id: \.self) { city in
                    GeometryReader { _ in
                        ZStack {
                            LocationSelectionAnimationView(currentCity: city)
                            HStack(alignment: .center) {
                                Text(city?.name ?? "Unknown")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                Spacer()
                                if (self.locations?.firstIndex(of: city) ?? 0) + computeOffset() == self.selectedIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                }
                            }
                        }

                    }.onTapGesture {
                        self.selectedIndex = self.unpurgedLocations?.firstIndex(of: city) ?? 0
                        presented = false
                    }
                    .frame(height: 100)
                    .cornerRadius(15)
                }
            }.padding(.horizontal)
                .padding(.top)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .listStyle(PlainListStyle())
        .ignoresSafeArea()
    }

    func computeOffset() -> Int {
        return (unpurgedLocations?.count ?? 0) - (locations?.count ?? 0)
    }
}

struct ConditionSelector: View {
    @Binding var selectedIndex: Int
    @Binding var presented: Bool
    @Binding var isNight: Bool
    let totalConditions = 47
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(0 ... totalConditions, id: \.self) { conditionIndex in
                    GeometryReader { _ in
                        ZStack {
                            CustomConditionPreview(conditionCode: conditionIndex, isNight: isNight)
                            HStack(alignment: .center) {
                                if conditionIndex == self.selectedIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .padding(.leading)
                                }
                            }
                        }

                    }.onTapGesture {
                        self.selectedIndex = conditionIndex
                        presented = false
                    }
                    .frame(height: 100)
                    .cornerRadius(15)
                }
            }.padding(.horizontal)
                .padding(.top)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .listStyle(PlainListStyle())
        .ignoresSafeArea()
    }
}
