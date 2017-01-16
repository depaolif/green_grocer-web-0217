require "pry"

def consolidate_cart(cart)
  # code here
  res = {}
  cart.each do |item|
  	name = item.keys[0]
  	if !res.keys.include?(name)
  		res[name] = item[name]
  		res[name][:count] = 1
  	else
  		res[name][:count] += 1
  	end
  end
  res
end

def apply_coupons(cart, coupons)
  # code here

  # first create couponed items and subtract
  if !coupons.is_a?(Array)
  	coupons = [coupons]
  end

  # for each coupon,
  coupons.each do |coupon|
  	# only matters if the coupon can apply to the cart
  	if cart.keys.include?(coupon[:item])
  	# check if  there are enough items per coupons
	  	while cart[coupon[:item]][:count] >= coupon[:num]
	  		# then, subtract the number of coupons from the main item
	  		cart[coupon[:item]][:count] -= coupon[:num]
	  		# and create a new, couponed item that many times
	  		cart["#{coupon[:item]} W/COUPON"] = {
	  			:price => coupon[:cost],
	  			:clearance => cart[coupon[:item]][:clearance],
	  			:count => cart["#{coupon[:item]} W/COUPON"] ? cart["#{coupon[:item]} W/COUPON"][:count] + 1 : 1
	  		}
	  	end
	end

  end
  cart
end


def apply_clearance(cart)
  # code here
  cart.each do |item,values|
  	if values[:clearance] == true
  		cart[item][:price] *= 0.8
  		cart[item][:price] = cart[item][:price].round(1)
  	end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each do |item, values|
  	total += values[:count] * values[:price]
  end

  return total > 100 ? total * 0.9 : total
end
