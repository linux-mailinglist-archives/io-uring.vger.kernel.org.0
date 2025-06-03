Return-Path: <io-uring+bounces-8191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF79ACC307
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 11:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3EE93A3BB6
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 09:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6D7280CE0;
	Tue,  3 Jun 2025 09:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="CaDjHJu9"
X-Original-To: io-uring@vger.kernel.org
Received: from forward201b.mail.yandex.net (forward201b.mail.yandex.net [178.154.239.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483E1F583D
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942960; cv=none; b=ZC6HYSRz35r/isrpwwgzlRB+o7sIsu+n2SymfXS+nTNTLLA0Gi0WwdONwJvp/gTe0iuWkTzlLV+IZLEFo++Q1ftr684JoArQqh7K+cBMv17pqmufOTHS/ZGWAHuLodWCKimvREYzjmgCFgmK6XlmIr14wND/hcKVlTgHK3OqHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942960; c=relaxed/simple;
	bh=r4MSoTvvvcJ4poUznnQkWS+T9m9spfzl8u7CJP/dxYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=edO+IYjBPjMgPcAJ4YqPsqLGh0QnKz4Pu8ZLHz5qqwmQhmgYa+InR+nTvJVvzxb5OVcu9JLcRl5BZQ3QNBGnVY4uEOlKNdFs1UsoVheqjXJ5twFPOJeufMKJaPqKPh7W2qRNAUEkQT7Zs2cX8vfQtJjUvebENHQSvgkEEkR3Ja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=CaDjHJu9; arc=none smtp.client-ip=178.154.239.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d103])
	by forward201b.mail.yandex.net (Yandex) with ESMTPS id C8A4E66072
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 12:23:25 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:aaac:0:640:94d6:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id E21BC60AF6;
	Tue,  3 Jun 2025 12:23:17 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id GNX0coDLdeA0-Y24eWWMd;
	Tue, 03 Jun 2025 12:23:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1748942597; bh=pSTuiAoI7oG3mDOGAKeeZ6AKTJneSBjhj5v1La1Hr28=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=CaDjHJu9I4o4jgwquy9PcHtUulVhn2Z1whqQv0hhMoQ9GGK/yxOpNEwTtSeI5GHwv
	 NYRJKa0tKK4FkQ9ezqKuqL46f0YfvAviMpfKN748ohS6TCL9kIlSx4hdpK0AtSGAMU
	 ool/eaIjTKiIx6uPCfwN+U+c3b8+rJ8Zd7fIz2t4=
Authentication-Results: mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] io_uring: miscellaneous spelling fixes
Date: Tue,  3 Jun 2025 12:20:45 +0300
Message-ID: <20250603092045.384197-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct spelling here and there as suggested by codespell.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 io_uring/cancel.c    | 4 ++--
 io_uring/io-wq.c     | 2 +-
 io_uring/io_uring.c  | 8 ++++----
 io_uring/notif.c     | 2 +-
 io_uring/poll.c      | 2 +-
 io_uring/rw.c        | 4 ++--
 io_uring/tctx.h      | 2 +-
 io_uring/uring_cmd.c | 2 +-
 io_uring/waitid.c    | 2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 6d57602304df..6d46a0ac278a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -306,8 +306,8 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	/*
-	 * Keep looking until we get -ENOENT. we'll get woken everytime
-	 * every time a request completes and will retry the cancelation.
+	 * Keep looking until we get -ENOENT. We'll get woken every
+	 * time a request completes and will retry the cancellation.
 	 */
 	do {
 		cd.seq = atomic_inc_return(&ctx->cancel_seq);
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index cd1fcb115739..70fdf174e4a1 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -605,7 +605,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		work = io_get_next_work(acct, wq);
 		if (work) {
 			/*
-			 * Make sure cancelation can find this, even before
+			 * Make sure cancellation can find this, even before
 			 * it becomes the active work. That avoids a window
 			 * where the work has been removed from our general
 			 * work list, but isn't yet discoverable as the
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c7a9cecf528e..abbb4f3dad88 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1157,7 +1157,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
+	 * We don't know how many requests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & IO_REQ_LINK_FLAGS)
@@ -2848,7 +2848,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * When @in_cancel, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 * tctx can be NULL if the queueing of this task_work raced with
-	 * work cancelation off the exec path.
+	 * work cancellation off the exec path.
 	 */
 	if (tctx && !atomic_read(&tctx->in_cancel))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
@@ -2980,7 +2980,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
 	 * if we're exiting a ton of rings at the same time. It just adds
-	 * noise and overhead, there's no discernable change in runtime
+	 * noise and overhead, there's no discernible change in runtime
 	 * over using system_wq.
 	 */
 	queue_work(iou_wq, &ctx->exit_work);
@@ -3152,7 +3152,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		if (!tctx_inflight(tctx, !cancel_all))
 			break;
 
-		/* read completions before cancelations */
+		/* read completions before cancellations */
 		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 9a6f6e92d742..93140abebd10 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -87,7 +87,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
 	prev_notif = cmd_to_io_kiocb(nd);
 
-	/* make sure all noifications can be finished in the same task_work */
+	/* make sure all notifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
 		     notif->tctx != prev_notif->tctx))
 		return -EEXIST;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0526062e2f81..dafe04dd6915 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -440,7 +440,7 @@ static bool io_poll_double_prepare(struct io_kiocb *req)
 	/*
 	 * poll arm might not hold ownership and so race for req->flags with
 	 * io_poll_wake(). There is only one poll entry queued, serialise with
-	 * it by taking its head lock. As we're still arming the tw hanlder
+	 * it by taking its head lock. As we're still arming the tw handler
 	 * is not going to be run, so there are no races with it.
 	 */
 	if (head) {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 710d8cd53ebb..e7e30af269a9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -186,7 +186,7 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 * This is really a bug in the core code that does this, any issue
 	 * path should assume that a successful (or -EIOCBQUEUED) return can
 	 * mean that the underlying data can be gone at any time. But that
-	 * should be fixed seperately, and then this check could be killed.
+	 * should be fixed separately, and then this check could be killed.
 	 */
 	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -347,7 +347,7 @@ static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	/*
 	 * Have to do this validation here, as this is in io_read() rw->len
-	 * might have chanaged due to buffer selection
+	 * might have changed due to buffer selection
 	 */
 	return io_iov_buffer_select_prep(req);
 }
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 608e96de70a2..1c10a3a1a00e 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -20,7 +20,7 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 			 unsigned nr_args);
 
 /*
- * Note that this task has used io_uring. We use it for cancelation purposes.
+ * Note that this task has used io_uring. We use it for cancellation purposes.
  */
 static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 929cad6ee326..40e35e8f8821 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -126,7 +126,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
 	if (io_should_terminate_tw())
 		flags |= IO_URING_F_TASK_DEAD;
 
-	/* task_work executor checks the deffered list completion */
+	/* task_work executor checks the deferred list completion */
 	ioucmd->task_work_cb(ioucmd, flags);
 }
 
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index e07a94694397..149439fdfcac 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -282,7 +282,7 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	atomic_set(&iw->refs, 1);
 
 	/*
-	 * Cancel must hold the ctx lock, so there's no risk of cancelation
+	 * Cancel must hold the ctx lock, so there's no risk of cancellation
 	 * finding us until a) we remain on the list, and b) the lock is
 	 * dropped. We only need to worry about racing with the wakeup
 	 * callback.
-- 
2.49.0


