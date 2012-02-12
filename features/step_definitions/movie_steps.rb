# Add a declarative step here for populating the DB with movies.


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    puts movie
    m = Movie.new(:title=>movie["title"], :rating=>movie["rating"], :release_date=>movie["release_date"])
    test = m.save
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #matchPattern = /.*#{e1}.*#{e2}/
  matchPattern1 = /#{e1}/
  matchPattern2 = /#{e2}/
  wholePage = page.body
  restOfPage = wholePage[wholePage=~matchPattern1..-1]
  restOfPage.should =~ matchPattern2
end

Then /I should see the following movies in this order: (.*)/ do |movies_list|
  mlist = movies_list.split(',')
  for i in 0..mlist.length-2
    step %Q{I should see "#{mlist[i]}" before "#{mlist[i+1]}"}
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split
  ratings.each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

#Check which movies are and aren't showing
Then /I should (not )?see (all|any) of the movies (.*)/ do |negate, allany, movies|
  mList = movies.split(',')
  mList.each do|m|
    step %Q{I should #{negate}see #{m.strip}}
  end
end
