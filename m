Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39CD76722C
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjG1Qne (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbjG1Qmy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:54 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C68319A4
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:46 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-78706966220so22790439f.1
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562565; x=1691167365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgmPORLNso3KhGjKAf8ri1EDar6yb/Ua+Lm2vp9NjUk=;
        b=Ur0yn05vA4g6T1oMAgp5S9eOXhQtpLAoIUiHwtUeZg7WO3bUolj2hC6IlLND4XUMQk
         1f6OAMKnGzk4YG7fQyrPaVOicySAWV6S/Uppg1jacyTOFCo0Jg3Ci/zeD2fpcWM+Wacy
         fQXHgBS5CGBszY2iiZR+K4mhDOLA+caxiY8mRZ9YkvIEC+UdvmAejzvXVylbd5FW88sw
         YvtNlixuhvlm/8yVwYJfR6N9j4H0qPCMSeouDkwUC91RSldd+8w2qTixfwoIAyYhQ/OZ
         iHx0excWbAyl4KxIih6EFokslp1PTrvrkYZcLTIMotZrIGaDpyOyTFCWsp9BkQQHkb+u
         vkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562565; x=1691167365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgmPORLNso3KhGjKAf8ri1EDar6yb/Ua+Lm2vp9NjUk=;
        b=hLGWtHgUVD8UbfYSUXdR/4algzyNSgBDhgKoBTBrisxoFmd3Nb77iOdgsJF+52tGxK
         jfCbXzdEvua8+pOV0WS3Kjps0E/4+6fHG54H5IpfLEK9GShvMoHLUMyVgZdVJD/NT9NC
         ojtGWTd+svLjp6AwhWlC8FTDRrmMKcqX9HuNIxo8hw9041Ou1nwxRStLmNok28U1MEyS
         ui4JnY+eVkLhPfxKIMrFk05TStuHFAgPgcNwjBLdIkwGraI+gzP6pORhVetgla3sRGln
         LISqJPoNs/kdbofoAcgvPTW9ZQVop5v41kZuR7mKwK/sdPia6XkW2Tuj9fT6RTTebZ22
         g6XQ==
X-Gm-Message-State: ABy/qLYjscY/c4+5W/K3yST/mN4GUgO5SILkAv7x4ZQ8jlneSwNvdY+A
        9rTQrIdCa8Ns9FF8eHB2JdKV4JkV5QWYvAP5fE0=
X-Google-Smtp-Source: APBJJlECGCC1BnbNTLfhF7JxlO0uEAba+K6k5FLKU0FPSM8izihcvb6OwaDmFe2CUiDnhujBkA9Whg==
X-Received: by 2002:a6b:c9d3:0:b0:788:2d78:813c with SMTP id z202-20020a6bc9d3000000b007882d78813cmr110344iof.0.1690562565051;
        Fri, 28 Jul 2023 09:42:45 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] futex: abstract out a __futex_wake_mark() helper
Date:   Fri, 28 Jul 2023 10:42:30 -0600
Message-Id: <20230728164235.1318118-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index bfc1e3c260b0..e04c74a34832 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -217,6 +217,7 @@ extern int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
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

