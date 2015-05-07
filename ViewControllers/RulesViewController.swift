//
//  RulesViewController.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit



let rules_text_english: String = "The game is played using 36-card deck. At the beginning 3 cards are dealt out to each of the players and the card, determining the trump suit, is displayed. A valid move for a player, initiating a move, consists of any combination of cards of the same suit (a combination of 3 aces, one of which is of trump suit, is also valid, and is called a golden bura). A player, responding to his opponent, has 2 options: either beat his cards (take a bribe) or give up the corresponding number of any cards in his hand. In the case when a player gives up cards, his opponent is said to have taken a bribe. After that cards are dealt out to players until each of them has 3 cards in hand. A player, who has taken the last bribe, initiates the next move. The game finishes when there are no cards left in deck and players' hands. The score of each player is calculated according to his cards' points in bribes, following the rule: Ace - 11 points, 10 - 10 points, King - 4 points, Queen - 3 points, Jack - 2 points, and 6, 7, 8, 9 have no value. In this game the order of ranks (ascending) is: 6, 7, 8, 9, Jack, Queen, King, 10, Ace."


let rules_text_russian: String = "В данной разновидности игры используется колода из 36 карт. Максимальное количество очков составляет 120. Игрок, набравший наибольшее количество очков, считается победителем. В начале игры соперникам сдается по 3 карты, после чего вскрывается карта, определяющая козырную масть. Игрок, обладающий правом хода, может \"походить\" комбинацией от 1-ой до 3-х карт, но так, чтобы карты были одной масти (либо ход должен состоять из 3-х тузов, включая козырный). У его соперника есть 2 варианта: либо \"побить\" карты противника, либо сбросить соответствующее количество карт (при этом сброс \"по масти\" необязателен). После того, как \"взятка\" была выиграна одним из игроков, соперникам сдаются карты с колоды до тех пор, пока их не будет по 3 у каждого. Игрок, взявший \"взятку\", должен инициировать следующий ход. Переход хода происходит в том случае, когда игрок, проигравший последний розыгрыш, после раздачи карт с колоды обладает одной из следующих комбинаций: бура (3 козырных карты) или золотая бура (3 туза, включая козырный). Игра проходит в описанном ключе ровно до тех пор, пока у игроков есть карты \"на руках\". Конечный результат определяется подсчетом очков карт, составляющих \"взятки\" игроков. Старшинство и достоинство карт: Туз - 11 очков; 10 - 10 очков (при этом десятка старше короля, дамы и валета); король - 4 очка, дама - 3 очка, валет - 2 очка; 6, 7, 8, 9 - 0 очков."






class RulesViewController: UIViewController, UIScrollViewDelegate {
    
    var scroller: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT * 1.5))
    
    
    lazy var back_button: UIButton = {
        var res = UIButton(frame: CGRectMake(0.01 * WIDTH, 0.01 * HEIGHT, 0.12 * WIDTH, 0.1 * HEIGHT));
        res.setBackgroundImage(UIImage(named: "back_button.png"), forState: UIControlState.Normal);
        res.addTarget(self, action: "goBackAction", forControlEvents: UIControlEvents.TouchUpInside);
        return res;
        }()
    
    
    lazy var title_label: UILabel = {
        var res: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH * 0.8, height: HEIGHT * 0.2))
        
        res.center.x = WIDTH / 2.0
        res.center.y = res.frame.size.height / 2 + 0.1 * HEIGHT;
        
        res.text = (self.language == Language.ENGLISH) ? "Obey the rules!" : "Следуй правилам!"
        res.textAlignment = NSTextAlignment.Center
        res.textColor = UIColor.whiteColor()
        res.font = res.font.fontWithSize(40)
        
        return res
        }()
    
    
    lazy var rules_label: UILabel = {
        var res: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH * 0.8, height: 10000))
        
        res.center.x = WIDTH / 2.0
        
        res.numberOfLines = 0
        
        res.backgroundColor = UIColor.clearColor()
        
        res.frame.origin.y = HEIGHT * 0.4
        
        res.text = (self.language == Language.ENGLISH) ? rules_text_english : rules_text_russian;
        res.textColor = UIColor.whiteColor()
        
        res.sizeToFit()
        
        return res
        }()
    
    
    var delegate: RulesViewControllerDelegate!;
    
    
    var language: Language!;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: BACKGROUND_IMG);
        
        self.view.addSubview(self.scroller);

        let height = self.rules_label.frame.origin.y + self.rules_label.frame.size.height + HEIGHT;
        self.scroller.contentSize = CGSize(width: WIDTH, height: height);
        
        self.scroller.addSubview(self.back_button);
        self.scroller.addSubview(self.rules_label);
        self.scroller.addSubview(self.title_label);
        
        self.scroller.delegate = self;
        self.scroller.scrollEnabled = true;
    }
    
    
    
    
    func goBackAction() {
        self.delegate.rulesViewControllerDidDismiss(self);
    }
}
