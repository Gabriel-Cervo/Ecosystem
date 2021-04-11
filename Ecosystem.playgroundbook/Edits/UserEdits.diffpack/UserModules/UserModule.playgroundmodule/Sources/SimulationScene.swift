import SpriteKit
import GameplayKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var numOfPlants: Int = 20
    var numOfHerbivores: Int = 10
    var hasShown: Bool = false
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let obj1 = contact.bodyA.node else { return }
        guard let obj2 = contact.bodyB.node else { return }
        
        collisionBetween(obj1: obj1, obj2: obj2)
    }
    
    // Collision
    func collisionBetween(obj1: SKNode, obj2: SKNode) {
        let areTwoHerbivorous = obj1.name!.commonPrefix(with: obj2.name!).hasPrefix("h")
        if areTwoHerbivorous {
            return
        }
        
        obj2.removeFromParent()
        
        let objectToRemove = checkWhatObjectToRemoveBetween(obj1, obj2)
        
        if objectToRemove.name!.hasPrefix("p") {
            var indexInName: Int = 0
            for (index, char) in objectToRemove.name!.enumerated() {
                if char.isNumber {
                    indexInName = index
                    if let indexInList = Int(String(objectToRemove.name!.suffix(indexInName))) {
                        self.plants.remove(at: indexInList)
                    }
                    break
                }
            }
        }
    }
    
    func checkWhatObjectToRemoveBetween(_ obj1: SKNode, _ obj2: SKNode) -> SKNode {
        let names = (obj1.name!, obj2.name!)
        if names.0.hasPrefix("h") && names.1.hasPrefix("p") {
            return obj2
        }
        
        return obj1
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if !hasShown {
            draw()
            hasShown = true
        } else {
            updateAnimalsState()
        }
    }
    
    public func draw() {
        drawPlants()
        drawHerbivores()
    }
    
    func drawPlants() {
        for i in 0..<numOfPlants {
            var plant = Plant()
            plant.name = "plant\(i)"
            if self.size.width > 0 {
                plant.x = CGFloat.random(in: 0..<size.width)
                plant.y = CGFloat.random(in: 0..<size.height)
                plant.size = CGFloat.random(in: 3...8)
            }
            plants.append(plant)
            self.addChild(plant.getShape())
        }
    }
    
    func drawHerbivores() {
        for i in 0..<numOfHerbivores {
            var herbivore = Animal()
            herbivore.name = "herbivore\(i)"            
            if self.size.width > 0 {
                herbivore.x = CGFloat.random(in: 0..<size.width)
                herbivore.y = CGFloat.random(in: 0..<size.height)
            }
            herbivores.append(herbivore)
            self.addChild(herbivore.getShape())
        }
    }

    public func updateAnimalsState() {
        var hungryHerbivorous: [Animal] = []
        for i in 0..<numOfHerbivores {
            let currentHerbivore = herbivores[i]
            currentHerbivore.updateState()
            if currentHerbivore.state == .hungry && !currentHerbivore.isSearchingForFood {
                hungryHerbivorous.append(currentHerbivore)
            }
        }
        
        lookForPlants(for: hungryHerbivorous)
    }
    
    func lookForPlants(for herbivores: [Animal]) {
        for herbivore in herbivores {
            herbivore.isSearchingForFood.toggle() 
            guard let thisNode = self.childNode(withName: herbivore.name) else { return }
            let closestPlant = getClosestNodeIn(distanceOf: 300, on: self, from: CGPoint(x: herbivore.x, y: herbivore.y), withType: .Plant)
            
            if let closestPlant = closestPlant {
                thisNode.run(SKAction.move(to: closestPlant.position, duration: 1)) {
                    herbivore.eat()
                    herbivore.isSearchingForFood.toggle()
                }
                break
            }
            
            moveAnimalRandonly(node: thisNode, animal: herbivore)
        }
    }
    
    func moveAnimalRandonly(node: SKNode, animal: Animal) {
        node.run(SKAction.move(to: CGPoint(x: CGFloat.random(in: 0..<self.size.width), y: CGFloat.random(in: 0..<self.size.height)), duration: 1)) { 
            animal.isSearchingForFood.toggle()
        }
    }
    
    // returns the closest node near the point
    func getClosestNodeIn(distanceOf maxDistance: CGFloat, on container: SKNode, from point: CGPoint, withType type: foodType) -> SKNode? {
        if type == .Plant {
            for plant in self.plants {
                guard let node = self.childNode(withName: plant.name) else { return nil }
                let dxActual = point.x - node.position.x
                let dyActual = point.y - node.position.y
                
                let distanceActual = dxActual * dxActual + dyActual * dyActual
                
                if (distanceActual <= (maxDistance * maxDistance)) {
                    return node
                }
            }
        }
        return nil
    }
}

enum foodType {
    case Plant
    case Animal
}
