//
//  CategoryModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 22.09.2021.
//

import Foundation
import SwiftUI


struct CategoryModel {
    var id = UUID().uuidString
    var imageString: String?
    var name: String?
  
}
class Category: ObservableObject {
    @Published var categoryArray = [CategoryModel]()
    @Published var category = CategoryModel()
    
    init(){
        getCategory()
    }
    
    func getCategory() {
        var category = [CategoryModel]()
        category.append(CategoryModel(imageString: "bar", name: "Бары и пабы"))
        category.append(CategoryModel(imageString: "restoran", name: "Рестораны и кафе"))
        category.append(CategoryModel(imageString: "fasfud", name: "Фасфуд"))
        category.append(CategoryModel(imageString: "salon", name: "Красота"))
        category.append(CategoryModel(imageString: "marcet", name: "Магазины"))
        category.append(CategoryModel(imageString: "tc", name: "Торговые центры"))
        category.append(CategoryModel(imageString: "kinder", name: "Для детей"))
        category.append(CategoryModel(imageString: "hotel", name: "Гостиницы"))
        category.append(CategoryModel(imageString: "bisnes", name: "Бизнес"))
        category.append(CategoryModel(imageString: "dicovery", name: "Места культуры"))
        category.append(CategoryModel(imageString: "parc", name: "Парки и скверы"))
        category.append(CategoryModel(imageString: "razvlechenia", name: "Развлечения"))
        category.append(CategoryModel(imageString: "servis", name: "Сервис"))
        category.append(CategoryModel(imageString: "servisAuto", name: "Автосервис"))
        category.append(CategoryModel(imageString: "direct", name: "Объявления"))
        category.append(CategoryModel(imageString: "adalt", name: "Для взрослых"))
        category.append(CategoryModel(imageString: "tinder", name: "Для общения"))
    
        self.categoryArray = category

    }
}
