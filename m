Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C0A4B6642
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 09:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiBOIhd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 03:37:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiBOIhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 03:37:31 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B496D21EF
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 00:37:21 -0800 (PST)
Received: from [45.44.224.220] (port=44292 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nJtKq-0001PF-1U; Tue, 15 Feb 2022 03:37:20 -0500
Message-ID: <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Tue, 15 Feb 2022 03:37:19 -0500
In-Reply-To: <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2022-02-15 at 01:13 +0800, Hao Xu wrote:
> 
> Yes, it seems that epoll_wait only does busy polling for 1 NAPI.
> 
> I think it is because the busy polling there is just an optimization
> 
> (doing some polling before trapping into sleep) not a must have,
> 
> so it's kind of trade-off between polling and reacting to other
> events
> 
> I guess. Not very sure about this too..
> 
> The iouring implementation I'm thinking of in my mind is polling for
> every
> 
> NAPI involved.
> 
Hao,

I have found the explanation about the epoll oddity:

In:
https://legacy.netdevconf.info/2.1/slides/apr6/dumazet-BUSY-POLLING-Netdev-2.1.pdf

Linux-4.12 changes
epoll() support was added by Sridhar Samudrala and Alexander Duyck,
with the assumption that an application using epoll() and busy polling
would first make sure that it would classify sockets based on their
receive queue (NAPI ID), and use at least one epoll fd per receive
queue.

SO_INCOMING_NAPI_ID was added as a new socket option to retrieve this
information, instead of relying on other mechanisms (CPU or NUMA
identifications).

I have created a small toy implementation with some limitations:
1. It assumes a single napi_id per io_uring ctx like what epoll does
2. It does not detect when pending requests using supporting sockets
are all gone.

That being said, I have not been able to make it work yet. For some
unknown reasons, no valid napi_id is extracted from the sockets added
to the context so the net_busy_poll function is never called.

I find that very strange since prior to use io_uring, my code was using
epoll and the busy polling was working fine with my application
sockets. Something is escaping my comprehension. I must tired and this
will become obvious...

In the meantime, here is what I have created so far. Feel free to play
with it and/or enhance it:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..d3deca9b9ef5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -63,6 +63,7 @@
 #include <net/sock.h>
 #include <net/af_unix.h>
 #include <net/scm.h>
+#include <net/busy_poll.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
@@ -395,6 +396,10 @@ struct io_ring_ctx {
 	struct list_head	sqd_list;
 
 	unsigned long		check_cq_overflow;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	/* used to track busy poll napi_id */
+	unsigned int napi_id;
+#endif
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -6976,7 +6981,40 @@ static inline struct file
*io_file_get_fixed(struct io_ring_ctx *ctx,
 	io_req_set_rsrc_node(req, ctx);
 	return file;
 }
+#ifdef CONFIG_NET_RX_BUSY_POLL
+/*
+ * Set epoll busy poll NAPI ID from sk.
+ */
+static inline void io_set_busy_poll_napi_id(struct io_ring_ctx *ctx,
struct file *file)
+{
+	unsigned int napi_id;
+	struct socket *sock;
+	struct sock *sk;
+
+	if (!net_busy_loop_on())
+		return;
 
+	sock = sock_from_file(file);
+	if (!sock)
+		return;
+
+	sk = sock->sk;
+	if (!sk)
+		return;
+
+	napi_id = READ_ONCE(sk->sk_napi_id);
+
+	/* Non-NAPI IDs can be rejected
+	 *	or
+	 * Nothing to do if we already have this ID
+	 */
+	if (napi_id < MIN_NAPI_ID || napi_id == ctx->napi_id)
+		return;
+
+	/* record NAPI ID for use in next busy poll */
+	ctx->napi_id = napi_id;
+}
+#endif
 static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req, int fd)
 {
@@ -6985,8 +7023,14 @@ static struct file *io_file_get_normal(struct
io_ring_ctx *ctx,
 	trace_io_uring_file_get(ctx, fd);
 
 	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
+	if (file) {
+		if (unlikely(file->f_op == &io_uring_fops))
+			io_req_track_inflight(req);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		else
+			io_set_busy_poll_napi_id(ctx, file);
+#endif
+	}
 	return file;
 }
 
@@ -7489,7 +7533,22 @@ static inline void
io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
 	spin_unlock(&ctx->completion_lock);
 }
+#ifdef CONFIG_NET_RX_BUSY_POLL
+/*
+ * Busy poll if globally on and supporting sockets found
+ */
+static inline bool io_napi_busy_loop(struct io_ring_ctx *ctx)
+{
+	unsigned int napi_id = ctx->napi_id;
 
+	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on()) {
+		napi_busy_loop(napi_id, NULL, NULL, true,
+			       BUSY_POLL_BUDGET);
+		return true;
+	}
+	return false;
+}
+#endif
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
 	unsigned int to_submit;
@@ -7518,7 +7577,10 @@ static int __io_sq_thread(struct io_ring_ctx
*ctx, bool cap_entries)
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
-
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		if (io_napi_busy_loop(ctx))
+			++ret;
+#endif
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
@@ -7649,6 +7711,9 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned busy_poll_to;
+#endif
 };
 
 static inline bool io_should_wake(struct io_wait_queue *iowq)
@@ -7709,6 +7774,29 @@ static inline int io_cqring_wait_schedule(struct
io_ring_ctx *ctx,
 	return !*timeout ? -ETIME : 1;
 }
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+static inline bool io_busy_loop_timeout(unsigned long start_time,
+					unsigned long bp_usec)
+{
+	if (bp_usec) {
+		unsigned long end_time = start_time + bp_usec;
+		unsigned long now = busy_loop_current_time();
+
+		return time_after(now, end_time);
+	}
+	return true;
+}
+
+static bool io_busy_loop_end(void *p, unsigned long start_time)
+{
+	struct io_wait_queue *iowq = p;
+
+	return io_busy_loop_timeout(start_time, iowq->busy_poll_to) ||
+	       io_run_task_work_sig() ||
+	       io_should_wake(iowq);
+}
+#endif
+
 /*
  * Wait until events become available, if we don't already have some.
The
  * application must reap them itself, as they reside on the shared cq
ring.
@@ -7729,12 +7817,33 @@ static int io_cqring_wait(struct io_ring_ctx
*ctx, int min_events,
 		if (!io_run_task_work())
 			break;
 	} while (1);
-
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	iowq.busy_poll_to = 0;
+#endif
 	if (uts) {
 		struct timespec64 ts;
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		if (!(ctx->flags & IORING_SETUP_SQPOLL) &&
+		    (ctx->napi_id >= MIN_NAPI_ID) &&
net_busy_loop_on()) {
+			unsigned busy_poll_to =
+				READ_ONCE(sysctl_net_busy_poll);
+			struct timespec64 pollto =
+				ns_to_timespec64(1000*busy_poll_to);
+
+			if (timespec64_compare(&ts, &pollto) > 0) {
+				ts = timespec64_sub(ts, pollto);
+				iowq.busy_poll_to = busy_poll_to;
+			}
+			else {
+				iowq.busy_poll_to =
timespec64_to_ns(&ts)/1000;
+				ts.tv_sec = 0;
+				ts.tv_nsec = 0;
+			}
+		}
+#endif
 		timeout = timespec64_to_jiffies(&ts);
 	}
 
@@ -7759,6 +7868,11 @@ static int io_cqring_wait(struct io_ring_ctx
*ctx, int min_events,
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 
 	trace_io_uring_cqring_wait(ctx, min_events);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	if (iowq.busy_poll_to)
+		napi_busy_loop(ctx->napi_id, io_busy_loop_end, &iowq,
true,
+			       BUSY_POLL_BUDGET);
+#endif
 	do {
 		/* if we can't even flush overflow, don't wait for
more */
 		if (!io_cqring_overflow_flush(ctx)) {

> 
