const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('SmartGuestBook', function () {
  let TexToken , texToken , owner, author1
  const NAME = 'TEXT'
  const SYMBOL = 'TXT'
  const TEXT_HASHED = ethers.utils.id('salut genius')
  const TEXT = 'salut genius'
  const URL="https://www.magnetgame.com/nft/salut genius";
  const TITLE ='TACPTER'
  const AUTHOR = 'GENIE'
  beforeEach(async function () {
    ;[owner, author1] = await ethers.getSigners()
    // ERC20 deployment
    TexToken = await ethers.getContractFactory('TexToken')
    texToken= await TexToken.connect(owner).deploy()
    await texToken.deployed()
  })

  // DEPLOYMENT
  describe('Deployment', function () {
    it('Should set name & symbol', async function () {
      expect(await texToken.name(), 'name').to.equal(NAME)
      expect(await texToken.symbol(), 'symbol').to.equal(SYMBOL)
    })
  })

  describe('Leave a comment', function () {
    
    beforeEach(async function () {
      await texToken
        .connect(author1)
        .certify(TEXT_HASHED, TEXT, URL, TITLE)
    })

    it('Should increase the balance of the author', async function () {
      expect(await texToken.balanceOf(author1.address)).to.equal(1)
    })

    it('Should have the right owner', async function () {
      expect(await texToken.ownerOf(0)).to.equal(author1.address)
    })

    it('should have the right URI', async function () {
      expect(await texToken.tokenURI(0)).to.equal(URL)
    })

  })

describe('burn a token', function(){
  beforeEach(async function () {
    await texToken
      .connect(author1)
      .certify(TEXT_HASHED, TEXT, URL, TITLE)

      await texToken
      .connect(author1)
      .burn(TEXT_HASHED, TEXT, URL, TITLE)
  })
  it('Should decrease the balance of the author', async function () {
    expect(await texToken.balanceOf(author1.address)).to.equal(0)
  })
})

})
