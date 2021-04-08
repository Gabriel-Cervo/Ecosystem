
import UIKit
import SpriteKit

public class SimulationViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView()
        let scene: SimulationScene = SimulationScene()
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        self.view = view
    }
}
