//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Simulating the Ecosystem

## Running the simulation
    
Know that you learned everything from here, we can start simulating our ecosystem! The simulation here will be very simple. Let me explain how the simulation will work:
 
- The simulation here is a **very simple** way of showing how a ecosystem works. The objective is not to be realistic, but to be a funny way of showing the topic learned in this playground.
- All animals feel hungry, when they reach a certain percentage, they start searching for food.
- Herbivorous animals eat the plants.
- Carnivorous animals eat the herbivorous ones.
- When animals are tired, they sleep. You may see carnivorous a lot more often staying in the same place, because they get more energy from their food.
- When a animal can't find food, he dies of hunger. In the simulation it is represented by changing his opacity.
- Animals reproduce, but it depends on how many of them are not starving. For each two animals, another one is born. They appear randomly in the screen.
- Plants are always growing from the ground as long as there is a herbivore.
 
 You can change the runSimulation variable from 0 (not running) to 1 (running), that way you can test new types of animals and plants.
 Very simple, huh? The key here is to balance the number between each type of animals and plants, not letting the ecosystem get unbalanced.
 The simulation is all yours now! Enjoy testing new combations of animals and plants!
 
 - Note:
    The limits for plants is 250. For herbivores and carnivores is 100. But I think you already saw that this is too much...

 + Callout(João):
    Hey, WWDC! Thank you for taking your time to see this playground. Hope I have been able to encourage you to look for more info on the subject spoken here. Take care and good luck in the simulation!
*/

var typeOfPlant: Int = /*#-editable-code*/<#T##Type of Plant (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfPlantsInScreen: Int = /*#-editable-code*/<#T##Number of plants##Int#>/*#-end-editable-code*/


var typeOfHerbivore: Int = /*#-editable-code*/<#T##Type of herbivore (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfHerbivoresInScreen: Int = /*#-editable-code*/<#T##Number of herbivores##Int#>/*#-end-editable-code*/


var typeOfCarnivore: Int = /*#-editable-code*/<#T##Type of carnivore (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfCarnivoresInScreen: Int = /*#-editable-code*/<#T##Number of carnivores##Int#>/*#-end-editable-code*/


var runSimulation: Int = /*#-editable-code*/<#T##0 or 1##Int#>/*#-end-editable-code*/


//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    remoteView.send(.dictionary(["plantType": .integer(typeOfPlant), "numberOfPlants": .integer(numberOfPlantsInScreen), "herbivoreType": .integer(typeOfHerbivore), "numberOfHerbivores": .integer(numberOfHerbivoresInScreen), "carnivoreType": .integer(typeOfCarnivore), "numberOfCarnivores": .integer(numberOfCarnivoresInScreen), "startSimulation": .integer(runSimulation)]))
    
}

startSystem()
//#-end-hidden-code
