//
//  LoginViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/30.
//

import UIKit
// import AuthenticationServices // 註解掉 Apple 登入
import FirebaseAuth
import CryptoKit

class SignInViewController: UIViewController {
    @IBOutlet weak var loginView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    func setupProviderLoginView() {
        // let button = ASAuthorizationAppleIDButton()
        // button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        // self.loginView.addArrangedSubview(button)
    }
    // @objc
    // func handleAuthorizationAppleIDButtonPress() {
    //     performSignIn()
    // }
    // func performSignIn() {
    //     let request = createAppleIDRequest()
    //     let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    //
    //     authorizationController.delegate = self
    //     authorizationController.presentationContextProvider = self
    //     authorizationController.performRequests()
    // }
    // func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
    //     let appleIDProvider = ASAuthorizationAppleIDProvider()
    //     let request = appleIDProvider.createRequest()
    //     request.requestedScopes = [.fullName, .email]
    //
    //     let nonce = randomNonceString()
    //     request.nonce =  sha256(nonce)
    //     currentNonce = nonce
    //
    //     return request
    // }
    // @available(iOS 13, *)
    // func startSignInWithAppleFlow() {
    //     let nonce = randomNonceString()
    //     currentNonce = nonce
    //     let appleIDProvider = ASAuthorizationAppleIDProvider()
    //     let request = appleIDProvider.createRequest()
    //     request.requestedScopes = [.fullName, .email]
    //     request.nonce = sha256(nonce)
    //
    //     let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    //     authorizationController.delegate = self
    //     authorizationController.presentationContextProvider = self
    //     authorizationController.performRequests()
    // }
    // @available(iOS 13, *)
    // private func sha256(_ input: String) -> String {
    //     let inputData = Data(input.utf8)
    //     let hashedData = SHA256.hash(data: inputData)
    //     let hashString = hashedData.compactMap {
    //         return String(format: "%02x", $0)
    //     }.joined()
    //
    //     return hashString
    // }

    fileprivate var currentNonce: String?
}
// extension SignInViewController: ASAuthorizationControllerDelegate {
//     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//         if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//             guard let nonce = currentNonce else {
//                 fatalError("invalid state: a log in callback was recieved,bit no log in request wassent")
//             }
//             guard let appleIDToken = appleIDCredential.identityToken else {
//                 print("unable to fetch identity token")
//                 return
//             }
//             guard let idToketString = String(data: appleIDToken, encoding: .utf8) else {
//                 print("unable to serialize token string from data \(appleIDToken.debugDescription)")
//                 return
//             }
//             let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToketString, rawNonce: nonce)
//
//             Auth.auth().signIn(with: credential) { (authDataResault, _ ) in
//                 if let user = authDataResault?.user {
//                     print("Nice ! You're sign in as \(user.uid),email: \(user.email ?? "unknown")")
//                     let userID = user.email
//                     print(userID ?? "")
//                     let controller = (self.storyboard?.instantiateViewController(identifier: "MainTabbarController")) as! TabBarViewController
//                     self.navigationController?.pushViewController(controller, animated: true)
//                 }
//             }
//         }
//     }
//     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//         print("Sign in with Apple errored: \(error)")
//     }
// }
// extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
//     func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//         return self.view.window!
//     }
// }
