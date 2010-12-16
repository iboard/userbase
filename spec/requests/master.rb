describe "sould get index" do
  it "routes / to welcome#index" do
    render
    rendered.should =~ /copyright/
  end
end
