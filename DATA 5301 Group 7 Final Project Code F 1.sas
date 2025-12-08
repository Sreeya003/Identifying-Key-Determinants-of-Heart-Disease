/* DATA CLEANING AND PREPROCESSING */

/* STEP 1: Import the Heart Disease (Cleveland) dataset
   We read the raw .data file and store it in a SAS dataset called heart_raw_char.
   For now we keep everything as CHARACTER so that "?" values are easy to see. 
   Note that the infile will change based on the user's system. */

data heart_raw_char;
    infile "/home/u64303972/sasuser.v94/5301 Projects/final project/processed.cleveland.data"
           dlm=','          /* Values are separated by commas           */
           dsd              /* Handles consecutive commas as missing    */
           truncover;       /* Prevents SAS from jumping to next line   */	

    /* Define each column with simple character names */
    length
        age       $3     /* age in years                         */
        sex       $1     /* 0 = female, 1 = male                 */
        cp        $1     /* chest pain type                      */
        trestbps  $3     /* resting blood pressure               */
        chol      $3     /* serum cholesterol                    */
        fbs       $1     /* fasting blood sugar                  */
        restecg   $1     /* resting ECG                          */
        thalach   $3     /* max heart rate                       */
        exang     $1     /* exercise induced angina              */
        oldpeak   $5     /* ST depression                        */
        slope     $1     /* slope of ST segment                  */
        ca        $1     /* number of major vessels              */
        thal      $2     /* thalassemia                          */
        target    $1 ;   /* 0–4, heart disease level             */

    /* Read the values in order, separated by commas */
    input
        age
        sex
        cp
        trestbps
        chol
        fbs
        restecg
        thalach
        exang
        oldpeak
        slope
        ca
        thal
        target ;
run;

/* Look at the first 10 rows to confirm it loaded correctly */
proc print data=heart_raw_char (obs=10);
run;

/* Check variable names, types, and length */
proc contents data=heart_raw_char;
run;



/* STEP 2: CLEAN MISSING VALUES AND CONVERT TO NUMERIC
   We create a clean numeric dataset called heart_clean_raw.
   First, we replace "?" with missing values (.) 
   Then we convert all character variables to numeric. */

data heart_clean_raw;
    set heart_raw_char;

    /* Replace all "?" with actual numeric missing values */
    array chars {*} age sex cp trestbps chol fbs restecg thalach exang oldpeak slope ca thal target;
    do i = 1 to dim(chars);
        if chars{i} = "?" then chars{i} = "";   /* Convert '?' to blank */
    end;

    /* Convert each character variable into numeric versions */
    age_num      = input(age, best12.);
    sex_num      = input(sex, best12.);
    cp_num       = input(cp, best12.);
    trestbps_num = input(trestbps, best12.);
    chol_num     = input(chol, best12.);
    fbs_num      = input(fbs, best12.);
    restecg_num  = input(restecg, best12.);
    thalach_num  = input(thalach, best12.);
    exang_num    = input(exang, best12.);
    oldpeak_num  = input(oldpeak, best12.);
    slope_num    = input(slope, best12.);
    ca_num       = input(ca, best12.);
    thal_num     = input(thal, best12.);
    target_num   = input(target, best12.);

    drop i;  /* Remove loop variable */
run;

/* Check the first 10 rows of the numeric dataset */
proc print data=heart_clean_raw (obs=10);
run;

/* Check structure of numeric variables */
proc contents data=heart_clean_raw;
run;



/* STEP 3: Create the final clean dataset
   We keep only the numeric variables and rename them to simple names.
   This makes the dataset easier to use in EDA and modeling. */

data heart_final;
    set heart_clean_raw;

    /* Keep only numeric versions */
    keep 
        age_num
        sex_num
        cp_num
        trestbps_num
        chol_num
        fbs_num
        restecg_num
        thalach_num
        exang_num
        oldpeak_num
        slope_num
        ca_num
        thal_num
        target_num;
run;

/* Rename numeric variables to cleaner names */
data heart_final;
    set heart_final;
    rename
        age_num      = age
        sex_num      = sex
        cp_num       = cp
        trestbps_num = trestbps
        chol_num     = chol
        fbs_num      = fbs
        restecg_num  = restecg
        thalach_num  = thalach
        exang_num    = exang
        oldpeak_num  = oldpeak
        slope_num    = slope
        ca_num       = ca
        thal_num     = thal
        target_num   = target;
run;

/* View first 10 cleaned rows */
proc print data=heart_final (obs=10);
run;

/* Check structure of final numeric dataset */
proc contents data=heart_final;
run;

/* Create a permanent CSV file, note the outfile will change based on the user's system */
proc export data=heart_final
    outfile="/home/u64303972/sasuser.v94/5301 Projects/final project/heart_clean_final.csv"
    dbms=csv
    replace;
run;



/* EXPLORATORY DATA ANALYSIS */

/* STEP 4A: Summary statistics for all numeric variables */

proc means data=heart_final mean median min max std nmiss;
    var age trestbps chol thalach oldpeak;
run;

/* STEP 4B: Frequency tables for categorical variables */

proc freq data=heart_final;
    tables 
        sex
        cp
        fbs
        restecg
        exang
        slope
        ca
        thal
        target / nocum nopercent;
run;

/* STEP 4C: Histograms for numerical variables */

proc sgplot data=heart_final;
    histogram age;
    density age / type=normal;
    title "Histogram of Age";
run;

proc sgplot data=heart_final;
    histogram trestbps;
    density trestbps / type=normal;
    title "Histogram of Resting Blood Pressure (trestbps)";
run;

proc sgplot data=heart_final;
    histogram chol;
    density chol / type=normal;
    title "Histogram of Cholesterol (chol)";
run;

proc sgplot data=heart_final;
    histogram thalach;
    density thalach / type=normal;
    title "Histogram of Max Heart Rate (thalach)";
run;

proc sgplot data=heart_final;
    histogram oldpeak;
    density oldpeak / type=normal;
    title "Histogram of Oldpeak (ST Depression)";
run;

/* STEP 4D: Boxplots for checking outliers */

proc sgplot data=heart_final;
    vbox age;
    title "Boxplot of Age";
run;

proc sgplot data=heart_final;
    vbox trestbps;
    title "Boxplot of Resting Blood Pressure (trestbps)";
run;

proc sgplot data=heart_final;
    vbox chol;
    title "Boxplot of Cholesterol (chol)";
run;

proc sgplot data=heart_final;
    vbox thalach;
    title "Boxplot of Max Heart Rate (thalach)";
run;

proc sgplot data=heart_final;
    vbox oldpeak;
    title "Boxplot of Oldpeak (ST Depression)";
run;

/* STEP 4E: Correlation matrix for numerical variables */

proc corr data=heart_final nosimple plots=matrix;
    var age trestbps chol thalach oldpeak;
    title "Correlation Matrix and Scatterplot Matrix for Numerical Variables";
run;
/* STEP 4F: Boxplots of Numerical Variables by Target */
proc sgplot data=heart_final;
    vbox age / category=target;
    title "Boxplot of Age by Heart Disease Target";
run;

proc sgplot data=heart_final;
    vbox trestbps / category=target;
    title "Boxplot of Resting Blood Pressure (trestbps) by Target";
run;

proc sgplot data=heart_final;
    vbox chol / category=target;
    title "Boxplot of Cholesterol (chol) by Target";
run;

proc sgplot data=heart_final;
    vbox thalach / category=target;
    title "Boxplot of Max Heart Rate (thalach) by Target";
run;

proc sgplot data=heart_final;
    vbox oldpeak / category=target;
    title "Boxplot of ST Depression (oldpeak) by Target";
run;

/*TTest comparisons*/


/* 1) trestbps ~ fbs */
proc ttest data=heart_final;
    class fbs;          /* 0 vs 1 groups */
    var trestbps;       /* numeric outcome */
run;
/* 2) chol ~ sex */
proc ttest data=heart_final;
    class sex;
    var chol;
run;

proc ttest data=heart_final;
    class sex;
    var chol;
    format sex sexfmt.;
run;
/*  CHI-SQUARE TEST: Chest Pain Type vs Target*/
proc freq data=heart_final;
  tables cp*target / chisq expected cellchi2;
  title "Chi-Square Test 2: Chest Pain Type vs Heart Disease Target";
run;

/*One-Way ANOVA*/
/*Checking thalach to see if it satisfies ANOVA assumptions*/
proc univariate data = heart_final;
class target;
var thalach;
qqplot;
run;
/*Starting the ANOVA for thalach and target with T test, Tukey, cldiff, and levene to check normality*/
PROC ANOVA DATA=heart_final;
    CLASS target;               
    MODEL thalach = target;     
    MEANS target / T Tukey cldiff hovtest=levene;                               
RUN;
QUIT;

/*Next we want to check target (presence of heart disease) vs cholestorol level (mg/dL) */

proc univariate data = heart_final;
class target;
var chol;
qqplot;
run;
/*Starting the ANOVA for chol and target with T test, Tukey, cldiff, and levene to check normality*/
PROC ANOVA DATA=heart_final;
    CLASS target;               
    MODEL chol = target;     
    MEANS target / T Tukey cldiff hovtest=levene;                               
RUN;
QUIT;



/* Create binary target variable*/
data heart_final;
    set heart_final;
    if target = 0 then target_bin = 0;    
    else target_bin = 1;
run;

/*Logistic Regression  */
proc logistic data=heart_final plots(only)=roc;
    class 
        sex(ref='1') 
        cp(ref='4') 
        slope(ref='3') 
        ca(ref='3') 
        thal(ref='7')
        / param=ref;

    model target_bin(event='1') =
          sex 
          trestbps
          thalach
          oldpeak
          cp
          slope
          ca
          thal
          / selection=stepwise slentry=0.15 slstay=0.15;
          
    output out=pred_clean p=phat;
run;

/*Better cutoff instead of 0.5 (0.4 is nicer) */

data pred_clean;
    set pred_clean;
    if phat >= 0.40 then pred_class = 1;
    else pred_class = 0;
run;



/*Confusion Matrix*/

proc freq data=pred_clean;
    tables target_bin * pred_class / norow nocol nopercent;
run;
