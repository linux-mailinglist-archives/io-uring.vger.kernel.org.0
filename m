Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7354B61F4
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 05:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiBOEKS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 23:10:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiBOEKR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 23:10:17 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B5FAFF59;
        Mon, 14 Feb 2022 20:10:08 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id l19so26956211pfu.2;
        Mon, 14 Feb 2022 20:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sH4/2oJtfi5laET5tEMr+Y3iQdUpMaIDyoN80AX7CZk=;
        b=TFB9JYwYT2dieEmGZmjGby6qN+n15NKEVhbbshPnmGbfZM5sMIGksQiob4rIqkMXAE
         1iXaDhLW9Wp7Np+0a6OLl5f4+qly1AO+QCk5YulLk9bvoKG/7GsgG3redqZX/h/RopHQ
         paopzfRbA74736juS6cvZhCxmrtnZ5jzuupmRIpyClljBpph+xqWclLfuHrQ5/Efqgr/
         ZM6XmM8qcBSHiJbO2aKU0mYvzrq/vTWdyls/MayWpK/KPaEoPbsmrPeTsWJST/OzIkK5
         NRpOilJd1ExVzxOtDipjk2uKuxopa/aySiPiYbgm/EGFhF4TuRIwPfX+XTWRk1GisvCM
         an2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sH4/2oJtfi5laET5tEMr+Y3iQdUpMaIDyoN80AX7CZk=;
        b=ft0QTSBn6MVz3BFm2kAS5Qw7O10PYfz9pZXEEcodv8K4qZWHTuYEppZfaCEHVs0gmw
         5ji71J6G57cNEV4eIVEJbc/ClX5E5PH3MKx1ZQzyWlVFaxF4FsMr3vqJros4VaUUSumd
         vXkHsA8Wpp9mhcuXZbWHDQSt5bAwrIQXNBJuFzNowS8kk3V2sT+LDT/OvPjCSimA4+ok
         CCB02GuIWhz6r4Ujee34sB8PIRmX6cb214EwSzObqazoDYD+Oid+e5vVMvPShTtY36us
         MjtSd7FTo/3hlvnudWDECLKn2Eb+xMfSCyNH5HcOWINd1fT0vIEBX2Cl+N3y9qVb5q0h
         j5Hw==
X-Gm-Message-State: AOAM533QIvtvCxjYg/bl76s8jhUV97N9Dzls6/kA4sTNtO7oEShSCepp
        KiooI+UMl4/7+ODAJ3uye6ukuf3Y36M=
X-Google-Smtp-Source: ABdhPJzBnrC5+k4E1LSF4Y/ZMXxUsvgq54z6F3pzi8xaU875WJtw9MKOdzTK1Ka9HrtVqhCxKHQjEg==
X-Received: by 2002:aa7:88d1:: with SMTP id k17mr2053151pff.38.1644898207434;
        Mon, 14 Feb 2022 20:10:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ff52:228f:b44e:a40b])
        by smtp.gmail.com with ESMTPSA id bm3sm871353pgb.88.2022.02.14.20.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 20:10:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH] io_uring: add a schedule point in io_add_buffers()
Date:   Mon, 14 Feb 2022 20:10:03 -0800
Message-Id: <20220215041003.2394784-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Looping ~65535 times doing kmalloc() calls can trigger soft lockups,
especially with DEBUG features (like KASAN).

[  253.536212] watchdog: BUG: soft lockup - CPU#64 stuck for 26s! [b219417889:12575]
[  253.544433] Modules linked in: vfat fat i2c_mux_pca954x i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
[  253.544451] CPU: 64 PID: 12575 Comm: b219417889 Tainted: G S         O      5.17.0-smp-DEV #801
[  253.544457] RIP: 0010:kernel_text_address (./include/asm-generic/sections.h:192 ./include/linux/kallsyms.h:29 kernel/extable.c:67 kernel/extable.c:98)
[  253.544464] Code: 0f 93 c0 48 c7 c1 e0 63 d7 a4 48 39 cb 0f 92 c1 20 c1 0f b6 c1 5b 5d c3 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 53 48 89 fb <48> c7 c0 00 00 80 a0 41 be 01 00 00 00 48 39 c7 72 0c 48 c7 c0 40
[  253.544468] RSP: 0018:ffff8882d8baf4c0 EFLAGS: 00000246
[  253.544471] RAX: 1ffff1105b175e00 RBX: ffffffffa13ef09a RCX: 00000000a13ef001
[  253.544474] RDX: ffffffffa13ef09a RSI: ffff8882d8baf558 RDI: ffffffffa13ef09a
[  253.544476] RBP: ffff8882d8baf4d8 R08: ffff8882d8baf5e0 R09: 0000000000000004
[  253.544479] R10: ffff8882d8baf5e8 R11: ffffffffa0d59a50 R12: ffff8882eab20380
[  253.544481] R13: ffffffffa0d59a50 R14: dffffc0000000000 R15: 1ffff1105b175eb0
[  253.544483] FS:  00000000016d3380(0000) GS:ffff88af48c00000(0000) knlGS:0000000000000000
[  253.544486] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  253.544488] CR2: 00000000004af0f0 CR3: 00000002eabfa004 CR4: 00000000003706e0
[  253.544491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  253.544492] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  253.544494] Call Trace:
[  253.544496]  <TASK>
[  253.544498] ? io_queue_sqe (fs/io_uring.c:7143)
[  253.544505] __kernel_text_address (kernel/extable.c:78)
[  253.544508] unwind_get_return_address (arch/x86/kernel/unwind_frame.c:19)
[  253.544514] arch_stack_walk (arch/x86/kernel/stacktrace.c:27)
[  253.544517] ? io_queue_sqe (fs/io_uring.c:7143)
[  253.544521] stack_trace_save (kernel/stacktrace.c:123)
[  253.544527] ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
[  253.544531] ? ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
[  253.544533] ? __kasan_kmalloc (mm/kasan/common.c:524)
[  253.544535] ? kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
[  253.544541] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544544] ? __io_queue_sqe (fs/io_uring.c:?)
[  253.544551] __kasan_kmalloc (mm/kasan/common.c:524)
[  253.544553] kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
[  253.544556] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544560] io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544564] ? __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
[  253.544567] ? __kasan_slab_alloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
[  253.544569] ? kmem_cache_alloc_bulk (mm/slab.h:732 mm/slab.c:3546)
[  253.544573] ? __io_alloc_req_refill (fs/io_uring.c:2078)
[  253.544578] ? io_submit_sqes (fs/io_uring.c:7441)
[  253.544581] ? __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
[  253.544584] ? __x64_sys_io_uring_enter (fs/io_uring.c:10096)
[  253.544587] ? do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[  253.544590] ? entry_SYSCALL_64_after_hwframe (??:?)
[  253.544596] __io_queue_sqe (fs/io_uring.c:?)
[  253.544600] io_queue_sqe (fs/io_uring.c:7143)
[  253.544603] io_submit_sqe (fs/io_uring.c:?)
[  253.544608] io_submit_sqes (fs/io_uring.c:?)
[  253.544612] __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
[  253.544616] __x64_sys_io_uring_enter (fs/io_uring.c:10096)
[  253.544619] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[  253.544623] entry_SYSCALL_64_after_hwframe (??:?)

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793bf3332a0229ed74603d195b761756..b928928617a475af71fe2d42c63bc32099b42ada 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4567,6 +4567,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 		} else {
 			list_add_tail(&buf->list, &(*head)->list);
 		}
+		cond_resched();
 	}
 
 	return i ? i : -ENOMEM;
-- 
2.35.1.265.g69c8d7142f-goog

