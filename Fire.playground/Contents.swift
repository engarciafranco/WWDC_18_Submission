//: A SpriteKit based Playground
import UIKit
import PlaygroundSupport
import SpriteKit
import CoreMotion

/*------------ Variables: --------------*/
var firstTorchPosition: [CGPoint] =
    [
        //Right-side
        CGPoint(x: 500, y: 0),
        CGPoint(x: 500, y: 750),
        CGPoint(x: 500, y: -750),
        
        //Left-side
        CGPoint(x: -500, y: 0),
        CGPoint(x: -500, y: 750),
        CGPoint(x: -500, y: -750),
]

/*------------ FUNCTIONS: --------------*/
func brightenTorches(numbered: [Int], emitters: [SKEmitterNode], light: [SKLightNode]) {
    for postion in numbered  {
       
        emitters[postion].particleAlpha = 1
        emitters[postion].particleAlphaRange = 1.5
        emitters[postion].particleScale = 0.5
        emitters[postion].particleScaleRange = 3.5
        emitters[postion].particleScaleSpeed = -0.5
        light[postion].isEnabled = true
        light[postion].falloff = 1
        
    }
}

func dimTorches(numbered: [Int], emitters: [SKEmitterNode], light: [SKLightNode]) {
    for postion in numbered  {
        
        emitters[postion].particleAlpha = 0
        emitters[postion].particleAlphaRange = 1.5
        emitters[postion].particleScale = 0.2
        emitters[postion].particleScaleRange = 2.5
        emitters[postion].particleScaleSpeed = -1.5
        
        light[postion].falloff = 25
    }
}


func putOutTorches(numbered: [Int], emitters: [SKEmitterNode], light: [SKLightNode]) {
    for postion in numbered  {
        
        emitters[postion].particleAlpha = 0
        emitters[postion].particleAlphaRange = 0.5
        emitters[postion].particleScale = 0
        emitters[postion].particleScaleRange = 1.5
        emitters[postion].particleScaleSpeed = -3.5
        light[postion].isEnabled = false
       
    }
}

/*--------------------------------------*/



//Create Subclass of SKScene
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Shapes
    let hiddenCircle = SKShapeNode(circleOfRadius: 85) //change this to an SKNode once finished testing.
    
    //Light Source
    let lightSource = SKLightNode()
    
    //Functions
    public var torchArray: [SKShapeNode] = []
    public var fireArray: [SKEmitterNode?] = []
    public var lightSourceArray: [SKLightNode] = []
    
    public func createTorchesAtPos(posArray: [CGPoint]) {
        
        var i = 0 // counter
        
        for points in posArray{
            torchArray.append(SKShapeNode(circleOfRadius: 40)) // Creates a circle
            fireArray.append(SKEmitterNode(fileNamed: "fire.sks")) // creates fire particle emitter
            lightSourceArray.append(SKLightNode())
            torchArray[i].position = posArray[i] // Places my tourch in the CGPoint specified by my array of points
            torchArray[i].fillColor = .black // Changes the color of my circle
            torchArray[i].strokeColor = .black //changes the outline color of my circle
            torchArray[i].name = "torch\(i)" // gives my tourch a name
            
            
            //light source
            lightSourceArray[i].categoryBitMask = 1
            lightSourceArray[i].falloff = 1
            lightSourceArray[i].ambientColor = UIColor.blue
            lightSourceArray[i].lightColor = UIColor.red
            lightSourceArray[i].shadowColor = UIColor.black
           
           
            torchArray[i].addChild(lightSourceArray[i])
            torchArray[i].addChild(fireArray[i]!) // attaches the emitter to my circles
            addChild(torchArray[i]) // attaches the torch into my scene
            
            i += 1 // counter++
//            print(points)
//            print(torchArray)
        }
        
        
    }
    
    
    override func didMove(to view: SKView) {
        //Put your scene in here and anything that you'd like the scene to start with:
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5) //Center the anchor point.
        physicsWorld.contactDelegate = self
        
        
        createTorchesAtPos(posArray: firstTorchPosition)
        
        //
        let background = SKSpriteNode(imageNamed: "dungeon-floor", normalMapped: true)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        
        background.lightingBitMask = 1
        background.shadowCastBitMask = 0
        background.shadowedBitMask = 1
        
        
        
        addChild(background)
        
        //Light Source
        lightSource.categoryBitMask = 1
        lightSource.falloff = 90
        lightSource.ambientColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.87)
        lightSource.lightColor = SKColor(red: 0.8, green: 0.8, blue: 0.4, alpha: 0.8)
        lightSource.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        lightSource.position = CGPoint(x: 0, y: 0)
        addChild(lightSource)
        
        
        //Hidden Circle
        hiddenCircle.position = CGPoint(x: 0, y: 0)
        hiddenCircle.alpha = 0
        hiddenCircle.physicsBody = SKPhysicsBody(circleOfRadius: 85)
        hiddenCircle.physicsBody?.categoryBitMask = 0
        hiddenCircle.physicsBody?.collisionBitMask = 1
        hiddenCircle.physicsBody?.contactTestBitMask = 0x1 << 1
        
        
        /*-------- ADD CHILDEREN HERE: ----------*/
        
        addChild(hiddenCircle)
        
        /*--------------------------------------*/
    }
    
    // Update FUnction  // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
//        getDistanceOfTwoNodes(staticNodes: torchArray, movingNode: hiddenCircle, emitters: fireArray as! [SKEmitterNode]) //use the distance formula for intensity.
        
    }
    
    //Handle Trigger Zones Here:
    func didBegin(_ contact: SKPhysicsContact) {
    //Reset: Zone 0
        if contact.bodyA.node?.name == "zoneZero" {
           brightenTorches(numbered: [0, 1, 2, 3, 4, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        }
        
    //Edges
        if contact.bodyA.node?.name == "zoneOne" {
            putOutTorches(numbered: [1, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneTwo" {
            putOutTorches(numbered: [2, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneThree" {
            putOutTorches(numbered: [3, 4, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneFour" {
            putOutTorches(numbered: [0, 1, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        }
    
    //Corners
        if contact.bodyA.node?.name == "zoneFive" {
            putOutTorches(numbered: [1], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            dimTorches(numbered: [0, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        } else if contact.bodyA.node?.name == "zoneSix" {
            putOutTorches(numbered: [2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            dimTorches(numbered: [0, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        } else if contact.bodyA.node?.name == "zoneSeven" {
            putOutTorches(numbered: [5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            dimTorches(numbered: [2, 3], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        } else if contact.bodyA.node?.name == "zoneEight" {
            putOutTorches(numbered: [4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            dimTorches(numbered: [1, 3], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        }
        
    //Mid Zones
        if contact.bodyA.node?.name == "midZoneUpper" {
            dimTorches(numbered: [1, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneLower" {
            dimTorches(numbered: [5, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneLeft" {
            dimTorches(numbered: [3, 4, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneRight" {
            dimTorches(numbered: [0, 1, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        }
        
        
    }
    
    /*--------------------------------------------------------------*/
    
    func didEnd(_ contact: SKPhysicsContact) {
        
       //Edges
        if contact.bodyA.node?.name == "zoneOne" {
            dimTorches(numbered: [1, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneTwo" {
            dimTorches(numbered: [2, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneThree" {
            dimTorches(numbered: [3, 4, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneFour" {
           dimTorches(numbered: [0, 1, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        }
        
        //Corners
        if contact.bodyA.node?.name == "zoneFive" {
            dimTorches(numbered: [1], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            brightenTorches(numbered: [0, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "zoneSix" {
            dimTorches(numbered: [2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            brightenTorches(numbered: [0, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
           
        } else if contact.bodyA.node?.name == "zoneSeven" {
            dimTorches(numbered: [5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            brightenTorches(numbered: [2, 3], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        } else if contact.bodyA.node?.name == "zoneEight" {
            dimTorches(numbered: [4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            brightenTorches(numbered: [1, 3], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
            
        }
        
        //Mid Zones
        if contact.bodyA.node?.name == "midZoneUpper" {
            brightenTorches(numbered: [1, 4], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneLower" {
            brightenTorches(numbered: [5, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneLeft" {
            brightenTorches(numbered: [3, 4, 5], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        } else if contact.bodyA.node?.name == "midZoneRight" {
            brightenTorches(numbered: [0, 1, 2], emitters: fireArray as! [SKEmitterNode], light: lightSourceArray)
        }
        
    }
    
}



public class GameViewController: UIViewController {
     var scene: GameScene?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //set up the view? /how it will be displayed/
//        scene = GameScene(size: CGSize(width:1536 , height: 2048))
        scene = GameScene(fileNamed: "GameScene")
        let skView = SKView(frame: self.view.frame)
        self.view = skView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
}




/*----------------This renders everything into the screen--------------------*/

// Use these two lines of code to render the scene.
let gameScene = GameViewController()  //creates a new intance of the view Controller
PlaygroundPage.current.liveView = gameScene //renders the scene.

/*----------------------------------------------------------------------------*/




//CoreMotion, getting to read the gyroscope data.
let cmManager = CMMotionManager();
cmManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue()) { (data, error) in
    
    // This makes sure that there is data inside of data.
    // guard, makes sure that the statement is true before executing the rest of the code, else takes the else.
    guard let data = data
        else {
            return
    }
    
    let xPos = data.gravity.x
    let yPos = data.gravity.y
    print(xPos, yPos)
    //The cordinate data needs to be multiplied by screen's aspect ration in order to get high enough numbers to move the circle.
    gameScene.scene?.hiddenCircle.position = CGPoint(x: xPos*1536/2.5, y: yPos*2048/2.5)
    
}





