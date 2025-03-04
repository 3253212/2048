//
//  HomeView.swift
//  2048
//
//  Created by cmStudent on 2024/10/29.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var game:GameModel
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("2048")
                    .padding()
                    .font(.system(size: 120))
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                
                Button(action: {
                    game.currentView = .game
                }, label: {
                    Text("始める")
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
               
                
                //                    NavigationLink(destination: GameView()
                //                        .environmentObject(game),isActive: $game.isShowGameView)
                //                    {
                //                        Text("始める")
                //                            .font(.title)
                //                            .padding()
                //                            .background(Color.orange)
                //                            .foregroundColor(.white)
                //                            .cornerRadius(10)
                //                    }
                //                    .padding()
                
                
                Button(action: {
                    game.currentView = .ranking
                }, label: {
                    Text("ランキング")
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)                })
               
                
                
//                NavigationLink(destination: RankingView()
//                    .environmentObject(game),isActive: $game.isShowRankingView) {
//                        Text("ランキング")
//                            .font(.title)
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                Color("background1")
            )
            .ignoresSafeArea()
            
            
            
        }
    }
}

#Preview {
    HomeView().environmentObject(GameModel())
}
