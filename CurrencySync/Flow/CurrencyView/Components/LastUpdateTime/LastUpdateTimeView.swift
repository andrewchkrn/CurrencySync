//
//  LastUpdateTimeView.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

struct LastUpdateTimeView: View {
    let lastUpdateTime: Date?
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            updateTimeView(currentDate: timeline.date)
        }
    }
    
    @ViewBuilder
    private func updateTimeView(currentDate: Date) -> some View {
        if let lastUpdateTime = lastUpdateTime {
            timeWithAnimation(lastUpdateTime, currentDate: currentDate)
        } else {
            Text("Not updated yet")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func timeWithAnimation(_ updateTime: Date, currentDate: Date) -> some View {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .second], from: updateTime, to: currentDate)
        
        if let minutes = components.minute, let seconds = components.second {
            HStack(spacing: 4) {
                Text("Updated")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if minutes == 0 {
                    if seconds < 1 {
                        Text("just now")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("\(seconds)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .contentTransition(.numericText())
                            .animation(.easeInOut, value: seconds)
                        
                        Text("seconds ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else if minutes == 1 {
                    Text("1 minute ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("\(minutes)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: minutes)
                    
                    Text("minutes ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
