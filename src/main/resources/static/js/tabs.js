function switchToTab(tabIndex) {
    const tabsContainer = document.querySelector('.tabs');
    const currentTab = {
        element: document.querySelector('.tab-active'),
        index: document.querySelector('.tab.tab-active')?.getAttribute('data-tab-index'),
    }
    const nextTab = {
        element: document.querySelector(`.tab[data-tab-index="${tabIndex}"]`),
        index: tabIndex,
    }
    if (!currentTab.element || !nextTab.element || currentTab.index === tabIndex)
        return currentTab.index;
    // set correct animation
    if (currentTab.index < nextTab.index) {
        currentTab.animation = 'fadeOutLeft';
        nextTab.animation = 'fadeInRight';
    } else {
        currentTab.animation = 'fadeOutRight';
        nextTab.animation = 'fadeInLeft';
    }
    // animate then hide the current tab
    currentTab.element.classList.remove('tab-active');
    _animateCSS(currentTab.element, currentTab.animation).then(() => {
        currentTab.element.classList.add('tab-hidden');
    });
    // show then animate the next tab
    nextTab.element.classList.remove('tab-hidden');
    _animateCSS(nextTab.element, nextTab.animation).then(() => {
        nextTab.element.classList.add('tab-active');
        updateTabsHeight();
    });
    // emit a new tab-changed event
    tabsContainer.dispatchEvent(new Event('tab-changed'));
    return nextTab.index;
}

function updateTabIndicators(tabIndex) {
    document.querySelectorAll("button[data-tab-index]").forEach(btn => {
        const isBtnDone = btn.getAttribute("data-tab-index") <= tabIndex;
        btn.classList[isBtnDone ? "add" : "remove"]('bg-primary', 'border-light');
        btn.classList[isBtnDone ? "remove" : "add"]('bg-transparent', 'border-primary');
    });
}

function updateTabsHeight() {
    const tabsContainer = document.querySelector('.tabs');
    const activeTab = document.querySelector('.tab-active');
    tabsContainer.style.minHeight = `${activeTab.offsetHeight}px`;
}

function getActiveTabIndex() {
    const activeTab = document.querySelector('.tab.tab-active');
    if (!activeTab) return -1;
    return Number(activeTab.getAttribute('data-tab-index'));
}