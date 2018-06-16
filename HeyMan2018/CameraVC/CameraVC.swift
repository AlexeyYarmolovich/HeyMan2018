//
//  CameraVC.swift
//  HeyMan2018
//
//  Created by Alexey on 6/16/18.
//  Copyright © 2018 HeyMan. All rights reserved.
//


import AVFoundation
import UIKit
import Vision 


class CameraVC: UIViewController {
  
  private var textDetectionRequest: VNDetectTextRectanglesRequest?
  private let session = AVCaptureSession()
  private var textObservations = [VNTextObservation]()
  private var tesseract = G8Tesseract(language: "eng", engineMode: .tesseractOnly)
  private var font = CTFontCreateWithName("Helvetica" as CFString, 18, nil)
  
  private var cameraView: CameraView {
    return view as! CameraView
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tesseract?.pageSegmentationMode = .singleBlock
    // Recognize only these characters
    tesseract?.charWhitelist = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890().,_-$€"
    if isAuthorized() {
      configureTextDetection()
      configureCamera()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  private func configureTextDetection() {
    textDetectionRequest = VNDetectTextRectanglesRequest(completionHandler: handleDetection)
    textDetectionRequest?.reportCharacterBoxes = true
    textDetectionRequest?.regionOfInterest = CGRect.init(x: 0.15, y: 0.4, width: 0.7, height: 0.2)
  }
  private func configureCamera() {
    cameraView.session = session
    
    let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    var cameraDevice: AVCaptureDevice?
    for device in cameraDevices.devices {
      if device.position == .back {
        cameraDevice = device
        break
      }
    }
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: cameraDevice!)
      if session.canAddInput(captureDeviceInput) {
        session.addInput(captureDeviceInput)
      }
    }
    catch {
      print("Error occured \(error)")
      return
    }
    session.sessionPreset = .high
    let videoDataOutput = AVCaptureVideoDataOutput()
    videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Buffer Queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
    if session.canAddOutput(videoDataOutput) {
      session.addOutput(videoDataOutput)
    }
    cameraView.videoPreviewLayer.videoGravity = .resize
    session.startRunning()
  }

  
  private func handleDetection(request: VNRequest, error: Error?) {
    
    guard let detectionResults = request.results else {
      print("No detection results")
      return
    }
    let textResults = detectionResults.map() {
      return $0 as? VNTextObservation
    }
    if textResults.isEmpty {
      return
    }
   textObservations = (textResults as! [VNTextObservation])
      .map { (observation: $0, area: $0.boundingBox.size.area) }
      .sorted(by: { $0.area > $1.area } )
      .prefix(3)
      .map { $0.observation }
    print(textObservations.count)
    DispatchQueue.main.async { [weak self] in
      
      guard let `self` = self else { return }
      
      self.removeTextLayers()
      
      let viewWidth = self.view.frame.size.width
      let viewHeight = self.view.frame.size.height
//      print(textResults.count)
      for result in self.textObservations {
        
//        if let textResult = result {
        
//          self.placeBorderLayer(for: result,viewWidth: viewWidth, viewHeight: viewHeight)
//        }
      }
    }
  }
  
  private func placeBorderLayer(for textResult: VNTextObservation, viewWidth: CGFloat, viewHeight: CGFloat) {
    let layer = CALayer()
    var rect = textResult.boundingBox
    rect.origin.x *= viewWidth
    rect.size.height *= viewHeight
    rect.origin.y = ((1 - rect.origin.y) * viewHeight) - rect.size.height
    rect.size.width *= viewWidth
    
    layer.frame = rect
//    layer.borderWidth = 2
    layer.backgroundColor = UIColor.red.cgColor
    self.view.layer.addSublayer(layer)
  }
  
  private func removeTextLayers() {
    guard let sublayers = self.view.layer.sublayers else {
      return
    }
    for layer in sublayers[1...] {
      if (layer as? CATextLayer) == nil {
        layer.removeFromSuperlayer()
      }
    }
  }
  
  private func isAuthorized() -> Bool {
    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    switch authorizationStatus {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                    completionHandler: { (granted:Bool) -> Void in
                                      if granted {
                                        DispatchQueue.main.async {
                                          self.configureTextDetection()
                                          self.configureCamera()
                                        }
                                      }
      })
      return true
    case .authorized:
      return true
    case .denied, .restricted: return false
    }
  }

}

extension CameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {
  // MARK: - Camera Delegate and Setup
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    var imageRequestOptions = [VNImageOption: Any]()
    if let cameraData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
      imageRequestOptions[.cameraIntrinsics] = cameraData
    }
    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: imageRequestOptions)
    do {
      try imageRequestHandler.perform([textDetectionRequest!])
    }
    catch {
      print("Error occured \(error)")
    }
    var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let transform = ciImage.orientationTransform(for: CGImagePropertyOrientation(rawValue: 6)!)
    ciImage = ciImage.transformed(by: transform)
    let size = ciImage.extent.size
    var recognizedTextPositionTuples = [(rect: CGRect, text: String)]()
    let observationsToDisplay = textObservations
      .map { (observation: $0, area: $0.boundingBox.size.area) }
      .sorted(by: { $0.area > $1.area } )
      .prefix(3)
//      .prefix(upTo: 3)
      .map { $0.observation }
    
    
    
    for textObservation in observationsToDisplay {
      guard let rects = textObservation.characterBoxes else {
        continue
      }
      var xMin = CGFloat.greatestFiniteMagnitude
      var xMax: CGFloat = 0
      var yMin = CGFloat.greatestFiniteMagnitude
      var yMax: CGFloat = 0
      for rect in rects {
        
        xMin = min(xMin, rect.bottomLeft.x)
        xMax = max(xMax, rect.bottomRight.x)
        yMin = min(yMin, rect.bottomRight.y)
        yMax = max(yMax, rect.topRight.y)
      }
      let imageRect = CGRect(x: xMin * size.width, y: yMin * size.height, width: (xMax - xMin) * size.width, height: (yMax - yMin) * size.height)
      let context = CIContext(options: nil)
      guard let cgImage = context.createCGImage(ciImage, from: imageRect) else {
        continue
      }
      let uiImage = UIImage(cgImage: cgImage)
      tesseract?.image = uiImage
      tesseract?.recognize()
      guard var text = tesseract?.recognizedText else {
        continue
      }
      text = text.trimmingCharacters(in: CharacterSet.newlines)
      if !text.isEmpty {
        let x = xMin
        let y = 1 - yMax
        let width = xMax - xMin
        let height = yMax - yMin
        recognizedTextPositionTuples.append((rect: CGRect(x: x, y: y, width: width, height: height), text: text))
      }
    }
    
    //clear old
    textObservations.removeAll()
    DispatchQueue.main.async {
      let viewWidth = self.view.frame.size.width
      let viewHeight = self.view.frame.size.height
      guard let sublayers = self.view.layer.sublayers else {
        return
      }
      for layer in sublayers[1...] {
        
        if let _ = layer as? CATextLayer {
          layer.removeFromSuperlayer()
        }
      }
      //add new
      for tuple in recognizedTextPositionTuples {
        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.red.cgColor
        textLayer.font = self.font
        var rect = tuple.rect
        
        rect.origin.x *= viewWidth
        rect.size.width *= viewWidth
        rect.origin.y *= viewHeight
        rect.size.height *= viewHeight
        
        // Increase the size of text layer to show text of large lengths
        rect.size.width += 100
        rect.size.height += 100
        
        textLayer.frame = rect
        textLayer.string = tuple.text
        textLayer.foregroundColor = UIColor.green.cgColor
        self.view.layer.addSublayer(textLayer)
      }
    }
  }
}

extension CGSize {
  var area: CGFloat {
    return width * height
  }
}
