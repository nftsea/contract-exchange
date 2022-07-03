// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {ICurrencyManager} from "./interfaces/ICurrencyManager.sol";

/**
 * @title CurrencyManager
 * @notice It allows adding/removing currencies for trading on the NFTSea exchange.
 */
contract CurrencyManager is ICurrencyManager, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _whitelistedCurrencies;

    event CurrencyRemoved(address indexed currency);
    event CurrencyWhitelisted(address indexed currency);

    /**
     * @notice Add a currency in the system
     * @param currency address of the currency to add
     */
    function addCurrency(address currency) external override onlyOwner {
        require(!_whitelistedCurrencies.contains(currency), "Currency: Already whitelisted");
        _whitelistedCurrencies.add(currency);

        emit CurrencyWhitelisted(currency);
    }

    /**
     * @notice Remove a currency from the system
     * @param currency address of the currency to remove
     */
    function removeCurrency(address currency) external override onlyOwner {
        require(_whitelistedCurrencies.contains(currency), "Currency: Not whitelisted");
        _whitelistedCurrencies.remove(currency);

        emit CurrencyRemoved(currency);
    }

    /**
     * @notice Returns if a currency is in the system
     * @param currency address of the currency
     */
    function isCurrencyWhitelisted(address currency) external view override returns (bool) {
        return _whitelistedCurrencies.contains(currency);
    }

    /**
     * @notice View number of whitelisted currencies
     */
    function viewCountWhitelistedCurrencies() external view override returns (uint256) {
        return _whitelistedCurrencies.length();
    }

    /**
     * @notice See whitelisted currencies in the system
     * @param cursor cursor (should start at 0 for first request)
     * @param size size of the response (e.g., 50)
     */
    function viewWhitelistedCurrencies(uint256 cursor, uint256 size)
        external
        view
        override
        returns (address[] memory, uint256)
    {
        uint256 length = size;

        if (length > _whitelistedCurrencies.length() - cursor) {
            length = _whitelistedCurrencies.length() - cursor;
        }

        address[] memory whitelistedCurrencies = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            whitelistedCurrencies[i] = _whitelistedCurrencies.at(cursor + i);
        }

        return (whitelistedCurrencies, cursor + length);
    }
}


//                                        :9H####@@@@@Xi                        
//                                       1@@@@@@@@@@@@@@8                       
//                                     ,8@@@@@@@@@B@@@@@@8                      
//                                    :B@@@@X3hi8Bs;B@@@@@Ah,                   
//               ,8i                  c@@@B:     1S ,M@@@@@@#8;                 
//              1AB35.i:               X@@8 .   SGhr ,A@@@@@@@@S                
//              1@h31MX8                18Hhh3i .i3r ,A@@@@@@@@@5               
//              ;@&i,58r5                 rGSS:     :B@@@@@@@@@@A               
//               1#i  . 9i                 hX.  .: .5@@@@@@@@@@@1               
//                sG1,  ,G53s.              9#Xi;hS5 3B@@@@@@@B1                
//                 .h8h.,A@@@MXSs,           #@H1:    3ssSSX@1                  
//                 s ,@@@@@@@@@@@@Xhi,       r#@@X1s9M8    .GA981               
//                 ,. rS8H#@@@@@@@@@@#HG51;.  .h31i;9@r    .8@@@@BS;i;          
//                  .19AXXXAB@@@@@@@@@@@@@@#MHXG893hrX#XGGXM@@@@@@@@@@MS        
//                  s@@MM@@@hsX#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,      
//                :GB@#3G@@Brs ,1GM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B,     
//              .hM@@@#@@#MX 51  r;iSGAM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8     
//            :3B@@@@@@@@@@@&9@h :Gs   .;sSXH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:    
//        s&HA#@@@@@@@@@@@@@@M89A;.8S.       ,r3@@@@@@@@@@@@@@@@@@@@@@@@@@@r    
//     ,13B@@@@@@@@@@@@@@@@@@@5 5B3 ;.         ;@@@@@@@@@@@@@@@@@@@@@@@@@@@i    
//    5#@@#&@@@@@@@@@@@@@@@@@@9  .39:          ;@@@@@@@@@@@@@@@@@@@@@@@@@@@;    
//    9@@@X:MM@@@@@@@@@@@@@@@#;    ;31.         H@@@@@@@@@@@@@@@@@@@@@@@@@@:    
//     SH#@B9.rM@@@@@@@@@@@@@B       :.         3@@@@@@@@@@@@@@@@@@@@@@@@@@5    
//       ,:.   9@@@@@@@@@@@#HB5                 .M@@@@@@@@@@@@@@@@@@@@@@@@@B    
//             ,ssirhSM@&1;i19911i,.             s@@@@@@@@@@@@@@@@@@@@@@@@@@S   
//                ,,,rHAri1h1rh&@#353Sh:          8@@@@@@@@@@@@@@@@@@@@@@@@@#:  
//              .A3hH@#5S553&@@#h   i:i9S          #@@@@@@@@@@@@@@@@@@@@@@@@@A.
 
//      又看源码，看你妹妹呀！


