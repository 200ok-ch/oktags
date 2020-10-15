describe 'Managing tags on files' do
  before(:each) do
    @test_folder = '/tmp/oktags'
    FileUtils.mkdir @test_folder
    @test_file1 = "#{@test_folder}/foo"
    @test_file2 = "#{@test_folder}/bar.pdf"
    @test_file3 = "#{@test_folder}/baz--[foo,bar].pdf"
    FileUtils.touch @test_file1
    FileUtils.touch @test_file2
    FileUtils.touch @test_file3
  end

  after(:each) do
    FileUtils.remove_dir(@test_folder, true)
  end

  describe 'Adding tags to files' do
    it 'adds tags to files without extensions' do
      new_path = OK::Tags.add_tags_to_file('foo,bar', @test_file1)
      expect(new_path).to eq("#{@test_folder}/foo--[bar,foo]")
      expect(Dir.glob("#{@test_folder}/foo*")).to eq(
        ["#{@test_folder}/foo--[bar,foo]"]
      )
    end

    it 'adds tags to files with extensions' do
      new_path = OK::Tags.add_tags_to_file('foobar', @test_file2)
      expect(new_path).to eq("#{@test_folder}/bar--[foobar].pdf")
      expect(Dir.glob("#{@test_folder}/bar*")).to eq(
        ["#{@test_folder}/bar--[foobar].pdf"]
      )
    end
  end

  describe 'Listing tags for path' do
    it 'lists all the tags recursively' do
      tags = OK::Tags.find_tags_for(File.join(@test_folder, '**/*'))
      expect(tags).to eq(['foo', 'bar'].sort)
    end
  end

  describe 'Remove tags' do
    it 'Removes a tag from a file' do
      OK::Tags.delete_tag_from_file('foo', @test_file3)
      expect(Dir.glob("#{@test_folder}/*").sort).to eql(
        [
          "#{@test_folder}/baz--[bar].pdf",
          "#{@test_folder}/foo",
          "#{@test_folder}/bar.pdf"
        ].sort
      )
    end
  end

  describe 'Renaming tags' do
    it 'Finds files with old tags and modifies them to have the new tag instead' do
      OK::Tags.rename_tag(@test_folder, 'foo', 'tag1')
      expect(Dir.glob("#{@test_folder}/*").sort).to eq(
        [
          "#{@test_folder}/baz--[bar,tag1].pdf",
          "#{@test_folder}/foo",
          "#{@test_folder}/bar.pdf"
        ].sort
      )
    end

    it 'Finds files with old tags and modifies them to have the new tags instead' do
      OK::Tags.rename_tag(@test_folder, 'foo', 'tag1,tag2')
      expect(Dir.glob("#{@test_folder}/*").sort).to eq(
        [
          "#{@test_folder}/baz--[bar,tag1,tag2].pdf",
          "#{@test_folder}/foo",
          "#{@test_folder}/bar.pdf"
        ].sort
      )
    end
  end
end
