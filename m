Return-Path: <io-uring+bounces-10529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D74C50ED8
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12CE93B29C6
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 07:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CCA2C0F65;
	Wed, 12 Nov 2025 07:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T9aE2Dpj"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDABB2C0F7C;
	Wed, 12 Nov 2025 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932167; cv=none; b=p9w1+p/NdVthgl4KD0kKfBCtMpFurdSzKUCzV9AyVX9w6HuC9Y+Y4xfsi6PfMFRIRtxqszsnOG7leKlYTCLozMO0tuwKgNtFGjBwqrEQm+Lrwtd6a44Qdo87As6MWQHGREuY3nEAqxJ6kO3t0Vz7VVD5N/mjynhdfR/LG9gO5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932167; c=relaxed/simple;
	bh=GEv91kwZsiIUbXPFNGB2nIhKPsP25YDE55A74zM0wb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGs6kCvZbTGFkEfVrmB0QtpoArsVTPG2PZWIC7y2sLpgFZIVNhDzhrf9N3xdL+ZNx0poyzD7FSE5GXRUDAne/Rikrw+JCbmwtZv5dFADOjHXvL2o3qn3e28ClGkvGEskHewM8aa/0rb8zUXW7xcu0XN0uz8a3ExDmUX15bTUT58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T9aE2Dpj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uDOVqOaoK0l5CAXYaJrUbWspQEa+T1CHea266wvFc+U=; b=T9aE2DpjmgGNoilC79yaS8mqJQ
	0zgWapG6vk6Q3SoKW18JDEzWR01NKz6zzfbHwekTxmIQ+jeIytu/Xpe0C7INXqDHjImRhCDnvZEe/
	idBto+gF55kabECUbWfJLVhImvzHvrwfZkpyEJCWEQ3PnySo3zSGIFlK0O+8cn+t64kBTx3XMuxyR
	rxQ8XtMJ2wdNKqWmevz/K381M/7S1VtUlvSAB3dbXwQ3dIpYL/wxre/t3QOxvlub5vEEI0wITtC/A
	1Wij0NxB0vw/O3bvNbGQDQe/jWLdUpkbfNMwapnKxMmxhMr+rf+H5EzxIlZnitTrkEsxMzj36vz3l
	rd6ktxKQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ5Bj-00000008Gld-35c7;
	Wed, 12 Nov 2025 07:22:44 +0000
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
	io-uring@vger.kernel.org
Subject: [PATCH 4/5] iomap: support write completions from interrupt context
Date: Wed, 12 Nov 2025 08:21:28 +0100
Message-ID: <20251112072214.844816-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112072214.844816-1-hch@lst.de>
References: <20251112072214.844816-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Completions for pure overwrites don't need to be deferred to a workqueue
as there is no work to be done, or at least no work that needs a user
context.  Set the IOMAP_DIO_INLINE_COMP by default for writes like we
already do for reads, and the clear it for all the cases that actually
do need a user context for completions to update the inode size or
record updates to the logical to physical mapping.

I've audited all users of the ->end_io callback, and they only require
user context for I/O that involves unwritten extents, COW, size
extensions, or error handling and all those are still run from workqueue
context.

This restores the behavior of the old pre-iomap direct I/O code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 55 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c4a883fa8ea5..df313232f422 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -184,6 +184,21 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	if (dio->error)
 		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
 
+	/*
+	 * Never invalidate pages from this context to avoid deadlocks with
+	 * buffered I/O completions when called from the ioend workqueue,
+	 * or avoid sleeping when called directly from ->bi_end_io.
+	 * Tough luck if you hit the tiny race with someone dirtying the range
+	 * right between this check and the actual completion.
+	 */
+	if ((dio->flags & IOMAP_DIO_WRITE) &&
+	    (dio->flags & IOMAP_DIO_INLINE_COMP)) {
+		if (dio->iocb->ki_filp->f_mapping->nrpages)
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+		else
+			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
+	}
+
 	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
@@ -234,15 +249,9 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
 		/*
 		 * Try to avoid another context switch for the completion given
 		 * that we are already called from the ioend completion
-		 * workqueue, but never invalidate pages from this thread to
-		 * avoid deadlocks with buffered I/O completions.  Tough luck if
-		 * you hit the tiny race with someone dirtying the range now
-		 * between this check and the actual completion.
+		 * workqueue.
 		 */
-		if (!dio->iocb->ki_filp->f_mapping->nrpages) {
-			dio->flags |= IOMAP_DIO_INLINE_COMP;
-			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
-		}
+		dio->flags |= IOMAP_DIO_INLINE_COMP;
 		iomap_dio_done(dio);
 	}
 
@@ -365,6 +374,16 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 			else
 				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
 		}
+
+		/*
+		 * We can only do inline completion for pure overwrites that
+		 * don't require additional I/O at completion time.
+		 *
+		 * This rules out writes that need zeroing or extent conversion,
+		 * or extend the file size.
+		 */
+		if (!iomap_dio_is_overwrite(iomap))
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
 	} else {
 		bio_opf |= REQ_OP_READ;
 	}
@@ -624,10 +643,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
 		dio->flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
 
-	if (iov_iter_rw(iter) == READ) {
-		/* reads can always complete inline */
-		dio->flags |= IOMAP_DIO_INLINE_COMP;
+	/*
+	 * Try to complete inline if we can.  For reads this is always possible,
+	 * but for writes we'll end up clearing this more often than not.
+	 */
+	dio->flags |= IOMAP_DIO_INLINE_COMP;
 
+	if (iov_iter_rw(iter) == READ) {
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
@@ -669,6 +691,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
 		}
 
+		/*
+		 * Inode size updates must to happen from process context.
+		 */
+		if (iomi.pos + iomi.len > dio->i_size)
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
 		 * If this invalidation fails, let the caller fall back to
@@ -741,9 +769,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	 * If all the writes we issued were already written through to the
 	 * media, we don't need to flush the cache on IO completion. Clear the
 	 * sync flag for this case.
+	 *
+	 * Otherwise clear the inline completion flag if any sync work is
+	 * needed, as that needs to be performed from process context.
 	 */
 	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
+	else if (dio->flags & IOMAP_DIO_NEED_SYNC)
+		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
 
 	/*
 	 * We are about to drop our additional submission reference, which
-- 
2.47.3


