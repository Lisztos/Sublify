import SwiftUI

struct ContentView: View {
  @StateObject private var sublifyManager = SublifyManagerShared.shared
  @State private var showingSettings = false

  var body: some View {
    VStack(spacing: 0) {
      // Clean Background
      SublifyCleanBackground()

      VStack(spacing: SublifySpacing.xxl) {
        // Clean Header - Centered App Icon and Title
        VStack(spacing: SublifySpacing.lg) {
          // Clean App Icon
          RoundedRectangle(cornerRadius: SublifyRadius.lg)
            .fill(Color.sublifyPrimary)
            .frame(width: 56, height: 56)
            .overlay(
              Image(systemName: "brain.head.profile")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            )

          VStack(spacing: SublifySpacing.xs) {
            Text("Sublify")
              .font(.system(size: 28, weight: .bold, design: .default))
              .foregroundColor(.sublifyText)

            Text("Subliminal motivation made simple")
              .font(.sublifyBody)
              .foregroundColor(.sublifyTextSecondary)
              .multilineTextAlignment(.center)
          }
        }

        // Modern Status Section
        VStack(spacing: SublifySpacing.lg) {
          // Status Header
          HStack {
            Text("Current Status")
              .font(.sublifyH3)
              .foregroundColor(.sublifyText)

            Spacer()

            SublifyStatusBadge(
                          text: sublifyManager.isRunning ? "Active" : "Inactive",
            status: sublifyManager.isRunning ? .active : .inactive
            )
          }

          // Stats Grid
          HStack(spacing: SublifySpacing.lg) {
            // Interval Stat
            SublifyModernCard(hasBorder: true, useSecondaryBackground: false) {
              VStack(spacing: SublifySpacing.xs) {
                Text("Interval")
                  .font(.sublifyCaption)
                  .foregroundColor(.sublifyTextSecondary)
                  .textCase(.uppercase)
                  .tracking(0.5)
                Text("\(sublifyManager.settings.intervalMinutes)")
                  .font(.system(size: 24, weight: .bold, design: .default))
                  .foregroundColor(.sublifyText)
                Text("minutes")
                  .font(.sublifyBodySmall)
                  .foregroundColor(.sublifyTextSecondary)
              }
            }

            // Duration Stat
            SublifyModernCard(hasBorder: true, useSecondaryBackground: false) {
              VStack(spacing: SublifySpacing.xs) {
                Text("Duration")
                  .font(.sublifyCaption)
                  .foregroundColor(.sublifyTextSecondary)
                  .textCase(.uppercase)
                  .tracking(0.5)
                Text("\(sublifyManager.settings.displayDurationMs)")
                  .font(.system(size: 24, weight: .bold, design: .default))
                  .foregroundColor(.sublifyText)
                Text("milliseconds")
                  .font(.sublifyBodySmall)
                  .foregroundColor(.sublifyTextSecondary)
              }
            }
          }

          // Settings Button
          HStack {
            Button(action: {
              showingSettings = true
            }) {
              HStack(spacing: 3) {
                Text("Customize Settings")
                  .font(.system(size: 14, weight: .medium))
              }
              .foregroundColor(.sublifyTextSecondary)
            }
            .buttonStyle(.plain)
            .onHover { isHovered in
              if isHovered {
                NSCursor.pointingHand.set()
              } else {
                NSCursor.arrow.set()
              }
            }
          }
        }

                // Main Action Button
        Button(sublifyManager.isRunning ? "Stop Session" : "Start Session") {
          if sublifyManager.isRunning {
            sublifyManager.stop()
          } else {
            sublifyManager.start()
          }
        }
        .buttonStyle(SublifyPrimaryButtonStyle())
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .onHover { isHovered in
          if isHovered {
            NSCursor.pointingHand.set()
          } else {
            NSCursor.arrow.set()
          }
        }
      }
      .padding(SublifySpacing.xxl)
    }
    .frame(width: 450, height: 550)
    .background(Color.sublifyBackground)
    .sheet(isPresented: $showingSettings) {
      SettingsView(sublifyManager: sublifyManager)
    }
  }
}