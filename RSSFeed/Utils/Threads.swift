//
//  Threads.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit

public enum BackgroundThreadPriority {
    case background
    case user_initiated
    case user_interactive
}

public func OnMainThread(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
}

public func OnMainThreadIfNeeded(_ block: @escaping (() -> Void)) {
    if Thread.isMainThread {
        block()
    } else {
        OnMainThread(block)
    }
}

public func OnBackgroundThreadWith(_ priority: BackgroundThreadPriority, _ block: @escaping (() -> Void) ) {
    switch priority {
    case .background:
        DispatchQueue.global(qos: .background).async(execute: block)
        
    case .user_initiated:
        DispatchQueue.global(qos: .userInitiated).async(execute: block)
        
    case .user_interactive:
        DispatchQueue.global(qos: .userInteractive).async(execute: block)
    }
}

public func OnBackgroundThreadIfNeeded(withPriority priority: BackgroundThreadPriority,
                                       _ block: @escaping (() -> Void)) {
    if Thread.isMainThread {
        OnBackgroundThreadWith(priority, block)
    } else {
        block()
    }
}

public func runAfter(_ delay:Double, closure:@escaping ()->()) {
    let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        DispatchQueue.main.async(execute: closure)
    }
}

