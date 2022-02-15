Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E34B728F
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiBOOuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 09:50:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbiBOOtz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 09:49:55 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC55120E90
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 06:47:25 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y5so35238895pfe.4
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 06:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=emeH7mCGapfwR7x4iOpmF9tKGBCFcUttvDyikdsQAJc=;
        b=cqVTvmIJzPmriwJyUF21v+XFr2iyEE6WvjfBvXmXcobqorKqs56hBOPkORZz/zg9J1
         rzrwxcjOcpRVXzZSqpUpmmlI2BQ/nVV+fgdbIOYWBlpRZjPaGYnM9z2COeGNMEhK3DMd
         47KBTlLw6OkPbVv6SBNsf0SI+cDEf07+Rj5diLPoCsI6mHxQxzSYv/2t1WSrjGXszIoH
         /yrdqKMDrRB4pnWW4979IstWWMNkPDkQFF/6N6+qMhfZTu+F6fSVIwj06zxgSVzCwtW0
         m20npBq/X4u+fwE0lAnyICllXdtAXl93YggL/M23yZgGv0qYtMTweCs9DvhypZZ7SrNX
         fzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=emeH7mCGapfwR7x4iOpmF9tKGBCFcUttvDyikdsQAJc=;
        b=HNy2Z7sp4VX5NmCjZTOaBVUwR6kfd3GgeiKqh4eXCyYwGDmFjTe4QD34qPrw96s3mp
         THxxmKrd9sao7TJ6wxea2ZwEcYesKiXkB5foCYvnj2BXNSnt3hxndsy9QQ+OCK9B4PuE
         MkZf/AeWqZEz8KRF6q7bDI3nKlKVVY8APVf5qG0jgDkyWYl2RrhNjr2jpuP7KUJk5wUu
         KHfCtnPYPaX82s1z/tc94njLFUb9J6YXEuMVSWQ6eMW+oM/lZO7lwFFvvC6anClxcaso
         5cR8/JLzHpmqQYlVJavhbxgXtkJG5Qr3oiRi1YW92Jjbe4QcEwG0PA4J25shofPkL71f
         I2Jg==
X-Gm-Message-State: AOAM532moTkOaVbGZkJJsgVpvd+6eOgoilAfoRa3SwAlU/bSylmDokNz
        MtUyppe1q6Ah2BcnEo419xWt5R3iVz7oWw==
X-Google-Smtp-Source: ABdhPJy9gtbW7lahIXCZesWLTIrk1BnyzaoT7BWcJwYBHfqKytr5jVZ7VLv2EJ3CW3QmJH3XabexlA==
X-Received: by 2002:a63:4c41:: with SMTP id m1mr3810469pgl.52.1644936444650;
        Tue, 15 Feb 2022 06:47:24 -0800 (PST)
Received: from [192.168.1.116] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z11sm17408284pjq.53.2022.02.15.06.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 06:47:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <20220215041003.2394784-1-eric.dumazet@gmail.com>
References: <20220215041003.2394784-1-eric.dumazet@gmail.com>
Subject: Re: [PATCH] io_uring: add a schedule point in io_add_buffers()
Message-Id: <164493644178.127292.6802735611215849677.b4-ty@kernel.dk>
Date:   Tue, 15 Feb 2022 07:47:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 14 Feb 2022 20:10:03 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Looping ~65535 times doing kmalloc() calls can trigger soft lockups,
> especially with DEBUG features (like KASAN).
> 
> [  253.536212] watchdog: BUG: soft lockup - CPU#64 stuck for 26s! [b219417889:12575]
> [  253.544433] Modules linked in: vfat fat i2c_mux_pca954x i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
> [  253.544451] CPU: 64 PID: 12575 Comm: b219417889 Tainted: G S         O      5.17.0-smp-DEV #801
> [  253.544457] RIP: 0010:kernel_text_address (./include/asm-generic/sections.h:192 ./include/linux/kallsyms.h:29 kernel/extable.c:67 kernel/extable.c:98)
> [  253.544464] Code: 0f 93 c0 48 c7 c1 e0 63 d7 a4 48 39 cb 0f 92 c1 20 c1 0f b6 c1 5b 5d c3 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 53 48 89 fb <48> c7 c0 00 00 80 a0 41 be 01 00 00 00 48 39 c7 72 0c 48 c7 c0 40
> [  253.544468] RSP: 0018:ffff8882d8baf4c0 EFLAGS: 00000246
> [  253.544471] RAX: 1ffff1105b175e00 RBX: ffffffffa13ef09a RCX: 00000000a13ef001
> [  253.544474] RDX: ffffffffa13ef09a RSI: ffff8882d8baf558 RDI: ffffffffa13ef09a
> [  253.544476] RBP: ffff8882d8baf4d8 R08: ffff8882d8baf5e0 R09: 0000000000000004
> [  253.544479] R10: ffff8882d8baf5e8 R11: ffffffffa0d59a50 R12: ffff8882eab20380
> [  253.544481] R13: ffffffffa0d59a50 R14: dffffc0000000000 R15: 1ffff1105b175eb0
> [  253.544483] FS:  00000000016d3380(0000) GS:ffff88af48c00000(0000) knlGS:0000000000000000
> [  253.544486] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  253.544488] CR2: 00000000004af0f0 CR3: 00000002eabfa004 CR4: 00000000003706e0
> [  253.544491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  253.544492] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  253.544494] Call Trace:
> [  253.544496]  <TASK>
> [  253.544498] ? io_queue_sqe (fs/io_uring.c:7143)
> [  253.544505] __kernel_text_address (kernel/extable.c:78)
> [  253.544508] unwind_get_return_address (arch/x86/kernel/unwind_frame.c:19)
> [  253.544514] arch_stack_walk (arch/x86/kernel/stacktrace.c:27)
> [  253.544517] ? io_queue_sqe (fs/io_uring.c:7143)
> [  253.544521] stack_trace_save (kernel/stacktrace.c:123)
> [  253.544527] ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
> [  253.544531] ? ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
> [  253.544533] ? __kasan_kmalloc (mm/kasan/common.c:524)
> [  253.544535] ? kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
> [  253.544541] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
> [  253.544544] ? __io_queue_sqe (fs/io_uring.c:?)
> [  253.544551] __kasan_kmalloc (mm/kasan/common.c:524)
> [  253.544553] kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
> [  253.544556] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
> [  253.544560] io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
> [  253.544564] ? __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
> [  253.544567] ? __kasan_slab_alloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
> [  253.544569] ? kmem_cache_alloc_bulk (mm/slab.h:732 mm/slab.c:3546)
> [  253.544573] ? __io_alloc_req_refill (fs/io_uring.c:2078)
> [  253.544578] ? io_submit_sqes (fs/io_uring.c:7441)
> [  253.544581] ? __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
> [  253.544584] ? __x64_sys_io_uring_enter (fs/io_uring.c:10096)
> [  253.544587] ? do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [  253.544590] ? entry_SYSCALL_64_after_hwframe (??:?)
> [  253.544596] __io_queue_sqe (fs/io_uring.c:?)
> [  253.544600] io_queue_sqe (fs/io_uring.c:7143)
> [  253.544603] io_submit_sqe (fs/io_uring.c:?)
> [  253.544608] io_submit_sqes (fs/io_uring.c:?)
> [  253.544612] __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
> [  253.544616] __x64_sys_io_uring_enter (fs/io_uring.c:10096)
> [  253.544619] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [  253.544623] entry_SYSCALL_64_after_hwframe (??:?)
> 
> [...]

Applied, thanks!

[1/1] io_uring: add a schedule point in io_add_buffers()
      commit: f240762f88b4b1b58561939ffd44837759756477

Best regards,
-- 
Jens Axboe


