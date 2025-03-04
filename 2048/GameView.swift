//
//  GameView.swift
//  2048
//
//  Created by cmStudent on 2024/10/27.
//


import SwiftUI

struct GameView: View {
//    @ObservedObject var game = GameModel()
    @EnvironmentObject var game:GameModel
    
    var body: some View {
        
        
        
        VStack{
            HStack{
                Button(action: {
                    game.currentView = .home
                }, label: {
                    Text("Back")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding()
                })

                Spacer()
            }
            Spacer()
            Text("点数：\(game.score)")
                .font(.largeTitle)
                .padding()
            
            Text("最高点数：\(game.highScore)")
                .font(.largeTitle)
                .padding()
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    game.reset()
                }, label: {
                    Text("リスタート")
                        .font(.title2)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
            })
                Spacer()
                Button(action: {
                    game.isGameOverFlag = true
                }, label: {
                    Text("諦める")
                        .font(.title2)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                Spacer()
            }
            
            Spacer()
            
            ForEach(0 ..< game.gridSize,id: \.self){ row in
                HStack{
                    ForEach(0 ..< game.gridSize,id: \.self){
                        col in
                        TileView(tile:game.grid[row][col])
                    }
                }
            }
            Spacer()
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded{value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    if abs(horizontalAmount) > abs(verticalAmount){
                        if horizontalAmount > 0 {
                            game.move(.right)
                        }else{
                            game.move(.left)
                        }
                    }else {
                        if verticalAmount > 0 {
                            game.move(.down)
                        } else {
                            game.move(.up)
                        }
                    }
                }
        
        )
        .sheet(isPresented: $game.isGameOverFlag) {
            GameOverSheet()
                .environmentObject(game)
                }
        .onAppear {
                    game.restart() // 每次进入 GameView 时执行 restart 方法
                }
//        .background(
//            Image("2048 game")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//        )
        
       
        
            
        
        
    }
}


struct GameOverSheet: View {
    @EnvironmentObject var game:GameModel
    
    
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.title)
                .padding()
            
            Text("名前を入力してください")
                .font(.headline)
            
            TextField("ゲスト", text: $game.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // 保存分数和名字
                game.addPlayerScore(name: game.name, score: game.highScore)
                    game.restart()
                
                game.isGameOverFlag = false
//                game.isShowRankingView = true
                game.currentView = .ranking
                           }) {
                Text("保存")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
         
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("background1")
            )
    }
}

struct TileView:View {
    let tile:Tile?
    var body: some View{
        ZStack{
            if let tile = tile{
                RoundedRectangle(cornerRadius: 10)
                    .fill(tileColor(value: tile.value))
                    .frame(width: 80, height: 80)
                Text("\(tile.value)")
                    .font(.largeTitle)
                    
                   
            } else{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
            }
        }
        
    }
    
    func tileColor(value:Int) -> Color{
        switch value{
        case 2:return Color.yellow
        case 4:return Color.orange
        case 8:return Color.red
        case 16:return Color.purple
        case 32:return Color.blue
        case 64:return Color.green
        case 128, 256, 512:return Color.pink
        case 1024... :return Color.mint
        default:
            return Color.gray
        }
    }
}

#Preview {
    GameView()
        .environmentObject(GameModel())
}
