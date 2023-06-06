//
//  CreateFlowView.swift
//  Banking
//
//  Created by Toby Clark on 15/5/2023.
//

import Foundation
import SwiftUI


struct CreateFlowView: View {
    var auth: Auth
    @State var username: String = ""
    @State var password: String = ""
    @State var screen = ""
    @State var pin: String = ""
    @StateObject var name: UsersName = UsersName(fName: "", lName: "")
    
    init (_ auth: Auth) {
        self.auth = auth
    }
    
    func userPassComplete () {
        screen = "info"
    }

    func pinBioComplete () {
        Task {
            do {
                try await auth.createUser(username: username, password: password, name: name, pin: pin, biometrics: .biometrics)
            } catch let error as AuthError {
                print(type(of: error))
                print(error.kind, error.error, error.message as Any)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func infoComplete () {
        screen = "alternatives"
    }
    
    var body: some View {
        switch screen {
            case "info": CreateUserInfo(finish: infoComplete, name: name)
            case "alternatives": CreatePinAndBio(finish: pinBioComplete, pin:$pin)
            default: CreateUserPass(finish: userPassComplete, username: $username, password: $password)
        }
    }
}


struct CreateUserPass: View {
    let finish: () -> Void
    @Binding var username: String
    @Binding var password: String
    
    
    var body: some View {
        VStack {
            Text("Email and Password - create")
            TextField("Email", text: $username).autocorrectionDisabled().textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Submit", action: {() in finish()})
        }
    }
}

struct CreatePinAndBio: View {
    let finish: () -> Void
    @Binding var pin: String
    
    var body: some View {
        SecureField("Pin", text: $pin)
        Button("Enable biometrics", action: {() in print("enable biometrics")})
        Button("Skip", action: {() in finish()})
        Button("Submit", action: {() in finish()})
    }
}


struct CreateUserInfo: View {
    let finish: () -> Void
    @ObservedObject var name: UsersName
    
    var body: some View {
        TextField("Name", text:$name.fName)
        Button("Submit", action: {() in finish()})
    }
}
