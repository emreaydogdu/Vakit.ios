//
//  DhikrView.swift
//  Vakit
//
//  Created by Emre Aydogdu on 25.12.23.
//

import SwiftUI

struct DhikrView: View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var btnBack : some View { Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
		ZStack {
			RoundedRectangle(cornerRadius: 15, style: .continuous)
				.fill(.black.opacity(0.4))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.frame(width: 40, height: 40)
			Image(systemName: "chevron.left") // set image here
				.aspectRatio(contentMode: .fit)
				.frame(width: 45, height: 45)
		}
	}}
	
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: btnBack)
			.toolbar(.hidden, for: .tabBar)
	}
}

#Preview {
	DhikrView()
}
