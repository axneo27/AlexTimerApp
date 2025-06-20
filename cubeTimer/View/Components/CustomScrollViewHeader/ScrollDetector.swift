//
//  ScrollDetector.swift
//  cubeTimer
//
//  Created by Oleksii on 17.06.2025.
//

import SwiftUI
import CoreGraphics

struct ScrollDetector: UIViewRepresentable {
    
    var onScroll: (CGFloat) -> Void
    
    var onDraggingEnd: (CGFloat, CGFloat) -> Void
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: ScrollDetector

        var isDelegateAdded: Bool = false
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.onDraggingEnd(scrollView.contentOffset.y, 0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        DispatchQueue.main.async {
            if let scrollView = recursiveFindScrollView(view: uiView), !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
        return uiView
    }
    
    func recursiveFindScrollView(view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        } else {
            if let superview = view.superview {
                return recursiveFindScrollView(view: superview)
            } else {
                return nil
            }
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
