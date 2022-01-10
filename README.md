# ERC721 Example Collection
An example ERC721 collection
# Features
Incrementing token IDs
A static mint price
Opensea compatibility
Limited supply, current contract only allows the minting of 6 NFTs.
Withdrawable funds (Of course)
# How To "Launch"
I recommend using Pinata.cloud for storing your NFT data.
1. Upload as a folder the images folder to Pinata.
2. Each json file will have a ```"image": "ipfs://(CID)/(tokenID)"``` entry in it, in each json file replace the old  ```(CID)``` portion with the CID of the images folder that you uploaded to Pinata, leave the token ID as is.
3. Upload as a folder the json folder to Pinata.
4. Open the smart contract and replace the CID inside of the ```return "ipfs://QmP6o3FdohRZFE3UV5uCzSvgfdfkw9yJiS95t6kiHVYFKv/";``` line with the CID of the json folder you uploaded.
5. The contract should be completely fine to deploy, and anything minted will show up on opensea.
