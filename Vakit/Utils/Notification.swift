import UserNotifications
import ActivityKit
import SwiftUI

class Notification {
	
	struct NotificationView: View {
		
		var body: some View {
			VStack {
				// 2 schedule notification
				Button("Schedule a notification") {
					
					
					// 2. Create the content for the notification
					let content = UNMutableNotificationContent()
					content.title = "Reminder"
					content.body = "Don't forget to check the app!"
					content.sound = UNNotificationSound.default
					
					// 3. Set up a trigger for the notification
					// For example, 10 seconds from now
					let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (10), repeats: false)
					
					// 4. Create the request
					let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
					
					// 5. Add the request to the notification center
					/*
					UNUserNotificationCenter.current().add(request) { error in
						if let error = error {
							print(error.localizedDescription)
						} else {
							print("Notification scheduled")
						}
					}
					 */
					
					Task{
						await startDeliveryPizza()
					}
				}.font(.title)
			}
			.padding()
			.onAppear(){
				// 1 checking for permission
				UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
					if success {
						print("Permission approved!")
					} else if let error = error {
						print(error.localizedDescription)
					}
				}
			}
		}
		
		func startDeliveryPizza () async {
			print(ActivityAuthorizationInfo().areActivitiesEnabled)
			let attr = LiveActivityAttr(title: "Hello World")
			let state = LiveActivityAttr.ContentState(startTime: .now)
			do{
				let activity = try Activity<LiveActivityAttr>.request( attributes: attr, contentState: state, pushType: nil)
				/*
				Task {
					await activity.end(
						using: .init(emoji: "😀"),
						dismissalPolicy: .immediate
					)
				}
				 */
			} catch {
				print("error")
			}
		}
	}
	
}

#Preview {
	Notification.NotificationView()
}
