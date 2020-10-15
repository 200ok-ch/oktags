describe 'Managing tags on files' do
  before(:each) do
    # suppress stdout (`puts` statements are only for console use)
    $stdout = StringIO.new

    @test_folder = '/tmp/oktags'
    FileUtils.mkdir @test_folder
    @test_file1 = "#{@test_folder}/foo"
    @test_file2 = "#{@test_folder}/bar.pdf"
    @test_file3 = "#{@test_folder}/baz--[foo,bar].pdf"
    @test_file4 = "#{@test_folder}/foobar--[foo,bar,baz].pdf"
    FileUtils.touch @test_file1
    FileUtils.touch @test_file2
    FileUtils.touch @test_file3
    FileUtils.touch @test_file4
  end

  after(:each) { FileUtils.remove_dir(@test_folder, true) }

  describe 'Adding tags to files' do
    it 'adds tags to files without extensions' do
      new_path = OK::Tags.add_tags_to_file('foo,bar', @test_file1)
      expect(new_path).to eq("#{@test_folder}/foo--[bar,foo]")
      expect(Dir.glob("#{@test_folder}/foo--*")).to eq(
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

    it 'spaces in tags are replaced by underscores' do
      new_path = OK::Tags.add_tags_to_file('foo bar', @test_file2)
      expect(new_path).to eq("#{@test_folder}/bar--[foo_bar].pdf")
      expect(Dir.glob("#{@test_folder}/bar*")).to eq(
        ["#{@test_folder}/bar--[foo_bar].pdf"]
      )
    end
  end

  describe 'Search for files with tags' do
    it 'lists all files grouped by tag' do
      files = OK::Tags.search_files_with_tags(File.join(@test_folder, '**/*'))
      expect(files).to eq(
        {
          'bar' => [
            "#{@test_folder}/baz--[foo,bar].pdf",
            "#{@test_folder}/foobar--[foo,bar,baz].pdf"
          ],
          'foo' => [
            "#{@test_folder}/baz--[foo,bar].pdf",
            "#{@test_folder}/foobar--[foo,bar,baz].pdf"
          ],
          'baz' => ["#{@test_folder}/foobar--[foo,bar,baz].pdf"]
        }
      )
    end

    it 'returns an empty list for unknown tags' do
      files =
        OK::Tags.list_files_with_tags(
          'unknown_tag',
          File.join(@test_folder, '**/*')
        )
      expect(files).to eq([])
    end

    it 'lists all files for a given tag' do
      files =
        OK::Tags.list_files_with_tags('foo', File.join(@test_folder, '**/*'))
      expect(files).to eq(
        [
          "#{@test_folder}/baz--[foo,bar].pdf",
          "#{@test_folder}/foobar--[foo,bar,baz].pdf"
        ]
      )
    end

    describe 'multiple tags' do
      it 'lists all matching files given multiple tags' do
        files =
          OK::Tags.list_files_with_tags(
            'foo,bar',
            File.join(@test_folder, '**/*')
          )
        expect(files).to eq(
          [
            "#{@test_folder}/baz--[foo,bar].pdf",
            "#{@test_folder}/foobar--[foo,bar,baz].pdf"
          ]
        )
      end

      it 'works no matter in which order tags are given' do
        files =
          OK::Tags.list_files_with_tags(
            'bar,foo',
            File.join(@test_folder, '**/*')
          )
        expect(files).to eq(
          [
            "#{@test_folder}/baz--[foo,bar].pdf",
            "#{@test_folder}/foobar--[foo,bar,baz].pdf"
          ]
        )
      end

      it 'restricts results to given path' do
        files =
          OK::Tags.list_files_with_tags(
            'bar,foo',
            File.join(@test_folder, '**/baz*')
          )
        expect(files).to eq(["#{@test_folder}/baz--[foo,bar].pdf"])
      end

      it 'works with three tags, too' do
        files =
          OK::Tags.list_files_with_tags(
            'foo,bar,baz',
            File.join(@test_folder, '**/*')
          )
        expect(files).to eq(["#{@test_folder}/foobar--[foo,bar,baz].pdf"])
      end

      it 'requires all tags to match' do
        files =
          OK::Tags.list_files_with_tags(
            'foo,unknown_tag',
            File.join(@test_folder, '**/*')
          )
        expect(files).to eq([])
      end
    end
  end

  describe 'Listing tags for path' do
    it 'lists all the tags recursively' do
      tags = OK::Tags.find_tags_for(File.join(@test_folder, '**/*'))
      expect(tags.uniq).to eq(%w[foo bar baz].sort)
    end
  end

  describe 'Remove tags' do
    it 'Removes a tag from a file' do
      OK::Tags.delete_tag_from_file('foo', @test_file3)
      expect(Dir.glob("#{@test_folder}/*").sort).to eql(
        [
          "#{@test_folder}/baz--[bar].pdf",
          "#{@test_folder}/foo",
          "#{@test_folder}/bar.pdf",
          "#{@test_folder}/foobar--[foo,bar,baz].pdf"
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
          "#{@test_folder}/bar.pdf",
          "#{@test_folder}/foobar--[bar,baz,tag1].pdf"
        ].sort
      )
    end

    it 'Finds files with old tags and modifies them to have the new tags instead' do
      OK::Tags.rename_tag(@test_folder, 'foo', 'tag1,tag2')
      expect(Dir.glob("#{@test_folder}/*").sort).to eq(
        [
          "#{@test_folder}/baz--[bar,tag1,tag2].pdf",
          "#{@test_folder}/foo",
          "#{@test_folder}/bar.pdf",
          "#{@test_folder}/foobar--[bar,baz,tag1,tag2].pdf"
        ].sort
      )
    end
  end
end
