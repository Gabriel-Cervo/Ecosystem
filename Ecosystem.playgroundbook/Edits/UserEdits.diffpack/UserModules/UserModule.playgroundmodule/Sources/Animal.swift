
import SpriteKit

public class Animal {
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var name: String = "herbivore"
    var isSearchingForFood: Bool = false
    var energy: Int = 50
    
    var state: AnimalState = .hungry
    
    init() {
        x = 0
        y = 0
        size = 20
    }
    
    init(x: CGFloat, y: CGFloat, size: CGFloat) {
        self.x = x
        self.y = y
        self.size = size
    }
    
    func getShape() -> SKShapeNode {
        var shape: SKShapeNode = .init(rectOf: CGSize(width: size, height: size))
        shape.fillColor = #colorLiteral(red: 0.3248277307, green: 0.8369095325, blue: 0.9915711284, alpha: 1.0)
        shape.lineWidth = 0
        shape.position = CGPoint(x: x, y: y)
        shape.name = name
        return shape
    }
    
    func eat() {
        energy += 15
    }
    
    func updateState() {
        energy -= 50
        if energy < 50 && state == .tired {
            state = .hungry
        } else if energy >= 50 && state == .hungry {
            state = .tired
        }
    }
}

public enum AnimalState {
    case hungry
    case tired
}
