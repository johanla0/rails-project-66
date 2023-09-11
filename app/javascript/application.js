import { Application } from '@hotwired/stimulus';
import '@hotwired/turbo-rails';
// eslint-disable-next-line import/no-unresolved
import { definitions } from 'stimulus:./controllers';

const application = Application.start();

// Configure Stimulus development experience
application.load(definitions);
application.debug = false;
window.Stimulus = application;

// eslint-disable-next-line import/prefer-default-export
export { application };
