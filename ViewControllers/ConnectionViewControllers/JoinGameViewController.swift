//
//  JoinGameViewController.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JoinGameViewController: ConnectionViewController, UITableViewDelegate {
    
    lazy var waiting_for_game_start_label: UILabel = {
        var res: UILabel = UILabel(frame: CGRectMake(0, 0, 0.6 * WIDTH, 50));
        res.center = CGPointMake(0.5 * WIDTH, 0.5 * HEIGHT);
        let image_name = (self.language == Language.ENGLISH) ? "waiting_for_game.png" : "waiting_for_game_start_russian.png";
        let background_image = resizeImage(UIImage(named: image_name)!, CGSizeMake(res.frame.width, res.frame.height));
        res.backgroundColor = UIColor(patternImage: background_image);
        res.hidden = true;
        return res;
    }()
    
    
    /* Stores the identity of the advertising peer (server) */
    var host_peer_id: MCPeerID!;
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.available_players_table.delegate = self;
        self.available_players_table.dataSource = self;
        
        self.view.addSubview(self.waiting_for_game_start_label);
        
        let image_name = (self.language == Language.ENGLISH) ? "available_games.png" : "available_games_russian.png";
        let background_image = resizeImage(UIImage(named: image_name)!, CGSizeMake(self.title_label.frame.width, self.title_label.frame.height));
        self.title_label.backgroundColor = UIColor(patternImage: background_image);
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.appDelegate.mpcHandler.setupSessionWithPeerID(self.appDelegate.mpcHandler.peerID);
        self.appDelegate.mpcHandler.startBrowsing();
    }
    
    
    
    
    /* Prepares the UI for the start of the game:
     * table fades out and waiting_for_game_start_label is displayed. */
    override func prepareForGameStart() {
        self.title_label.hidden = true;
        self.table_border_label.hidden = true;
        self.available_players_table.hidden = true;
        self.waiting_for_game_start_label.hidden = false;
    }
    
    
    
    
    
    
// MARK: UITableViewDelegate
    /* Send invitation to the advertiser through clicking on the table cell. */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.connection_state == ConnectionState.NOT_CONNECTED) {
            // change label text color of the selected cell
            let cell = tableView.cellForRowAtIndexPath(indexPath);
            cell?.textLabel?.textColor = UIColor.grayColor();
            
            let peer_id: MCPeerID = self.players[indexPath.row];
            self.host_peer_id = peer_id;
            self.appDelegate.mpcHandler.browser?.invitePeer(peer_id, toSession: self.appDelegate.mpcHandler.session, withContext: nil, timeout: 0);
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        cell?.textLabel?.textColor = UIColor.whiteColor();
    }
    
    
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.connection_state == ConnectionState.NOT_CONNECTED;
    }
}