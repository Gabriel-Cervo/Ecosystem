import SpriteKit
import GameplayKit

public class SimulationScene: SKScene {
    var plants: [Plant] = []
    var herbivores: [Animal] = []
    var numOfPlants: Int = 35
    var numOfHerbivores: Int = 5
    var hasShown: Bool = false
    
    public override func sceneDidLoad() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        for i in 0..<numOfHerbivores {
            let currentHerbivore = herbivores[i]
            currentHerbivore.updateState()
            if currentHerbivore.state == .hungry && !currentHerbivore.isSearchingForFood {
                currentHerbivore.isSearchingForFood = true
                lookForPlants(for: currentHerbivore)
            }
        }
    }
    
    func lookForPlants(for herbivore: Animal) {
        guard let thisNode = self.childNode(withName: herbivore.name) else { return }
        let closestPlant = getClosestNodeIn(distanceOf: 100, on: self, from: CGPoint(x: herbivore.x, y: herbivore.y))
        
        if let closestPlant = closestPlant {
            closestPlant.position.x = CGFloat.random(in: 0..<size.width)
            closestPlant.position.y = CGFloat.random(in: 0..<size.height)
            thisNode.run(SKAction.move(to: closestPlant.position, duration: 1)) {
                herbivore.eat()
                closestPlant.isHidden = true
                self.plants.filter { $0.name != closestPlant.name }
                herbivore.isSearchingForFood = false
            }
        }
    }
    
    // returns the closest node near the point
    func getClosestNodeIn(distanceOf maxDistance: CGFloat, on container: SKNode, from point: CGPoint) -> SKNode? {
        var closestNode: SKNode?
        for node in container.children {
            let dxActual = point.x - node.position.x
            let dyActual = point.y - node.position.y
            
            let distanceActual = dxActual * dxActual + dyActual * dyActual
            
            if (distanceActual <= (maxDistance * maxDistance)) {
                if let cn = closestNode {
                    let dxClosest = point.x - cn.position.x
                    let dyClosest = point.y - cn.position.y
                    let closestNodeDistance = dxClosest * dxClosest + dyClosest * dyClosest
                    
                    if distanceActual > closestNodeDistance {
                        closestNode = node
                    }
                } else {
                    closestNode = node
                }
            }
        }
        return closestNode
    }
}
