import SwiftUI
import Foundation
import Request

class QuranApi {
	
	struct RandomVerse: Codable {
		let verse: Verse
		struct Verse: Codable {
			let verse_key: String
			let verse_number: Int
			let chapter_id: Int
			let text_uthmani: String
			let text_uthmani_simple: String
			let translations: [Translations]
			struct Translations: Codable {
				let text: String
			}
		}
	}
	struct Chapter: Codable {
		let chapter : Chapters
		struct Chapters: Codable {
			let name_simple: String
		   }
	}
	
	func getDailyAyah() async -> (String, String, String) {
		var dua = ""
		var dua_arab = ""
		var chapter = ""
		do {
			let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.quran.com/api/v4/verses/random?translations=77&fields=text_uthmani_simple,text_uthmani,chapter_id")!))
			let randomVerse = try JSONDecoder().decode(QuranApi.RandomVerse.self, from: data)
			let (chapterData, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.quran.com/api/v4/chapters/\(randomVerse.verse.chapter_id.description)")!))
			let chapterM = try JSONDecoder().decode(QuranApi.Chapter.self, from: chapterData)
			dua = randomVerse.verse.translations[0].text
			dua_arab = randomVerse.verse.text_uthmani_simple
			chapter = "\(chapterM.chapter.name_simple)・\(randomVerse.verse.verse_number)"
		} catch {
			print("Error decoding", error)
		}
		
		return (dua, dua_arab, chapter)
	}
}
