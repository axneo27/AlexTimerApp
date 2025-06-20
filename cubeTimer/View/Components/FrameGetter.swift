//
//  FrameGetter.swift
//  cubeTimer
//
//  Created by Oleksii on 12.05.2025.
//

import SwiftUI

extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}
  
struct FrameGetter: ViewModifier {
  
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
DispatchQueue.main.async {
                            self.frame = rect
                        }
                       }
                return AnyView(EmptyView())
            })
    }
}
