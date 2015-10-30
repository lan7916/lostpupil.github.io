import React from 'react';

export default class HelloBox extends React.Component {
  render() {
    return <div>
    <h1>Ahoyi React</h1>
    <Harry/>
    <Potter/>
    </div>
  }
}

class Harry extends React.Component {
  render(){
    return  <p>I am harry</p>
  }
}
class Potter extends Harry {
  render(){
    return  <p>I am harry potter </p>
  }
}
