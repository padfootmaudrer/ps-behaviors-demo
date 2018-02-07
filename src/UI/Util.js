function attachAttributeList(element, attrList) {
  var key, value;
  var curried;
  var events = [];
  var fn = function(props) {console.log(props)};

  var domNameIndex = -1;
  for (var i = 0; i < attrList.length; i++) {
    key = attrList[i].value0;
    value = attrList[i].value1.value0;

    if (key === "domName") {
      domNameIndex = i;
    }

    if (typeof value == "function") {
      // var screenName = attrList[domNameIndex].value1.value0.tag;
      // attachListener(element, screenName, key);
      events.push({key: key, value: value});
    } else {
      element.props[key] = value;
    }
  }
  for (var i=0; i<events.length; i++) {
    curried = events[i].value(element.props);
    element.props[events[i].key] = curried;
  }

  return null;
}

function attachListener(element, screenName, eventType) {
  element[eventType] = function(){
    window.__screenSubs[screenName](element.props);
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
      // console.log("cleanupAttributes");
      // console.log(element);
      // console.log(attrList);
    }
  }
}

exports.done = function() {
  console.log("done");
  return;
}

exports.logNode = function(node) {
  return function() {
    console.log(node);
  }
}

exports.storeMachine = function(machine) {
  return function() {
    window.MACHINE = machine;
  }
}

exports.getLatestMachine = function() {
  return window.MACHINE;
}

exports.getRootNode = function() {
  return {type: "linearLayout", props: {root: "true"}, children: []};
}


exports.insertDom = function(root) {
  return function(dom) {
    return function() {
      console.log("insertDom");
      root.children.push(dom);
      dom.parentNode = root;

      console.log(root);
    }
  }
}

exports.attachEvents = function(id) {
  return function(sub) {
    var elem = document.getElementsByTagName("body")[0];

    var cb = function() {
      sub(true)();
    }

    elem.addEventListener("click", cb);
  }
}


exports.initializeState = function() {
  if (!window.APP_STATE) {
    window.APP_STATE = {};
  }

  return null;
}

exports.updateState = function(key) {
  return function(value) {
    return function() {
      if (!window.APP_STATE) {
        window.APP_STATE = {};
      }

      window.APP_STATE[key] = value;

      return window.APP_STATE;
    }
  }
}

exports.getState = function() {
  if (!window.APP_STATE) {
    window.APP_STATE = {};
  }

  return window.APP_STATE;
}
