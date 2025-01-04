# SRAM: Cross Training Conversion Project

## Project Overview

This application converts your Strava activity mileage across different sports. Ideal for users recovering from injury or those looking to add variety to their workout routine but still hit consistent aerobic goals. After logging into your Strava account, you’ll be able to see your mileage totals and choose to convert them into equivalent mileage for your selected sport.

## How to Build and Run

### Prerequisites
- A Strava account.
- Xcode 14.0+ installed on your Mac.

### Building and Running the App
1. Clone the repository:
   ```bash
   git clone https://github.com/SofiaWongg/StravaXTCalculator.git
2. Open xcodeproj in Xcode
3. Add environment variables (instructions below)
4. Build and run the app (cmd + R)

### Environment Variables
*Must have a strava app Setup
1. Set up environment variables for the app to securely access the Strava API:
   - `CLIENT_ID`: Your Strava client ID.
   - `CLIENT_SECRET`: Your Strava client secret.

2. Add these variables in Xcode:
   - Open your project in Xcode.
   - Go to `Product > Scheme > Edit Scheme`.
   - Under the "Arguments" tab, add the following key-value pairs in the "Environment Variables" section:
     ```
     CLIENT_ID = client_id
     CLIENT_SECRET = client_secret
     ```

### Steps to get a Strava Developer account
1. Go to the [Strava API Developers Page](https://www.strava.com/settings/api). 
2. Log in with your Strava account. 
3. Click "Create & Manage Your App."
4. Fill in the required details for your application 
   -> Application Name: XTConversions, Category: Mobile App,  Website: https://bucolic-kleicha-03ec15.netlify.app  Authorization Callback Domain: com.crosstrain.oauth
5. Copy the `Client ID` and `Client Secret` from the app details page. 

---
### Currently Supported Activities
- Ride
- Swim
- Run
  
  _*activities marked private are not shown_
  
---

## Future Considerations

### Features
1. **Goal Setting/Recommendations**
   - Allow users to set a mileage goal for their chosen sport and track progress throughout the week.

2. **Expanded Supported Activities**
   - Add support for additional Strava activity types such as:
     - Elliptical
     - Stair Stepper
     - Hiking
     - Walking

3. **Additional Statistics for Conversions**
   - Incorporate additional metrics like heart rate or time to provide more accurate mileage conversions.

4. **Custom Date Ranges**
   - Allow users to select specific date ranges for viewing and comparing their activity statistics.
     
5. **Allowing for Multiple Athlete Connections**
   - Applying for strava review https://share.hsforms.com/1VXSwPUYqSH6IxK0y51FjHwcnkd8

---

### Technical Enhancements
1. **Refresh Expired Access Tokens**
   - Implement token refresh logic to prevent users from having to log in every time they open the app.

2. **Proper Sign-Out Implementation**
   - Fully deauthorize the user's Strava account upon signing out.

3. **Accessibility Improvements**
   - Add accessibility labels for images and controls.
   - Improve contrast and ensure compatibility with screen readers for better usability by users with low vision.

4. **Testing**
   - Expand unit tests to cover edge cases, especially those involving:
     - Dates and time zones.
     - API failure scenarios and error handling.

5. **Previews with Mock Data**
   - Re-enable SwiftUI previews with mock data.

6. **Scalable Design**
   - Refactor key components to support scalability.

---
https://github.com/user-attachments/assets/089a6541-3467-413d-948b-04384f6249e5
