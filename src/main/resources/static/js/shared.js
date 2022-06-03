function _clearForm(form) {
    form.reset();
    form.querySelectorAll("input[type='hidden']").forEach(elem => elem.value = "");
    form.querySelectorAll("img").forEach((elem) => elem.src = "");
    form.querySelectorAll("select").forEach((elem) => elem.innerHTML = "");
    const csrfInput = form.querySelector("input[type='hidden'][name='_csrf']");
    if (csrfInput)
        csrfInput.value = document.querySelector("meta[name='_csrf']").getAttribute("content");
}

function _applyJsonToForm(formId, json) {
    for (const prop in json) {
        const elem = document.getElementById(formId + "_" + prop)
        if (elem) {
            elem.value = json[prop]
        }
    }
}

function _showElems(elems, show) {
    elems.forEach(element => element.classList[show ? "remove" : "add"]("d-none"))
}

function _assignDefaultValue(target, src) {
    for (const targetKey in target) {
        const value = target[targetKey];
        if (!src[targetKey]) {
            src[targetKey] = value
        }
    }
    return src
}

function _setPlaceholder(elem) {
    elem.src = elem.dataset.placeholder
}

function _updateAutoTextArea(textArea) {
    if (!(textArea instanceof HTMLElement))
        textArea = document.querySelector(textArea)
    textArea.style.height = '4rem';
    textArea.style.height = textArea.scrollHeight + 'px';
}

function _setupAutoTextArea(textArea) {
    if (!(textArea instanceof HTMLElement))
        textArea = document.querySelector(textArea)
    // set initial textarea height
    textArea.setAttribute("style", "height:4rem;overflow-y:hidden;")
    // textarea onInput
    textArea.addEventListener("input", _updateAutoTextArea.bind(this, textArea))
}

function _animateCSS(element, animation, prefix = 'animate__') {
    return new Promise((resolve) => {
        const animationName = `${prefix}${animation}`;
        const node = element instanceof Element ? element : document.querySelector(element);
        node.classList.add(`${prefix}animated`, animationName);
        document.querySelector("body").classList.add("overflow-hidden");

        function handleAnimationEnd(event) {
            event.stopPropagation();
            node.classList.remove(`${prefix}animated`, animationName);
            document.querySelector("body").classList.remove("overflow-hidden");
            resolve('Animation ended');
        }

        node.addEventListener('animationend', handleAnimationEnd, {once: true});
    });
}

function _sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function _getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min);
}
