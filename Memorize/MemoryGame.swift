//
// Created by Roland Schmitz on 30.05.20.
// Copyright (c) 2020 Roland Schmitz. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent : Equatable> {
    var cards: [Card]
    var score: Int = 0

    mutating func choose(card: Card) {
        print("card chosen -> \(card)")
        let faceupCardIndices = cards.indices
            .filter {
                cards[$0].isFaceUp
            }
        if faceupCardIndices.count > 1 {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    cards[index].wasAlreadySeen = true
                    cards[index].isFaceUp = false
                }
            }
        }
        if !card.isMatched, let cardIndex = cards.firstIndex(matching: card), !cards[cardIndex].isFaceUp {
            cards[cardIndex].isFaceUp = true
            if faceupCardIndices.count == 1 {
                if cards[faceupCardIndices[0]].content == cards[cardIndex].content {
                    cards[cardIndex].isMatched = true
                    cards[faceupCardIndices[0]].isMatched = true
                    score += 2
                } else {
                    if cards[cardIndex].wasAlreadySeen {
                        score -= 1
                    }
                    if cards[faceupCardIndices[0]].wasAlreadySeen {
                        score -= 1
                    }
                }

            }
        }
    }

    mutating func shuffleCards() {
        cards.shuffle()
        print("shuffled cards = \(cards)")
    }

    mutating func resetGame() {
        score = 0
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].wasAlreadySeen = false
        }
    }

    init(numberOfPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairs {
            let cardPairContent = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: cardPairContent))
            cards.append(Card(id: pairIndex * 2 + 1, content: cardPairContent))
        }
        shuffleCards()
    }

    struct Card : Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var wasAlreadySeen: Bool = false
    }
}

