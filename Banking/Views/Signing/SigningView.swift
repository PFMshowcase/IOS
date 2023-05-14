//
//  Signing.swift
//  Banking
//
//  Created by Toby Clark on 12/5/2023.
//

import SwiftUI

struct SigningView: View {
    @State var email: String = ""
    @State var password: String = ""
    @StateObject var auth: Auth
    
    private func submit () {
        do {
//            try auth.signIn(username: email, password: password)
            try auth.signIn(.biometrics)
        } catch let err {
            print("Error signing in")
            print(err)
        }
    }
    
    var body: some View {
        VStack {
            Text("text")
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
