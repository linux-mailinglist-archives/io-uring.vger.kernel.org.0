Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A716EE775
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 20:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjDYSTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 14:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjDYSTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 14:19:10 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCB986BE
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 11:19:08 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 1D26D442E9C1; Tue, 25 Apr 2023 11:18:52 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v10 2/5] io-uring: add napi busy poll support
Date:   Tue, 25 Apr 2023 11:18:42 -0700
Message-Id: <20230425181845.2813854-3-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230425181845.2813854-1-shr@devkernel.io>
References: <20230425181845.2813854-1-shr@devkernel.io>
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
speed up the lookup to the list elements.

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
 include/linux/io_uring_types.h |  10 ++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |  30 +++-
 io_uring/io_uring.h            |   4 +
 io_uring/napi.c                | 243 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  66 +++++++++
 io_uring/poll.c                |   2 +
 7 files changed, 351 insertions(+), 5 deletions(-)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 1b2a20a42413..2b2ca990ee93 100644
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
@@ -277,6 +278,15 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct list_head	napi_list;	/* track busy poll napi_id */
+	spinlock_t		napi_lock;	/* napi_list lock */
+
+	DECLARE_HASHTABLE(napi_ht, 4);
+	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
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
index efbd6c9c56e5..fff8f84eb560 100644
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
@@ -2614,15 +2617,31 @@ static int io_cqring_wait(struct io_ring_ctx *ctx=
, int min_events,
 	iowq.cq_tail =3D READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout =3D KTIME_MAX;
=20
-	if (uts) {
-		struct timespec64 ts;
+	if (!io_napi(ctx)) {
+		if (uts) {
+			struct timespec64 ts;
=20
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		iowq.timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns())=
;
+			if (get_timespec64(&ts, uts))
+				return -EFAULT;
+			iowq.timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns()=
);
+		}
+	} else {
+		if (uts) {
+			struct timespec64 ts;
+
+			if (get_timespec64(&ts, uts))
+				return -EFAULT;
+
+			io_napi_adjust_timeout(ctx, &iowq, &ts);
+			iowq.timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns()=
);
+		} else {
+			io_napi_adjust_timeout(ctx, &iowq, NULL);
+		}
+		io_napi_busy_loop(ctx, &iowq);
 	}
=20
 	trace_io_uring_cqring_wait(ctx, min_events);
+
 	do {
 		unsigned long check_cq;
=20
@@ -2856,6 +2875,7 @@ static __cold void io_ring_ctx_free(struct io_ring_=
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
index 000000000000..bb7d2b6b7e90
--- /dev/null
+++ b/io_uring/napi.c
@@ -0,0 +1,243 @@
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
+struct io_napi_ht_entry {
+	unsigned int		napi_id;
+	struct list_head	list;
+
+	/* Covered by napi lock spinlock.  */
+	unsigned long		timeout;
+	struct hlist_node	node;
+};
+
+void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
+{
+	unsigned int napi_id;
+	struct socket *sock;
+	struct sock *sk;
+	struct io_napi_ht_entry *he;
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
+	spin_lock(&ctx->napi_lock);
+	hash_for_each_possible(ctx->napi_ht, he, node, napi_id) {
+		if (he->napi_id =3D=3D napi_id) {
+			he->timeout =3D jiffies + NAPI_TIMEOUT;
+			goto out;
+		}
+	}
+
+	he =3D kmalloc(sizeof(*he), GFP_NOWAIT);
+	if (!he)
+		goto out;
+
+	he->napi_id =3D napi_id;
+	he->timeout =3D jiffies + NAPI_TIMEOUT;
+	hash_add(ctx->napi_ht, &he->node, napi_id);
+
+	list_add_tail(&he->list, &ctx->napi_list);
+
+out:
+	spin_unlock(&ctx->napi_lock);
+}
+
+static inline void adjust_timeout(unsigned int poll_to, struct timespec6=
4 *ts,
+		unsigned int *new_poll_to)
+{
+	struct timespec64 pollto =3D ns_to_timespec64(1000 * (s64)poll_to);
+
+	if (timespec64_compare(ts, &pollto) > 0) {
+		*ts =3D timespec64_sub(*ts, pollto);
+		*new_poll_to =3D poll_to;
+	} else {
+		u64 to =3D timespec64_to_ns(ts);
+
+		do_div(to, 1000);
+		*new_poll_to =3D to;
+		ts->tv_sec =3D 0;
+		ts->tv_nsec =3D 0;
+	}
+}
+
+static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
+		unsigned long bp_usec)
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
+static bool io_napi_busy_loop_should_end(void *p, unsigned long start_ti=
me)
+{
+	struct io_wait_queue *iowq =3D p;
+
+	return signal_pending(current) ||
+	       io_should_wake(iowq) ||
+	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
+}
+
+static bool __io_napi_busy_loop(struct list_head *napi_list, bool prefer=
_busy_poll)
+{
+	struct io_napi_ht_entry *e;
+	struct io_napi_ht_entry *n;
+
+	list_for_each_entry_safe(e, n, napi_list, list) {
+		napi_busy_loop(e->napi_id, NULL, NULL, prefer_busy_poll,
+			       BUSY_POLL_BUDGET);
+	}
+
+	return !list_empty(napi_list);
+}
+
+static void io_napi_multi_busy_loop(struct list_head *napi_list,
+		struct io_wait_queue *iowq)
+{
+	unsigned long start_time =3D busy_loop_current_time();
+
+	do {
+		if (list_is_singular(napi_list))
+			break;
+		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
+			break;
+	} while (!io_napi_busy_loop_should_end(iowq, start_time));
+}
+
+static void io_napi_blocking_busy_loop(struct list_head *napi_list,
+		struct io_wait_queue *iowq)
+{
+	if (!list_is_singular(napi_list))
+		io_napi_multi_busy_loop(napi_list, iowq);
+
+	if (list_is_singular(napi_list)) {
+		struct io_napi_ht_entry *ne;
+
+		ne =3D list_first_entry(napi_list, struct io_napi_ht_entry, list);
+		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
+			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+	}
+}
+
+static void io_napi_remove_stale(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+	struct io_napi_ht_entry *he;
+
+	hash_for_each(ctx->napi_ht, i, he, node) {
+		if (time_after(jiffies, he->timeout)) {
+			list_del(&he->list);
+			hash_del(&he->node);
+		}
+	}
+
+}
+
+static void io_napi_merge_lists(struct io_ring_ctx *ctx,
+		struct list_head *napi_list)
+{
+	spin_lock(&ctx->napi_lock);
+	list_splice(napi_list, &ctx->napi_list);
+	io_napi_remove_stale(ctx);
+	spin_unlock(&ctx->napi_lock);
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
+	unsigned int i;
+	struct io_napi_ht_entry *he;
+	LIST_HEAD(napi_list);
+
+	spin_lock(&ctx->napi_lock);
+	hash_for_each(ctx->napi_ht, i, he, node)
+		hash_del(&he->node);
+	spin_unlock(&ctx->napi_lock);
+}
+
+/*
+ * io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * @ctx: pointer to io-uring context structure
+ * @iowq: pointer to io wait queue
+ * @ts: pointer to timespec or NULL
+ *
+ * Adjust the busy loop timeout according to timespec and busy poll time=
out.
+ */
+void io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queu=
e *iowq,
+		struct timespec64 *ts)
+{
+	if (ts)
+		adjust_timeout(READ_ONCE(ctx->napi_busy_poll_to), ts,
+			&iowq->napi_busy_poll_to);
+	else
+		iowq->napi_busy_poll_to =3D READ_ONCE(ctx->napi_busy_poll_to);
+}
+
+/*
+ * io_napi_busy_loop() - execute busy poll loop
+ * @ctx: pointer to io-uring context structure
+ * @iowq: pointer to io wait queue
+ *
+ * Execute the busy poll loop and merge the spliced off list.
+ */
+void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *io=
wq)
+{
+	iowq->napi_prefer_busy_poll =3D READ_ONCE(ctx->napi_prefer_busy_poll);
+
+	/* SQPOLL is handled in sqthread. */
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		LIST_HEAD(napi_list);
+
+		spin_lock(&ctx->napi_lock);
+		list_splice_init(&ctx->napi_list, &napi_list);
+		spin_unlock(&ctx->napi_lock);
+
+		if (iowq->napi_busy_poll_to)
+			io_napi_blocking_busy_loop(&napi_list, iowq);
+
+		io_napi_merge_lists(ctx, &napi_list);
+	}
+}
+
+#endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
new file mode 100644
index 000000000000..49322a16b6e5
--- /dev/null
+++ b/io_uring/napi.h
@@ -0,0 +1,66 @@
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
+void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+		struct io_wait_queue *iowq, struct timespec64 *ts);
+void io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *io=
wq);
+
+static inline bool io_napi(struct io_ring_ctx *ctx)
+{
+	return !list_empty(&ctx->napi_list);
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

