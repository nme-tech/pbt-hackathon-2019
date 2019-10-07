import React from 'react';
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import Navbar from './components/Layout/Navbar'
import Footer from './components/Layout/Footer'

import LandingPage from './components/LandingPage/LandingPage'
import InputPage from './components/InputPage/InputPage'
import './App.css';
import './components/Layout/Layout.css'

function App() {

  return (
    <div className="App">
      <Router>
        <div className='layout'>
        <Navbar />
        <Switch>
          <Route exact path='/'>
            <LandingPage />
          </Route>
          <Route exact path='/input'>
            <InputPage />
          </Route>
        </Switch>
        <Footer />
        </ div>

            
      </Router>

    </div>
  );
}

export default App;
