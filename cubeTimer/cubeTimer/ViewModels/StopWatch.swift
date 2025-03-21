//
//  StopWatch.swift
//  cubeTimer
//
//  Created by Oleksii on 31.12.2024.
//

import Foundation

public class StopWatch: ObservableObject {
    @Published var pausedTime: TimeInterval = 0
    @Published var runningTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var startTime: Date? = nil
    
    @Published var timer: Timer?
    
    public func toggleStopwatch() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            pausedTime += Date().timeIntervalSince(startTime ?? Date())
            isRunning = false
            startTime = nil
        } else {
            startTime = Date()
            isRunning = true
            startTimer()
        }
    }
    
    public func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
            guard let self = self, self.isRunning, let startTime = self.startTime else {
                return
            }
            let elapsed = Date().timeIntervalSince(startTime)
            self.runningTime = (elapsed * 1000).rounded() / 1000
        }
    }
}
