//
//  Diary+CoreDataProperties.swift
//  myAprication004
//
//  Created by Apple on 2016/11/19.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary");
    }

    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var category: String?
    @NSManaged public var diary: String?
    @NSManaged public var image: String?

}
