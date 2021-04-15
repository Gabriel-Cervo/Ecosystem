import UIKit
import SpriteKit

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
        if case let .integer(info) = message {
            switch info {
            case info:
                scene.typeOfPlant = info
                scene.start()
                break
            default:
                break
            }
        }
    }
}
