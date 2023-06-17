//
//  SettingsHelp.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/16/23.
//

import SwiftUI

struct SettingsHelp: View {
    @State var isPresentingAlert = false
    var title: String
    var alertTitle: String
    var alertText: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: {
                isPresentingAlert = true
            }) {
                Image(systemName: "questionmark.circle")
                    .accessibilityLabel("Help button")
            }
            .alert(isPresented: $isPresentingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Got it!")))
            }
        }
    }
}

struct SettingsHelp_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHelp(title: "Refreshes", alertTitle: "About Background Refreshes", alertText: "hfashdflashdfiouwhrlkahkjsgdjfhgakjsdhgfkajhsdgfkajhs")
    }
}
