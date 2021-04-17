//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Herbivores
    
Herbivore is an animal that eat plant-based material (plants, algae, seeds...) as the main component of its diet. They range in size from tiny insects to large animals, like elephants.
 
- Callout(Did you know? 💡):
    The biggest dinosaur was herbivorous! According to the paleontologist Gregory Paul, the Argentinosaurus had an approximate mass of 65 to 70 tons 🤯.
 
 ### Nutrition
 
 Herbivores depend on plants for survival, so if the plant population declines, they can't get enough food 😦. Many herbivores spend a big part of their life eating. Elephants, for example, need about 300 pounds of food a day, and it takes a long time to eat that much of leaves and grass.
 
 ### Impact
 
 They have an important role in maintaining the ecosystem by preventing an overgrowth of vegetation. Many plants relies on herbivores, like bees, to help them reproduce.
 They are termed as the primary consumers in the food chain, since they can survive solely on plant matter.
 
 - Callout(See it by yourself!):
   Try naming at least 10 species of herbivores in your region, I bet you know a lot of them 😉
 
 ## Let's continue our simulation! 🔧
 I guess now we have all we need to take our simulation to the next step! In the previous page, you probably (or not) tought to yourself, well, isn't the plant population getting out of control since we don't have any animals? Yes! That's why now it's time to test herbivores to add for your ecosystem! Try testing different species and quantities to see the best options that fit your simulation!
 
 + Callout(Limits):
    The limit for the number of herbivores is 100.
 
 After you are done:
 [Click here to advance](@next)
 */

var typeOfHerbivore: HerbivoreType = /*#-editable-code*/<#T##.capybara | .rabbit | .zebra##HerbivoreType#>/*#-end-editable-code*/
var numberOfHerbivoresInScreen: Int = /*#-editable-code*/<#T##Number of herbivores##Int#>/*#-end-editable-code*/


//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
     let herbivoreType = getHerbivoreTypeInInt(typeOfHerbivore)
    
    PlaygroundKeyValueStore.current["herbivoreType"] = .integer(herbivoreType)
    PlaygroundKeyValueStore.current["numberOfHerbivores"] = .integer(numberOfHerbivoresInScreen)
        
    remoteView.send(.dictionary(["herbivoreType": .integer(herbivoreType), "numberOfHerbivores": .integer(numberOfHerbivoresInScreen)]))
}

startSystem()
//#-end-hidden-code
