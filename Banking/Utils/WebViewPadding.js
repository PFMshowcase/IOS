
// MARK: Adding padding as view will ignore safe areas

javascript:(function() {
    const view = document.getElementById('main_wrapper');
    const windowHeight = window.innerHeight;
    const padding = 100;
    
//    Giving padding to the top of the view
    view.style.setProperty('padding-top', '100px');
    view.style.setProperty('padding-bottom', '100px');
    
    view.style.setProperty('position', 'relative')
    
//    Give all children that have `position: absolute` that are in the `main_wrapper` div provided css
    function give_absolute_child_styles(children, property, value) {
        for (let i = 0; i < children.length; i++) {
            const child = children[i]
            const computedStyle = getComputedStyle(child)
            if (computedStyle.position === "absolute") {
                child.style.setProperty(property, value)
            }
            give_absolute_child_styles(child.children, property, value)
        }
    }
    
//    Call the above function setting the children to have `padding: inherit`
    give_absolute_child_styles(view.children, "padding-bottom", '100px')
})()
