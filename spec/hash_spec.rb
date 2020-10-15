describe 'Hash.safe_invert' do
  it 'inverts trivial hashes' do
    expect({ 1 => 2 }.safe_invert).to eq({ 2 => 1 })
  end

  it 'inverts hashes with arrays as values' do
    expect({ 1 => [2] }.safe_invert).to eq({ 2 => 1 })
  end

  it 'inverts hashes with arrays as values and multiple keys' do
    expect({ 1 => [2], 2 => [2] }.safe_invert).to eq({ 2 => [1, 2] })
  end

  it 'inverts hashes with arrays as values and multiple keys and merges values under keys' do
    expect({ 1 => [1, 2], 3 => [2, 1] }.safe_invert).to eq(
      { 1 => [1, 3], 2 => [1, 3] }
    )
  end
end
