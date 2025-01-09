//
//  sonusApp.swift
//  sonus
//
//  Created by Alfonso Tarallo on 28/11/24.
//

import SwiftUI

@main
struct sonusApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { EmptyView() }
    }
}
