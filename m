Return-Path: <io-uring+bounces-10610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E485C59326
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B3D9421189
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDE535B139;
	Thu, 13 Nov 2025 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VLbcnjGU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6519A28BA95;
	Thu, 13 Nov 2025 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053633; cv=none; b=ixkud5CIrO3k1h5xvNNZcXJvU47BIx5QVNCrY2wR/lJKPk36eO9ROL4CJcEcdnl77mqRYietqRBdy+qoEzdubduYggg3ktr31FxCuunxnbni07/oPKEeST2A3Pf29ap+psASVCo6n4LyZy4ig3p8bTiEB7PeDFqXsAGxl4rDuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053633; c=relaxed/simple;
	bh=XWUxrM4QhaMQVwuTm2E1J/q7SXJ5ukT5GvDZrY0Fzrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTu0bsiNwT9vAyKGZTlFc8J0ObX7SE2JmbLkvv2QeWs8OfUgHf7AiPh7lllGjX3fR1o59iAycUlLSL/ipPALaPpxYIDjkXxKzYB+tPHWkRqAfA47uLh7srqPp73k3AkcIrpk/oqhqs2u0pP7jPleQKLgl/74fiBkso/hTK2Yd8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VLbcnjGU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m6VWUP8s3axJFhq6M0l9ieTJYp5C+LEaheEkCsl8LYw=; b=VLbcnjGUjfbPbZ2AntIe723J1a
	uU3TYcROuXLXuCABpsYolgz4CK8uSgJ4V8rNHsh5ujs6PNHE6SSmPeObPQggaNrg5j3j7hiUzSL0M
	iykjt2YFSLeP7IEa6a58q7TgKe8myq/rJoG0aKRdqH46JpQ7+u8oMKeMCUWb8P8e663Ezwym+IX2Q
	3DM9bCm4D0dz2f+6KIVqqQASQrhNw/DQ63nsX6jfdUGYRYhG0W84v2s0NgTw9jhO483OkwZxTl6Dy
	T0GGz/9aZiSfbaMKcOV7SwuQOkU/k8AIZz6nPY0PHLkXLQAd1pAuUqWGD1v97CldS/ZutZ/GN7Eqi
	Re+9mU9g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJams-0000000AqPS-1LJs;
	Thu, 13 Nov 2025 17:07:10 +0000
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
Subject: [PATCH 5/5] iomap: invert the polarity of IOMAP_DIO_INLINE_COMP
Date: Thu, 13 Nov 2025 18:06:30 +0100
Message-ID: <20251113170633.1453259-6-hch@lst.de>
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

Replace IOMAP_DIO_INLINE_COMP with a flag to indicate that the
completion should be offloaded.  This removes a tiny bit of boilerplate
code, but more importantly just makes the code easier to follow as this
new flag gets set most of the time and only cleared in one place, while
it was the inverse for the old version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/iomap/direct-io.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 60884c8cf8b7..00ab58d55c54 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -17,7 +17,7 @@
  * iomap.h:
  */
 #define IOMAP_DIO_NO_INVALIDATE	(1U << 26)
-#define IOMAP_DIO_INLINE_COMP	(1U << 27)
+#define IOMAP_DIO_COMP_WORK	(1U << 27)
 #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
 #define IOMAP_DIO_NEED_SYNC	(1U << 29)
 #define IOMAP_DIO_WRITE		(1U << 30)
@@ -182,7 +182,7 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	 * for error handling.
 	 */
 	if (dio->error)
-		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+		dio->flags |= IOMAP_DIO_COMP_WORK;
 
 	/*
 	 * Never invalidate pages from this context to avoid deadlocks with
@@ -192,17 +192,14 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	 * right between this check and the actual completion.
 	 */
 	if ((dio->flags & IOMAP_DIO_WRITE) &&
-	    (dio->flags & IOMAP_DIO_INLINE_COMP)) {
+	    !(dio->flags & IOMAP_DIO_COMP_WORK)) {
 		if (dio->iocb->ki_filp->f_mapping->nrpages)
-			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+			dio->flags |= IOMAP_DIO_COMP_WORK;
 		else
 			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
 	}
 
-	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
-		WRITE_ONCE(iocb->private, NULL);
-		iomap_dio_complete_work(&dio->aio.work);
-	} else {
+	if (dio->flags & IOMAP_DIO_COMP_WORK) {
 		struct inode *inode = file_inode(iocb->ki_filp);
 
 		/*
@@ -213,7 +210,11 @@ static void iomap_dio_done(struct iomap_dio *dio)
 		 */
 		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
+		return;
 	}
+
+	WRITE_ONCE(iocb->private, NULL);
+	iomap_dio_complete_work(&dio->aio.work);
 }
 
 void iomap_dio_bio_end_io(struct bio *bio)
@@ -251,7 +252,7 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
 		 * that we are already called from the ioend completion
 		 * workqueue.
 		 */
-		dio->flags |= IOMAP_DIO_INLINE_COMP;
+		dio->flags &= ~IOMAP_DIO_COMP_WORK;
 		iomap_dio_done(dio);
 	}
 
@@ -399,7 +400,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 		 * handled in __iomap_dio_rw().
 		 */
 		if (need_completion_work)
-			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+			dio->flags |= IOMAP_DIO_COMP_WORK;
 
 		bio_opf |= REQ_OP_WRITE;
 	} else {
@@ -422,7 +423,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * ones we set for inline and deferred completions. If none of those
 	 * are available for this IO, clear the polled flag.
 	 */
-	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
+	if (dio->flags & IOMAP_DIO_COMP_WORK)
 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
 
 	if (need_zeroout) {
@@ -661,12 +662,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
 		dio->flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
 
-	/*
-	 * Try to complete inline if we can.  For reads this is always possible,
-	 * but for writes we'll end up clearing this more often than not.
-	 */
-	dio->flags |= IOMAP_DIO_INLINE_COMP;
-
 	if (iov_iter_rw(iter) == READ) {
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
@@ -713,7 +708,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		 * i_size updates must to happen from process context.
 		 */
 		if (iomi.pos + iomi.len > dio->i_size)
-			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+			dio->flags |= IOMAP_DIO_COMP_WORK;
 
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
@@ -794,7 +789,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 	else if (dio->flags & IOMAP_DIO_NEED_SYNC)
-		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+		dio->flags |= IOMAP_DIO_COMP_WORK;
 
 	/*
 	 * We are about to drop our additional submission reference, which
-- 
2.47.3


