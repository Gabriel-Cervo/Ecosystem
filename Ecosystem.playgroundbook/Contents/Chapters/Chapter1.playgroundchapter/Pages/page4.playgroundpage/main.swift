//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Carnivores
    
 Carnivore is an animal that mostly eats meat or animal tissue, acquired by hunting or scavenging. Carnivores are called predators.
  
 - Callout(Did you know? 💡):
     Carnivores cannot move their lower jaw from side to side. That's why you see your dog or cat chomping up-and-down motion when eating. This happens because of the shape of the carnivoran skull.
  
  ### Types
  
  You may think that carnivores are predators that only eat other animals. But not all of them eat *only* meat, there's different types of carnivores, as shown below:
 
 - Obligate Carnivores -> Depend only on meat for survival, and their body cannot digest plants properly.
 
 - Hipercarnivore -> It's an organism that depends on meat for at least 70% of its diet. Other nutrients make up the rest of their food, like plants or fungi. Cats are a good example of this type.
 
 - Mesocarnivores -> Depend on meat for at least 50% of their diet. They also eat fruits and vegetables. A good example is foxes.
 
 - Hypocarnivores -> Depend on animals for less than 30% of their diet. Bears are a goode example, they eat meat, fish berries... the list goes on. They are also considered omnivores.
 
  
  ### Impact
  
  They are very important to a healthy ecosystem. They keep the number of herbivores in balance so overpopulation doesn't happen, disrupting the entire ecosystem.
  
  - Callout(Don't you have one in home?):
    Cats are very common house companions. Since they are carnivores, it's not very uncommon to see your cat bringing home a dead animal or trying to hunt any animal that enter's your house.
  
  ## It's time to complete our simulation! 🔧
  That's it! Now you now the basics of an ecosystem. On the next chapter you will see how the simulation will in fact work and see everything interacting. But first, why not try to add some carnivores here and see which one serves your simulation best?
 
 + Callout(Limits):
    The limit for the number of carnivores is 100.
 
 After you are done:
 [Go to simulation](@next)
 */

var typeOfCarnivore: CarnivoreType = /*#-editable-code*/<#T##.jaguar | .snake | .wolf##CarnivoreType#>/*#-end-editable-code*/
var numberOfCarnivoresInScreen: Int = /*#-editable-code*/<#T##Number of carnivores##Int#>/*#-end-editable-code*/


//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    let carnivoreType = getCarnivoreTypeInInt(typeOfCarnivore)
    
    PlaygroundKeyValueStore.current["carnivoreType"] = .integer(carnivoreType)
    PlaygroundKeyValueStore.current["numberOfCarnivores"] = .integer(numberOfCarnivoresInScreen)
    
    remoteView.send(.dictionary(["carnivoreType": .integer(carnivoreType), "numberOfCarnivores": .integer(numberOfCarnivoresInScreen)]))
}

startSystem()
//#-end-hidden-code
