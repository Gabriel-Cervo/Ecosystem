//#-hidden-code
import PlaygroundSupport
import Ecosystem
import SpriteKit
//#-end-hidden-code

/*:
 
# Plants
    
The plants are the biggest and one of the most diverse group of living beings on the planet. They are the basis of terrestrial ecosystems. Plants also provide us a substantial part of oxygen, which we need to survive, so it's important to take care of them!!
 
- Callout(Did you know? 💡):
    Trees are a plant! Some people don't know this because they are big, but in fact, they are a very large plant!
 
 ### Life Cycle
 
 Plants starts life as a seed, which germinates and grows into a plant. The mature plant produces flowers, which are fertilised and produce seeds in a fruit or seedpod. The plant eventually dies, leaving seeds which will germinate to produce new plants, and the cycle repeats itself.
 
 - Callout(Try it by yourself!):
    Try cutting the branch of a healthy plant and put it in a suitable medium, such as moist soil. And then just wait for the plant to grow! But be aware to take good care of the plant, otherwise it will die and not grow 😓
 
 ### Nutrition
 
 Plants get their nutrition from photosynthesis, that is, aborbing energy from the sun's light. There are some carnivorous plants that complements their nutrition eating little insects.
 
 - Callout(Taking good care of a plant):
    If you follow the last tip, try to not let your plant in the sun's light for too long, or they die! Try to maintain a good balance of time 😊. And don't forget to give water to the soil.
 
 ## Let's start building the simulation 🔧
 Now that you know the basics of plants, I think we can start building our own ecosystem!
    Don't worry! You don't need to know how to code, everything here will be very intuitive!
    First, you need to put below the type of the plant you want in your ecosystem, try changing the variable below to values from 1 to 3. You can also modify the number of plants in screen to be of your liking. And then try hitting "Run my code" to see what type of plant it appears.
 
 + Callout(Limits):
    The upper limit for plants is 250. You can put any number below that. If you try to exceed it, it will ignore and draw until the limit.
 
 - Note:
    There is no error handling if you type a invalid number, so i'm gonna trust you to not break the program!
 
 After you are done:
 [Click here to advance](@next)

    
 */
var typeOfPlant: FlowerType = /*#-editable-code*/<#T##.grass | .herb | .flower##FlowerType#>/*#-end-editable-code*/
var numberOfPlantsInScreen: Int = /*#-editable-code*/<#T##Number of plants##Int#>/*#-end-editable-code*/

//#-hidden-code
public func startSystem() {
    guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
        fatalError("Always-on live view not configured in this page's LiveView.swift")
    }
    
    let plantType = getPlantTypeInInt(typeOfPlant)
    
    remoteView.send(.dictionary(["plantType": .integer(plantType), "numberOfPlants": .integer(numberOfPlantsInScreen)]))
}

startSystem()
//#-end-hidden-code
