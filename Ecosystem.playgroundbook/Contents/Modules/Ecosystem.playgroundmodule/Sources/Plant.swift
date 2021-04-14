import SpriteKit

public class Plant {
    var x: CGFloat
    var y: CGFloat
    var name: String = "plant"
    var size: Int = 10
    var typeNumber: Int = 1
    
    init() {
        x = 0
        y = 0
    }
    
    init(x: CGFloat, y: CGFloat, size: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func getShape() -> SKSpriteNode {
        var shape: SKSpriteNode = .init(imageNamed: "plant\(typeNumber)")
        shape.position = CGPoint(x: x, y: y)
        shape.name = name
        shape.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        shape.physicsBody!.collisionBitMask = 0b0001
        shape.physicsBody!.contactTestBitMask = shape.physicsBody!.collisionBitMask
        return shape
    }
}
