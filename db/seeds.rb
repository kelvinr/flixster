# vids =
#   [title: 'Family guy', description: 'A twisted comedy about an ignorant father and the adventures of his hilarious family.',
# small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy_large.jpg'],
#   [title: 'Futurama', description: 'What happens when a pizza delivery boy gets frozen and awakens 1000 years in the future? only to
# continue his career under Planet Express... Futurama!', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg'],
#   [title: 'Southpark', description: 'The sick, twisted and all around politcally incorrect animated series thats sure to make you laugh.',
# small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park_large.png'],
#   [title: 'Monk', description: 'A great comedy about a detective who uses his OCD and fear of germs to his advantage',
# small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg']
#
# Category.all.each do |category|
#   6.times do
#     category.videos << Fabricate(:video, vids.flatten.sample)
#   end
# end
categories = ['Comedy', 'Drama', 'Mystery', 'Classics', 'Romance', 'Action']

6.times do
  Fabricate(:category, name: categories.pop)
end

Fabricate(:user, email: "kelvin@example.com", password: "hunter", admin: true)
