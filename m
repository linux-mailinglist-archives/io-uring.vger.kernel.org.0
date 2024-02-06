Return-Path: <io-uring+bounces-556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B0F84BB0B
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17F961F25CDE
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFDEF63D9;
	Tue,  6 Feb 2024 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uMPoPCHc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24DD79C4
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237276; cv=none; b=q/6r6RK7vB3kbkxar8JOvYIzI+V1nP5k/SiER2aB7g5oiR2gBHtcJK2DS+oLYkzjn6z3MIO/jWVlm4eQmFg5T0zTIw3wy+TZSDjab0pIrpbZgj643bmBXv9Gv5gKNv0c+8hroNTB17/RATIlZHxpatKXdqTVbhf9Qom6vW/QhHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237276; c=relaxed/simple;
	bh=eLksyQ0MtfFvoJZdFb1LhkLzmmNUkNkVgRHd9DLyh2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVMdVHishWDTtFuwCuEkixiwUQeuOpfcUPPBJEFhfJtAL1nq/CqS/PB5tjrbJ43j9dIPOaXzgUvNPWjz2ugKS0l83xUgtm8ph0j9xyU5cq1sDBMdaFra3BM1J+a6hEpQDlLfJy4FEsOYHJvPwXWTimSxUzSOAXK/8asZyUvcj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uMPoPCHc; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso74302739f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707237273; x=1707842073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5X5AUjZNYYEuUj8am5fmQz51tbMel9yIWnPqzHKSl4=;
        b=uMPoPCHc97BLc+kQYVmZZXy9Pk6faCA8KUS2foAOU9suVJY/XHNAS0eUt7ZKREZoNO
         m21Z4b2+xNDE11b0Bxg2YwdMPQz96hcb2Fklsr+9/aWGxo62X8kvoP2vhOvvTFB0wm+o
         Xma84CC12p7K0Xs+HqsuazzFjW1x3uX2QIHCakveLyFYzTIFUGNiD5WZzM9yTVm48ZIE
         WjCebTEnGV6pP7twpm+aMZ1lqRjLtWRg+jEmarwwUR7CF784ynENImRHKYj3DI9mEjjS
         BDfYv4szItqXNxhkw9OHw629+BbvSyKuPQ1Q6gBr1FuvTfzU2TFNV94MijZObiwpvOFq
         nUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707237273; x=1707842073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5X5AUjZNYYEuUj8am5fmQz51tbMel9yIWnPqzHKSl4=;
        b=Ywhelqg5jlBT9gJGrgQ4EOZIiSq0ZEMSHXsvLSxYUc2Fpy7sFNpingQxIOc+sX22m7
         ALqxNskZJKfNC6Wk9mSc02MtNOhl+2D310+ZHFteumeUJCYGIrKIZCHLfN50ETNvnay5
         NXKVeKBPfETiauWM7HBOFSbX6fP7fhKCc/VfHpD6MjfTI1Qd5ubgGptzui3HFfqxIq//
         F4YDsYeq08xt6Yryti71Rrdcq5aklWJ6B55MTL1Uov1ro5zcjVS7Vngu5xXTMTdKhK/V
         qutB+o7b4fOzFj0YpxznY8a7XkHQDKyLu8w6aILtuIoq6DFhksJBwYjfOsAikBx0ys7g
         Qs2A==
X-Gm-Message-State: AOJu0YxiLf8cKtUe6CJk//vR4RcidVmLM5t7I0LG2ValKhZtqUiPoHuo
	k0ZIDMknbzbBUpw9mcjWxAoETQ0JKQgJ+s/Eag3g0QIWz03zPTDNSadyxvur4pJh6+OOBPkTxD0
	PaNU=
X-Google-Smtp-Source: AGHT+IF2LDeLQj6zm+K/0hF+quUUwt/9QrU8jUx29xqHZGRzmKptXB3qk+lXT6VsnecHrMTxoz6sRA==
X-Received: by 2002:a6b:670e:0:b0:7c3:eda5:f41a with SMTP id b14-20020a6b670e000000b007c3eda5f41amr2957784ioc.1.1707237273423;
        Tue, 06 Feb 2024 08:34:33 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWvQ63hNe4QbSfaQbvWOvEL5ANMhqoxizDdUu4Ymil+6K4ujTh2yIfz/rW3qcYrwCgCUAWnaTWyWDCMCyCK7E1udKzmFmcbnijh7PrXINxoQ3KnBnURRYsa9uJonwp8B16cESQUEtoBy0qZqvspxvZWN2kZTwu5hFT9H69xMMz4B0w=
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a02aa88000000b00471337ff774sm573316jai.113.2024.02.06.08.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:34:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	olivier@trillion01.com,
	Stefan Roesch <shr@devkernel.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io-uring: add napi busy poll support
Date: Tue,  6 Feb 2024 09:30:06 -0700
Message-ID: <20240206163422.646218-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
References: <20240206163422.646218-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Roesch <shr@devkernel.io>

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. The list is
synchronized by the new napi_lock spin lock. The current default napi
busy polling time is stored in napi_busy_poll_to. If napi busy polling
is not enabled, the value is 0.

In addition there is also a hash table. The hash table store the napi
id and the pointer to the above list nodes. The hash table is used to
speed up the lookup to the list elements. The hash table is synchronized
with rcu.

The NAPI_TIMEOUT is stored as a timeout to make sure that the time a
napi entry is stored in the napi list is limited.

The busy poll timeout is also stored as part of the io_wait_queue. This
is necessary as for sq polling the poll interval needs to be adjusted
and the napi callback allows only to pass in one value.

This has been tested with two simple programs from the liburing library
repository: the napi client and the napi server program. The client
sends a request, which has a timestamp in its payload and the server
replies with the same payload. The client calculates the roundtrip time
and stores it to calculate the results.

The client is running on host1 and the server is running on host 2 (in
the same rack). The measured times below are roundtrip times. They are
average times over 5 runs each. Each run measures 1 million roundtrips.

                   no rx coal          rx coal: frames=88,usecs=33
Default              57us                    56us

client_poll=100us    47us                    46us

server_poll=100us    51us                    46us

client_poll=100us+   40us                    40us
server_poll=100us

client_poll=100us+   41us                    39us
server_poll=100us+
prefer napi busy poll on client

client_poll=100us+   41us                    39us
server_poll=100us+
prefer napi busy poll on server

client_poll=100us+   41us                    39us
server_poll=100us+
prefer napi busy poll on client + server

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230608163839.2891748-5-shr@devkernel.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  11 ++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |   8 ++
 io_uring/io_uring.h            |   4 +
 io_uring/napi.c                | 255 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  89 ++++++++++++
 io_uring/poll.c                |   2 +
 7 files changed, 370 insertions(+)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 8c0742f5b57e..1fabbcda38a6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -2,6 +2,7 @@
 #define IO_URING_TYPES_H
 
 #include <linux/blkdev.h>
+#include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
@@ -374,6 +375,16 @@ struct io_ring_ctx {
 	/* deferred free list, protected by ->uring_lock */
 	struct hlist_head	io_buf_list;
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct list_head	napi_list;	/* track busy poll napi_id */
+	spinlock_t		napi_lock;	/* napi_list lock */
+
+	DECLARE_HASHTABLE(napi_ht, 4);
+	/* napi busy poll default timeout */
+	unsigned int		napi_busy_poll_to;
+	bool			napi_prefer_busy_poll;
+#endif
+
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 2cdc51825405..0e2d4e94855d 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					notif.o waitid.o register.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
+obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 76762371eba3..1a9d176bb7f7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "notif.h"
 #include "waitid.h"
 #include "futex.h"
+#include "napi.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -349,6 +350,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
+	io_napi_init(ctx);
+
 	return ctx;
 err:
 	kfree(ctx->cancel_table.hbs);
@@ -2602,9 +2605,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
+
 		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+		io_napi_adjust_timeout(ctx, &iowq, &ts);
 	}
 
+	io_napi_busy_loop(ctx, &iowq);
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		int nr_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);
@@ -2897,6 +2904,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
+	io_napi_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->io_bl);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 859f6e0580e3..1ca99522811b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -42,6 +42,10 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 	ktime_t timeout;
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned int napi_busy_poll_to;
+	bool napi_prefer_busy_poll;
+#endif
 };
 
 static inline bool io_should_wake(struct io_wait_queue *iowq)
diff --git a/io_uring/napi.c b/io_uring/napi.c
new file mode 100644
index 000000000000..1112cc39153c
--- /dev/null
+++ b/io_uring/napi.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "io_uring.h"
+#include "napi.h"
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+
+/* Timeout for cleanout of stale entries. */
+#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+
+struct io_napi_entry {
+	unsigned int		napi_id;
+	struct list_head	list;
+
+	unsigned long		timeout;
+	struct hlist_node	node;
+
+	struct rcu_head		rcu;
+};
+
+static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
+					       unsigned int napi_id)
+{
+	struct io_napi_entry *e;
+
+	hlist_for_each_entry_rcu(e, hash_list, node) {
+		if (e->napi_id != napi_id)
+			continue;
+		e->timeout = jiffies + NAPI_TIMEOUT;
+		return e;
+	}
+
+	return NULL;
+}
+
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+{
+	struct hlist_head *hash_list;
+	unsigned int napi_id;
+	struct sock *sk;
+	struct io_napi_entry *e;
+
+	sk = sock->sk;
+	if (!sk)
+		return;
+
+	napi_id = READ_ONCE(sk->sk_napi_id);
+
+	/* Non-NAPI IDs can be rejected. */
+	if (napi_id < MIN_NAPI_ID)
+		return;
+
+	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
+
+	rcu_read_lock();
+	e = io_napi_hash_find(hash_list, napi_id);
+	if (e) {
+		e->timeout = jiffies + NAPI_TIMEOUT;
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	e = kmalloc(sizeof(*e), GFP_NOWAIT);
+	if (!e)
+		return;
+
+	e->napi_id = napi_id;
+	e->timeout = jiffies + NAPI_TIMEOUT;
+
+	spin_lock(&ctx->napi_lock);
+	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
+		spin_unlock(&ctx->napi_lock);
+		kfree(e);
+		return;
+	}
+
+	hlist_add_tail_rcu(&e->node, hash_list);
+	list_add_tail(&e->list, &ctx->napi_list);
+	spin_unlock(&ctx->napi_lock);
+}
+
+static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
+{
+	struct io_napi_entry *e;
+	unsigned int i;
+
+	spin_lock(&ctx->napi_lock);
+	hash_for_each(ctx->napi_ht, i, e, node) {
+		if (time_after(jiffies, e->timeout)) {
+			list_del(&e->list);
+			hash_del_rcu(&e->node);
+			kfree_rcu(e, rcu);
+		}
+	}
+	spin_unlock(&ctx->napi_lock);
+}
+
+static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
+{
+	if (is_stale)
+		__io_napi_remove_stale(ctx);
+}
+
+static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
+					     unsigned long bp_usec)
+{
+	if (bp_usec) {
+		unsigned long end_time = start_time + bp_usec;
+		unsigned long now = busy_loop_current_time();
+
+		return time_after(now, end_time);
+	}
+
+	return true;
+}
+
+static bool io_napi_busy_loop_should_end(void *data,
+					 unsigned long start_time)
+{
+	struct io_wait_queue *iowq = data;
+
+	if (signal_pending(current))
+		return true;
+	if (io_should_wake(iowq))
+		return true;
+	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
+		return true;
+
+	return false;
+}
+
+static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
+				   void *loop_end_arg)
+{
+	struct io_napi_entry *e;
+	bool (*loop_end)(void *, unsigned long) = NULL;
+	bool is_stale = false;
+
+	if (loop_end_arg)
+		loop_end = io_napi_busy_loop_should_end;
+
+	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
+		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
+				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+
+		if (time_after(jiffies, e->timeout))
+			is_stale = true;
+	}
+
+	return is_stale;
+}
+
+static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
+				       struct io_wait_queue *iowq)
+{
+	unsigned long start_time = busy_loop_current_time();
+	void *loop_end_arg = NULL;
+	bool is_stale = false;
+
+	/* Singular lists use a different napi loop end check function and are
+	 * only executed once.
+	 */
+	if (list_is_singular(&ctx->napi_list))
+		loop_end_arg = iowq;
+
+	rcu_read_lock();
+	do {
+		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
+	rcu_read_unlock();
+
+	io_napi_remove_stale(ctx, is_stale);
+}
+
+/*
+ * io_napi_init() - Init napi settings
+ * @ctx: pointer to io-uring context structure
+ *
+ * Init napi settings in the io-uring context.
+ */
+void io_napi_init(struct io_ring_ctx *ctx)
+{
+	INIT_LIST_HEAD(&ctx->napi_list);
+	spin_lock_init(&ctx->napi_lock);
+	ctx->napi_prefer_busy_poll = false;
+	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
+}
+
+/*
+ * io_napi_free() - Deallocate napi
+ * @ctx: pointer to io-uring context structure
+ *
+ * Free the napi list and the hash table in the io-uring context.
+ */
+void io_napi_free(struct io_ring_ctx *ctx)
+{
+	struct io_napi_entry *e;
+	LIST_HEAD(napi_list);
+	unsigned int i;
+
+	spin_lock(&ctx->napi_lock);
+	hash_for_each(ctx->napi_ht, i, e, node) {
+		hash_del_rcu(&e->node);
+		kfree_rcu(e, rcu);
+	}
+	spin_unlock(&ctx->napi_lock);
+}
+
+/*
+ * __io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * @ctx: pointer to io-uring context structure
+ * @iowq: pointer to io wait queue
+ * @ts: pointer to timespec or NULL
+ *
+ * Adjust the busy loop timeout according to timespec and busy poll timeout.
+ */
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
+			      struct timespec64 *ts)
+{
+	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
+
+	if (ts) {
+		struct timespec64 poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+
+		if (timespec64_compare(ts, &poll_to_ts) > 0) {
+			*ts = timespec64_sub(*ts, poll_to_ts);
+		} else {
+			u64 to = timespec64_to_ns(ts);
+
+			do_div(to, 1000);
+			ts->tv_sec = 0;
+			ts->tv_nsec = 0;
+		}
+	}
+
+	iowq->napi_busy_poll_to = poll_to;
+}
+
+/*
+ * __io_napi_busy_loop() - execute busy poll loop
+ * @ctx: pointer to io-uring context structure
+ * @iowq: pointer to io wait queue
+ *
+ * Execute the busy poll loop and merge the spliced off list.
+ */
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
+{
+	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && iowq->napi_busy_poll_to)
+		io_napi_blocking_busy_loop(ctx, iowq);
+}
+
+#endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
new file mode 100644
index 000000000000..be8aa8ee32d9
--- /dev/null
+++ b/io_uring/napi.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef IOU_NAPI_H
+#define IOU_NAPI_H
+
+#include <linux/kernel.h>
+#include <linux/io_uring.h>
+#include <net/busy_poll.h>
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+
+void io_napi_init(struct io_ring_ctx *ctx);
+void io_napi_free(struct io_ring_ctx *ctx);
+
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
+
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+		struct io_wait_queue *iowq, struct timespec64 *ts);
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
+
+static inline bool io_napi(struct io_ring_ctx *ctx)
+{
+	return !list_empty(&ctx->napi_list);
+}
+
+static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  struct timespec64 *ts)
+{
+	if (!io_napi(ctx))
+		return;
+	__io_napi_adjust_timeout(ctx, iowq, ts);
+}
+
+static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
+{
+	if (!io_napi(ctx))
+		return;
+	__io_napi_busy_loop(ctx, iowq);
+}
+
+/*
+ * io_napi_add() - Add napi id to the busy poll list
+ * @req: pointer to io_kiocb request
+ *
+ * Add the napi id of the socket to the napi busy poll list and hash table.
+ */
+static inline void io_napi_add(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct socket *sock;
+
+	if (!READ_ONCE(ctx->napi_busy_poll_to))
+		return;
+
+	sock = sock_from_file(req->file);
+	if (sock)
+		__io_napi_add(ctx, sock);
+}
+
+#else
+
+static inline void io_napi_init(struct io_ring_ctx *ctx)
+{
+}
+static inline void io_napi_free(struct io_ring_ctx *ctx)
+{
+}
+static inline bool io_napi(struct io_ring_ctx *ctx)
+{
+	return false;
+}
+static inline void io_napi_add(struct io_kiocb *req)
+{
+}
+static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  struct timespec64 *ts)
+{
+}
+static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
+{
+}
+
+#endif /* CONFIG_NET_RX_BUSY_POLL */
+
+#endif
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8e01c2672df4..053d738c330c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -15,6 +15,7 @@
 
 #include "io_uring.h"
 #include "refs.h"
+#include "napi.h"
 #include "opdef.h"
 #include "kbuf.h"
 #include "poll.h"
@@ -649,6 +650,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		__io_poll_execute(req, mask);
 		return 0;
 	}
+	io_napi_add(req);
 
 	if (ipt->owning) {
 		/*
-- 
2.43.0


