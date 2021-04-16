//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Herbivores
    
Herbivore is an animal that eat plant-based material (plants, algae, seeds...) as his main component of its diet. They range in size from tiny insects to large animals, such the elephant.
 
- Callout(Did you know? 💡):
    The biggest dinosaur was a herbivorous one! According to the paleontologist Gregory Paul, the Argentinosaurus had a approximate mass of 65 to 70 tons 🤯.
 
 ### Nutrition
 
 Herbivores depend on plants for survival, so if the plant population declines, they can't get enough food 😦. Many herbivores spend a big part of their life eating. Elephants for example, need about 300 pounds of food a day, and it takes a long time to eat that much of leaves and grass.
 
 ### Impact
 
 They have an important role in maintaining the ecosystem by preventing an overgrowth of vegetation. Many plants relies on the herbivores, like bees, to help them reproduce.
 They are termed as the primary consumers in the food cycle, since they can survive solely on plant matter. They are one of the most diverse group too! Having a group of ~4000 species.
 
 - Callout(See it by yourself!):
   Try naming at least 10 species of herbivores in your region, I bet you know a lot of them 😉
 
 ## Let's continue our simulation! 🔧
 I guess now we have all we need to take our simulation to the next step! In the last page, you probably (or not) tought to yourself, well, isn't the plant population getting out of control since we don't have any animals? Yes! That's why now it's time to add herbivores to your ecosystem! Try testing different species and quantities to see the best options that fit your simulation!
 
 - Note:
    I had a tough time trying to put persistent data across this playground, unfortunaly I didn't make it in time for WWDC, sorry 😓. So I'm going to need you to put again the number and type of plants...
 */

var typeOfPlant: Int = /*#-editable-code*/<#T##Type of Plant (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfPlantsInScreen: Int = /*#-editable-code*/<#T##Number of plants##Int#>/*#-end-editable-code*/


var typeOfHerbivore: Int = /*#-editable-code*/<#T##Type of herbivore (1 to 3)##Int#>/*#-end-editable-code*/
var numberOfHerbivoresInScreen: Int = /*#-editable-code*/<#T##Number of herbivores##Int#>/*#-end-editable-code*/



//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    remoteView.send(.dictionary(["plantType": .integer(typeOfPlant), "numberOfPlants": .integer(numberOfPlantsInScreen), "herbivoreType": .integer(typeOfHerbivore), "numberOfHerbivores": .integer(numberOfHerbivoresInScreen)]))
    
}

startSystem()
//#-end-hidden-code
