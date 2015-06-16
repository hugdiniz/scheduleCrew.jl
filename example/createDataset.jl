function getDayInYear(month,day)
    monthDays = [1 31;2 28;3 31;4 30;5 31;6 30;7 31;8 31;9 30;10 31;11 30;12 31]
    finalDay = sum(monthDays[2,1:month])
    finalDay = day + finalDay
    return finalDay
end


cd("/home/hugdiniz/Work/Workspace/ScheduleCrew.jl/example")
dataset =  readcsv("dataset/dataset.csv")

#leg_nb 	 airport_dep 	 date_dep 	 hour_dep 	 airport_arr 	 date_arr 	 hour_arr

#airports
uniqueValues = unique(dataset[:,2])
airports = hcat(1:length(uniqueValues),uniqueValues)
writecsv("datasetModified/airports.csv",airports)

airports_init_fk = Array(Int, length(dataset[:,2]))
airports_end_fk = Array(Int, length(dataset[:,2]))

for i=1:length(dataset[:,2])
    for j=1:length(airports[:,2])
       if airports[j,2] == dataset[i,2]
            airports_init_fk[i] = airports[j,1]
        end
        if airports[j,2] == dataset[i,5]
            airports_end_fk[i] = airports[j,1]
        end
    end
end


#dates
uniqueValues = unique(dataset[:,6])
dates = hcat(1:length(uniqueValues),uniqueValues)
writecsv("datasetModified/dates.csv",dates)


#hours -- minutes

iniDateString = dataset[:,3]
iniDates =  Array(Int, length(iniDateString))
i = 1
for date in iniDateString
    yearMonthDay = split(date,"-")
    day = getDayInYear(int(yearMonthDay[2]),int(yearMonthDay[3]))
    iniDates[i] = day
    i = i + 1
end

initHoursString = dataset[:,4]
initMinutes =  Array(Int, length(initHoursString))
i = 1
for hourMinute in initHoursString
    hourMinuteSplit = split(hourMinute,":")
    minute = int(hourMinuteSplit[1]) * 60 + int(hourMinuteSplit[2])
    initMinutes[i] = minute + (iniDates[i] * 24 * 60)
    i = i + 1
end


endDateString = dataset[:,6]
endDates =  Array(Int, length(endDateString))
i = 1
for date in endDateString
    yearMonthDay = split(date,"-")
    day = getDayInYear(int(yearMonthDay[2]),int(yearMonthDay[3]))
    endDates[i] = day
    i = i + 1
end

endHoursString = dataset[:,7]
endMinutes =  Array(Int, length(endHoursString))
i = 1
for hourMinute in endHoursString
    hourMinuteSplit = split(hourMinute,":")
    minute = int(hourMinuteSplit[1]) * 60 + int(hourMinuteSplit[2])
    endMinutes[i] = minute + (endDates[i] * 24 * 60)
    i = i + 1
end
#id airports_init_fk airports_end_fk initMinutes endMinutes
datasetModified = hcat(1:length(dataset[:,6]),airports_init_fk,airports_end_fk,initMinutes,endMinutes)
writecsv("datasetModified/datasetModified.csv",datasetModified)


