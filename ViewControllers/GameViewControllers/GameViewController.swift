//
//  GameViewController.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/6/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    lazy var turn_label: UILabel = {
        var res = self.createCenterLabel();
        let image_name = (self.language == Language.ENGLISH) ? "turn_label.png" : "turn_label_russian.png";
        let resized_image = resizeImage(UIImage(named: image_name)!, CGSizeMake(res.frame.width, res.frame.height));
        res.backgroundColor = UIColor(patternImage: resized_image);
        return res;
    }()
    
    
    lazy var invalid_move_label: UILabel = {
        return self.createCenterLabel();
    }()
    
    
    lazy var submit_button: UIButton = {
        var res: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: HEIGHT * 0.213, height: HEIGHT * 0.213));
        res.center = CGPoint(x: 0.8 * WIDTH, y: 0.85 * HEIGHT);
        
        let image_name = (self.language == Language.ENGLISH) ? "play_circle.png" : "play_circle_russian.png";
        res.backgroundColor = UIColor(patternImage: resizeImage(UIImage(named: image_name)!, CGSize(width: res.frame.size.width, height: res.frame.size.height)));
        res.layer.cornerRadius = res.frame.width / 2.0
        
        
        res.hidden = true;
        res.addTarget(self, action: "submitButtonAction", forControlEvents: UIControlEvents.TouchUpInside);
        
        return res;
        }()
    
    
    lazy var player_name_label: UILabel = {
        var res: UILabel = self.createNameLabel(UIDevice.currentDevice().name, y: 0.95 * HEIGHT);
        return res;
    }()
    
    
    lazy var opponent_name_label: UILabel = {
        var res: UILabel = self.createNameLabel("Computer", y: 0.05 * HEIGHT);
        return res;
    }()
    
    
    var your_score: Int!;
    
    
    var opponent_score: Int!;
    
    
    var game: Game!;
    
    
    var card_buttons: [UIButton]!;
    
    
    var cards_in_play: [UIButton] = [UIButton]();   /* holds the player's cards, which are currently in play */
    
    
    var back_button: UIButton!;
    

    var language: Language!;
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Add card buttons.
        self.card_buttons = self.createCardButtons();
        for button in self.card_buttons { self.view.addSubview(button); }
        
        
        // Set background image.
        self.view.backgroundColor = UIColor(patternImage: BACKGROUND_IMG);
        
        
        // Add back button (go back to main menu)
        self.back_button = UIButton(frame: CGRect(x: WIDTH * 0.01, y: HEIGHT * 0.01, width: WIDTH * 0.12, height: HEIGHT * 0.1));
        self.back_button.setBackgroundImage(UIImage(named: "back_button.png"), forState: UIControlState.Normal);
        self.back_button.addTarget(self, action: "backButtonAction", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(self.back_button);
        
        
        self.view.addSubview(self.turn_label);
        self.view.addSubview(self.invalid_move_label);
        self.view.addSubview(self.submit_button)
        
        
        self.view.addSubview(self.player_name_label);
        self.view.addSubview(self.opponent_name_label);
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.listenToNotifications();
        
        self.prepareForGameStart();
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.performGameIntro(animate: true);
        
        // deal the cards and start the game
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(CARDS_ANIMATION_DURATION * 2, target: self, selector: "deal", userInfo: nil, repeats: false);
    }
    
    
    
    
    func prepareForGameStart() {
        // Move card buttons off screen
        for button in self.card_buttons {
            button.moveTo(0.5 * WIDTH, y: 2 * HEIGHT);
        }
    }
    
    
    
    
    func performGameIntro(#animate: Bool) {
        let block: Void -> Void = { var trump_card_button = self.getButtonForCard(self.game.deck.trump_card);
                                    for button in self.card_buttons {
                                        var x: CGFloat = 0.9 * WIDTH;
                                        if (button == trump_card_button) {
                                            x -= 0.5 * CARDBUTTON_WIDTH;
                                            button.setFace(self.game.deck.trump_card);
                                            button.rotate(90);
                                        }
                                        button.moveTo(x, y: 0.5 * HEIGHT);
                                    } }
        if (animate) {
            UIView.animateWithDuration(CARDS_ANIMATION_DURATION, animations: block);
        } else {
            block();
        }
    }
    
    
    
    
    /* Abstract method for listening to notifications. */
    func listenToNotifications() {}
    
    
    
    
    func createCardButtons() -> [UIButton] {
        var res: [UIButton] = [UIButton]();
        let num_of_cards = self.game.deck.deckSize;
        for i in 0..<num_of_cards {
            let card_button = UIButton.makeCardButton();
            card_button.disable();
            card_button.rotateByRandomDegree(3);
            card_button.addTarget(self, action: "cardButtonAction:", forControlEvents: UIControlEvents.TouchUpInside);
            res.append(card_button);
        }
        return res;
    }
    
    
    
    
    /* Creates a UILabel centered in the center of the screen. */
    func createCenterLabel() -> UILabel {
        var res: UILabel = UILabel(frame: CGRectMake(0, 0, 0.8 * WIDTH, 0.1 * HEIGHT));
        res.center = CGPointMake(0.5 * WIDTH, 0.5 * HEIGHT);
        res.textColor = UIColor.whiteColor();
        res.textAlignment = NSTextAlignment.Center;
        res.hidden = true;
        return res;
    }
    
    
    
    
    /* Returns a button corresponding to a card. */
    func getButtonForCard(card: PlayingCard) -> UIButton {
        let index = self.game.deck.indexOfCard(card);
        return self.card_buttons[index];
    }
    
    
    
    
    /* Returns a card corresponding to a button. */
    func getCardForButton(button: UIButton) -> PlayingCard {
        let index: Int! = find(self.card_buttons, button);
        return self.game.deck.cardAtIndex(index) as! PlayingCard!;
    }
    
    
    
    
    /* Sets a face image for the button. */
    func setFaceImage(card_button: UIButton) {
        let card: PlayingCard = self.getCardForButton(card_button);
        card_button.setFace(card);
    }
    
    
    
    
    func cardButtonAction(button: UIButton) {
        self.turn_label.hidden = true;
        
        let card = self.getCardForButton(button);
        let index: Int? = find(self.game.players[0].cards_in_play, card);
        
        let moveUp: Bool = (index != nil) ? false : true;
        
        moveUp ? self.game.players[0].addToCardsInPlay(card) : self.game.players[0].removeFromCardsInPlay(card);
        
        self.makeCardMove(button, moveUp: moveUp, isOpponent: false);
        
        self.submit_button.hidden = (self.game.game_turn == 0) ? (self.game.players[0].cards_in_play.count == 0) : (self.game.players[0].cards_in_play.count != self.game.players[1].cards_in_play.count);
        self.invalid_move_label.hidden = true;
    }
    
    
    
    
    func submitButtonAction() {
        if (self.game.game_turn == 0 && !Game.isValidMove(self.game.players[0].cards_in_play)) {
            self.invalidMoveMade();
        }
        else {
            self.successfulMoveMade();
        }
    }
    
    
    
    
    /* Handles the case when a player has made an invalid move */
    func invalidMoveMade() {
        let cards = self.game.players[0].cards_in_play;
        for card in cards {
            self.game.players[0].removeFromCardsInPlay(card);
            let card_button = self.getButtonForCard(card);
            self.makeCardMove(card_button, moveUp: false, isOpponent: false);
        }
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(CARDS_ANIMATION_DURATION, target: self, selector: "displayInvalidMessage", userInfo: nil, repeats: false);
    }
    
    
    
    
    func displayInvalidMessage() {
        self.invalid_move_label.hidden = false;
    }
    
    
    
    
    /* Handles the case when a player's move has been valid */
    func successfulMoveMade() {
        self.blockHand(true);
        self.submit_button.hidden = true;
        
        if (self.game.game_turn == 0) {
            var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(CARDS_ANIMATION_DURATION, target: self, selector: "opponentRespond", userInfo: nil, repeats: false);
        } else {
            var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(4 * CARDS_ANIMATION_DURATION, target: self, selector: "handDidFinish", userInfo: nil, repeats: false);
        }
    }
   
    
    
    
    /* Handles the case when the hand has finished */
    func handDidFinish() {
        var (winner_index, cards_won) = self.game.handWinner();
        
        for card in cards_won {
            self.updatePile(isOpponent: winner_index == 1, cards: cards_won);
        }
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(3 * CARDS_ANIMATION_DURATION, target: self, selector: "deal", userInfo: nil, repeats: false);
    }
    
    
    
    
    /* Starts a new hand */
    func startNewHand() {
        if (self.game.game_over) {
            self.your_score = self.game.players[0].getScore();
            self.opponent_score = self.game.players[1].getScore();
            self.gameOverAnimation();
        } else if (self.game.game_turn == 0) {
            self.turn_label.hidden = false;
            self.blockHand(false);
            
            if (self.game.players[0].hasBura() || self.game.players[0].hasGoldenBura()) {
                self.makeAutomaticMove();
            }
        } else {
            self.opponentInitiate();
        }
    }
    
    
    
    
    func opponentInitiate() {
        fatalError("Must be overridden");
    }
    
    
    
    
    func opponentRespond() {
        fatalError("Must be overridden");
    }
    
    
    
    
    /* Makes automatic move in the case when player has either bura or golden bura */
    func makeAutomaticMove() {
        let hand = self.game.players[0].hand as! [PlayingCard];
        
        for card in hand {
            let card_button = self.getButtonForCard(card);
            self.cardButtonAction(card_button);
        }
        
        // After the move is finished, automatically confirm it
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(1.1 * CARDS_ANIMATION_DURATION, target: self, selector: "submitButtonAction", userInfo: nil, repeats: false);
    }
    
    
    
    
    /* if block is true, then block; otherwise unblock */
    func blockHand(block: Bool) {
        let hand = self.game.players[0].hand as! [PlayingCard];
        for card in hand {
            let cardButton = self.getButtonForCard(card);
            cardButton.enabled = !block;
        }
    }
    
    
    
    
    /* unblocks hand */
    func unblockHand() {
        self.blockHand(false);
    }
    
    
    
    
    /* Deals out the cards */
    func deal() {
        self.game.deal();
        self.updateHands();
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(2 * CARDS_ANIMATION_DURATION, target: self, selector: "startNewHand", userInfo: nil, repeats: false);
    }
    
    
    
    
    /* Update hand. Animate if animate is true. */
    func updateHand(#isOpponent: Bool, animate: Bool = true) {
        var yLoc: CGFloat = 0.775 * HEIGHT;
        if (isOpponent) { yLoc = HEIGHT - yLoc; }
        let xLocMult: [CGFloat] = [-1.1, 0.0, 1.1];
        
        let hand: [PlayingCard] = (isOpponent ? self.game.players[1].hand : self.game.players[0].hand) as! [PlayingCard];
        
        var i: Int = 0;
        
        for card in hand {
            let cardButton: UIButton = self.getButtonForCard(card);
            
            // if card is a deck's trump card, we want to rotate, and set shirt as background if it is opponent's card
            if (card == self.game.deck.trump_card) {
                if (animate) {
                    cardButton.rotateAndAnimate(3, animation_duration: CARDS_ANIMATION_DURATION);
                    if (isOpponent) { cardButton.setShirt(); }
                } else {
                    cardButton.rotateByRandomDegree(3);
                    if (isOpponent) { cardButton.setShirt(); }
                }
            }
            
            let xLoc: CGFloat = 0.5 * WIDTH + xLocMult[i++] * CARDBUTTON_WIDTH;
            
            if (animate) {
                cardButton.moveToAnimate(xLoc, y: yLoc, animation_duration: CARDS_ANIMATION_DURATION, completion: { (Bool) -> Void in
                    if (!isOpponent) { cardButton.setFace(card); }
                });
            } else {
                cardButton.moveTo(xLoc, y: yLoc);
                if (!isOpponent) { cardButton.setFace(card); }
            }
        }
    }
    
    
    
    
    /* Update hands */
    func updateHands() {
        self.updateHand(isOpponent: true);
        self.updateHand(isOpponent: false);
    }
    
    
    
    
    /* Update pile */
    func updatePile(#isOpponent: Bool, cards: [PlayingCard]) {
        let mid_height: CGFloat = 0.5 * HEIGHT;
        let yLoc: CGFloat = isOpponent ? (mid_height - 0.7 * CARDBUTTON_HEIGHT) : (mid_height + 0.7 * CARDBUTTON_HEIGHT);
        let xLoc: CGFloat = 0.1 * WIDTH;
        for card in cards {
            let cardButton: UIButton = self.getButtonForCard(card);
            
            // Removing from superview and then adding to it makes sure cards in piles properly stack
            cardButton.removeFromSuperview();
            self.view.addSubview(cardButton);
            
            // Rotate button by random degree
            cardButton.rotateAndAnimate(30, animation_duration: CARDS_ANIMATION_DURATION);
            
            cardButton.moveToAnimate(xLoc, y: yLoc, animation_duration: CARDS_ANIMATION_DURATION, completion: { Bool -> Void in cardButton.setShirt(); })
        }
    }
    
    
    
    
    /* Update pile */
    func updatePiles(cards: [PlayingCard]) {
        // moves cards to the pile of the player who has won the hand (indicated by self.game.game_turn
        // since after the last hand it is the turn of the player who won
        let isOpponent: Bool = (self.game.game_turn == 1);
        self.updatePile(isOpponent: isOpponent, cards: cards);
    }
    
    
    
    
    /* Move card to the battlefield if moveUp is true; otherwise, move it to the default position */
    func makeCardMove(card_button: UIButton, moveUp: Bool, isOpponent: Bool) {
        let x: CGFloat = card_button.center.x;
        var y: CGFloat = moveUp ? (0.5 * HEIGHT + 0.6 * CARDBUTTON_HEIGHT) : (0.775 * HEIGHT);
        if (isOpponent) { y = HEIGHT - y; }
        card_button.moveToAnimate(x, y: y, animation_duration: CARDS_ANIMATION_DURATION, completion: nil);
    }
    
    
    
    
    func backButtonAction() {
        fatalError("Must be overridden");
    }
    
    
    
    
    func gameOverAnimation() {
        if (self.game.game_over) {
            self.game = nil;
            for button in self.card_buttons {
                var completion: (Bool -> Void)? = { finished in button.removeFromSuperview(); }
                button.moveToAnimate(0.5 * WIDTH, y: 2 * HEIGHT, animation_duration: CARDS_ANIMATION_DURATION, completion: completion);
            }
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(CARDS_ANIMATION_DURATION, target: self, selector: "showScoreAlert", userInfo: nil, repeats: false);
        }
    }
    
    
    
    
    func createNameLabel(name: String, y: CGFloat) -> UILabel {
        var res: UILabel = UILabel(frame: CGRectMake(0, 0, 0.7 * WIDTH, 25));
        res.center = CGPointMake(0.5 * WIDTH, y);
        res.backgroundColor = UIColor.clearColor();
        res.text = name;
        res.textAlignment = NSTextAlignment.Center;
        res.textColor = UIColor.whiteColor();
        res.font = UIFont(name: res.font.fontName, size: 15);
        return res;
    }
    
    
    
    
    /* Creates a new game object */
    func startNewGame(numberOfPlayers: Int) {
        if (self.game == nil) {
            self.game = Game(numberOfPlayers: numberOfPlayers);
        }
        
        self.card_buttons = self.createCardButtons();
        for card_button in self.card_buttons { self.view.addSubview(card_button); }
        
        self.prepareForGameStart();
        self.performGameIntro(animate: true);
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(2 * CARDS_ANIMATION_DURATION, target: self, selector: "deal", userInfo: nil, repeats: false);
    }
    
    
    
    
    func showScoreAlert() {
        fatalError("Must be overridden");
    }
    
    
    
    
    func showPlayAgainAlert() {
        fatalError("Must be overridden");
    }
    
    
    
    
    func isWinTitle(title: String) -> Bool {
        return (title == "You win!" || title == "You lose!" || title == "Draw!" || title == "Вы победили!" || title == "Вы проиграли!" || title == "Ничья!");
    }
}