
const contactForm = document.getElementById("contactForm");
const response = document.getElementById("response");

contactForm.addEventListener("submit", function(event) {
    event.preventDefault();

    const name = document.getElementById("name").value;

    response.textContent =
        `Thank you, ${name}! Your message has been received.`;

    contactForm.reset();
});
