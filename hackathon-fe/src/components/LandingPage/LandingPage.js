import React from 'react';

import TaskCard from '../TaskCard/TaskCard'

import westpalmbeach from '../../assets/Photos/Palm_beach.jpg'

import './landingPage.css'
import location from '../../assets/Icons/location.svg'
import tasks from '../../tasks.json'

const LandingPage = () => {
    return (
        <div>
            <img src={westpalmbeach} alt="west palm beach" className='palm-beach-image'/>
            <div className='buttonRow'>
               <button className='report'>Report an Issue</button>
               <button className='aroundme'>Around Me <img src={location} alt="pin"></img></button>
            </div>
            <div>
                {tasks.map(task => <TaskCard />)}
            </div>
        </div>
    )
}

export default LandingPage