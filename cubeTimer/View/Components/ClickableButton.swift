//
//  ClickableButton.swift
//  cubeTimer
//
//  Created by Oleksii on 11.06.2025.
//

import SwiftUI

struct ClickableButton: View {
    var text: String
    var action: () -> Void
    @State private var isPressed = false
    var color: Color
    var image: String?
    var imageColor: Color?
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            action()
        }) {
            HStack(spacing: 10) {
                if image != nil {
                    Image(systemName: image!)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor((imageColor != nil) ? imageColor! : .white)
                }
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(color)
            .cornerRadius(8)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    isPressed = true
                })
                .onEnded({ _ in
                    isPressed = false
                })
        )
    }
}

struct ClickableButton_Previews: PreviewProvider {

    static var previews: some View {
        ClickableButton(text: "Share records", action: {
            print("Share records tapped")
        }, color: .blue, image: "square.and.arrow.up")
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
