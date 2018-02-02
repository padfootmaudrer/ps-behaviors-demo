exports.setAttrImpl = function(element) {
  return function(attr) {
    return function() {
      console.log(element);
      console.log(attr);
      return "attr " + attr;
    }
  }
}

exports.appendChildToBody = function(node) {
  return function() {
    var body = document.getElementsByTagName("body");

    console.log(node);
    console.log("node");
    // body[0].appendChild(node);
  }
}

exports.getDoc = function() {
  console.log(document);
  return document;
}

exports.done = function() {
    console.log("done");
    return;
}

exports.logMy = function(node) {
  return function() {
    console.log("node");
    console.log(node);
  }
}
