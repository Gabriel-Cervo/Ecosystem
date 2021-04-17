public enum FlowerType {
    case grass
    case herb
    case flower
}

public enum HerbivoreType {
    case capybara
    case rabbit
    case zebra
}

public enum CarnivoreType {
    case jaguar
    case snake
    case wolf
}

public func getPlantTypeInInt(_ type: FlowerType) -> Int {
    switch type {
    case .grass:
        return 1
    case .herb:
        return 2
    case .flower:
        return 3
    default:
        return 1
    }
}

public func getHerbivoreTypeInInt(_ type: HerbivoreType) -> Int {
    switch type {
    case .capybara:
        return 1
    case .rabbit:
        return 2
    case .zebra:
        return 3
    default:
        return 1
    }
}

public func getCarnivoreTypeInInt(_ type: CarnivoreType) -> Int {
    switch type {
    case .jaguar:
        return 1
    case .snake:
        return 2
    case .wolf:
        return 3
    default:
        return 1
    }
}
