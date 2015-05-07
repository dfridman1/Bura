//
//  ConnectionViewController.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit
import MultipeerConnectivity




class ConnectionViewController: UIViewController, UITableViewDataSource, UIAlertViewDelegate {
    
    lazy var title_label: UILabel = {
        var res = UILabel(frame: CGRectMake(0, 0, 0.5 * WIDTH, 50));
        let y: CGFloat = self.available_players_table.frame.origin.y - 30;
        res.center = CGPointMake(0.5 * WIDTH, y);
        return res;
    }()
    
    
    lazy var back_button: UIButton = {
        var res = UIButton(frame: CGRectMake(0.01 * WIDTH, 0.01 * HEIGHT, 0.12 * WIDTH, 0.1 * HEIGHT));
        res.setBackgroundImage(UIImage(named: "back_button.png"), forState: UIControlState.Normal);
        res.addTarget(self, action: "goBackAction", forControlEvents: UIControlEvents.TouchUpInside);
        return res;
    }()
    
    
    lazy var available_players_table: UITableView = {
        var res: UITableView = UITableView(frame: CGRectMake(9, 0, 0.8 * WIDTH, 0.5 * HEIGHT));
        res.center = CGPointMake(0.5 * WIDTH, 0.5 * HEIGHT);
        res.backgroundColor = UIColor.clearColor();
        res.separatorInset = UIEdgeInsetsMake(0, 3, 0, 11);
        return res;
    }()
    
    
    lazy var table_border_label: UILabel = {
        var res = UILabel(frame: CGRectMake(0, 0, 0.85 * WIDTH, 0.55 * HEIGHT));
        res.center = self.available_players_table.center;
        let background_image = resizeImage(UIImage(named: "table_border.png")!, CGSizeMake(res.frame.width, res.frame.height));
        res.backgroundColor = UIColor(patternImage: background_image);
        return res;
    }()
    
    
    var players: [MCPeerID] = [MCPeerID]();
    
    
    var delegate: ConnectionViewControllerDelegate?;
    
    
    var appDelegate: AppDelegate!;
    
    
    var connection_state: ConnectionState = ConnectionState.NOT_CONNECTED;
    
    
    var game_state: GameState = GameState.GAME_NOT_STARTED;
    
    
    var language: Language!;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: BACKGROUND_IMG);
        
        self.view.addSubview(self.title_label);
        self.view.addSubview(self.back_button);
        self.view.addSubview(self.available_players_table);
        self.view.addSubview(self.table_border_label);
        
        self.available_players_table.dataSource = self;
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        self.appDelegate.mpcHandler.setupPeerIDwithDisplayName(UIDevice.currentDevice().name);
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.listenToNotifications();
    }

    
    
    
    func goBackAction() {
        if (self.game_state == GameState.GAME_STARTED) {
            self.showQuitConfirmationAlert();
        } else {
            self.delegate?.ConnectionViewControllerDismissWithInfo(self, reason: QuitReason.VOLANTARY);
        }
    }
    
    
    
    
    /* Prompts the player to confirm the intention to quit the game. */
    func showQuitConfirmationAlert() {
        var alert: UIAlertView = UIAlertView();
        alert.title = "Quit Game?";
        alert.message = "Are you sure you want to quit the game?";
        alert.addButtonWithTitle("Yes");
        alert.addButtonWithTitle("No");
        alert.delegate = self;
        alert.show();
    }
    
    
    
    
    /* Abstract method. Makes UI preparation for the game start and sends appropriate
     * messages to the connected peers. */
    func prepareForGameStart() {}
    
    
    
    
    
    
// MARK: UITableViewDataSourceDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count;
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Cell") as! UITableViewCell!;
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        }
        cell.backgroundColor = UIColor.clearColor();
        cell.textLabel!.textColor = UIColor.whiteColor();
        // populate cell with peer's display name.
        cell.textLabel!.text = self.players[indexPath.row].displayName;
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell;
    }
    
    

    
    
    
// MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let title = alertView.title;
        if (title == "Quit Game?") {
            let button_title = alertView.buttonTitleAtIndex(buttonIndex);
            if (button_title == "Yes") {
                self.delegate?.ConnectionViewControllerDismissWithInfo(self, reason: QuitReason.VOLANTARY);
            }
        }
    }
}