package edu.asu.stas.lib;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.Period;
import java.util.Objects;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DateUtils {

    //  Rounds the period to the nearest month
    public static Period roundPeriod(Period period) {
        if (period.getDays() > 15) {
            period = period.plusMonths(1).withDays(0).normalized();
        }
        return period;
    }

    public static String getYearMonthPeriod(LocalDate start, LocalDate end) {
        end = Objects.requireNonNullElse(end, LocalDate.now());
        Period period = roundPeriod(Period.between(start, end));
        StringBuilder durationStr = new StringBuilder();
        if (period.getYears() != 0) {
            durationStr.append(period.getYears()).append(" yr ");
        }
        if (period.getMonths() != 0) {
            durationStr.append(period.getMonths()).append(" mos ");
        }
        return durationStr.toString();
    }

}
