window.removeChild = removeChild;
window.addChild = addChild;
window.addAttribute = addAttribute;
window.removeAttribute = removeAttribute;
window.updateAttribute = updateAttribute;
window.addAttribute = addAttribute;

function removeChild (child, parent, index) {
  console.log("removeChild");
  console.log(child, parent, index);
}

function addChild (child, parent, index) {
  console.log("addChild");
  console.log(child, parent, index);
}

window.__screenSubs = {};

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

exports.onClick = function() {}

