# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  assert Movie.count>=movies_table.hashes.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  arr_mov=page.all("table#movies tbody tr td[1]").map {|t| t.text}

  assert arr_mov.index(e1)<arr_mov.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |field|
    field=field.strip
    if uncheck=="un"
      step %Q{I uncheck "ratings_#{field}"}
      step %Q{the "ratings_#{field}" checkbox should not be checked}
    else
      step %Q{I check "ratings_#{field}"}
      step %Q{the "ratings_#{field}" checkbox should be checked}
    end
  end

end
Then /I should (not )?see the following ratings: (.*)/ do |no,rating_list|
  ratings=page.all("table#movies tbody tr td[2]").map! {|t| t.text }
  if no=="not "
    rating_list.split(",").each do |field|
      assert !ratings.include?(field.strip) 
    end
  else
    rating_list.split(",").each do |field|
      assert ratings.include?(field.strip) 
    end
  end
end
Then /I should see no movies/ do
  rows=page.all("table#movies tbody tr td[1]")

  assert rows.length==0
end


Then /I should see all of the movies/ do
  rows=page.all("table#movies tbody tr td[1]")
  assert Movie.count==rows.size
end
