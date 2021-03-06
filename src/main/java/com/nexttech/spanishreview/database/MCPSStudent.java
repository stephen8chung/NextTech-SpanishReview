package com.nexttech.spanishreview.database;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Serialize;

import java.util.Arrays;

/**
 * Created by plato2000 on 5/25/16.
 */

// Datastore entity
@Entity
public class MCPSStudent {
    // MCPS Student ID
    @Id Long id;
    // MCPS email
    String emailAddress;
    // The real name of the student
    String name;

    // The total number of worksheets completed by the user
    int overallWorksheets;
    // The total number of worksheets over the given score completed by the user
    int overScore;
    // The total number of blank worksheets filled out by the user
    int blankWorksheets;

    // The deadline time set by the teacher
    long deadline;
    // The name/email of the teacher
    String teacher;

    // The variables representing the number of worksheets required to get credit for the assignment
    int requiredTotal;
    int requiredOverScore;
    int requiredBlank;

    // The last served worksheet
    @Serialize String[][] lastWorksheet;

    /**
     * The private constructor, never used (Objectify requires a no-args constructor)
     */
    private MCPSStudent() {}

    public MCPSStudent(long id) {
        this(id + "@mcpsmd.net");
    }

    /**
     * The basic constructor, makes a user with dummy fields except for ID and emailAddress. Used when student logs in
     * before teacher sets stuff up.
     * @param emailAddress The MCPS email address of the student
     */
    public MCPSStudent(String emailAddress) {
        this(emailAddress, emailAddress, 0, "", 5, 3, 1);
    }

    /**
     * The expanded constructor; makes a user given an email address, a deadline, and a teacher.
     * @param emailAddress The MCPS email address of the student
     * @param deadline The deadline time for the student to complete work by
     * @param teacher The name/email of the teacher
     */
    public MCPSStudent(String emailAddress, String name, long deadline, String teacher, int requiredTotal, int requiredOverScore, int totalBlank) {
        this.emailAddress = emailAddress;
        this.deadline = deadline;
        this.teacher = teacher;

        this.overallWorksheets = 0;
        this.overScore = 0;
        this.blankWorksheets = 0;

        // The part of the email address before the @ symbol is the id
        this.id = Long.parseLong(this.emailAddress.substring(0, this.emailAddress.indexOf("@")));

        this.name = name;

        this.requiredTotal = requiredTotal;
        this.requiredOverScore = requiredOverScore;
        this.requiredBlank = totalBlank;
//        this.initTime = Calendar.getInstance().getTimeInMillis();

    }

    /**
     * Called when the student has completed a worksheet over the given score
     */
    public void completedOverScore() {
        this.overScore++;
    }

    /**
     * Called when the student has completed any worksheet
     */
    public void completedWorksheet() {
        this.overallWorksheets++;
    }

    /**
     * Called when the student has completed a blank worksheet
     */
    public void completedBlank() {
        this.blankWorksheets++;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public int getOverallWorksheets() {
        return overallWorksheets;
    }

    public int getOverScore() {
        return overScore;
    }

    public int getBlankWorksheets() {
        return blankWorksheets;
    }

    public long getDeadline() {
        return deadline;
    }

    public void setDeadline(long deadline) {
        this.deadline = deadline;
    }

    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getRequiredBlank() {
        return requiredBlank;
    }

    public void setRequiredBlank(int requiredBlank) {
        this.requiredBlank = requiredBlank;
    }

    public int getRequiredTotal() {
        return requiredTotal;
    }

    public void setRequiredTotal(int requiredTotal) {
        this.requiredTotal = requiredTotal;
    }

    public int getRequiredOverScore() {
        return requiredOverScore;
    }

    public void setRequiredOverScore(int requiredOverScore) {
        this.requiredOverScore = requiredOverScore;
    }

    public String getName() {
        return name;
    }

    public String[][] getLastWorksheet() {
        if(this.lastWorksheet == null) {
            return null;
        }
        String[][] copiedWorksheet = new String[this.lastWorksheet.length][];
        for(int i = 0; i < this.lastWorksheet.length; i++) {
            copiedWorksheet[i] = Arrays.copyOf(this.lastWorksheet[i], this.lastWorksheet[i].length);
        }
        return copiedWorksheet;
    }

    public void setLastWorksheet(String[][] worksheet) {
        if(worksheet == null) {
            this.lastWorksheet = null;
            return;
        }
        this.lastWorksheet = new String[worksheet.length][];
        for(int i = 0; i < worksheet.length; i++) {
            this.lastWorksheet[i] = Arrays.copyOf(worksheet[i], worksheet[i].length);
        }
    }

    /**
     * Checks if the student has met the requirements set by their own fields
     * @return true if the student has met the requirements, false otherwise
     */
    public boolean metRequirements() {
        if(getOverallWorksheets() >= getRequiredTotal()) {
            if(getBlankWorksheets() >= getRequiredBlank()) {
                if(getOverScore() >= getRequiredOverScore()) {
                    return true;
                }
            }
         }
        return false;
    }

    /**
     * Checks if the student has done anything on the site at all
     * @return true if the student has completed at least one worksheet, false otherwise
     */
    public boolean started() {
        return getOverallWorksheets() > 0;
    }

    @Override
    public String toString() {
        return "MCPSStudent{" +
                "id=" + id +
                ", emailAddress='" + emailAddress + '\'' +
                ", name='" + name + '\'' +
                ", overallWorksheets=" + overallWorksheets +
                ", overScore=" + overScore +
                ", blankWorksheets=" + blankWorksheets +
                ", deadline=" + deadline +
                ", teacher='" + teacher + '\'' +
                ", lastWorksheet=" + Arrays.toString(lastWorksheet) +
                '}';
    }
}
