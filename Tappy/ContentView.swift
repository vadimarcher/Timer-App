//
//  ContentView.swift
//  Tappy
//
//  Created by Vadim Archer on 17.06.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var  tappyModel: TappyModel
    var body: some View {
       Home()
            .environmentObject(tappyModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
