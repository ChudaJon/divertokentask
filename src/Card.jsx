import React, { useState } from "react";

function Card({ text, spend }) {
  const [currentVotes, setCurrentVotes] = useState(0);

  const onClickVote = () => {
    if (spend()) {
      setCurrentVotes((prev) => prev + 1);
    }
  };

  return (
    <div className="border rounded-xl flex flex-col justify-center items-center w-1/2 py-8 ">
      <div>{text}</div>
      <div>Current votes {currentVotes}</div>
      <button
        className="border rounded-xl px-4 py-2 bg-gray-400"
        onClick={onClickVote}
      >
        vote
      </button>
    </div>
  );
}

export default Card;
