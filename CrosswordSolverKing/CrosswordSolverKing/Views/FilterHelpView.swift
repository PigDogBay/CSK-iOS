//
//  FilterHelpView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 29/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FilterSectionView: View {
    let title : String
    let description : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top, 8)
                .padding(.bottom, 8)

            Text(description)
                .font(.body)
        }
        .padding(8)
    }
}

struct FilterHelpView: View {
    @EnvironmentObject var coordinator : Coordinator
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "lightbulb")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.yellow)
                    .padding(8)
                Text("Filters")
                    .font(.largeTitle)
                Spacer()
            }
            Text("To reduce the number of matches you can add extra search criteria. From the main screen press the Filters button to add filters, when you go back to the main screen the filters will be applied and will remain for other searches. Press the reset button to clear any filters.")
                .padding(8)
            FilterSectionView(title: "FILTER BY LETTERS", description: "Contains: The order of the letters does not matter and you can specify a letter more than once. So 'Contains aabc' will only allow matches that contain at least 2 a's, 1 b and 1 c.\n\nExcludes: Removes any matches that contain any of the letters that you specify.\n\nDistinct: Allows or removes matches where all the letters are different. \n\nTip! Use the Distinct and Exclude filters for Codeword puzzles.")
            FilterSectionView(title: "FILTER BY WORDS", description: "Contains Word: Only allows matches that contain the specified word.\n\nExcludes Word: Only allows matches that do NOT contain the specified word.")
            FilterSectionView(title: "PREFIX / SUFFIX", description: "Only allow matches that start or end with the specified words")
            FilterSectionView(title: "EXPERT FILTERS", description: "Pattern Filter: Similar to a Crossword search, use ? for an unknown letter.  So ?tr??? will look for 6 letter words where the second letter is a t and the third an r. This is useful for Scrabble games where you specify the letters on the board you want to use. You also can use @ to mean 1 or more letters.\n\nReg Exp: Create powerful search patterns using Regular Expression.\n\nExamples\n [aeiou] letter must be a vowel.\n [a-z]+ any letter one or more times.\n [aeiou][a-z]+[aeiou] Matches words that start and end with a vowel.\n\nTip! Use * for the main search query to filter against the entire word list.")
            FilterSectionView(title: "WORD SIZE", description: "Only allow words that are equal to, smaller than or greater than the specified size.\n\nThese filters are useful for anagram searches when you need to find words of a certain length.")
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
        .onAppear(perform: {self.coordinator.onAppear(screen: .FilterHelp)})
        .onDisappear(perform: {self.coordinator.onDisappear(screen: .FilterHelp)})
    }}

struct FilterHelpView_Previews: PreviewProvider {
    static var previews: some View {
        FilterHelpView()
    }
}
