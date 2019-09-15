//
//  ItemService.swift
//  PipeLineAR
//
//  Created by Tuncay Cansız on 14.09.2019.
//  Copyright © 2019 Tuncay Cansız. All rights reserved.
//


import Foundation


class ItemService {
    static let instance = ItemService()
    

    
    
    private let planets = [
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "EarthDay"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "EarthNight"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "Moon"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "CeresFictional"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "ErisFictional"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "HuemeaFictional"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "Jupiter"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "Mars"),
        Items(groupName: "Planets", itemName: "Earth Day", itemImage: "Mercury")
    ]
    

    
    private let furnitures = [
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "BarStoolRound"),
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "DiningChairHighBack"),
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "TallChair"),
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "DinerChair"),
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "DinerBench"),
        Items(groupName: "Furnitures", itemName: "Earth Day", itemImage: "DinerBoth")
    ]
    
    private let cubes = [
        Items(groupName: "Cubes", itemName: "Earth Day", itemImage: "Cube1"),
        Items(groupName: "Cubes", itemName: "Earth Day", itemImage: "Cube2"),
        Items(groupName: "Cubes", itemName: "Earth Day", itemImage: "Cube3")
    ]
    
    private let characters = [
        Items(groupName: "Characters", itemName: "Earth Day", itemImage: "Ceday"),
        Items(groupName: "Characters", itemName: "Earth Day", itemImage: "Yoda"),
    ]
    


    
    
    func getItems(forGroupName groupName:String) -> [Items]{
        switch groupName {
        case "Planets":
            return getPlanets()
        case "Furnitures":
            return getFurnitures()
        case "Cubes":
            return getCubes()
        case "Characters":
            return getCharacters()
        default:
            return getPlanets()
        }
    }
    

    func getPlanets() -> [Items]{
        return planets
    }
    
    func getFurnitures() -> [Items]{
        return furnitures
    }
    
    
    func getCubes() -> [Items]{
        return cubes
    }
    
    func getCharacters() -> [Items]{
        return characters
    }

}
