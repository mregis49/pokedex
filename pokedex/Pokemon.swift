//
//  Pokemon.swift
//  pokedex
//
//  Created by Regis Family on 3/1/16.
//  Copyright © 2016 Regis Family. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    private var _moves: [Move]!
    
    var moves: [Move] {
        if _moves == nil {
            _moves = [Move]()
        }
        return _moves
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
       
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                

                // Pokemon type
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0  {
                
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
        
                // Description
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let descrip = descDict["description"] as? String {
                                    let description = descrip.stringByReplacingOccurrencesOfString("POKMON", withString: "pokemon")
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }

                // Evolutions
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                   
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon right now but api still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                    }
                                    
                                } else {
                                    self._nextEvolutionLvl = ""
                                    
                                }
                            }
                        }
                    }
                }
                
                //Moves
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] where moves.count > 0 {
                    
                    var moveName = ""
                    var moveDesc = ""
                    var movePower = ""
                    var moveAccuracy = ""
                    
                    for move in moves {
                        
                        if let url = move["resource_uri"] as? String {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                                
                                let moveResult = response.result
                                
                                if let moveDict = moveResult.value as? Dictionary<String, AnyObject> {
                                    
                                    if let name = moveDict["name"] as? String {
                                        moveName = name
                                    }
                                    
                                    if let desc = moveDict["description"] as? String {
                                        moveDesc = desc
                                    }
                                    
                                    if let power = moveDict["power"] as? Int {
                                        movePower = "\(power)"
                                    }
                                    
                                    if let accuracy = moveDict["accuracy"] as? Int {
                                        moveAccuracy = "\(accuracy)"
                                    }
                                    
                                    let move = Move(name: moveName, description: moveDesc, accuracy: moveAccuracy, power: movePower)
                                    
                                    self._moves.append(move)
                                    print(move.name)
                                    print(move.description)
                                    print(move.power)
                                    print(move.accuracy)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}