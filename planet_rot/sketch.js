#!/usr/bin/env node
// Id$ nonnax Wed Jan 10 18:38:43 2024
// https://github.com/nonnax
let planet;
let satellite;

function setup() {
  createCanvas(600, 600);
  planet = createVector(width / 2, height / 2);
  satellite = createVector(planet.x + 100, planet.y);
}

function draw() {
  background(255);

  updateSatellite();
  applyGravity();

  // Draw the planet
  fill(0);
  ellipse(planet.x, planet.y, 50, 50);

  // Draw the satellite
  fill(200, 0, 0);
  ellipse(satellite.x, satellite.y, 20, 20);
}

function updateSatellite() {
  // Define the orbit parameters
  let radius = 100;
  let speed = 0.02;

  // Update the satellite position using p5.Vector
  let orbit = p5.Vector.fromAngle(speed * frameCount).mult(radius);
  satellite = p5.Vector.add(planet, orbit);
}

function applyGravity() {
  // Define gravitational parameters
  let gravitationalConstant = 0.1;

  // Calculate the gravitational force using p5.Vector
  let force = p5.Vector.sub(planet, satellite);
  let distanceSquared = force.magSq();
  force.normalize();
  force.mult(gravitationalConstant / distanceSquared);

  // Apply the gravitational force to the satellite
  satellite.add(force);
}

