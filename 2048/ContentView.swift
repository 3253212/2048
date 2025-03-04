//
//  ContentView.swift
//  2048
//
//  Created by cmStudent on 2024/10/27.
//



import SwiftUI


struct ContentView: View {
    @StateObject private var game = GameModel()
   
    var body: some View {
        
        
        NavigationStack{
            VStack{
                switch game.currentView {
                case .home:
                    HomeView().environmentObject(game)
                case .game:
                    GameView().environmentObject(game)
                case .ranking:
                    RankingView().environmentObject(game)
                }
            }
        }
        
//        NavigationStack {
//                VStack {
//                    Spacer()
//                    Text("2048")
//                        .padding()
//                        .font(.system(size: 120))
//                        .bold()
//                        .foregroundColor(.white)
//                    Spacer()
//                    
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
//                    NavigationLink(destination: RankingView()
//                        .environmentObject(game),isActive: $game.isShowRankingView) {
//                        Text("ランキング")
//                            .font(.title)
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//                .background(
//                    Color("background1")
//                    )
//                .ignoresSafeArea()
//                
//                
//                
//            }
//            
        
    }
    
}
//struct Game1View: View {
//    var body: some View {
//        VStack {
//            Text("游戏开始！")
//                .font(.largeTitle)
//                .padding()
//
//            // 你可以在这里放置游戏的视图和逻辑
//        }
//
//    }
//}

#Preview {
    ContentView()
}
