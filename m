Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B013874FC59
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjGLArY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjGLArV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4028D173C
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:19 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5576ad1b7e7so1011208a12.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122838; x=1691714838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAI3I/Dhvc4kFPF9aMsZuUCg5MncxXQjosQul2Nohhs=;
        b=df7itfq6b68/usvHEi91e1MzZBznscTgw/J0lMxPEjugpJIES1PAZeC1++4h+nEL73
         hF+zuH761pjLrXKQpoIJkDL+LT+9G23AGGt33Admf11D+pplifWgUjWVTThi3WpgwHCO
         VxnxqurUC3FRQw+FWp8InVuWdBVU+xc49C5pfnXq4QjskLSfD2SG3w1CEPCSVao7WuFR
         kDsOdHs18B1OBSsIgbeEq870s4F9L0+4RC507KZsTFkPntUQnv5uM1x4bgmDW2yu4o4o
         M+JTd8NS3GwLh2iaS8FT/bN6jNFYa/baEeCgtdmpgaS+PJD47Os/ouyIY42q6CayXWI+
         OQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122838; x=1691714838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAI3I/Dhvc4kFPF9aMsZuUCg5MncxXQjosQul2Nohhs=;
        b=BytxoROb2OvOQ6/14r7J79/I244Os+Z2ffGg7p1u2yDiCwqrh6zVWh18XFzLTOAG6y
         hoYdETfpocw1CLmz6bBw3eeZooiKQw6oAWMEB0PKp77mBDeF/e3f74OfcWcS9s12S03L
         +rku9JvuMUXgZzQxx2ZsXQOPd3hVEvMS8rB4ZgMU28wO6svladlOZEJWTFAin6m948WP
         OYXJSczj1EVGSu9pfQfQd0ciLel9BUzbFsjID96369aiblMNs3+pWrbA8KDRCg8Z63k8
         bF+DCqlgFPdSxF4MiWRtKOGOx/1FBfUK2f8ewBVtjCeaJadMPABZielDLlWth2d2J+jb
         ye8A==
X-Gm-Message-State: ABy/qLZEs8qLU4Nxh898hqF7nGw5XVo7OZVCIAlp6m406PkSZuLttoPg
        Yp0str8JfqNlWUas4se/NQDTItm45oSNVZGROug=
X-Google-Smtp-Source: APBJJlF0OcXmextAbH9ZOz7q7HkUMlDfdRnt7GYOrghw54ttVQIxzCRuTPnMc4lyuqCnqyjb0gi/RQ==
X-Received: by 2002:a17:902:d4cd:b0:1b8:17e8:5472 with SMTP id o13-20020a170902d4cd00b001b817e85472mr21890265plg.1.1689122838441;
        Tue, 11 Jul 2023 17:47:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] futex: make futex_parse_waitv() available as a helper
Date:   Tue, 11 Jul 2023 18:47:03 -0600
Message-Id: <20230712004705.316157-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To make it more generically useful, augment it with allowing the caller
to pass in the wake handler and wake data. Convert the futex_waitv()
syscall, passing in the default handlers.

Since we now provide a way to pass in a wake handler and data, ensure we
use __futex_queue() to avoid having futex_queue() overwrite our wait
data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  5 +++++
 kernel/futex/syscalls.c | 14 ++++++++++----
 kernel/futex/waitwake.c |  3 ++-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 75dec2ec7469..ed5a7ccd2e99 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -284,6 +284,11 @@ struct futex_vector {
 	struct futex_q q;
 };
 
+extern int futex_parse_waitv(struct futex_vector *futexv,
+			     struct futex_waitv __user *uwaitv,
+			     unsigned int nr_futexes, futex_wake_fn *wake,
+			     void *wake_data);
+
 extern int futex_wait_multiple(struct futex_vector *vs, unsigned int count,
 			       struct hrtimer_sleeper *to);
 
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 75ca8c41cc94..8ac70bfb89fc 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -184,12 +184,15 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
  * @futexv:	Kernel side list of waiters to be filled
  * @uwaitv:     Userspace list to be parsed
  * @nr_futexes: Length of futexv
+ * @wake:	Wake to call when futex is woken
+ * @wake_data:	Data for the wake handler
  *
  * Return: Error code on failure, 0 on success
  */
-static int futex_parse_waitv(struct futex_vector *futexv,
-			     struct futex_waitv __user *uwaitv,
-			     unsigned int nr_futexes)
+int futex_parse_waitv(struct futex_vector *futexv,
+		      struct futex_waitv __user *uwaitv,
+		      unsigned int nr_futexes, futex_wake_fn *wake,
+		      void *wake_data)
 {
 	struct futex_waitv aux;
 	unsigned int i;
@@ -208,6 +211,8 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
 		futexv[i].q = futex_q_init;
+		futexv[i].q.wake = wake;
+		futexv[i].q.wake_data = wake_data;
 	}
 
 	return 0;
@@ -284,7 +289,8 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 		goto destroy_timer;
 	}
 
-	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
+	ret = futex_parse_waitv(futexv, waiters, nr_futexes, futex_wake_mark,
+				NULL);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3471af87cb7d..dfd02ca5ecfa 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -446,7 +446,8 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 			 * next futex. Queue each futex at this moment so hb can
 			 * be unlocked.
 			 */
-			futex_queue(q, hb);
+			__futex_queue(q, hb);
+			spin_unlock(&hb->lock);
 			continue;
 		}
 
-- 
2.40.1

