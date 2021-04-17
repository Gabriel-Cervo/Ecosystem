import SpriteKit

public class SimulationScene: SKScene, SKPhysicsContactDelegate, AnimalStateDelegate {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var carnivores: [Animal] = []
    var initialNumberOfPlants: Int = 0
    var initialNumberOfHerbivores: Int = 0
    var initialNumberOfCarnivores: Int = 0
    
    var typeOfPlant: Int = 1
    var typeOfHerbivore: Int = 1
    var typeOfCarnivore: Int = 1
    
    var hasShown: Bool = false
    var runSimulation: Bool = false
    var hasStarted: Bool = false
    
    let maxNumberOfHerbivores: Int = 100
    var maxNumberOfCarnivores: Int = 100
    let maxNumberOfPlants: Int = 250
    
    let energyToReproduce: Double = 25.0
    
    let objectVelocity: Double = 85.0
        
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 0.5225631594657898, green: 0.7202061414718628, blue: 0.4632362723350525, alpha: 1.0)
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

    func collisionBetween(obj1: SKNode, obj2: SKNode) {
        let areTwoHerbivorous = obj1.name!.commonPrefix(with: obj2.name!).hasPrefix("herbivore")
        if areTwoHerbivorous {
            return
        }
        
        if let objectToRemove = checkWhatObjectToRemoveBetween(obj1, obj2) {
            objectToRemove.removeFromParent()
            
            let eater = objectToRemove.isEqual(to: obj1) ? obj2 : obj1
            
            if objectToRemove.name!.contains("plant") {
                if let firstPlantWithIndexOf = plants.firstIndex(where: { $0.name == objectToRemove.name! }) {
                    let hasEaten = searchInArrayAndCallEat(for: eater, in: "herbivores")
                    
                    if hasEaten {
                        self.plants.remove(at: firstPlantWithIndexOf)
                    }
                }
            } else {
                if let firstHerbivoreWithIndex = herbivores.firstIndex(where: { $0.name == objectToRemove.name! }) {
                    let hasEaten = searchInArrayAndCallEat(for: eater, in: "carnivores")
                    
                    if hasEaten {
                        self.herbivores.remove(at: firstHerbivoreWithIndex)
                    }
                }
            }
        }
    }
    
    func searchInArrayAndCallEat(for obj: SKNode, in listName: String) -> Bool {
        let eaterName = obj.name!
        if listName == "herbivores" {
            for herbivore in herbivores {
                if herbivore.name == eaterName {
                    herbivore.eat()
                    return true
                }
            }
            return false
        }
        
        for carnivore in carnivores {
            if carnivore.name == eaterName {
                if carnivore.isAlive {
                    carnivore.eat()
                    return true
                }
                return false
            }
        }
        
        return false
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
        start()
    }
    
    public func start() {
        self.removeAllChildren()
        hasStarted = false
        clearLists()
        drawPlants(initialNumberOfPlants)
        drawHerbivores()
        drawCarnivores()
        runSpawns()
        hasStarted = true
    }
    
    func clearLists() {
        plants.removeAll()
        herbivores.removeAll()
        carnivores.removeAll()
    }
    
    func drawPlants(_ numOfPlants: Int) {
        if plants.count >= maxNumberOfPlants {
            return
        }
        
        if herbivores.count == 0 && hasStarted {
            return
        }
        
        if initialNumberOfPlants > maxNumberOfPlants {
            initialNumberOfPlants = maxNumberOfPlants
        }
        
        let numberOfPlantsActual = plants.count
        
        for i in 0..<numOfPlants {
            if plants.count >= maxNumberOfPlants {
                return
            }
            var plant = Plant()
            let indexName = numberOfPlantsActual == 0 ? i : plants.count + i + 1
            plant.name = "plant\(indexName)"
            plant.typeNumber = typeOfPlant
            plant.x = CGFloat.random(in: 0..<size.width)
            plant.y = CGFloat.random(in: 0..<size.height)
            plants.append(plant)
            self.addChild(plant.getShape())
        }
    }
    
    func drawHerbivores() {
        if herbivores.count >= maxNumberOfHerbivores {
            return
        }
        
        if initialNumberOfHerbivores > maxNumberOfHerbivores {
            initialNumberOfHerbivores = maxNumberOfHerbivores
        }
                
        var animalsToDraw = hasStarted ? self.herbivores.filter({ $0.energy >= energyToReproduce }).count % 2 : initialNumberOfHerbivores
                
        let quantityOfHerbivores = herbivores.count
        
        let totalAfterDraw = animalsToDraw + quantityOfHerbivores

        if  totalAfterDraw > maxNumberOfHerbivores {
            animalsToDraw = totalAfterDraw - maxNumberOfHerbivores
        }
        
        for i in 0..<animalsToDraw {
            if herbivores.count >= maxNumberOfHerbivores {
                return
            }
            var herbivore = Animal()
            let indexName = quantityOfHerbivores == 0 ? i : herbivores.count + i + 1
            herbivore.name = "herbivore\(indexName)"   
            herbivore.delegate = self
            herbivore.type = .Herbivore
            herbivore.typeNumber = typeOfHerbivore
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
        
        if initialNumberOfCarnivores > maxNumberOfCarnivores {
            initialNumberOfCarnivores = maxNumberOfCarnivores
        }
                
        var animalsToDraw = hasStarted ? self.carnivores.filter({ $0.energy >= energyToReproduce }).count % 2 : initialNumberOfCarnivores
        
        let quantityOfCarnivores = carnivores.count
        
        let totalAfterDraw = animalsToDraw + quantityOfCarnivores

        if  totalAfterDraw > maxNumberOfCarnivores {
            animalsToDraw = totalAfterDraw - maxNumberOfCarnivores
        }
        
        for i in 0..<animalsToDraw {
            if carnivores.count >= maxNumberOfCarnivores {
                return
            }
            var carnivore = Animal()
            let indexName = quantityOfCarnivores == 0 ? i : carnivores.count + i + 1
            carnivore.name = "carnivore\(indexName)"   
            carnivore.delegate = self
            carnivore.type = .Carnivore
            carnivore.typeNumber = typeOfCarnivore
            carnivore.x = CGFloat.random(in: 0..<size.width)
            carnivore.y = CGFloat.random(in: 0..<size.height)
            carnivores.append(carnivore)
            self.addChild(carnivore.getShape())
        }
    }
    
    func runSpawns() {
        if runSimulation {
            let wait = SKAction.wait(forDuration: 1)
            let update = SKAction.run({ self.drawPlants(2) })
            let group1 = SKAction.sequence([wait, update])
            
            let wait2 = SKAction.wait(forDuration: 4)
            let update2 = SKAction.run({ self.drawHerbivores() })
            let group2 = SKAction.sequence([wait2, update2])
            
            let wait3 = SKAction.wait(forDuration: 4)
            let update3 = SKAction.run({ self.drawCarnivores() })
            let group3 = SKAction.sequence([wait3, update3])
            
            let group = SKAction.group([group1, group2, group3])
            let repeatedForever = SKAction.repeatForever(group)
            self.run(repeatedForever)
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if !hasShown {
            draw()
            hasShown = true
            return
        }
        
        if runSimulation {
            updateAnimalsState()
        }
    }
    
    func updateAnimalsState() {
        for herbivore in herbivores {
            if herbivore.isAlive {
                herbivore.updateState()
            }
        }
        
        for carnivore in carnivores {
            if carnivore.isAlive {
                carnivore.updateState()
            }
        }
    }
    
    func searchForFood(for animal: Animal) {
        animal.isSearchingForFood.toggle() 
        let typeOfFood: foodType = animal.type == .Herbivore ? .Plant : .Animal
        guard let thisNode = self.childNode(withName: animal.name) else { return }
        let closestNode = getClosestNodeWith(distanceOf: 200, from: CGPoint(x: animal.x, y: animal.y), withType: typeOfFood)
            
        if let closestNode = closestNode {
            let distance = distanceBetweenPoints(first: thisNode.position, second: closestNode.position)
            let goToTarget = SKAction.move(to: closestNode.position, duration: (Double(distance) / objectVelocity))
            
            let spriteNames = animal.type == .Carnivore ? ("carnivore\(typeOfCarnivore)", "carnivore\(typeOfCarnivore)_eating") : ("herbivore\(typeOfHerbivore)", "herbivore\(typeOfHerbivore)_eating")
            
            let animate = SKAction.animate(with: [  SKTexture.init(imageNamed: spriteNames.1)], timePerFrame: 1) 
            
            let group = SKAction.group([animate, goToTarget])
            thisNode.run(group) {
                animal.isSearchingForFood.toggle()
                
                thisNode.run(SKAction.animate(with: [SKTexture.init(imageNamed: spriteNames.0)], timePerFrame: 1))
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
            if animal.isAlive {
                animal.isAlive = false
            }
        }
    }
}

enum foodType {
    case Plant
    case Animal
}
