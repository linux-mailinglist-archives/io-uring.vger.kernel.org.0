Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563DC75BA6C
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjGTWTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjGTWTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:15 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F8310D2
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6748a616e17so275285b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891554; x=1690496354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrNmrUoR5Wi6oW3AUbferDPa1uD6ufTJlswF9U4gsFE=;
        b=ddu84UJQmmPrzwNUcMBCwOXE8nxk76dm9ZNv+KenQmgPS/A2gMlOgyY+Farr4xlL3a
         vH3qrJVNJ3buiSZ7e1gKr1P+PyneefhudGCAaYdWP9zyTpSkYr1fGkLUFPYlWFASKpqA
         D9SvYXELPN5C23V1tretsjXsm4Oc7hkO03jhQoLTn7VVF3cFHja9E/ghYnglMCmWTws/
         qEjcfVm+Wt7YCOaJeij65kYRQTT0vyZ9Hrjwc6bt9lw3EZGEKkQ8sF4zW28+wHp13JDI
         FnYz5D2zzNftTyeqt94Bz/WVgXmiRf5KTqHNw7yMp4fnSBUl/5+9Gp484Bx/FLlE5LBE
         igsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891554; x=1690496354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrNmrUoR5Wi6oW3AUbferDPa1uD6ufTJlswF9U4gsFE=;
        b=KqvvRffaKb8zKypxsoFIqDGUVxlf+Dicn8TspahBE3kmlS14pXurZT1lY0QvhyxOho
         Larp1brNmN68sCcrv530lyaaUSrkejkYfW3SS+l/MroO/HHuiJQAAxwy+XS+Ofl/7Q4L
         NzX+z73RjwZMnGopWBFQ9jg2p9K6HtEqBElqi4rHybzeAZORiq725aMLT2kuNUmHGgQX
         OJ6BX1Got1842raO20K0XtWIjJsB6qFWv9njB0Y0rI9GsHupmA62LSzu+/s7Jdf5aagM
         jn7EscVgJeV4R/MDi+Ag/DD6i4QP1ag73dQJW5S2k/VlfS0SV9bSSDC0MM9Rw6jSq7R4
         n/xQ==
X-Gm-Message-State: ABy/qLZ9zYlVIDCbEboyxeyH0XXjOB8JCb/4ii+lT1AujOAryJLGT7Nk
        2BV5r9ulb8SIqvPG1TFaQ2iAZ79d14hSzY/ZI5Y=
X-Google-Smtp-Source: APBJJlHYTB4DmiBIVBJNyqqY2MhI1jA/DzDhyOjug8qQ3b7qOuDyfxIftzu5V4LUeEr7Tg44/woCgA==
X-Received: by 2002:a05:6a00:4186:b0:679:a1f1:a5f8 with SMTP id ca6-20020a056a00418600b00679a1f1a5f8mr121447pfb.3.1689891553713;
        Thu, 20 Jul 2023 15:19:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] futex: abstract out a __futex_wake_mark() helper
Date:   Thu, 20 Jul 2023 16:18:53 -0600
Message-Id: <20230720221858.135240-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the unqueue and lock_ptr clear into a helper that futex_wake_mark()
calls. Add it to the public functions as well, in preparation for using
it outside the core futex code.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  1 +
 kernel/futex/waitwake.c | 33 ++++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 2b18eb889cce..98d43e9efe65 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -190,6 +190,7 @@ extern int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 			    struct futex_q *q, struct futex_hash_bucket **hb);
 extern void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 				   struct hrtimer_sleeper *timeout);
+extern bool __futex_wake_mark(struct futex_q *q);
 extern void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q);
 
 extern int fault_in_user_writeable(u32 __user *uaddr);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 0272b8c3b132..86f67f652b95 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -106,20 +106,11 @@
  * double_lock_hb() and double_unlock_hb(), respectively.
  */
 
-/*
- * The hash bucket lock must be held when this is called.
- * Afterwards, the futex_q must not be accessed. Callers
- * must ensure to later call wake_up_q() for the actual
- * wakeups to occur.
- */
-void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
+bool __futex_wake_mark(struct futex_q *q)
 {
-	struct task_struct *p = q->task;
-
 	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
-		return;
+		return false;
 
-	get_task_struct(p);
 	__futex_unqueue(q);
 	/*
 	 * The waiting task can free the futex_q as soon as q->lock_ptr = NULL
@@ -130,6 +121,26 @@ void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
 	 */
 	smp_store_release(&q->lock_ptr, NULL);
 
+	return true;
+}
+
+/*
+ * The hash bucket lock must be held when this is called.
+ * Afterwards, the futex_q must not be accessed. Callers
+ * must ensure to later call wake_up_q() for the actual
+ * wakeups to occur.
+ */
+void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
+{
+	struct task_struct *p = q->task;
+
+	get_task_struct(p);
+
+	if (!__futex_wake_mark(q)) {
+		put_task_struct(p);
+		return;
+	}
+
 	/*
 	 * Queue the task for later wakeup for after we've released
 	 * the hb->lock.
-- 
2.40.1

