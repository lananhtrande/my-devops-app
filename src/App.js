import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>DevOps React Application</h1>
        <p>Successfully deployed with Docker to EC2!</p>
        <p>Hostname: {window.location.hostname}</p>
        <code>Environment: Production</code>
      </header>
    </div>
  );
}

export default App;
