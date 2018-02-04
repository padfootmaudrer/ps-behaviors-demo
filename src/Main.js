window.EVENTS = {};

function addAttribute (element, attribute) {
  console.log("addAttribute");
  console.log(element, attribute);
}

function removeAttribute (element, attribute) {
  console.log("removeAttribute");
  console.log(element, attribute);
}

function updateAttribute (element, attribute) {
  console.log("updateAttribute");
  console.log(element, attribute);
}

function attachAttributeList(element, attrList) {
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

exports.appendChildToBody = function(node) {
  return function() {
    var body = document.getElementsByTagName("body");

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

exports.applyAttributes = function(element) {
  return function(attrList) {
    return function() {
      attachAttributeList(element, attrList);
      return null;
    }
  }
}

exports.patchAttributes = function(element) {
  return function(oldAttrList) {
    return function(newAttrList) {
      return function() {

        var attrFound = 0;

        for (var i=0; i<oldAttrList.length; i++) {
          attrFound = 0;
          for (var j=0; j<newAttrList.length; j++) {
            if (oldAttrList[i].value0 == newAttrList[j].value0) {
              attrFound = 1;

              if (oldAttrList[i].value1.value0 !== newAttrList[j].value1.value0) {
                updateAttribute(element, newAttrList[j]);
              }
            }
          }

          if (!attrFound) {
            removeAttribute(element, oldAttrList[i]);
          }
        }

        for (var i=0; i<newAttrList.length; i++) {
          attrFound = 0;
          for (var j=0; j<oldAttrList.length; j++) {

            if (oldAttrList[j].value0 == newAttrList[i].value0) {
              attrFound = 1;
            }
          }

          if (!attrFound) {
            addAttribute(element, newAttrList[i]);
          }
        }
      }
    }
  }
}

exports.cleanupAttributes = function(element) {
  return function(attrList) {
    return function() {
      console.log("cleanupAttributes");
      console.log(element);
      console.log(attrList);
    }
  }
}
