//
//  ViewController.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit





class ViewController: UIViewController, ConnectionViewControllerDelegate, SingleGameViewControllerDelegate, MultiplayerGameViewControllerDelegate, RulesViewControllerDelegate {
    
    var game: Game!   // start game with this object
    
    
    var language: Language = Language.ENGLISH;

    
    lazy var new_game_button: UIButton = {
        var res = self.createMenuButton(0.55 * HEIGHT, img_name: "new_game_custom.png", target_name: "newGameAction");
        return res;
    }()
    
    
    lazy var resume_game_button: UIButton = {
        var res = self.createMenuButton(0.64 * HEIGHT, img_name: "resume_game_custom.png", target_name: "resumeGameAction");
        return res;
    }()
    
    
    lazy var host_game_button: UIButton = {
        var res = self.createMenuButton(0.64 * HEIGHT, img_name: "host_game_custom.png", target_name: "hostGameAction");
        return res;
    }()
    
    
    lazy var join_game_button: UIButton = {
        var res = self.createMenuButton(0.73 * HEIGHT, img_name: "join_game_custom.png", target_name: "joinGameAction");
        return res;
    }()
    
    
    lazy var rules_button: UIButton = {
        var res = self.createMenuButton(0.82 * HEIGHT, img_name: "rules_custom.png", target_name: "rulesAction");
        return res;
    }()
    
    
    lazy var ace_labels: [UILabel] = {
        var res: [UILabel] = [UILabel]();
        let ace_image_names = ["ace_spades_cropped.png", "ace_diamonds_cropped.png", "ace_clubs_cropped.png", "ace_hearts_cropped.png"];
        for name in ace_image_names {
            let ace = self.createAceLabel(name);
            res.append(ace);
        }
        return res;
    }()
    
    
    lazy var separator_lines: [UILabel] = {
        var res = [UILabel]();
        let ys: [CGFloat] = [0.595, 0.685, 0.775, 0.865];
        
        for i in 0..<4 {
            var line = self.createSeparatorLine(ys[i] * HEIGHT);
            line.alpha = 0;
            res.append(line);
        }
        return res;
    }()
    
    
    lazy var russian_button: UIButton = {
        var res: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: HEIGHT * 0.1245, height: HEIGHT * 0.075));
        res.center = CGPoint(x: WIDTH - res.frame.size.width, y: res.frame.size.height);
        res.setBackgroundImage(UIImage(named: "russian_button.png")!, forState: UIControlState.Normal);
        res.addTarget(self, action: Selector("russianButtonAction"), forControlEvents: UIControlEvents.TouchUpInside);
        return res
        }()
    
    
    lazy var english_button: UIButton = {
        var res: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: HEIGHT * 0.1245, height: HEIGHT * 0.075))
        res.center = CGPoint(x: WIDTH - 2.25 * res.frame.size.width, y: res.frame.size.height)
        res.setBackgroundImage(UIImage(named: "english_button.png"), forState: UIControlState.Normal);
        res.addTarget(self, action: Selector("englishButtonAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return res
        }()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.host_game_button);
        self.view.addSubview(self.join_game_button);
        self.view.addSubview(self.new_game_button);
        self.view.addSubview(self.rules_button);
        self.view.addSubview(self.russian_button);
        self.view.addSubview(self.english_button);
        
        self.view.backgroundColor = UIColor(patternImage: BACKGROUND_IMG);
        
        for line in self.separator_lines { self.view.addSubview(line); }
        
        for ace in self.ace_labels { self.view.addSubview(ace); }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        if (self.game != nil) {
            self.view.addSubview(self.resume_game_button);
        }
        
        self.prepareForAnimation();
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.performIntroAnimation();
    }
    
    
    
    
    /* Prepares view for animation */
    func prepareForAnimation() {
        self.locateMenuButtons();
        self.prepareAcesForAnimation();
    }
    
    
    
    
    /* Locates menu buttons */
    func locateMenuButtons() {
        let ys: [CGFloat] = [0.55, 0.64, 0.73, 0.82, 0.91];
        var menu_buttons: [UIButton] = [self.new_game_button, self.host_game_button, self.join_game_button, self.rules_button];
        
        if (self.game != nil) {
            menu_buttons.insert(self.resume_game_button, atIndex: 1);
        }
        
        for i in 0..<menu_buttons.count {
            let button = menu_buttons[i];
            button.alpha = 0;
            button.disable();
            let y = ys[i] * HEIGHT;
            button.center.y = y;
        }
    }
    
    
    
    
    func prepareAcesForAnimation() {
        let x = 0.5 * WIDTH;
        let y = 2.0 * HEIGHT;
        
        for ace in self.ace_labels {
            ace.moveTo(x: x, y: y);
        }
    }
    
    
    
    
    func performIntroAnimation() {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { Void -> Void in
            let y: CGFloat = 0.25 * HEIGHT;
            let xs: [CGFloat] = [0.29, 0.43, 0.57, 0.71];
            let rs: [CGFloat] = [0.1, -0.1, 0.1, -0.1];
            
            for i in 0..<self.ace_labels.count {
                let ace: UILabel = self.ace_labels[i];
                ace.moveTo(x: xs[i] * WIDTH, y: y);
                ace.rotate(angle: rs[i]);
            }
            }, completion: { finished in self.showMenuButtonsAndLines(); })
    }
    
    
    
    
    func performExitAnimation(completion_block: Void -> Void) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { Void -> Void in
            self.hideMenuButtonsAndLines();
            for ace in self.ace_labels {
                ace.center.x = 0.5 * WIDTH;
                ace.rotate(angle: 0);
            }
            }, completion: { finished in
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { Void -> Void in
                    for ace in self.ace_labels {
                        ace.center.y = -HEIGHT;
                    }
                    
                    }, completion: { Bool -> Void in completion_block() })
        })
    }
    
    
    
    
    func showMenuButtonsAndLines() {
        self.showHideMenuButtonsAndLines(hide: false);
    }
    
    
    
    
    func hideMenuButtonsAndLines() {
        self.showHideMenuButtonsAndLines(hide: true);
    }
    
    
    
    
    /* Brightens menu buttons if hide is false; otherwise, fades out */
    func showHideMenuButtonsAndLines(#hide: Bool) {
        var buttons = [self.new_game_button, self.host_game_button, self.join_game_button, self.rules_button];
        
        if (self.game != nil) { buttons.insert(self.resume_game_button, atIndex: 1); }
        
        let d: [Bool : CGFloat] = [true : 0, false : 1];
        
        for i in 0..<buttons.count {
            let button = buttons[i];
            button.enabled = !hide;
            UIView.animateWithDuration(0.5, animations: { Void -> Void in
                button.alpha = d[hide]!;
                if (i < buttons.count - 1) {
                    let line = self.separator_lines[i];
                    line.alpha = d[hide]!;
                }
            })
        }
    }
    
    
    
    
    func createSeparatorLine(center_y: CGFloat) -> UILabel {
        //creates a line vertically centered at centerY to separate options in the main menu
        var res: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH / 8.0, height: 1))
        res.moveTo(x: WIDTH / 2.0, y: center_y);
        
        res.backgroundColor = UIColor(patternImage: resizeImage(UIImage(named: "separator.png")!, CGSize(width: res.frame.size.width, height: res.frame.size.height)))
        
        return res
    }
    
    
    
    
    func createAceLabel(image_name: String) -> UILabel {
        let width = 0.12 * WIDTH;
        let height = 0.32 * HEIGHT;
        let image_size = CGSizeMake(width, height)
        let background_image = UIColor(patternImage: resizeImage(UIImage(named: image_name)!, image_size));
        
        var res = UILabel(frame: CGRectMake(0, 0, width, height));
        
        res.layer.masksToBounds = true;
        res.layer.cornerRadius = 3.0;
        
        res.backgroundColor = background_image;
        
        return res;
    }
    
    
    
    
    /* Presents RulesViewControler */
    func rulesAction() {
        self.performExitAnimation(self.rulesActionAux);
    }
    
    
    
    
    func rulesActionAux() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("RulesViewController") as! RulesViewController;
        controller.delegate = self;
        controller.language = self.language;
        self.presentViewController(controller, animated: false, completion: nil);
    }
    
    
    
    
    /* Presents a HostGameViewController */
    func hostGameAction() {
        self.performExitAnimation(self.hostGameActionAux);
    }
    
    func hostGameActionAux() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("HostVC") as! HostGameViewController;
        controller.delegate = self;
        controller.language = self.language;
        self.presentViewController(controller, animated: false, completion: nil);
    }
    
    
    
    
    /* Presents a JoinGameViewController */
    func joinGameAction() {
        self.performExitAnimation(self.joinGameActionAux);
    }
    
    func joinGameActionAux() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("JoinVC") as! JoinGameViewController;
        controller.delegate = self;
        controller.language = self.language;
        self.presentViewController(controller, animated: false, completion: nil);
    }
    
    
    
    
    /* Sets a game object to a new game and invokes a method which starts a game. */
    func newGameAction() {
        self.performExitAnimation(self.newGameActionAux);
    }
    
    func newGameActionAux() {
        self.game = Game();  // 2-player game
        self.startSingleGame(false);
    }
    
    
    
    
    /* Resumes single player game. */
    func resumeGameAction() {
        self.performExitAnimation(self.resumeGameActionAux);
    }
    
    func resumeGameActionAux() {
        self.startSingleGame(true);
    }
    

    
    
    /* Starts a single player game. */
    func startSingleGame(resume: Bool) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SingleGameViewController") as! SingleGameViewController;
        controller.game = self.game;
        if (resume) { controller.game_resumed = true; }
        controller.dismiss_delegate = self;
        controller.language = self.language;
        self.presentViewController(controller, animated: false, completion: nil);
    }
    
    
    
    
    func russianButtonAction() {
        self.language = Language.RUSSIAN;
        
        self.new_game_button.setBackgroundImage(UIImage(named: "new_game_russian_custom.png"), forState: UIControlState.Normal);
        self.resume_game_button.setBackgroundImage(UIImage(named: "resume_game_russian_custom.png"), forState: UIControlState.Normal);
        self.join_game_button.setBackgroundImage(UIImage(named: "join_game_russian_custom.png"), forState: UIControlState.Normal);
        self.host_game_button.setBackgroundImage(UIImage(named: "host_game_russian_custom.png"), forState: UIControlState.Normal);
        self.rules_button.setBackgroundImage(UIImage(named: "rules_russian_custom.png"), forState: UIControlState.Normal);
    }
    
    
    
    
    func englishButtonAction() {
        self.language = Language.ENGLISH;
        
        self.new_game_button.setBackgroundImage(UIImage(named: "new_game_custom.png"), forState: UIControlState.Normal);
        self.resume_game_button.setBackgroundImage(UIImage(named: "resume_game_custom.png"), forState: UIControlState.Normal);
        self.join_game_button.setBackgroundImage(UIImage(named: "join_game_custom.png"), forState: UIControlState.Normal);
        self.host_game_button.setBackgroundImage(UIImage(named: "host_game_custom.png"), forState: UIControlState.Normal);
        self.rules_button.setBackgroundImage(UIImage(named: "rules_custom.png"), forState: UIControlState.Normal);
    }
    
    
    
    
    /* Creates a menu button */
    func createMenuButton(center_y: CGFloat, img_name: String, target_name: String) -> UIButton {
        var res = UIButton(frame: CGRectMake(0, 0, 0.56 * WIDTH, 0.07 * HEIGHT));
        res.center = CGPointMake(0.5 * WIDTH, center_y);
        res.setBackgroundImage(UIImage(named: img_name)!, forState: UIControlState.Normal);
        res.addTarget(self, action: Selector(target_name), forControlEvents: UIControlEvents.TouchUpInside);
        return res;
    }
    

    
    /* Shows disconnected alert. */
    func showDisconnectedAlert() {
        let title = (self.language == Language.ENGLISH) ? "Disconnected" : "Сообщение";
        let message = (self.language == Language.ENGLISH) ? "You have been disconnected!" : "Соединение с соперником разорвано!"
        var alert: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK");
        alert.show();
    }
    
    
    
    
    
    
// MARK: ConnectionViewControllerDelegate
    /* Dismisses Connection(Host | Join)ViewController */
    func ConnectionViewControllerDismissWithInfo(controller: ConnectionViewController, reason: QuitReason) {
        controller.breakConnection();
        if (reason == QuitReason.CONNECTION_LOST) {
            controller.dismissViewControllerAnimated(false, completion: showDisconnectedAlert);
        } else if (reason == QuitReason.VOLANTARY) {
            controller.dismissViewControllerAnimated(false, completion: nil);
        }
    }
    
    
    
    
    func dismissAndStartGameWithAppDelegate(controller: ConnectionViewController, game: Game, appDelegate: AppDelegate, isServer: Bool) {
        controller.dismissViewControllerAnimated(false, completion: nil);
        
        let game_controller = self.storyboard!.instantiateViewControllerWithIdentifier("MultiplayerGameViewController") as! MultiplayerGameViewController;
        game_controller.appDelegate = appDelegate;
        game_controller.delegate = self;
        game_controller.game = game;
        game_controller.is_server = isServer;
        game_controller.language = self.language;
        self.presentViewController(game_controller, animated: false, completion: nil);
    }
    
    
    
    
    
    
// MARK: GameViewControllerDelegate
    func SingleGameViewControllerDismiss(controller: GameViewController, game: Game?) {
        self.game = game;
        controller.dismissViewControllerAnimated(false, completion: nil);
    }
    
    
    
    
    
    
// MARK: MultipeerGameViewControllerDelegate
    func dismissMultiplayerGameViewController(controller: MultiplayerGameViewController, reason: QuitReason) {
        controller.breakConnection();
        var completion: (Void -> Void)? = (reason == QuitReason.CONNECTION_LOST) ? showDisconnectedAlert : nil;
        controller.dismissViewControllerAnimated(false, completion: completion);
    }

    
    
    
    
    
// MARK: RulesViewControllerDelegate
    func rulesViewControllerDidDismiss(controller: RulesViewController) {
        controller.dismissViewControllerAnimated(false, completion: nil);
    }
}