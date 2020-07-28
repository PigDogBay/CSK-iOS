//
//  FeedbackRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import MessageUI
import SwiftUtils

struct FeedbackRow: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isPressented = false
    @State private var showAlert = false
    
    func feedback(){
        if MFMailComposeViewController.canSendMail() {
            isPressented = true
        } else if let emailUrl = mpdbCreateEmailUrl(to: Strings.emailAddress, subject: Strings.feedbackSubject, body: "")  {
            UIApplication.shared.open(emailUrl)
        } else {
            showAlert = true
        }
    }
    
    var body: some View {
        Button(action: feedback){
            HStack {
                Image(systemName: "envelope")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.red)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Feedback").font(.title)
                    Text("Email your suggestions and ideas").font(.footnote)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isPressented, content: {MailView(recipient: Strings.emailAddress, subject: Strings.feedbackSubject, result: self.$result)})
        .alert(isPresented: $showAlert){
            Alert(title: Text("Email Not Supported"), message: Text("Please email me at: \(Strings.emailAddress)"), dismissButton: .default(Text("OK")))
        }
    }
}

struct FeedbackRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedbackRow()
            FeedbackRow()
            FeedbackRow()
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
