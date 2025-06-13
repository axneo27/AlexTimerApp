//
//  ShareRecordsButton.swift
//  cubeTimer
//
//  Created by Oleksii on 11.06.2025.
//

import SwiftUI

struct ShareRecordsButton: View {
    var action: () -> Void
    @State private var isPressed = false
    @State var color: Color
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .medium))
                
                Text("Share records")
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

struct ShareRecordsButton_Previews: PreviewProvider {
    @State static var bColor: Color = .blue
    static var previews: some View {
        ShareRecordsButton(action: {
            print("Share records tapped")
        }, color: bColor)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
