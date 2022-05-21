//
//  Renderable.swift
//  Fabnite
//
//  Created by Yaroslav Kh. on 09.11.2021.
//

import Foundation

protocol Renderable: AnyObject {
    
    associatedtype EntityType
    
    func render(with entity: EntityType)
}
