Return-Path: <io-uring+bounces-7849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3C4AAC421
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AF5D3B149A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E468428134E;
	Tue,  6 May 2025 12:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Py3eGWMu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B37A28134C
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534410; cv=none; b=R+UzZlT/uzhOuguDS8akpWAyS9+Zan9IxdnQM++fUs83M7JQKmLkwTriCDsqFumFdJaYzUAOexZEZuQeAPtZB0wYKKTOUBGB+HkobHXb+O9oRkzexTCGKiWm4peib0iX1YXLyvm3t0CdKsBEBRWBj67SHbO0wm2mCWCzlwD5Tjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534410; c=relaxed/simple;
	bh=xaimPp1dI/YSvYuoFFciLQ1/IjD2JWZoJ0ISrEritb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nAZAoUQE//rNd2Jajw8WN2pHWm00/PU+HMcvE6qZxwm+BITnz+Gujh/T+IKTUaSd/Saxes34M3ArJZ9syOZM83PoHbuysOOV/oEBW5Fp8URZ8YnEnkTQED8rkcNkhyAbU8cIpS/zkwIHJ5+EOAmklGeA5WLaYVUvZ/LajpD6Pzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Py3eGWMu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250506122645epoutp0353193846e7bf06738c2f62f6b4d49f56~878nRTseN2430324303epoutp03r
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250506122645epoutp0353193846e7bf06738c2f62f6b4d49f56~878nRTseN2430324303epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534405;
	bh=unJTCCEaXXXg5wwDLxh3fhnhvj31mJgiMXpUO+QUVoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py3eGWMuuoiWYpqYm6d9XuxO0+OeGeICb+3ygrLo19E9SKvDL+i0uNAQulRfEYGaG
	 uuJK9Zr0VQ11obPEmgfV03el7L1LjxX1SOomxkCrnhUmGDjvTr/IOSvsVzQmsIRHaf
	 V4T4wqThPiddIIyPorVAbFezO71fuVVhNgnziby8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122645epcas5p44fd15f89441c0df298a9b93e64b028f8~878mvrcdp0663906639epcas5p4z;
	Tue,  6 May 2025 12:26:45 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.181]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZsHh32mF2z6B9m4; Tue,  6 May
	2025 12:26:43 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122642epcas5p267fef037060e55d1e9c0055b0dfd692e~878kab1vq2629526295epcas5p2F;
	Tue,  6 May 2025 12:26:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250506122642epsmtrp18afea66031e60e23bd1a87beac41edaf~878kYxaoB2592625926epsmtrp1B;
	Tue,  6 May 2025 12:26:42 +0000 (GMT)
X-AuditID: b6c32a29-55afd7000000223e-91-681a00025fa8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CC.B6.08766.2000A186; Tue,  6 May 2025 21:26:42 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122640epsmtip25724ed78f8c9f291b05de63988079d32~878ixpy5s1679416794epsmtip2c;
	Tue,  6 May 2025 12:26:40 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 05/11] block: expose write streams for block device
 nodes
Date: Tue,  6 May 2025 17:47:26 +0530
Message-Id: <20250506121732.8211-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvC4Tg1SGwccJYhZzVm1jtFh9t5/N
	Ys+iSUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22LP3pMsFvOXPWW32PZ7PrMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Nh8utrj8ya5AI4oLpuU1JzMstQifbsErozDm68w
	F/wUqZh26glbA+MKwS5GTg4JAROJ3xtusXYxcnEICexmlNjTtpsNIiEu0XztBzuELSyx8t9z
	doiij4wSq64fY+pi5OBgE9CUuDC5FKRGRCBA4uXix8wgNcwCH4AGTZzNCJIQFvCVeP5lPQtI
	PYuAqkTjzTCQMK+AucSVc78ZIebLS8y89B1sF6eAhcTyPbPA4kJANS+OHmGHqBeUODnzCQuI
	zQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjgkt
	zR2M21d90DvEyMTBeIhRgoNZSYT3/n3JDCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE
	0hNLUrNTUwtSi2CyTBycUg1MXlFGJ2/tyH/h+Tujxkd67eN3ryXbHhjIXvb+ysJ/sMw3cMXc
	3d/vLvle92l3Wq2vqli38qOT0j8O3KmRZKn13vG8ZYbrxp/JER659lY3LNV+TPpyl+FB4Yzt
	7xlt90Q63vq2d8uOwzWfHWLlSj3n/wren7Na8kzP3306E+I9Vlq+6DMUTdW+uI83LGi6u/7F
	A4y3zFy57xhOvanWaPNuzuZjJXtbFgQbXb24gzXvdMibR53WDSbbb7x7cqs+LefI3ReT/Zua
	blgefNq+dalX6xH/2xOZ36Rsu7KwyPlv8oK/xhtdjIyVEpO3fN4Qt/HSyRDvyaq2kw2TD3m7
	qkptin1jedHaYsrh75LvubM+liqxFGckGmoxFxUnAgDBeGbl+AIAAA==
X-CMS-MailID: 20250506122642epcas5p267fef037060e55d1e9c0055b0dfd692e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122642epcas5p267fef037060e55d1e9c0055b0dfd692e
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122642epcas5p267fef037060e55d1e9c0055b0dfd692e@epcas5p2.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Use the per-kiocb write stream if provided, or map temperature hints to
write streams (which is a bit questionable, but this shows how it is
done).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[kbusch: removed statx reporting]
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/fops.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index b6d7cdd96b54..1309861d4c2c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -73,6 +73,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_stream = iocb->ki_write_stream;
 	bio.bi_ioprio = iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |= REQ_ATOMIC;
@@ -206,6 +207,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	for (;;) {
 		bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 		bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_stream = iocb->ki_write_stream;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
@@ -333,6 +335,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	dio->iocb = iocb;
 	bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_stream = iocb->ki_write_stream;
 	bio->bi_end_io = blkdev_bio_end_io_async;
 	bio->bi_ioprio = iocb->ki_ioprio;
 
@@ -398,6 +401,26 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
2.25.1


