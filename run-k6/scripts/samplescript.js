import http from 'k6/http';
import { sleep, check } from 'k6';

// Test configuration
export const options = {
  discardResponseBodies: true,
  // Stages for ramping up and down load
  stages: [
    { duration: '30s', target: 10 }, // Ramp up to 10 users
    { duration: '1m', target: 10 },  // Stay at 10 users for 1 minute
    { duration: '30s', target: 0 },  // Ramp down to 0 users
  ],
  thresholds: {
    // Requirements for test to pass
    http_req_duration: ['p(95)<500'], // 95% of requests must finish within 500ms
    http_req_failed: ['rate<0.01'],   // Less than 1% of requests should fail
  },
};

// Default function executed by each virtual user
export default function() {
  // Make HTTP GET request to test.k6.io
  const res = http.get('https://test.k6.io/');
  
  // Check response
  check(res, {
    'status is 200': (r) => r.status === 200,
    'page contains title': (r) => r.body.includes('Welcome to the k6.io demo site!'),
  });
  
  // Wait for 1 second before next iteration
  sleep(1);
  
  // Make a request to a search form
  const searchRes = http.get('https://test.k6.io/search?q=performance');
  
  check(searchRes, {
    'search returned 200': (r) => r.status === 200,
  });
  
  sleep(1);
}
