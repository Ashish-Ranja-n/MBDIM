import React from 'react';

const Header = () => {
  return (
    <header className="bg-white/90 backdrop-blur-sm shadow-lg sticky top-0 z-50">
      <div className="container mx-auto px-4 py-4 flex justify-between items-center">
  <div className="text-2xl font-bold text-primary tracking-tight">Vitkara</div>
        <button className="bg-primary text-white px-6 py-2.5 rounded-full font-medium hover:bg-blue-700 hover:shadow-lg hover:shadow-blue-200 transition-all duration-300">Get Started</button>
      </div>
    </header>
  );
};

export default Header;
