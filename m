Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A763975E3
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhFAPAg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 11:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhFAPAf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 11:00:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FD8C06174A;
        Tue,  1 Jun 2021 07:58:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n4so14699011wrw.3;
        Tue, 01 Jun 2021 07:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LMV82XQ2WTYEkk7h3J6fMG0vSDs2Xa027BUtgb0mwIc=;
        b=fDHEjnEwM0qvEI3ETHSYQXGd9irEfSv7KDVZKufkTEzBq5URngtiqEvM+cKuGS2XVH
         9+sgt9X63W+5irfiwFZ+QGwGftsZMbjKKvganlUNhzlcwHuOJt3iP23u5xgCF76iJZzT
         e/Z7UlaG97Msyi5lg1GUYCjMWkWhRHd2WEZrqDAZxd09IJ93rNe7vy3+mqF39CJ7nDhL
         pSmFFTbizpJrWoD+F7jpMAIk5/OzLZ8n7l0RmgzGHU0Jeau8I8kIIF7zCOIrp4sNrzoP
         xbeLbGoEOe2Mc9gE/I5CeQKc/SAwLd5lqzsmZtmxFc9qd1c8MigLLmiO/xP4dYJYfz1e
         m/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LMV82XQ2WTYEkk7h3J6fMG0vSDs2Xa027BUtgb0mwIc=;
        b=Uzrj4PJc4rPIhvD1UjOnDlWDXhnFsTV2WsH3uv+WZvgmIBr0VRwfCFsnDLIm3jGGmf
         8WVMHdZQ47vQV7FbbaG0mZDzEoZNTZ7L3WraD3tC+E1rQa3wP8b9+APom6vSRUzh5agf
         ZpX6dld4NkbrsLcedfxhdi6Hgwjc7tv+jZap8BOQoDEr0RiD8BwrFJUCzV9Q7lRhF+Fd
         MZdUaWhC6Jkw0hZtQc16G9tSt5r1+tjajwbd9wqfqEyBi/l8XZxz5N/c3QoIPuPSLKkZ
         SJ+suevyOwKnpMFq+co+6rhYmgeiddmgMGWPb87Re++x7R6ImLRYFz+iTK3RoEdtPmpV
         gDTw==
X-Gm-Message-State: AOAM5333lxFL8YHi1jLjuPNvHJNcvPYWfn4JjAUwb50TXrsHmDTZtEMP
        Z+9UG9BtmGpxNnJ7rB2Wg0uUoi7mPKZ/rg==
X-Google-Smtp-Source: ABdhPJzNnU/hqFoN9pQen6NJZpayOLXNpG6MdWnmakMDCzftRslEQAnjJCBptVyITuw4Vc2Y2Upubg==
X-Received: by 2002:a5d:4ac2:: with SMTP id y2mr8366068wrs.316.1622559531019;
        Tue, 01 Jun 2021 07:58:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id b4sm10697061wmj.42.2021.06.01.07.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:58:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/4] futex: add op wake for a single key
Date:   Tue,  1 Jun 2021 15:58:26 +0100
Message-Id: <2fded39d933cb51f0992fd51416ddef5f0e81493.1622558659.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622558659.git.asml.silence@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new futex wake function futex_wake_op_single(), which works
similar to futex_wake_op() but only for a single futex address as it
takes too many arguments. Also export it and other functions that will
be used by io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/futex.h | 15 ++++++++++
 kernel/futex.c        | 64 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index b70df27d7e85..04d500ae5983 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -77,6 +77,10 @@ void futex_exec_release(struct task_struct *tsk);
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
+int futex_wake_op_single(u32 __user *uaddr, int nr_wake, unsigned int op,
+			 bool shared, bool try);
+int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
+	       ktime_t *abs_time, u32 bitset);
 #else
 static inline void futex_init_task(struct task_struct *tsk) { }
 static inline void futex_exit_recursive(struct task_struct *tsk) { }
@@ -88,6 +92,17 @@ static inline long do_futex(u32 __user *uaddr, int op, u32 val,
 {
 	return -EINVAL;
 }
+static inline int futex_wake_op_single(u32 __user *uaddr, int nr_wake,
+				       unsigned int op, bool shared, bool try)
+{
+	return -EINVAL;
+}
+static inline int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
+			     ktime_t *abs_time, u32 bitset)
+{
+	return -EINVAL;
+}
+
 #endif
 
 #endif
diff --git a/kernel/futex.c b/kernel/futex.c
index 4938a00bc785..75dc600062a4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1681,6 +1681,66 @@ static int futex_atomic_op_inuser(unsigned int encoded_op, u32 __user *uaddr)
 	}
 }
 
+int futex_wake_op_single(u32 __user *uaddr, int nr_wake, unsigned int op,
+			 bool shared, bool try)
+{
+	union futex_key key;
+	struct futex_hash_bucket *hb;
+	struct futex_q *this, *next;
+	int ret, op_ret;
+	DEFINE_WAKE_Q(wake_q);
+
+retry:
+	ret = get_futex_key(uaddr, shared, &key, FUTEX_WRITE);
+	if (unlikely(ret != 0))
+		return ret;
+	hb = hash_futex(&key);
+retry_private:
+	spin_lock(&hb->lock);
+	op_ret = futex_atomic_op_inuser(op, uaddr);
+	if (unlikely(op_ret < 0)) {
+		spin_unlock(&hb->lock);
+
+		if (!IS_ENABLED(CONFIG_MMU) ||
+		    unlikely(op_ret != -EFAULT && op_ret != -EAGAIN)) {
+			/*
+			 * we don't get EFAULT from MMU faults if we don't have
+			 * an MMU, but we might get them from range checking
+			 */
+			ret = op_ret;
+			return ret;
+		}
+		if (try)
+			return -EAGAIN;
+
+		if (op_ret == -EFAULT) {
+			ret = fault_in_user_writeable(uaddr);
+			if (ret)
+				return ret;
+		}
+		cond_resched();
+		if (shared)
+			goto retry;
+		goto retry_private;
+	}
+	if (op_ret) {
+		plist_for_each_entry_safe(this, next, &hb->chain, list) {
+			if (match_futex(&this->key, &key)) {
+				if (this->pi_state || this->rt_waiter) {
+					ret = -EINVAL;
+					break;
+				}
+				mark_wake_futex(&wake_q, this);
+				if (++ret >= nr_wake)
+					break;
+			}
+		}
+	}
+	spin_unlock(&hb->lock);
+	wake_up_q(&wake_q);
+	return ret;
+}
+
 /*
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
@@ -2680,8 +2740,8 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
-		      ktime_t *abs_time, u32 bitset)
+int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
+	       ktime_t *abs_time, u32 bitset)
 {
 	struct hrtimer_sleeper timeout, *to;
 	struct restart_block *restart;
-- 
2.31.1

