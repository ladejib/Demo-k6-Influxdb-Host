import http from 'k6/http';
import { sleep } from 'k6';
import { check, group } from 'k6';

export const options = {
  // A simple test configuration
  discardResponseBodies: true,
  stages: [
    { duration: '30s', target: 2 },  // Ramp up to 2 users over 30 seconds
    { duration: '1m', target: 5 },   // Stay at 5 users for 1 minute
    { duration: '30s', target: 0 },   // Ramp down to 0 users over 30 seconds
  ],
  thresholds: {
    'http_req_duration': ['p(95)<500'], // 95% of requests should be below 500ms
    'http_req_failed': ['rate<0.01'],   // Less than 1% of requests should fail
  },
  // Ensure output is compatible with InfluxDB 2.x
  // This is actually handled by environment variables in docker-compose.yml
};

export default function () {
  group('API Testing', function () {
    // Replace with your actual API endpoint
    const response = http.get('https://test.k6.io/');
    
    check(response, {
      'status is 200': (r) => r.status === 200,
      'transaction time < 500ms': (r) => r.timings.duration < 500,
    });
  });
  
  sleep(1); // Sleep for 1 second between iterations
}
