/**
 
 Copyright 2017 IBM Corp. All Rights Reserved.
 Licensed under the Apache License, Version 2.0 (the 'License'); you may not
 use this file except in compliance with the License. You may obtain a copy of
 the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations under
 the License.
 */
 
import Foundation
import ARKit
import SwiftyJSON

public extension SCNNode {
    convenience init(withJSON profile : JSON, position: SCNVector3) {
        let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // Full Name text
        let fullName = profile["fullname"].stringValue
        let fullNameBubble = SCNText(string: fullName, extrusionDepth: CGFloat(bubbleDepth))
        fullNameBubble.font = UIFont(name: "Futura", size: 0.10)?.withTraits(traits: .traitBold)
        fullNameBubble.alignmentMode = kCAAlignmentCenter
        fullNameBubble.firstMaterial?.diffuse.contents = UIColor.orange
        fullNameBubble.firstMaterial?.specular.contents = UIColor.white
        fullNameBubble.firstMaterial?.isDoubleSided = true
        fullNameBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        let (minBound, maxBound) = fullNameBubble.boundingBox
        let fullNameNode = SCNNode(geometry: fullNameBubble)
        // Centre Node - to Centre-Bottom point
        fullNameNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        fullNameNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        fullNameNode.simdPosition = simd_float3.init(x: 0.06, y: 0.09, z: 0)
        
        //        Linked in icon
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.init(named: "linkedin.png")
        material.isDoubleSided = false
        let linkedinBox = SCNBox.init(width: 0.1, height: 0.1, length: 0.01, chamferRadius: 0)
        let linkedinBoxNode = SCNNode(geometry: linkedinBox)
        linkedinBox.firstMaterial = material
        linkedinBoxNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        linkedinBoxNode.simdPosition = simd_float3.init(x: 0.02, y: 0.085, z: 0)
        
        // linkedin text
        let linkedIn = profile["linkedin"].stringValue
        let linkedInBubble = SCNText(string: linkedIn, extrusionDepth: CGFloat(bubbleDepth))
        linkedInBubble.font = UIFont(name: "Futura", size: 0.10)?.withTraits(traits: .traitBold)
        linkedInBubble.alignmentMode = kCAAlignmentCenter
        linkedInBubble.firstMaterial?.diffuse.contents = UIColor.orange
        linkedInBubble.firstMaterial?.specular.contents = UIColor.white
        linkedInBubble.firstMaterial?.isDoubleSided = true
        linkedInBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let linkedInNode = SCNNode(geometry: linkedInBubble)
        // Centre Node - to Centre-Bottom point
        linkedInNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        linkedInNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        linkedInNode.simdPosition = simd_float3.init(x: 0.07, y: 0.08, z: 0)
        
        
        //        Linked in icon
        let twitterMaterial = SCNMaterial()
        twitterMaterial.diffuse.contents = UIImage.init(named: "twitter.png")
        twitterMaterial.isDoubleSided = false
        let twitterIconBox = SCNBox.init(width: 0.1, height: 0.1, length: 0.01, chamferRadius: 0)
        let twitterIconNode = SCNNode(geometry: twitterIconBox)
        twitterIconBox.firstMaterial = twitterMaterial
        twitterIconNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        twitterIconNode.simdPosition = simd_float3.init(x: 0.02, y: 0.075, z: 0)
        
        
        //twitter text
        let twitter = profile["twitter"].stringValue
        let twitterBubble = SCNText(string: twitter, extrusionDepth: CGFloat(bubbleDepth))
        twitterBubble.font = UIFont(name: "Futura", size: 0.10)?.withTraits(traits: .traitBold)
        twitterBubble.alignmentMode = kCAAlignmentCenter
        twitterBubble.firstMaterial?.diffuse.contents = UIColor.orange
        twitterBubble.firstMaterial?.specular.contents = UIColor.white
        twitterBubble.firstMaterial?.isDoubleSided = true
        twitterBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let twitterNode = SCNNode(geometry: twitterBubble)
        // Centre Node - to Centre-Bottom point
        twitterNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        twitterNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        twitterNode.simdPosition = simd_float3.init(x: 0.07, y: 0.07, z: 0)
        
        
        //        Linked in icon
        let fbMaterial = SCNMaterial()
        fbMaterial.diffuse.contents = UIImage.init(named: "facebook.png")
        fbMaterial.isDoubleSided = false
        let fbIconBox = SCNBox.init(width: 0.1, height: 0.1, length: 0.01, chamferRadius: 0)
        let fbIconNode = SCNNode(geometry: fbIconBox)
        fbIconBox.firstMaterial = fbMaterial
        fbIconNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        fbIconNode.simdPosition = simd_float3.init(x: 0.02, y: 0.065, z: 0)
        
        //facebook
        let facebook = profile["facebook"].stringValue
        let fbBubble = SCNText(string: facebook, extrusionDepth: CGFloat(bubbleDepth))
        fbBubble.font = UIFont(name: "Futura", size: 0.10)?.withTraits(traits: .traitBold)
        fbBubble.alignmentMode = kCAAlignmentCenter
        fbBubble.firstMaterial?.diffuse.contents = UIColor.orange
        fbBubble.firstMaterial?.specular.contents = UIColor.white
        fbBubble.firstMaterial?.isDoubleSided = true
        fbBubble.chamferRadius = CGFloat(bubbleDepth)
        //        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let fbNode = SCNNode(geometry: fbBubble)
        // Centre Node - to Centre-Bottom point
        fbNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        fbNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        fbNode.simdPosition = simd_float3.init(x: 0.07, y: 0.06, z: 0)
        
        //        //phone
        let phone = profile["phone"].stringValue
        let phoneBubble = SCNText(string: phone, extrusionDepth: CGFloat(bubbleDepth))
        phoneBubble.font = UIFont(name: "Futura", size: 0.09)?.withTraits(traits: .traitBold)
        phoneBubble.alignmentMode = kCAAlignmentCenter
        phoneBubble.firstMaterial?.diffuse.contents = UIColor.orange
        phoneBubble.firstMaterial?.specular.contents = UIColor.white
        phoneBubble.firstMaterial?.isDoubleSided = true
        phoneBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let phoneNode = SCNNode(geometry: phoneBubble)
        // Centre Node - to Centre-Bottom point
        phoneNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        phoneNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        phoneNode.simdPosition = simd_float3.init(x: 0.07, y: 0.05, z: 0)
        //location
        let location = profile["location"].stringValue
        let locBubble = SCNText(string: location, extrusionDepth: CGFloat(bubbleDepth))
        locBubble.font = UIFont(name: "Futura", size: 0.10)?.withTraits(traits: .traitBold)
        locBubble.alignmentMode = kCAAlignmentCenter
        locBubble.firstMaterial?.diffuse.contents = UIColor.orange
        locBubble.firstMaterial?.specular.contents = UIColor.white
        locBubble.firstMaterial?.isDoubleSided = true
        locBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let locNode = SCNNode(geometry: locBubble)
        // Centre Node - to Centre-Bottom point
        locNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        locNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        locNode.simdPosition = simd_float3.init(x: 0.07, y: 0.04, z: 0)
        
        //        // 3D IMAGE NODE
        //        let faceScene = SCNScene(named: "art.scnassets/ship.scn")
        //        //let box = SCNBox.init(width: 0.5, height: 0.5, length: 0.01, chamferRadius: 0)
        //        let boxNode = SCNNode()
        //        //faceScene!.rootNode.addChildNode(boxNode)
        //        boxNode.addChildNode((faceScene?.rootNode)!)
        //        boxNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        //        boxNode.simdPosition = simd_float3.init(x: -0.05, y: 0, z: 0)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.004)
        sphere.firstMaterial?.diffuse.contents = UIColor.gray
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.opacity = 0.6
        
        self.init()
        addChildNode(fullNameNode)
        addChildNode(linkedInNode)
        addChildNode(linkedinBoxNode)
        addChildNode(twitterIconNode)
        addChildNode(twitterNode)
        addChildNode(fbIconNode)
        addChildNode(fbNode)
        addChildNode(phoneNode)
        addChildNode(locNode)
        addChildNode(sphereNode)
        constraints = [billboardConstraint]
        self.position = position
    }
    
    convenience init(withText text : String, position: SCNVector3) {
        let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
        bubble.font = UIFont(name: "Futura", size: 0.15)?.withTraits(traits: .traitBold)
        bubble.alignmentMode = kCAAlignmentCenter
        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        bubble.chamferRadius = CGFloat(bubbleDepth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        bubbleNode.simdPosition = simd_float3.init(x: 0.06, y: 0.09, z: 0)

        self.init()
        addChildNode(bubbleNode)
        constraints = [billboardConstraint]
        self.position = position
    }
    
    func move(_ position: SCNVector3)  {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.position = position
        opacity = 1
        SCNTransaction.commit()
    }
    
    func hide()  {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2.0
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        opacity = 0
        SCNTransaction.commit()
    }
    
    func show()  {
        opacity = 0
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        opacity = 1
        SCNTransaction.commit()
    }
}

private extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
