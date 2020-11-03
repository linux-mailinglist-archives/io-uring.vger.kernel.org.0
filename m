Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8C2A50DF
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 21:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgKCU2j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 15:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCU2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 15:28:39 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AA3C0617A6
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 12:28:38 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id z2so17286059ilh.11
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 12:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ANJthhraSHiJ7O8q/9pmHZwUckFdNsf0+PdLSnpaQY=;
        b=CNZsfAwTy4TGccTuaiO62YqQatrdryXkZtTlIwvUnkG6jsN0S3RFQvtR7/VyNJpFw2
         3MXOfxvULH796SCxELeOa7bgV58k4QJVpS2wCBncwTm2ZsGACd+IXmBNfXpxlYZDWZ+5
         ShV4avk9SG9LsfnsCLs6FOwj89Y1oTVduDUqDymQBP4ob0yHiTyJvLD6UpO3/PGthXYP
         PrNhLiJCnH+DluV57c43bpL3/2M+sVeMDVG33FgqdUs1oACP+41n+kC/p0fhAckI/lio
         AqpsYSGjVhVgq5SRbO2d1dyXQJyBi+T0luFjvhC1z/bcvP0JcCnjR8z9rTgClLjnrbol
         7mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ANJthhraSHiJ7O8q/9pmHZwUckFdNsf0+PdLSnpaQY=;
        b=IYGQUhA2AlKnkv69Cu3EE/LnUo18Y5f6V9lUywYWyTno2TXypOIWQ2hef9usSayC7b
         eOKdNyox6Cq/32j07wylS92kvuGHF0sgzJZkemEns2GdyUtfTxG1rOrWa23BuGCHwcqg
         Cng6OWrhd7PBVN+2xEKqtjrzQheGH/fDkJLSyLQF+wXMekBjedhrRVl5N/SxXxfpCEGA
         of2jrkQ2m8VKrO1MH+MXPwnQZr3MMEf+ZK6jhcBn9eYz+fvW8cl8uFYINWvgYHUPCrmt
         yyh6eE7+4iGWa4S+tz9MQlCjeLTZ79/D1FlC5CoGK32NBNDPNb91W8WQT9J72HG/KU5/
         O7OA==
X-Gm-Message-State: AOAM532k3riaZtyMUcrj4PGCfDT4/NC/+fwlNbeM7QZvMOelFFBI1UbX
        VC3V3i9zG0DHyG7qKIASK8bnKsqC1XGxsA==
X-Google-Smtp-Source: ABdhPJxFYpkqgaQCgMAuZkxX/wVhlK3tpRgt8Z3rQslnKya48LGhs3XEeyViUketDcemSvysg2+Xbw==
X-Received: by 2002:a92:c5ce:: with SMTP id s14mr16396295ilt.40.1604435317962;
        Tue, 03 Nov 2020 12:28:37 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm13472902ilf.19.2020.11.03.12.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:28:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com
Subject: [PATCH 4/4] io_uring: drop req/tctx io_identity separately
Date:   Tue,  3 Nov 2020 13:28:32 -0700
Message-Id: <20201103202832.923305-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103202832.923305-1-axboe@kernel.dk>
References: <20201103202832.923305-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can't bundle this into one operation, as the identity may not have
originated from the tctx to begin with. Drop one ref for each of them
separately, if they don't match the static assignment. If we don't, then
if the identity is a lookup from registered credentials, we could be
freeing that identity as we're dropping a reference assuming it came from
the tctx. syzbot reports this as a use-after-free, as the identity is
still referencable from idr lookup:

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in io_init_req fs/io_uring.c:6700 [inline]
BUG: KASAN: use-after-free in io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
Write of size 4 at addr ffff888011e08e48 by task syz-executor165/8487

CPU: 1 PID: 8487 Comm: syz-executor165 Not tainted 5.10.0-rc1-next-20201102-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 io_init_req fs/io_uring.c:6700 [inline]
 io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
 __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440e19
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff644ff178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000440e19
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000022b4850
R13: 0000000000000010 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8487:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:552 [inline]
 io_register_personality fs/io_uring.c:9638 [inline]
 __io_uring_register fs/io_uring.c:9874 [inline]
 __do_sys_io_uring_register+0x10f0/0x40a0 fs/io_uring.c:9924
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8487:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3140 [inline]
 kfree+0xdb/0x360 mm/slub.c:4122
 io_identity_cow fs/io_uring.c:1380 [inline]
 io_prep_async_work+0x903/0xbc0 fs/io_uring.c:1492
 io_prep_async_link fs/io_uring.c:1505 [inline]
 io_req_defer fs/io_uring.c:5999 [inline]
 io_queue_sqe+0x212/0xed0 fs/io_uring.c:6448
 io_submit_sqe fs/io_uring.c:6542 [inline]
 io_submit_sqes+0x14f6/0x25f0 fs/io_uring.c:6784
 __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888011e08e00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 72 bytes inside of
 96-byte region [ffff888011e08e00, ffff888011e08e60)
The buggy address belongs to the page:
page:00000000a7104751 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e08
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00004f8540 0000001f00000002 ffff888010041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888011e08d00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888011e08d80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> ffff888011e08e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                              ^
 ffff888011e08e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888011e08f00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================

Reported-by: syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com
Fixes: 1e6fa5216a0e ("io_uring: COW io_identity on mismatch")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

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
2.29.2

