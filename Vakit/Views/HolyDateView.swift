import SwiftUI

struct HolyDateView: View {

	@State var capitals: [HolyDate] = []

	var body: some View {
		ScrollView(showsIndicators: false) {
			ForEach(capitals, id: \.id) { country in
				ZStack(alignment: .leading){
					Text(Date().getHolyGregorianStr(dateStr: country.gregorian))
						.font(.callout)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.leading)
					Circle()
						.fill(.black)
						.frame(width: 20, alignment: .leading)
						.padding(.leading, 85)
					Circle()
						.fill(.white)
						.frame(width: 10, alignment: .leading)
						.padding(.leading, 90)
					Divider()
						.frame(minHeight: 2)
						.overlay(.black)
						.padding(.leading, 100)
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.fill(Color(hex: "#F1F5FF"))
						.padding(.horizontal)
						.padding(.leading, 100)
					VStack(spacing: 10){
						Text(LocalizedStringKey(country.name))
							.font(.headline)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(LocalizedStringKey(country.desc))
							.font(.subheadline)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(Date().getHolyHijri(dateStr: country.gregorian))
							.font(.subheadline)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding()
					.padding(.leading, 120)
				}
			}
		}
		.onAppear {
			capitals = csvStringToArray(stringCSV: "HolyDates.csv")
		}
	}

	func csvStringToArray(stringCSV: String) -> [HolyDate] {
		var dataArray: [HolyDate] = []
		if let filepath = Bundle.main.path(forResource: stringCSV, ofType: nil) {
			do {
				let csvRows = try String(contentsOfFile: filepath)
				let lines = csvRows.components(separatedBy: "\n")
				for i in lines {
					let columns = i.components(separatedBy: ",")
					let csvColumns: HolyDate = HolyDate.init(name: columns[0].trimmingCharacters(in: .whitespacesAndNewlines), desc: columns[1].trimmingCharacters(in: .whitespacesAndNewlines), gregorian: Date().getHolyGregorian(dateStr: columns[2])!, mode: Int(columns[3].trimmingCharacters(in: .whitespacesAndNewlines))!)
					dataArray.append(csvColumns)
				}
				return dataArray
			} catch { print("error: \(error)") }
		}
		return dataArray
	}
}

#Preview {
	HolyDateView()
}
