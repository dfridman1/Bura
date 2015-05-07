//
//  enums.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/5/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation


enum ConnectionState {
    case NOT_CONNECTED; case CONNECTING; case CONNECTED;
}


enum GameState {
    case GAME_NOT_STARTED; case GAME_STARTED;
}


enum QuitReason {
    case CONNECTION_LOST; case VOLANTARY;
}


enum Language {
    case RUSSIAN; case ENGLISH;
}