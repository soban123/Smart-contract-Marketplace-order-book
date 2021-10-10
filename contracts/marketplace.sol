// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract OrderBook {
    struct Sell_Data {
        string name;
        uint256 demandPrice;
    }

    struct Buy_Data {
        string name;
        uint256 offerPrice;
    }

    Sell_Data[] public sellData;

    Buy_Data[] public buyData;

    function sellerOrder(uint256 demandPrice, string memory assetName) public {
        sellData.push(Sell_Data({name: assetName, demandPrice: demandPrice}));
        matchOrder();
    }

    function buyOrder(uint256 offerPrice, string memory assetName) public {
        buyData.push(Buy_Data({name: assetName, offerPrice: offerPrice}));
        matchOrder();
    }

    function getLength() public view returns (uint256, uint256) {
        return (sellData.length, buyData.length);
    }

    function removeOrderAtIndex(uint256 buyIndex, uint256 sellIndex) internal {
        buyData[buyIndex] = buyData[buyData.length - 1];
        delete buyData[buyData.length - 1];
        //   buyData.pop();

        sellData[sellIndex] = sellData[sellData.length - 1];
        delete sellData[sellData.length - 1];
        //   sellData.pop();// dosnot work maybe because of version
    }

    function matchOrder() public returns (string memory) {
        for (uint256 i = 0; i < buyData.length; i++) {
            for (uint256 j = 0; j < sellData.length; j++) {
                if (
                    keccak256(bytes(buyData[i].name)) ==
                    keccak256(bytes(sellData[j].name)) &&
                    buyData[i].offerPrice == sellData[j].demandPrice
                ) {
                    removeOrderAtIndex(i, j);

                    return "success";
                }
            }
        }

        return "Not Found";
    }
}
