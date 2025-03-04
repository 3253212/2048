//
//  RankingView.swift
//  2048
//
//  Created by cmStudent on 2024/10/27.
//

import SwiftUI

struct RankingView: View {
    @EnvironmentObject var game:GameModel
//    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
//        NavigationView{
            
                VStack{
                    Section(header: Text("ランキング").font(.headline)){
                        List(game.playerScores.sorted(by: {$0.score>$1.score})){player in
                            HStack{
                                
                                Text(player.name)
                                Spacer()
                                Text("\(player.score)")
                                
                            }
                        }
                        
                    }.scrollContentBackground(.hidden)
                    
                    Button(action: {
                        game.currentView = .home
//                        game.isShowGameView = false
//                      dismiss()
                       
//                        game.isShowRankingView = false
                                   }) {
                        Text("戻る")
                            .font(.title2)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
//                .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity)
            .background(Color("background1"))
//        }.navigationTitle("ランキング")
    }
}

#Preview {
    RankingView()
        .environmentObject(GameModel())
}
