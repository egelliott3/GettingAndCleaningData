Data Dictionary - Tidy.txt

subjectId<br/>
    Integer value representing the id of the subject that was measured
    
activityName<br/>
    Name of the activity performed by the subject<br/>
    <ul>
        <li>WALKING</li>
        <li>WALKING_UPSTAIRS</li>
        <li>WALKING_DOWNSTAIRS</li>
        <li>SITTING</li>
        <li>STANDING</li>
        <li>LAYING</li>
    </ul>

domain<br/>
    The type of domain signal used for the measurement<br/>
    <ul>
        <li>Time</li>
        <li>Frequency</li>
    </ul>
        
instrument<br/>
    Instrument used to measure the subject<br/>
    <ul>
        <li>Gyroscope</li>
        <li>Accelerometer</li>
    </ul>
        
acceleration<br/>
    The type of acceleration used when the subject was measured by an Accelerometer.  NA reported for any reading not from an Accelerometer.<br/>
    <ul>
        <li>Body</li>
        <li>Gravity</li>
    </ul>
        
isJerk</br>
    Flag field indicating if this was a Jerk signal or not
    
isMagnitude</br>
    Flag field indicating if this value was calculated using the magnitude.
    
variable<br/>
    The variable that was measured for this observation<br/>
    <ul>
      <li>Mean</li>
      <li>StandardDeviation</li>
     </ul>
      
axis<br/>
    The axis that was measured<br/>
    <ul>
        <li>X</li>
        <li>Y</li>
        <li>Z</li>
    </ul>
