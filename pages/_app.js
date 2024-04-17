import "../styles/globals.css";

//INTRNAL IMPORT
import { NavBar} from "../components/componentsindex";
import { NFTMarketplaceProvider } from "../Context/NFTMarketplaceContext";

const MyApp = ({ Component, pageProps }) => (
  <div>
    <NFTMarketplaceProvider>
      <NavBar />
      <Component {...pageProps} />
    </NFTMarketplaceProvider>
  </div>
);

export default MyApp;
