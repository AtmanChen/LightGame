//
//  GameManager.swift
//  LightGame
//
//  Created by Buck on 2019/10/18.
//  Copyright © 2019 Buck. All rights reserved.
//

import SwiftUI


class GameManager: ObservableObject {
    
    @Published var lights: [[Light]] = []
    @Published var isWin = false
    
    private(set) var size: Int
    private var currentStatus: GameStatus = .during {
        didSet {
            switch currentStatus {
            case .win: isWin = true
            case .lose: isWin = false
            default: break
            }
        }
    }
    
    init(size: Int) {
        self.size = size
    }
    
    convenience init(size: Int = 5,
                     lightSequence: [Int] = []) {
        
        var size = size
        if size > 8 {
            size = 7
        }
        if size < 2 {
            size = 2
        }
        self.init(size: size)
        lights = Array(repeating: Array(repeating: Light(), count: size), count: size)
        start(lightSequence)
    }
    
    func updateLight(at row: Int, column: Int) {
        self.lights[row][column].status.toggle()
        let top = row - 1
        let down = row + 1
        if top >= 0 {
            self.lights[top][column].status.toggle()
        }
        if down < lights.count {
            self.lights[down][column].status.toggle()
        }
        
        let left = column - 1
        let right = column + 1
        if left >= 0 {
            self.lights[row][left].status.toggle()
        }
        if right < self.lights[row].count {
            self.lights[row][right].status.toggle()
        }
    }
    
    private func updateLightStatus(_ lightSequence: [Int]) {
        for lightIndex in lightSequence {
            var row = lightIndex / size
            let column = lightIndex % size
            if column > 0 && row >= 0 {
                row += 1
            }
            updateLight(at: row, column: column)
        }
    }
    
    func circleWidth() -> CGFloat {
        let edges: CGFloat = 20
        let innerSpacing: CGFloat = 20
        var circleWidth = (UIScreen.main.bounds.width - edges - CGFloat(size) * innerSpacing) / CGFloat(size)
        if size < 5 {
            circleWidth = UIScreen.main.bounds.width / 5
        }
        return circleWidth
    }
    
    private func udpateGameStatus() {
        let lightStatus = lights.flatMap { $0 }.map { $0.status }
        let lightingCount = lightStatus.filter { $0 == true }
        if lightingCount.count == size * size {
            currentStatus = .lose
            return
        }
        if lightingCount.count == 0 {
            currentStatus = .win
            return
        }
    }
    
    func start(_ lightSequence: [Int]) {
        currentStatus = .during
        updateLightStatus(lightSequence)
    }
    
}

extension GameManager {
    enum GameStatus {
        case win
        case lose
        case during
    }
}
