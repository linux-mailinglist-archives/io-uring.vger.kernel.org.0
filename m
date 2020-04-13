Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE89B1A6FC1
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 01:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389946AbgDMXJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 19:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389929AbgDMXJp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 19:09:45 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226B6C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 16:09:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id c23so5159058pgj.3
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 16:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=USs+nbOPQabSlWHrTodmSKJ9sbeRMseO7ARPbs0ftY4=;
        b=YR5gCI7f6VWvPxmV0WZ0lRBw3J2UPH7ClPVjuisw1SeJ7OsoAYXySLmV4cufPOnXpJ
         FDkca35ZUpEKH2956ZGqzO5U70Dx26si9shCGDIW3fPGvOexs8oIsq4qAKkbkxBUf+0x
         hpDagV+l7Gpz+N41iRV102cNuDaN/2TXMLm+jJSmSOTIPCQfFWEwhuG4SFUROGsx6Gv5
         k/RY4tsoiZuytO+jJr6XycRtdCwOYzonD6ZJF0WtUNC5jkXi48u/wDMQfNcAbcd1DTxF
         aXaxRJ8x/K1N6Gm7nhvb6YDhrtxL3ug0EtsYMgaGHOwiNyYiTpkIVBk6UFc4/OBSRsrg
         L/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=USs+nbOPQabSlWHrTodmSKJ9sbeRMseO7ARPbs0ftY4=;
        b=cPcSK5TY3+lDcJlphipiLKSefhBewm1E48b5pHovNBsr8ydRIykuKaW89s/fTGhIwt
         yp//SrKtwj1V3qPaPrW+deu2zKBe6LQd7VBIOsYHRJ+fkvXvxwOxQDKObaibXuc9Zl7H
         DbWNNx8of6JIwmBUfCvreFD1JZq3dPh+UXDdAu7WYIZQscpoYw6ZbxK+U5dBEyPHO06j
         ttT5pNUp0IK4kBg7U15LJ07FjQYHVYisQlyQF2QqaxhuOGebM33bOwHbgKwYMlZhmXRO
         xRTpk2BWOsoIDJqsPoFnv2DuREFd5xMbgj2pnfzStjyy9z7MPincT8jbza94fuD1kLWg
         3Gdg==
X-Gm-Message-State: AGi0PuaoF2B07JhQx4Qt8Tx6hxiZk1OKuuRgvS5JQdM8n8CDFgkBvIjh
        awXf5WAZpzWSl+PpaDCbmamqTQ==
X-Google-Smtp-Source: APiQypJF5FkfpoqOrbKFI2om2Wg20ixyLoIt3hhnmaPnoxWKhrb75r94clYW8lVykUz2/WyOZmdrpg==
X-Received: by 2002:a63:31ca:: with SMTP id x193mr19022041pgx.146.1586819384603;
        Mon, 13 Apr 2020 16:09:44 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g16sm1199312pgh.30.2020.04.13.16.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 16:09:43 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Qian Cai <cai@lca.pw>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: only post events in io_poll_remove_all() if we
 completed some
Message-ID: <db263d71-83d8-9027-66f2-e18de1563025@kernel.dk>
Date:   Mon, 13 Apr 2020 17:09:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports this crash:

BUG: unable to handle page fault for address: ffffffffffffffe8
PGD f96e17067 P4D f96e17067 PUD f96e19067 PMD 0
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
CPU: 55 PID: 211750 Comm: trinity-c127 Tainted: G    B        L    5.7.0-rc1-next-20200413 #4
Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 04/12/2017
RIP: 0010:__wake_up_common+0x98/0x290
el/sched/wait.c:87
Code: 40 4d 8d 78 e8 49 8d 7f 18 49 39 fd 0f 84 80 00 00 00 e8 6b bd 2b 00 49 8b 5f 18 45 31 e4 48 83 eb 18 4c 89 ff e8 08 bc 2b 00 <45> 8b 37 41 f6 c6 04 75 71 49 8d 7f 10 e8 46 bd 2b 00 49 8b 47 10
RSP: 0018:ffffc9000adbfaf0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffe8 RCX: ffffffffaa9636b8
RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffffffffffffffe8
RBP: ffffc9000adbfb40 R08: fffffbfff582c5fd R09: fffffbfff582c5fd
R10: ffffffffac162fe3 R11: fffffbfff582c5fc R12: 0000000000000000
R13: ffff888ef82b0960 R14: ffffc9000adbfb80 R15: ffffffffffffffe8
FS:  00007fdcba4c4740(0000) GS:ffff889033780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffe8 CR3: 0000000f776a0004 CR4: 00000000001606e0
Call Trace:
 __wake_up_common_lock+0xea/0x150
ommon_lock at kernel/sched/wait.c:124
 ? __wake_up_common+0x290/0x290
 ? lockdep_hardirqs_on+0x16/0x2c0
 __wake_up+0x13/0x20
 io_cqring_ev_posted+0x75/0xe0
v_posted at fs/io_uring.c:1160
 io_ring_ctx_wait_and_kill+0x1c0/0x2f0
l at fs/io_uring.c:7305
 io_uring_create+0xa8d/0x13b0
 ? io_req_defer_prep+0x990/0x990
 ? __kasan_check_write+0x14/0x20
 io_uring_setup+0xb8/0x130
 ? io_uring_create+0x13b0/0x13b0
 ? check_flags.part.28+0x220/0x220
 ? lockdep_hardirqs_on+0x16/0x2c0
 __x64_sys_io_uring_setup+0x31/0x40
 do_syscall_64+0xcc/0xaf0
 ? syscall_return_slowpath+0x580/0x580
 ? lockdep_hardirqs_off+0x1f/0x140
 ? entry_SYSCALL_64_after_hwframe+0x3e/0xb3
 ? trace_hardirqs_off_caller+0x3a/0x150
 ? trace_hardirqs_off_thunk+0x1a/0x1c
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7fdcb9dd76ed
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6b 57 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe7fd4e4f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00000000000001a9 RCX: 00007fdcb9dd76ed
RDX: fffffffffffffffc RSI: 0000000000000000 RDI: 0000000000005d54
RBP: 00000000000001a9 R08: 0000000e31d3caa7 R09: 0082400004004000
R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000002
R13: 00007fdcb842e058 R14: 00007fdcba4c46c0 R15: 00007fdcb842e000
Modules linked in: bridge stp llc nfnetlink cn brd vfat fat ext4 crc16 mbcache jbd2 loop kvm_intel kvm irqbypass intel_cstate intel_uncore dax_pmem intel_rapl_perf dax_pmem_core ip_tables x_tables xfs sd_mod tg3 firmware_class libphy hpsa scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: binfmt_misc]
CR2: ffffffffffffffe8
---[ end trace f9502383d57e0e22 ]---
RIP: 0010:__wake_up_common+0x98/0x290
Code: 40 4d 8d 78 e8 49 8d 7f 18 49 39 fd 0f 84 80 00 00 00 e8 6b bd 2b 00 49 8b 5f 18 45 31 e4 48 83 eb 18 4c 89 ff e8 08 bc 2b 00 <45> 8b 37 41 f6 c6 04 75 71 49 8d 7f 10 e8 46 bd 2b 00 49 8b 47 10
RSP: 0018:ffffc9000adbfaf0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffe8 RCX: ffffffffaa9636b8
RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffffffffffffffe8
RBP: ffffc9000adbfb40 R08: fffffbfff582c5fd R09: fffffbfff582c5fd
R10: ffffffffac162fe3 R11: fffffbfff582c5fc R12: 0000000000000000
R13: ffff888ef82b0960 R14: ffffc9000adbfb80 R15: ffffffffffffffe8
FS:  00007fdcba4c4740(0000) GS:ffff889033780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffe8 CR3: 0000000f776a0004 CR4: 00000000001606e0
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x29800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]—

which is due to error injection (or allocation failure) preventing the
rings from being setup. On shutdown, we attempt to remove any pending
requests, and for poll request, we call io_cqring_ev_posted() when we've
killed poll requests. However, since the rings aren't setup, we won't
find any poll requests. Make the calling of io_cqring_ev_posted()
dependent on actually having completed requests. This fixes this setup
corner case, and removes spurious calls if we remove poll requests and
don't find any.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aac54772e12e..32cbace58256 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4392,7 +4392,7 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
-	int i;
+	int posted = 0, i;
 
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
@@ -4400,11 +4400,12 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx)
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node)
-			io_poll_remove_one(req);
+			posted += io_poll_remove_one(req);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_ev_posted(ctx);
+	if (posted)
+		io_cqring_ev_posted(ctx);
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)

-- 
Jens Axboe

