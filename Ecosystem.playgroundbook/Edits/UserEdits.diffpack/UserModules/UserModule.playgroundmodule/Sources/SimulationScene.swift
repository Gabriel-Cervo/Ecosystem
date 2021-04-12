import SpriteKit
import GameplayKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate, AnimalStateDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var carnivores: [Animal] = []
    var initialNumberOfPlants: Int = 20
    var initialNumberOfHerbivores: Int = 10
    var initialNumberOfCarnivores: Int = 2
    
    var hasShown: Bool = false
    
    let maxNumberOfHerbivores: Int = 20
    var maxNumberOfCarnivores: Int = 5
    let maxNumberOfPlants: Int = 40
    
    let energyToReproduce: Double = 25.0
    
    let objectVelocity: Double = 80.0
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    public override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let wait = SKAction.wait(forDuration: 3)
        let update = SKAction.run({ self.drawPlants(2) })
        
        let wait2 = SKAction.wait(forDuration: 2)
        let update2 = SKAction.run({ self.drawHerbivores() })
        
        let wait3 = SKAction.wait(forDuration: 2)
        let update3 = SKAction.run({ self.drawCarnivores() })
        
        let seq = SKAction.sequence([wait, update, wait2, update2, wait3, update3])
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
        
        if let objectToRemove = checkWhatObjectToRemoveBetween(obj1, obj2) {
            objectToRemove.removeFromParent()
            
            let eater = objectToRemove.isEqual(to: obj1) ? obj2 : obj1
            
            var indexInName: Int = 0
            for (index, char) in objectToRemove.name!.enumerated() {
                if char.isNumber {
                    indexInName = index
                    if let indexInList = Int(String(objectToRemove.name!.suffix(indexInName))) {
                        
                        if objectToRemove.name!.hasPrefix("plant") {
                            searchInArrayAndCallEat(for: eater, in: "herbivores")
                            self.plants.remove(at: indexInList)
                            return
                        } 
                        searchInArrayAndCallEat(for: eater, in: "carnivores")
                        self.herbivores.remove(at: indexInList)
                    }
                    break
                }
            }
        }
    }
    
    func searchInArrayAndCallEat(for obj: SKNode, in listName: String) {
        let eaterName = obj.name!
        if listName == "herbivores" {
            for i in 0..<herbivores.count {
                if herbivores[i].name == eaterName {
                    herbivores.remove(at: i)
                }
            }
            return
        }
        
        for i in 0..<carnivores.count {
            if carnivores[i].name == eaterName {
                carnivores.remove(at: i)
            }
        }
        return
    }
    
    func checkWhatObjectToRemoveBetween(_ obj1: SKNode, _ obj2: SKNode) -> SKNode? {
        let names = (obj1.name!, obj2.name!)
        
        if names.0.contains("plant") {
            return names.1.contains("carnivore") ? nil : obj1
        }
        
        if names.0.contains("herbivore") {
            return names.1.contains("carnivore") ? obj1 : obj2
            
        }
        
        if names.0.contains("carnivore") {
            return names.1.contains("herbivore") ? obj2 : nil
        }
        
        return nil
    }
    
    public func draw() {
        drawPlants(initialNumberOfPlants)
        drawHerbivores()
        drawCarnivores()
    }
    
    func drawPlants(_ numOfPlants: Int) {
        if plants.count >= maxNumberOfPlants {
            return
        }
        
        let isPlantsListEmpty: Bool = plants.count == 0
        
        for i in 0..<numOfPlants {
            var plant = Plant()
            let indexName = isPlantsListEmpty ? i : plants.count + i + 1
            plant.name = "plant\(indexName)"
            plant.x = CGFloat.random(in: 0..<size.width)
            plant.y = CGFloat.random(in: 0..<size.height)
            plant.size = CGFloat.random(in: 3...8)
            plants.append(plant)
            self.addChild(plant.getShape())
        }
    }
    
    func drawHerbivores() {
        if herbivores.count >= maxNumberOfHerbivores {
            return
        }
        
        let isHerbivorousListEmpty: Bool = herbivores.count == 0
        
        let animalsToDraw = isHerbivorousListEmpty ? initialNumberOfHerbivores : self.herbivores.filter({ $0.energy >= energyToReproduce }).count % 2
        
        for i in 0..<animalsToDraw {
            var herbivore = Animal()
            let indexName = isHerbivorousListEmpty ? i : herbivores.count + i + 1
            herbivore.name = "herbivore\(i)"   
            herbivore.delegate = self
            herbivore.type = .Herbivore
            herbivore.x = CGFloat.random(in: 0..<size.width)
            herbivore.y = CGFloat.random(in: 0..<size.height)
            herbivores.append(herbivore)
            self.addChild(herbivore.getShape())
            }
        }
    
    func drawCarnivores() {
        if carnivores.count >= maxNumberOfCarnivores {
            return
        }
        
        let isCarnivoresListEmpty: Bool = carnivores.count == 0
        
        let animalsToDraw = isCarnivoresListEmpty ? initialNumberOfCarnivores : self.carnivores.filter({ $0.energy >= energyToReproduce }).count % 2
        
        for i in 0..<animalsToDraw {
            var carnivore = Animal()
            let indexName = isCarnivoresListEmpty ? i : carnivores.count + i + 1
            carnivore.name = "carnivore\(i)"   
            carnivore.delegate = self
            carnivore.type = .Carnivore
            carnivore.x = CGFloat.random(in: 0..<size.width)
            carnivore.y = CGFloat.random(in: 0..<size.height)
            carnivores.append(carnivore)
            self.addChild(carnivore.getShape())
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if !hasShown {
            draw()
            hasShown = true
            return
        }
        
        updateAnimalsState()
    }
    
    func updateAnimalsState() {
        for herbivore in herbivores {
            herbivore.updateState()
        }
        
        for carnivore in carnivores {
            carnivore.updateState()
        }
    }
    
    func searchForFood(for animal: Animal) {
        animal.isSearchingForFood.toggle() 
        let typeOfFood: foodType = animal.type == .Herbivore ? .Plant : .Animal
        guard let thisNode = self.childNode(withName: animal.name) else { return }
        let closestNode = getClosestNodeWith(distanceOf: 200, from: CGPoint(x: animal.x, y: animal.y), withType: typeOfFood)
            
        if let closestNode = closestNode {
            let distance = distanceBetweenPoints(first: thisNode.position, second: closestNode.position)
            thisNode.run(SKAction.move(to: closestNode.position, duration: (Double(distance) / objectVelocity))) {
                animal.isSearchingForFood.toggle()
            }
            return
        }
        moveAnimalRandonly(node: thisNode, animal: animal)
    }
    
    func moveAnimalRandonly(node: SKNode, animal: Animal) {
        node.removeAllActions()
        
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
            return nil
        }
        
        if herbivores.count <= 0 {
            return nil
        }
        for animal in herbivores {
            if let node = self.childNode(withName: animal.name) {
                let distance = distanceBetweenPoints(first: node.position, second: point)
                
                if (distance <= maxDistance) {
                    return node
                }
            }
        }
        
        return nil
    }
    
    func distanceBetweenPoints(first: CGPoint, second: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)))
    }
    
    func dieOfHungry(animal: Animal) {
        if let node = self.childNode(withName: animal.name) {
            node.removeAllActions()
            node.alpha = 0.4
        }
    }
}

enum foodType {
    case Plant
    case Animal
}
