import SpriteKit
public class SimulationScene: SKScene {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var numOfPlants: Int = 35
    var numOfHerbivores: Int = 5
    
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        drawPlants()
        drawHerbivores()
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
    
    public func drawHerbivores() {
        herbivores = []
        for i in 0..<numOfHerbivores {
            var animal = Animal()
            if self.size.width > 0 {
                animal.x = CGFloat.random(in: 0..<size.width)
                animal.y = CGFloat.random(in: 0..<size.height)
            }
            herbivores.append(animal)
        }
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        draw()
        updateAnimalsState()
    }
    
    public func draw() {
        self.removeAllChildren()
        for i in 0..<numOfPlants {
            self.addChild(plants[i].getShape())
        }
        
        for i in 0..<numOfHerbivores {
            self.addChild(herbivores[i].getShape())
        }
    }
    
    public func updateAnimalsState() {
        for i in 0..<numOfHerbivores {
            herbivores[i].updateState()
        }
    }
}
