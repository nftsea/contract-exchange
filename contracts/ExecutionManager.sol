// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {IExecutionManager} from "./interfaces/IExecutionManager.sol";

/**
 * @title ExecutionManager
 * @notice It allows adding/removing execution strategies for trading on the NFTSea exchange.
 */
contract ExecutionManager is IExecutionManager, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _whitelistedStrategies;

    event StrategyRemoved(address indexed strategy);
    event CurrencyRemoveWhitelist(address indexed currency);
    event StrategyWhitelisted(address indexed strategy);

    /**
     * @notice Add an execution strategy in the system
     * @param strategy address of the strategy to add
     */
    function addStrategy(address strategy) external override onlyOwner {
        require(!_whitelistedStrategies.contains(strategy), "Strategy: Already whitelisted");
        _whitelistedStrategies.add(strategy);

        emit StrategyWhitelisted(strategy);
    }

    /**
     * @notice Remove an execution strategy from the system
     * @param strategy address of the strategy to remove
     */
    function removeStrategy(address strategy) external override onlyOwner {
        require(_whitelistedStrategies.contains(strategy), "Strategy: Not whitelisted");
        _whitelistedStrategies.remove(strategy);

        emit StrategyRemoved(strategy);
    }

    /**
     * @notice Returns if an execution strategy is in the system
     * @param strategy address of the strategy
     */
    function isStrategyWhitelisted(address strategy) external view override returns (bool) {
        return _whitelistedStrategies.contains(strategy);
    }

    /**
     * @notice View number of whitelisted strategies
     */
    function viewCountWhitelistedStrategies() external view override returns (uint256) {
        return _whitelistedStrategies.length();
    }

    /**
     * @notice See whitelisted strategies in the system
     * @param cursor cursor (should start at 0 for first request)
     * @param size size of the response (e.g., 50)
     */
    function viewWhitelistedStrategies(uint256 cursor, uint256 size)
        external
        view
        override
        returns (address[] memory, uint256)
    {
        uint256 length = size;

        if (length > _whitelistedStrategies.length() - cursor) {
            length = _whitelistedStrategies.length() - cursor;
        }

        address[] memory whitelistedStrategies = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            whitelistedStrategies[i] = _whitelistedStrategies.at(cursor + i);
        }

        return (whitelistedStrategies, cursor + length);
    }
}
//  _______________#########_______________________
//  ______________###NFTSea######_____________________
//  ______________####NFTSea######____________________
//  _____________##__##NFTSea######___________________
//  ____________###__######_#####__________________
//  ____________###_#######___####_________________
//  ___________###__###NFTSea##_####________________
//  __________####__#####NFTSea##_####_______________
//  ________#####___####NFTSea#__#####_____________
//  _______######___###NFTSea###___#####___________
//  _______#####___###___#NFTSea#___######_________
//  ______######___###__###NFTSea##___######_______
//  _____######___####_#####NFTSea###__######______
//  ____#######__############NFTSea##_#######_____
//  ____#######__#############NFTSea###########____
//  ___#######__######_########NFTSea###_#######___
//  ___#######__######_######_##NFTSea#___######___
//  ___#######____##__######___######_____######___
//  ___#######________######____#####_____#####____
//  ____######________#####_____#####_____####_____
//  _____#####________####______#####_____###______
//  ______#####______;###________###______#________
//  ________##_______####________####______________