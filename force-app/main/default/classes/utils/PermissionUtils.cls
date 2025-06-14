public without sharing class PermissionUtils {
    static Profile loggedInUserProfileName;
    public static String getLoggedInUserProfileName() {
        if (loggedInUserProfileName == null) {
            loggedInUserProfileName = [
                SELECT Name
                FROM Profile
                WHERE Id = :userinfo.getProfileid()
            ];
        }
        return loggedInUserProfileName.Name;
    }

    public static boolean doesCurrentUserHasGivenPermissionSet(String permissionSet) {
        return getAllUsersInPermissionSet(permissionSet)
            .contains(userinfo.getUserId());
    }

    public static Set<Id> getAllUsersInPermissionSet(String permissionSetName) {
        Set<Id> ids = new Set<Id>();
        for (PermissionSetAssignment PermissionSetAssignmentData : [
            SELECT Id, PermissionSet.Profile.Name, AssigneeId, Assignee.Name
            FROM PermissionSetAssignment
            WHERE PermissionSet.Name = :permissionSetName
        ]) {
            ids.add(PermissionSetAssignmentData.AssigneeId);
        }
        return ids;
    }
}
