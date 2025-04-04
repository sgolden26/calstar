import { useState } from 'react'
import React from "react";
import Logo from "./components/logo.jsx";

function WelcomeMessage({ name }) {
  return <h1>Welcome to CalStar, {name}!</h1>;
}



function App() {
  return (
    <div>
      <Logo />
      <WelcomeMessage name="UC Berkeley Students" />
    </div>
  );
}

export default App;

