// SPDX-License-Identifier: GPL-3.0
// Hadcoins ICO

// version of compiler
pragma solidity ^0.8.0;

contract HadcoinICO {
    // maximum number of hadcoins available for sale
    uint public maxHadcoins = 1000000;

    // usd to hadcoins conversion rate
    uint public usdToHadcoins = 1000;

    // introducing the total number of hadcoins that have been bought by the investors
    uint public totalHadcoinsBought = 0;

    // mapping from the investor address to its equity in hadcoins and usd
    mapping(address => uint) equityHadcoins;
    mapping(address => uint) equityUsd;

    // checking if an investor can buy hadcoins
    modifier canBuyHadcoins(uint usdInvested) {
        require(usdInvested * usdToHadcoins + totalHadcoinsBought <= maxHadcoins, "Not enough Hadcoins available");
        _;
    }

    // getting the equity in hadcoins of an investor
    function equityInHadcoins(address investor) external view returns (uint) {
        return equityHadcoins[investor];
    }

    // getting the equity in usd of an investor
    function equityInUsd(address investor) external view returns (uint) {
        return equityUsd[investor];
    }

    // buying hadcoins
    function buyHadcoins(address investor, uint usdInvested) external canBuyHadcoins(usdInvested) {
        uint hadcoinsBought = usdInvested * usdToHadcoins;
        equityHadcoins[investor] += hadcoinsBought;
        equityUsd[investor] = equityHadcoins[investor] / 1000;
        totalHadcoinsBought += hadcoinsBought;
    }

    // selling hadcoins
    function sellHadcoins(address investor, uint hadcoinsSold) external {
        require(equityHadcoins[investor] >= hadcoinsSold, "Not enough Hadcoins owned by the investor");
        uint usdEarned = hadcoinsSold * usdToHadcoins / 1000;
        equityHadcoins[investor] -= hadcoinsSold;
        equityUsd[investor] -= usdEarned;
        totalHadcoinsBought -= hadcoinsSold;
    }
}
