class Game < ApplicationRecord

  # consumes two coordinates, outputs distance between in kilometers
  # http://www.geodatasource.com/developers/javascript
  def distance_between (long1, long2, lat1, lat2)
    radlat1 = Math.PI * lat1/180
  	radlat2 = Math.PI * lat2/180
  	theta = lon1-lon2
  	radtheta = Math.PI * theta/180
  	dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
  	dist = Math.acos(dist)
  	dist = dist * 180/Math.PI
  	dist = dist * 60 * 1.1515
    dist = dist * 1.609344
  	return dist
  end

  # consumes radius of center, r, and distance, d, between user and center
  def proximity (r, d)
    if d < r
      return true
    else
      return false
  end


end
