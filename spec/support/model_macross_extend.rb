module ModelMacrosExtend
  def it_includes_votable_concern
    describe 'includes Votable concern' do
      it { expect(described_class.included_modules.include?(Votable)).to eq(true) }
    end
  end
end
