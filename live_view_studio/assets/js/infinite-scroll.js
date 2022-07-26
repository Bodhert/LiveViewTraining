const InfiniteScroll = {
        mounted() {
                console.log("Footer added to Dom", this.el);
                this.observer = new IntersectionObserver(entries => {
                        console.log(entries[0])
                        const entry = entries[0];
                        if (entry.isIntersecting) {
                                console.log("Footer is visible");
                                this.pushEvent("load-more");
                        }
                });

                this.observer.observe(this.el);
        },

        destroyed() {
                this.observer.disconnect();
        }
};

export default InfiniteScroll;
