//
//  QRScannerController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/25.
//

import UIKit
import AVFoundation
protocol QRCodeScannerDelegate {
    func QRScanner( category: String, price: String)
}
class QRScannerController: UIViewController {
     var delegate: QRCodeScannerDelegate?
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var label: UILabel!

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Fail to get the device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice )
            captureSession.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            print(error)
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()

        view.bringSubviewToFront(label)
        view.bringSubviewToFront(bar)
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    func launchApp(decodedURL: String) {
        if presentedViewController != nil {
            return
        }
        let alertPrompt = UIAlertController(title: "Open App",
                                            message: "You are going to open \(decodedURL)",
                                            preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (_) -> Void in
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        present(alertPrompt, animated: true, completion: nil)
    }
    
}
extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func unwindToContainerVC(segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "unwindToHomeScreenWithSegue", sender: self)

    }
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            label.text = "No QR Code is detected."
            return
        }
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                if metadataObj.stringValue != nil {
                    print(metadataObj)
                    label.text = metadataObj.stringValue
                    if metadataObj.stringValue!.count != 2 {
                        let receipt = metadataObj.stringValue
                        print(receipt ?? "no data")
                        //                        guard let start = receipt?.index(receipt!.startIndex, offsetBy: 95) else { return  }
                        //                        guard let end = receipt?.index(receipt!.endIndex, offsetBy: -6) else { return  }
                        //                        let range = start..<end
                        //                        let myReceipt = receipt![range]
                        //                        print(myReceipt)
                        //
                        //                        guard let priceStart = receipt?.index(receipt!.startIndex, offsetBy: 110) else { return  }
                        //                        guard let priceEnd = receipt?.index(receipt!.endIndex, offsetBy: -1) else { return  }
                        //                        let priceRange = priceStart..<priceEnd
                        //                        let priceReceipt = receipt![priceRange]
                        //                        print(priceReceipt)
                        //                        delegate?.QRScanner(category: "\(myReceipt)", price: "\(priceReceipt)")

                    } else {return}

                }
                //            launchApp(decodedURL: metadataObj.stringValue!)
                // self.navigationController?.popViewController(animated: true)
            }
        } else {return}
    }
}
