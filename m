Return-Path: <io-uring+bounces-3791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DBC9A2815
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 043E2283FD9
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846551DEFE4;
	Thu, 17 Oct 2024 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Z0l5OvWa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC721DF267
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181427; cv=none; b=eVdM+GwkGmtMixC1DH8a2zJr3oHWwzGwGsTd1lf+3DdC1Gm6ptS9oMBCXiZ3llbQVLxZLcilIkKaRnBuIcF3vjUSVvKNotGd6oSspXFkCeG+bwcFCpdPjNJDWRr1NAGCE0i87DXpCJH4+PP2CvAbPi3SZ2lKO+6h9Cgfc2VGbak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181427; c=relaxed/simple;
	bh=MvS/i32WJkDXXnSscWSi1W93KMQWsKONvvpOgs3T5G8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCx79TCbDKJ08knrJgS4tSJDbKyzzMLfm3tYbBLa45oz8272CvTtyCH1DDd4lSEoU541atoJBAqpZE7MMzH8wjOLsiB0RNHWbUIoIahHoIo5eu7lZlvanf0s8QxUVMQpqlTZxnfS5xNtVnvdNOcrOnqw4xVzBL1hznBjGMxHOAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Z0l5OvWa; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HCgsB6003824
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=Fpv8CvzFpr/t1VctB+FPTead3v5vovwpLAkShY9F2ik=; b=Z0l5OvWaMysp
	KMXYFzntY/wCwA+7z/Vy9Rr775j9k3A6klqNjvB+mpfrF7lJPVNgIQhnSs895PbB
	RORv4KLNys0PkXh4a41Abi1nQSGGypY3zZolrJgRESkM/rYFT+L9r2SdVjDVMt8X
	xOgusRSl0hfQbCajU62s+eOetg7aj84z8fyNZJkKdog89sI8aowg4x+ZD38wQnVe
	DSRDZg7mnaO9WI49LAhe2R5dUnPY5uCwwNoL7iabLAuOkwSQIR7ncIrYT0Hc1up2
	J5scsh3VbCLMLb4s0I4g6puiaJ/ZKbjDf4Kh2T1iWKHRSy1dARN5q5N8o9/dg7Lh
	bCvxd5huRw==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42a9tjkbjn-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:10:24 -0700 (PDT)
Received: from twshared23455.15.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 17 Oct 2024 16:10:21 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id ADEF7143A4AD2; Thu, 17 Oct 2024 09:10:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <axboe@kernel.dk>, <hch@lst.de>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv8 3/6] block: introduce max_write_hints queue limit
Date: Thu, 17 Oct 2024 09:09:34 -0700
Message-ID: <20241017160937.2283225-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241017160937.2283225-1-kbusch@meta.com>
References: <20241017160937.2283225-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YDktiGf3ORN5P8IniB9M1BEq_j9PcRFq
X-Proofpoint-GUID: YDktiGf3ORN5P8IniB9M1BEq_j9PcRFq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Drivers with hardware that support write hints need a way to export how
many are available so applications can generically query this.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block |  7 +++++++
 block/blk-settings.c                 |  3 +++
 block/blk-sysfs.c                    |  3 +++
 block/fops.c                         |  2 ++
 include/linux/blkdev.h               | 12 ++++++++++++
 5 files changed, 27 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index 8353611107154..f2db2cabb8e75 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -506,6 +506,13 @@ Description:
 		[RO] Maximum size in bytes of a single element in a DMA
 		scatter/gather list.
=20
+What:		/sys/block/<disk>/queue/max_write_hints
+Date:		October 2024
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] Maximum number of write hints supported, 0 if not
+		supported. If supported, valid values are 1 through
+		max_write_hints, inclusive.
=20
 What:		/sys/block/<disk>/queue/max_segments
 Date:		March 2010
diff --git a/block/blk-settings.c b/block/blk-settings.c
index a446654ddee5e..921fb4d334fa4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -43,6 +43,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->seg_boundary_mask =3D BLK_SEG_BOUNDARY_MASK;
=20
 	/* Inherit limits from component devices */
+	lim->max_write_hints =3D USHRT_MAX;
 	lim->max_segments =3D USHRT_MAX;
 	lim->max_discard_segments =3D USHRT_MAX;
 	lim->max_hw_sectors =3D UINT_MAX;
@@ -544,6 +545,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,
 	t->max_segment_size =3D min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
=20
+	t->max_write_hints =3D min(t->max_write_hints, b->max_write_hints);
+
 	alignment =3D queue_limit_alignment_offset(b, start);
=20
 	/* Bottom device has different alignment.  Check that it is
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 741b95dfdbf6f..85f48ca461049 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -104,6 +104,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
+QUEUE_SYSFS_LIMIT_SHOW(max_write_hints)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -457,6 +458,7 @@ QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_=
kb");
 QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_RO_ENTRY(queue_max_segment_size, "max_segment_size");
+QUEUE_RO_ENTRY(queue_max_write_hints, "max_write_hints");
 QUEUE_RW_LOAD_MODULE_ENTRY(elv_iosched, "scheduler");
=20
 QUEUE_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -591,6 +593,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_max_discard_segments_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
+	&queue_max_write_hints_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/block/fops.c b/block/fops.c
index 85b9b97d372c8..d0b16d3975fd6 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -376,6 +376,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, s=
truct iov_iter *iter)
=20
 	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
 		return -EINVAL;
+	if (iocb->ki_write_hint > bdev_max_write_hints(bdev))
+		return -EINVAL;
=20
 	nr_pages =3D bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <=3D BIO_MAX_VECS)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6b78a68e0bd9c..01aba0ffeff6e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -393,6 +393,8 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
=20
+	unsigned short		max_write_hints;
+
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
=20
@@ -1183,6 +1185,11 @@ static inline unsigned short queue_max_segments(co=
nst struct request_queue *q)
 	return q->limits.max_segments;
 }
=20
+static inline unsigned short queue_max_write_hints(struct request_queue =
*q)
+{
+	return q->limits.max_write_hints;
+}
+
 static inline unsigned short queue_max_discard_segments(const struct req=
uest_queue *q)
 {
 	return q->limits.max_discard_segments;
@@ -1230,6 +1237,11 @@ static inline unsigned int bdev_max_segments(struc=
t block_device *bdev)
 	return queue_max_segments(bdev_get_queue(bdev));
 }
=20
+static inline unsigned short bdev_max_write_hints(struct block_device *b=
dev)
+{
+	return queue_max_write_hints(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_que=
ue *q)
 {
 	return q->limits.logical_block_size;
--=20
2.43.5


