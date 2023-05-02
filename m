Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26206F48AE
	for <lists+io-uring@lfdr.de>; Tue,  2 May 2023 18:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjEBQyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 May 2023 12:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjEBQyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 May 2023 12:54:17 -0400
Received: from 66-220-144-179.mail-mxout.facebook.com (66-220-144-179.mail-mxout.facebook.com [66.220.144.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2D430CA
        for <io-uring@vger.kernel.org>; Tue,  2 May 2023 09:54:05 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 1CD594CF6CC0; Tue,  2 May 2023 09:53:47 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v12 2/5] io-uring: add napi busy poll support
Date:   Tue,  2 May 2023 09:53:29 -0700
Message-Id: <20230502165332.2075091-3-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230502165332.2075091-1-shr@devkernel.io>
References: <20230502165332.2075091-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. The list is
synchronized by the new napi_lock spin lock. The current default napi
busy polling time is stored in napi_busy_poll_to. If napi busy polling
is not enabled, the value is 0.

In addition there is also a hash table. The hash table store the napi
id ond the pointer to the above list nodes. The hash table is used to
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
and stores it to calcualte the results.

The client is running on host1 and the server is running on host 2 (in
the same rack). The measured times below are roundtrip times. They are
average times over 5 runs each. Each run measures 1 million roundtrips.

                   no rx coal          rx coal: frames=3D88,usecs=3D33
Default              57us                    56us

client_poll=3D100us    47us                    46us

server_poll=3D100us    51us                    46us

client_poll=3D100us+   40us                    40us
server_poll=3D100us

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on client

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on server

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on client + server

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/io_uring_types.h |  11 ++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |   8 +
 io_uring/io_uring.h            |   4 +
 io_uring/napi.c                | 260 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  83 +++++++++++
 io_uring/poll.c                |   2 +
 7 files changed, 369 insertions(+)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 1b2a20a42413..9def1de4eaf4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -2,6 +2,7 @@
 #define IO_URING_TYPES_H
=20
 #include <linux/blkdev.h>
+#include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
@@ -277,6 +278,16 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
=20
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
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..2efe7c5f07ba 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_IO_URING)		+=3D io_uring.o xattr.o nop.o fs.=
o splice.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
 obj-$(CONFIG_IO_WQ)		+=3D io-wq.o
+obj-$(CONFIG_NET_RX_BUSY_POLL) +=3D napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index efbd6c9c56e5..f06175b36b41 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -91,6 +91,7 @@
 #include "rsrc.h"
 #include "cancel.h"
 #include "net.h"
+#include "napi.h"
 #include "notif.h"
=20
 #include "timeout.h"
@@ -337,6 +338,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	io_napi_init(ctx);
+
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2619,9 +2622,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx,=
 int min_events,
=20
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
+
 		iowq.timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns())=
;
+		io_napi_adjust_timeout(ctx, &iowq, &ts);
 	}
=20
+	io_napi_busy_loop(ctx, &iowq);
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		unsigned long check_cq;
@@ -2856,6 +2863,7 @@ static __cold void io_ring_ctx_free(struct io_ring_=
ctx *ctx)
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
+	io_napi_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->dummy_ubuf);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5f04bd47562a..d669e06f54f0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -48,6 +48,10 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 	ktime_t timeout;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned int napi_busy_poll_to;
+	bool napi_prefer_busy_poll;
+#endif
 };
=20
 static inline bool io_should_wake(struct io_wait_queue *iowq)
diff --git a/io_uring/napi.c b/io_uring/napi.c
new file mode 100644
index 000000000000..76bcabeb7ef0
--- /dev/null
+++ b/io_uring/napi.c
@@ -0,0 +1,260 @@
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
+static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_l=
ist,
+					       unsigned int napi_id)
+{
+	struct io_napi_entry *e;
+
+	hlist_for_each_entry_rcu(e, hash_list, node) {
+		if (e->napi_id !=3D napi_id)
+			continue;
+		e->timeout =3D jiffies + NAPI_TIMEOUT;
+		return e;
+	}
+
+	return NULL;
+}
+
+void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
+{
+	struct hlist_head *hash_list;
+	unsigned int napi_id;
+	struct socket *sock;
+	struct sock *sk;
+	struct io_napi_entry *e;
+
+	sock =3D sock_from_file(file);
+	if (!sock)
+		return;
+
+	sk =3D sock->sk;
+	if (!sk)
+		return;
+
+	napi_id =3D READ_ONCE(sk->sk_napi_id);
+
+	/* Non-NAPI IDs can be rejected. */
+	if (napi_id < MIN_NAPI_ID)
+		return;
+
+	hash_list =3D &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))]=
;
+
+	rcu_read_lock();
+	e =3D io_napi_hash_find(hash_list, napi_id);
+	if (e) {
+		e->timeout =3D jiffies + NAPI_TIMEOUT;
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	e =3D kmalloc(sizeof(*e), GFP_NOWAIT);
+	if (!e)
+		return;
+
+	e->napi_id =3D napi_id;
+	e->timeout =3D jiffies + NAPI_TIMEOUT;
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
+static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is=
_stale)
+{
+	if (is_stale)
+		__io_napi_remove_stale(ctx);
+}
+
+static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
+					     unsigned long bp_usec)
+{
+	if (bp_usec) {
+		unsigned long end_time =3D start_time + bp_usec;
+		unsigned long now =3D busy_loop_current_time();
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
+	struct io_wait_queue *iowq =3D data;
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
+	bool (*loop_end)(void *, unsigned long) =3D NULL;
+	bool is_stale =3D false;
+
+	if (loop_end_arg)
+		loop_end =3D io_napi_busy_loop_should_end;
+
+	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
+		napi_busy_loop(e->napi_id, loop_end, loop_end_arg,
+			       ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+
+		if (time_after(jiffies, e->timeout))
+			is_stale =3D true;
+	}
+
+	return is_stale;
+}
+
+static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
+				       struct io_wait_queue *iowq)
+{
+	unsigned long start_time =3D busy_loop_current_time();
+	void *loop_end_arg =3D NULL;
+	bool is_stale =3D false;
+
+	/* Singular lists use a different napi loop end check function and are
+	 * only executed once.
+	 */
+	if (list_is_singular(&ctx->napi_list))
+		loop_end_arg =3D iowq;
+
+	rcu_read_lock();
+	do {
+		is_stale =3D __io_napi_do_busy_loop(ctx, loop_end_arg);
+	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_a=
rg);
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
+	ctx->napi_prefer_busy_poll =3D false;
+	ctx->napi_busy_poll_to =3D READ_ONCE(sysctl_net_busy_poll);
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
+ * Adjust the busy loop timeout according to timespec and busy poll time=
out.
+ */
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_qu=
eue *iowq,
+			      struct timespec64 *ts)
+{
+	unsigned int poll_to =3D READ_ONCE(ctx->napi_busy_poll_to);
+
+	if (ts) {
+		struct timespec64 poll_to_ts =3D ns_to_timespec64(1000 * (s64)poll_to)=
;
+
+		if (timespec64_compare(ts, &poll_to_ts) > 0) {
+			*ts =3D timespec64_sub(*ts, poll_to_ts);
+		} else {
+			u64 to =3D timespec64_to_ns(ts);
+
+			do_div(to, 1000);
+			ts->tv_sec =3D 0;
+			ts->tv_nsec =3D 0;
+		}
+	}
+
+	iowq->napi_busy_poll_to =3D poll_to;
+}
+
+/*
+ * __io_napi_busy_loop() - execute busy poll loop
+ * @ctx: pointer to io-uring context structure
+ * @iowq: pointer to io wait queue
+ *
+ * Execute the busy poll loop and merge the spliced off list.
+ */
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *=
iowq)
+{
+	iowq->napi_prefer_busy_poll =3D READ_ONCE(ctx->napi_prefer_busy_poll);
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && iowq->napi_busy_poll_to)
+		io_napi_blocking_busy_loop(ctx, iowq);
+}
+
+#endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
new file mode 100644
index 000000000000..1bdf8442081f
--- /dev/null
+++ b/io_uring/napi.h
@@ -0,0 +1,83 @@
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
+void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
+
+void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+		struct io_wait_queue *iowq, struct timespec64 *ts);
+void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *=
iowq);
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
+ * Add the napi id of the socket to the napi busy poll list and hash tab=
le.
+ */
+static inline void io_napi_add(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+
+	if (!READ_ONCE(ctx->napi_busy_poll_to))
+		return;
+
+	__io_napi_add(ctx, req->file);
+}
+
+#else
+
+static inline void io_napi_init(struct io_ring_ctx *ctx)
+{
+}
+
+static inline void io_napi_free(struct io_ring_ctx *ctx)
+{
+}
+
+static inline bool io_napi(struct io_ring_ctx *ctx)
+{
+	return false;
+}
+
+static inline void io_napi_add(struct io_kiocb *req)
+{
+}
+
+#define io_napi_adjust_timeout(ctx, iowq, ts) do {} while (0)
+#define io_napi_busy_loop(ctx, iowq) do {} while (0)
+
+#endif
+
+#endif
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c90e47dc1e29..0284849793bb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -15,6 +15,7 @@
=20
 #include "io_uring.h"
 #include "refs.h"
+#include "napi.h"
 #include "opdef.h"
 #include "kbuf.h"
 #include "poll.h"
@@ -631,6 +632,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req=
,
 		__io_poll_execute(req, mask);
 		return 0;
 	}
+	io_napi_add(req);
=20
 	if (ipt->owning) {
 		/*
--=20
2.39.1

