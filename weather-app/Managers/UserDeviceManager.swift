//
//  UserDeviceManager.swift
//  weather-app
//
//  Created by Николай Завгородний on 23.09.2025.
//

import UIKit

final class UserDeviceManager {
    static let shared = UserDeviceManager()
    private init() {}
    
    let isPad = {
        UIDevice.current.userInterfaceIdiom == .pad
    }()
}
