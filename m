Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162CE7A9A43
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjIUSho (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjIUShR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:37:17 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9EED7DBA
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:18 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-79f96830e4dso3975739f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320957; x=1695925757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeITMYfcld3mteb+NSEcBXXoBeyRBDS9X8Wlurs1dfY=;
        b=elkX0bbQnyNGl1I50jhGbi+pWcQeuY5xLC5VLpCo+FVlOp7UwN6P0Qjig8a5k6gTkQ
         IL7gyU0LgEPpo9Y/PpIaiUVN0MVHLzLecVmUCsHkN14IwxkjxIkhNo9w2VQxBKO2Gpyr
         T3n2Z7dN+Z75R5u4IwI8PyaftN/9UYXl9GqRtbYkA4PM7NrFR1UmBTFreO0O11jsr1a4
         DbXsv1worfom++ih99/XxocYLChcdRN0DHTxZPIdcbChypfX1OaaNmOSAeXQr2AkEGZZ
         H8ULrGx+Y3Ie51DabPn9XxVnN6c6uFlFfjOXjZgyG9q3PPDHxGudBcFECoeA6MCZe4Eq
         jFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320957; x=1695925757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeITMYfcld3mteb+NSEcBXXoBeyRBDS9X8Wlurs1dfY=;
        b=ag37ZVE7GxFR1PqwOZ5zrzE5YLJrQzE0WMp08Zlcy1QsW98y1K6bfFy7NAhK2yVD8b
         xTPAs2rRQDaaWLUAdMsUkoSikISWtWHQPG/owWdW7oMzIjz9cfk8+4OJCzHXJY7EJahy
         kUXxNNn3gI1j0VLuQqC6KK6zVVMT8Qg5CUnb1F8QSXEDNbEWaYDLje75Os+mahnaDYy8
         KWpSD7fPt0d+rgW+UqOEwZ7UeN+Xl/oKQKNnG6HF4jm98Gq3ulJIPcfOyvIXmrReYprp
         pFb/zBO8Nux3KK4/It37vSU7AQFz7gGL3bpJw85QhK4Dt+A1CvrgCwhGnweQ3UAcfEOd
         MwuQ==
X-Gm-Message-State: AOJu0YxPtnAcsW40OdP5NvpenFhFD9L+XERvgf3BiZf3+VWvYTmjoxnN
        nsSMtbUjEEWN2BQdJvEzy2fiQeUIXfLpptuSJ8uWZg==
X-Google-Smtp-Source: AGHT+IEMeR7eiw0nzdlaXpVdshFLf4QAnYLaYjf6wZVS+llAK8oxoAXqFB8JQnoxkaPkNldByScrSw==
X-Received: by 2002:a92:d903:0:b0:350:f353:4017 with SMTP id s3-20020a92d903000000b00350f3534017mr6601502iln.0.1695320957710;
        Thu, 21 Sep 2023 11:29:17 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] futex: abstract out a __futex_wake_mark() helper
Date:   Thu, 21 Sep 2023 12:29:03 -0600
Message-Id: <20230921182908.160080-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921182908.160080-1-axboe@kernel.dk>
References: <20230921182908.160080-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 547f509b2c87..33835b81e0c3 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -219,6 +219,7 @@ extern int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 			    struct futex_q *q, struct futex_hash_bucket **hb);
 extern void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 				   struct hrtimer_sleeper *timeout);
+extern bool __futex_wake_mark(struct futex_q *q);
 extern void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q);
 
 extern int fault_in_user_writeable(u32 __user *uaddr);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 35c6a637a4bb..6fcf5f723719 100644
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

