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
        scene.start()
    }
}
