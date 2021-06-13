class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

      
    if req.path.match(/gifts/) 
      
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        user_id = req.path.split("/users/").last.split('/gifts').first
        user = User.find_by(id: user_id)
        gift = user.gifts.create(name: input["name"])
        return [200, { 'Content-Type' => 'application/json' }, [ gift.to_json ]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        user_id = req.path.split("/users/").last.split('/gifts/').first
        user = User.find_by(id: user_id)
        gift_id = req.path.split('/gifts/').last
        user_gift = user.gifts.find_by(id: gift_id)
        user_gift.destroy()
      end

    elsif req.path.match(/users/)
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        user = User.create(name: input["name"])
        return [200, { 'Content-Type' => 'application/json' }, [ user.to_json ]]
      else
        if req.path.split("/users").length == 0 
          return [200, { 'Content-Type' => 'application/json' }, [ User.all.to_json ]]
        else
          user_id = req.path.split("/users/").last
          return [200, { 'Content-Type' => 'application/json' }, [ User.find_by(id: user_id).to_json({:include => :gifts})]]
        end
      end
    
    else
      resp.write "Path Not Found"
        
    end

    resp.finish
  end

end
