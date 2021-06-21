//
//  WebSocket.swift
//  ProximityTest
//
//  Created by Ravikumar, Gowtham on 19/06/21.
//

import Foundation
import SwiftUI

struct AlertMessage: Identifiable {
  let id = UUID()
  let alert: Alert
}

final class WebSocketTaskConnection: ObservableObject {
    
    var webSocketTask: URLSessionWebSocketTask!
    var urlSession: URLSession
    @Published var cityValues = [String: Quality]()
    @Published var alertMessage: AlertMessage?
    
    
    var alert: Alert? {
      didSet {
        guard let a = self.alert else { return }
        DispatchQueue.main.async {
          self.alertMessage = .init(alert: a)
        }
      }
    }
    
    init() {
        self.alertMessage = nil
        self.urlSession = URLSession(configuration: .default)
        self.connect()
    }
    
    func connect() {
        self.webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://city-ws.herokuapp.com")!)
        webSocketTask.resume()
        listen()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocketTask.receive { result in
            switch result {
            case .failure(_):
                self.webSocketTask.cancel(with: .goingAway, reason: nil)
                let alert = Alert(title: Text("ProximityTest"), message: Text("Something went wrong!"), primaryButton: .default(Text("Try again"), action: {
                    self.connect()
                }), secondaryButton: .default(Text("Dismiss")))                
                
                self.alert = alert
                
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let str):
                    guard let data = str.data(using: .utf8) else { return }
                    self.handle(data)
                @unknown default:
                    break
                }
                self.listen()
            }
        }
    }
    
    func handle(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let quality = try decoder.decode([Quality].self, from: data)
            DispatchQueue.main.async {
                
                for data in quality {
                    var currentCityQuality = data
                    currentCityQuality.date = Date()
                    self.cityValues[data.city] = currentCityQuality
                }
            }
        } catch {
            print(error)
        }
    }
}
