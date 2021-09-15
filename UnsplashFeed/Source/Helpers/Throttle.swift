//
//  Throttle.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 15/09/2021.
//

import Foundation
import UIKit

public class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var maxInterval: Double
    fileprivate let semaphore: DispatchSemaphoreWrapper
    
    init(seconds: Double) {
        self.maxInterval = seconds
        self.semaphore = DispatchSemaphoreWrapper(withValue: 1)
    }
    
    
    func throttle(block: @escaping () -> ()) {
        
        self.semaphore.sync  { () -> () in
            job.cancel()
            job = DispatchWorkItem(){ [weak self] in
                self?.previousRun = Date()
                block()
            }
            let delay = Date.second(from: previousRun) > maxInterval ? 0 : maxInterval
            queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
        }
        
    }
}
 
private extension Date {
    static func second(from referenceDate: Date) -> Double {
        return Date().timeIntervalSince(referenceDate).rounded()
    }
}

public struct DispatchSemaphoreWrapper {
    
    private let semaphore: DispatchSemaphore
    
    public init(withValue value: Int) {
        
        self.semaphore = DispatchSemaphore(value: value)
    }
    
    public func sync<R>(execute: () throws -> R) rethrows -> R {
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        defer { semaphore.signal() }
        return try execute()
    }
}
