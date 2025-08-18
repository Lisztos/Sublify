import SwiftUI

struct ContentView: View {
    @StateObject private var motivatorManager = MotivatorManager()
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 20) {
                        Text("Subliminal Motivator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Subconscious motivation through brief visual cues")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Status:")
                        .fontWeight(.medium)
                    Text(motivatorManager.isRunning ? "Active" : "Inactive")
                        .foregroundColor(motivatorManager.isRunning ? .green : .red)
                }

                HStack {
                    Text("Interval:")
                        .fontWeight(.medium)
                    Text("\(motivatorManager.settings.intervalMinutes) minutes")
                }

                HStack {
                    Text("Display Duration:")
                        .fontWeight(.medium)
                    Text("\(motivatorManager.settings.displayDurationMs) ms")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            HStack(spacing: 15) {
                Button(motivatorManager.isRunning ? "Stop" : "Start") {
                    if motivatorManager.isRunning {
                        motivatorManager.stop()
                    } else {
                        motivatorManager.start()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Settings") {
                    showingSettings = true
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding(30)
        .frame(width: 300, height: 250)
        .sheet(isPresented: $showingSettings) {
            SettingsView(motivatorManager: motivatorManager)
        }
    }
}
