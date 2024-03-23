import SwiftUI

struct NextHolyDayView: View {
	
	let title = LocalizedStringKey("Next Holy Date").localized!
	@State var leftDays = 0
	@State var leftDaysT = ""
	@State var holyDayTitle = ""
	@State var holyDayDesc = ""
	@State var capitals: HolyDate = HolyDate(name: "", desc: "", gregorian: Date(), mode: 0)
	@State private var isExpanded: Bool = false
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color("cardView.sub"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			VStack{
				ShareLink(item: "\(title)\n\n\(holyDayTitle)・\(leftDaysT)\n\n\(holyDayDesc)\n\n\(Date().getHolyGregorianStrNorm(dateStr: capitals.gregorian))\n\(Date().getHolyHijri(dateStr: capitals.gregorian))") {
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, alignment: .leading)
							.task {
								(capitals, leftDays) = getNextHolyDate2()
								holyDayTitle = LocalizedStringKey(capitals.name).localized!
								holyDayDesc = LocalizedStringKey(capitals.desc).localized!
								leftDaysT = LocalizedStringKey("\(leftDays.description) Days left").localized!
							}
						Image("ic_share")
							.resizable()
							.imageScale(.small)
							.frame(width: 28, height: 28)
							.foregroundColor(Color("cardView.title"))
					}
				}
				VStack(){
					VStack {
						Text(holyDayTitle)
							.font(.body)
							.fontWeight(.semibold)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.top, 8)
						Text(holyDayDesc)
							.font(.body)
							.foregroundColor(Color("subTextColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom)
						Text(leftDaysT)
							.font(.title3)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .trailing)
							.padding(.bottom)
					}
					HStack {
						Text(Date().getHolyGregorianStrNorm(dateStr: capitals.gregorian))
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
						Spacer()
						Text(Date().getHolyHijri(dateStr: capitals.gregorian))
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
				}
			}
			.padding(22)
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
	
	func getNextHolyDate2() -> (HolyDate, Int) {
		let dates: [HolyDate] = csvStringToArray(stringCSV: "HolyDates.csv")
		var diff = 0
		for date in dates {
			diff = Calendar.current.dateComponents([.day], from: Date(), to: date.gregorian).day!
			if  diff > 0 {
				return (date, diff+1)
			}
		}
		return (dates[0], diff)
	}
	
}
struct LongText: View {
	
	/* Indicates whether the user want to see all the text or not. */
	@State private var expanded: Bool = false
	
	/* Indicates whether the text has been truncated in its display. */
	@State private var truncated: Bool = false
	
	private var text: String
	
	init(_ text: String) {
		self.text = text
	}
	
	private func determineTruncation(_ geometry: GeometryProxy) {
		// Calculate the bounding box we'd need to render the
		// text given the width from the GeometryReader.
		let total = self.text.boundingRect(
			with: CGSize(
				width: geometry.size.width,
				height: .greatestFiniteMagnitude
			),
			options: .usesLineFragmentOrigin,
			attributes: [.font: UIFont.systemFont(ofSize: 16)],
			context: nil
		)
		
		if total.size.height > geometry.size.height {
			self.truncated = true
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text(LocalizedStringKey(self.text))
				.font(.system(size: 16))
				.lineLimit(self.expanded ? nil : 3)
			// see https://swiftui-lab.com/geometryreader-to-the-rescue/,
			// and https://swiftui-lab.com/communicating-with-the-view-tree-part-1/
				.background(GeometryReader { geometry in
					Color.clear.onAppear {
						self.determineTruncation(geometry)
					}
				})
			
			if self.truncated {
				self.toggleButton
			}
		}
	}

var toggleButton: some View {
	Button(action: {
		withAnimation(){
			self.expanded.toggle()
		}
	}) {
		Text(self.expanded ? "Show less" : "Show more")
			.font(.caption)
	}
}

}

#Preview {
	NextHolyDayView()
}
