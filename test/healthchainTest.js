let catchRevert = require('./exceptionsHelpers.js').catchRevert
var HealthChain = artifacts.require('./HealthChain.sol')

contract('HealthChain', function (accounts) {
  const starterDoctors = [accounts[1], accounts[2], accounts[3]]
  const admins = [accounts[0], accounts[1]]

  const admin1 = accounts[0]
  const admin2 = accounts[1]
  const doctor1 = accounts[1]
  const doctor2 = accounts[2]
  const doctor3 = accounts[3]

  beforeEach(async () => {
    instance = await HealthChain.new(starterDoctors, admins)
  })

  it('admin1 should be an admin, doctor1 should be a doctor', async () => {
    const isAnAdmin = await instance.isAdmin.call(admin1, { from: admin1 })
    const isADoctor = await instance.isDoctor(doctor1, { from: admin1 })
    const docCount = await instance.getTotalDoctors({ from: admin1 })
    assert.equal(isAnAdmin, true, 'deployment was incorrect, check deploy_healthchain.js and/or constructor')
    assert.equal(isADoctor, true, 'deployment incorrect, check deploy_healthchain.js and/or constructor')
    assert.equal(docCount, 3, 'deployment incorrect, check deploy_healthchain.js for number of starterDoctors')
  })

  it('should not be able to enroll if an account already is a doctor', async () => {
    await catchRevert(instance.createDoctor(282, { from: doctor1 }))
  })

  it('successful adding of account[0] or admin1 as a doctor', async () => {
    var isADoctor = await instance.isDoctor(accounts[0], { from: admin1 })
    assert.equal(isADoctor, false, 'account[0] or admin1 should have not initiated as a doctor')
    await instance.createDoctor(212, { from: admin1 })
    isADoctor = await instance.isDoctor(accounts[0], { from: admin1 })
    assert.equal(isADoctor, true, 'createDoctor failed to add account[0] or admin1 as a doctor')
  })

  it('check deleteDoctor function, only admin can delete', async () => {
  	await instance.createDoctor(212, { from: accounts[4] })
  	await instance.createDoctor(342, { from: admin1 })
    var docCount = await instance.getTotalDoctors({ from: admin1 })
    assert.equal(docCount, 5, 'after having added 2 doctors, there should be 5 doctors now')
    await catchRevert(instance.deleteDoctor(212, accounts[4], { from: accounts[4] }))
    await instance.deleteDoctor(212, accounts[4], { from: admin1 })
    docCount = await instance.getTotalDoctors({ from: admin1 })
    assert.equal(docCount, 4, 'after deleting accounts[4] from doctors, there should be 4 doctors')
    var isADoctor = await instance.isDoctor(accounts[4], { from: admin1 })
    assert.equal(isADoctor, false, 'with successful delete failed to report account[4] as a doctor to be false')
  })
})
