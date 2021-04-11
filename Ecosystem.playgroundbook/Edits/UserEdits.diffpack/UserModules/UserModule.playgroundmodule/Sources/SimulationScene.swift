import SpriteKit
import GameplayKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate, AnimalStateDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var numOfPlants: Int = 20
    var numOfHerbivores: Int = 5
    var hasShown: Bool = false
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let wait = SKAction.wait(forDuration: 3)
        let update = SKAction.run({ self.drawMorePlants(1) })
        
        let wait2 = SKAction.wait(forDuration: 2)
        let update2 = SKAction.run({ self.drawMoreAnimals(1) })
        
        let seq = SKAction.sequence([wait, update, wait2, update2])
        let repeatAction = SKAction.repeatForever(seq)
        self.run(repeatAction)
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let obj1 = contact.bodyA.node else { return }
        guard let obj2 = contact.bodyB.node else { return }
        
        collisionBetween(obj1: obj1, obj2: obj2)
    }

    func collisionBetween(obj1: SKNode, obj2: SKNode) {
        let areTwoHerbivorous = obj1.name!.commonPrefix(with: obj2.name!).hasPrefix("herbivore")
        if areTwoHerbivorous {
            return
        }
        
        obj2.removeFromParent()
        
        let objectToRemove = checkWhatObjectToRemoveBetween(obj1, obj2)
        
        if objectToRemove.name!.hasPrefix("plant") {
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
        if names.0.hasPrefix("herbivore") && names.1.hasPrefix("plant") {
            return obj2
        }
        
        return obj1
    }
    

    public func draw() {
        drawPlants()
        drawHerbivores()
    }
    
    func drawPlants() {
        for i in 0..<numOfPlants {
            var plant = Plant()
            if self.size.width > 0 {
                plant.name = "plant\(i)"
                plant.x = CGFloat.random(in: 0..<size.width)
                plant.y = CGFloat.random(in: 0..<size.height)
                plant.size = CGFloat.random(in: 3...8)
                plants.append(plant)
                self.addChild(plant.getShape())
            }
        }
    }
    
    func drawMorePlants(_ plantsToDraw: Int) {
        var indexInName = 0
        for (index, char) in plants.last!.name.enumerated() {
            if char.isNumber {
                indexInName = index
                var lastIndex = Int(String(plants.last!.name.suffix(indexInName))) ?? 0
                    for i in 0..<plantsToDraw {
                        var plant = Plant()
                        if self.size.width > 0 {
                            plant.name = "plant\(lastIndex)"
                            plant.x = CGFloat.random(in: 0..<size.width)
                            plant.y = CGFloat.random(in: 0..<size.height)
                            plant.size = CGFloat.random(in: 3...8)
                            self.plants.append(plant)
                            self.addChild(plant.getShape())
                            numOfPlants += 1
                            lastIndex += 1
                        }
                    }
                break
            }
        }
    }
    
    func drawMoreAnimals(_ animalsToDraw: Int) {
        var indexInName = 0
        for (index, char) in herbivores.last!.name.enumerated() {
            if char.isNumber {
                indexInName = index
                var lastIndex = Int(String(herbivores.last!.name.suffix(indexInName))) ?? 0
                for i in 0..<animalsToDraw {
                    var herbivore = Animal()
                    if self.size.width > 0 {
                        herbivore.name = "herbivore\(lastIndex + 1)" 
                        herbivore.delegate = self
                        herbivore.x = CGFloat.random(in: 0..<size.width)
                        herbivore.y = CGFloat.random(in: 0..<size.height)
                        self.herbivores.append(herbivore)
                        self.addChild(herbivore.getShape())
                        numOfHerbivores += 1
                        lastIndex += 1
                    }
                }
                break
            }
        }
    }
    
    func drawHerbivores() {
        for i in 0..<numOfHerbivores {
            var herbivore = Animal()
            if self.size.width > 0 {
                herbivore.name = "herbivore\(i)"   
                herbivore.delegate = self
                herbivore.x = CGFloat.random(in: 0..<size.width)
                herbivore.y = CGFloat.random(in: 0..<size.height)
                herbivores.append(herbivore)
                self.addChild(herbivore.getShape())
            }
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if !hasShown {
            draw()
            hasShown = true
            return
        }
        for herbivore in herbivores {
            herbivore.updateState()
        }
        
        
    }
    
    func searchForFood(for animal: Animal) {
        animal.isSearchingForFood.toggle() 
        guard let thisNode = self.childNode(withName: animal.name) else { return }
        let closestPlant = getClosestNodeIn(distanceOf: 100, from: CGPoint(x: animal.x, y: animal.y), withType: .Plant)
            
        if let closestPlant = closestPlant {
            thisNode.run(SKAction.move(to: closestPlant.position, duration: 3)) {
                if self.plants.contains(where: { $0.name == closestPlant.name }) {
                    animal.eat()
                }
                animal.isSearchingForFood.toggle()
            }
            return
        }
        moveAnimalRandonly(node: thisNode, animal: animal)
    }
    
    func moveAnimalRandonly(node: SKNode, animal: Animal) {
        node.run(SKAction.move(to: CGPoint(x: CGFloat.random(in: 0..<self.size.width), y: CGFloat.random(in: 0..<self.size.height)), duration: 3)) { 
            animal.isSearchingForFood.toggle()
        }
    }
    
    // returns the closest node near the point
    func getClosestNodeIn(distanceOf maxDistance: CGFloat, from point: CGPoint, withType type: foodType) -> SKNode? {
        if type == .Plant {
            for plant in plants {
                if let node = self.childNode(withName: plant.name) {
                    let dxActual = node.position.x - point.x
                    let dyActual = node.position.y - point.y
                    
                    let distanceActual = dxActual * dxActual + dyActual * dyActual
                    
                    if (distanceActual <= (maxDistance * maxDistance)) {
                        return node
                    }
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
