/**
 * ************ This is an experimental dev feature ************
 *
 * Ready to use variables:
 * - web3
 * - {varName} with the contract chosed
 *
 * For More info check:
 * https://web3js.readthedocs.io/en/v1.2.2/web3-eth-contract.html#web3-eth-contract
 *
 * Web3 doc:
 * https://web3js.readthedocs.io/en/v1.2.2/
 *
 * The value returned should be convertible to a JSON string.
 *
 * Feedback is welcome :)
 */

 async function main() {

    // const name = await HODLPigs.methods.unpause().send({ from: '0xB3d9B324ff277E26a93D391F11c10985f3675bFf' })
  
    // const name = await HODLPigs.methods.mintPig(1).send({ from: '0xa0E58B0Af706375f0B5e30b682908C3888e59480', value: 25000000000000000 })
  
    // const name = await HODLPigs.methods.saleLedger().call().catch(console.log)
    const name = await HODLPigs.methods.totalSupply().call().catch(console.log)
  
    // const name = await HODLPigs.methods.deposit(0).send({ from: '0xB3d9B324ff277E26a93D391F11c10985f3675bFf', value: 69000000000000000 })
  
    // const name = await HODLPigs.methods.transferFrom('0xB3d9B324ff277E26a93D391F11c10985f3675bFf', '0xa0E58B0Af706375f0B5e30b682908C3888e59480', 0).send({ from: '0xB3d9B324ff277E26a93D391F11c10985f3675bFf' }).then(console.log).catch(console.log)
  
    // const name = await HODLPigs.methods.crackPig(0).send({ from: '0xB3d9B324ff277E26a93D391F11c10985f3675bFf' })
  
    // const name = await HODLPigs.methods.crackPig(0).send({ from: '0xa0E58B0Af706375f0B5e30b682908C3888e59480' }).then(console.log).catch(console.log)
    // const name = await HODLPigs.methods.crackPig(0).send({ from: '0xB3d9B324ff277E26a93D391F11c10985f3675bFf' }).then(console.log).catch(console.log)
  
  
    return name
  
  }
  