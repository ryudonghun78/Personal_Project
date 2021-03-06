//
//  LoginViewController.swift
//  memo
//
//  Created by Dongheon Ryu on 2017. 11. 10..
//  Copyright © 2017년 이효중. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class LoginViewController: UIViewController/* , GIDSignInUIDelegate*/, FBSDKLoginButtonDelegate{
    
    //ID, PW input TextField
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBAction func loginBtn(_ sender: Any) {
        handleLogin()
    }
    
    func handleLogin(){
        guard let email = idTextField.text, let password = pwTextField.text else{
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            if err != nil{
                print(err)
                let AlertController = UIAlertController(title: "실패", message: "아이디, 패스워드를 확인해주세요", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler : nil)
                AlertController.addAction(okAction)
                self.present(AlertController,animated: true,completion: nil)
                return
                
            }
            self.performSegue(withIdentifier: "login", sender: self)
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //need x,y,width,height constraints
        
        
        // Do any additional setup after loading the view.
        
        
        
        //***** Google Sign In *****//
        
        //        //add google sign in button
        //        let googleButton = GIDSignInButton()
        //        googleButton.frame = googleBtn.frame
        //        view.addSubview(googleButton)
        //
        //
        //
        //        GIDSignIn.sharedInstance().uiDelegate = self
        
        //***** end of Google Sign In *****//
        
        
        //***** Facebook Log In *****//
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        print("success button make")
        
        
        //***** End of Facebook Log In *****//
        
    }
    
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) {(result,err) in
            if err != nil{
                print("Custom FB Login failed: ",err)
                return
            }
            self.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook....")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        //segue를 만들어서 로그인 끝나고 다시 돌아올때 바로 다음화면으로 넘어갈 수 있게 만듬
        
        
        performSegue(withIdentifier: "facebookLogin", sender: self)
        showEmailAddress()
        print("Successfully logged in with facebook...")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        print("accessToken : \(accessToken)")
        guard let accessTokenString = accessToken!.tokenString else {return}
        print("accessTokenString : \(accessTokenString)")
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        print("credentials : \(credentials)")
        //이부분에서 에러가 남. 어떤 에러인지 스택오버플로우를 통해 검색해봤으나 해결하지 못함. 나온 방법들을 그대로 사용했으나 버전이 달라 해결 불가. 일단 다음으로 넘김
        FIRAuth.auth()?.signIn(with: credentials, completion: {(user,err) in
            if err != nil {
                print("something went wrong with our FB user: ",err!)
                return
            }
            print("Successfully logged in with our user: ", user!)
        })
        FBSDKGraphRequest(graphPath: "/me", parameters : ["fields":"id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("failed to start graph request: ", err)
                return
            }
            print(result ?? "")
        }
    }
    
    //Keyboard end
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

