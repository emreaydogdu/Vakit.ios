import SwiftUI
import SwiftData
import SwipeActions
import Combine

struct DhikrView: View {
	
	@Environment(\.modelContext) var context
	@Query var dhikrs: [Dhikr]
	@State var selectedDhikr: Dhikr?
	@State var deletedDhikr: Dhikr?
	@State var editDhikr: Dhikr?
	@State private var add = false
	@State private var edit = false
	@State private var isPresentingConfirm = false
	@State private var show = false
	@State var scrollOffset = CGFloat.zero
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			OScrollView(scrollOffset: $scrollOffset) { _ in
				SwipeViewGroup {
					ForEach(dhikrs.reversed() + Dhikr.preDefined, id: \.id) { dhikr in
						CardView(option: false) {
							ZStack {
								HStack{
									Spacer()
									VStack{
										Image("ic_share")
											.resizable()
											.imageScale(.small)
											.frame(width: 28, height: 28)
											.foregroundColor(Color("cardView.title"))
										Spacer()
									}
								}
								VStack{
									Text(dhikr.nameAr)
										.font(.title)
										.padding(.top, 12)
									HStack{
										Text(dhikr.name)
											.font(.headline)
											.fontWeight(.bold)
											.foregroundColor(Color("textColor"))
											.frame(maxWidth: .infinity, alignment: .leading)
											.padding(.top, 1)
										Spacer()
										Text("\(dhikr.count) / \(dhikr.amount)")
											.font(.body)
											.foregroundColor(Color("subTextColor"))
											.frame(maxWidth: .infinity, alignment: .trailing)
									}
									ProgressView(value: CGFloat(dhikr.count), total: CGFloat(dhikr.amount))
										.progressViewStyle(BarProgressStyle())
										.padding(.vertical, 8)
								}
							}
						}
						.scrollTransition { content, phase in
							content
								.opacity(1 - 1.1*phase.value)
						}
						.onTapGesture { selectedDhikr = dhikr }
						.sheet(item: $selectedDhikr) { dhikr in DhikrCountView(dhikr: dhikr) }
						.sheet(isPresented: $add)  { DhikrAddView() }
						.sheet(item: $editDhikr) { dhikr in DhikrAddView(editDhikr: dhikr) }
						.if(!dhikr.predef){ content in
							SwipeView {
								content
							} trailingActions: { _ in
								SwipeAction {
									editDhikr = dhikr
									edit.toggle()
								} label: { highlight in
									Image("ic_reset")
										.resizable()
										.imageScale(.small)
										.frame(width: 28, height: 28)
										.foregroundColor(Color.white)
										.padding()
								} background: { highlight in
									RoundedRectangle(cornerRadius: 16, style: .continuous)
										.fill(Color.blue)
										.padding(10)
								}
								SwipeAction {
									deletedDhikr = dhikr
									isPresentingConfirm.toggle()
								} label: { highlight in
									Image("ic_trash")
										.resizable()
										.imageScale(.small)
										.frame(width: 28, height: 28)
										.foregroundColor(Color.white)
										.padding()
								} background: { highlight in
									RoundedRectangle(cornerRadius: 16, style: .continuous)
										.fill(Color.red)
										.padding(10)
								}
								.confirmationDialog("Are you sure?",  isPresented: $isPresentingConfirm, titleVisibility: .visible) {
									Button("Delete", role: .destructive) {
										withAnimation(.spring()){
											context.delete(deletedDhikr!)
										}
									}
								}
							}
							.swipeActionsMaskCornerRadius(0)
							.swipeMinimumDistance(10)
							.swipeSpacing(0)
							.swipeActionsStyle(.mask)
						}
					}
					.transition(AnyTransition.scale)
				}
			}
			.animation(.easeInOut, value: dhikrs )
			.contentMargins(.top, 80, for: .scrollContent)
			.contentMargins(.bottom, 90, for: .scrollContent)
			.onChange(of: scrollOffset) { show = scrollOffset.isLess(than: -60) ? false : true }
			ToolbarBck(title: "Dhikr", show: $show)
			SubmitButton(title: "Create a new Dhikr", icon: "ic_add"){ add.toggle() }
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct BarProgressStyle: ProgressViewStyle {
	
	var height: Double = 20.0
	var radius: Double = 10.0
	var labelFontStyle: Font = .body
	
	func makeBody(configuration: Configuration) -> some View {
		
		let progress = configuration.fractionCompleted ?? 0.0
		
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.frame(width: geometry.size.width, height: height)
					.foregroundColor(Color(uiColor: .systemGray5))
				
				RoundedRectangle(cornerRadius: radius)
					.frame(width: geometry.size.width * progress, height: height)
					.foregroundColor(Color.black)
			}.cornerRadius(radius)
		}
	}
}

struct DhikrAddView: View {
	
	@State var editDhikr: Dhikr?
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	@State private var add = false
	@State private var preDefined = false
	@State private var original = ""
	@State private var translation = ""
	@State private var amount = ""
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	@State private var selectedDhikr: Dhikr?
	@FocusState private var focusItem: Bool
	
	var body: some View {
		ZStack{
			PatternBG(pattern: false)
			VStack {
				Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
				Spacer()
			}
			ScrollView{
				if((editDhikr == nil)){
					FormSection2(header: "SELECT DHIKR", footer: "Select a predefined Dhikr from the List or create a new one right below", option: true) {
						Button(action: {preDefined.toggle()}, label: {
							HStack {
								Text("Select Dhikr")
									.font(.headline)
									.fontWeight(.bold)
									.foregroundColor(Color("cardView.title"))
								Spacer()
								Image("ic_share")
									.resizable()
									.imageScale(.small)
									.frame(width: 30, height: 30)
									.rotationEffect(.degrees(45))
									.foregroundColor(Color("cardView.title"))
							}
						})
						.sheet(isPresented: $preDefined){
							ZStack{
								PatternBG(pattern: false)
								VStack {
									Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
									ScrollView {
										ForEach(Dhikr.preDefined, id: \.self) { dhikr in
											VStack {
												ZStack(alignment: .topLeading) {
													RoundedRectangle(cornerRadius: 20, style: .continuous)
														.fill(Color("cardView.sub"))
														.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
													RoundedRectangle(cornerRadius: 16, style: .continuous)
														.fill(Color("cardView"))
														.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
														.padding(5)
													VStack{
														Text(dhikr.nameAr)
															.font(.title)
															.padding(.top, 12)
														Text(dhikr.name)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color("textColor"))
															.frame(maxWidth: .infinity, alignment: .leading)
															.padding(.top, 1)
													}
													.padding(22)
												}
												.onTapGesture {
													selectedDhikr = dhikr
													preDefined.toggle()
												}
											}
											.padding(.horizontal)
											.padding(.bottom, 6)
										}
										.background(GeometryReader { geometry in
											Color.clear
												.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
												.onAppear{
													defaultv = geometry.frame(in: .named("scroll")).origin
												}
										})
										.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
											withAnimation(.linear(duration: 0.1)){
												show = value.y < defaultv.y - 30.0
											}
										}
									}
									Spacer()
								}
							}
						}
						.onChange(of: selectedDhikr) {
							original = selectedDhikr!.nameAr
							translation = selectedDhikr!.name
						}
					}
				}

				FormSection2(header: (editDhikr == nil) ? "Create Dhikr" : "Edit Dhikr", footer: "Please provide the original spelling of your dhikr and the translation", option: true){
					VStack {
						TextField("Original", text: $original)
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
							.focused($focusItem)
							.padding(.vertical, 10)
						Divider()
						TextField("Translation", text: $translation)
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.focused($focusItem)
							.padding(.vertical, 10)
					}
				}
				
				FormSection2(header: "Choose Amount", footer: "Set Amount", option: false){
					TextField("99", text: $amount)
						.font(.headline)
						.foregroundColor(Color("cardView.title"))
						.focused($focusItem)
						.keyboardType(.numberPad)
						.onReceive(Just(amount)) { newValue in
							let filtered = newValue.filter { "0123456789".contains($0) }
							if filtered != newValue {
								self.amount = filtered
							}
						}
						.padding(.vertical, 10)
				}
				
				Spacer()
				SubmitButton(title: (editDhikr == nil) ? "Create" : "Save", icon: (editDhikr == nil) ? "ic_add" : "ic_trash") {
					if (translation != "" && original != "" && amount != ""){
						if(editDhikr == nil){
							context.insert(Dhikr(id: UUID(), name: translation, nameAr: original, count: 0, amount: Int(amount)!, predef: false))
						} else {
							editDhikr!.nameAr = original
							editDhikr!.name = translation
							editDhikr!.amount = Int(amount)!
						}
						dismiss()
					}
				}
			}
			.padding(.top, 20)
		}
		.onAppear{
			if(editDhikr != nil){
				original = editDhikr!.nameAr
				translation = editDhikr!.name
				amount = String(editDhikr!.amount)
			}
		}
		.onTapGesture{
			focusItem = false
		}
	}
}

struct FormSection<Content: View>: View {
	var header: String
	var footer: String
	var content: () -> Content
	
	var body: some View {
		Section(
			header: Text("\(header)".uppercased())
				.font(.subheadline)
				.fontWeight(.bold)
				.foregroundColor(Color("cardView.subtitle"))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 38)
				.padding(.top, 20),
			footer: Text(.init("\(footer)"))
				.font(.subheadline)
				.foregroundColor(Color("cardView.subtitle"))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal, 38))
		{
			CardView(option: false) {
				content()
			}
		}
	}
}

struct DhikrCountView: View {
	
	@Bindable var dhikr: Dhikr
	@State var disable = true
	@AppStorage("vibration_dhikr")
	private var vibration = true
	
	var body: some View {
		ZStack(alignment: .top) {
			PatternBG(pattern: false)
			Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
			VStack {
				ZStack() {
					RoundedRectangle(cornerRadius: 13, style: .continuous)
						.fill(Color("cardView"))
						.padding(5)
					VStack {
						Text("\(dhikr.nameAr)")
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.environment(\.layoutDirection, .rightToLeft)
						Text("\(dhikr.name)")
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.top, 5)
					}
					.padding(22)
				}
				.fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
				.padding(.top, 50)
				.padding(.horizontal)
				Spacer()
				HStack{
					Button(action: {
						withAnimation {
							dhikr.count = 0
						}
					}, label: {
						ZStack {
							RoundedRectangle(cornerRadius: 200, style: .continuous)
								.fill(Color("cardView"))
								.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
								.frame(width: 52, height: 52)
							Image("ic_reset")
								.resizable()
								.imageScale(.small)
								.frame(width: 24, height: 24)
								.foregroundColor(Color("color"))
						}
					})
					Spacer()
					Button(action: {
						vibration.toggle()
					}, label: {
						ZStack {
							RoundedRectangle(cornerRadius: 200, style: .continuous)
								.fill(Color("cardView"))
								.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
								.frame(width: 52, height: 52)
							Image("ic_vibrate")
								.resizable()
								.imageScale(.small)
								.frame(width: 24, height: 24)
								.foregroundColor(Color("color"))
						}
					})
				}
				.padding(.horizontal, 22)
				.offset(y: 40)
				ZStack {
					RoundedRectangle(cornerRadius: 200, style: .continuous)
						.fill(Color("cardView.sub"))
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						.frame(width: 360, height: 360)
					Circle()
						.trim(from: 0, to: 1.0)
						.rotation(.degrees(-90))
						.stroke(Color("cardView"), style: StrokeStyle(lineWidth: 50, lineCap: .round))
						.frame(width: 300, height: 300)
					Circle()
						.trim(from: 0, to: CGFloat(dhikr.count)/CGFloat(dhikr.amount))
						.rotation(.degrees(-90))
						.stroke(Color(hex: "#C1D2E7"), style: StrokeStyle(lineWidth: 40, lineCap: .round))
						.frame(width: 300, height: 300)
					Text("\(dhikr.count)/\(dhikr.amount)").monospaced()
						.font(.largeTitle)
						.fontWeight(.bold)
				}
				.allowsHitTesting(disable)
				.onTapGesture {
					if (dhikr.count < dhikr.amount - 1){
						vibrate(style: .rigid, pref: vibration)
						withAnimation{
							dhikr.count += 1
						}
					}
					else{
						disable.toggle()
						withAnimation {
							vibrate(style: .heavy, pref: vibration)
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
								vibrate(style: .heavy, pref: vibration)
							}
							dhikr.count += 1
						} completion: {
							withAnimation{
								dhikr.count = 0
								disable.toggle()
							}
						}
					}
				}
			}
			.frame(maxWidth: .infinity)
		}
	}
}

#Preview {
	DhikrView()
		.modelContainer(for: [Dhikr.self])
	/*
	 let dhikr = Dhikr(id: UUID(), name: "After Salah", count: 99)
	 DhikrCountView(dhikr: dhikr)
	 */
}
