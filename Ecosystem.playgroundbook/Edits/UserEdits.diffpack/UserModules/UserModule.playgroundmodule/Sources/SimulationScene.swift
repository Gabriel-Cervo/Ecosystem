import SpriteKit
import GameplayKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate, AnimalStateDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var initialNumberOfPlants: Int = 20
    var initialNumberOfHerbivores: Int = 50
    var hasShown: Bool = false
    
    let maxNumberOfHerbivores = 20
    let maxNumberOfPlants: Int = 40
    
    let objectVelocity: Double = 55.0 
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let wait = SKAction.wait(forDuration: 3)
        let update = SKAction.run({ self.drawMorePlants(1) })
        
        let wait2 = SKAction.wait(forDuration: 2)
        let update2 = SKAction.run({ self.drawMoreAnimals(2) })
        
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
        for i in 0..<initialNumberOfPlants {
            if self.size.width > 0 {
                var plant = Plant()
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
        if plants.count >= maxNumberOfPlants {
            return
        }
        for i in 0..<plantsToDraw {
            if self.size.width > 0 {
                var plant = Plant()
                plant.name = "plant\(i + plants.count)"
                plant.x = CGFloat.random(in: 0..<size.width)
                plant.y = CGFloat.random(in: 0..<size.height)
                plant.size = CGFloat.random(in: 3...8)
                self.plants.append(plant)
                self.addChild(plant.getShape())
            }
        }
    }
    
    func drawHerbivores() {
        for i in 0..<initialNumberOfHerbivores {
            var herbivore = Animal()
            herbivore.name = "herbivore\(i)"   
            herbivore.delegate = self
            herbivore.x = CGFloat.random(in: 0..<size.width)
            herbivore.y = CGFloat.random(in: 0..<size.height)
            herbivores.append(herbivore)
            self.addChild(herbivore.getShape())
            }
        }
    
    func drawMoreAnimals(_ animalsToDraw: Int) {
        if herbivores.count >= maxNumberOfHerbivores {
            return
        }
        for i in 0..<animalsToDraw {
            var herbivore = Animal()
            herbivore.name = "herbivore\((i + herbivores.count))" 
            herbivore.delegate = self
            herbivore.x = CGFloat.random(in: 0..<size.width)
            herbivore.y = CGFloat.random(in: 0..<size.height)
            self.herbivores.append(herbivore)
            self.addChild(herbivore.getShape())
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
        let closestPlant = getClosestNodeWith(distanceOf: 200, from: CGPoint(x: animal.x, y: animal.y), withType: .Plant)
            
        if let closestPlant = closestPlant {
            let distance = distanceBetweenPoints(first: thisNode.position, second: closestPlant.position)
            thisNode.run(SKAction.move(to: closestPlant.position, duration: (Double(distance) / objectVelocity))) {
                if let stillExists = self.childNode(withName: closestPlant.name!) {
                    animal.eat()
                }
                animal.isSearchingForFood.toggle()
            }
            return
        }
        moveAnimalRandonly(node: thisNode, animal: animal)
    }
    
    func moveAnimalRandonly(node: SKNode, animal: Animal) {
        let randomPoint = CGPoint(x: CGFloat.random(in: 0..<self.size.width), y: CGFloat.random(in: 0..<self.size.height))
        
        let distance = distanceBetweenPoints(first: node.position, second: randomPoint)
        
        node.run(SKAction.move(to: randomPoint, duration: (Double(distance) / objectVelocity))) { 
            animal.isSearchingForFood.toggle()
        }
    }
    
    func getClosestNodeWith(distanceOf maxDistance: CGFloat, from point: CGPoint, withType type: foodType) -> SKNode? {
        if type == .Plant {
            if plants.count <= 0 {
                return nil
            }
            for plant in plants {
                if let node = self.childNode(withName: plant.name) {
                    let distance = distanceBetweenPoints(first: node.position, second: point)
                    
                    if (distance <= maxDistance) {
                        return node
                    }
                }
            }
        }
        return nil
    }
    
    func distanceBetweenPoints(first: CGPoint, second: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)))
    }
}

enum foodType {
    case Plant
    case Animal
}
