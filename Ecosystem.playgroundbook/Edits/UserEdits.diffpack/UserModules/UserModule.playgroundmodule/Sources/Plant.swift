

import SpriteKit

public class Plant {
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var name: String = "plant"
    
    init() {
        x = 0
        y = 0
        size = 10
    }
    
    init(x: CGFloat, y: CGFloat, size: CGFloat) {
        self.x = x
        self.y = y
        self.size = size
    }
    
    func getShape() -> SKShapeNode {
        var shape: SKShapeNode = .init(circleOfRadius: size)
        shape.fillColor = #colorLiteral(red: 0.6933748722, green: 0.8683621287, blue: 0.5471815467, alpha: 1.0)
        shape.lineWidth = 0
        shape.position = CGPoint(x: x, y: y)
        shape.name = name
        return shape
    }
}
