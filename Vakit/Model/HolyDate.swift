import Foundation

struct HolyDate: Identifiable{
	let id 		  = UUID()
	let name 	  : String
	let desc 	  : String
	let gregorian : Date
	let mode 	  : Int
}
