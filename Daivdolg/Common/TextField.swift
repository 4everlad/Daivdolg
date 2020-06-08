//
//  TextField.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 09.06.2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
