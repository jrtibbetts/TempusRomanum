//: A UIKit based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

extension Double {

    static var twoPi: Double {
        return Double.pi * 2
    }

}
struct RadianView: View {

    static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 0.0
        formatter.maximum = NSNumber(value: Double.twoPi)
        formatter.numberStyle = .decimal

        return formatter
    }()

    @State var thickness: CGFloat = 20.0

    @State var radians: Double

    var percentage: CGFloat {
        return CGFloat(radians / Double.twoPi)
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(lineWidth: thickness)
                    .foregroundColor(.red /*Gradient(colors: [.blue, .purple])*/)

                // Progress overlay
                Circle()
                    .trim(from: 0.0, to: percentage)
                    .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.red)
                    .rotationEffect(Angle(degrees: 270.0))

                VStack {
                    let radianString = RadianView.formatter.string(from: NSNumber(value: radians))
                    Text("Radians: \(radianString!)")
                    let angleString = RadianView.formatter.string(from: NSNumber(value: Angle(radians: radians).degrees))
                    Text("Degrees: \(angleString!)")
                }
            }

            Slider(value: $radians,
                   in: 0...Double.twoPi)
        }
    }

}

PlaygroundPage.current.setLiveView(
    RadianView(radians: Double.pi)
        .frame(width: 400.0, height: 400.0)
)
