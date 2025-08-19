Return-Path: <io-uring+bounces-9052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 517E7B2BBC5
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 10:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 932DB561C67
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 08:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE0131159E;
	Tue, 19 Aug 2025 08:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u3mj74ip"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4EA31195C;
	Tue, 19 Aug 2025 08:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755591930; cv=none; b=m9e7ZeqMRz9Drtu3EjueL6Q7I04qzyxFtnDPeKpATTNphfEKQslzWPr5l6VHvsvSwrdX8VbWkRar2ZG5h0hKbEa21w/dsGngi14iqb8c5UgMtP6nSXT+T4D+J2GcLUa4dDTG3xAWIbiDtXdPQnGgzcjDeOFzAXa+tJXdJ5QI5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755591930; c=relaxed/simple;
	bh=PXTU745VSyhx2OEIHWoNelqS0egAOcoigGskH1Ncr0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYzbRzUUFRU5C2rhfBC7lgrEFjeGs9SB2MF8b49EJyDqKreZjK5y/eu1l5NYid6n0F4NcM3qTe5w7dLie0C4k9d1VWvSki0YRtfeH5GPnj0GPIfR8o0VKyceAzp0cG6+ZIzarwQqdsqFtHwk4jck9AnBqqPuabbT0bRiAvVKdkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u3mj74ip; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2U+UZbwX1uaJHylf2E08XkTUURX8c5kOBefobOHX2Zw=; b=u3mj74ipo6P+nNAy+apNM91SK8
	GcO4JJg5OIkLKtDL7EINXtqvUeLkANRbL3BelbbUosbg9ajydHIXSed8gV6P4NzJGgiGV6+yyg3Ur
	bf2tv+so/X4aTKRntuBVH6mLA1qf+5iZeepF+7nVrsqqRbwC6m6fpkwU4vAzlGgQodj4MSwumiF7Z
	D2i+4JZrdIydps6IVNKd+keV1M2Ayd2GMCl1XIp8Y8MPGskjcomCpvPDroPdTfz134itS5Qkhuht5
	xJOQfsBKcKMY2znJmI8ajixW43qa2aWJdzVKqh+Kavuq4cUY/mhOQzVqRxUJ2345dH6KC5dqbbZaJ
	Er7hAyXQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoHep-00000009nW6-09nL;
	Tue, 19 Aug 2025 08:25:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 2/2] block: don't silently ignore metadata for sync read/write
Date: Tue, 19 Aug 2025 10:25:01 +0200
Message-ID: <20250819082517.2038819-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250819082517.2038819-1-hch@lst.de>
References: <20250819082517.2038819-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The block fops don't try to handle metadata for synchronous requests,
probably because the completion handler looks at dio->iocb which is not
valid for synchronous requests.

But silently ignoring metadata (or warning in case of
__blkdev_direct_IO_simple) is a really bad idea as that can cause
silent data corruption if a user ever shows up.

Instead simply handle metadata for synchronous requests as the completion
handler can simply check for bio_integrity() as the block layer default
integrity will already be freed at this point, and thus bio_integrity()
will only return true for user mapped integrity.

Fixes: 3d8b5a22d404 ("block: add support to pass user meta buffer")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 08e7c21bd9f1..ddbc69c0922b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -55,7 +55,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
-	WARN_ON_ONCE(iocb->ki_flags & IOCB_HAS_METADATA);
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -132,7 +131,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
-	if (!is_sync && (dio->iocb->ki_flags & IOCB_HAS_METADATA))
+	if (bio_integrity(bio))
 		bio_integrity_unmap_user(bio);
 
 	if (atomic_dec_and_test(&dio->ref)) {
@@ -234,7 +233,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			bio->bi_opf |= REQ_NOWAIT;
 		}
-		if (!is_sync && (iocb->ki_flags & IOCB_HAS_METADATA)) {
+		if (iocb->ki_flags & IOCB_HAS_METADATA) {
 			ret = bio_integrity_map_iter(bio, iocb->private);
 			if (unlikely(ret))
 				goto fail;
@@ -302,7 +301,7 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
-	if (iocb->ki_flags & IOCB_HAS_METADATA)
+	if (bio_integrity(bio))
 		bio_integrity_unmap_user(bio);
 
 	iocb->ki_complete(iocb, ret);
@@ -423,7 +422,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
-	if (likely(nr_pages <= BIO_MAX_VECS)) {
+	if (likely(nr_pages <= BIO_MAX_VECS &&
+		   !(iocb->ki_flags & IOCB_HAS_METADATA))) {
 		if (is_sync_kiocb(iocb))
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
-- 
2.47.2


