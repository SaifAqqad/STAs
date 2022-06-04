function switchToTab(tabIndex, isFirstLoad = false) {
    const tabsContainer = document.querySelector('.tabs');
    const currentTab = {
        element: document.querySelector('.tab.tab-active'),
        index: document.querySelector('.tab.tab-active')?.getAttribute('data-tab-index'),
    }
    const nextTab = {
        element: document.querySelector(`.tab[data-tab-index="${tabIndex}"]`),
        index: tabIndex,
    }

    // emit tab-changing event to check if the tab is allowed to be switched
    const shouldChange = tabsContainer.dispatchEvent(new Event('tab-changing', {cancelable: true}));
    if (!shouldChange || !nextTab.element || (!currentTab.element && !isFirstLoad) || currentTab.index === tabIndex)
        return currentTab.index;

    // set correct animation
    if (currentTab.index < nextTab.index) {
        currentTab.animation = 'fadeOutLeft';
        nextTab.animation = 'fadeInRight';
    } else if (currentTab.index) {
        currentTab.animation = 'fadeOutRight';
        nextTab.animation = 'fadeInLeft';
    } else {
        nextTab.animation = 'fadeIn'
    }

    if (currentTab.element) {
        // animate then hide the current tab
        currentTab.element.classList.remove('tab-active');
        _animateCSS(currentTab.element, currentTab.animation).then(() => {
            currentTab.element.classList.add('tab-hidden');
        });
    }

    // scroll to the top of the page
    window.scrollTo({top: 0, behavior: 'smooth'});

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
    if (!activeTab) return;
    tabsContainer.style.minHeight = `${activeTab.offsetHeight}px`;
}

function getActiveTabIndex() {
    const activeTab = document.querySelector('.tab.tab-active');
    if (!activeTab) return -1;
    return Number(activeTab.getAttribute('data-tab-index'));
}