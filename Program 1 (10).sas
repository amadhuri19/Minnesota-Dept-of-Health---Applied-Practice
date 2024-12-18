proc import datafile="/home/u63569870/APEx/infants_clean_06.14.24_use.xlsx"
            out=infant
            dbms=xlsx
            replace;
    sheet="infants_clean";
    getnames=yes;
run;

/*Table 1. Adult Vaccination Status in Household by Race, Parental Education, and Family Income */
proc format;
    value vaccine_adultf
        1 = "Yes"
        0 = "No"
        3 = "Unknown";
       
    value sr_raceethf
        1 = "American Indian/Alaska Native"
        2 = "Asian"
        3 = "Black/African American"
        4 = "Native Hawaiian/Pacific Islander"
        5 = "White"
        6 = "Other"
        7 = "Multiracial"
        8 = "Hispanic"
        9 = "Unknown";
        
    value highest_parent_eduf
        1 = "Never attended school or only attended kindergarten"
        2 = "Grades 1 through 8 (Elementary/Middle)"
        3 = "Grades 9 through 11 (some high school)"
        4 = "Grade 12 or GED (high school graduate)"
        5 = "College 1 year to 3 years (some college, technical school, associate's degree)"
        6 = "College 4 years or more (college graduate)"
        7 = "Advanced degree (Masters or doctoral-level graduate)"
        8 = "Unknown";
        
    value incomef
        1 = "Less than $30,000"
        2 = "$30,000 to $80,000"
        3 = "Over $80,000"
        4 = "Unknown";
        
    picture pctfmt (round)
        other = '009.9%';
run;


data infant1;
    set infant; 
    label vaccine_adult = "Was adult in household vaccinated?"
          sr_raceeth = "Self-reported race/ethnicity"
          highest_parent_edu = "Highest level of education for entire household"
          income = "Total household income";
run;
proc tabulate data=infant1 order=unformatted;
    class vaccine_adult sr_raceeth highest_parent_edu income / missing;
    classlev vaccine_adult sr_raceeth highest_parent_edu income / style=[asis=on];
    table sr_raceeth*(n="N" rowpctn='%'*f=pctfmt.)
          highest_parent_edu*(n="N" rowpctn='%'*f=pctfmt.)
          income*(n="N" rowpctn='%'*f=pctfmt.),
          (all vaccine_adult) / misstext="0";
    format vaccine_adult vaccine_adultf. sr_raceeth sr_raceethf.
           highest_parent_edu highest_parent_eduf. income incomef.;
run;

/*Table 2. Adult Vaccination Status in the 6 Months Prior to Infant’s COVID Infection by Race, Parental Education, and Family Income*/
proc format;
        
    value vax_6mf
    	1 = "Yes"
        0 = "No";
        
    value sr_raceethf
        1 = "American Indian/Alaska Native"
        2 = "Asian"
        3 = "Black/African American"
        4 = "Native Hawaiian/Pacific Islander"
        5 = "White"
        6 = "Other"
        7 = "Multiracial"
        8 = "Hispanic"
        9 = "Unknown";
        
    value highest_parent_eduf
        1 = "Never attended school or only attended kindergarten"
        2 = "Grades 1 through 8 (Elementary/Middle)"
        3 = "Grades 9 through 11 (some high school)"
        4 = "Grade 12 or GED (high school graduate)"
        5 = "College 1 year to 3 years (some college, technical school, associate's degree)"
        6 = "College 4 years or more (college graduate)"
        7 = "Advanced degree (Masters or doctoral-level graduate)"
        8 = "Unknown";
        
    value incomef
        1 = "Less than $30,000"
        2 = "$30,000 to $80,000"
        3 = "Over $80,000"
        4 = "Unknown";
        
    picture pctfmt (round)
        other = '009.9%';
run;


data infant1;
    set infant; 
    label vax_6m = "Was an adult vaccinated in the 6 months before infant's infection?"
          sr_raceeth = "Self-reported race/ethnicity"
          highest_parent_edu = "Highest level of education for entire household"
          income = "Total household income";
run;
proc tabulate data=infant1 order=unformatted;
    class vax_6m sr_raceeth highest_parent_edu income / missing;
    classlev vax_6m sr_raceeth highest_parent_edu income / style=[asis=on];
    table sr_raceeth*(n="N" rowpctn='%'*f=pctfmt.)
          highest_parent_edu*(n="N" rowpctn='%'*f=pctfmt.)
          income*(n="N" rowpctn='%'*f=pctfmt.),
          (all vax_6m) / misstext="0";
    format vax_6m vax_6mf. sr_raceeth sr_raceethf.
           highest_parent_edu highest_parent_eduf. income incomef.;
run;

/*Adult Vaccination Status in Household by Race/Ethnicity */
proc sgplot data=infant1;
  vbar sr_raceeth / group=vaccine_adult groupdisplay=cluster;
  xaxis label="Race/Ethhnicity";
  yaxis grid label="Count";
  format vaccine_adult vaccine_adultf. sr_raceeth sr_raceethf.;
  keylegend /title="Adult in Home Vaccinated";
run;

/*Adult Vaccination Status in Household by Highest Parental Education*/
proc sgplot data=infant1;
  vbar highest_parent_edu / group=vaccine_adult groupdisplay=cluster;
  xaxis label="Highest Parental Education";
  yaxis grid label="Count";
  format vaccine_adult vaccine_adultf. highest_parent_edu highest_parent_eduf.;
  keylegend /title="Adult in Home Vaccinated";
run;

/*Adult Vaccination Status in Household by Family Income Level*/
proc sgplot data=infant1;
  vbar income / group=vaccine_adult groupdisplay=cluster;
  xaxis label="Total Household Income";
  yaxis grid label="Count";
  format vaccine_adult vaccine_adultf. income incomef.;
  keylegend /title="Adult in Home Vaccinated";
run;

/*Adult Vaccination Status in the 6 Months Prior to Infant’s COVID Infection by Race/Ethnicity*/
proc sgplot data=infant1;
  vbar sr_raceeth / group=vax_6m groupdisplay=cluster;
  xaxis label="Race/Ethhnicity";
  yaxis grid label="Count";
  format vax_6m vax_6mf. sr_raceeth sr_raceethf.;
  keylegend /title="Adult in Home Vaccinated in the last 6 months";
run;

/*Adult Vaccination Status in the 6 Months Prior to Infant’s COVID Infection by Highest Parental Education*/
proc sgplot data=infant1;
  vbar highest_parent_edu / group=vax_6m groupdisplay=cluster;
  xaxis label="Highest Parental Education";
  yaxis grid label="Count";
  format vax_6m vax_6mf. highest_parent_edu highest_parent_eduf.;
  keylegend /title="Adult in Home Vaccinated in the last 6 months";
run;

/*Adult Vaccination Status in the 6 Months Prior to Infant’s COVID Infection by Family Income Level*/
proc sgplot data=infant1;
  vbar income / group=vax_6m groupdisplay=cluster;
  xaxis label="Total Household Income";
  yaxis grid label="Count";
  format vax_6m vax_6mf. income incomef.;
  keylegend /title="Adult in Home Vaccinated in the last 6 months";
run;
  
