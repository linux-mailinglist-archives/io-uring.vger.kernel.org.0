Return-Path: <io-uring+bounces-10606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C6BBEC59182
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 58B1C35F13D
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222513587C5;
	Thu, 13 Nov 2025 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jRoVVd0I"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23603587CD;
	Thu, 13 Nov 2025 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053609; cv=none; b=sblJfARj9yWdDsH1HHJhz3fgpiXvEsNcSrL/8qcIw7n6mZ214wmJvEI11S/19s+bvJEi/uIq1MQ6jW17ZBsO3zzs9295VcEbywL5ktVGqG7Q6m4zJi7fQRaI+1zvZNkVrM7P3bAQnLnzSPDrtto4dTBZOZfp0+W1HfhUIRtVVxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053609; c=relaxed/simple;
	bh=ZNRSelug7NJXNmeFQIY1rscGejTekYAZUxz3hUMEjqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1XplEksc2LMS2pIIUk8NmVTS+PssM9aXyQ2QlMLFpVQIkF/RjqFjfUYtst1UbbfA5PwjHzoQArrrIgcXjvcz4KW5HDNhxNjOMDwHqWRT9Y4peGOq3Rm1b96qEh3WEJavp3Ka1RPlhswOw6cJu6Wu+Vei+WTmpVpT9B8z6AjY4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jRoVVd0I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VryVtp6qfr3fyRALHbl2CHjb53WFI1V9lkgkNi34uTU=; b=jRoVVd0IfqtbqpXstFmD8d89w3
	5wWMUbVgtFKmae08gxvoNZEPrQwbK6FuqtfRW51V+wZ2NsPPvGuGYQWAV31kgZDSWtKZ2vvdnjdl8
	JhdwgF8eHegSBkB+yKUp83CmY5tFbJckxUTeK7QqRf9SDIEO2v4D8esVHh5zu3uT1OA2rJLMpZ12K
	ITYd072rqmlMo9cbf8+8TIlfTZMUS7WTvMs8g6tYS44+F1JtzJhv1P3FyJe5uINuANRAB1ygZodr1
	Z3kTcnsy+8eqQrFwM20cm44q/g4b4cC5xb+UUu/pvVsMa8zg/NuK1Tjb5/1WWDRXr6J6Dn3svsKay
	fxrMpcbA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJamS-0000000AqN6-1edG;
	Thu, 13 Nov 2025 17:06:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
Date: Thu, 13 Nov 2025 18:06:26 +0100
Message-ID: <20251113170633.1453259-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170633.1453259-1-hch@lst.de>
References: <20251113170633.1453259-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This was added by commit 099ada2c8726 ("io_uring/rw: add write support
for IOCB_DIO_CALLER_COMP") and disabled a little later by commit
838b35bb6a89 ("io_uring/rw: disable IOCB_DIO_CALLER_COMP") because it
didn't work.  Remove all the related code that sat unused for 2 years.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 .../filesystems/iomap/operations.rst          |  4 --
 fs/backing-file.c                             |  6 --
 fs/iomap/direct-io.c                          | 56 +------------------
 include/linux/fs.h                            | 43 +++-----------
 io_uring/rw.c                                 | 16 +-----
 5 files changed, 13 insertions(+), 112 deletions(-)

diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index c88205132039..5558a44891bb 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -488,10 +488,6 @@ These ``struct kiocb`` flags are significant for direct I/O with iomap:
    Only meaningful for asynchronous I/O, and only if the entire I/O can
    be issued as a single ``struct bio``.
 
- * ``IOCB_DIO_CALLER_COMP``: Try to run I/O completion from the caller's
-   process context.
-   See ``linux/fs.h`` for more details.
-
 Filesystems should call ``iomap_dio_rw`` from ``->read_iter`` and
 ``->write_iter``, and set ``FMODE_CAN_ODIRECT`` in the ``->open``
 function for the file.
diff --git a/fs/backing-file.c b/fs/backing-file.c
index 15a7f8031084..2a86bb6fcd13 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -227,12 +227,6 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 	    !(file->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * Stacked filesystems don't support deferred completions, don't copy
-	 * this property in case it is set by the issuer.
-	 */
-	flags &= ~IOCB_DIO_CALLER_COMP;
-
 	old_cred = override_creds(ctx->cred);
 	if (is_sync_kiocb(iocb)) {
 		rwf_t rwf = iocb_to_rw_flags(flags);
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b2f9fb89eb3..7659db85083a 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -16,8 +16,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_NO_INVALIDATE	(1U << 25)
-#define IOMAP_DIO_CALLER_COMP	(1U << 26)
+#define IOMAP_DIO_NO_INVALIDATE	(1U << 26)
 #define IOMAP_DIO_INLINE_COMP	(1U << 27)
 #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
 #define IOMAP_DIO_NEED_SYNC	(1U << 29)
@@ -140,11 +139,6 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_complete);
 
-static ssize_t iomap_dio_deferred_complete(void *data)
-{
-	return iomap_dio_complete(data);
-}
-
 static void iomap_dio_complete_work(struct work_struct *work)
 {
 	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
@@ -182,29 +176,6 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
-	} else if (dio->flags & IOMAP_DIO_CALLER_COMP) {
-		/*
-		 * If this dio is flagged with IOMAP_DIO_CALLER_COMP, then
-		 * schedule our completion that way to avoid an async punt to a
-		 * workqueue.
-		 */
-		/* only polled IO cares about private cleared */
-		iocb->private = dio;
-		iocb->dio_complete = iomap_dio_deferred_complete;
-
-		/*
-		 * Invoke ->ki_complete() directly. We've assigned our
-		 * dio_complete callback handler, and since the issuer set
-		 * IOCB_DIO_CALLER_COMP, we know their ki_complete handler will
-		 * notice ->dio_complete being set and will defer calling that
-		 * handler until it can be done from a safe task context.
-		 *
-		 * Note that the 'res' being passed in here is not important
-		 * for this case. The actual completion value of the request
-		 * will be gotten from dio_complete when that is run by the
-		 * issuer.
-		 */
-		iocb->ki_complete(iocb, 0);
 	} else {
 		struct inode *inode = file_inode(iocb->ki_filp);
 
@@ -261,7 +232,6 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
 			dio->flags |= IOMAP_DIO_INLINE_COMP;
 			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
 		}
-		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
 		iomap_dio_done(dio);
 	}
 
@@ -380,19 +350,6 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 		if (!(bio_opf & REQ_FUA))
 			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
-
-		/*
-		 * We can only do deferred completion for pure overwrites that
-		 * don't require additional I/O at completion time.
-		 *
-		 * This rules out writes that need zeroing or extent conversion,
-		 * extend the file size, or issue metadata I/O or cache flushes
-		 * during completion processing.
-		 */
-		if (need_zeroout || (pos >= i_size_read(inode)) ||
-		    ((dio->flags & IOMAP_DIO_NEED_SYNC) &&
-		     !(bio_opf & REQ_FUA)))
-			dio->flags &= ~IOMAP_DIO_CALLER_COMP;
 	} else {
 		bio_opf |= REQ_OP_READ;
 	}
@@ -413,7 +370,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * ones we set for inline and deferred completions. If none of those
 	 * are available for this IO, clear the polled flag.
 	 */
-	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
+	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
 
 	if (need_zeroout) {
@@ -669,15 +626,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
-		/*
-		 * Flag as supporting deferred completions, if the issuer
-		 * groks it. This can avoid a workqueue punt for writes.
-		 * We may later clear this flag if we need to do other IO
-		 * as part of this IO completion.
-		 */
-		if (iocb->ki_flags & IOCB_DIO_CALLER_COMP)
-			dio->flags |= IOMAP_DIO_CALLER_COMP;
-
 		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
 			ret = -EAGAIN;
 			if (iomi.pos >= dio->i_size ||
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..e210d2d8af53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -367,23 +367,9 @@ struct readahead_control;
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
-/*
- * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
- * iocb completion can be passed back to the owner for execution from a safe
- * context rather than needing to be punted through a workqueue. If this
- * flag is set, the bio completion handling may set iocb->dio_complete to a
- * handler function and iocb->private to context information for that handler.
- * The issuer should call the handler with that context information from task
- * context to complete the processing of the iocb. Note that while this
- * provides a task context for the dio_complete() callback, it should only be
- * used on the completion side for non-IO generating completions. It's fine to
- * call blocking functions from this callback, but they should not wait for
- * unrelated IO (like cache flushing, new IO generation, etc).
- */
-#define IOCB_DIO_CALLER_COMP	(1 << 22)
 /* kiocb is a read or write operation submitted by fs/aio.c. */
-#define IOCB_AIO_RW		(1 << 23)
-#define IOCB_HAS_METADATA	(1 << 24)
+#define IOCB_AIO_RW		(1 << 22)
+#define IOCB_HAS_METADATA	(1 << 23)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -400,7 +386,6 @@ struct readahead_control;
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
 	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
-	{ IOCB_DIO_CALLER_COMP,	"CALLER_COMP" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
 	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
 
@@ -412,23 +397,13 @@ struct kiocb {
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	u8			ki_write_stream;
-	union {
-		/*
-		 * Only used for async buffered reads, where it denotes the
-		 * page waitqueue associated with completing the read. Valid
-		 * IFF IOCB_WAITQ is set.
-		 */
-		struct wait_page_queue	*ki_waitq;
-		/*
-		 * Can be used for O_DIRECT IO, where the completion handling
-		 * is punted back to the issuer of the IO. May only be set
-		 * if IOCB_DIO_CALLER_COMP is set by the issuer, and the issuer
-		 * must then check for presence of this handler when ki_complete
-		 * is invoked. The data passed in to this handler must be
-		 * assigned to ->private when dio_complete is assigned.
-		 */
-		ssize_t (*dio_complete)(void *data);
-	};
+
+	/*
+	 * Only used for async buffered reads, where it denotes the page
+	 * waitqueue associated with completing the read.
+	 * Valid IFF IOCB_WAITQ is set.
+	 */
+	struct wait_page_queue	*ki_waitq;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 08882648d569..4d0ab8f50d14 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -277,7 +277,6 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	} else {
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
-	rw->kiocb.dio_complete = NULL;
 	rw->kiocb.ki_flags = 0;
 	rw->kiocb.ki_write_stream = READ_ONCE(sqe->write_stream);
 
@@ -566,15 +565,6 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	struct kiocb *kiocb = &rw->kiocb;
-
-	if ((kiocb->ki_flags & IOCB_DIO_CALLER_COMP) && kiocb->dio_complete) {
-		long res = kiocb->dio_complete(rw->kiocb.private);
-
-		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
-	}
-
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
@@ -589,10 +579,8 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
-	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
-		__io_complete_rw_common(req, res);
-		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
-	}
+	__io_complete_rw_common(req, res);
+	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;
 	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
-- 
2.47.3


