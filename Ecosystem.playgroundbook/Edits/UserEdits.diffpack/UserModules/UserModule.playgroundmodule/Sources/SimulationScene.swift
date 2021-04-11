import SpriteKit
import GameplayKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var numOfPlants: Int = 30
    var numOfHerbivores: Int = 5
    var hasShown: Bool = false
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        collisionBetween(obj1: contact.bodyA.node!, obj2: contact.bodyB.node!)
    }
    
    // Collision
    func collisionBetween(obj1: SKNode, obj2: SKNode) {
        if obj1.name!.commonPrefix(with: obj2.name!).hasPrefix("a") {
            return
        }
        obj2.removeFromParent()
        self.plants = self.plants.filter { $0.name != obj2.name }
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
            var animal = Animal()
            animal.name = "animal\(i)"            
            if self.size.width > 0 {
                animal.x = CGFloat.random(in: 0..<size.width)
                animal.y = CGFloat.random(in: 0..<size.height)
            }
            herbivores.append(animal)
            self.addChild(animal.getShape())
        }
    }

    public func updateAnimalsState() {
        var hungryAnimals: [Animal] = []
        for i in 0..<numOfHerbivores {
            let currentHerbivore = herbivores[i]
            currentHerbivore.updateState()
            if currentHerbivore.state == .hungry && !currentHerbivore.isSearchingForFood {
                hungryAnimals.append(currentHerbivore)
            }
        }
        
        lookForPlants(for: hungryAnimals)
    }
    
    func lookForPlants(for herbivores: [Animal]) {
        for herbivore in herbivores {
            herbivore.isSearchingForFood.toggle() 
            guard let thisNode = self.childNode(withName: herbivore.name) else { return }
            let closestPlant = getClosestNodeIn(distanceOf: 250, on: self, from: CGPoint(x: herbivore.x, y: herbivore.y), withName: "plant")
            
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
    func getClosestNodeIn(distanceOf maxDistance: CGFloat, on container: SKNode, from point: CGPoint, withName prefix: String) -> SKNode? {
        var closestNode: SKNode?
        for node in container.children {
            if node.name!.hasPrefix(prefix) {
                let dxActual = point.x - node.position.x
                let dyActual = point.y - node.position.y
                
                let distanceActual = dxActual * dxActual + dyActual * dyActual
                
                if (distanceActual <= (maxDistance * maxDistance)) {
                    return node
                }
            }
        }
        return closestNode
    }
}
