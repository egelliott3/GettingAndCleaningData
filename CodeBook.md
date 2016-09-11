Data Dictionary - Tidy.csv

rowNum
    Row number created by RStudio write.csv function
    
subjectId
    Integer value representing the id of the subject that was measured
    
activityName
    Name of the activity performed by the subject
        WALKING
        WALKING_UPSTAIRS
        WALKING_DOWNSTAIRS
        SITTING
        STANDING
        LAYING

domain
    The type of domain signal used for the measurement
        Time
        Frequency
        
instrument
    Instrument used to measure the subject
        Gyroscope
        Accelerometer
        
acceleration
    The type of acceleration used when the subject was measured by an Accelerometer.  NA reported for any reading not from an Accelerometer.
        Body
        Gravity
        
isJerk
    Flag field indicating if this was a Jerk signal or not
    
isMagnitude
    Flag field indicating if this value was calculated using the magnitude.
    
variable
    The variable that was measured for this observation
      Mean
      StandardDeviation
      
axis
    The axis that was measured
        X
        Y
        Z
