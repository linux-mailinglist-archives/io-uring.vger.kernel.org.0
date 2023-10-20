Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD417D14E1
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377868AbjJTR3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 13:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377735AbjJTR3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 13:29:37 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Oct 2023 10:29:33 PDT
Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF80D7
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 10:29:33 -0700 (PDT)
Date:   Fri, 20 Oct 2023 13:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697822635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HKD6QHqHzdlEVSEClRQkvmcLNXImKRIj4jNqLjjhCUM=;
        b=EIolxBEfVaCX1Q1U/y+l5nldTHmgqQjd91NiMcQ++aC6M0VHzTgOmm+K4lWErvqWbjhTj+
        lmzG6aotzsv9goYpwkztqmCp1bNA6odRMwOtA2n3Of/34ZxaL/wIN8RDAZ9X7uuaQWe9Rn
        VxnnEDVlXaJs/vSNx61wfZfa61JEaqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Daniel J Blueman <daniel@quora.org>
Cc:     linux-bcachefs@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: bcachefs KASAN SLAB out of bounds
Message-ID: <20231020172352.vh4y7fvmllod2j4n@moria.home.lan>
References: <CAMVG2sss9S45sCRnV+0nQ2jcd+XTMqYXNZ0FObodhD9kFUhwyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2sss9S45sCRnV+0nQ2jcd+XTMqYXNZ0FObodhD9kFUhwyg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 20, 2023 at 05:03:45PM +0800, Daniel J Blueman wrote:
> Hi Kent et al,
> 
> Booting bcachefs/master (SHA a180af9d) with a stock Ubuntu 23.04
> config plus CONFIG_KASAN=CONFIG_KASAN_VMALLOC=y, I have identified a
> minimal and consistent reproducer [1] triggering a KASAN report after
> ~90s of the fio workload [2].
> 
> The report shows a SLAB out of bounds access in connection from IO
> uring submission queue entries [3].
> 
> I confirmed the report isn't emitted when using ext4 in place of
> bcachefs; let me know if you'd like further testing on it.
> 
> Thanks,
>   Daniel
> 
> -- [1]
> 
> modprobe brd rd_nr=1 rd_size=1048576
> bcachefs format /dev/ram0
> mount -t bcachefs /dev/ram0 /mnt
> fio workload.fio
> 
> -- [2] workload.fio
> 
> [global]
> group_reporting
> ioengine=io_uring
> directory=/mnt
> size=16m
> time_based
> runtime=48h
> iodepth=256
> verify_async=8
> bs=4k-64k
> norandommap
> random_distribution=zipf:0.5
> ioengine=io_uring
> numjobs=16
> rw=randrw
> 
> [job1]
> direct=1
> 
> [job2]
> direct=0
> 
> -- [3]
> 
> BUG: KASAN: slab-out-of-bounds in io_req_local_work_add+0xf0/0x2a0
> Read of size 4 at addr ffff888138305218 by task iou-wrk-2702/3275
> 
> CPU: 38 PID: 3275 Comm: iou-wrk-2702 Not tainted 6.5.0+ #1
> Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS 2.5 09/08/2022
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x48/0x70
>  print_report+0xd2/0x660
>  ? __virt_addr_valid+0x103/0x180
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? kasan_complete_mode_report_info+0x40/0x230
>  ? io_req_local_work_add+0xf0/0x2a0
>  kasan_report+0xd0/0x120
>  ? io_req_local_work_add+0xf0/0x2a0
>  __asan_load4+0x8e/0xd0
>  io_req_local_work_add+0xf0/0x2a0
>  ? __pfx_io_req_local_work_add+0x10/0x10
>  io_req_complete_post+0x88/0x120
>  io_issue_sqe+0x363/0x6b0
>  io_wq_submit_work+0x10c/0x4d0
>  io_worker_handle_work+0x494/0xa60
>  io_wq_worker+0x3d5/0x660
>  ? __pfx_io_wq_worker+0x10/0x10
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? __kasan_check_write+0x14/0x30
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? _raw_spin_lock_irq+0x8b/0x100
>  ? __pfx__raw_spin_lock_irq+0x10/0x10
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? __kasan_check_write+0x14/0x30
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? srso_alias_return_thunk+0x5/0x7f
>  ? calculate_sigpending+0x5a/0x70
>  ? __pfx_io_wq_worker+0x10/0x10
>  ret_from_fork+0x47/0x80
>  ? __pfx_io_wq_worker+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
> RIP: 0033:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 002b:0000000000000000 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000000 RBX: 00007f752ea36718 RCX: 000055792b721268
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
> RBP: 00007f752ea36718 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
> R13: 000055792d883950 R14: 00000000000532ed R15: 000055792d915740
>  </TASK>
> 
> Allocated by task 2702:
>  kasan_save_stack+0x38/0x70
>  kasan_set_track+0x25/0x40
>  kasan_save_alloc_info+0x1e/0x40
>  __kasan_slab_alloc+0x9d/0xa0
>  slab_post_alloc_hook+0x5f/0xe0
>  kmem_cache_alloc_bulk+0x264/0x3e0
>  __io_alloc_req_refill+0x1d8/0x370
>  io_submit_sqes+0x549/0xb80
>  __do_sys_io_uring_enter+0x968/0x1330
>  __x64_sys_io_uring_enter+0x7f/0xa0
>  do_syscall_64+0x5b/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> The buggy address belongs to the object at ffff888138305180
> which belongs to the cache io_kiocb of size 224
> The buggy address is located 152 bytes inside of        allocated
> 224-byte region [ffff888138305180, ffff888138305260)
> 
> The buggy address belongs to the physical page:
> page:00000000f168c2d3 refcount:1 mapcount:0 mapping:0000000000000000
> index:0xffff8881383048c0 pfn:0x138304
> head:00000000f168c2d3 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff8881cfb7e001
> flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> page_type: 0xffffffff()
> raw: 0017ffffc0010200 ffff888126f670c0 dead000000000122 0000000000000000
> raw: ffff8881383048c0 000000008033002b 00000001ffffffff ffff8881cfb7e001
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888138305100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888138305180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888138305200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>               ^
>  ffff888138305280: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
>  ffff888138305300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> -- 
> Daniel J Blueman

Beats me, this looks like an io_uring bug.

I did reproduce it, decode_stacktrace.sh output might help:

BUG: KASAN: slab-out-of-bounds in __io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
Read of size 4 at addr ffff888109eccd18 by task iou-wrk-606/2321

CPU: 9 PID: 2321 Comm: iou-wrk-606 Not tainted 6.5.0-ktest-02826-gf70a3402188e #993
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:107) 
print_report (mm/kasan/report.c:365 mm/kasan/report.c:475) 
? __virt_addr_valid (include/linux/mmzone.h:1908 (discriminator 1) include/linux/mmzone.h:2004 (discriminator 1) arch/x86/mm/physaddr.c:65 (discriminator 1)) 
? kasan_complete_mode_report_info (mm/kasan/report_generic.c:172) 
kasan_report (mm/kasan/report.c:590) 
? __io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
? __io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
__asan_load4 (mm/kasan/generic.c:259) 
__io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
? io_eventfd_signal (io_uring/io_uring.c:1378) 
? find_held_lock (kernel/locking/lockdep.c:5279) 
io_req_complete_post (io_uring/io_uring.c:1039) 
io_issue_sqe (io_uring/io_uring.c:1879) 
io_wq_submit_work (io_uring/io_uring.c:1949) 
io_worker_handle_work (io_uring/io-wq.c:518 io_uring/io-wq.c:572) 
io_wq_worker (io_uring/io-wq.c:615) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
? __this_cpu_preempt_check (lib/smp_processor_id.c:67) 
? lockdep_hardirqs_on (kernel/locking/lockdep.c:4437) 
? _raw_spin_unlock_irq (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:77 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:202) 
? trace_hardirqs_on (kernel/trace/trace_preemptirq.c:63) 
? preempt_count_sub (kernel/sched/core.c:5880) 
? _raw_spin_unlock_irq (arch/x86/include/asm/preempt.h:104 (discriminator 1) include/linux/spinlock_api_smp.h:160 (discriminator 1) kernel/locking/spinlock.c:202 (discriminator 1)) 
? calculate_sigpending (kernel/signal.c:200) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
ret_from_fork (arch/x86/kernel/process.c:151) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
RIP: 0033:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.

Code starting with the faulting instruction
===========================================
RSP: 002b:0000000000000000 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000560948a7132b
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f6bdf0485c0
R13: 0000000000000003 R14: 0000000000000003 R15: 00005609499c3100
</TASK>

Allocated by task 606:
kasan_save_stack (mm/kasan/common.c:46) 
kasan_set_track (mm/kasan/common.c:52 (discriminator 1)) 
kasan_save_alloc_info (mm/kasan/generic.c:512) 
__kasan_slab_alloc (mm/kasan/common.c:328) 
kmem_cache_alloc_bulk (mm/slab.h:763 (discriminator 1) mm/slub.c:4048 (discriminator 1)) 
__io_alloc_req_refill (io_uring/io_uring.c:1114) 
io_submit_sqes (io_uring/io_uring.h:365 (discriminator 1) io_uring/io_uring.c:2409 (discriminator 1)) 
__x64_sys_io_uring_enter (io_uring/io_uring.c:3628 (discriminator 1) io_uring/io_uring.c:3562 (discriminator 1) io_uring/io_uring.c:3562 (discriminator 1)) 
do_syscall_64 (arch/x86/entry/common.c:50 (discriminator 1) arch/x86/entry/common.c:80 (discriminator 1)) 
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 

The buggy address belongs to the object at ffff888109eccc80
which belongs to the cache io_kiocb of size 224
The buggy address is located 152 bytes inside of
allocated 224-byte region [ffff888109eccc80, ffff888109eccd60)

The buggy address belongs to the physical page:
page:00000000dd505ee7 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888109ecc000 pfn:0x109ecc
head:00000000dd505ee7 order:1 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x8000000000010200(slab|head|zone=2)
page_type: 0xffffffff()
raw: 8000000000010200 ffff8881048e1400 dead000000000122 0000000000000000
raw: ffff888109ecc000 0000000080190011 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff888109eccc00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff888109eccc80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888109eccd00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
^
ffff888109eccd80: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
ffff888109ecce00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Kernel panic - not syncing: kasan.fault=panic set ...
CPU: 9 PID: 2321 Comm: iou-wrk-606 Not tainted 6.5.0-ktest-02826-gf70a3402188e #993
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:107) 
dump_stack (lib/dump_stack.c:114) 
panic (kernel/panic.c:340) 
? crash_smp_send_stop+0x40/0x40 
? mark_held_locks (kernel/locking/lockdep.c:4280) 
? check_panic_on_warn (arch/x86/include/asm/atomic.h:85 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:555 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:1011 (discriminator 4) include/linux/atomic/atomic-instrumented.h:454 (discriminator 4) kernel/panic.c:239 (discriminator 4)) 
end_report (mm/kasan/report.c:231) 
kasan_report (mm/kasan/report.c:590) 
? __io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
? __io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
__asan_load4 (mm/kasan/generic.c:259) 
__io_req_task_work_add.part.0 (io_uring/io_uring.c:1329 (discriminator 2) io_uring/io_uring.c:1382 (discriminator 2)) 
? io_eventfd_signal (io_uring/io_uring.c:1378) 
? find_held_lock (kernel/locking/lockdep.c:5279) 
io_req_complete_post (io_uring/io_uring.c:1039) 
io_issue_sqe (io_uring/io_uring.c:1879) 
io_wq_submit_work (io_uring/io_uring.c:1949) 
io_worker_handle_work (io_uring/io-wq.c:518 io_uring/io-wq.c:572) 
io_wq_worker (io_uring/io-wq.c:615) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
? __this_cpu_preempt_check (lib/smp_processor_id.c:67) 
? lockdep_hardirqs_on (kernel/locking/lockdep.c:4437) 
? _raw_spin_unlock_irq (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:77 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:202) 
? trace_hardirqs_on (kernel/trace/trace_preemptirq.c:63) 
? preempt_count_sub (kernel/sched/core.c:5880) 
? _raw_spin_unlock_irq (arch/x86/include/asm/preempt.h:104 (discriminator 1) include/linux/spinlock_api_smp.h:160 (discriminator 1) kernel/locking/spinlock.c:202 (discriminator 1)) 
? calculate_sigpending (kernel/signal.c:200) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
ret_from_fork (arch/x86/kernel/process.c:151) 
? io_worker_handle_work (io_uring/io-wq.c:598) 
ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
RIP: 0033:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.

Code starting with the faulting instruction
===========================================
RSP: 002b:0000000000000000 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000560948a7132b
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f6bdf0485c0
R13: 0000000000000003 R14: 0000000000000003 R15: 00005609499c3100
</TASK>
