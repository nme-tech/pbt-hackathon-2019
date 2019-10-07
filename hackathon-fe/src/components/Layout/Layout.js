import React from 'react';

import Navbar from './Navbar'
import Footer from './Footer'
import './Layout.css'

import LandingPage from '../LandingPage/LandingPage';
import InputPage from '../InputPage/InputPage';

const Layout = props => (
        <div className="layout">
            <Navbar />
            {/* {props.children}
            <Footer /> */}
        </div>
)

export default () => (
    <Layout>
        <Switch>
            <Route exact path="/">
                <LandingPage />
            </Route>
            <Route exact path="/input">
                <InputPage />
            </Route>
        </Switch>
    </Layout>
)