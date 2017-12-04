import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
// import '../bower_components/webcomponentsjs/webcomponents-lite'
// import '../bower_components/polymer/polymer.html'
// import '../bower_components/paper-input/paper-input.html'

Main.embed(document.getElementById('root'));

registerServiceWorker();
