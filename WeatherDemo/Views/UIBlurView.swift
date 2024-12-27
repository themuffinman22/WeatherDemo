//
//  UIBlurView.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/18/24.
//

import Foundation
import SwiftUI

// for blur effect used in backgrounds
struct UIBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return effectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
