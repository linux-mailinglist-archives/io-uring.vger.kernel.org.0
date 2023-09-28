Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7F7B23D3
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjI1RZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjI1RZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAC9193
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9a1bcc540c0so349161366b.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921925; x=1696526725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5m39pK9Sy+s98BPtXb5MPOzqgjCaZT2iuuWI0t83mc=;
        b=UmGn9vNMxK9jugw5FvQnqmL2r2OvneHLTQSMVl4f3jMHvuA2Ew1YUyytyPRZ7T/9us
         H70B+rUVCpoJxfiwxL1JYnvlxcyHLIfduBMdirJ527MxqTdLkQMb0HgOxnlNH4pYSqP6
         V/9k2GSH4fYxywb7P2YEx0bkE3BLAzDRs7dr+EY3K95rvzr3y36PP/tpIEbDyfd3dwIl
         XmEK5M9+xS9ETvc+7YC0pfR+b5SkgicoOsHlNGyX6gxwcyptzCmYrkXIGoK3/OfKqvXa
         ZB4ZDgozqrOZxc3r30N/OaaX6Pum0VDRIM8SIUxz5qnps23HqLTYvEsdT1jpg9EypSDe
         1YEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921925; x=1696526725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5m39pK9Sy+s98BPtXb5MPOzqgjCaZT2iuuWI0t83mc=;
        b=A5JvXVH6TnghyL/WnN/6U3SCZKuIueYvJnqIX9HO94SsE10SIYBIYxvpatIinOrl6j
         tKE+uKz2KQPMC8bQEwinHXrkqmdR/e6QL7D/mkBK53nfa/XUJMGjP7RnX+e5qw5q+s9x
         QxVcOVeIozrZ7rqZBzU3ajL+//wbTVjvC5P1HVx+cHqNotN32LvE9wcNAX8B1WZ9ts8v
         3X9GTf7VvCd2vZD3cparTowocp6pwhWmIcP3bxZ6EfwkF+IPpaxxYEfSG2LNYDo0wis8
         K2Knatv5XFY1cYFBR2O/XooKEf+Hq85LhPP2iiL1+4QccV4v5e5086bCDlvC1Yw1zA4i
         sNiw==
X-Gm-Message-State: AOJu0YxwM7b3Om6lJKLAwka2N58iNHh209gDqmutuJV+gBMo0ZNT0h1d
        8rJ0XNbYw6/HQx412q+pvzsRX5CDz/OmIveH4g8S5E0j
X-Google-Smtp-Source: AGHT+IGt+eNuwg2/AQcW7COtq95twqR233dKHl8Ir5zXd8GhVMetP/XHQdKO6YrKNkPd+D/OTtsq8A==
X-Received: by 2002:a17:906:9f05:b0:9b2:b532:d8d7 with SMTP id fy5-20020a1709069f0500b009b2b532d8d7mr1832832ejc.5.1695921925707;
        Thu, 28 Sep 2023 10:25:25 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] futex: factor out the futex wake handling
Date:   Thu, 28 Sep 2023 11:25:11 -0600
Message-Id: <20230928172517.961093-3-axboe@kernel.dk>
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
 kernel/futex/futex.h    | 5 +++++
 kernel/futex/requeue.c  | 3 ++-
 kernel/futex/waitwake.c | 6 +++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index a173a9d501e1..547f509b2c87 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -139,11 +139,15 @@ struct futex_pi_state {
 	union futex_key key;
 } __randomize_layout;
 
+struct futex_q;
+typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
+
 /**
  * struct futex_q - The hashed futex queue entry, one per waiting task
  * @list:		priority-sorted list of tasks waiting on this futex
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
+ * @wake:		the wake handler for this queue
  * @key:		the key the futex is hashed on
  * @pi_state:		optional priority inheritance state
  * @rt_waiter:		rt_waiter storage for use with requeue_pi
@@ -168,6 +172,7 @@ struct futex_q {
 
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
+	futex_wake_fn *wake;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
diff --git a/kernel/futex/requeue.c b/kernel/futex/requeue.c
index a0a79954f506..9dc789399a1a 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -58,6 +58,7 @@ enum {
 
 const struct futex_q futex_q_init = {
 	/* list gets initialized in futex_queue()*/
+	.wake		= futex_wake_mark,
 	.key		= FUTEX_KEY_INIT,
 	.bitset		= FUTEX_BITSET_MATCH_ANY,
 	.requeue_state	= ATOMIC_INIT(Q_REQUEUE_PI_NONE),
@@ -593,7 +594,7 @@ int futex_requeue(u32 __user *uaddr1, unsigned int flags1,
 		/* Plain futexes just wake or requeue and are done */
 		if (!requeue_pi) {
 			if (++task_count <= nr_wake)
-				futex_wake_mark(&wake_q, this);
+				this->wake(&wake_q, this);
 			else
 				requeue_futex(this, hb1, hb2, &key2);
 			continue;
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 37860f794bf7..35c6a637a4bb 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -177,7 +177,7 @@ int futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 			if (!(this->bitset & bitset))
 				continue;
 
-			futex_wake_mark(&wake_q, this);
+			this->wake(&wake_q, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -292,7 +292,7 @@ int futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 				ret = -EINVAL;
 				goto out_unlock;
 			}
-			futex_wake_mark(&wake_q, this);
+			this->wake(&wake_q, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -306,7 +306,7 @@ int futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
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

