//
//  CardView.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/10/24.
//

import SwiftUI

struct CardView<Content: View>: View {
    var content: Content
    
    var fillColor: Color = .white
    
    var width: CGFloat
    var height: CGFloat
    
    init(@ViewBuilder content: () -> Content, width: CGFloat, height: CGFloat, fillColor: Color?) {
        self.content = content()
        self.width = width
        self.height = height
        
        if let c = fillColor {
            self.fillColor = c
        }
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(fillColor)
                    .frame(width: width, height: height)
            ).padding(.horizontal)
    }
}

