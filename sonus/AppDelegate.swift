//
//  AppDelegate.swift
//  sonus
//
//  Created by Alfonso Tarallo on 01/12/24.
//

import SwiftUI
import AppKit
import Cocoa

class CustomWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow()
        setupGlobalShortcut()
    }
    
    private func setupWindow() {
        let contentView = ContentView()
        
        window = CustomWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isMovableByWindowBackground = true
        
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: contentView)
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.setFrameAutosaveName("OverlayWindow")
        
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        window.center()
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func setupGlobalShortcut() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 49 && event.modifierFlags.contains(.option) && event.modifierFlags.contains(.shift) { // 49 is Spacebar
                self?.toggleWindow()
            } else if event.keyCode == 53 { // 53 is ESC
                if let window = self?.window {
                    if window.isVisible {
                        NSApp.hide(nil)
                    }
                }
            } else {
                
            }
        }
    }
    
    private func toggleWindow() {
        if let window = window {
            if window.isVisible {
                NSApp.hide(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
