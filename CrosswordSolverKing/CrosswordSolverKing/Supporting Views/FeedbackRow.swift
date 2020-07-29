//
//  FeedbackRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FeedbackRow: View {
    @ObservedObject private var viewModel = AboutViewModel()
    
    var body: some View {
        Button(action: viewModel.feedback){
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
        .sheet(isPresented: $viewModel.isMailVCPressented, content: {MailView(recipient: Strings.emailAddress, subject: Strings.feedbackSubject, result: self.$viewModel.result)})
        .alert(isPresented: $viewModel.showNoEmailAlert){
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
