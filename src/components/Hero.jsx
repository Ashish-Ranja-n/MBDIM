import React from 'react';

const Hero = () => {
  return (
    <section className="relative bg-gradient-to-b from-blue-50 to-white py-32 overflow-hidden">
      <div className="absolute inset-0 bg-grid-gray-200/50 [mask-image:linear-gradient(0deg,white,rgba(255,255,255,0.6))]"></div>
      <div className="container mx-auto px-4 text-center relative">
        <div className="animate-fade-in-up">
          <h1 className="text-4xl md:text-7xl font-bold text-gray-900 mb-6 leading-tight">
            Invest in Local Shops. 
            <span className="bg-gradient-to-r from-primary to-blue-600 bg-clip-text text-transparent block mt-2">
              Grow with Their Success.
            </span>
          </h1>
          <p className="text-xl text-gray-600 mb-12 max-w-3xl mx-auto leading-relaxed">
            VITKARA connects small neighborhood businesses — from tea stalls to barbers — with local investors. 
            Businesses receive community-driven funding, while investors earn transparent daily returns.
          </p>
          <div className="flex justify-center gap-4">
            <button className="bg-primary text-white px-8 py-4 rounded-full text-lg font-medium hover:bg-blue-700 hover:shadow-lg hover:shadow-blue-200 transition-all duration-300 transform hover:-translate-y-1">
              Learn More
            </button>
            <button className="bg-white text-primary px-8 py-4 rounded-full text-lg font-medium border-2 border-primary hover:bg-blue-50 transition-all duration-300 transform hover:-translate-y-1">
              Get Started
            </button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
