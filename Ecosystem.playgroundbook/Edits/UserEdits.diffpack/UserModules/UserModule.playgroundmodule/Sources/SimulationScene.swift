import SpriteKit
public class SimulationScene: SKScene {
    var plants: [Plant] = []
    let numOfPlants: Int = 35
    
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        drawPlants()
    }
    
    public func drawPlants() {
        plants = []
        for i in 0..<numOfPlants {
            var plant = Plant()
            if self.size.width > 0 {
                plant.x = CGFloat.random(in: 0..<size.width)
                plant.y = CGFloat.random(in: 0..<size.height)
                plant.size = CGFloat.random(in: 3...8)
            }
            plants.append(plant)
        }
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        draw()
    }
    
    public func draw() {
        self.removeAllChildren()
        for i in 0..<numOfPlants {
            self.addChild(plants[i].getShape())
        }
    }
}
