window.berachain = {
    async connectWallet() {
        if (typeof window.ethereum === "undefined") {
            return { error: "MetaMask not found" };
        }
        try {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const chainId = await window.ethereum.request({ method: 'eth_chainId' });
            console.log("Account ID", accounts[0]);
            console.log("ChainID", chainId);
            return {
                account: accounts[0],
                chainId: chainId
            };
        } catch (err) {
            return { error: err.message };
        }
    },

    async getBlockNumber() {
        try {
            const result = await window.ethereum.request({ method: 'eth_blockNumber' });
            return parseInt(result, 16);
        } catch (err) {
            return -1;
        }
    }
};
