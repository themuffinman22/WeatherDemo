//
//  MessageCardView.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/18/24.
//

import Foundation
import SwiftUI

// view for message card
struct MessageCardView: View {
    let messageCard: MessageCard
    
    var body: some View {
        HStack{
            Spacer()
            ZStack {
                // Apply the blur effect with rounded corners here
                UIBlurView(style: .systemMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip the blurred view with rounded corners
                    .shadow(radius: 10) // Apply shadow to the blurred background
                VStack{
                    HStack {
                        Spacer()
                        Text(messageCard.message)
                            .font(.title2)
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if messageCard.isLoading {
                            // ProgressView for loading
                            ProgressView()
                                .scaleEffect(1.5)
                        } else {
                            // default to alert style 
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding(20)
            }
            .fixedSize(horizontal: true, vertical: true)
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height)
    }
}

#Preview {
    MessageCardView(messageCard: .example)
}

