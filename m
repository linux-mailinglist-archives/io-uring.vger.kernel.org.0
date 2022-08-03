Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA28E589457
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 00:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiHCWYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 18:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiHCWYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 18:24:10 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718A850186;
        Wed,  3 Aug 2022 15:24:07 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c3so13869483qko.1;
        Wed, 03 Aug 2022 15:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bIH5s7GF6nzPQ/hRzBmgueYl4MrTkMyCP5UL1r27IIo=;
        b=Q8kdhewgKpenh0lGOkj+H9rDCKL2Gygmc0X5mYzDCPH2yACEOyROLDkE/uawpoW6G7
         b5tgZBp5ExBxH57L67YPhdD5r38lxLT3oF9tT4jYdVCtkFgvdIcZGTh/LhyoUmDf9Wpx
         Y3z2jzfs/wD9zyFZAil+M0+eNG+Su+vi0m24DBXI1cgARmN4v2nTTsf6bO0yoIrYncBW
         clJ9ktW43flAeq36VbqYuRHL8IBkj8XQANRujDTu0rTqO70dlKyHM8MYhQTqADj5zjPL
         cnW4go2+11abpmMiBOyC5yWkeZZEZeluuR4tg8MR24sJbqTpFlunoalgslAnuft13XZr
         PDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bIH5s7GF6nzPQ/hRzBmgueYl4MrTkMyCP5UL1r27IIo=;
        b=tl3zspfho5IQGzINgZo8DJG1+SSSoEs6z2NCnlwjQnrZHYrKfZnaE2BWpJ4AO4Z4qG
         R2hulJu0vbrXrOSclbSchOg2RzVnSKDojFTs1zUW1sG5l00KOqU1iwvmLZcWoc1zsIkl
         qm5Lyu4G9tDCLHigT6uU2qmeJcCTL1Wt0y8aMuw5ZdM/ooZwiANA6pvYBaFRQ8Rj5WUq
         OKCAbAMG2c/b3vWHliYImFppnABlhbAa6Y6jPOdTrH1g29zrBhyBzZuLktvlyrgwanQe
         d9Jyb+XvZgRhZB/T70SlDQX44Wkh+0LUYFa3aJOJR1f+iM9Nb6h8kSHb/3k2ZQ2ekUL2
         EKjg==
X-Gm-Message-State: AJIora9PZBQOcmjGApssBG/SMDFBLP8zL9wfI4lwwD/KLMCRJTvgDKkf
        ukvqireUih+6vuCy+EXuEw==
X-Google-Smtp-Source: AGRyM1su5PXPoWPyT7ZUOgJqvRZ1saahDdsrEsHaE9Lm/eUMBJ2QkorNFMgK+yfYCqrhvQDrjpiOCw==
X-Received: by 2002:a05:620a:1707:b0:6b5:f93a:ee54 with SMTP id az7-20020a05620a170700b006b5f93aee54mr19682643qkb.158.1659565446431;
        Wed, 03 Aug 2022 15:24:06 -0700 (PDT)
Received: from bytedance.bytedance.net ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id h3-20020ae9ec03000000b006af10bd3635sm12511008qkg.57.2022.08.03.15.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 15:24:05 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v2] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()
Date:   Wed,  3 Aug 2022 15:23:43 -0700
Message-Id: <20220803222343.31673-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803050230.30152-1-yepeilin.cs@gmail.com>
References: <20220803050230.30152-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently @audit_context is allocated twice for io_uring workers:

  1. copy_process() calls audit_alloc();
  2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
     is effectively audit_alloc()) and overwrites @audit_context,
     causing:

  BUG: memory leak
  unreferenced object 0xffff888144547400 (size 1024):
<...>
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
      [<ffffffff81239e63>] copy_process+0xcd3/0x2340
      [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
      [<ffffffff81686604>] create_io_worker+0xb4/0x230
      [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
      [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
      [<ffffffff816768b3>] io_queue_async+0x113/0x180
      [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
      [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
      [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
      [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
      [<ffffffff8125a688>] get_signal+0xc18/0xf10
      [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
      [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
      [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
      [<ffffffff844a7e80>] do_syscall_64+0x40/0x80

Then,

  3. io_sq_thread() or io_wqe_worker() frees @audit_context using
     audit_free();
  4. do_exit() eventually calls audit_free() again, which is okay
     because audit_free() does a NULL check.

As suggested by Paul Moore, fix it by deleting audit_alloc_kernel() and
redundant audit_free() calls.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Suggested-by: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Change since v1:
  - Delete audit_alloc_kernel() (Paul Moore)

 fs/io-wq.c            |  3 ---
 fs/io_uring.c         |  4 ----
 include/linux/audit.h |  5 -----
 kernel/auditsc.c      | 25 -------------------------
 4 files changed, 37 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 824623bcf1a5..4d8a77a2a150 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -634,8 +634,6 @@ static int io_wqe_worker(void *data)
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
 
-	audit_alloc_kernel(current);
-
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
@@ -670,7 +668,6 @@ static int io_wqe_worker(void *data)
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
 
-	audit_free(current);
 	io_worker_exit(worker);
 	return 0;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8e769be9ed0..e0da0d2f71f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9208,8 +9208,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	audit_alloc_kernel(current);
-
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
@@ -9283,8 +9281,6 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
-	audit_free(current);
-
 	complete(&sqd->exited);
 	do_exit(0);
 }
diff --git a/include/linux/audit.h b/include/linux/audit.h
index cece70231138..c313df466e6e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -287,7 +287,6 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
 /* These are defined in auditsc.c */
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
-extern int  audit_alloc_kernel(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
 extern void __audit_uring_entry(u8 op);
 extern void __audit_uring_exit(int success, long code);
@@ -580,10 +579,6 @@ static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
 }
-static inline int audit_alloc_kernel(struct task_struct *task)
-{
-	return 0;
-}
 static inline void audit_free(struct task_struct *task)
 { }
 static inline void audit_uring_entry(u8 op)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3a8c9d744800..dd8d9ab747c3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1073,31 +1073,6 @@ int audit_alloc(struct task_struct *tsk)
 	return 0;
 }
 
-/**
- * audit_alloc_kernel - allocate an audit_context for a kernel task
- * @tsk: the kernel task
- *
- * Similar to the audit_alloc() function, but intended for kernel private
- * threads.  Returns zero on success, negative values on failure.
- */
-int audit_alloc_kernel(struct task_struct *tsk)
-{
-	/*
-	 * At the moment we are just going to call into audit_alloc() to
-	 * simplify the code, but there two things to keep in mind with this
-	 * approach:
-	 *
-	 * 1. Filtering internal kernel tasks is a bit laughable in almost all
-	 * cases, but there is at least one case where there is a benefit:
-	 * the '-a task,never' case allows the admin to effectively disable
-	 * task auditing at runtime.
-	 *
-	 * 2. The {set,clear}_task_syscall_work() ops likely have zero effect
-	 * on these internal kernel tasks, but they probably don't hurt either.
-	 */
-	return audit_alloc(tsk);
-}
-
 static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */
-- 
2.20.1

