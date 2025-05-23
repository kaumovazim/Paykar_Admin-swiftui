//
//  MainService.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/08/24.
//

import SwiftUI

protocol MainService {
    
    func convertSVGToImage(image: String, width: Int, height: Int) -> UIImage
    
    func checkInternetConnection() -> Bool
        
}


