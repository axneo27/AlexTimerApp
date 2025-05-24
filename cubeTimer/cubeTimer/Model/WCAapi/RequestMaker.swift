//
//  RequestMaker.swift
//  cubeTimer
//
//  Created by Oleksii on 04.01.2025.
//

import Foundation

struct ScrambleJson: Codable {
    var id: String
    var scramble: String
}

enum SError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class RequestMaker{
    private var urlString: String = "http://127.0.0.1:8000/scramble" // tested only locally
    private var url: URL?
    
    public var discipline: Discipline?
    public var count: Int = 1
    private var puzzle: String {
        switch discipline{
        case .two: return "two"
        case .three: return "three"
        case .four: return "four_fast"
        default: return ""
        }
    }
    
    private var scramblesJson: [ScrambleJson]?
    
    init(puzzleType: Discipline, count: Int) {
        self.count = count
        self.discipline = puzzleType
        urlString+="/\(self.puzzle)/\(self.count)"
    }
    
    private func fetchScramble() async throws -> [ScrambleJson] {
        let endpoint = "http://127.0.0.1:8000/scramble/\(self.puzzle)/\(self.count)"
        
        guard let url = URL(string: endpoint) else {throw SError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode([String: [ScrambleJson]].self, from: data)
            guard let scrambleList = decodedResponse.values.first else {
                throw SError.invalidData
            }
            return scrambleList
        } catch {
            throw SError.invalidData
        }
    }
    
    public func getScramblesString(completion: @escaping ([String]?) -> (Void)) {
        DispatchQueue.global().async {
            Task {
                do{
                    self.scramblesJson = try await self.fetchScramble()
                    let scramblesString = self.scramblesJson?.compactMap{$0.scramble}
                    DispatchQueue.main.async {
                        completion(scramblesString)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}
