Return-Path: <io-uring+bounces-4572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B249C25D7
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D8862812E5
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D551AA1C8;
	Fri,  8 Nov 2024 19:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GCRfzGRk"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCED233D72
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 19:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731095339; cv=none; b=eHRHueHvxfqnUGUjvTU0iT+U0VyK1NgeG6G/LcypGqR0+Yc0LkMElLx/tdqKiAv+XIXgtBad22INGwKkQp2JLIHMpVcxnLAGZHP4ePerd6Qiq17ZmzmWVbC1zfTwli1soQR4JP4VGVGZ9ElLOh6ZshmB94a4XCl5ZlqZif8RDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731095339; c=relaxed/simple;
	bh=62NxbrkTBvu2ZXfuvt0cM1JrzKX8zfy5nlwp4/oPg+M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQnAqB5UHL2vKYCUX6rITBmwQmypPJ1MCqwf6/OafWXGLp+z2OLQS9QxBPtACLM/rBLIy68O43aPRwn5NapHjrSFilJO3qZLQd29PfhxN0fJC+YwDrtDHyILONj5kGlyy5pO33CPZLpfzppftWgksrddXhW6c3PSomXT9251Oo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GCRfzGRk; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8HPKrB022316
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 11:48:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=JLqB0bINPP9TBHWvbswRy3CLboznVSFjr0ykLJ11WFw=; b=GCRfzGRk8Fz7
	NWWUK9RaGJV34qXK/bfT4kLefN/JzfpmbDtW2YQ9/9pIOnjGLACNxzuS21SzmIMo
	VUQ7Iaq/SR/ZV7ihdHa/JDs4PQC3cUKio9eH1S7TyJgR5gV+WZl/Pf/PFbpYbxOx
	J+Sydl3vFVHjYEr7yOIShdnqVuxUljOOigu1Gw2edelmhuMH4/PF7UAonflFnZoZ
	U708qZwsXc3GFN/AaM7SylKsYds6+mrXBf8GHxpsSHrgPZyM93oDqSqYvllASXkI
	849H/JwFLrJWH0IOlM4NW2zrPT/ATGLPu0wy9shNZ+jFROj8SNwj8RMxWJq+VjuS
	kSoL6TGGxA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42sn58a41r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 11:48:57 -0800 (PST)
Received: from twshared8596.05.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 19:48:55 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B281E14E3A03D; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 7/9] block: export placement hint feature
Date: Fri, 8 Nov 2024 11:36:27 -0800
Message-ID: <20241108193629.3817619-8-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: cpS2lzRUp-VzcJ8C0JsQFFjn38i-70uw
X-Proofpoint-GUID: cpS2lzRUp-VzcJ8C0JsQFFjn38i-70uw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Add a feature flag for devices that support generic placement hints in
write commands. This is in contrast to data lifetime hints.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-settings.c   | 2 ++
 block/blk-sysfs.c      | 3 +++
 include/linux/blkdev.h | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f9f831f104615..b809f31ad84f2 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -518,6 +518,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,
 		t->features &=3D ~BLK_FEAT_NOWAIT;
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &=3D ~BLK_FEAT_POLL;
+	if (!(b->features & BLK_FEAT_PLACEMENT_HINTS))
+		t->features &=3D ~BLK_FEAT_PLACEMENT_HINTS;
=20
 	t->flags |=3D (b->flags & BLK_FLAG_MISALIGNED);
=20
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1925ea23bd290..6280c5f89b8b7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -260,6 +260,7 @@ static ssize_t queue_##_name##_show(struct gendisk *d=
isk, char *page)	\
 QUEUE_SYSFS_FEATURE_SHOW(poll, BLK_FEAT_POLL);
 QUEUE_SYSFS_FEATURE_SHOW(fua, BLK_FEAT_FUA);
 QUEUE_SYSFS_FEATURE_SHOW(dax, BLK_FEAT_DAX);
+QUEUE_SYSFS_FEATURE_SHOW(placement_hints, BLK_FEAT_PLACEMENT_HINTS);
=20
 static ssize_t queue_zoned_show(struct gendisk *disk, char *page)
 {
@@ -497,6 +498,7 @@ QUEUE_RW_ENTRY(queue_poll_delay, "io_poll_delay");
 QUEUE_RW_ENTRY(queue_wc, "write_cache");
 QUEUE_RO_ENTRY(queue_fua, "fua");
 QUEUE_RO_ENTRY(queue_dax, "dax");
+QUEUE_RO_ENTRY(queue_placement_hints, "placement_hints");
 QUEUE_RW_ENTRY(queue_io_timeout, "io_timeout");
 QUEUE_RO_ENTRY(queue_virt_boundary_mask, "virt_boundary_mask");
 QUEUE_RO_ENTRY(queue_dma_alignment, "dma_alignment");
@@ -626,6 +628,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_wc_entry.attr,
 	&queue_fua_entry.attr,
 	&queue_dax_entry.attr,
+	&queue_placement_hints_entry.attr,
 	&queue_poll_delay_entry.attr,
 	&queue_virt_boundary_mask_entry.attr,
 	&queue_dma_alignment_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1477f751ad8bd..2ffe9a3b9dbff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -333,6 +333,9 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
=20
+/* supports generic write placement hints */
+#define BLK_FEAT_PLACEMENT_HINTS	((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
--=20
2.43.5


