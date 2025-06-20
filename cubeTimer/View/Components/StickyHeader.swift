//
//  StickyHeader.swift
//  cubeTimer
//
//  Created by Oleksii on 17.06.2025.
//

import SwiftUICore

struct StickyHeader<HeaderView: View, ScrollView: View>: View {
    let defaultHeaderHeight: CGFloat
    
    let headerView: (() -> HeaderView)
    let scrollView: (() -> ScrollView)
    @Binding var offset: CGFloat
    
    init(defaultHeaderHeight: CGFloat,
         offset: Binding<CGFloat>,
         headerView: @escaping () -> HeaderView,
         scrollView: @escaping () -> ScrollView) {
        self.defaultHeaderHeight = defaultHeaderHeight
        self._offset = offset
        self.headerView = headerView
        self.scrollView = scrollView
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            scrollView()
                .offset(y: defaultHeaderHeight)
            headerView()
                .frame(height: defaultHeaderHeight)
                .offset(y: getOffset(offset: offset))
                .zIndex(1) 
        }
    }
    
    private func getOffset(offset: CGFloat) -> CGFloat {
        guard offset < .zero else { return .zero }
        if offset > 0 {
            return offset
        } else {
            return 0
        }
    }
}
