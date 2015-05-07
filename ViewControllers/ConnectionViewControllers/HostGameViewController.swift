//
//  HostGameViewController.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit
import MultipeerConnectivity





class HostGameViewController: ConnectionViewController, UITableViewDelegate {
    
    lazy var start_game: UIButton = {
        var res: UIButton = UIButton(frame: CGRectMake(0, 0, 0.4 * WIDTH, 40));
        res.center = CGPointMake(0.5 * WIDTH, 0.85 * HEIGHT);
        let image_name = (self.language == Language.ENGLISH) ? "start_game.png" : "start_game_russian.png";
        res.setBackgroundImage(UIImage(named: image_name), forState: UIControlState.Normal);
        res.addTarget(self, action: "startGame", forControlEvents: UIControlEvents.TouchUpInside);
        return res;
    }()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.start_game);
        
        let image_name = (self.language == Language.ENGLISH) ? "waiting_for_opponent_to_join.png" : "waiting_for_opponent_to_join_russian.png";
        let background_image = resizeImage(UIImage(named: image_name)!, CGSizeMake(self.title_label.frame.width, self.title_label.frame.height));
        self.title_label.backgroundColor = UIColor(patternImage: background_image);
        
        self.available_players_table.delegate = self;
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.appDelegate.mpcHandler.advertiseSelf(true);
    }
    
    
    
    
    /* Starts the game with players in self.players.
     * If there are no players, an alert is shown. */
    func startGame() {
        if (self.players.isEmpty) {
            self.showNoOpponentsAlert();
        } else {
            self.appDelegate.mpcHandler.advertiseSelf(false);
            self.game_state = GameState.GAME_STARTED;
            self.prepareForGameStart();
        }
    }
    
    
    
    
    /* Shows an alert if host is trying to start a game when there
     * are no players connected. */
    func showNoOpponentsAlert() {
        let title = (self.language == Language.ENGLISH) ? "No Opponents!" : "Внимание!";
        let message = (self.language == Language.ENGLISH) ? "You must have at least one opponent to play against!" : "К Вам не подключился ни один игрок!"
        let alert: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK");
        alert.show();
    }
    
    
    
    
    /* Sends a message to the connected peers about the start of the game. */
    override func prepareForGameStart() {
        // send info about the deck so that opponents can build a Game object from it
        var game: Game = Game();
        var raw_deck: [(Int, Int)] = PlayingDeck.rawDeck(game.deck);
        
        var dataToSend = [RANKS : Map({ card in card.0 }, raw_deck),
                          SUITS : Map({ card in card.1 }, raw_deck)];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
        self.sendData(dataToSend as NSDictionary, peers: connected_peers);
        self.delegate?.dismissAndStartGameWithAppDelegate(self, game: game, appDelegate: self.appDelegate, isServer: true);
    }
   
    
    
    
    
    
// MARK: UITableViewDelegate
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
}