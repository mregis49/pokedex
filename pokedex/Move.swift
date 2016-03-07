//
//  Move.swift
//  pokedex
//
//  Created by Regis Family on 3/5/16.
//  Copyright © 2016 Regis Family. All rights reserved.
//

import Foundation

class Move {
    
    private var _name: String!
    private var _description: String!
    private var _accuracy: String!
    private var _power: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name 
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var accuracy: String {
        if _accuracy == nil {
            _accuracy = ""
        }
        return _accuracy
    }
    
    var power: String {
        if _power == nil {
            _power = ""
        }
        return _power
    }
    
    init(name: String, description: String, accuracy: String, power: String) {
        self._name = name.capitalizedString
        self._description = description
        self._accuracy = accuracy
        self._power = power
    }    
}
