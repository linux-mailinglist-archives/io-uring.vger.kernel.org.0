Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0A7B23D5
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjI1RZf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjI1RZc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DEBCD5
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9ae65c0e46fso342068966b.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921927; x=1696526727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeITMYfcld3mteb+NSEcBXXoBeyRBDS9X8Wlurs1dfY=;
        b=lXvTQyEa5u24mMaMoOxgC5v9uj1pFbc/ALXz0mBlCmD1vl709tS7CSZqztxkkEOjR3
         tpaPy0SlcULi7K+OUMEYz8rRxlu8By+7nGeh6U7wpPFtm1YroLWkOllJHr9Op4Nj02s9
         Uy2MInb/UQGdE5m5cr8HnJCO5tS9OYe3J4FYpaFSvgujWoIfJc6HiWfbP0yxVvi72zFu
         I3y8AnwA9ifUtYLDFVzlFTe6776N0/DyKSwC9NMwTKDJuy9TpqMqnDn+nAL9uiv4hne5
         OYBidcg3yu2ywgO+iCIo14jrvs3OIARlLBF2VwJ9h2rHQpF5+amCjnBoHGDtw3GjrGCM
         15VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921927; x=1696526727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeITMYfcld3mteb+NSEcBXXoBeyRBDS9X8Wlurs1dfY=;
        b=vhH2TbiN48cKoNZ71PH8ifNoH+DpxKWab0bd4TDgvsXVsJ4FnSzK2V7xiR+Y+Lq++D
         SCIRnRh0Cxn+MMBaWEiOKgwHxGi/z8QKsiYsHt+VjT54DI7hHi9kX86MFx/OHayUtt7a
         SNI4x/Dn0iv4almGynrAz1+hFIWhLNOwjMR58TxUtn295G+Pvp+4ZOPWQ/9ZnZ7xhl7w
         J3dKrQOIgonyiEopFOU42Xl3fre/Q8+t5NvQFM7WkGefruUkvATQY86f/8cE6Y2m4WX3
         yhJ24anZchH9n4PcNMxms8IA2A86LZa3jkAQ+pXQ/LgqX5s04hrIs6hot5CWr+1XMKI5
         lGLA==
X-Gm-Message-State: AOJu0YwYqisrF5IFRqFsi4fD5WuJYHwwdi9Vv4/RSjPKsM2Ui9TDMUp5
        z9J8f+EyoJ+6nsXULDEj5RNadh38wM8cPhzp/chYatHv
X-Google-Smtp-Source: AGHT+IHJ2uM1YZlSZZijhxVhmTA+uIkKbBWR7+AMbCLOEfLXFUo8yZlvHfK1N05feFpjuEOISMg6zA==
X-Received: by 2002:a17:906:104e:b0:9b2:bf2d:6b66 with SMTP id j14-20020a170906104e00b009b2bf2d6b66mr1576384ejj.7.1695921927081;
        Thu, 28 Sep 2023 10:25:27 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] futex: abstract out a __futex_wake_mark() helper
Date:   Thu, 28 Sep 2023 11:25:12 -0600
Message-Id: <20230928172517.961093-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
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

