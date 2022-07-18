import Quill from 'quill/dist/quill.js';
export default Quill;

var toolbarOptions = [
  [{ header: [1, 2, 3, 4, 5, 6, false] }],
  [{ size: ['small', false, 'large', 'huge'] }],
  ['bold', 'italic', 'underline', 'strike'],
  ['blockquote', 'code-block'],

  [{ align: [] }],
  [{ direction: 'rtl' }],
  [{ indent: '-1' }, { indent: '+1' }],
  [{ list: 'ordered' }, { list: 'bullet' }],

  [{ color: [] }, { background: [] }],
  [{ font: [] }],
  ['clean'],
];

var quill_options = {
  modules: {
    toolbar: toolbarOptions,
  },
  placeholder: 'Compose an epic...',
  theme: 'snow',
};

document.addEventListener('DOMContentLoaded', function (event) {
  var quill = new Quill('.quill-editor', quill_options);
  quill.root.innerHTML = document.querySelector('input[class=quill-content]').value;

  document.querySelector('form').onsubmit = function () {
    var body = document.querySelector('input[class=quill-content]');
    body.value = quill.root.innerHTML;
  };
});
