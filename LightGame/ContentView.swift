//
//  ContentView.swift
//  LightGame
//
//  Created by Buck on 2019/10/18.
//  Copyright © 2019 Buck. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameManager: GameManager
    
    private let innerSpacing = 30
    
    init() {
        gameManager = GameManager(size: 5, lightSequence: [1, 2, 3])
    }
    
    var body: some View {
        ForEach(0..<gameManager.lights.count) { row in
            HStack(spacing: 20) {
                ForEach(0..<self.gameManager.lights[row].count) { column in
                    Circle()
                        .foregroundColor(self.gameManager.lights[row][column].status ? .yellow : .gray)
                        .opacity(self.gameManager.lights[row][column].status ? 0.8 : 0.5)
                        .frame(width: self.gameManager.circleWidth(), height: self.gameManager.circleWidth())
                        .shadow(color: .yellow, radius: self.gameManager.lights[row][column].status ? 10.0 : 0.0)
                        .onTapGesture {
                            self.gameManager.updateLight(at: row, column: column)
                        }
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        }
        .alert(isPresented: $gameManager.isWin) {
            Alert(title: Text("瞎猫碰到死耗子!"),
                  dismissButton: .default(Text("重来")) {
                    self.gameManager.start([3, 2, 1])
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
