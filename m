Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD28131D9A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 03:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgAGC3k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jan 2020 21:29:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34762 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGC3k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jan 2020 21:29:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0072OWPH189377;
        Tue, 7 Jan 2020 02:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=xJzLdtiOeHi/qXyLSLz92uFYAQH2nIrnSmWBcHRc6AY=;
 b=lqZHC9J/omcFt2K+0MVPGqHB6vCPvPdAElvaiNX5or54VVQTaVlZgo2juStYw7T9Qsr9
 GQXXf0/sZa+CxlWv/96oZSZcpqrJZIO6shi+RK37+fgFK3i2HBMRKfbbCgPJw/MuTmt1
 JlAowLJZayeaKn8G3093ro0cxXr9VlYHIH8EsBuXu+JdrlinkLFP/r8g763oHMmNF7C3
 a7pXrM+B6VqC+Ne9U5CNrutUcP6uI7iLfAWaCzu+sufHu+MeOAQVdC8+4z1St0dAQoMr
 +3+FkI0lvrogxiPP2h9Y0/5oFFl7ysXahpIU1DVpV98UU556nG10TenufGO6dO9ploUK Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnptmq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 02:29:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0072TOoS090634;
        Tue, 7 Jan 2020 02:29:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xb467wpkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 02:29:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0072SR8j003768;
        Tue, 7 Jan 2020 02:28:27 GMT
Received: from [10.154.126.148] (/10.154.126.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 18:28:26 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Crash with fio io_uring polled mode test
Message-ID: <6b78f711-563d-7ae6-bda9-db403aa989aa@oracle.com>
Date:   Mon, 6 Jan 2020 18:28:25 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200105-0, 01/05/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070018
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'm seeing a consistent crash with the test case below.  With 5.5-rc5 
there is an io_kiocb user-after-free bug in the stack trace.

--bijan

[global]
filename=/dev/nvme0n1
rw=randread
bs=256k
direct=1
time_based=1
randrepeat=1
gtod_reduce=1
[fiotest]


fio nvme.fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs 
--hipri --numjobs=$1 --runtime=$2


# pwd
/sys/kernel/debug/block/nvme0n1
# grep . hctx*/type
hctx0/type:default
hctx10/type:poll
hctx11/type:poll
hctx12/type:poll
hctx13/type:poll
hctx14/type:poll
hctx1/type:default
hctx2/type:default
hctx3/type:default
hctx4/type:default
hctx5/type:default
hctx6/type:default
hctx7/type:poll
hctx8/type:poll
hctx9/type:poll

# lscpu
CPU(s):              16
On-line CPU(s) list: 0-15
Thread(s) per core:  1
Core(s) per socket:  1
Socket(s):           16
NUMA node(s):        1


[   36.676431] ------------[ cut here ]------------
[   36.679928] DMA-API: exceeded 7 overlapping mappings of cacheline 
0x0000000005e373c0
[   36.683789] WARNING: CPU: 0 PID: 4450 at kernel/dma/debug.c:500 
add_dma_entry+0x114/0x180
[   36.688226] Modules linked in: xfs dm_mod sr_mod sd_mod cdrom 
crc32c_intel nvme ata_piix nvme_core libata e1000 virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   36.696344] CPU: 0 PID: 4450 Comm: io_wqe_worker-0 Not tainted 
5.5.0-rc5-bij #350
[   36.703105] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   36.712590] RIP: 0010:add_dma_entry+0x114/0x180
[   36.716347] Code: f8 07 7e 55 80 3d 9b b8 59 01 00 75 4c 48 89 e2 be 
07 00 00 00 48 c7 c7 b0 1d 12 82 31 c0 c6 05 81 b8 59 01 01 e8 cc 64 f7 
ff <0f> 0b eb 2b 4c 89 e6 48 c7 c7 a0 05 52 82 e8 89 6b 7f 00 83 fb f4
[   36.728910] RSP: 0018:ffffc900023a37d0 EFLAGS: 00010086
[   36.733200] RAX: 0000000000000000 RBX: 00000000ffffffef RCX: 
0000000000000001
[   36.738455] RDX: 0000000000000001 RSI: 00000000fcd09a07 RDI: 
ffff888232fea400
[   36.743174] RBP: 0000000005e373c0 R08: ffff8881f3a55530 R09: 
0000000074cf0ba0
[   36.748052] R10: 0000000000000001 R11: 0000000000000000 R12: 
0000000000000292
[   36.752058] R13: ffff88823135ac80 R14: 0000000000000292 R15: 
00000000ffffffff
[   36.756879] FS:  0000000000000000(0000) GS:ffff888232e00000(0000) 
knlGS:0000000000000000
[   36.763292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.765706] CR2: 00007f7865cd1468 CR3: 00000001fae52001 CR4: 
0000000000160ef0
[   36.770354] Call Trace:
[   36.772284]  debug_dma_map_sg+0x2a6/0x340
[   36.775589]  ? dma_direct_map_sg+0x69/0xa0
[   36.776950]  nvme_queue_rq+0x41f/0xc99 [nvme]
[   36.778546]  ? kvm_sched_clock_read+0xd/0x20
[   36.781190]  ? __lock_acquire.isra.24+0x526/0x6c0
[   36.784511]  __blk_mq_try_issue_directly+0x120/0x1f0
[   36.786874]  ? __blk_mq_requeue_request+0xc1/0x120
[   36.788804]  blk_mq_try_issue_directly+0x57/0xb0
[   36.792139]  blk_mq_make_request+0x4fe/0x650
[   36.794700]  generic_make_request+0xfb/0x2f0
[   36.796709]  submit_bio+0x136/0x180
[   36.799056]  blkdev_direct_IO+0x421/0x460
[   36.801071]  generic_file_read_iter+0xde/0xc80
[   36.804590]  ? kvm_sched_clock_read+0xd/0x20
[   36.806479]  ? kvm_sched_clock_read+0xd/0x20
[   36.808776]  ? _cond_resched+0x20/0x30
[   36.810685]  io_read+0xf4/0x210
[   36.812337]  ? kvm_sched_clock_read+0xd/0x20
[   36.815122]  ? finish_task_switch+0x13e/0x2a0
[   36.817828]  ? do_raw_spin_unlock+0x83/0x90
[   36.820634]  ? _raw_spin_unlock_irq+0x1f/0x30
[   36.823428]  io_issue_sqe+0x81/0x960
[   36.825024]  ? __schedule+0x54c/0x6e0
[   36.827386]  io_wq_submit_work+0x54/0x1b0
[   36.829359]  io_worker_handle_work+0x33f/0x470
[   36.831265]  io_wqe_worker+0x35f/0x3a0
[   36.834689]  kthread+0x118/0x120
[   36.836232]  ? io_wqe_enqueue+0x130/0x130
[   36.837973]  ? kthread_insert_work_sanity_check+0x60/0x60
[   36.840677]  ret_from_fork+0x1f/0x30
[   36.842612] ---[ end trace 6d29f9243c0c2fd3 ]---
[   37.958777] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[   37.961783] CPU: 3 PID: 4418 Comm: fio Tainted: G W         
5.5.0-rc5-bij #350
[   37.964377] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   37.967975] RIP: 0010:blkdev_bio_end_io+0x71/0xe0
[   37.969504] Code: 75 3c 0f b6 43 32 4c 8b 2b 84 c0 75 0a 48 8b 73 08 
49 01 75 08 eb 0b 0f b6 f8 e8 8a 85 0f 00 48 63 f0 48 8b 03 31 d2 4c 89 
ef <ff> 50 10 f6 43 14 01 74 32 48 8d 7b 18 e8 3d 39 0f 00 eb 27 48 8b
[   37.975758] RSP: 0018:ffffc900022bfc20 EFLAGS: 00010246
[   37.976141] 
=============================================================================
[   37.977857] RAX: ffff88808173e400 RBX: ffff888083ba4480 RCX: 
0000000033323691
[   37.981248] BUG io_kiocb (Tainted: G        W        ): Poison 
overwritten
[   37.984322] RDX: 0000000000000000 RSI: 0000000000040000 RDI: 
ffff88808173e400
[   37.986124] 
-----------------------------------------------------------------------------
[   37.986124]
[   37.986127] INFO: 0x00000000ab4e622a-0x00000000ab4e622a @offset=9226. 
First byte 0x6f instead of 0x6b
[   37.989760] RBP: ffff888083ba4498 R08: ffff8881ff30b078 R09: 
00000000fffffff0
[   37.993948] INFO: Allocated in io_submit_sqes+0x160/0xa20 age=1372 
cpu=0 pid=4414
[   37.999091] R10: ffffffff82474ee0 R11: 0000000000000000 R12: 
0000000000000000
[   38.001693]  __slab_alloc+0x40/0x5d
[   38.001695]  kmem_cache_alloc+0xb1/0x290
[   38.005599] R13: ffff88808173e400 R14: 0000000000000000 R15: 
0000000000000000
[   38.009305]  io_submit_sqes+0x160/0xa20
[   38.010134] FS:  00007f78880c7740(0000) GS:ffff888233a00000(0000) 
knlGS:0000000000000000
[   38.011300]  __x64_sys_io_uring_enter+0x1f6/0x423
[   38.011304]  do_syscall_64+0x63/0x1a0
[   38.013411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.016189]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.016194] INFO: Freed in io_free_req+0x41/0x210 age=39 cpu=0 pid=4414
[   38.021660] CR2: 00007f7865d35668 CR3: 00000001f3b74001 CR4: 
0000000000160ee0
[   38.024586]  kmem_cache_free+0x16f/0x240
[   38.024589]  io_free_req+0x41/0x210
[   38.026796] Call Trace:
[   38.030317]  io_iopoll_getevents+0x28a/0x3d0
[   38.032220]  blk_update_request+0x219/0x3e0
[   38.034541]  __io_iopoll_check+0x75/0xa0
[   38.037999]  ? do_raw_spin_unlock+0x83/0x90
[   38.039152]  __x64_sys_io_uring_enter+0x270/0x423
[   38.039154]  do_syscall_64+0x63/0x1a0
[   38.040986]  blk_mq_end_request+0x1a/0x110
[   38.041680]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.043052]  blk_mq_complete_request+0x47/0xf0
[   38.045060] INFO: Slab 0x0000000045354dd2 objects=32 used=32 
fp=0x00000000dda1596f flags=0xfffffc0010200
[   38.046499]  nvme_poll+0x23a/0x2c0 [nvme]
[   38.047354] INFO: Object 0x000000006e84cdd8 @offset=9216 
fp=0x000000009ec683d4
[   38.047354]
[   38.048642]  blk_poll+0x24f/0x320
[   38.049378] Bytes b4 00000000176f5391: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00  ................
[   38.050588]  ? __lock_acquire.isra.24+0x526/0x6c0
[   38.051658] Object 000000006e84cdd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6f 
6b 6b 6b 6b 6b  kkkkkkkkkkokkkkk
[   38.054254]  ? find_held_lock+0x3c/0xa0
[   38.057345] Object 00000000709b5f04: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.058887]  io_iopoll_getevents+0x120/0x3d0
[   38.061937] Object 0000000046ffe485: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.063034]  ? __x64_sys_io_uring_enter+0x260/0x423
[   38.065613] Object 00000000bc9ec79c: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.066808]  __io_iopoll_check+0x75/0xa0
[   38.069418] Object 000000006623f064: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.069419] Object 0000000017c29cf2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.070412]  __x64_sys_io_uring_enter+0x270/0x423
[   38.072563] Object 00000000500a935d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.072565] Object 000000006ff56685: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.073614]  ? __x64_sys_io_uring_enter+0x83/0x423
[   38.075750] Object 00000000944d14a1: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.076844]  do_syscall_64+0x63/0x1a0
[   38.078938] Object 000000009e7ef42d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.078939] Object 000000003d95cefa: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.079874]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.081913] Object 000000003b27a75a: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   38.084053] RIP: 0033:0x7f78870132cd
[   38.085097] Object 000000004d942a34: 6b 6b 6b 6b 6b 6b 6b 
a5                          kkkkkkk.
[   38.087347] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   38.089440] CPU: 0 PID: 4414 Comm: fio Tainted: G    B W         
5.5.0-rc5-bij #350
[   38.090618] RSP: 002b:00007ffe8781e238 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   38.092901] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   38.093738] RAX: ffffffffffffffda RBX: 00007f7865d25580 RCX: 
00007f78870132cd
[   38.093740] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   38.096574] Call Trace:
[   38.099242] RBP: 00007f7865d25580 R08: 0000000000000000 R09: 
0000000000000000
[   38.100476]  dump_stack+0x64/0x83
[   38.102545] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000019b86d0
[   38.103369]  check_bytes_and_report+0xdd/0x130
[   38.105359] R13: 0000000000000403 R14: 0000000000000001 R15: 
0000000001a34928
[   38.109540]  check_object+0x121/0x250
[   38.111328] Modules linked in: xfs dm_mod sr_mod sd_mod cdrom 
crc32c_intel nvme ata_piix nvme_core libata e1000 virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   38.112905]  ? io_submit_sqes+0x160/0xa20
[   38.117085] ---[ end trace 6d29f9243c0c2fd4 ]---
[   38.119512]  alloc_debug_processing+0x80/0x129
[   38.119514]  ___slab_alloc+0x4fd/0x6a0
[   38.119516]  ? io_read_prep+0x28/0xc0
[   38.119519]  ? io_submit_sqes+0x160/0xa20
[   38.121431] RIP: 0010:blkdev_bio_end_io+0x71/0xe0
[   38.122431]  ? io_issue_sqe+0x8eb/0x960
[   38.122434]  ? io_submit_sqes+0x160/0xa20
[   38.122436]  __slab_alloc+0x40/0x5d
[   38.124618] Code: 75 3c 0f b6 43 32 4c 8b 2b 84 c0 75 0a 48 8b 73 08 
49 01 75 08 eb 0b 0f b6 f8 e8 8a 85 0f 00 48 63 f0 48 8b 03 31 d2 4c 89 
ef <ff> 50 10 f6 43 14 01 74 32 48 8d 7b 18 e8 3d 39 0f 00 eb 27 48 8b
[   38.125419]  ? io_submit_sqes+0x160/0xa20
[   38.127222] RSP: 0018:ffffc900022bfc20 EFLAGS: 00010246
[   38.128419]  kmem_cache_alloc+0xb1/0x290
[   38.128422]  io_submit_sqes+0x160/0xa20
[   38.128424]  ? io_submit_sqes+0xd7/0xa20
[   38.130239] RAX: ffff88808173e400 RBX: ffff888083ba4480 RCX: 
0000000033323691
[   38.130992]  ? __x64_sys_io_uring_enter+0x1c5/0x423
[   38.130994]  ? __x64_sys_io_uring_enter+0x1c5/0x423
[   38.134617] RDX: 0000000000000000 RSI: 0000000000040000 RDI: 
ffff88808173e400
[   38.135617]  ? __x64_sys_io_uring_enter+0x83/0x423
[   38.135619]  __x64_sys_io_uring_enter+0x1f6/0x423
[   38.135620]  ? __x64_sys_io_uring_enter+0x83/0x423
[   38.135624]  do_syscall_64+0x63/0x1a0
[   38.136758] RBP: ffff888083ba4498 R08: ffff8881ff30b078 R09: 
00000000fffffff0
[   38.138172]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.138174] RIP: 0033:0x7f78870132cd
[   38.138177] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   38.138990] R10: ffffffff82474ee0 R11: 0000000000000000 R12: 
0000000000000000
[   38.139778] RSP: 002b:00007ffe8781e238 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   38.139779] RAX: ffffffffffffffda RBX: 00007f7865cc1380 RCX: 
00007f78870132cd
[   38.139780] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   38.139781] RBP: 00007f7865cc1380 R08: 0000000000000000 R09: 
0000000000000000
[   38.139782] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000019b8650
[   38.140795] R13: ffff88808173e400 R14: 0000000000000000 R15: 
0000000000000000
[   38.142071] R13: 00000000000004b3 R14: 0000000000000001 R15: 
0000000001a232a8
[   38.142076] FIX io_kiocb: Restoring 
0x00000000ab4e622a-0x00000000ab4e622a=0x6b
[   38.142076]
[   38.143177] FS:  00007f78880c7740(0000) GS:ffff888233a00000(0000) 
knlGS:0000000000000000
[   38.144871] FIX io_kiocb: Marking all objects used
[   38.156470] BUG: unable to handle page fault for address: 
ffff888084174010
[   38.157440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.159346] #PF: supervisor read access in kernel mode
[   38.159347] #PF: error_code(0x0000) - not-present page
[   38.159348] PGD 4201067 P4D 4201067 PUD 23fb01067 PMD 23fae0067 PTE 
800fffff7be8b060
[   38.159352] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC PTI
[   38.160518] CR2: 00007f7865d35668 CR3: 00000001f3b74001 CR4: 
0000000000160ee0
[   38.162432] CPU: 11 PID: 4413 Comm: fio Tainted: G    B D W         
5.5.0-rc5-bij #350
[   38.162433] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   38.162437] RIP: 0010:debug_dma_unmap_sg+0x8f/0x140
[   38.163808] Kernel panic - not syncing: Fatal exception
[   38.165156] Code: 31 ff c7 44 24 0c 00 00 00 00 31 c0 b9 10 00 00 00 
48 89 df f3 48 ab 48 8b 04 24 48 ba 00 00 00 00 00 16 00 00 48 89 44 24 
20 <49> 8b 44 24 10 48 89 44 24 28 41 8b 44 24 18 c7 44 24 38 01 00 00
[   38.211209] RSP: 0018:ffffc90002297b30 EFLAGS: 00010246
[   38.212177] RAX: ffff8882316020b0 RBX: ffffc90002297b40 RCX: 
0000000000000000
[   38.213484] RDX: 0000160000000000 RSI: ffff888084174000 RDI: 
ffffc90002297bc0
[   38.214792] RBP: ffffc90002297c30 R08: 0000000000000000 R09: 
0000000000000001
[   38.216098] R10: ffff888083b89440 R11: 0000000000000001 R12: 
ffff888084174000
[   38.217405] R13: 0000000000000001 R14: 0000000000000002 R15: 
0000000000000000
[   38.218713] FS:  00007f78880c7740(0000) GS:ffff888235a00000(0000) 
knlGS:0000000000000000
[   38.220197] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.221256] CR2: ffff888084174010 CR3: 0000000200ae2004 CR4: 
0000000000160ee0
[   38.222566] Call Trace:
[   38.223040]  nvme_unmap_data+0x109/0x250 [nvme]
[   38.223886]  nvme_pci_complete_rq+0xda/0xf0 [nvme]
[   38.224778]  blk_mq_complete_request+0x47/0xf0
[   38.225600]  nvme_poll+0x23a/0x2c0 [nvme]
[   38.226352]  blk_poll+0x24f/0x320
[   38.226976]  ? __lock_acquire.isra.24+0x526/0x6c0
[   38.227850]  ? find_held_lock+0x3c/0xa0
[   38.228563]  io_iopoll_getevents+0x120/0x3d0
[   38.229359]  ? __x64_sys_io_uring_enter+0x260/0x423
[   38.230263]  __io_iopoll_check+0x75/0xa0
[   38.230996]  __x64_sys_io_uring_enter+0x270/0x423
[   38.231869]  ? __x64_sys_io_uring_enter+0x83/0x423
[   38.232761]  do_syscall_64+0x63/0x1a0
[   38.233442]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.234376] RIP: 0033:0x7f78870132cd
[   38.235046] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   38.238459] RSP: 002b:00007ffe8781e238 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   38.239858] RAX: ffffffffffffffda RBX: 00007f7865ca8300 RCX: 
00007f78870132cd
[   38.241168] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   38.242477] RBP: 00007f7865ca8300 R08: 0000000000000000 R09: 
0000000000000000
[   38.243788] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000019b8630
[   38.245094] R13: 0000000000000455 R14: 0000000000000001 R15: 
0000000001a2bb68
[   38.246404] Modules linked in: xfs dm_mod sr_mod sd_mod cdrom 
crc32c_intel nvme ata_piix nvme_core libata e1000 virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   38.249080] CR2: ffff888084174010
[   38.249702] ---[ end trace 6d29f9243c0c2fd5 ]---
[   38.250562] RIP: 0010:blkdev_bio_end_io+0x71/0xe0
[   38.251438] Code: 75 3c 0f b6 43 32 4c 8b 2b 84 c0 75 0a 48 8b 73 08 
49 01 75 08 eb 0b 0f b6 f8 e8 8a 85 0f 00 48 63 f0 48 8b 03 31 d2 4c 89 
ef <ff> 50 10 f6 43 14 01 74 32 48 8d 7b 18 e8 3d 39 0f 00 eb 27 48 8b
[   38.254855] RSP: 0018:ffffc900022bfc20 EFLAGS: 00010246
[   38.255820] RAX: ffff88808173e400 RBX: ffff888083ba4480 RCX: 
0000000033323691
[   38.257127] RDX: 0000000000000000 RSI: 0000000000040000 RDI: 
ffff88808173e400
[   38.258435] RBP: ffff888083ba4498 R08: ffff8881ff30b078 R09: 
00000000fffffff0
[   38.259747] R10: ffffffff82474ee0 R11: 0000000000000000 R12: 
0000000000000000
[   38.261056] R13: ffff88808173e400 R14: 0000000000000000 R15: 
0000000000000000
[   38.262366] FS:  00007f78880c7740(0000) GS:ffff888235a00000(0000) 
knlGS:0000000000000000
[   38.263854] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.264917] CR2: ffff888084174010 CR3: 0000000200ae2004 CR4: 
0000000000160ee0
[   39.230854] Shutting down cpus with NMI
[   39.231641] Kernel Offset: disabled
[   39.232302] ---[ end Kernel panic - not syncing: Fatal exception ]---

