Return-Path: <io-uring+bounces-4569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC0E9C25B7
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D3431F213AD
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F42D1AA1E0;
	Fri,  8 Nov 2024 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XHHgGm7d"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E0C1AA1DD
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094985; cv=none; b=WQgJeB2lFIrjAevF5qU9R0JaSAfOR3XOnrwdSeeznW6NhlEyCgQY5oGWzSEJPhewWK2Ihz05A9dq14B8RFQSCwHhl8Cu+xnIaEC5yFnwAfY9szlpQpwi/GAps9lHDuC9eWbOvN1jodhkOJFBmhjxpxPDbe/LDII1UvR/bXKJgsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094985; c=relaxed/simple;
	bh=dghYSJUqrHxZgJ2S/xR790cnSvBl4HY9BwyiDV53ToA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3FA5Tq5rIwXqWKxgGoSCCl/UHKAbQFBhshg1c3gP7U/qUdHWXBCpyEzNpb6yAOEWg2Byl33QriPBexHPkAVfSQ/n4lO1aQvAO8jQPo/y7w+0r44GilaDQAagnE2tDGCXq6m9+8XsqrSIQi7/lUrhMEk3+qeN96t841xaw5fLxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XHHgGm7d; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8IANqN004929
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 11:43:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=EBbt1Sz3anE/DwELXc/1XodO6Fo/C1FtndRt7TOnDpo=; b=XHHgGm7d9IZ+
	xPIQvIHhw2W7woWQpGp5uLIN1BQ998I7hfP3T3MlEkP1FQNrC72XCYKJam2OOCZA
	4wjLdRhkyWxiQhuPnBs6aUvDL9cymh1zu1S49udr66QZ+9c1Pn/F2RHjZRycxt+S
	a6YtJ36+pTovLHK2Ejbd/0tz7pK8kko0mdw8VDOYZoxQln3lk1iSLC8oAmqIvmVp
	ENq8gnFwQ796cHoAVVgU3NjHB0NPv7Ckzc9BKVvfG7besnHfeO6S6G3gGqJXl3ms
	CtbSSbTXO3n5x4MFLrKRaij+U/BWhIT7AeF4xtrvMVPF/mRbWFiPjl/dQHw89/lM
	QE1Igv+Ifw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42sqpc0qye-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 11:43:02 -0800 (PST)
Received: from twshared29075.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 19:43:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7135514E3A02E; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 2/9] block: introduce max_write_hints queue limit
Date: Fri, 8 Nov 2024 11:36:22 -0800
Message-ID: <20241108193629.3817619-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241108193629.3817619-1-kbusch@meta.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0-Mhu4bJSHzbDba59SMNyNeC82I2ENxE
X-Proofpoint-GUID: 0-Mhu4bJSHzbDba59SMNyNeC82I2ENxE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Drivers with hardware that support write streams need a way to export how
many are available so applications can generically query this.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block |  7 +++++++
 block/blk-settings.c                 |  3 +++
 block/blk-sysfs.c                    |  3 +++
 include/linux/blkdev.h               | 12 ++++++++++++
 4 files changed, 25 insertions(+)

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
index 5ee3d6d1448df..f9f831f104615 100644
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
index 0ef4e13e247d9..1925ea23bd290 100644
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b51a7c92e9be..1477f751ad8bd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -394,6 +394,8 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
=20
+	unsigned short		max_write_hints;
+
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
=20
@@ -1198,6 +1200,11 @@ static inline unsigned short queue_max_segments(co=
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
@@ -1245,6 +1252,11 @@ static inline unsigned int bdev_max_segments(struc=
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


