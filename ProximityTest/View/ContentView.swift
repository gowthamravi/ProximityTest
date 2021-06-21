//
//  ContentView.swift
//  ProximityTest
//
//  Created by Ravikumar, Gowtham on 19/06/21.
//

import SwiftUI
import Foundation



struct ContentView: View {
    
    @ObservedObject var socket: WebSocketTaskConnection = .init()
    
    var body: some View {
    
        NavigationView {
            VStack{
                List(Array(socket.cityValues.keys), id: \.self) { keys in
                    NavigationLink(destination: DetailView(item:socket.cityValues[keys]!)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(keys)")
                                let aqi = socket.cityValues[keys]?.aqi ?? 0
                                Text("\(String(format: "%.2f",aqi))")
                                    .font(.subheadline)
                                    .foregroundColor(self.getColor(value: aqi))
                            }
                            Spacer()
                            Text(Date().timeSinceDate(fromDate: socket.cityValues[keys]?.date ?? Date()))
                        }
                    }
                }
            }
            .navigationBarTitle("Air Quality Monitorinng")
            
        }.alert(item: $socket.alertMessage) { $0.alert }

    }

    func getColor(value: Double) -> Color {
        if value <= 50.0 {
            return Color(red: 106 / 255.0, green: 165 / 255.0, blue: 89 / 255.0)
        } else if value >= 51.0 && value <= 100.0 {
            return Color(red: 106 / 255.0, green: 165 / 255.0, blue: 89 / 255.0)
        } else if value >= 101.0 && value <= 200.0 {
            return Color(red: 255 / 255.0, green: 246 / 255.0, blue: 95 / 255.0)
        } else if value >= 201.0 && value <= 300.0 {
            return Color(red: 221 / 255.0, green: 152 / 255.0, blue: 74 / 255.0)
        } else if value >= 301.0 && value <= 400.0 {
            return Color(red: 216 / 255.0, green: 77 / 255.0, blue: 62 / 255.0)
        } else {
            return Color(red: 162, green: 56, blue: 44 / 255.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



