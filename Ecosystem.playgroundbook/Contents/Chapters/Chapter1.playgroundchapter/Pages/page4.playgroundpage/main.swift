//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Carnivores
    
 Carnivore is an animal that mostly eats meat or animal tissue, acquired by hunting or scavenging. Carnivores are called predators.
  
 - Callout(Did you know? 💡):
     Carnivores cannot move their lower jaw from side to side. That's why you see your dog or cat doing chomping up-and-down motion when eating. This happens because of the shape of the carnivoran skull.
  
  ### Types
  
  You may think that carnivores are predators that only eat other animals. But not all of them eat *only* meat, there's different types of carnivores, as shown below:
 
 - Obligate Carnivores -> Depend only on meat for survival, and their body cannot digest plants properly.
 
 - Hipercarnivore -> Is an organism that depends on meat for at least 70% of its diet. Other nutrients make up the rest of their food, like plants or fungi. Cats are a good example of this type.
 
 - Mesocarnivores -> Depend on meat for at least 50% of their diet. They also eat fruits and vegetables. A good example is foxes.
 
 - Hypocarnivores -> Depend on animals for less than 30% of their diet. Bears are a goode example, they eat meat, fish berries... the list goes on. They are also considered omnivores.
 
  
  ### Impact
  
  They are very important to a healthy ecosystem. They keep the number of herbivores in balance so it doesn't happen a overpopulation, disrupting the entire ecosystem.
  
  - Callout(Don't you have one in home?):
    Cat's are a very common house companion. Since they are carnivores, it's not very uncommon to see your cat bringing home a dead animal or trying to hunt any animal that enter's your house.
  
  ## It's time to complete our simulation! 🔧
  That's it! Now you now the basics of a ecosystem. On the next chapter you will see how the simulation will in fact work and see everything interacting. But first, why not try to add some carnivores here and see which one serves your simulation best?
 
 - Note:
    The limits for plants is 250. For herbivores and carnivores is 100.
  
 + Note:
   If you want to see the articles used for reference, I made a list [here.](https://www.notion.so/b064038b379a403eb0d31b9ee39ebe1d?v=6ede034d4ff64a9e82702c90f102a2c2) They all have a very nice content and can be a good source to deepen your knowledge with topics not covered here 😉.
 
 After you are done:
 [Go to simulation](@next)
 */

var typeOfPlant: Int = /*#-editable-code*/<#T##Type of Plant (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfPlantsInScreen: Int = /*#-editable-code*/<#T##Number of plants##Int#>/*#-end-editable-code*/


var typeOfHerbivore: Int = /*#-editable-code*/<#T##Type of herbivore (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfHerbivoresInScreen: Int = /*#-editable-code*/<#T##Number of herbivores##Int#>/*#-end-editable-code*/

var typeOfCarnivore: Int = /*#-editable-code*/<#T##Type of carnivore (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfCarnivoresInScreen: Int = /*#-editable-code*/<#T##Number of carnivores##Int#>/*#-end-editable-code*/


//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    remoteView.send(.dictionary(["plantType": .integer(typeOfPlant), "numberOfPlants": .integer(numberOfPlantsInScreen), "herbivoreType": .integer(typeOfHerbivore), "numberOfHerbivores": .integer(numberOfHerbivoresInScreen), "carnivoreType": .integer(typeOfCarnivore), "numberOfCarnivores": .integer(numberOfCarnivoresInScreen)]))
    
}

startSystem()
//#-end-hidden-code
