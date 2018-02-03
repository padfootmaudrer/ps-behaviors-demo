window.EVENTS = {};

exports.setAttrImpl = function(element) {
  return function(attrList) {
    return function() {
      var key, value;
      var curried;
      var events = [];
      var fn = function(props) {console.log(props)};

      for (var i = 0; i < attrList.length; i++) {
        key = attrList[i].value0;
        value = attrList[i].value1.value0;

        if (typeof value == "function") {
          events.push({key: key, value: value});
        } else {
          element.props[key] = value;
        }
      }

      for (var i=0; i<events.length; i++) {
        curried = events[i].value(element.props);
        EVENTS[element.props.id] = fn;
        element.props[events[i].key] = curried;
      }

      window.El = element;
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

exports.onClick = function(props) {
  return function() {
    window.EVENTS[props.id](props);
  }
}
