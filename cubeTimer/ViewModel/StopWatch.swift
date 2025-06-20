//
//  StopWatch.swift
//  cubeTimer
//
//  Created by Oleksii on 31.12.2024.
//

import Foundation
import QuartzCore

public class StopWatch: ObservableObject {
    @Published private(set) var runningTime: TimeInterval = 0
    @Published private(set) var isRunning: Bool = false
    
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var displayLink: CADisplayLink?
    
    private let preferredFPS: Int = 60
    
    public func toggleStopwatch() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }
    
    public func start() {
        guard !isRunning else { return }
        
        startTime = Date()
        isRunning = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink?.preferredFramesPerSecond = preferredFPS
        displayLink?.add(to: .main, forMode: .common)
    }
    
    public func stop() {
        guard isRunning else { return }
        
        accumulatedTime += Date().timeIntervalSince(startTime ?? Date())
        displayLink?.invalidate()
        displayLink = nil
        isRunning = false
        startTime = nil
        
        accumulatedTime = 0
    }
    
    public func reset() {
        stop()
        runningTime = 0
        accumulatedTime = 0
    }
    
    @objc private func updateTime() {
        guard isRunning, let startTime = startTime else { return }
        runningTime = accumulatedTime + Date().timeIntervalSince(startTime)
    }
}
