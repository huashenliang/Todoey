//
//  AppDelegate.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-06.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //get the realm file location
       // print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            _ =  try Realm()
        } catch  {
            print("Error initialising new realm, \(error)")
        }

  

        return true
    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Inside your application(application:didFinishLaunchingWithOptions:)
//
//        let config = Realm.Configuration(
//            // Set the new schema version. This must be greater than the previously used
//            // version (if you've never set a schema version before, the version is 0).
//            schemaVersion: 1,
//
//            // Set the block which will be called automatically when opening a Realm with
//            // a schema version lower than the one set above
//            migrationBlock: { migration, oldSchemaVersion in
//                // We haven’t migrated anything yet, so oldSchemaVersion == 0
//                if (oldSchemaVersion < 1) {
//                    // Nothing to do!
//                    // Realm will automatically detect new properties and removed properties
//                    // And will update the schema on disk automatically
//                }
//        })
//
//        // Tell Realm to use this new configuration object for the default Realm
//        Realm.Configuration.defaultConfiguration = config
//
//        // Now that we've told Realm how to handle the schema change, opening the file
//        // will automatically perform the migration
//        let realm = try! Realm()
//
//        return true
//    }
}
