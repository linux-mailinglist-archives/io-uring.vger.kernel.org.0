Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609654E5117
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbiCWLRi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 07:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbiCWLRi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 07:17:38 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA7C7891E
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 04:16:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r64so708798wmr.4
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zkUPbewTemhzOCwHb3lkPnAhb3jPaZR8hBrdZO1jAxw=;
        b=dm9eLiOkgk7EVxeyVWx5bpZPprcoi4ioqHj/N7TNGAeV/BHhA1rLtGCi47rxPhXZhz
         a/j3Po/xlU0UMWWpdetwQpxPJzMyM+yZ571vmyXWnE1jIyOl7IMB1FlwGRW1zbfNZ4N6
         GhVhg4YRwVmna7GnZ6DyCdrYvlyreiArm2be5Z8ytn1qppekLFGEloQO1QeoNLpDW+Un
         TOJJbT1aSrGcJ/Se4TNRbbyhis1qeoHDVb1c5ZQekZpzeR60adjpfI4lYAcI+/Gynmuz
         yt+7w0Q9nQ+ycbkSMqbd7F9dtB53FLHDBv28lstLzcaBrxnux+danG8wvNZqgRJMIT95
         ZV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zkUPbewTemhzOCwHb3lkPnAhb3jPaZR8hBrdZO1jAxw=;
        b=Ak8310zG8rcBsa+dZ7gDAsNRC0hojEeIXLEhKpPVrD5Fo8f/ZBvq/Bh1FpklMyWQk2
         iiBvjygUBzd9pPsSDGEAxPz2mwRy/Fc+HKRDjzbsAmyJecnERBUEQuWYHYG670cK0Que
         5hyi2NrePq/EFlC0Dzdph2hhhSVLeT9HEach1AGaVsdzD32JF1W6FciuejYLjf23ZZRt
         EYwOs57XkhtXn5kiT8cggq+W5Ui/MYworWb5sO97b4AUCFb/uIBIShypzJp3V47sglor
         xUqP5btYHfLdX4+pe30knrwv9bxCy/g49Pi4AZbqS1fmY7EG2/QUl15Cr2YYOdaMrf/d
         Wn4A==
X-Gm-Message-State: AOAM5301XJSj2qzhDrxLizmCXdmLTSiuxCoqZCdVQTwsRbRD80mn7RYV
        QOK4NF/D7pIDhSDAq/kkQ4hSdtkohBlclQ==
X-Google-Smtp-Source: ABdhPJz5iHNnQ4yvoWoDAi47p0/fnOXT+S0CwswEqQD05oHYOAf2pNsFM/XsM0GRczkvd/5vKrKPqg==
X-Received: by 2002:a05:600c:3c8b:b0:37f:1546:40c9 with SMTP id bg11-20020a05600c3c8b00b0037f154640c9mr8516721wmb.161.1648034167245;
        Wed, 23 Mar 2022 04:16:07 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-253.dab.02.net. [82.132.233.253])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d6da7000000b00203d9d1875bsm20107007wrs.73.2022.03.23.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 04:16:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: null deref in early failed ring destruction
Date:   Wed, 23 Mar 2022 11:14:54 +0000
Message-Id: <669d91dd881a4f7c86104b9414fa3d12477b2669.1648032632.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

[  830.443583] Running test nop-all-sizes:
[  830.551826] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[  830.551900] RIP: 0010:io_kill_timeouts+0xc5/0xf0
[  830.551951] Call Trace:
[  830.551958]  <TASK>
[  830.551970]  io_ring_ctx_wait_and_kill+0xb0/0x117
[  830.551975]  io_uring_setup.cold+0x4dc/0xb97
[  830.551990]  __x64_sys_io_uring_setup+0x15/0x20
[  830.552003]  do_syscall_64+0x3b/0x80
[  830.552011]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Apparently, not all io_commi_cqring() guarding was useless, some were
protecting against cases where we call io_ring_ctx_wait_and_kill() for a
ring failed early during creation. This particular one points to

(gdb) l *(io_kill_timeouts+0xc5)
0xffffffff81b26b19 is in io_kill_timeouts (fs/io_uring.c:1813).
1808    }
1809
1810    static inline void io_commit_cqring(struct io_ring_ctx *ctx)
1811    {
1812            /* order cqe stores with ring update */
1813            smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
1814    }

A better way to handle the problem is to not get into the request
cancellation paths for when we don't have ctx->rings allocated.

Fixes: c9be622494c01 ("io_uring: remove extra ifs around io_commit_cqring")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 594ed8bc4585..6ad81d39d81e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10309,11 +10309,13 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL, true);
-	io_poll_remove_all(ctx, NULL, true);
-
-	/* if we failed setting up the ctx, we might not have any rings */
-	io_iopoll_try_reap_events(ctx);
+	/* failed during ring init, it couldn't have issued any requests */
+	if (ctx->rings) {
+		io_kill_timeouts(ctx, NULL, true);
+		io_poll_remove_all(ctx, NULL, true);
+		/* if we failed setting up the ctx, we might not have any rings */
+		io_iopoll_try_reap_events(ctx);
+	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
@@ -10405,6 +10407,10 @@ static __cold void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
 	struct io_uring_task *tctx = task ? task->io_uring : NULL;
 
+	/* failed during ring init, it couldn't have issued any requests */
+	if (!ctx->rings)
+		return;
+
 	while (1) {
 		enum io_wq_cancel cret;
 		bool ret = false;
-- 
2.35.1

