//
//  AppDelegate.swift
//  sonus
//
//  Created by Alfonso Tarallo on 01/12/24.
//

import SwiftUI
import AppKit
import Cocoa
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleWindow = Self("toggleWindow")
    static let closeWindow = Self("closeWindow")
}

class CustomWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    override init() {
        super.init()
        
        KeyboardShortcuts.setShortcut(.init(.z, modifiers: .control), for: .toggleWindow)
        KeyboardShortcuts.setShortcut(.init(.escape), for: .closeWindow)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow()
        setupKeyboardShortcuts()
    }
    
    private func setupWindow() {
        let contentView = ContentView()
        
        window = CustomWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.setFrameAutosaveName("SonusWindow")
        window.contentView = NSHostingView(rootView: contentView)
        window.isMovableByWindowBackground = true
        window.isReleasedWhenClosed = false
        window.isOpaque = false
        window.level = .floating
        window.backgroundColor = .clear
        
        window.collectionBehavior = [.canJoinAllSpaces]
        window.orderFrontRegardless()
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    private func setupKeyboardShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .toggleWindow) { [self] in
            self.toggleWindow()
        }
        
        KeyboardShortcuts.onKeyDown(for: .closeWindow) { [self] in
            self.closeWindow()
        }
    }
    
    private func toggleWindow() {
        if let window = window {
            if window.isVisible {
                NSApp.hide(nil)
            } else {
                window.center()
                
                var windowFrame = window.frame
                windowFrame.origin.y -= windowFrame.height / 3
                window.setFrame(windowFrame, display: true, animate: false)
                
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    private func closeWindow() {
        if let window = self.window, window.isVisible {
            NSApp.hide(nil)
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
    }
}
