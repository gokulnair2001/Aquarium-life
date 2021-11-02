//
//  ParentView.swift
//  Aquarium life
//
//  Created by Sahil Satralkar on 25/11/20.
//

import SwiftUI
import StoreKit

//Code to hide keyboard/decimalpad
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// Get app version
extension UIApplication {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
}
//Get iOS version
func getOSInfo()->String {
    let os = ProcessInfo().operatingSystemVersion
    return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
}

//Get Device name
// Modified for v1.5
func getDeviceName() -> String {
    let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
                
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
                
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
                
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
    return modelName
    
}

enum LengthUnits: String, CaseIterable {
    case Centimeters
    case Inches
}

enum WeightUnits: String, CaseIterable {
    case Kilograms
    case Pounds
}

enum VolumeUnits: String, CaseIterable {
    case Liters
    case USGallons = "US Gallons"
    case UKGallons = "UK Gallons"
}

enum TemperatureUnits: String, CaseIterable {
    case Celsius
    case Fahrenheit
}

struct ParentView: View {
    
    // v.1.4
    @EnvironmentObject var selectedTabEnv: SelectedTab
    //
    //IAP product ID's
    let productIDs = [
            //Use your product IDs
        Constants.IAP.shrimpsPackProductID,
        Constants.IAP.plantsPackProductID
        ]
    
    @StateObject var storeManager = StoreManager()
    
    var body: some View {
        // v.1.4
        TabView (selection: $selectedTabEnv.tabNumber){
        //
            
            
            LiveStockView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(LocalizedStringKey("CareSheets"))
                }
                // v.1.4.1
                .tag(TabIdentifier.careSheets)
                //
            CalculatorView()
                .tabItem {
                    Image(systemName: "plus.slash.minus")
                    Text(LocalizedStringKey("Calculators"))
                }
                // v.1.4.1
                .tag(TabIdentifier.calculators)
                //
            MyTankView()
                .tabItem {
                    Image(systemName: "cube")
                    Text(LocalizedStringKey("MyAquariums"))
                }
                // v.1.4.1
                .tag(TabIdentifier.myAquariums)
                //
            NotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text(LocalizedStringKey("MyNotes"))
                }
                // v.1.4.1
                .tag(TabIdentifier.myNotes)
                //
            SettingsView(storeManager: self.storeManager)
                .tabItem {
                    Image(systemName: "gear")
                    Text(("Settings"))
                }
                // v.1.4.1
                .tag(TabIdentifier.settings)
                //
                .background(Color(.blue))
        }
        .onAppear(perform:{
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIDs: productIDs)
        })
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(storeManager: StoreManager())
    }
}
