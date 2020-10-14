load 'okfiletags'

describe "Managing tags on files" do
  before(:each) do
    @test_folder = '/tmp/okfiletags_mau'
    FileUtils.remove_dir(@test_folder, true)
    FileUtils.mkdir @test_folder
    @test_file1 = "#{@test_folder}/foo"
    @test_file2 = "#{@test_folder}/bar.pdf"
    FileUtils.touch @test_file1
    FileUtils.touch @test_file2
  end

  describe "Adding tags to files" do

    it "adds tags to files without extensions" do
      new_path = add_tags_to_file("foo,bar", @test_file1)
      expect(new_path).to eq("#{@test_folder}/foo--bar,foo")
      expect(Dir.glob("#{@test_folder}/foo*")).to eq(["#{@test_folder}/foo--bar,foo"])
    end

    it "adds tags to files with extensions" do
      new_path = add_tags_to_file("foobar", @test_file2)
      expect(new_path).to eq("#{@test_folder}/bar--foobar.pdf")
      expect(Dir.glob("#{@test_folder}/bar*")).to eq(["#{@test_folder}/bar--foobar.pdf"])
    end
  end
end
