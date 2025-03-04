//
//  Func.swift
//  2048
//
//  Created by cmStudent on 2024/10/21.
//

import SwiftUI
import AVFoundation

struct Tile:Identifiable{
    let id = UUID()
    var value:Int
    var merged:Bool = false
    
}

struct PlayerScore:Identifiable, Codable{
    var id = UUID()
    let name:String
    let score:Int
    
}



class GameModel:ObservableObject{
    
    @Published var grid:[[Tile?]]
    @Published var score:Int = 0
    @Published var highScore:Int = 0
    @Published var name:String = ""
    @Published var playerScores:[PlayerScore] = []{
        didSet{
            savePlayerScores()
        }
    }
    
    
    @Published var isGameOverFlag:Bool = false
    @Published var isShowRankingView:Bool = false
    @Published var isShowGameView:Bool = false
    @Published var isShowHomeView:Bool = false
    @Published var currentView:ViewState = .home
    
    var moveSound:AVAudioPlayer?
    var mergeSound:AVAudioPlayer?
    
    let gridSize = 4
    
    init(){
        
        grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        addNewTile()
        addNewTile()
                loadSounds()
        loadPlayerScores()
    }
    
    func loadSounds() {
            if let moveSoundURL = Bundle.main.url(forResource: "move", withExtension: "mp3") {
                moveSound = try? AVAudioPlayer(contentsOf: moveSoundURL)
            }
            if let mergeSoundURL = Bundle.main.url(forResource: "merge", withExtension: "mp3") {
                mergeSound = try? AVAudioPlayer(contentsOf: mergeSoundURL)
            }
        }
    
    func playMoveSound() {
            moveSound?.play()
        }

    func playMergeSound() {
            mergeSound?.play()
        }
    
    func addNewTile(){
        var emptyTiles = [(Int,Int)]()
        //        var emptyTiles: [(Int, Int)] = []
        for row in 0 ..< gridSize {
            for col in 0 ..< gridSize{
                if grid[row][col] == nil {
                    emptyTiles.append((row,col))
                }
            }
        }
        if let newTilePosition = emptyTiles.randomElement(){
            grid[newTilePosition.0][newTilePosition.1] = Tile(value:[2,4].randomElement()!)
        }
    }
    
    
    func move(_ direction: Direction){
        var moved = false
        
        resetMergedFlags()
        
        switch direction{
        case .up:
            for col in 0 ..< gridSize{
                for row in 0 ..< gridSize{
                    moved = mergeAndMove(row: row, col: col, dRow: -1, dCol: 0) || moved
                }
            }
        case .down:
            for col in 0 ..< gridSize{
                for row in (0 ..< gridSize-1).reversed(){
                    moved = mergeAndMove(row: row, col: col, dRow: 1, dCol: 0) || moved
                }
            }
        case .left:
            for row in 0 ..< gridSize{
                for col in 0 ..< gridSize{
                    moved = mergeAndMove(row: row, col: col, dRow: 0, dCol: -1) || moved
                }
            }
        case .right:
            for row in 0 ..< gridSize{
                for col in (0 ..< gridSize-1).reversed(){
                    moved = mergeAndMove(row: row, col: col, dRow: 0, dCol: 1) || moved
                }
            }
        }
        if moved {
            addNewTile()
            playMoveSound()
        }
        
        isGameOverFlag = isGameOver()
        
    }
    
    func mergeAndMove(row:Int,col:Int,dRow:Int,dCol:Int) -> Bool{
        
        var currentRow = row
        var currentCol = col
        var moved = false
        
        guard let currentTile = grid[currentRow][currentCol] else {
            return false
        }
        
        while true{
            let nextRow = currentRow + dRow
            let nextCol = currentCol + dCol
            
            if !isValidPosition(row: nextRow, col: nextCol){
                break
            }
            
            if grid[nextRow][nextCol] == nil {
                grid[nextRow][nextCol] = currentTile
                grid[currentRow][currentCol] = nil
                currentRow = nextRow
                currentCol = nextCol
                moved = true
                
            }
            else if grid[nextRow][nextCol]?.value == currentTile.value && !(grid[nextRow][nextCol]?.merged ?? false){
                grid[nextRow][nextCol]?.value *= 2
                grid[nextRow][nextCol]?.merged = true
                grid[currentRow][currentCol] = nil
                score += grid[nextRow][nextCol]?.value ?? 0
                moved = true
                playMergeSound()
                checkForNewHighScore()
                break
            }
            else{
                break
            }
            
        }//while
        
        
        
        return moved
    }
    
    func isValidPosition(row:Int,col:Int) -> Bool {
        return row >= 0 && row < gridSize && col >= 0 && col < gridSize
    }
    
    func resetMergedFlags(){
        for row in 0 ..< gridSize{
            for col in 0 ..< gridSize{
                grid[row][col]?.merged = false
            }
        }
    }
    
    func checkForNewHighScore(){
        if score > highScore{
            highScore = score
        }
    }
    
    func isGameOver() -> Bool {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == nil { // 如果有空位
                    return false
                }
                // 检查相邻的格子是否可以合并
                if col + 1 < gridSize, grid[row][col]?.value == grid[row][col + 1]?.value {
                    return false
                }
                if row + 1 < gridSize, grid[row][col]?.value == grid[row + 1][col]?.value {
                    return false
                }
            }
        }
        return true
    }
    
    func reset(){
        for row in 0 ..< gridSize{
            for col in 0 ..< gridSize{
                grid[row][col] = nil
            }
        }
        addNewTile()
        addNewTile()
        score = 0
    }
    
    func restart(){
        reset()
        score = 0
        highScore = 0
        name = ""
    }
    func savePlayerScores() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playerScores) {
            UserDefaults.standard.set(encoded, forKey: "playerScores")
        }
    }
    
    func loadPlayerScores() {
        if let savedPlayerScoresData = UserDefaults.standard.data(forKey: "playerScores") {
            let decoder = JSONDecoder()
            if let loadedPlayerScores = try? decoder.decode([PlayerScore].self, from: savedPlayerScoresData) {
                self.playerScores = loadedPlayerScores
            }
        }
        
    }
    
    func addPlayerScore(name: String, score: Int) {
            let newPlayerScore = PlayerScore(name: name, score: score)
            playerScores.append(newPlayerScore)
        }
}

enum Direction{
    case up, down, left, right
}

enum ViewState{
    case home,game,ranking
}
