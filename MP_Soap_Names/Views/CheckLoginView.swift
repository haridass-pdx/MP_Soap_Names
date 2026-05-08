//
//  CheckLoginView.swift
//  KPRC-Payroll
//
//  Created by Hari Dass Khalsa on 12/18/25.
//

import SwiftUI

struct CheckLoginView: View {
 //   @EnvironmentObject var globalData: globalDataRec
    @State var authenticated: Bool = false
    
    var body: some View {
        if(authenticated == false){
            AuthenticateView(isAuthenticated: $authenticated)
        }
        else {
         
                ContentView()
         //           .environmentObject(globalData)
            }
        }
    }


#Preview {
    //    CheckLoginView()
}
