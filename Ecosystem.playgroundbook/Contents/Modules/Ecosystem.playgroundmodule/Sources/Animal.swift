import SpriteKit

public class Animal {
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var name: String = "animal"
    var isSearchingForFood: Bool = false
    var type: AnimalType
    var typeNumber: Int = 1
    var energy: Double = Double.random(in: 45.0..<70.0)
    var isAlive: Bool = true
    
    var state: AnimalState = .tired
    var delegate: AnimalStateDelegate?
    
    init() {
        x = 0
        y = 0
        size = 20
        type = .Herbivore
    }
    
    init(x: CGFloat, y: CGFloat, size: CGFloat, type: AnimalType) {
        self.x = x
        self.y = y
        self.size = size
        self.type = type
    }
    
    func getShape() -> SKSpriteNode {
        var shape: SKSpriteNode = self.type == .Carnivore ? .init(imageNamed: "carnivore\(typeNumber)") : .init(imageNamed: "herbivore\(typeNumber)")
        shape.size = CGSize(width: 64, height: 64)
        shape.position = CGPoint(x: x, y: y)
        shape.name = name
        shape.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        shape.physicsBody!.collisionBitMask = 0b0001
        shape.physicsBody!.contactTestBitMask = shape.physicsBody!.collisionBitMask
        return shape
    }
    
    func eat() {
        energy += self.type == .Carnivore ? Double.random(in: 50.0..<80.0) : Double.random(in: 20.0..<40.0)
    }
    
    func updateState() {
        if isAlive {
            energy -= 0.03
            if energy <= 0.0 {
                isAlive = false
                self.delegate?.dieOfHungry(animal: self)
            } else if energy <= 60.0 {
                state = .hungry
                if !isSearchingForFood {
                    self.delegate?.searchForFood(for: self)
                }
            } else {
                state = .tired
            }
        }
    }
}

public enum AnimalState {
    case hungry
    case tired
}

public enum AnimalType {
    case Carnivore
    case Herbivore
}

protocol AnimalStateDelegate {
    func searchForFood(for animal: Animal)
    func dieOfHungry(animal: Animal)
}
