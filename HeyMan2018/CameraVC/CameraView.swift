//
//  CameraView.swift
//  HeyMan2018
//
//  Created by Alexey on 6/16/18.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraView: UIView {
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    guard let layer = layer as? AVCaptureVideoPreviewLayer else {
      fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
    }
    return layer
  }
  var session: AVCaptureSession? {
    get {
      return videoPreviewLayer.session
    }
    set {
      videoPreviewLayer.session = newValue
    }
  }
  // MARK: UIView
  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
}
