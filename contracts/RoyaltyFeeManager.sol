// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC165, IERC2981} from "@openzeppelin/contracts/interfaces/IERC2981.sol";

import {IRoyaltyFeeManager} from "./interfaces/IRoyaltyFeeManager.sol";
import {IRoyaltyFeeRegistry} from "./interfaces/IRoyaltyFeeRegistry.sol";

/**
 * @title RoyaltyFeeManager
 * @notice It handles the logic to check and transfer royalty fees (if any).
 */
contract RoyaltyFeeManager is IRoyaltyFeeManager, Ownable {
    // https://eips.ethereum.org/EIPS/eip-2981
    bytes4 public constant INTERFACE_ID_ERC2981 = 0x2a55205a;

    IRoyaltyFeeRegistry public immutable royaltyFeeRegistry;

    /**
     * @notice Constructor
     * @param _royaltyFeeRegistry address of the RoyaltyFeeRegistry
     */
    constructor(address _royaltyFeeRegistry) {
        royaltyFeeRegistry = IRoyaltyFeeRegistry(_royaltyFeeRegistry);
    }

    /**
     * @notice Calculate royalty fee and get recipient
     * @param collection address of the NFT contract
     * @param tokenId tokenId
     * @param amount amount to transfer
     */
    function calculateRoyaltyFeeAndGetRecipient(
        address collection,
        uint256 tokenId,
        uint256 amount
    ) external view override returns (address, uint256) {
        // 1. Check if there is a royalty info in the system
        (address receiver, uint256 royaltyAmount) = royaltyFeeRegistry.royaltyInfo(collection, amount);

        // 2. If the receiver is address(0), fee is null, check if it supports the ERC2981 interface
        if ((receiver == address(0)) || (royaltyAmount == 0)) {
            if (IERC165(collection).supportsInterface(INTERFACE_ID_ERC2981)) {
                (receiver, royaltyAmount) = IERC2981(collection).royaltyInfo(tokenId, amount);
            }
        }
        return (receiver, royaltyAmount);
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
