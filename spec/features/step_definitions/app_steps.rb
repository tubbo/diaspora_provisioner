def visit_root
  visit '/'
end

Given /^I am on the home page$/ do
  visit_root
end

Given /^I follow "(.*?)"$/ do |text|
  click_link text
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content text
end