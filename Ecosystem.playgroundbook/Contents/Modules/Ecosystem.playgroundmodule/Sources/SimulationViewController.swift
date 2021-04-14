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
        switch message {
        case let .integer(info):
            scene.typeOfPlant = info
            scene.start()
            break
        default:
            print("Mensagem não tratada")
        }
    }
}
