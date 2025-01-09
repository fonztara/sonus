//
//  SettingsButton.swift
//  sonus
//
//  Created by Alfonso Tarallo on 09/01/25.
//

import SwiftUI

struct SettingsButton: View {
    @EnvironmentObject var settings: AppSettings
    @State var isHovering: Bool = false
    
    var body: some View {
        Button {
            settings.isInSettings.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.background)
                
                if isHovering {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.white.opacity(0.3))
                }
                
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            }
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            if hovering {
                withAnimation(.easeIn(duration: 0.05)) {
                    isHovering = hovering
                }
            } else {
                isHovering = hovering
            }
        }
    }
}

#Preview {
    SettingsButton()
}
