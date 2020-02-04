Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A015226F
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2020 23:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgBDWoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 17:44:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgBDWoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 17:44:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014Mf3Ni021725;
        Tue, 4 Feb 2020 22:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Oyut+0d3///xJcwZyzOszm6ZkGSDjQ645MC6RdfTna8=;
 b=X7KFJXzMEx0F3nkJmaFzxHIHqm+mjMwYjvminlPRZRaOHtzOGrRyHrf7sMCe42QK0GP7
 v21uG3okICmrO+DklQNTZhGq2vtbbEFFn4xy86ULpBw64qQ+dxS3XUA7L2RE2mwa2601
 xam3Rx1x0xpjWRiSQ++ucpZ+l3TzmAFTLZj4OzdVu66E8VP9mZXtncy1yhS9CTQsxRj6
 HwrOP/O64MSZK8lYa0CtgLPGFpqeUy8m9obaUhuJDDkDHomEUN+FGz2tCKy4584lbfoJ
 3J1QQ9hBKuMo6NZsQ/owH4FeVUSRP6Fmmz0g0yUtLppnNzFBz5QlTmIDqBzljIsT07OA 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xyhkfg08v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 22:43:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014MfdpA089150;
        Tue, 4 Feb 2020 22:41:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xyhmq003j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 22:41:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 014MfdPp007979;
        Tue, 4 Feb 2020 22:41:40 GMT
Received: from [10.154.162.90] (/10.154.162.90)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 14:41:39 -0800
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
 <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
 <20200203083422.GA2671@infradead.org>
 <aaecd43b-dd44-f6c5-4e2d-1772cf135d2a@oracle.com>
 <20200204075124.GA29349@infradead.org>
 <46bf2ea0-7677-44af-8e23-45a10710ca3d@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <f9913e81-5da8-902b-ba17-2e70d59dbd9c@oracle.com>
Date:   Tue, 4 Feb 2020 14:41:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <46bf2ea0-7677-44af-8e23-45a10710ca3d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200203-2, 02/03/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040155
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/2020 12:59 PM, Jens Axboe wrote:
> On 2/4/20 12:51 AM, Christoph Hellwig wrote:
>> On Mon, Feb 03, 2020 at 01:07:48PM -0800, Bijan Mottahedeh wrote:
>>> My concern is with the code below for the single bio async case:
>>>
>>>                             qc = submit_bio(bio);
>>>
>>>                             if (polled)
>>>                                     WRITE_ONCE(iocb->ki_cookie, qc);
>>>
>>> The bio/dio can be freed before the the cookie is written which is what I'm
>>> seeing, and I thought this may lead to a scenario where that iocb request
>>> could be completed, freed, reallocated, and resubmitted in io_uring layer;
>>> i.e., I thought the cookie could be written into the wrong iocb.
>> I think we do have a potential use after free of the iocb here.
>> But taking a bio reference isn't going to help with that, as the iocb
>> and bio/dio life times are unrelated.
>>
>> I vaguely remember having that discussion with Jens a while ago, and
>> tried to pass a pointer to the qc to submit_bio so that we can set
>> it at submission time, but he came up with a reason why that might not
>> be required.  I'd have to dig out all notes unless Jens remembers
>> better.
> Don't remember that either, so I'd have to dig out emails! But looking
> at it now, for the async case with io_uring, the iocb is embedded in the
> io_kiocb from io_uring. We hold two references to the io_kiocb, one for
> submit and one for completion. Hence even if the bio completes
> immediately and someone else finds the completion before the application
> doing this submit, we still hold the submission reference to the
> io_kiocb. Hence I don't really see how we can end up with a
> use-after-free situation here.
>
> IIRC, Bijan had traces showing this can happen, KASAN complaining about
> it. Which makes me think that I'm missing a case here, though I don't
> immediately see what it is.
>
> Bijan, could post your trace again, I can't seem to find it?
>

Trace included below; note the two different warnings:

[   90.785364] WARNING: CPU: 3 PID: 4731 at lib/refcount.c:28 
refcount_warn_saturate+0xa1/0xf0
[   90.838168] WARNING: CPU: 2 PID: 4714 at kernel/dma/debug.c:1051 
check_unmap+0x459/0x870
[   90.959286] WARNING: CPU: 8 PID: 4716 at kernel/dma/debug.c:1014 
check_unmap+0x145/0x870

This is the bug I was originally chasing when I suspected the single bio 
async case code above but it doesn't seem to related.

It happens pretty reliably though not necessarily with the two warnings 
at the same time.  Let me know if you want to tweak anything.

--bijan

-----------------------------------------------------------------------------------------

[   90.774034] nvme 0000:00:04.0: dma_pool_free prp list page, 
000000008f36ce00 (bad vaddr)/0x00000000830ae000
[   90.780098] ------------[ cut here ]------------
[   90.782388] refcount_t: underflow; use-after-free.
[   90.785364] WARNING: CPU: 3 PID: 4731 at lib/refcount.c:28 
refcount_warn_saturate+0xa1/0xf0
[   90.788181] Modules linked in: xfs dm_mod sr_mod cdrom sd_mod 
crc32c_intel nvme ata_piix nvme_core e1000 t10_pi libata virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   90.794794] CPU: 3 PID: 4731 Comm: fio Not tainted 
5.5.0-next-20200203-bij #610
[   90.797396] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   90.801519] RIP: 0010:refcount_warn_saturate+0xa1/0xf0
[   90.803549] Code: 4c 28 01 01 e8 d0 8f c4 ff 0f 0b c3 80 3d 14 4c 28 
01 00 75 59 48 c7 c7 68 15 17 82 31 c0 c6 05 02 4c 28 01 01 e8 af 8f c4 
ff <0f> 0b c3 80 3d f2 4b 28 01 00 75 38 48 c7 c7 90 15 17 82 31 c0 c6
[   90.812441] RSP: 0018:ffffc900024d3cb8 EFLAGS: 00010286
[   90.813911] RAX: 0000000000000000 RBX: ffff888226f2b700 RCX: 
0000000000000000
[   90.816595] RDX: ffff888233bfab40 RSI: ffff888233bea408 RDI: 
ffff888233bea408
[   90.819218] RBP: ffff8882286d6e78 R08: ffff88822cba30c0 R09: 
00000000fffffff0
[   90.822529] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffffe8fffd600580
[   90.825082] R13: ffff888226f2b700 R14: ffff8882286d6e78 R15: 
ffff888228abda80
[   90.827679] FS:  00007fbecf69a740(0000) GS:ffff888233a00000(0000) 
knlGS:0000000000000000
[   90.829474] ------------[ cut here ]------------
[   90.830949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.830953] CR2: 00007f1037f54000 CR3: 00000001f46b4001 CR4: 
0000000000160ee0
[   90.832778] DMA-API: nvme 0000:00:04.0: device driver frees DMA sg 
list with different entry count [map count=2] [unmap count=1]
[   90.834876] Call Trace:
[   90.838168] WARNING: CPU: 2 PID: 4714 at kernel/dma/debug.c:1051 
check_unmap+0x459/0x870
[   90.843447]  blk_mq_complete_request+0x47/0xf0
[   90.844292] Modules linked in: xfs dm_mod sr_mod cdrom sd_mod 
crc32c_intel nvme ata_piix nvme_core e1000 t10_pi libata virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   90.848498]  nvme_poll+0x23a/0x2c0 [nvme]
[   90.850475] CPU: 2 PID: 4714 Comm: fio Not tainted 
5.5.0-next-20200203-bij #610
[   90.857373]  blk_poll+0x24f/0x320
[   90.858513] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   90.858519] RIP: 0010:check_unmap+0x459/0x870
[   90.860929]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.862191] Code: d1 03 00 00 4c 8b 37 e9 c9 03 00 00 49 c7 c6 f3 8f 
14 82 4c 89 f6 44 89 f9 4c 89 f2 48 c7 c7 f8 8c 12 82 31 c0 e8 57 2c f7 
ff <0f> 0b 48 c7 c7 9c 84 12 82 31 c0 e8 cb 73 fe ff 8b 73 4c 48 8d 7b
[   90.868222]  ? find_held_lock+0x38/0xa0
[   90.871415] RSP: 0018:ffffc9000158bad8 EFLAGS: 00010086
[   90.874370]  io_iopoll_getevents+0x11c/0x2e0
[   90.882129] RAX: 0000000000000000 RBX: ffff8882311afe80 RCX: 
0000000000000001
[   90.882132] RDX: 0000000000000001 RSI: 00000000d97dcdbe RDI: 
ffff8882337ea400
[   90.885032]  ? kvm_sched_clock_read+0xd/0x20
[   90.887837] RBP: ffffc9000158bb40 R08: ffff8881fe1bd5b8 R09: 
00000000b4d5c0f0
[   90.889983]  ? __x64_sys_io_uring_enter+0x1fb/0x420
[   90.892835] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffffffff834f6bd8
[   90.896551]  ? __x64_sys_io_uring_enter+0x259/0x420
[   90.898401] R13: 0000000000000282 R14: ffff8882307b82a0 R15: 
0000000000000002
[   90.898405] FS:  00007fbecf69a740(0000) GS:ffff888233600000(0000) 
knlGS:0000000000000000
[   90.901417]  __io_iopoll_check+0x75/0xa0
[   90.903627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.903629] CR2: 00007f4f8806b1f8 CR3: 00000001f89de005 CR4: 
0000000000160ee0
[   90.906273]  __x64_sys_io_uring_enter+0x269/0x420
[   90.909268] Call Trace:
[   90.911805]  ? __x64_sys_io_uring_enter+0x83/0x420
[   90.911818]  do_syscall_64+0x63/0x1a0
[   90.915022]  debug_dma_unmap_sg+0xff/0x140
[   90.916977]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   90.918894]  ? kvm_sched_clock_read+0xd/0x20
[   90.921652] RIP: 0033:0x7fbece5e62cd
[   90.923601]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.925060] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   90.927287]  nvme_unmap_data+0x109/0x250 [nvme]
[   90.929843] RSP: 002b:00007ffd6a00b8b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   90.932078]  nvme_pci_complete_rq+0xda/0xf0 [nvme]
[   90.933924] RAX: ffffffffffffffda RBX: 00007fbead343700 RCX: 
00007fbece5e62cd
[   90.933926] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   90.935992]  blk_mq_complete_request+0x47/0xf0
[   90.937856] RBP: 00007fbead343700 R08: 0000000000000000 R09: 
0000000000000000
[   90.937859] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000024ce730
[   90.941177]  nvme_poll+0x23a/0x2c0 [nvme]
[   90.949896] R13: 0000000000004329 R14: 0000000000000001 R15: 
000000000250e728
[   90.949912] ---[ end trace 6f10eae6c97ebbfe ]---
[   90.951749]  blk_poll+0x24f/0x320
[   90.959132] nvme 0000:00:04.0: dma_pool_free prp list page, 
000000005fe36fa7 (bad vaddr)/0x0000000083911000
[   90.959246]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.959263] ------------[ cut here ]------------
[   90.959267] DMA-API: nvme 0000:00:04.0: device driver tries to free 
DMA memory it has not allocated [device address=0x6b6b6b6b6b6b6b6b] 
[size=1802201963 bytes]
[   90.959286] WARNING: CPU: 8 PID: 4716 at kernel/dma/debug.c:1014 
check_unmap+0x145/0x870
[   90.959288] Modules linked in: xfs dm_mod sr_mod cdrom sd_mod 
crc32c_intel nvme ata_piix nvme_core e1000 t10_pi libata virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   90.959305] CPU: 8 PID: 4716 Comm: fio Tainted: G W         
5.5.0-next-20200203-bij #610
[   90.959307] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   90.959310] RIP: 0010:check_unmap+0x145/0x870
[   90.959312] Code: 00 48 8b 1f e9 59 06 00 00 48 c7 c3 f3 8f 14 82 48 
89 de 4d 89 e8 4c 89 e1 48 89 da 48 c7 c7 98 8a 12 82 31 c0 e8 6b 2f f7 
ff <0f> 0b 8b 15 63 49 5e 01 85 d2 0f 85 08 07 00 00 8b 05 c1 b1 40 01
[   90.959314] RSP: 0018:ffffc90002463ad8 EFLAGS: 00010286
[   90.959316] RAX: 0000000000000000 RBX: ffff8882307b82a0 RCX: 
0000000000000001
[   90.959317] RDX: 0000000000000001 RSI: 00000000fea2a5f1 RDI: 
ffff888234fea400
[   90.959318] RBP: ffffc90002463b40 R08: ffff8881fe1bb0c0 R09: 
00000000fffffff0
[   90.959319] R10: 0000000000000001 R11: 0000000000000000 R12: 
6b6b6b6b6b6b6b6b
[   90.959320] R13: 000000006b6b6b6b R14: 0000000000000002 R15: 
0000000000000001
[   90.959322] FS:  00007fbecf69a740(0000) GS:ffff888234e00000(0000) 
knlGS:0000000000000000
[   90.959323] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.959324] CR2: 000055ec5f1b4f70 CR3: 00000001fa136001 CR4: 
0000000000160ee0
[   90.959329] Call Trace:
[   90.959335]  ? do_raw_spin_unlock+0x83/0x90
[   90.959342]  debug_dma_unmap_sg+0xff/0x140
[   90.959358]  ? kvm_sched_clock_read+0xd/0x20
[   90.959363]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.959370]  nvme_unmap_data+0x109/0x250 [nvme]
[   90.959378]  nvme_pci_complete_rq+0xda/0xf0 [nvme]
[   90.959384]  blk_mq_complete_request+0x47/0xf0
[   90.959389]  nvme_poll+0x23a/0x2c0 [nvme]
[   90.959396]  blk_poll+0x24f/0x320
[   90.959399]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.959406]  ? find_held_lock+0x38/0xa0
[   90.959416]  io_iopoll_getevents+0x11c/0x2e0
[   90.959425]  ? __mutex_unlock_slowpath+0x14e/0x250
[   90.959429]  ? __x64_sys_io_uring_enter+0x259/0x420
[   90.959438]  __io_iopoll_check+0x75/0xa0
[   90.959444]  __x64_sys_io_uring_enter+0x269/0x420
[   90.959445]  ? __x64_sys_io_uring_enter+0x83/0x420
[   90.959458]  do_syscall_64+0x63/0x1a0
[   90.959462]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   90.959465] RIP: 0033:0x7fbece5e62cd
[   90.959467] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   90.959468] RSP: 002b:00007ffd6a00b8b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   90.959470] RAX: ffffffffffffffda RBX: 00007fbead217100 RCX: 
00007fbece5e62cd
[   90.959471] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   90.959472] RBP: 00007fbead217100 R08: 0000000000000000 R09: 
0000000000000000
[   90.959473] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000024ce5b0
[   90.959474] R13: 000000000000465a R14: 0000000000000001 R15: 
000000000252de28
[   90.959489] ---[ end trace 6f10eae6c97ebbff ]---
[   90.959500] general protection fault, probably for non-canonical 
address 0x6b6b6b6b6b6b7b63: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[   90.959501] CPU: 8 PID: 4716 Comm: fio Tainted: G W         
5.5.0-next-20200203-bij #610
[   90.959502] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   90.959504] RIP: 0010:nvme_unmap_data+0x1f8/0x250 [nvme]
[   90.959505] Code: 75 0b 0f b7 83 c2 00 00 00 48 c1 e0 05 80 bb 40 01 
00 00 00 48 63 cd 48 8d 14 ca 48 8b 34 02 74 09 4c 8b b6 f0 0f 00 00 eb 
04 <4e> 8b 34 2e 49 8b bf 58 02 00 00 4c 89 e2 83 c5 01 e8 42 2e 15 e1
[   90.959506] RSP: 0018:ffffc90002463c38 EFLAGS: 00010246
[   90.959508] RAX: 0000000000000020 RBX: ffff888226f58400 RCX: 
0000000000000000
[   90.959508] RDX: ffff888083742000 RSI: 6b6b6b6b6b6b6b6b RDI: 
ffff888083742000
[   90.959509] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000001
[   90.959510] R10: 0000000000000001 R11: 0000000000000000 R12: 
000000011a06b000
[   90.959510] R13: 0000000000000ff8 R14: ffff8882316020b0 R15: 
ffff888228a00000
[   90.959511] FS:  00007fbecf69a740(0000) GS:ffff888234e00000(0000) 
knlGS:0000000000000000
[   90.959512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.959513] CR2: 000055ec5f1b4f70 CR3: 00000001fa136001 CR4: 
0000000000160ee0
[   90.959513] Call Trace:
[   90.959517]  nvme_pci_complete_rq+0xda/0xf0 [nvme]
[   90.959519]  blk_mq_complete_request+0x47/0xf0
[   90.959522]  nvme_poll+0x23a/0x2c0 [nvme]
[   90.959525]  blk_poll+0x24f/0x320
[   90.959526]  ? __lock_acquire.isra.27+0x526/0x6c0
[   90.959529]  ? find_held_lock+0x38/0xa0
[   90.959532]  io_iopoll_getevents+0x11c/0x2e0
[   90.959535]  ? __mutex_unlock_slowpath+0x14e/0x250
[   90.959537]  ? __x64_sys_io_uring_enter+0x259/0x420
[   90.959540]  __io_iopoll_check+0x75/0xa0
[   90.959543]  __x64_sys_io_uring_enter+0x269/0x420
[   90.959544]  ? __x64_sys_io_uring_enter+0x83/0x420
[   90.959548]  do_syscall_64+0x63/0x1a0
[   90.959550]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   90.959551] RIP: 0033:0x7fbece5e62cd
[   90.959552] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   90.959552] RSP: 002b:00007ffd6a00b8b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   90.959554] RAX: ffffffffffffffda RBX: 00007fbead217100 RCX: 
00007fbece5e62cd
[   90.959554] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   90.959566] RBP: 00007fbead217100 R08: 0000000000000000 R09: 
0000000000000000
[   90.959567] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000024ce5b0
[   90.959568] R13: 000000000000465a R14: 0000000000000001 R15: 
000000000252de28
[   90.959572] Modules linked in: xfs dm_mod sr_mod cdrom sd_mod 
crc32c_intel nvme ata_piix nvme_core e1000 t10_pi libata virtio_pci 
9pnet_virtio virtio_ring virtio 9p 9pnet
[   90.959588] ---[ end trace 6f10eae6c97ebc00 ]---
[   90.959590] RIP: 0010:nvme_unmap_data+0x1f8/0x250 [nvme]
[   90.959591] Code: 75 0b 0f b7 83 c2 00 00 00 48 c1 e0 05 80 bb 40 01 
00 00 00 48 63 cd 48 8d 14 ca 48 8b 34 02 74 09 4c 8b b6 f0 0f 00 00 eb 
04 <4e> 8b 34 2e 49 8b bf 58 02 00 00 4c 89 e2 83 c5 01 e8 42 2e 15 e1
[   90.959592] RSP: 0018:ffffc90002463c38 EFLAGS: 00010246
[   90.959593] RAX: 0000000000000020 RBX: ffff888226f58400 RCX: 
0000000000000000
[   90.959595] RDX: ffff888083742000 RSI: 6b6b6b6b6b6b6b6b RDI: 
ffff888083742000
[   90.959595] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000001
[   90.959596] R10: 0000000000000001 R11: 0000000000000000 R12: 
000000011a06b000
[   90.959597] R13: 0000000000000ff8 R14: ffff8882316020b0 R15: 
ffff888228a00000
[   90.959598] FS:  00007fbecf69a740(0000) GS:ffff888234e00000(0000) 
knlGS:0000000000000000
[   90.959599] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.959599] CR2: 000055ec5f1b4f70 CR3: 00000001fa136001 CR4: 
0000000000160ee0
[   90.959600] Kernel panic - not syncing: Fatal exception
[   91.154129]  ? find_held_lock+0x38/0xa0
[   91.154817]  io_iopoll_getevents+0x11c/0x2e0
[   91.155574]  ? kvm_sched_clock_read+0xd/0x20
[   91.156335]  ? __x64_sys_io_uring_enter+0x1fb/0x420
[   91.157203]  ? __x64_sys_io_uring_enter+0x259/0x420
[   91.158075]  __io_iopoll_check+0x75/0xa0
[   91.158781]  __x64_sys_io_uring_enter+0x269/0x420
[   91.159624]  ? __x64_sys_io_uring_enter+0x83/0x420
[   91.160491]  do_syscall_64+0x63/0x1a0
[   91.161178]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   91.162090] RIP: 0033:0x7fbece5e62cd
[   91.162742] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b 6b 2c 00 f7 d8 64 89 01 48
[   91.166010] RSP: 002b:00007ffd6a00b8b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   91.167342] RAX: ffffffffffffffda RBX: 00007fbead1e5000 RCX: 
00007fbece5e62cd
[   91.168597] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
0000000000000003
[   91.169851] RBP: 00007fbead1e5000 R08: 0000000000000000 R09: 
0000000000000000
[   91.171105] R10: 0000000000000001 R11: 0000000000000246 R12: 
00000000024ce570
[   91.172360] R13: 0000000000004689 R14: 0000000000000001 R15: 
00000000024e0c68
[   91.173618] ---[ end trace 6f10eae6c97ebc01 ]---
[   91.174439] DMA-API: Mapped at:
[   91.175011]  debug_dma_map_sg+0x4e/0x340
[   91.175717]  nvme_queue_rq+0x41f/0xc99 [nvme]
[   91.176495]  __blk_mq_try_issue_directly+0x120/0x1f0
[   91.177381]  blk_mq_try_issue_directly+0x57/0xb0
[   91.178206]  blk_mq_make_request+0x4fe/0x650
[   91.179024] Kernel Offset: disabled
[   91.179671] ---[ end Kernel panic - not syncing: Fatal exception ]---


