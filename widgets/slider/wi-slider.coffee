
lookupElementByClassName: (node, className) ->
    unless result: node.getElementsByClassName(className)[0]
        result: document.createElement('div')
        result.className: className
        node.appendChild result
    result

isDescendant: (descendant, ancestor) ->
    descendant and (descendant is ancestor or isDescendant(descendant.parentNode, ancestor))

isMouseCrossingOuterBoundary: (event, node) ->
    isDescendant(event.target, node) and not isDescendant(event.relatedTarget, node)


class WiSlider

    constructor: (node) ->
        this.node:  node
        this.left:  lookupElementByClassName node, 'wi-track-left'
        this.right: lookupElementByClassName node, 'wi-track-right'
        this.knob:  lookupElementByClassName node, 'wi-knob'
        this.knobWidth: this.knob.offsetWidth

        this.min:   parseFloat(node.getAttribute('data-wi-min') || '0')
        this.max:   parseFloat(node.getAttribute('data-wi-max') || '100')
        this.value: parseFloat(node.getAttribute('data-wi-value') || '50')

        for eventName in ['mousedown', 'mousemove', 'mouseup', 'mouseout', 'touchmove', 'touchend', 'touchcancel']
            this.node.addEventListener eventName, this, false
        this.knob.addEventListener 'touchstart', this, false

        this.node.wi: this
        this.layout()

    setValue: (value) ->
        this.value: Math.min(this.max, Math.max(this.min, value))
        this.layout()

    layout: ->
        width:  @node.offsetWidth - this.knobWidth
        center: (@value - @min) * width / (@max - @min)

        # @knob.style.webkitTransform: "translate3d(${center - knobW/2}px, 0px, 0px)"
        @knob.style.left:   "${center}px"
        @left.style.width:  "${center + this.knobWidth/2}px"
        @right.style.width: "${width - center + this.knobWidth/2}px"
        
    fireChanged: ->
        event: document.createEvent('Event')
        event.initEvent 'wi-changed', true, false
        event.value: this.value
        this.node.dispatchEvent event

    handleEvent: (event) ->
        this[event.type](event)
    
    moveKnobTo: (pageX) ->
        delta: (pageX - this.startX) / (@node.offsetWidth - this.knobWidth) * (@max - @min)
        this.setValue(this.startValue + delta)
        this.fireChanged()
    
    mousedown: (event) ->
        if event.target is this.knob
            this.startX: event.pageX
            this.startValue: this.value
            this.dragging: yes
        else
            

    mousemove: (event) ->
        if this.dragging
            this.moveKnobTo event.pageX

    mouseup: (event) ->
        this.dragging: no

    mouseleave: (event) ->
        this.dragging: no

    mouseout: (event) ->
        this.mouseleave(event) if isMouseCrossingOuterBoundary event, this.node

    touchstart: (event) ->
        this.startX: event.targetTouches[0].pageX
        this.startValue: this.value
        this.dragging: yes
        event.preventDefault()  # avoid scrolling

    touchmove: (event) ->
        if this.dragging
            this.moveKnobTo event.targetTouches[0].pageX
    
    touchend: (event) ->
        this.dragging: no
    
    touchcancel: (event) ->
        this.dragging: no


hookSliders: ->
    for node in document.getElementsByClassName 'wi-slider'
        new WiSlider node

document.addEventListener('DOMContentLoaded', hookSliders, false)
