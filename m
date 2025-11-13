Return-Path: <io-uring+bounces-10609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D72AC591DC
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A2A25010A3
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8271EDA2B;
	Thu, 13 Nov 2025 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hExweOWu"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A135B139;
	Thu, 13 Nov 2025 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053627; cv=none; b=rXAfgP/w3EPO+L1N+lrecC+Dgx/uVCbGp/5q9IjAPtCEEhPOKDCxSvWuqcTXEWxjNoDV52GQ5RRMToksZAphOJTdtHMx8VvA4mrW7lRzR+TlChEn7vnDGD3C3VaORtp/1he8a9z9nu2lAW2vjGpZNLMOUZYC1ECODxFvXxu0mSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053627; c=relaxed/simple;
	bh=3Pn51qn1zETuorxW3Yy/gat63VcaJe6UFcZT02sjlSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8PdIo/lhnseQZmQeyk9B9v1XV99pvQ/Zh86hPJ+PPuizMq4R1n9AJLsRvlvgqp+0gF4XjF/IbQ3mOtn2G1XAT/ldYUaONBEQrrTyfC51GdTTLVqq9T6PBZlA3XycDZFE/vxOO2p8j9vyyYDmZ7xX0krC33cxqMryN++8pa3i48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hExweOWu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JIlroqApWboqs3ssizIL6VLKvIu7rZ4sxhT4ESiRR5Y=; b=hExweOWuUKvuTmlMpYVn7dE7z7
	drpvE8f9BKOdFPOdOwcJ/RhWeJePYPxoBObFy/5L3tUWZ8VH4ZguWOE64oUJsY9EOuU9BfT5xEt84
	cZG0W5uu2jAmto4AbWv/63jJPIZmNhvgG4gQ8va4BJBjlg3+SqF4OXXZ+UiCWZl3CDxvF9tCkaHD0
	U0s4t+hH4Daz5x11vCEKDtrFwvGjFmjgtWoVHNFHcm+uzkT1IEavNtoK7BmvFN5mjLcmVDd0kaR/R
	OFOvA7B8lNGV29XM2Bc06XgmOQRF1nhiGiX2XTReFysuXNgorzD/oCubIu10YNBF0pvlbns1i5vES
	Ww/xkLSg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJaml-0000000AqOY-3YK2;
	Thu, 13 Nov 2025 17:07:04 +0000
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
Date: Thu, 13 Nov 2025 18:06:29 +0100
Message-ID: <20251113170633.1453259-5-hch@lst.de>
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
 fs/iomap/direct-io.c | 59 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fb2d83f640ef..60884c8cf8b7 100644
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
 
@@ -378,6 +387,20 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 			else
 				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
 		}
+
+		/*
+		 * We can only do inline completion for pure overwrites that
+		 * don't require additional I/O at completion time.
+		 *
+		 * This rules out writes that need zeroing or metdata updates to
+		 * convert unwritten or shared extents.
+		 *
+		 * Writes that extend i_size are also not supported, but this is
+		 * handled in __iomap_dio_rw().
+		 */
+		if (need_completion_work)
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
 		bio_opf |= REQ_OP_WRITE;
 	} else {
 		bio_opf |= REQ_OP_READ;
@@ -638,10 +661,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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
 
@@ -683,6 +709,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
 		}
 
+		/*
+		 * i_size updates must to happen from process context.
+		 */
+		if (iomi.pos + iomi.len > dio->i_size)
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
 		 * If this invalidation fails, let the caller fall back to
@@ -755,9 +787,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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


