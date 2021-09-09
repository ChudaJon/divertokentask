open React

@react.component
let make = () => 
<div> 
  <p> {string("Register")} </p> 
  <input type="text" name="username"/>
  <input type="password" name="password"/>
  <input type="password" name="cpassword"/>
</div>
