const prestoDayum = require("presto-ui").doms;
const parseParams = require("presto-ui").helpers.web.parseParams;


function domAll(elem) {
  for (var i = 0; i < elem.children.length; i++) {
    elem.children[i] = domAll(elem.children[i]);
  }
  return prestoDayum(elem.type, elem.props, elem.children);
}

function applyProp(element, attribute) {
  var prop = {
    id: element.props.id
  }
  debugger;
  prop[attribute.value0] = attribute.value1.value0;
  Android.runInUI(parseParams("linearLayout", prop, "set"));
}

window.removeChild = removeChild;
window.addChild = addChild;

function removeChild (child, parent, index) {
  debugger;
  console.log("removeChild");
  Android.removeView(child.props.id);
  console.log(child, parent, index);
}

function addChild (child, parent, index) {
  console.log("addChild");
  Android.addViewToParent(parent.props.id, domAll(child), index);
  console.log(child, parent, index);
}

window.__screenSubs = {};

function addAttribute (element, attribute) {
  console.log("addAttribute");
  applyProp(element, attribute);
}

function removeAttribute (element, attribute) {
  console.log("removeAttribute");
  console.log(element, attribute);
}

function updateAttribute (element, attribute) {
  console.log("updateAttribute");
  applyProp(element, attribute);
}

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
      var screenName = attrList[domNameIndex].value1.value0.tag;
      attachListener(element, screenName, key);
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

exports.getRootNode = function() {
  return {type: "linearLayout", props: {root: "true"}, children: []};
}

exports.done = function() {
    console.log("done");
    return;
}

exports.logMy = function(node) {
  return function() {
    console.log("current Node");
    console.log(node);
    window.__n = node;
  }
}

exports.onClick = function() {
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

exports.attachSub = function(screenJSON) {
  return function(sub) {
    window.__screenSubs[screenJSON.tag] = sub;
  }
}

exports.insertDom = function(root) {
  return function(dom) {
    return function() {
      console.log("insertDom");
      Android.Render(domAll(dom));
      root.children.push(dom);
      dom.parentNode = root;

      console.log(root);
    }
  }
}
