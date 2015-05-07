//
//  SingleGameViewController.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/6/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit






class SingleGameViewController: GameViewController, UIAlertViewDelegate {
    var game_resumed: Bool = false;  /* indicator of whether a player starts a new game or restarts the old one */
    
    
    var dismiss_delegate: SingleGameViewControllerDelegate!;  // delegate responsible for dismissing game view controller
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if (self.game_resumed) {
            self.performGameIntro(animate: false);
            self.updateHands();
            self.updatePile(isOpponent: true, cards: self.game.players[1].pile);
            self.updatePile(isOpponent: false, cards: self.game.players[0].pile);
            
            self.startNewHand();
        }
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        // NOTE: only if we start a new game, we want a default
        // initialization of the game (deal the cards and update hands);
        // otherwise, we DO NOT deal the cards at this moment, but only update the UI
        if (!self.game_resumed) {
            super.viewDidAppear(animated);
        }
    }
    
    
    
    
    override func listenToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backButtonAction", name: ENTERED_BACKGROUND, object: nil)
    }
    
    
    
    
    /* Computer responds to the move initiated by the player. */
    override func opponentRespond() {
        self.computerMakeMove(response: true);
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(4 * CARDS_ANIMATION_DURATION, target: self, selector: "handDidFinish", userInfo: nil, repeats: false);
    }
    
    
    
    
    /* Computer initiates a move. */
    override func opponentInitiate() {
        self.computerMakeMove(response: false);
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(2 * CARDS_ANIMATION_DURATION, target: self, selector: "unblockHand", userInfo: nil, repeats: false);
    }
    
    
    
    
    /* If response is true, computer responds to a move; otherwise, he initiates it. */
    func computerMakeMove(#response: Bool) {
        self.game.players[1].cards_in_play = response ? self.game.computerRespond(self.game.players[0].cards_in_play, player_id: 1) : self.game.computerInitiate();
        for card in self.game.players[1].cards_in_play {
            let card_button = self.getButtonForCard(card);
            card_button.setFace(card);
            self.makeCardMove(card_button, moveUp: true, isOpponent: true);
        }
    }
    
    
    
    
    /* Updates game object when we leave the game (provided game is not nil, ie game not finished yet)
     * ie transferring cards in cards_in_play back to players' hands */
    func updateGameCards() {
        if (self.game != nil) {
            for player in self.game.players {
                var card: PlayingCard!;
                while (!player.cards_in_play.isEmpty) {
                    card = player.cards_in_play[0];
                    player.removeFromCardsInPlay(card);
                }
            }
        }
    }
    
    
    
    
    /* Goes back to main menu */
    override func backButtonAction() {
        self.updateGameCards();
        self.dismiss_delegate?.SingleGameViewControllerDismiss(self, game: self.game);
    }
    
    
    

    override func showScoreAlert() {
        var alert = UIAlertView();
        var title: String!;
        var message: String!;
        
        if (self.your_score > self.opponent_score) {
            title = (self.language == Language.ENGLISH) ? "You win!" : "Вы победили!";
        } else if (self.your_score < self.opponent_score) {
            title = (self.language == Language.ENGLISH) ? "You lose!" : "Вы проиграли!";
        } else {
            title = (self.language == Language.ENGLISH) ? "Draw!" : "Ничья!";
        }
        
        message = "Your score: \(self.your_score)\nComputer's score: \(self.opponent_score)";
        if (self.language == Language.RUSSIAN) {
            message = "Ваш счет: \(self.your_score)\nСчет соперника: \(self.opponent_score)";
        }
        
        alert.title = title;
        alert.message = message;
        alert.delegate = self;
        alert.addButtonWithTitle("OK");
        
        alert.show();
    }
    
    
    
    
    override func showPlayAgainAlert() {
        var alert = UIAlertView();
        var title: String!;
        var message: String!;
        
        title = (self.language == Language.ENGLISH) ? "Play again?" : "Сыграть еще?";
        message = (self.language == Language.ENGLISH) ? "Do you want to play again?" : "Хотите сыграть еще?";
        
        alert.title = title;
        alert.message = message;
        alert.delegate = self;
        
        let yes = (self.language == Language.ENGLISH) ? "Yes" : "Да";
        alert.addButtonWithTitle(yes);
        let no = (self.language == Language.ENGLISH) ? "No" : "Нет";
        alert.addButtonWithTitle(no);
        
        alert.show();
    }
    
    
    
    
    

// MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var title = alertView.title;
        let button_title = alertView.buttonTitleAtIndex(buttonIndex);
        
        if (self.isWinTitle(title)) {
            self.showPlayAgainAlert();
        }
        
        if (title == "Play again?" || title == "Сыграть еще?") {
            if (button_title == "Yes" || button_title == "Да") {
                self.startNewGame(2);
            } else {
                self.backButtonAction();
            }
        }
    }
}