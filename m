Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C018172A23F
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjFISbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjFISbg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:36 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C59E35B3
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:33 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-33d0c740498so911435ab.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335492; x=1688927492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXQqhUliGcPBmuBlH0wkZgD4w96JtLsryqUu5jjomWg=;
        b=As1AkOemnueixaino3MHFDx2xUDZq2TSa/Rn0liGFK4Pm968NecFs5Sumj4AEKJN+I
         87B2GnwU17n2ZFj6B028t93S8RUyqtatMYJ9FSty1zMAWlvbRpK1pNupuDnuiLtYhcxk
         KkYXCNjIUqaAKovQLubC9weMkHOdTPUTIaIaYCTBw4Nl2/0wynUzb+VgbWzxQri1M692
         +LhraX1U/miDoldVL55S85jxU66nzdSEjbDBIEdY5vHotu11z8pxof5W3DcDEjbQce1h
         DV8dgOxZNMW8nkAo8LxD5Z4AUfFOHApooQoGfuDztknjTWKTwmmZgJXyS4JIn/s2qF29
         gIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335492; x=1688927492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXQqhUliGcPBmuBlH0wkZgD4w96JtLsryqUu5jjomWg=;
        b=VNxm/8+vjZ3Dv/2IvbosI3UdJaW6YGwW9/R7SH4Aj5+mmRKw6x5ft5l4pcP56zQEBX
         QPd+/KhBcP3dEvyEMny0xwjSNrZhRuOIzpv4Zo3EWRKnLban86y+7RFTChU3v8qpKE/Z
         zLOr+gdME7/Tb/IVEjVAP3V6qzp/gbVrY8SjVhoIb4puCiNlNVHJ3vgWqXY2CNjiZSsv
         q/uKU8WhJamLLAZAuiJcFY4J7CotFM5mr5P5zW0dV/v9YgJTO1dLApefJUqtbh+r23wW
         O7+1C4F0N8nKIKlcPh4M9ngwHS5Gtlscuowl9zVBAWlBt9SOLsXgdcXwstUXhWv9ymA2
         5XLA==
X-Gm-Message-State: AC+VfDwhf+hNPTSZ+1ZtyxI1+LAuqOohvWamoPQfFhQ9Kkgs8GUy0fJ9
        oraanA+YeE1UIh8ShsqRphDJSOD/OUOzVyqGIPQ=
X-Google-Smtp-Source: ACHHUZ495VpbwfEM78NdUpSjoTokGZaP2yeKaGfAqZQXgkXJPKHbmQ3Uts3Db2azfbmISTdph2RIRA==
X-Received: by 2002:a05:6e02:1188:b0:32a:eacb:c5d4 with SMTP id y8-20020a056e02118800b0032aeacbc5d4mr1225219ili.0.1686335492430;
        Fri, 09 Jun 2023 11:31:32 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] futex: factor out the futex wake handling
Date:   Fri,  9 Jun 2023 12:31:21 -0600
Message-Id: <20230609183125.673140-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609183125.673140-1-axboe@kernel.dk>
References: <20230609183125.673140-1-axboe@kernel.dk>
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

In preparation for having another waker that isn't futex_wake_mark(),
add a wake handler in futex_q and rename the futex_q->task field to just
be wake_data. futex_wake_mark() is defined as the standard wakeup helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/core.c     | 2 +-
 kernel/futex/futex.h    | 3 ++-
 kernel/futex/requeue.c  | 7 ++++---
 kernel/futex/waitwake.c | 8 ++++----
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 514e4582b863..6223cce3d876 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -556,7 +556,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
-	q->task = current;
+	q->wake_data = current;
 }
 
 /**
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index d2949fca37d1..1b7dd5266dd2 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -96,7 +96,6 @@ struct futex_pi_state {
 struct futex_q {
 	struct plist_node list;
 
-	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
@@ -107,6 +106,8 @@ struct futex_q {
 #ifdef CONFIG_PREEMPT_RT
 	struct rcuwait requeue_wait;
 #endif
+	void (*wake)(struct wake_q_head *wake_q, struct futex_q *);
+	void *wake_data;
 } __randomize_layout;
 
 extern const struct futex_q futex_q_init;
diff --git a/kernel/futex/requeue.c b/kernel/futex/requeue.c
index cba8b1a6a4cc..6aee8408c341 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -61,6 +61,7 @@ const struct futex_q futex_q_init = {
 	.key		= FUTEX_KEY_INIT,
 	.bitset		= FUTEX_BITSET_MATCH_ANY,
 	.requeue_state	= ATOMIC_INIT(Q_REQUEUE_PI_NONE),
+	.wake		= futex_wake_mark,
 };
 
 /**
@@ -234,7 +235,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 
 	/* Signal locked state to the waiter */
 	futex_requeue_pi_complete(q, 1);
-	wake_up_state(q->task, TASK_NORMAL);
+	wake_up_state(q->wake_data, TASK_NORMAL);
 }
 
 /**
@@ -316,7 +317,7 @@ futex_proxy_trylock_atomic(u32 __user *pifutex, struct futex_hash_bucket *hb1,
 	 * the user space lock can be acquired then PI state is attached to
 	 * the new owner (@top_waiter->task) when @set_waiters is true.
 	 */
-	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
+	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->wake_data,
 				   exiting, set_waiters);
 	if (ret == 1) {
 		/*
@@ -626,7 +627,7 @@ int futex_requeue(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 
 		ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 						this->rt_waiter,
-						this->task);
+						this->wake_data);
 
 		if (ret == 1) {
 			/*
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index ba01b9408203..5151c83e2db8 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -114,7 +114,7 @@
  */
 void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
 {
-	struct task_struct *p = q->task;
+	struct task_struct *p = q->wake_data;
 
 	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
 		return;
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
2.39.2

