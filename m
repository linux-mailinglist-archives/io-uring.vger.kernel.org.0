Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23A075BA6B
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjGTWTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjGTWTO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:14 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86508110
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:13 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-785ccd731a7so17736639f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891552; x=1690496352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LX64aRTXZn1J2+kMH6li2nZLGVOvJMDcauw8tqpt/jw=;
        b=NTDIBKuaQrU+oK6NuHlx5B81IFDJTKS6nFNJR8IjnDWuQ3CbrlsC37Y6uNykBch951
         y1cDhu4g3Vm2zDmH7LT6Yah04Cwmm6E2kIo17kCmYQbPD5TRzI97KDs7voVTmSRh05LO
         8gsjss/ICP3PEbbXnwbSxmi8W/ocu+WKm86dXJiAYuRtoqTXZoKFjXyL0Hshgo/1biL0
         T+iW3lltXneCyqwUYeGEKgvExOsAlS8cH3LZZ3hVIg0XXWmevD2sPCeK2RxFJ/K5qkCP
         AZ2o+gTFfDFuBUnqI4SGYJc+HtbaktxCa1lDXW8JRp0yfO0Y51ti9hPn0nw8I7VS/wFG
         Befg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891552; x=1690496352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LX64aRTXZn1J2+kMH6li2nZLGVOvJMDcauw8tqpt/jw=;
        b=ERpS0/VXXSuvdIaCNIjknD8s188Ppo/OHZtJtKD7HrNRcwVzML+UKliXRDq/YUJh6R
         3Pn6GjM8LNR8lmOaaneFhv4GZ418eO8FSGcv+M1v3Hp+FcMYgZNBPHEegmdkHFYghYdM
         3s3grnLmI3udxEiLnIcA2MLl5pB4Xb7tv6kIo+vdhR0huGb2gyX1knW6g576WWs2Mokt
         s90NsCN3yvS6fIPfBtJxrK05bvOv6o+Z1xzuS9+3+92ng7CGsZ1NFif2jnM9KyVwp8bd
         rjNibbideLnn/xB//zI5A15epH0WJrnHXAHVDwz0RpFtHRW7rudbRxopOlgbxSFhnkCx
         uJ8A==
X-Gm-Message-State: ABy/qLbnGNzfTW6eEOXJu3+05np6WpvfDcG1tYgmktfAT9mwDlAa7qBa
        2F31S6VKcdLCvOdZIygCaDDDnCOUVOyax3P1Yn4=
X-Google-Smtp-Source: APBJJlGdh4Bq+l7mgjDWnewJLZLry41UbONLt+MZXKwA45zuA39xOQx8MtZhX6YAzouH+wfUFT71Pg==
X-Received: by 2002:a92:c9c3:0:b0:33b:d741:5888 with SMTP id k3-20020a92c9c3000000b0033bd7415888mr347950ilq.0.1689891552434;
        Thu, 20 Jul 2023 15:19:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] futex: factor out the futex wake handling
Date:   Thu, 20 Jul 2023 16:18:52 -0600
Message-Id: <20230720221858.135240-5-axboe@kernel.dk>
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

In preparation for having another waker that isn't futex_wake_mark(),
add a wake handler in futex_q. No extra data is associated with the
handler outside of struct futex_q itself. futex_wake_mark() is defined as
the standard wakeup helper, now set through futex_q_init like other
defaults.

Normal sync futex waiting relies on wake_q holding tasks that should
be woken up. This is what futex_wake_mark() does, it'll unqueue the
futex and add the associated task to the wake queue. For async usage of
futex waiting, rather than having tasks sleeping on the futex, we'll
need to deal with a futex wake differently. For the planned io_uring
case, that means posting a completion event for the task in question.
Having a definable wake handler can help support that use case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 4 ++++
 kernel/futex/requeue.c  | 3 ++-
 kernel/futex/waitwake.c | 6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 54f4470b7db8..2b18eb889cce 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -111,6 +111,9 @@ struct futex_pi_state {
 	union futex_key key;
 } __randomize_layout;
 
+struct futex_q;
+typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
+
 /**
  * struct futex_q - The hashed futex queue entry, one per waiting task
  * @list:		priority-sorted list of tasks waiting on this futex
@@ -140,6 +143,7 @@ struct futex_q {
 
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
+	futex_wake_fn *wake;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
diff --git a/kernel/futex/requeue.c b/kernel/futex/requeue.c
index cba8b1a6a4cc..e892bc6c41d8 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -58,6 +58,7 @@ enum {
 
 const struct futex_q futex_q_init = {
 	/* list gets initialized in futex_queue()*/
+	.wake		= futex_wake_mark,
 	.key		= FUTEX_KEY_INIT,
 	.bitset		= FUTEX_BITSET_MATCH_ANY,
 	.requeue_state	= ATOMIC_INIT(Q_REQUEUE_PI_NONE),
@@ -591,7 +592,7 @@ int futex_requeue(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 		/* Plain futexes just wake or requeue and are done */
 		if (!requeue_pi) {
 			if (++task_count <= nr_wake)
-				futex_wake_mark(&wake_q, this);
+				this->wake(&wake_q, this);
 			else
 				requeue_futex(this, hb1, hb2, &key2);
 			continue;
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index fa9757766103..0272b8c3b132 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -174,7 +174,7 @@ int futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 			if (!(this->bitset & bitset))
 				continue;
 
-			futex_wake_mark(&wake_q, this);
+			this->wake(&wake_q, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -289,7 +289,7 @@ int futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 				ret = -EINVAL;
 				goto out_unlock;
 			}
-			futex_wake_mark(&wake_q, this);
+			this->wake(&wake_q, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -303,7 +303,7 @@ int futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 					ret = -EINVAL;
 					goto out_unlock;
 				}
-				futex_wake_mark(&wake_q, this);
+				this->wake(&wake_q, this);
 				if (++op_ret >= nr_wake2)
 					break;
 			}
-- 
2.40.1

