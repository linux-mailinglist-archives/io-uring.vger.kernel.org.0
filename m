Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51627A9A3F
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjIUShp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjIUSh0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:37:26 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F71D8689
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:24 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-79f8df47bfbso10253739f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320963; x=1695925763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMx5R6E0R0h9+pd+QZi7bIoYwQS8EWnvSyRr5gNA3m0=;
        b=h5zvPxbWi+KBRxy2l33P4Ql1YrEkI5Vx8JkaX3wnEgJgrTip2d0QcU61NZKFXB/ZT4
         +bilLkvNep0yTxPjbCHKLlY5A6YkiwfKVWsjTCN7ksJCuRSiqvnfLqwvppLCoYEGJumu
         vuCHLIx2ifF+PsvY37r0fd4azPnN+TqB0WDk7j8Ihho6HeE5uWIJWsTkjqFQWxL2gWij
         7Uts5c0xhdZOb0cKv63m1Xo+Sbkz1cEZaftBB+TDUcnxnj9XXp/JM4wEU87WAGG1HeNv
         MU/aMdT3NIEBJh+ofW+2cCCCpQUh/fgqQoD0xZQdHisLwUt1HeO9K4ncQph9yhGJNFP7
         6ZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320963; x=1695925763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMx5R6E0R0h9+pd+QZi7bIoYwQS8EWnvSyRr5gNA3m0=;
        b=pl0WT/i97sGm6exCPKcJT5Q1/+QQcri1oUPCiWDAtYO8ue5jGRqxFRZi9Z39yycD31
         h/s3KU86kPfdV8CElUvB/FZ0PYz+AgD/nhgW2KeMApHCnFwCYB9IITZVl1BjPE+IYM+0
         dRIF4yGn/EK+vp2FG2evNqNXYuOaA7h/DTfuYSL+64DVaWB1s8pYZJOtbiT5e0kw/B/j
         SGkh/gsvejycCqaa5PzlvpfUZZ+k8NL7oIa2ddgS9QetXyEC4WvWL16r9LxKOI6MsIIb
         BjaHbro3crXSmotjdeHguxbZF5N4jFn/lX1VtsT78BEoppZw5L7zIBe8zuCmFkpU2unG
         ZtCA==
X-Gm-Message-State: AOJu0YwwK8ZOBOs5Cft+cEBpZF3uTeqgNFyE00nIS5pq4CVcvl8q0eJI
        ipc32+e3pj1WY58uhj8TcgTCIb/+9YZaDGr32SlmSg==
X-Google-Smtp-Source: AGHT+IGg+1Bf4dt5Q006eZUcpXl2xhZHKdXAg7pZKFh2g2e8No0nMLmMw3nV+J6FY9ahF6SJxJmTuQ==
X-Received: by 2002:a05:6602:3788:b0:792:7c78:55be with SMTP id be8-20020a056602378800b007927c7855bemr6834507iob.0.1695320963064;
        Thu, 21 Sep 2023 11:29:23 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] futex: make the vectored futex operations available
Date:   Thu, 21 Sep 2023 12:29:07 -0600
Message-Id: <20230921182908.160080-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921182908.160080-1-axboe@kernel.dk>
References: <20230921182908.160080-1-axboe@kernel.dk>
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

Rename unqueue_multiple() as futex_unqueue_multiple(), and make both
that and futex_wait_multiple_setup() available for external users. This
is in preparation for wiring up vectored waits in io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/waitwake.c | 10 +++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 6b6a6b3da103..8b195d06f4e8 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -366,6 +366,11 @@ extern int futex_parse_waitv(struct futex_vector *futexv,
 			     unsigned int nr_futexes, futex_wake_fn *wake,
 			     void *wake_data);
 
+extern int futex_wait_multiple_setup(struct futex_vector *vs, int count,
+				     int *woken);
+
+extern int futex_unqueue_multiple(struct futex_vector *v, int count);
+
 extern int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 			       struct hrtimer_sleeper *to);
 
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 6fcf5f723719..61b112897a84 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -372,7 +372,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 }
 
 /**
- * unqueue_multiple - Remove various futexes from their hash bucket
+ * futex_unqueue_multiple - Remove various futexes from their hash bucket
  * @v:	   The list of futexes to unqueue
  * @count: Number of futexes in the list
  *
@@ -382,7 +382,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
  *  - >=0 - Index of the last futex that was awoken;
  *  - -1  - No futex was awoken
  */
-static int unqueue_multiple(struct futex_vector *v, int count)
+int futex_unqueue_multiple(struct futex_vector *v, int count)
 {
 	int ret = -1, i;
 
@@ -410,7 +410,7 @@ static int unqueue_multiple(struct futex_vector *v, int count)
  *  -  0 - Success
  *  - <0 - -EFAULT, -EWOULDBLOCK or -EINVAL
  */
-static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
+int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 {
 	struct futex_hash_bucket *hb;
 	bool retry = false;
@@ -472,7 +472,7 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 		 * was woken, we don't return error and return this index to
 		 * userspace
 		 */
-		*woken = unqueue_multiple(vs, i);
+		*woken = futex_unqueue_multiple(vs, i);
 		if (*woken >= 0)
 			return 1;
 
@@ -557,7 +557,7 @@ int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 
 		__set_current_state(TASK_RUNNING);
 
-		ret = unqueue_multiple(vs, count);
+		ret = futex_unqueue_multiple(vs, count);
 		if (ret >= 0)
 			return ret;
 
-- 
2.40.1

