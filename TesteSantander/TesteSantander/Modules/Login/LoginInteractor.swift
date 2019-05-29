//
//  LoginInteractor.swift
//  TesteSantander
//
//  Created by Felipe Alexander Silva Melo on 28/05/19.
//  Copyright (c) 2019 Felipe Alexander Silva Melo. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginBusinessLogic {
    func login(request: Login.Login.Request)
}

protocol LoginDataStore {
    //var name: String { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func login(request: Login.Login.Request) {
        worker = LoginWorker()
        worker?.login(userFormFields: request.userFormFields) { user in
            let response = Login.Login.Response(user: user)
            self.presenter?.presentStatements(response: response)
        }
    }
}
