//
//  IncreasedHitPointButton.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 26.01.2022.
//

import UIKit

class IncreasedHitPointButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
}
