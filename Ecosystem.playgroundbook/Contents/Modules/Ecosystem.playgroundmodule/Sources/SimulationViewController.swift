import UIKit
import SpriteKit
import PlaygroundSupport

public class SimulationViewController: UIViewController {
    var scene = SimulationScene()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView()
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        self.view = view
    }
}

extension SimulationViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard case let .dictionary(info) = message else { return }
        guard case let .integer(typeOfPlant) = info["plantType"] else { return }
        guard case let .integer(numberOfPlantsInScreen) = info["numberOfPlants"] else { return }

        scene.initialNumberOfPlants = numberOfPlantsInScreen
        scene.typeOfPlant = typeOfPlant
        
        if case let .integer(typeOfHerbivore) = info["herbivoreType"], case let .integer(numberOfHerbivores) = info["numberOfHerbivores"] {
                scene.typeOfHerbivore = typeOfHerbivore
                scene.initialNumberOfHerbivores = numberOfHerbivores
            }
        
        if case let .integer(typeOfCarnivore) = info["carnivoreType"], case let .integer(numberOfCarnivores) = info["numberOfCarnivores"] {
                scene.typeOfCarnivore = (typeOfCarnivore)
                scene.initialNumberOfCarnivores = numberOfCarnivores
            }
        
        scene.start()
    }
}
