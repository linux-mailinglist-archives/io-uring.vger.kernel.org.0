Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3AA7A9A46
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjIUShs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjIUShR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:37:17 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B603D7DB6
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:17 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-34e1757fe8fso1016745ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320956; x=1695925756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5m39pK9Sy+s98BPtXb5MPOzqgjCaZT2iuuWI0t83mc=;
        b=pbeT1sbpkNh70vmMi3c2YLE6X/cRjVCPHP3VLnlyOgV6DtqthEfXH5xxiCUWNyq/aO
         Uev+MjFXqt/oSR+daovj2eWyBPsl3J/V3e7S4RjbmQ0mEYo65rVU1Faks5HvQjJ8yxm2
         wjApNCrR206ws+T0WdYaGkPQoFRu59KCbABM+wp9dRYj2m6dPNeOsW/kFJyYjtoHE6Td
         8chLc/WsroHdM7R3Nwb+37BgSrs1iijFll/osPXPuPQQsxBMY3bTCFNqjpuxqmLndUGW
         JgH/SYxLnTbYMyePJU1yjHhAmuhxwZSJiPznc9pjH3UKrnHOZDgsnnMXfPgxTLf2a+wH
         +jjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320956; x=1695925756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5m39pK9Sy+s98BPtXb5MPOzqgjCaZT2iuuWI0t83mc=;
        b=nPodgUEzibZNLu+UYcvMYg4Va3O2yf3UgcuQEyLw1cMlNRW/rwtIgtUtd62KY453Bf
         yUuo41uoN+tAq6PDn0XF47QS+qk8cyffu2WmRRtzpLgDZJAh44pcjq9OO/wOcidUusSa
         4qhZrrHArf1ZMR572DvmcaqgwOtKuwyoOQzctpp3m/xZ8PEDZz5a1Yv50H3Of4q4jZiA
         pNVEi+sQ/pT+R9xwz5lQkURQH8Lg79UMR9UBUZFxI6oFrlQvdu3IjRDdywzoNiWjBQz0
         F7Y4309hldRiaRQkOBTpUXK0IIuwOyV67AX65M05/I4KCvdrt/MeaHHYNvknP83RKopr
         chgQ==
X-Gm-Message-State: AOJu0YzIlbeSkpmBCXnSbdzARzL8eE0JNjwQxPrKe+rkjuRsu8KcEAv7
        ZYAxDEtxwH996VRWfukdN/ipyRazXpER7ysa3IyJuA==
X-Google-Smtp-Source: AGHT+IGqEzddFnDbKkDtYGA8ktTswxfUZvEcKcJvZukcbX41+WzSSJZjWINRWy9kHKvClMEuc2TsUQ==
X-Received: by 2002:a05:6602:4996:b0:79a:c487:2711 with SMTP id eg22-20020a056602499600b0079ac4872711mr7316666iob.0.1695320956283;
        Thu, 21 Sep 2023 11:29:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] futex: factor out the futex wake handling
Date:   Thu, 21 Sep 2023 12:29:02 -0600
Message-Id: <20230921182908.160080-3-axboe@kernel.dk>
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

