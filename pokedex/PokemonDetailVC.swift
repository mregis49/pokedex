//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Regis Family on 3/3/16.
//  Copyright © 2016 Regis Family. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemon: Pokemon!
    
    @IBOutlet var segCtrl: UISegmentedControl!
    
    @IBOutlet var bioStack: UIStackView!
    @IBOutlet var evoStack: UIStackView!
    @IBOutlet var evoView: UIView!
    @IBOutlet var movesTableView: UITableView!
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var defenseLbl: UILabel!
    @IBOutlet var heightLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var baseAttackLbl: UILabel!
    @IBOutlet var pokedexLbl: UILabel!
    @IBOutlet var currentEvoImg: UIImageView!
    @IBOutlet var nextEvoImg: UIImageView!
    @IBOutlet var evoLbl: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after download is done
            self.updateUI()
            self.movesTableView.reloadData()
        }
        
        movesTableView.hidden = true
        movesTableView.delegate = self
        movesTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        movesTableView.reloadData()
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.attack
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
            
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
                evoLbl.text = str
            }
        }
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func segCtrlPressed(sender: AnyObject) {
          if segCtrl.selectedSegmentIndex == 0 {
            movesTableView.hidden = true
            bioStack.hidden = false
            evoStack.hidden = false
            evoView.hidden = false
            
        } else if segCtrl.selectedSegmentIndex == 1 {
            movesTableView.hidden = false
            bioStack.hidden = true
            evoStack.hidden = true
            evoView.hidden = true
            movesTableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovesCell") as? MovesCell {
            let move = pokemon.moves[indexPath.row]
            cell.configureCell(move)
            return cell
            
        } else {
            return MovesCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemon.moves.count
    }    
}
