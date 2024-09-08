Return-Path: <io-uring+bounces-3089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7395970912
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 19:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AF171F2151C
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 17:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E53175D46;
	Sun,  8 Sep 2024 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=c-pestka.de header.i=@c-pestka.de header.b="Z/Jysm73";
	dkim=permerror (0-bit key) header.d=c-pestka.de header.i=@c-pestka.de header.b="XaF/lOYQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EF31741F8;
	Sun,  8 Sep 2024 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.221
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725817219; cv=pass; b=KKaZzie3UQEsI32naDcyNGlVkPl+KCMoPHVO+OIYJSh1CoQhHptKplS1/K8gHjVYw+RenWy4RcOO9uBWi2elqeHoqkeKvQ/t0uUMqb1lF59ztFes4QXSBdvVLiOMreQd0roVZwx/cuHJ04H8hnFRUBh8vJJfFwEOqLEEs6pgAWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725817219; c=relaxed/simple;
	bh=D6+Xt05mKgW9VIpF13ieIKUQH+0/o70Le7eZMj+QWR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MIWxnTa5WP1PPgpqBcNf/JG9t5njlaMBWF6w+dOQyuTucUrTgAxKDLwYvAp0SmAhzrKrCmbUZ3PBLphID0hsre+bi7R3muWtk4msZsaCMn4Mt8sKp3srdDImq10WhKg9P1GNejKUZH2SNMuKynhFfj+t5qnQUpgArY4BP5xta70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c-pestka.de; spf=none smtp.mailfrom=c-pestka.de; dkim=pass (2048-bit key) header.d=c-pestka.de header.i=@c-pestka.de header.b=Z/Jysm73; dkim=permerror (0-bit key) header.d=c-pestka.de header.i=@c-pestka.de header.b=XaF/lOYQ; arc=pass smtp.client-ip=81.169.146.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c-pestka.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=c-pestka.de
ARC-Seal: i=1; a=rsa-sha256; t=1725814205; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=a9c5ahdHRqIgVmTrX89XBjFW1ggWp1eMzKRa/MJsQffqs3Qt0aFUOLNeA24lI8pU1+
    38ee9+jFqoQPqpg77fX+4sgddsfyOmD78f09QLCvU1oxKgO4R9gXKpkxWt1pPa6j7uOZ
    yasopUifGQkOeqtHr2d+1VFNdBrBWgYcbgJvBHy7yx1yn8HWQM3uoQCLqxrsroS3A/zg
    Rqko0zFidipomCuFUls4h2z89vlMNfwH2Z5zBGf8j+huWHMwQQiqeKCSRuG0AhgNEUWz
    ZxymeyVESEkAlaj7g5oMfRPdAp8GRlmyk4lwByhEq6n6l45nUtwYcTABhdBsxVxVu/nD
    W3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1725814205;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=dOd96coyOjgjOOeKj0OXf5THYVEwQQ4N2Zp/6b9P0Wo=;
    b=ouiPubx74uo5byJ8PgTUYzgLRzrF/rEp4pTMtwJXWqApjZFm3OIftZ1MntKGZiP4JL
    JDKYt4OFTjyaY1BFo5zV3ONGWS98YZ5z3oCEsKQdp5wgBt1jSLrrXmvhZf4oiG77AhRe
    w8Pav8LCyILi4QSFIcQhjwq7cX6joZaQwACDFSfqbFMF6AcSJ0amqgbBBnHFZlrEmIuE
    8Jja69jeUXX3Yt+O86v3g7cIjhGKDwsSWSiSwSxeT8gXBl4kZHK/9rlDKtogSUQFRWRm
    qSXZiUzneCEM33lAOk9qDBVObDw8/lNH2K3iEAvf0abL1ggPnLmOAJBl1MTYHOG+YazU
    5CYg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1725814205;
    s=strato-dkim-0002; d=c-pestka.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=dOd96coyOjgjOOeKj0OXf5THYVEwQQ4N2Zp/6b9P0Wo=;
    b=Z/Jysm73Sr7oJzWjALXShi3EUHK45NJYcacSUWY+6kYJnZHpvH+1B6NpX0aniopax+
    LI25G1HDkqgv8yVARKTqQpSlapdJjWAF96u0Q6WY4hDdRx9fi7sg4myTD+OM8dUDLQU2
    MlX/sp/RRsoeIgjPL0VOkE4kRqYDYvZBxFzmVCdNFJe0s1nPUrhh6tEIVl8RSgMG1UPu
    hDO5TeTisD6b8W2FB5SJ0YM0QnYkw+AmeJq09Agl6Msp5NEhj143Wr+xnDJKpmRjxidb
    7sTHCTWhmXHElMfyczNGiLQEm8U0OzSSXYb1kyvRnmA3edZ9bCssN6gAf2g7u2m/ChvT
    vcBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1725814205;
    s=strato-dkim-0003; d=c-pestka.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=dOd96coyOjgjOOeKj0OXf5THYVEwQQ4N2Zp/6b9P0Wo=;
    b=XaF/lOYQ2psUX5x3js9U3ijQKdJTfvL+ZFDL2DSLHIctRIs3/R5mR2foVtZT808t69
    K18nclTaBV3sOtQmFcCA==
X-RZG-AUTH: ":L2MKZlSpdet8FP+8D8Y/EFgj3PDuHqiU+J2UvJ91fMU85+sWFzCdeIxJCqi9QKnfTxPU18j3ONv7H6kamhT49+xdFd5PhUVwIAmVdhyEU1q+1io="
Received: from cpestka-main-ubunt.fritz.box
    by smtp.strato.de (RZmta 51.2.3 AUTH)
    with ESMTPSA id I9634d088Go5Fud
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 8 Sep 2024 18:50:05 +0200 (CEST)
From: CPestka <constantin.pestka@c-pestka.de>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	CPestka <constantin.pestka@c-pestka.de>
Subject: [PATCH] block and io_uring: typo fixes
Date: Sun,  8 Sep 2024 18:47:23 +0200
Message-ID: <20240908164723.36468-1-constantin.pestka@c-pestka.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

Signed-off-by: Constantin Pestka <constantin.pestka@c-pestka.de>
---
 block/Kconfig.iosched         | 2 +-
 block/genhd.c                 | 8 ++++----
 include/uapi/linux/io_uring.h | 6 +++---
 io_uring/io_uring.c           | 8 ++++----
 io_uring/uring_cmd.c          | 4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 27f11320b8d1..1ecd19f9506b 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -20,7 +20,7 @@ config IOSCHED_BFQ
 	tristate "BFQ I/O scheduler"
 	select BLK_ICQ
 	help
-	BFQ I/O scheduler for BLK-MQ. BFQ distributes the bandwidth of
+	BFQ I/O scheduler for BLK-MQ. BFQ distributes the bandwidth
 	of the device among all processes according to their weights,
 	regardless of the device parameters and with any workload. It
 	also guarantees a low latency to interactive and soft
diff --git a/block/genhd.c b/block/genhd.c
index 1c05dd4c6980..8c93fb977a59 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -352,7 +352,7 @@ int disk_scan_partitions(struct gendisk *disk, blk_mode_t mode)
 
 	/*
 	 * If the device is opened exclusively by current thread already, it's
-	 * safe to scan partitons, otherwise, use bd_prepare_to_claim() to
+	 * safe to scan partitions, otherwise, use bd_prepare_to_claim() to
 	 * synchronize with other exclusive openers and other partition
 	 * scanners.
 	 */
@@ -374,7 +374,7 @@ int disk_scan_partitions(struct gendisk *disk, blk_mode_t mode)
 	/*
 	 * If blkdev_get_by_dev() failed early, GD_NEED_PART_SCAN is still set,
 	 * and this will cause that re-assemble partitioned raid device will
-	 * creat partition for underlying disk.
+	 * create partition for underlying disk.
 	 */
 	clear_bit(GD_NEED_PART_SCAN, &disk->state);
 	if (!(mode & BLK_OPEN_EXCL))
@@ -607,7 +607,7 @@ static void __blk_mark_disk_dead(struct gendisk *disk)
  * blk_mark_disk_dead - mark a disk as dead
  * @disk: disk to mark as dead
  *
- * Mark as disk as dead (e.g. surprise removed) and don't accept any new I/O
+ * Mark a disk as dead (e.g. surprise removed) and don't accept any new I/O
  * to this disk.
  */
 void blk_mark_disk_dead(struct gendisk *disk)
@@ -732,7 +732,7 @@ EXPORT_SYMBOL(del_gendisk);
  * invalidate_disk - invalidate the disk
  * @disk: the struct gendisk to invalidate
  *
- * A helper to invalidates the disk. It will clean the disk's associated
+ * A helper to invalidate the disk. It will clean the disk's associated
  * buffer/page caches and reset its internal states so that the disk
  * can be reused by the drivers.
  *
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a275f91d2ac0..69cbdb1df9d4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -318,7 +318,7 @@ enum io_uring_op {
  * ASYNC_CANCEL flags.
  *
  * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
- * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
+ * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancellation rather than the
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
@@ -361,7 +361,7 @@ enum io_uring_op {
  *				result 	will be the number of buffers send, with
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
- *				will be	contigious from the starting buffer ID.
+ *				will be	contiguous from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -594,7 +594,7 @@ enum io_uring_register_op {
 	IORING_REGISTER_PBUF_RING		= 22,
 	IORING_UNREGISTER_PBUF_RING		= 23,
 
-	/* sync cancelation API */
+	/* sync cancellation API */
 	IORING_REGISTER_SYNC_CANCEL		= 24,
 
 	/* register a range of fixed file slots for automatic slot allocation */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1aca501efaf6..41e5f00d7f01 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1137,7 +1137,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
+	 * We don't know how many requests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
@@ -1177,7 +1177,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	 * in set_current_state() on the io_cqring_wait() side. It's used
 	 * to ensure that either we see updated ->cq_wait_nr, or waiters
 	 * going to sleep will observe the work added to the list, which
-	 * is similar to the wait/wawke task state sync.
+	 * is similar to the wait/wake task state sync.
 	 */
 
 	if (!head) {
@@ -2842,7 +2842,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * When @in_cancel, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 * tctx can be NULL if the queueing of this task_work raced with
-	 * work cancelation off the exec path.
+	 * work cancellation off the exec path.
 	 */
 	if (tctx && !atomic_read(&tctx->in_cancel))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
@@ -3141,7 +3141,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		if (!tctx_inflight(tctx, !cancel_all))
 			break;
 
-		/* read completions before cancelations */
+		/* read completions before cancellations */
 		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8391c7c7c1ec..b89623012d52 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -93,7 +93,7 @@ static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
 }
 
 /*
- * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
+ * Mark this command as cancellable, then io_uring_try_cancel_uring_cmd()
  * will try to cancel this issued command by sending ->uring_cmd() with
  * issue_flags of IO_URING_F_CANCEL.
  *
@@ -120,7 +120,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	/* task_work executor checks the deffered list completion */
+	/* task_work executor checks the deferred list completion */
 	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
 }
 
-- 
2.43.0


