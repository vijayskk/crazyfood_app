addToCart(Map item, List cart) {
  bool isFind = false;
  if (cart.isNotEmpty) {
    for (var i = 0; i < cart.length; i++) {
      Map current = cart[i];
      if (current["item"]["objectID"] == item["objectID"]) {
        current["quantity"] = current["quantity"] + 1;
        isFind = true;
        break;
      }
    }
  }
  if (!isFind) {
    cart.add({"item": item, "quantity": 1});
  }
  return cart;
}

removeFromCart(Map item, List cart) {
  if (cart.isNotEmpty) {
    for (var i = 0; i < cart.length; i++) {
      Map current = cart[i];
      if (current["item"]["objectID"] == item["objectID"]) {
        if (current["quantity"] > 1) {
          current["quantity"] = current["quantity"] - 1;
        } else {
          cart.remove(current);
        }
        break;
      }
    }
    return cart;
  } else {
    return [];
  }
}

removeAllFromCart(Map item, List cart) {
  if (cart.isNotEmpty) {
    for (var i = 0; i < cart.length; i++) {
      Map current = cart[i];
      if (current["item"]["objectID"] == item["objectID"]) {
        cart.remove(current);
        break;
      }
    }
    return cart;
  } else {
    return [];
  }
}

checkAvailable(Map item, List cart) {
  bool isFind = false;
  if (cart.isNotEmpty) {
    for (var i = 0; i < cart.length; i++) {
      Map current = cart[i];
      if (current["item"]["objectID"] == item["objectID"]) {
        isFind = true;
        return current["quantity"];
      }
    }
  }
  if (!isFind) {
    return null;
  }
}

int getTotal(List cart) {
  if (cart.isNotEmpty) {
    int total = 0;
    for (var i = 0; i < cart.length; i++) {
      Map current = cart[i];
      total = total +
          int.parse(current["item"]["itemprice"]) *
              int.parse(current["quantity"].toString());
    }
    return total;
  } else {
    return 0;
  }
}
