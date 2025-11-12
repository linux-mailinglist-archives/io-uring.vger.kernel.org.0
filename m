Return-Path: <io-uring+bounces-10530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6D9C50EA8
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D82664EFC83
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 07:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BAE28B7DB;
	Wed, 12 Nov 2025 07:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L1SI7N7q"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10849270ED2;
	Wed, 12 Nov 2025 07:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932175; cv=none; b=Jc1Fx20pa9Ah2i2Ujzy77/KORxeog8KoSuRvEo07s1o623xDWx1ePBCbJMaBZITXx9T2kkkK7fr8z2vf9k6TdykkbofRSv1/aVkJkLUEo4/vALC9OiAfDEpYDGXclHXltp/JNTclil2DhQU5S6ZmNubkZb+LH6XhzZKrgj+PVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932175; c=relaxed/simple;
	bh=MPy27ZwdqGMSt1zJ0eXuE2GKy2SBulCz2fXlqdEKKsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZE45kpEbu32TuxVVoLfKp6N4aztJCSklk1Cvi0YMSyKAdCpfIUZ9CdT0MplXy2gR+wKvw3HGYQ+BTMwKnnottWRW7DRwphzOI+PAXGjdwMyj6HbMLrvnQIswGSypEV6Wo82SgT1k7/tC3cpaNuHL0XXzc3J1JyjX1nwucXKOuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L1SI7N7q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dKDBVhCeN/mA2/VOlJ7BfegOY/G5wXUPPL3UsViI3aI=; b=L1SI7N7qKtPcNVCTCylY/dgEoN
	Y0K53kK5b2LWbtAtdUCOvQYPM8BviAmmGYM2+Cyv6W6ITxPp5HreuQ3Z14UVlz43GPLfQZ0M6RQXr
	5qz6VjDjIoyEhHCgct6L/p401y3yAJy0YY8hXWjNsol5mJXMySm/WXPEin8tOExcMolNNbiowx4Q4
	wXj8J4tOA/dPhmBktO0DGwSUrXxjQMXO9XH6lqsoIRwf7J9Rs8xlLx8CI8h7DxGsJ+JF1hIqvHrfY
	DR88Z85otTHaIOP+9mU5yUlOEHpYU0QRRfZa6gAp+ghQASfXwsfCdT2bN6upFkJg0n7XwqtWf+cM+
	tsga6SeQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ5Br-00000008Gno-3JOv;
	Wed, 12 Nov 2025 07:22:52 +0000
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
Date: Wed, 12 Nov 2025 08:21:29 +0100
Message-ID: <20251112072214.844816-6-hch@lst.de>
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

Replace IOMAP_DIO_INLINE_COMP with a flag to indicate that the
completion should be offloaded.  This removes a tiny bit of boilerplate
code, but more importantly just makes the code easier to follow as this
new flag gets set most of the time and only cleared in one place, while
it was the inverse for the old version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index df313232f422..80ec3ff4e5dd 100644
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
 
@@ -383,7 +384,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 		 * or extend the file size.
 		 */
 		if (!iomap_dio_is_overwrite(iomap))
-			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+			dio->flags |= IOMAP_DIO_COMP_WORK;
 	} else {
 		bio_opf |= REQ_OP_READ;
 	}
@@ -404,7 +405,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * ones we set for inline and deferred completions. If none of those
 	 * are available for this IO, clear the polled flag.
 	 */
-	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
+	if (dio->flags & IOMAP_DIO_COMP_WORK)
 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
 
 	if (need_zeroout) {
@@ -643,12 +644,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -695,7 +690,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		 * Inode size updates must to happen from process context.
 		 */
 		if (iomi.pos + iomi.len > dio->i_size)
-			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+			dio->flags |= IOMAP_DIO_COMP_WORK;
 
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
@@ -776,7 +771,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 	else if (dio->flags & IOMAP_DIO_NEED_SYNC)
-		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+		dio->flags |= IOMAP_DIO_COMP_WORK;
 
 	/*
 	 * We are about to drop our additional submission reference, which
-- 
2.47.3


