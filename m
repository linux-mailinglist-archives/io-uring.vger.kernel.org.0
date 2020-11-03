Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351222A4FF1
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 20:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgKCTT1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 14:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgKCTTG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 14:19:06 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C64C061A04
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 11:19:06 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y14so15094714pfp.13
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 11:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zV/OnyQ0VTY12YwYrbYCgOsFCOBFm6BwEF5zbxZ+sIY=;
        b=xn8Aj1v7NRcD8zwfMSJT6YHUTNhBGjXZtOENVOGNdygsyrMWusZNiy3cWp5rQPSRNk
         pLf5jKIaEGt5988zNl82R5CViyek7x/MsexN4zXv8bOB0aGhhA75Tu6NE/O2Dgk1v52i
         tdlCaZx6c++T+o5u8ThkyYdoyLd1roMDodyzf2gEWTzi969eHKZdmt2TG8AQHN8XRhHn
         zVCTttPjL0NIu2oPZe9E2g7x754bvXDLM7zypDwM7iG6L5zgYgisBe/QgmVpoQWO1cIJ
         HQhyNK50zGss1dlpAEvWVwXuA7OcW5+obqgvIuYFSn+tBvwrwr45y5bVMeu/5PmXIk7p
         KPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zV/OnyQ0VTY12YwYrbYCgOsFCOBFm6BwEF5zbxZ+sIY=;
        b=JDTMMQIn7LIKDyMMiROqV7fC7/0v1OK86sUV9VslGRd2AWZCCrpFz9idYhAFTCUPAQ
         m0E9YaunhMxQ6cqt5hX8D7SH9DxgMe9SA765Aequcrx4hP6tTUQNs2LL3YqW0H10AGaW
         oGtqm5nFlHeP+l3okNk800vHXmVL7+g0ion/xRN+TgfmRuBX1Y8CKUfi+do7B+BzXj3b
         iNNBlTi2+afN+3zp5bmmSk1+Vm9Gm99kFXNbpp4eRyqIF3kMv32thcmPx1mqEavEUXpR
         LmnfwsmspvTHSd23sLyTa6oizmP8KkCWlfCqmC7/k3M0OcxjgTAlcNSZ2CVS2Oqjvrtt
         sqNw==
X-Gm-Message-State: AOAM531O9WGxT+URreHaWCN/EUSu/M+h7xAn7Es5jiVUKe4WUL/UYYn+
        saEp1VP5y2AsDDWTLpxtTysLIQ==
X-Google-Smtp-Source: ABdhPJwRNRrRATUtdL4+5hLrhIQWAudDuHUn938uynKE0OafXqk5sIatDFz+r9XSajXjppHizASbPQ==
X-Received: by 2002:a17:90b:4c43:: with SMTP id np3mr715481pjb.28.1604431145598;
        Tue, 03 Nov 2020 11:19:05 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21c1::164d? ([2620:10d:c090:400::5:c8a6])
        by smtp.gmail.com with ESMTPSA id b7sm19042215pfr.171.2020.11.03.11.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 11:19:04 -0800 (PST)
Subject: Re: KASAN: use-after-free Write in io_submit_sqes
To:     syzbot <syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000627c8805b33766e9@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c72570f5-8f56-c3a2-d371-70f8215305cd@kernel.dk>
Date:   Tue, 3 Nov 2020 12:19:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000627c8805b33766e9@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/3/20 10:43 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b49976d8 Add linux-next specific files for 20201102
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a02732500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe87d079ac78e2be
> dashboard link: https://syzkaller.appspot.com/bug?extid=625ce3bb7835b63f7f3d
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12de9346500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1213fda8500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com
> 
> IPVS: ftp: loaded support on port[0] = 21
> ==================================================================
> BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
> BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
> BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
> BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
> BUG: KASAN: use-after-free in io_init_req fs/io_uring.c:6700 [inline]
> BUG: KASAN: use-after-free in io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
> Write of size 4 at addr ffff888011e08e48 by task syz-executor165/8487
> 
> CPU: 1 PID: 8487 Comm: syz-executor165 Not tainted 5.10.0-rc1-next-20201102-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:186 [inline]
>  check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
>  __refcount_add include/linux/refcount.h:193 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  io_init_req fs/io_uring.c:6700 [inline]
>  io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
>  __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440e19
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fff644ff178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000440e19
> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
> RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000022b4850
> R13: 0000000000000010 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 8487:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
>  kmalloc include/linux/slab.h:552 [inline]
>  io_register_personality fs/io_uring.c:9638 [inline]
>  __io_uring_register fs/io_uring.c:9874 [inline]
>  __do_sys_io_uring_register+0x10f0/0x40a0 fs/io_uring.c:9924
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 8487:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
>  __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
>  slab_free mm/slub.c:3140 [inline]
>  kfree+0xdb/0x360 mm/slub.c:4122
>  io_identity_cow fs/io_uring.c:1380 [inline]
>  io_prep_async_work+0x903/0xbc0 fs/io_uring.c:1492
>  io_prep_async_link fs/io_uring.c:1505 [inline]
>  io_req_defer fs/io_uring.c:5999 [inline]
>  io_queue_sqe+0x212/0xed0 fs/io_uring.c:6448
>  io_submit_sqe fs/io_uring.c:6542 [inline]
>  io_submit_sqes+0x14f6/0x25f0 fs/io_uring.c:6784
>  __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff888011e08e00
>  which belongs to the cache kmalloc-96 of size 96
> The buggy address is located 72 bytes inside of
>  96-byte region [ffff888011e08e00, ffff888011e08e60)
> The buggy address belongs to the page:
> page:00000000a7104751 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e08
> flags: 0xfff00000000200(slab)
> raw: 00fff00000000200 ffffea00004f8540 0000001f00000002 ffff888010041780
> raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888011e08d00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>  ffff888011e08d80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>> ffff888011e08e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>                                               ^
>  ffff888011e08e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>  ffff888011e08f00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> ==================================================================

We need to drop the identity references separately, can't bundle them
into two.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f555e3c44cd..09369bc0317e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1287,9 +1287,12 @@ static bool io_identity_cow(struct io_kiocb *req)
 	/* add one for this request */
 	refcount_inc(&id->count);
 
-	/* drop old identity, assign new one. one ref for req, one for tctx */
-	if (req->work.identity != tctx->identity &&
-	    refcount_sub_and_test(2, &req->work.identity->count))
+	/* drop tctx and req identity references, if needed */
+	if (tctx->identity != &tctx->__identity &&
+	    refcount_dec_and_test(&tctx->identity->count))
+		kfree(tctx->identity);
+	if (req->work.identity != &tctx->__identity &&
+	    refcount_dec_and_test(&req->work.identity->count))
 		kfree(req->work.identity);
 
 	req->work.identity = id;

-- 
Jens Axboe

