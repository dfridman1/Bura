//
//  MultiplayerGameViewController.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/7/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit
import MultipeerConnectivity






class MultiplayerGameViewController: GameViewController, UIAlertViewDelegate {
    
    lazy var waiting_label: UILabel = {
        var res = self.createCenterLabel();
        let image_name = (self.language == Language.ENGLISH) ? "wait_for_opponent.png" : "wait_for_opponent_russian.png";
        let resized_image = resizeImage(UIImage(named: image_name)!, CGSizeMake(res.frame.width, res.frame.height));
        res.backgroundColor = UIColor(patternImage: resized_image);
        return res;
        }()
    
    
    var appDelegate: AppDelegate!  /* handles connection */
    
    
    var delegate: MultiplayerGameViewControllerDelegate!;
    
    
    var is_server: Bool!;  /* required for managing alerts */

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set opponent's name label
        let opponent: MCPeerID = self.appDelegate.mpcHandler.session.connectedPeers[0] as! MCPeerID;
        let opponent_name: String = opponent.displayName;
        self.opponent_name_label.text = opponent_name;
        
        
        self.view.addSubview(self.waiting_label);
    }
    

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.listenToNotifications();
    }
    
    
    
    
    override func opponentInitiate() {
        self.waiting_label.hidden = false;
    }
    
    
    
    
    override func opponentRespond() {
        // inform opponent that it is his move
        
        let cards_in_play: [(Int, Int)] = Map({ card in PlayingCard.toRaw(card) }, self.game.players[0].cards_in_play);
        let suits: [Int] = Map({ card in card.1 }, cards_in_play);
        let ranks: [Int] = Map({ card in card.0 }, cards_in_play);
        
        let data_to_send = [MESSAGE : RESPOND, SUITS : suits, RANKS : ranks];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
        
        self.sendData(data_to_send as NSDictionary, peers: connected_peers);
    }
    
    
    
    
    /* Handles the case when a player's move has been valid */
    override func successfulMoveMade() {
        self.blockHand(true);
        self.submit_button.hidden = true;
        
        if (self.game.game_turn == 0) {
            var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(CARDS_ANIMATION_DURATION, target: self, selector: "opponentRespond", userInfo: nil, repeats: false);
        } else {
            self.sendHandDidFinishMessage();
            var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(4 * CARDS_ANIMATION_DURATION, target: self, selector: "handDidFinish", userInfo: nil, repeats: false);
        }
    }

    
    
    
    override func backButtonAction() {
        self.showQuitConfirmationAlert();
    }
    
    
    
    
    /* Prompts the player to confirm the intention to quit the game. */
    func showQuitConfirmationAlert() {
        var alert: UIAlertView = UIAlertView();
        
        alert.title = (self.language == Language.ENGLISH) ? "Quit Game?" : "Покинуть игру?";
        
        alert.message = "Are you sure you want to quit the game?";
        if (self.language == Language.RUSSIAN) {
            alert.message = "Вы уверены, что хотите покинуть игру?";
        }
        
        let yes = (self.language == Language.ENGLISH) ? "Yes" : "Да";
        let no = (self.language == Language.ENGLISH) ? "No" : "Нет";
        
        alert.addButtonWithTitle(yes);
        alert.addButtonWithTitle(no);
        
        alert.delegate = self;
        alert.show();
    }
    
    
    
    
    override func showScoreAlert() {
        var alert = UIAlertView();
        var title: String!;
        var message: String!;
        
        let opponent = self.appDelegate.mpcHandler.session.connectedPeers[0] as! MCPeerID;
        let opponent_name = opponent.displayName;
        
        if (self.your_score > self.opponent_score) {
            title = (self.language == Language.ENGLISH) ? "You win!" : "Вы победили!";
        } else if (self.your_score < self.opponent_score) {
            title = (self.language == Language.ENGLISH) ? "You lose!" : "Вы проиграли!";
        } else {
            title = (self.language == Language.ENGLISH) ? "Draw!" : "Ничья!";
        }
        
        message = "Your score: \(self.your_score)\n\(opponent_name)'s score: \(self.opponent_score)";
        if (self.language == Language.RUSSIAN) {
            message = "Ваш счет: \(self.your_score)\nСчет \(opponent_name): \(self.opponent_score)";
        }
        
        alert.title = title;
        alert.message = message;
        alert.delegate = self;
        alert.addButtonWithTitle("OK");
        
        alert.show();
    }
    
    
    
    
    func serverPlayAgainAlert() {
        var alert = UIAlertView();
        
        var title: String!;
        var message: String!;
        
        let opponent = self.appDelegate.mpcHandler.session.connectedPeers[0] as! MCPeerID;
        let opponent_name = opponent.displayName;
        
        title = "Play again?";
        if (self.language == Language.RUSSIAN) { title = "Сыграть еще?"; }
        
        message = "Do you want to play against \(opponent_name) again?";
        if (self.language == Language.RUSSIAN) {
            message = "Хотите еще сыграть против \(opponent_name)?";
        }
        
        alert.title = title;
        alert.message = message;
        alert.delegate = self;
        let yes = (self.language == Language.ENGLISH) ? "Yes" : "Да";
        let no = (self.language == Language.ENGLISH) ? "No" : "Нет";
        alert.addButtonWithTitle(yes);
        alert.addButtonWithTitle(no);
        
        alert.show();
    }
    
    
    
    
    func showPlayAgainRequestAlert(server_name: String) {
        var alert = UIAlertView();
        
        var title: String!;
        var message: String!;
        
        title = (self.language == Language.ENGLISH) ? "Play again?" : "Сыграть еще?";
        
        message = "\(server_name) is offering to play another match. Do you want to?";
        if (self.language == Language.RUSSIAN) {
            message = "\(server_name) предлагает Вам сыграть еще. Вы согласны?";
        }
        
        alert.title = title;
        alert.message = message;
        alert.delegate = self;
        let yes = (self.language == Language.ENGLISH) ? "Yes" : "Да";
        let no = (self.language == Language.ENGLISH) ? "No" : "Нет";
        alert.addButtonWithTitle(yes);
        alert.addButtonWithTitle(no);
        
        alert.show();
    }
    
    
    
    
    
    
// MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let title = alertView.title;
        let button_title = alertView.buttonTitleAtIndex(buttonIndex);
        if (title == "Quit Game?" || title == "Покинуть игру?") {
            if (button_title == "Yes" || button_title == "Да") {
                self.delegate.dismissMultiplayerGameViewController(self, reason: QuitReason.VOLANTARY);
            }
            
        } else if (self.isWinTitle(title)) {
            if (self.is_server!) {
                self.serverPlayAgainAlert();
            }
            
        } else if (title == "Play again?" || title == "Сыграть еще?") {
            if (self.is_server!) {
                (button_title == "Yes" || button_title == "Да") ? self.sendPlayAgainRequest() : self.backButtonAction();
            } else {
                (button_title == "Yes" || button_title == "Да") ? self.sendConfirmPlayAgain() : self.backButtonAction();
            }
        }
    }
}