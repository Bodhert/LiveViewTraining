import flatpickr from "flatpickr";

const DatePicker = {
    mounted() {
        console.log("se montó")
        flatpickr(this.el, {
            enableTime: false,
            dateFormat: "F d, Y",
            onChange: this.handleDatePicked.bind(this)
        });
    },

    handleDatePicked(selectedDates, dateStr, instance) {
        this.pushEvent("dates-picked", dateStr)
    },
};

export default DatePicker;
