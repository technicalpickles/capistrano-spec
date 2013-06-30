shared_examples 'correct before callback' do
  it "won't raise error when `before` callback has occured for the given task" do
    expect do
      should callback('fake:thing').before(task_name)
    end.to_not raise_error(
      RSpec::Expectations::ExpectationNotMetError,
      /expected configuration to callback .*\s* before .*\s*, but did not/
    )
  end
end

shared_examples 'incorrect before callback' do
  it "will raise error when `before` callback hasn't occured for the given task" do
    expect do
      should_not callback('fake:thing').before(task_name)
    end.to_not raise_error(
      RSpec::Expectations::ExpectationNotMetError,
      /expected configuration to not callback .*\s* before .*\s*, but did/
    )
  end
end

shared_examples 'correct after callback' do
  it "won't raise error when `after` callback has occured for the given task" do
    expect do
      should callback('fake:thing').after(task_name)
    end.to_not raise_error(
      RSpec::Expectations::ExpectationNotMetError,
      /expected configuration to callback .*\s* after .*\s*, but did not/
    )
  end
end

shared_examples 'incorrect after callback' do
  it "will raise error when `after` callback hasn't occured for the given task" do
    expect do
      should_not callback('fake:thing').after(task_name)
    end.to_not raise_error(
      RSpec::Expectations::ExpectationNotMetError,
      /expected configuration to not callback .*\s* after .*\s*, but did/
    )
  end
end
