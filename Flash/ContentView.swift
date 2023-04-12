//
//  ContentView.swift
//  Flash
//
//  Created by Hariz Shirazi on 2023-04-12.
//

import SwiftUI
import MacDirtyCow

struct ContentView: View {
    @State var speed: Double = 1.0
    var body: some View {
        NavigationView {
            VStack {
                Slider(value: $speed, in: 0.0 ... 10.0, step: 0.1, label: {
                    Text("Set animation speed")})
                Text("\(String(format: "%.1f", speed))x")
                Button(action: {
                    Haptic.shared.play(.medium)
                    do {
                        try changeSpeed(speed)
                        Haptic.shared.notify(.success)
                        MacDirtyCow.restartFrontboard()
                    } catch {
                        Haptic.shared.notify(.error)
                        UIApplication.shared.alert(body: error.localizedDescription)
                    }
                }, label: {Label("Apply", systemImage: "checkmark.seal")})
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .padding()
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    if escaped {
                        speed = getSpeed()
                    }
                }
            }
            
            .navigationTitle("Flash")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
