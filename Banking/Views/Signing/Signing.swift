//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import SwiftUI

struct Signing: View {
    @State var email: String = ""
    @State var password: String = ""
    @StateObject var auth: Auth
    
    private func submit () {
        do {
            try auth.signIn(username: email, password: password)
        } catch {
            print("Error signing in")
        }
    }
    
    var body: some View {
        VStack {
            Text("tezxt")
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Submit!", action: submit)
        }
        .padding([.top, .bottom, .leading, .trailing], 15)
        .bAlignment(.center)
        .foregroundColor(.text.normal)
        .background(.background)
    }
}


//struct Signing_Preview: PreviewProvider {
//    
//    
//    static var previews: some View {
//        Signing(try! Auth.getAuth()).previewLayout(.sizeThatFits)
//    }
//}
