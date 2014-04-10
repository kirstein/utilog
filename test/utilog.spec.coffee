mod = require "#{process.cwd()}/src/utilog"

describe 'utilog', ->
  it 'should exist', ->
    mod.should.be.ok

  describe '#hello', ->
    it 'should return the right value', ->
      mod.hello().should.eql 'hello utilog'


