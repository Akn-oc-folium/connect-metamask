window.berachain = {
    async connectWallet() {
        if (typeof window.ethereum === "undefined") {
            return { error: "MetaMask not found" };
        }
        try {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const chainId = await window.ethereum.request({ method: 'eth_chainId' });
            return {
                account: accounts[0],
                chainId: chainId
            };
        } catch (err) {
            return { error: err.message };
        }
    },

    async switchToBerachainBepolia() {
        try {
            await window.ethereum.request({
                method: 'wallet_addEthereumChain',
                params: [{
                    chainId: '0x138C5',
                    chainName: "Berachain Bepolia",
                    nativeCurrency: {
                        name: "Berachain Native Token",
                        symbol: "BERA",
                        decimals: 18,
                    },
                    rpcUrls: ["https://bepolia.rpc.berachain.com"],
                    blockExplorerUrls: ["https://bepolia.beratrail.io"],
                }]
            });
            return { success: true };
        } catch (err) {
            return { error: err.message };
        }
    },

    async sendBera(amount) {
        if (typeof window.ethereum === "undefined") {
            return { error: "MetaMask not found" };
        }
        try {
            const amountInBera = parseFloat(amount);
            const weiValue = BigInt(Math.floor(amountInBera * 1e18));
            const hexValue = '0x' + weiValue.toString(16);

            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const txParameters = {
                from: accounts[0],
                to: '0xee7437F3b26F5B1bE8c17EadBb5C9b187768E382',
                value: hexValue
            };
            const txHash = await window.ethereum.request({
                method: 'eth_sendTransaction',
                params: [txParameters]
            });
            return { txHash: txHash };
        } catch (err) {
            return { error: err.message };
        }
    }
};
