import React, { useEffect, useState, useContext } from "react";

//INTERNAL IMPORT
import Style from "../styles/upload-nft.module.css";
import { UploadNFT } from "../UploadNFT/uploadNFTIndex";

//SMART CONTRACT IMPORT
import { NFTMarketplaceContext } from "../Context/NFTMarketplaceContext";

const uploadNFT = () => {
  const [tokenType, setTokenType] = useState('ERC721'); 
  const { uploadToIPFS, createNFT, uploadToPinata } = useContext(
    NFTMarketplaceContext
  );

  const handleCreateToken = () => {
    if (tokenType === 'ERC721') {
      // 执行创建ERC721代币的操作
      createNFT('ERC721');
    } else if (tokenType === 'ERC1155') {
      // 执行创建ERC1155代币的操作
      createNFT('ERC1155');
    }
  };


  return (
    <div className={Style.uploadNFT}>
      <div className={Style.uploadNFT_box}>
        <div className={Style.uploadNFT_box_heading}>
          <h1>Create New NFT</h1>
        </div>

        <div className={Style.uploadNFT_box_title}>
          <h2>Choose your token Types</h2>
        </div>

        <div className={Style.uploadNFT_box_form}>
          <button onClick={() => setTokenType('ERC721')} className={tokenType === 'ERC721' ? Style.selected : null}>ERC721</button>
          <button onClick={() => setTokenType('ERC1155')} className={tokenType === 'ERC1155' ? Style.selected : null}>ERC1155</button>
        </div>

        <div className={Style.uploadNFT_box_form}>
          <UploadNFT
            uploadToIPFS={uploadToIPFS}
            createNFT={createNFT}
            uploadToPinata={uploadToPinata}
          />
        </div>
      </div>
    </div>
  );
};

export default uploadNFT;
