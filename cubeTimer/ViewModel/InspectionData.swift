//
//  InspectionData.swift
//  cubeTimer
//
//  Created by Oleksii on 21.03.2025.
//

import Foundation
import SwiftUI

final class InspectionData: ObservableObject {
    static let shared = InspectionData()
    private init() {}
    
    @AppStorage("inspectionState") public var inspectionEnabled: Bool = false
    
}
