//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit

var previousPlantType: FlowerType = .grass
var previousHerbivoreType: HerbivoreType = .capybara
var previousCarnivoreType: CarnivoreType = .jaguar

var previousNumberOfPlants: Int = 0
var previousNumberOfHerbivores: Int = 0
var previousNumberOfCarnivores: Int = 0

func loadTypes() {
    if let typeOfPlant = PlaygroundKeyValueStore.current["plantType"],
        case .integer(let type) = typeOfPlant {
        switch type {
        case 1:
            previousPlantType = FlowerType.grass
        case 2:
            previousPlantType = FlowerType.herb
        case 3:
            previousPlantType = FlowerType.flower
        default:
            previousPlantType = FlowerType.grass
        }
    }
    
    if let typeOfHerbivore = PlaygroundKeyValueStore.current["herbivoreType"],
        case .integer(let type) = typeOfHerbivore {
        switch type {
        case 1:
            previousHerbivoreType = HerbivoreType.capybara
        case 2:
            previousHerbivoreType = HerbivoreType.rabbit
        case 3:
            previousHerbivoreType = HerbivoreType.zebra
        default:
            previousHerbivoreType = HerbivoreType.capybara
        }
    }
    
    if let typeOfCarnivore = PlaygroundKeyValueStore.current["carnivoreType"],
        case .integer(let type) = typeOfCarnivore {
        switch type {
        case 1:
            previousCarnivoreType = CarnivoreType.jaguar
        case 2:
            previousCarnivoreType = CarnivoreType.snake
        case 3:
            previousCarnivoreType = CarnivoreType.wolf
        default:
            previousCarnivoreType = CarnivoreType.jaguar
        }
    }
}

func loadNumbers() {
    if let numberOfPlants = PlaygroundKeyValueStore.current["numberOfPlants"],
        case .integer(let nPlants) = numberOfPlants {
        previousNumberOfPlants = nPlants
    }

    if let numberOfHerbivores = PlaygroundKeyValueStore.current["numberOfHerbivores"],
        case .integer(let nHerbivores) = numberOfHerbivores {
        previousNumberOfHerbivores = nHerbivores
    }

    if let numberOfCarnivores = PlaygroundKeyValueStore.current["numberOfCarnivores"],
        case .integer(let nCarnivores) = numberOfCarnivores {
        previousNumberOfCarnivores = nCarnivores
    }
}

loadTypes()
loadNumbers()
    
//#-end-hidden-code

/*:
 
# Simulating the Ecosystem

## Running the simulation
    
Now that you learned everything from here, we can start simulating our ecosystem! The simulation here will be very simple. Let me explain how it will work:
 
- The simulation here is a **very simple** way of showing how an ecosystem works. The objective is not to be realistic, but to be a funny way of showing the topic learned in this playground.
- All animals feel hungry, when they reach a certain percentage, they start searching for food.
- Herbivorous animals eat the plants.
- Carnivorous animals eat the herbivorous ones.
- When animals are tired, they sleep. You may see carnivorous staying in the same place a lot more often than herbivorous, because they get more energy from their food.
- When an animal can't find food, it dies of hunger. In the simulation it is represented by changing its opacity.
- Animals reproduce, but it depends on how many of them are not starving. For each two animals, another one is born. They appear randomly in the ecosystem.
- Plants are always growing from the ground as long as there is a herbivore.
 
 You can change the `runSimulation` variable from `false` (not running) to `true` (running), that way you can test new types of animals and plants.
 Very simple, huh? The key here is to balance the number between each type of animals (carnivorous and herbivorous) and plants, not letting the ecosystem get unbalanced.
 The simulation is all yours now! Enjoy testing new combations of animals and plants!
 
 + Callout(Limits):
    The limits for the number of plants is 250. For herbivores and carnivores it's 100. But I think you already saw that this is too much...
 
 - Note:
    The code will automatically load your previous choices. So you don't need to modify the variables unless you want to change something 😉

 + Callout(João):
    Hey, WWDC! Thank you for taking your time to see this playground. Hope I have been able to encourage you to look for more info on the subject on this topic. Take care and good luck in the simulation!
*/

var typeOfPlant: FlowerType = /*#-editable-code*/previousPlantType/*#-end-editable-code*/
var numberOfPlantsInScreen: Int = /*#-editable-code*/previousNumberOfPlants/*#-end-editable-code*/


var typeOfHerbivore: HerbivoreType = /*#-editable-code*/previousHerbivoreType/*#-end-editable-code*/
var numberOfHerbivoresInScreen: Int = /*#-editable-code*/previousNumberOfHerbivores/*#-end-editable-code*/


var typeOfCarnivore: CarnivoreType = /*#-editable-code*/previousCarnivoreType/*#-end-editable-code*/
var numberOfCarnivoresInScreen: Int = /*#-editable-code*/previousNumberOfCarnivores/*#-end-editable-code*/


var runSimulation: Bool = /*#-editable-code*/true/*#-end-editable-code*/


//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    let plantType = getPlantTypeInInt(typeOfPlant)
    let herbivoreType = getHerbivoreTypeInInt(typeOfHerbivore)
    let carnivoreType = getCarnivoreTypeInInt(typeOfCarnivore)

    remoteView.send(.dictionary(["plantType": .integer(plantType), "numberOfPlants": .integer(numberOfPlantsInScreen), "herbivoreType": .integer(herbivoreType), "numberOfHerbivores": .integer(numberOfHerbivoresInScreen), "carnivoreType": .integer(carnivoreType), "numberOfCarnivores": .integer(numberOfCarnivoresInScreen), "startSimulation": .boolean(runSimulation)]))
    
}

startSystem()
//#-end-hidden-code
