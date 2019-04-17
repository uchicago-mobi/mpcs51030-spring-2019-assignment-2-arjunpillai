//
//  ViewController.swift
//  ItsAZooInThere
//
//  Created by Arjun Pillai on 4/16/19.
//  Copyright © 2019 Arjun Pillai. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Properties
    var animals: [Animal] = []
    var animalSound: AVAudioPlayer?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var animalLabel: UILabel!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create three animals.
        // Used Image Literal construct adapted from this guide: https://guides.codepath.com/ios/adding-image-assets
        let panthro = Animal(name:"Panthro", species:"Panther", age:5,
                             image: #imageLiteral(resourceName: "Pantrho"), soundPath: "Panther.mp3", character: "proud")
        let tygra = Animal(name:"Tygra", species:"Tiger", age:6,
                           image: #imageLiteral(resourceName: "Tygra"), soundPath: "Tiger.mp3", character: "noble")
        let liono = Animal(name:"Liono", species:"Lion", age:6,
                           image: #imageLiteral(resourceName: "Liono"), soundPath: "Lion.mp3", character: "valiant")
        
        // Randomly assign created animals to the animals array.
        // Shuffle method reference from Swift docs: https://developer.apple.com/documentation/swift/array/2994753-shuffle
        self.animals = [panthro, tygra, liono]
        animals.shuffle()
        
        // Center label and set it to the first animal in animals
        animalLabel.textAlignment = .center
        animalLabel.text = animals[0].species
        
        // Set scroll view delegate to this view controller and set content size. Note: window size set to 375 * 500 on storyboard
        // Adapted implementation from question on Stack Overvflow:
        // https://stackoverflow.com/questions/37114002/change-uiscrollview-content-size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width:1125, height:500)
        
        // Add a button and image to the subview for each animal in the list of animals
        for (index, animal) in animals.enumerated() {
            // Add a button to the scrollView
            let button = UIButton(type: .system)
            scrollView.addSubview(button)
            
            // Update button properties
            // Tag and title updates modeled after Stack Overflow answer:
            // https://stackoverflow.com/questions/31616341/how-to-change-uibutton-label-programmatically
            // Adapted setTitle from UIKit docs: https://developer.apple.com/documentation/uikit/uibutton/1624018-settitle
            button.tag = index
            button.setTitle(animal.name, for: UIControl.State.normal)
            button.frame = CGRect(x: 375*index, y: 400, width: 375, height: 100)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            // Add an imageView of the animal at this index to the scrollView and set it size appropriately
            // Assumes image is always present
            let image = UIImageView(image: animal.image)
            scrollView.addSubview(image)
            image.frame = CGRect(x: 375*index, y: 30, width: 375, height: 350)
        }
    }
    
    
    // MARK: Button Functionality
    // Adapted from first answer on Stack Overflow to:
    // https://stackoverflow.com/questions/35550966/swift-add-show-action-to-button-programmatically
    @objc func buttonTapped(_ sender: UIButton!) {
        // Identify correct animal from list of animals using sender's tag
        let animal = self.animals[sender.tag]
        print(animal) // Requested in spec - prints animal description to console
        
        // Play animal sound
        // Code modified from: https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
        // Get path to expected animal sound resource
        let path = Bundle.main.path(forResource: animal.soundPath, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        // Try to play the animal sound resource using URL and AVAudioPlayer
        do {
            animalSound = try AVAudioPlayer(contentsOf: url)
            animalSound?.play()
        } catch {
            // Log error - could not load file at URL
            print("Could not load requested mp3 file from \(url)")
        }
        
        // Create alert for this animal. Code adapted from: https://nshipster.com/uialertcontroller/
        let description = "\(animal.name) is a \(animal.age) year old \(animal.species) and a \(animal.character) defender of Thundaria!"
        let alertController = UIAlertController(title: "Meet \(animal.name)",
                                                message: description,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Hi \(animal.name)!", style: .cancel) { (action) in })
        
        // Display alert for this animal. Code adapted from: https://nshipster.com/uialertcontroller/
        self.present(alertController, animated: true) { /* Display with no cleanup actions */ }
    }
    
}


extension ViewController: UIScrollViewDelegate{
    
    // Adjust label text and opacity as user scrolls through the animal images
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Adjust the label text to reflect the animal whose image takes up most of the screen
        animalLabel.text = animals[Int((scrollView.contentOffset.x + 187.5) / 375)].species
        
        // Determine quantity for dimness that is 0.0 when the current x offset is in the middle of
        // the scrollView frame and 1.0 when it is at the edge of the frame
        // Referenced the Swift docs for abs function: https://developer.apple.com/documentation/swift/2885649-abs
        let dimness = abs(0.5 - (Double(scrollView.contentOffset.x).truncatingRemainder(dividingBy: 375.0)) / 375.0) * 2.0
        
        // Set the the label opacity using the construct from flashlight app (line 22):
        // https://github.com/uchicago-mobi/flashlight/blob/master/Flashlight/ViewController.swift
        animalLabel.textColor = UIColor.black.withAlphaComponent(CGFloat(dimness))
    }
    
}
