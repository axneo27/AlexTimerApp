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
    
    private var urlString: String = "https://tnoodle-api-production.up.railway.app/scramble"
//    private var urlString: String = "http://localhost:80/scramble" // for tests
    
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
    }
    
    private func fetchScramble() async throws -> [ScrambleJson] {
        let endpoint = urlString+"/\(self.puzzle)/\(self.count)"
        print(endpoint)
        
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
        DispatchQueue.main.async {
            Task {
                do{
                    self.scramblesJson = try await self.fetchScramble()
                    let scramblesString = self.scramblesJson?.compactMap{$0.scramble}
                    completion(scramblesString)
                } catch {
                    print("Error in getScramblesString (but obviously was thrown in fetchScramble): \(error)")
                    completion(nil)
                }
            }
        }
    }
}
