Return-Path: <io-uring+bounces-10608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF72C59683
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 19:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E62894F74C5
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F8A3587CD;
	Thu, 13 Nov 2025 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JauCib0y"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E6C1DE8BE;
	Thu, 13 Nov 2025 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053622; cv=none; b=OAcZDo0mCSgco1Thbb/Tn8EvOKJwZVaKvtsZ8uQFlynDC7hhzxjmg2cLWV9aQ60mcJEv+0IfFFJlcz1fkEAm40HDVmX9C4JloAZhLbcwLC8RyGttHrLlm/+N5JDueGodtzcMv/Vr/InKYl20mpfEKyx2+NN5AJR4W0gijeJg3Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053622; c=relaxed/simple;
	bh=GW3YPidwD6qg+u6IuzTJky9hYP6nNPoy/uWvpfQcYKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igb++wpXLudU1JfwgHzhdEU+hw5bY1L03k3hYYbofoB+5cg6p+O3s67jKpVGioCm4mp/VaTVlnK53RpTW6Rv9HEH+JxMqkDlbIoFPJdSWQJwbHN+pPZlbTFTmbO/XZqSAcuNZq9HkekBH0XJ51qTX2zEu+wxSu3m4mgaNMkb4Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JauCib0y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6TsBEv2n3Fj7SFYAZNEUokcn15+RWybIbyntX0gHd+E=; b=JauCib0y6wD+pg8+X9byNkmNuV
	bAuCtMaep1zSa/4EqM8FsLDM5zqiaL5E6+SWn8u7qRdtH/VKh8vf8LMxP3ndmWVQlZhbu9DJSm7Z8
	QvRBhBRVR3xIKOoW4mBjIWjU8C2VYWYKUPfTkj+FaY88aUvQQuDalvi/XRBDQemZNvs7iRRHicBdQ
	ViAM4nttY6BL+5ccU8BroEkkdm4M9M/OJtBMQh6S8vdbftpNOG4VLCGM2x5qmjPFhE5D6eCC5UcXA
	q+qeUAJXgXt/ZAPshh59o8LlkQD6tisINOdQggqZ9djHPBMIySUtU0eEFvfcYf2/EWPRhMjFrnB1w
	Egn65MbA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJamg-0000000AqOI-0tiY;
	Thu, 13 Nov 2025 17:06:58 +0000
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
Subject: [PATCH 3/5] iomap: rework REQ_FUA selection
Date: Thu, 13 Nov 2025 18:06:28 +0100
Message-ID: <20251113170633.1453259-4-hch@lst.de>
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

The way how iomap_dio_can_use_fua and the caller is structured is
a bit confusing, as the main guarding condition is hidden in the
helper, and the secondary conditions are split between caller and
callee.

Refactor the code, so that iomap_dio_bio_iter itself tracks if a write
might need metadata updates based on the iomap type and flags, and
then have a condition based on that to use the FUA flag.

Note that this also moves the REQ_OP_WRITE assignment to the end of
the branch to improve readability a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 78 +++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 765ab6dd6637..fb2d83f640ef 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -287,23 +287,6 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 	return 0;
 }
 
-/*
- * Use a FUA write if we need datasync semantics and this is a pure data I/O
- * that doesn't require any metadata updates (including after I/O completion
- * such as unwritten extent conversion) and the underlying device either
- * doesn't have a volatile write cache or supports FUA.
- * This allows us to avoid cache flushes on I/O completion.
- */
-static inline bool iomap_dio_can_use_fua(const struct iomap *iomap,
-		struct iomap_dio *dio)
-{
-	if (iomap->flags & (IOMAP_F_SHARED | IOMAP_F_DIRTY))
-		return false;
-	if (!(dio->flags & IOMAP_DIO_WRITE_THROUGH))
-		return false;
-	return !bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev);
-}
-
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -332,7 +315,24 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 		return -EINVAL;
 
 	if (dio->flags & IOMAP_DIO_WRITE) {
-		bio_opf |= REQ_OP_WRITE;
+		bool need_completion_work = true;
+
+		switch (iomap->type) {
+		case IOMAP_MAPPED:
+			/*
+			 * Directly mapped I/O does not inherently need to do
+			 * work at I/O completion time.  But there are various
+			 * cases below where this will get set again.
+			 */
+			need_completion_work = false;
+			break;
+		case IOMAP_UNWRITTEN:
+			dio->flags |= IOMAP_DIO_UNWRITTEN;
+			need_zeroout = true;
+			break;
+		default:
+			break;
+		}
 
 		if (iomap->flags & IOMAP_F_ATOMIC_BIO) {
 			/*
@@ -345,22 +345,40 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 			bio_opf |= REQ_ATOMIC;
 		}
 
-		if (iomap->type == IOMAP_UNWRITTEN) {
-			dio->flags |= IOMAP_DIO_UNWRITTEN;
-			need_zeroout = true;
-		}
-
-		if (iomap->flags & IOMAP_F_SHARED)
+		if (iomap->flags & IOMAP_F_SHARED) {
+			/*
+			 * Unsharing of needs to update metadata at I/O
+			 * completion time.
+			 */
+			need_completion_work = true;
 			dio->flags |= IOMAP_DIO_COW;
+		}
 
-		if (iomap->flags & IOMAP_F_NEW)
+		if (iomap->flags & IOMAP_F_NEW) {
+			/*
+			 * Newly allocated blocks might need recording in
+			 * metadata at I/O completion time.
+			 */
+			need_completion_work = true;
 			need_zeroout = true;
-		else if (iomap->type == IOMAP_MAPPED &&
-			 iomap_dio_can_use_fua(iomap, dio))
-			bio_opf |= REQ_FUA;
+		}
 
-		if (!(bio_opf & REQ_FUA))
-			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
+		/*
+		 * Use a FUA write if we need datasync semantics and this is a
+		 * pure overwrite that doesn't require any metadata updates.
+		 *
+		 * This allows us to avoid cache flushes on I/O completion.
+		 */
+		if (dio->flags & IOMAP_DIO_WRITE_THROUGH) {
+			if (!need_completion_work &&
+			    !(iomap->flags & IOMAP_F_DIRTY) &&
+			    (!bdev_write_cache(iomap->bdev) ||
+			     bdev_fua(iomap->bdev)))
+				bio_opf |= REQ_FUA;
+			else
+				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
+		}
+		bio_opf |= REQ_OP_WRITE;
 	} else {
 		bio_opf |= REQ_OP_READ;
 	}
-- 
2.47.3


