//
//  Animal.swift
//  ItsAZooInThere
//
//  Created by Arjun Pillai on 4/16/19.
//  Copyright © 2019 Arjun Pillai. All rights reserved.
//

import UIKit

class Animal: CustomStringConvertible {
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    let description: String
    let character: String
    
    init(name:String, species: String, age: Int, image: UIImage, soundPath: String, character: String) {
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
        self.character = character
        self.description = "Animal: name = \(name), species = \(species), age = \(age)"
    }
}
