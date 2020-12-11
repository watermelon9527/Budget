//
//  QRScannerController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/25.
//

import UIKit
import AVFoundation
class QRScannerController: UIViewController {

    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var label: UILabel!

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
        self.navigationController?.isNavigationBarHidden = true
        //取得後置鏡頭來擷取影片
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Fail to get the device")
            return
        }
        do {
            //使用前一個裝置物件來取得AVCaptureDeviceInput類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice )
            captureSession.addInput(input)

            //初始化一個AVCaptureMetadataOutput物件並將其設定作為擷取session的輸出裝置
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // 設定委派並使用預設的調度佇列來執行回呼（call back）
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            print(error)
            return
        }
        // 初始化影片預覽層，並將其作為子層加入 viewPreview 視圖的圖層中」
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()

        //初始化 QR Code 框來凸顯QR Code
        // Move the label and bar to the front
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
        // 檢查metadataObjects陣列為非空值，他至少需要包含一個物件
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            label.text = "No QR Code is detected."
            return
        }
        //取得元資料(metadata)物件
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // 若發現的元物件和QRCode的元物件相同，便更新狀態標籤的文字並設定邊界
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                if metadataObj.stringValue != nil {
                  // print(metadataObj)
                    label.text = metadataObj.stringValue
                    if metadataObj.stringValue!.count != 2 {
                    let receipt = metadataObj.stringValue
                    guard let start = receipt?.index(receipt!.startIndex, offsetBy: 95) else { return  }
                    guard let end = receipt?.index(receipt!.endIndex, offsetBy: 0) else { return  }
                    let range = start..<end
                    let myReceipt = receipt![range]
                    print(myReceipt)
                    } else {return}

                }
                launchApp(decodedURL: metadataObj.stringValue!)
         //       self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        } else {return}
    }
}
