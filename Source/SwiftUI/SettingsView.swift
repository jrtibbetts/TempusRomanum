//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct SettingsView : View {
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
        }
            .navigationBarTitle(Text("Settings"))
        .navigationBarItems(trailing: Text("Settings"))
    }
    
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
