//
//  DetailView.swift
//  ProximityTest
//
//  Created by Ravikumar, Gowtham on 20/06/21.
//

import SwiftUI
import SwiftUICharts
import Combine

struct DetailView: View {
    
    var item: Quality?
    let blueStyle = ChartStyle(backgroundColor: .white,
                               foregroundColor: [ColorGradient(.purple, .blue)])
    
    var body: some View {
        Text("\(item?.city ?? "")").onReceive(item.publisher.collect()) { value in
            AirPollution.data.append(value[0].aqi)
        }.font(.system(.largeTitle, design: .rounded))
        
        VStack {
            CardView(showShadow: true) {
                ChartLabel("Air Quality", type: .legend)
                BarChart()
            }
            .data(AirPollution.data)
            .chartStyle(blueStyle)
            .padding()
            .onAppear {
                AirPollution.data.removeAll()
            }
        }
    }
}

