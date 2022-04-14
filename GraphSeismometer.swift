//
//  GraphSeismometer.swift
//  SPM_Seismometer
//
//  Created by Luiz Araujo on 13/04/22.
//

import SwiftUI

struct GraphSeismometer: View {
    @EnvironmentObject private var detector: MotionDetector
    @State private var data = [Double]()
    let maxData = 1000
    
    @State private var sensitivity = 0.0
    let graphMaxValueMostSensitive = 0.01
    let graphMaxValueLeastSensitive = 1.0
    
    var graphMaxValue: Double {
        graphMaxValueMostSensitive + (1 - sensitivity) * (graphMaxValueLeastSensitive - graphMaxValueMostSensitive)
    }
    
    var graphMinValue: Double {
        -graphMaxValue
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            LineGraph(data: data, maxData: maxData, minValue: graphMinValue, maxValue: graphMaxValue)
                .clipped()
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(20)
                .padding()
                .aspectRatio(1, contentMode: .fit)
            
            Spacer()
            
            Text("Sensitivity")
                .font(.headline)
            
            Slider(value: $sensitivity, in: 0...1, minimumValueLabel: Text("Min"), maximumValueLabel: Text("Max")) {
                Text("Sensitivity")
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            detector.onUpdate = {
                data.append(-detector.zAcceleration)
                if data.count > maxData {
                    data = Array(data.dropFirst())
                }
            }
        }
    }
}

struct GraphSeismometer_Previews: PreviewProvider {
    static var previews: some View {
        GraphSeismometer()
    }
}
