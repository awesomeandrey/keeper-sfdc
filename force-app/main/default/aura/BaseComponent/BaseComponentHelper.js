({
    isDesignMode: function () {
        return document
            .location
            .href
            .toLowerCase()
            .indexOf("flexipageeditor") >= 0;
    },
});