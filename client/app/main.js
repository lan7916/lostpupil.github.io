import React from 'react';
import ReactDom from 'react-dom';
import HelloBox from './components/hello.jsx';


main();

function main() {
    // ReactDom.render(<SearchableTable data={data}/>, document.getElementById('search'));
    ReactDom.render(<HelloBox />, document.getElementById('app'));
}
