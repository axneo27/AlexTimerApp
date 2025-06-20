//
//  PopUp.swift
//  cubeTimer
//
//  Created by Oleksii on 12.05.2025.
//

import SwiftUI

extension View {

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                view: view)
        )
    }
}

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    
    init(isPresented: Binding<Bool>,
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.view = view
    }
    
    @Binding var isPresented: Bool
    
    var view: () -> PopupContent
    
    @State private var presenterContentRect: CGRect = .zero
    
    @State private var sheetContentRect: CGRect = .zero
    
    private var displayedOffset: CGFloat {
        -presenterContentRect.midY + screenHeight/2
    }
    
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1000
        }
        return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
    }
    
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    // MARK: - Content Builders
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
        }
        .overlay(sheet())
    }
    
    func sheet() -> some View {
        ZStack {
            self.view()
                .simultaneousGesture(
                    TapGesture().onEnded {
                        dismiss()
                    })
                .frameGetter($sheetContentRect)
                .frame(width: screenWidth)
                .offset(x: 0, y: currentOffset)
                .animation(Animation.easeOut(duration: 0.3), value:
                            currentOffset)
        }
    }
    
    private func dismiss() {
        isPresented = false
    }
}
