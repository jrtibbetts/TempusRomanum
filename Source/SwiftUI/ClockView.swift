//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct ClockView : View {

    @EnvironmentObject private var tempus: Tempus
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Clock()

                // Switches between 12- and 24-hour style.
                Button(action: { self.tempus.useMilitaryTime.toggle() },
                       label: {
                        Text(self.tempus.modernTimeString)
                            .frame(minWidth: 100)
                            .font(.headline)
                }
                    )
                    .padding(.top, 30)

                if self.tempus.romanTimeString != nil {
                    Text(self.tempus.romanTimeString!)
                        .font(.subheadline)
                        .italic()
                        .padding(.top, 10)
                }

                Spacer()
            }
                .navigationBarTitle(
                    Text("TEMPUS ROMANUM")
                )

                .padding(10)
        }
//            .navigationBarItems(trailing: /* Text("Kreplach") */
//                PresentationButton(
//                    Image(systemName: "settings"),
//                    destination: SettingsView()
//                )
//        )
    }
    
}

struct ClockView_Previews : PreviewProvider {
    static var previews: some View {
        return ClockView()
            .environmentObject(ClockSettings())
            .environmentObject(Tempus.debugInstance)
    }
}
