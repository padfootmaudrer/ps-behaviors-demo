exports.setAttrImpl = function(element) {
  return function(attrList) {
    return function() {
      for (var i = 0; i < attrList.length; i++) {
        element.props[attrList[i].value0] = attrList[i].value1;
      }

      console.log(element);
      return null;
    }
  }
}

exports.appendChildToBody = function(node) {
  return function() {
    var body = document.getElementsByTagName("body");

    console.log(node);

    body[0].appendChild(node);
  }
}

exports.getDoc = function() {
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
