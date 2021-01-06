## Activity File: Exploring Kibana

* You are a DevOps professional and have set up monitoring for one of your web
  servers. You are collecting all sorts of web log data and it is your job to
  review the data regularly to make sure everything is running smoothly.

* Today, you notice something strange in the logs and you want to take a closer
  look.

* Your task: Explore the web server logs to see if there's anything unusual.
  Specifically, you will:

:warning: **Heads Up**: These sample logs are specific to the time you view
them. As such, your answers will be different from the answers provided in the
solution file.

---

### Instructions

1. Add the sample web log data to Kibana.
  - On the homepage click on `Load a data set and a Kibana dashboard` under `Add sample data`
  - Click `Add data` under the `Sample web logs` data pane
  - Click `View Data` to pull up the dashboard

2. Answer the following questions:
  - In the last 7 days, how many unique visitors were located in India?
    * 225 unique visitors were located in India over the last seven days.

  - In the last 24 hours, of the visitors from China, how many were using Mac
    OSX?
    * From China, eight (8) visitors were using macosx, of a total of 33 unique
    * visitors.

  - In the last 2 days, what percentage of visitors received 404 errors? How
    about 503 errors?
    * In the last two days, 12 unique vistors (3.15%) received 404 errors. 18
    * visitors (4.7%) received 503 errors.

  - In the last 7 days, what country produced the majority of the traffic on
    the website?
    * In the last seven days, there were 268 visitors from China, representing
    * the majority of traffic from any single country.

  - Of the traffic that's coming from that country, what time of day had the
    highest amount of activity?
    * The 13th hour of the day (1:00 PM) had the highest amount of traffic from China.

  - List all the types of downloaded files that have been identified for the
    last 7 days, along with a short description of each file type (use Google
    if you aren't sure about a particular file type).
    * The following file type downloads were detected over the last seven days:
    * `.gz` - Gzip File - Compressed file type. Can contain any data.
    * `.css` - CSS style sheet - Cascading Style Sheet file used to style websites.
    * `.zip` - Zip File - Compressed file type. Can contain any data.
    * `.deb` - Debian Package - Debian package type used to package software for
      debian-based linux distributions (e.g. Debian, Ubuntu).
    * `.rpm` - Red-Hat Package - Red-Hat style package type used to package
      software for Red-Hat-based linux distributions (e.g. RHEL, CentOS).

3. Now that you have a feel for the data, Let's dive a bit deeper. Look at the
   chart that shows Unique Visitors Vs. Average Bytes.

  - Locate the time frame in the last 7 days with the most amount of bytes (activity).
    * The most amount of bytes (i.e. activity) occurred in the 19th hour
      (7:00 PM) on 01-03-2020 (according to my data).

  - In your own words, is there anything that seems potentially strange about this activity?
    * This activity all originated from a single IP address in India using
      a Windows 8 machine.  This is potentially strange because all the activity
      was used to download an `rpm` package, a software package format that is
      unsupported on the Windows 8 operating system.

4. Filter the data by this event.
  - What is the timestamp for this event?
    * The timestamp for this event is Jan 3, 2021 @ 19:57:28.552
  - What kind of file was downloaded?
    * An `rpm` package was downloaded.
  - From what country did this activity originate?
    * This activity originated in India.
  - What HTTP response codes were encountered by this visitor?
    * The visitor encountered a 200 (OK) response.

5. Switch to the Kibana Discover page to see more details about this activity.
  - What is the source IP address of this activity?
    * The source IP address of this activity is `35.143.166.159`.
  - What are the geo coordinates of this activity?
    * The geo coordinates of this activity is 43.34121,-73.6103075
  - What OS was the source machine running?
    * The source machine was running Windows 8.
  - What is the full URL that was accessed?
    * The full URL accessed was `https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.3.2-i686.rpm`.
  - From what website did the visitor's traffic originate?
    * The visitor's traffic originated from `facebook.com`.

6. Finish your investigation with a short overview of your insights.
  - What do you think the user was doing?
    * The user was downloading the metricbeat rpm package from `elastic.co`.
  - Was the file they downloaded malicious? If not, what is the file used for?
    * The file is most likely not malicious. The file downloaded is simply the
      metricbeat package for Red-Hat-based linux distributions.
  - Is there anything that seems suspicious about this activity?
    * It is a bit suspicious that the user was downloading a metricbeat package
      that is intended for use on Red-Hat-based linux distributions on a Windows
      machine, and it is also suspicious that the traffic originated from
      Facebook, but it is most likely a mistake.
  - Is any of the traffic you inspected potentially outside of compliance guidelines?
    * It is potentially outside of compliance guidelines that a package was
      downloaded on an unsupported machine, on traffic originating from
      Facebook. We generally don't want to download any executable filetypes
      that are from unknown origins.

---
© 2020 Trilogy Education Services, a 2U, Inc. brand. All Rights Reserved.
