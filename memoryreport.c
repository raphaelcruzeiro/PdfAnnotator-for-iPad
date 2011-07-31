//
//  memoryreport.c
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/30/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#include <stdio.h>
#include <mach/mach.h>

#include "memoryreport.h"

void memoryReport()
{
    static unsigned last_resident_size = 0;
    static unsigned greatest = 0;
    static unsigned last_greatest = 0;
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    
    if(kerr == KERN_SUCCESS) {
        int diff = (int)info.resident_size - (int)last_resident_size;
        unsigned latest = info.resident_size;
        if(latest > greatest) greatest = latest;
        int greatest_diff = greatest - last_greatest;
        int last_greatest_diff = latest - greatest;
        
        printf("Mem: %10u (%10d) : %10d : greatest: %10u (%d)\n", info.resident_size, diff, last_greatest_diff, greatest, greatest_diff);
    }
    
    last_resident_size = info.resident_size;
    last_greatest = greatest;
}
