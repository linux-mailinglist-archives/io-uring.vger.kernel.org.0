Return-Path: <io-uring+bounces-1564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067E18A5E42
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 01:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFC34282F75
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 23:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D3A158DC9;
	Mon, 15 Apr 2024 23:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Qj+jiDre"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0335D158859;
	Mon, 15 Apr 2024 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713223585; cv=none; b=OLnKK+3+cLtbmnsHRTB87oQEbvkZYFkooqUqVgD1xB+lOzAhjmGOQp+48yTML/k0z9XkHCRm6yujtvVSxs28/qneWRxnDW3JuHSL7++NlYNpedYnCBrmUIEcOC6pbQadZV2vh+ncpZaIRopbCIY0knzMydyy7eGlm2LBvrUdaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713223585; c=relaxed/simple;
	bh=BQsXRqLvo2iR7NbLsVRTDBKIXVsBZY1PftjOEpal5Rc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PFjSr/3K0dCk1g8v9Kwp8L3MNx05nrdlu93iZLvz6P826Oiu+XPFTT/3WQEGcZazK7EH0xo+T3CHMPvZCxw4We3diOBolMl9qfH5+u6wl63QxG+0Bl/eGG0OP5XO+ndCF2X4okPR4tP5WFU89c1gahW+Ti50KQmR9Yo43s3Yri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Qj+jiDre; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.4.31] (pool-96-235-38-110.pitbpa.fios.verizon.net [96.235.38.110])
	by linux.microsoft.com (Postfix) with ESMTPSA id 16EBC20FCF9D;
	Mon, 15 Apr 2024 16:26:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 16EBC20FCF9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1713223583;
	bh=fWdLvV1SLtoUtT0FiRzuJaEj86NRITZjkPPVGS9jFyA=;
	h=Date:To:Cc:From:Subject:From;
	b=Qj+jiDre3ANlrtjr+2buPd2EGi7WRLRvTjuSVe5/JHfGy5wufGn2Rcxwcbywc7kcH
	 ygfOF8q+2wt3JrOuju0gLLu1WEMx1gOl3Ndw0YejxfzJKcjdAb17/3vq4iXc+yqAMG
	 ck6gcN5lr+2byNWEGj28PyKavaEIJKZnTiaCOuBU=
Message-ID: <0cea7b29-5c31-409a-a8d3-de53c7ce40eb@linux.microsoft.com>
Date: Mon, 15 Apr 2024 19:26:22 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-CA
To: io-uring@vger.kernel.org
Cc: audit@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paul Moore <paul@paul-moore.com>
From: Dan Clash <daclash@linux.microsoft.com>
Subject: io_uring: worker thread NULL dereference during openat op
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Below is a test program that causes multiple io_uring worker threads to 
hit a NULL dereference while executing openat ops.

The test program hangs forever in a D state.  The test program can be 
run again after the NULL dereferences.  However, there are long delays 
at reboot time because the io_uring_cancel() during do_exit() attempts 
to wake the worker threads.

The test program is single threaded but it queues multiple openat and 
close ops with IOSQE_ASYNC set before waiting for completions.

I collected trace with /sys/kernel/tracing/events/io_uring/enable 
enabled if that is helpful.

The test program reproduces similar problems in the following releases.

mainline v6.9-rc3
stable 6.8.5
Ubuntu 6.5.0-1018-azure

The test program does not reproduce the problem in Ubuntu 
5.15.0-1052-azure, which does not have the io_uring audit changes.

The following is the first io_uring worker thread backtrace in the repro 
against v6.9-rc3.

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 0 PID: 4628 Comm: iou-wrk-4605 Not tainted 6.9.0-rc3 #2
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, 
BIOS Hyper-V UEFI Release v4.1 11/28/2023
RIP: 0010:strlen (lib/string.c:402)
Call Trace:
  <TASK>
? show_regs (arch/x86/kernel/dumpstack.c:479)
? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
? page_fault_oops (arch/x86/mm/fault.c:713)
? do_user_addr_fault (arch/x86/mm/fault.c:1261)
? exc_page_fault (./arch/x86/include/asm/irqflags.h:37 
./arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1513 
arch/x86/mm/fault.c:1563)
? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623)
? __pfx_strlen (lib/string.c:402)
? parent_len (kernel/auditfilter.c:1284)
__audit_inode (kernel/auditsc.c:2381 (discriminator 4))
? link_path_walk.part.0.constprop.0 (fs/namei.c:2324)
path_openat (fs/namei.c:3550 fs/namei.c:3796)
do_filp_open (fs/namei.c:3826)
? alloc_fd (./arch/x86/include/asm/paravirt.h:589 (discriminator 10) 
./arch/x86/include/asm/qspinlock.h:57 (discriminator 10) 
./include/linux/spinlock.h:204 (discriminator 10) 
./include/linux/spinlock_api_smp.h:142 (discriminator 10) 
./include/linux/spinlock.h:391 (discriminator 10) fs/file.c:553 
(discriminator 10))
io_openat2 (io_uring/openclose.c:140)
io_openat (io_uring/openclose.c:178)
io_issue_sqe (io_uring/io_uring.c:1897)
io_wq_submit_work (io_uring/io_uring.c:2006)
io_worker_handle_work (io_uring/io-wq.c:540 io_uring/io-wq.c:597)
io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
? __pfx_io_wq_worker (io_uring/io-wq.c:627)
? raw_spin_rq_unlock (./arch/x86/include/asm/paravirt.h:589 
./arch/x86/include/asm/qspinlock.h:57 ./include/linux/spinlock.h:204 
./include/linux/spinlock_api_smp.h:142 kernel/sched/core.c:603)
? finish_task_switch.isra.0 (./arch/x86/include/asm/irqflags.h:42 
./arch/x86/include/asm/irqflags.h:77 kernel/sched/sched.h:1397 
kernel/sched/core.c:5163 kernel/sched/core.c:5281)
? __pfx_io_wq_worker (io_uring/io-wq.c:627)
ret_from_fork (arch/x86/kernel/process.c:156)
? __pfx_io_wq_worker (io_uring/io-wq.c:627)
ret_from_fork_asm (arch/x86/entry/entry_64.S:256)
RIP: 0033:0x0

Test program:

#include <cassert>
#include <fcntl.h>
#include <filesystem>
#include <getopt.h>
#include <iostream>
#include <liburing.h>

// This single threaded test program triggers a kernel BUG in an
// io_uring worker thread.
//
// The --count parameter sets the number of times that the following
// workload is executed:
//
// 1. io_uring_prep_openat(same_filename_each_time)
// 2. io_uring_submit
// 3. io_uring_wait_cqe
// 4. io_uring_prep_close(fd_from_openat_in_step_1)
// 5. io_uring_submit
// 6. io_uring_wait_cqe
//
// The SQEs in steps 1 and 4 have the IOSQE_ASYNC flag set.
//
// The --inflight parameter sets the number of the workloads that are
// executing at the same time.
// Steps 1 and 2 are executed, before step 3, until the inflight limit
// is reached.
//
// The sqe user_data is set to the io_uring op to keep the event_loop()
// simple.
// io_uring_sqe_set_data64() was not available during development.
//
// Warning: This test program may cause system instability and reboot
// may be affected.

// Usage:
//
// sudo apt install -y g++
// sudo apt install -y liburing-dev
// g++ ./io_uring_open_close_inflight.cc -o io_uring_open_close_inflight 
-luring
// sudo dmesg --clear
// ./io_uring_open_close_inflight --directory /tmp/deleteme --count 1 
--inflight 1
// sudo dmesg
//
// A good starting point to reproduce the problem is:
// --count 1000000 --inflight 100

void
submit1(struct io_uring& ring, const std::string& fileName)
{
     int ret;
     struct io_uring_sqe* sqe {};
     uintptr_t user_data {IORING_OP_OPENAT};

     int flags {O_RDWR | O_CREAT};
     mode_t mode {0666};

     sqe = io_uring_get_sqe(&ring);
     assert(sqe != nullptr);

     io_uring_prep_openat(sqe, AT_FDCWD, fileName.data(), flags, mode);
     io_uring_sqe_set_data(sqe, reinterpret_cast<void*>(user_data));
     io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);

     ret = io_uring_submit(&ring);
     assert(ret == 1);
}

void
submit2(struct io_uring& ring, const int fd)
{
     int ret;
     struct io_uring_sqe* sqe {};
     uintptr_t user_data {IORING_OP_CLOSE};

     sqe = io_uring_get_sqe(&ring);
     assert(sqe != nullptr);

     io_uring_prep_close(sqe, fd);
     io_uring_sqe_set_data(sqe, reinterpret_cast<void*>(user_data));
     io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);

     ret = io_uring_submit(&ring);
     assert(ret == 1);
}

void
event_loop(struct io_uring& ring,
            const std::string& filePath,
            const uint32_t count_max,
            const uint32_t inflight_max)
{
     uint32_t inflight {0};
     uint32_t count_phase1 {0};
     uint32_t count_phase2 {0};

     int i {0};
     std::string fileName(filePath + "/file" + std::to_string(i));

     while (count_phase2 < count_max) {
         int ret {0};
         int res {0};
         uintptr_t user_data {};


         while ((count_phase1 < count_max) and (inflight < inflight_max)) {
             if (0 == (count_phase1 % 100)) {
                 std::cout << "count=" << std::to_string(count_phase1)
			  << std::endl;
             }
             count_phase1 += 1;
             inflight += 1;
             submit1(ring, fileName);
         }

         {
             struct io_uring_cqe* cqe {};

             ret = io_uring_wait_cqe(&ring, &cqe);
             assert(ret == 0);

             res = cqe->res;
             user_data = 
reinterpret_cast<uintptr_t>(io_uring_cqe_get_data(cqe));

             io_uring_cqe_seen(&ring, cqe);
         }

         switch (user_data) {
         case IORING_OP_OPENAT:
             // res is a file descriptor or -errno.
             assert(res >= 0);
             submit2(ring, res);
             break;
         case IORING_OP_CLOSE:
             // assert that the close succeeded.
             assert(res == 0);
             count_phase2 += 1;
             inflight -= 1;
             break;
         default:
             assert(0);
         }
     }

     assert(count_phase1 == count_max);
     assert(count_phase2 == count_max);
     assert(inflight == 0);
}

void
workload(const std::string& filePath, const uint32_t count_max, const 
uint32_t inflight_max)
{
     int ret {0};
     struct io_uring ring;

     ret = io_uring_queue_init(2 * inflight_max, &ring, 0);
     assert(0 == ret);

     std::filesystem::create_directory(filePath);

     event_loop(ring, filePath, count_max, inflight_max);

     std::filesystem::remove_all(filePath);

     io_uring_queue_exit(&ring);
}

int
main(int argc, char** argv)
{
     std::string executableName {argv[0]};
     std::string filePath {};
     int count {};
     int inflight {};

     struct option options[]
     {
         {"help", no_argument, 0, 'h'},
         {"directory", required_argument, 0, 'd'},
         {"count", required_argument, 0, 'c'},
         {"inflight", required_argument, 0, 'i'},
         { 0, 0, 0, 0 }
     };
     bool printUsage {false};
     int val {};

     while ((val = getopt_long_only(argc, argv, "", options, nullptr)) 
!= -1) {
         if (val == 'h') {
             printUsage = true;
         } else if (val == 'd') {
             filePath = optarg;
             if (std::filesystem::exists(filePath)) {
                 printUsage = true;
                 std::cerr << "directory must not exist" << std::endl;
             }
         } else if (val == 'c') {
             count = atoi(optarg);
             if (0 == count) {
                 printUsage = true;
             }
         } else if (val == 'i') {
             inflight = atoi(optarg);
             if (0 == inflight) {
                 printUsage = true;
             }
         } else {
             printUsage = true;
         }
     }

     if ((0 == count) || (0 == inflight) || (filePath.empty())) {
         printUsage = true;
     }

     if (printUsage || (optind < argc)) {
         std::cerr << executableName
             << " --directory DIR --count COUNT --inflight INFLIGHT"
             << std::endl;
         exit(1);
     }

     workload(filePath, count, inflight);
     return 0;
}


Details:

The test program has no io_uring worker threads associated after the 
NULL dereferences.

root@openat-hang-3:~# date
Mon Apr 15 06:03:22 PM UTC 2024

root@openat-hang-3:~# ps -o pid,state,command -C 
io_uring_open_close_inflight
     PID S COMMAND
    4605 D ./io_uring_open_close_inflight --directory /tmp/deleteme 
--count 1000000 --inflight 100

root@openat-hang-3:~# ps -L -p 4605
     PID     LWP TTY          TIME CMD
    4605    4605 pts/3    00:00:07 io_uring_open_c

root@openat-hang-3:/# ps -e -L | grep -Ee 'iou[-]wrk[-]' --count
0

10 io_uring worker threads are present in dmesg.

root@openat-hang-3:~# nproc --all
8

root@openat-hang-3:/# grep /tmp/io_uring_dmesg_decode.txt -Ee 
'CPU.*iou-wrk-' --count
10

root@openat-hang-3:/# grep /tmp/io_uring_dmesg_decode.txt -Ee 
'CPU.*iou-wrk-'
[Mon Apr 15 18:02:55 2024] CPU: 0 PID: 4628 Comm: iou-wrk-4605 Not 
tainted 6.9.0-rc3 #2
[Mon Apr 15 18:02:55 2024] CPU: 1 PID: 4635 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:56 2024] CPU: 2 PID: 4636 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:57 2024] CPU: 3 PID: 4632 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:57 2024] CPU: 2 PID: 4634 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:58 2024] CPU: 5 PID: 4626 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:58 2024] CPU: 7 PID: 4630 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:58 2024] CPU: 4 PID: 4707 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:58 2024] CPU: 1 PID: 4705 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2
[Mon Apr 15 18:02:58 2024] CPU: 0 PID: 4711 Comm: iou-wrk-4605 Tainted: 
G      D            6.9.0-rc3 #2

The alloc_fd lines in the next section were changed to the following.

  ? alloc_fd (... fs/file.c:553 (discriminator 10))

The 10 backtraces are very similar.

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-1.txt
16a17
 >  ? __send_ipi_one (arch/x86/hyperv/hv_apic.c:252 (discriminator 3))

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-2.txt
root@openat-hang-3:/tmp/call-traces#

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-3.txt
root@openat-hang-3:/tmp/call-traces#

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-4.txt
14a15
 >  ? update_cfs_group (kernel/sched/fair.c:3983)

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-5.txt
root@openat-hang-3:/tmp/call-traces#

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-6.txt
16a17
 >  ? __io_req_complete_post (io_uring/io_uring.c:1016)

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-7.txt
root@openat-hang-3:/tmp/call-traces#

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-8.txt
16a17
 >  ? __send_ipi_one (arch/x86/hyperv/hv_apic.c:252 (discriminator 3))

root@openat-hang-3:/tmp/call-traces# diff call-trace-0.txt call-trace-9.txt
14a15
 >  ? update_cfs_group (kernel/sched/fair.c:3983)

