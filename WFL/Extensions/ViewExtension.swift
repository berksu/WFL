//
//  ViewExtension.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.12.2021.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position + 1)
        return self.offset(CGSize(width: offset * 20, height: 0))
    }
    
    func opaced(at position: Int, in total: Int) -> some View {
        if(total >= 3){
            switch position{
            case 0:
                return self.opacity(0.2)
            case 1:
                return self.opacity(0.5)
            default:
                return self.opacity(1)
            }
        }else if(total == 2){
            switch position{
            case 0:
                return self.opacity(0.5)
            default:
                return self.opacity(1)
            }
        }else{
            return self.opacity(1)
        }
    }
    
    func scaled(at position: Int, in total: Int) -> some View {
        if(total >= 3){
            switch position{
            case 0:
                return self.scaleEffect(0.9)
            case 1:
                return self.scaleEffect(0.95)
            default:
                return self.scaleEffect(1)
            }
        }else if(total == 2){
            switch position{
            case 0:
                return self.scaleEffect(0.95)
            default:
                return self.scaleEffect(1)
            }
        }else{
            return self.scaleEffect(1)
        }
    }
}
