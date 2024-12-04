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
    var keyDownGlobalMonitor: Any? = nil
    var keyDownLocalMonitor: Any? = nil
    var mouseClickEventMonitor: Any? = nil
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow()
        setupEventMonitors()
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
    
    
    private func setupEventMonitors() {
        let windowKeycodes: [UInt16] = [6] // Z
        let windowModifierFlags: NSEvent.ModifierFlags = [.control]
        let closeWindowKeycode: UInt16 = 53 // ESC
        
        keyDownGlobalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return }
            
            if windowKeycodes.contains(event.keyCode) && windowModifierFlags.isSubset(of: event.modifierFlags) { // 49 is Spacebar
                self.toggleWindow()
            } else if event.keyCode == closeWindowKeycode {
                if let window = self.window, window.isVisible {
                    NSApp.hide(nil)
                }
            }
        }
        
        keyDownLocalMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }

            if windowKeycodes.contains(event.keyCode) && windowModifierFlags.isSubset(of: event.modifierFlags) {
                self.toggleWindow()
                return nil
            } else if event.keyCode == closeWindowKeycode {
                if let window = self.window, window.isVisible {
                    NSApp.hide(nil)
                }
                return nil
            }

            return event
        }
        
        mouseClickEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
            guard let self = self else { return }
            
            let windowFrame = self.window.frame
            let mouseLocation = NSEvent.mouseLocation
            
            if !windowFrame.contains(mouseLocation) {
                self.window.close()
            }
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
    
    func applicationWillTerminate(_ notification: Notification) {
        if let keyDownGlobalMonitor = keyDownGlobalMonitor {
            NSEvent.removeMonitor(keyDownGlobalMonitor)
        }
        if let keyDownLocalMonitor = keyDownLocalMonitor {
            NSEvent.removeMonitor(keyDownLocalMonitor)
        }
        if let mouseClickEventMonitor = mouseClickEventMonitor {
            NSEvent.removeMonitor(mouseClickEventMonitor)
        }
    }
}
