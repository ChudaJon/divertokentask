import React, { useState } from "react";
import Card from "./Card";

function App() {
  const [tokens, setTokens] = useState(10);

  const spend = () => {
    if (tokens > 0) {
      setTokens((prev) => prev - 1);
      return true;
    }
    return false;
  };

  return (
    <div className="flex flex-col gap-4 justify-center items-center w-screen h-screen">
      My token: {tokens}
      <Card text="Task 1" tokens spend={spend} />
      <Card text="Task 2" tokens spend={spend} />
      <Card text="Task 3" tokens spend={spend} />
    </div>
  );
}

export default App;
