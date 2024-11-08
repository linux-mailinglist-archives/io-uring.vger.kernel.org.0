Return-Path: <io-uring+bounces-4575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C2B9C25EA
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 714491F2236D
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228721C1F00;
	Fri,  8 Nov 2024 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FetIrU/B"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A09366
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731095678; cv=none; b=SFp9p3gLhxoneA4dE9ZIBaMZCKHJHgY+zIt7rs9fghe5mFxatVhqQtIGNoOKeqYm9Jh+2Wdd9RyxlfNsBq9fWpO746+uzGFsU9pOBs43Fy23IbC1pj1sILvmeUyxeLAisglObRQrKCPGo3Grdb/+ErSZUmE9ZjLtM0a6mLpk2sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731095678; c=relaxed/simple;
	bh=kC2CCpjrTQkhcEvumtIX2EYBkb5eklg6AEd9vlsozpE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATzUMXTLkfOO8lsGMxrNjSMcwZNPkjXnUkJ8CfAyKR6gdxa95kvQYh0h7wZrEzxXJk+C8RCAVvLX2wNtwX2PqpSdjqV3An5cLf3SFxCPtk2bNHF5Bc3Q1qaqseGI7OOb0QIbwf55DT9CcHUpwrAroowrnETDKolJQhK7MeitnFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=FetIrU/B; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8IATUH005487
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 11:54:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=nFY5cQKcXIBMZ0d4Pwtwa9fvrYAh9lTNwdSR11VK3f8=; b=FetIrU/BBqo+
	6rZNdQeIt9m9VthgVWZmYJpAsg1ONTepD098hioGUUJ5gufGBINr43QIMKbLOoj0
	OIRNvzYjZwh9QIsvq2WFul2Ug/JicnrIFYdJ6XPgF0126/7hx5n3DnWCsj4XZgVs
	kXJh+Rh2AbaymmDzPll0qZuz2+F/fwfNBtQcBgNR2ZBHgPViZ2u5QHohvPsVj4Qk
	J25Kk8fxTkcpkOIGiIvFfdo2A3mz4EjR1u+BDM/eSQowf0Hmc4ML30iXDMrqBhlW
	243D/jFhXKVLN90gzmJ/XpMXY2cgHkSC9blIkzxOA7Ge37ZlI3GvbK0UoA7lcWxa
	qtpAtLhwDQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42sqpc0t7u-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 11:54:35 -0800 (PST)
Received: from twshared54778.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 19:54:04 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8DC3714E3A034; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 4/9] block: allow ability to limit partition write hints
Date: Fri, 8 Nov 2024 11:36:24 -0800
Message-ID: <20241108193629.3817619-5-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: dBRU5zdJfMBfZFNTrnYSW5pLeeL2HFhS
X-Proofpoint-GUID: dBRU5zdJfMBfZFNTrnYSW5pLeeL2HFhS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

When multiple partitions are used, you may want to enforce different
subsets of the available write hints for each partition. Provide a
bitmap attribute of the available write hints, and allow an admin to
write a different mask to set the partition's allowed write hints.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block |  7 +++++
 block/bdev.c                         | 17 +++++++++++
 block/partitions/core.c              | 45 ++++++++++++++++++++++++++--
 include/linux/blk_types.h            |  1 +
 4 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index f2db2cabb8e75..fa2db6b638d63 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -187,6 +187,13 @@ Description:
 		partition is offset from the internal allocation unit's
 		natural alignment.
=20
+What:		/sys/block/<disk>/<partition>/write_hint_mask
+Date:		October 2024
+Contact:	linux-block@vger.kernel.org
+Description:
+		The mask of allowed write hints. You can limit which hints the
+		block layer will use by writing a new mask.  Only the first
+		partition can access all the write hints by default.
=20
 What:		/sys/block/<disk>/<partition>/stat
 Date:		February 2008
diff --git a/block/bdev.c b/block/bdev.c
index 9a59f0c882170..e6f9d19db599b 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -415,6 +415,7 @@ void __init bdev_cache_init(void)
 struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 {
 	struct block_device *bdev;
+	unsigned short write_hint;
 	struct inode *inode;
=20
 	inode =3D new_inode(blockdev_superblock);
@@ -440,6 +441,22 @@ struct block_device *bdev_alloc(struct gendisk *disk=
, u8 partno)
 		return NULL;
 	}
 	bdev->bd_disk =3D disk;
+
+	write_hint =3D bdev_max_write_hints(bdev);
+	if (write_hint) {
+		bdev->write_hint_mask =3D bitmap_alloc(write_hint, GFP_KERNEL);
+		if (!bdev->write_hint_mask) {
+			free_percpu(bdev->bd_stats);
+			iput(inode);
+			return NULL;
+		}
+
+		if (partno =3D=3D 1)
+			bitmap_set(bdev->write_hint_mask, 0, write_hint);
+		else
+			bitmap_clear(bdev->write_hint_mask, 0, write_hint);
+	}
+
 	return bdev;
 }
=20
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 815ed33caa1b8..c71a5d34339d7 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -203,6 +203,41 @@ static ssize_t part_discard_alignment_show(struct de=
vice *dev,
 	return sprintf(buf, "%u\n", bdev_discard_alignment(dev_to_bdev(dev)));
 }
=20
+static ssize_t part_write_hint_mask_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct block_device *bdev =3D dev_to_bdev(dev);
+	unsigned short max_write_hints =3D bdev_max_write_hints(bdev);
+
+	if (!max_write_hints)
+		return sprintf(buf, "0");
+	return sprintf(buf, "%*pb\n", max_write_hints, bdev->write_hint_mask);
+}
+
+static ssize_t part_write_hint_mask_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct block_device *bdev =3D dev_to_bdev(dev);
+	unsigned short max_write_hints =3D bdev_max_write_hints(bdev);
+	unsigned long *new_mask;
+
+	if (!max_write_hints)
+		return count;
+
+	new_mask =3D bitmap_alloc(max_write_hints, GFP_KERNEL);
+	if (!new_mask)
+		return -ENOMEM;
+
+	bitmap_parse(buf, count, new_mask, max_write_hints);
+	bitmap_copy(bdev->write_hint_mask, new_mask, max_write_hints);
+	smp_wmb();
+	bitmap_free(new_mask);
+
+	return count;
+}
+
 static DEVICE_ATTR(partition, 0444, part_partition_show, NULL);
 static DEVICE_ATTR(start, 0444, part_start_show, NULL);
 static DEVICE_ATTR(size, 0444, part_size_show, NULL);
@@ -211,6 +246,8 @@ static DEVICE_ATTR(alignment_offset, 0444, part_align=
ment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, 0444, part_discard_alignment_show,=
 NULL);
 static DEVICE_ATTR(stat, 0444, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
+static DEVICE_ATTR(write_hint_mask, 0644, part_write_hint_mask_show,
+		   part_write_hint_mask_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =3D
 	__ATTR(make-it-fail, 0644, part_fail_show, part_fail_store);
@@ -225,6 +262,7 @@ static struct attribute *part_attrs[] =3D {
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_write_hint_mask.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -245,8 +283,11 @@ static const struct attribute_group *part_attr_group=
s[] =3D {
=20
 static void part_release(struct device *dev)
 {
-	put_disk(dev_to_bdev(dev)->bd_disk);
-	bdev_drop(dev_to_bdev(dev));
+	struct block_device *part =3D dev_to_bdev(dev);
+
+	bitmap_free(part->write_hint_mask);
+	put_disk(part->bd_disk);
+	bdev_drop(part);
 }
=20
 static int part_uevent(const struct device *dev, struct kobj_uevent_env =
*env)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6737795220e18..af430e543f7f7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -73,6 +73,7 @@ struct block_device {
 #ifdef CONFIG_SECURITY
 	void			*bd_security;
 #endif
+	unsigned long		*write_hint_mask;
 	/*
 	 * keep this out-of-line as it's both big and not needed in the fast
 	 * path
--=20
2.43.5


