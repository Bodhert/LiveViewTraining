import { AsYouType } from "libphonenumber-js";

const FormatPhone = {
    mounted() {
        this.el.addEventListener("input", e => {
            this.el.value = new AsYouType("US").input(this.el.value);
            console.log(this.el.value);
            // AsYouType.
            // format phone number associated with the input field
        });
    },
};

export default FormatPhone
