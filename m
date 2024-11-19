Return-Path: <io-uring+bounces-4823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BF89D2584
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC8162845D2
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E8D1CF5D8;
	Tue, 19 Nov 2024 12:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pfYpb1CI"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB31CF5E9;
	Tue, 19 Nov 2024 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018626; cv=none; b=lC+tXMGilLFZdmIWEuDkIjdqaPg768WkmS0Yz1MJDpVyJAKFEcEGTsWaWkHzxNmkYna3ogyLO4ssU/T+02H7vrONcqDltbzjOWEzvjt5x093iGkXht00Bx4gjsObW3q+dVoXtRo7TrQX1LcoNx9NrXA4nOrrbiUliHP8j//w6FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018626; c=relaxed/simple;
	bh=Dwzh/OpYLSodRjyM0GjZ2OwbD5NSC/lznYETElq1I6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS/566iW6O7Me6Z6ryLpNbhHkj14QglDOGQ9+eRf/Ac6g+nnfdW7OjPIR6rk+MquyCIBth0qiTtnIK8qjWFuDWw11+DuHf0GPW1Xv9rruNfEKiE4oM1pyxiVmeWuvYMFrXcomWU1xUBUkWpVVPCGfE5MDlc+Jzo1MGfhW+PiY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pfYpb1CI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eFnAU/YKrxAyCOfUvcjuy01kOFc9uTpB/T3yj/VVbHA=; b=pfYpb1CIj8PrENBsku6UAQacBw
	w3a4aG7fE4mHf1ocsBB1gkmOmpeEr8nuBpFbQ+TjkHJPHDWlYhS2whFI6t1q5Fcf/upN96+LzZZB6
	0M2NdX+yOKP+4s8ZGt1fP+e39m1c/6niYRonZcEVZHw4EF8g7nH6vIrfsfjZXtHBb30Bc+XEm/hYI
	3GdmTZRH10Od6yN1wYAPn60Som2J22Ezz85YFlOywTfWqC4SWyVDJDAxkdsNrUWjQXPM6sAiR4B41
	AVIDnBIc58XDWL7du7C61zsY/v9ningkdr+1Fphe7FM68/+qbScEWtNtR4JMaMImhG2Mt0clTIWG9
	5bjjW8hg==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNAE-0000000CJ83-1nRx;
	Tue, 19 Nov 2024 12:17:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 09/15] block: expose write streams for block device nodes
Date: Tue, 19 Nov 2024 13:16:23 +0100
Message-ID: <20241119121632.1225556-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Export statx information about the number and granularity of write
streams, use the per-kiocb write hint and map temperature hints
to write streams (which is a bit questionable, but this shows how it is
done).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c |  6 ++++++
 block/fops.c | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 738e3c8457e7..c23245f1fdfe 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1296,6 +1296,12 @@ void bdev_statx(struct path *path, struct kstat *stat,
 		stat->result_mask |= STATX_DIOALIGN;
 	}
 
+	if ((request_mask & STATX_WRITE_STREAM) &&
+	    bdev_max_write_streams(bdev)) {
+		stat->write_stream_max = bdev_max_write_streams(bdev);
+		stat->result_mask |= STATX_WRITE_STREAM;
+	}
+
 	if (request_mask & STATX_WRITE_ATOMIC && bdev_can_atomic_write(bdev)) {
 		struct request_queue *bd_queue = bdev->bd_queue;
 
diff --git a/block/fops.c b/block/fops.c
index 2d01c9007681..2a860dbe5e48 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -72,6 +72,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_stream = iocb->ki_write_stream;
 	bio.bi_ioprio = iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |= REQ_ATOMIC;
@@ -201,6 +202,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	for (;;) {
 		bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 		bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_stream = iocb->ki_write_stream;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
@@ -317,6 +319,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	dio->iocb = iocb;
 	bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_stream = iocb->ki_write_stream;
 	bio->bi_end_io = blkdev_bio_end_io_async;
 	bio->bi_ioprio = iocb->ki_ioprio;
 
@@ -373,6 +376,26 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (blkdev_dio_invalid(bdev, iocb, iter))
 		return -EINVAL;
 
+	if (iov_iter_rw(iter) == WRITE) {
+		u16 max_write_streams = bdev_max_write_streams(bdev);
+
+		if (iocb->ki_write_stream) {
+			if (iocb->ki_write_stream > max_write_streams)
+				return -EINVAL;
+		} else if (max_write_streams) {
+			enum rw_hint write_hint =
+				file_inode(iocb->ki_filp)->i_write_hint;
+
+			/*
+			 * Just use the write hint as write stream for block
+			 * device writes.  This assumes no file system is
+			 * mounted that would use the streams differently.
+			 */
+			if (write_hint <= max_write_streams)
+				iocb->ki_write_stream = write_hint;
+		}
+	}
+
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <= BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
-- 
2.45.2


