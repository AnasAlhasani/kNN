//
//  kNN.swift
//
//  Created by Anas on 9/23/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

public struct KNN {
    
    private let blockSize = 6
    private var blocks: [Int] = []
    private let k: Int
    private let offlineSignals: [[Double]]
    private let onlineSignals: [Double]
    
    public init(onlineSignals: [Double], offlineSignals: [[Double]]) {
        
        self.onlineSignals = onlineSignals
        self.offlineSignals = offlineSignals
        self.k = Int(sqrt(Double(offlineSignals.count)))
        
        var block = 0
        offlineSignals.enumerated().forEach({
            block = $0.0 % blockSize == 0 ? block + 1: block
            blocks.append(block)
        })
    }
    
    private func calculateEuclideanDistances() -> [Double] {
        
        return offlineSignals.enumerated().map({
            
            $0.1.enumerated().map({
                
                pow($0.1 - onlineSignals[$0.0], 2)
                
            }).reduce(0, +).squareRoot()
            
        }).flatMap({ $0 })
    }
    
    private func kNearestNeighbors() -> [(block: Int, location: Int)] {
        
        let distances = calculateEuclideanDistances()
        
        let neighbors = distances.enumerated().flatMap({
            (blocks[$0.0], $0.0 + 1, $0.1)
        })
        
        return neighbors.sorted { $0.2 < $1.2 }[0...k-1].flatMap({ ($0.0, $0.1) })
    }
    
    public func getEstimatedLocation() -> Int {
        
        var frequencies: [Int: Int] = [:]
        
        let knn = kNearestNeighbors()
        
        knn.forEach({ frequencies[$0.0, default: 0] += 1 })
        
        let majority = frequencies.filter({ $0.1 == frequencies.values.max() }).first!.0
        
        return knn.filter({ $0.0 == majority })[0].1
        
    }
}











