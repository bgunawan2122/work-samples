#include "AI.h"
#include <cassert>

// This file is used only in the Reach, not the Core.
// You do not need to make any changes to this file for the Core

string getAIMoveString(const BuildingState& buildingState) {
    string str = "";
    
    // Elevator Data
    int elevatorFloor[NUM_ELEVATORS] = {};
    int servicingCount = 0;
    
    for (int i = 0; i < NUM_ELEVATORS; i++) {
        elevatorFloor[i] = buildingState.elevators[i].currentFloor;
    }
    
    // Pickup Move
    for (int i = 0; i < NUM_ELEVATORS; i++) {
        // Checks for Pass Move
        if (buildingState.elevators[i].isServicing) {
            servicingCount++;
        }
        // Checks for people on elevator's floor
        if (buildingState.floors[elevatorFloor[i]].numPeople > 0) {
            for (int j = 0; j < NUM_ELEVATORS; j++) {
                if (buildingState.elevators[j].isServicing == false) {
                    if (buildingState.floors[buildingState.elevators[j].currentFloor].numPeople > 0) {
                        str = 'e' + to_string(buildingState.elevators[j].elevatorId) + 'p';
                        return str;
                    }
                }
            }
        }
    }
    // Handles Pass Move
    if (servicingCount == 3) {
        // If the servicing count is 3, then no free elevators, so pass move.
        str = "";
    }
    // Go to Floor with Most People
    int targetFloor = buildingState.floors[0].floorNum;
    int numPeopleOnFloor = buildingState.floors[0].numPeople;
    
    for (int i = 0; i < NUM_FLOORS; i++) {
        // Greater amount of people
        if (buildingState.floors[i].numPeople > numPeopleOnFloor) {
            targetFloor = buildingState.floors[i].floorNum;
            numPeopleOnFloor = buildingState.floors[i].numPeople;
            for(int j = 0; j < NUM_ELEVATORS; j++) {
                if (!buildingState.elevators[j].isServicing) {
                    str = 'e' + to_string(buildingState.elevators[j].elevatorId) + 'f' + to_string(targetFloor);
                }
            }
        }
    }
    return str;
}

string getAIPickupList(const Move& move, const BuildingState& buildingState, const Floor& floorToPickup) {
    int upRequests = 0;
    int downRequests = 0;
    int numPeople = floorToPickup.getNumPeople();
    string pickUpList = "";
    
    for (int i = 0; i < numPeople; i++) {
        int targetFloor = floorToPickup.getPersonByIndex(i).getTargetFloor();
        int currentFloor = floorToPickup.getPersonByIndex(i).getCurrentFloor();
        if (targetFloor - currentFloor > 0) {
            upRequests++;
        }
        else {
            downRequests++;
        }
    }
    if (upRequests > downRequests) {
        for (int i = 0; i < numPeople; i++) {
            int targetFloor = floorToPickup.getPersonByIndex(i).getTargetFloor();
            int currentFloor = floorToPickup.getPersonByIndex(i).getCurrentFloor();
            
            if (targetFloor - currentFloor > 0) {
                pickUpList = pickUpList + to_string(i);
            }
        }
    }
    if (upRequests < downRequests) {
        for (int i = 0; i < numPeople; i++) {
            int targetFloor = floorToPickup.getPersonByIndex(i).getTargetFloor();
            int currentFloor = floorToPickup.getPersonByIndex(i).getCurrentFloor();
            
            if (targetFloor - currentFloor < 0) {
                pickUpList = pickUpList + to_string(i);
            }
        }
    }
    return pickUpList;
}
