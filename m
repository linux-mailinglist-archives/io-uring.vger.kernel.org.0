Return-Path: <io-uring+bounces-5277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1069E7BA8
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F176216AA47
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF6C22C6C0;
	Fri,  6 Dec 2024 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mCc/ziz1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4100C212F97
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523842; cv=none; b=YcTHVkLRi6pCRcg5n8HhNCTCrf6HwsqpnUUzjEQ2D+l7kI+UHS1aBdZfW2ix5EuWrukdTuC3gGqzBdG/Ndxtgu+L9UZK0kveV4PoDTGOBG2uK9Fd0ZfMo+HQJeB8cGrje0LHzdqcSAy6CHNuW+lGvBsz4YCpf2cnlNRs/GTpLv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523842; c=relaxed/simple;
	bh=yHXFvDsEeK5TRGak0SpI6LYPt8+i/ACjWPHS2Ewq/9I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kvk06w7nt0cFGSDqNGgAC7s8mP8ijouaaCnd8uaqnFSlWFG3wvAQP3DM1WPjeu82flEMZ2RZSLMELVIaCv6p4eUijc22wwsUX4RfmqV6MMeX9hNZETdyHzuwFTq/MuLLvUt+YBuvqMt6U5fCxggC/8TGSKceiJRcRYNvlSLKuJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mCc/ziz1; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6Lh0g2020002
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:24:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=H1449KeqBHH2qLyX/UaGXiOFOGfVyFVyzOCCtWJaXls=; b=mCc/ziz1dBfW
	1J1Purn95Rx/JCJjC75pAXd9cn0heK+ehBEeStpJdJjZtZlEC9EHehNvxzvHmpve
	G2ePNw3J+n0nxJWISLhrAmuKgTDbUuQqyVUcCEh9TOPqlzfwLIrqOBqNZdxmbwT4
	UiJvWT9lcXaeHO8CM+J7ugANhAowBxQQVgtsh3Dgdgp2ogZegM9zARKIFCsc2Wde
	AgtfD0q3DUgYByOLLnqd2eUsT+DVwdCUXWj45UJ7RfhLlM1hWFPNEa/mtL14Kvf6
	RbVo2M5V3Bykf2HGRFlrWS6vxRtL1Oku7uS+86ImhT1Gq6LeBboAjMsL4lLLsmeA
	2nFiq2TDDQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43bycymhp6-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:24:00 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:23:57 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 2AB7F15B8CB79; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 05/12] block: introduce a write_stream_granularity queue limit
Date: Fri, 6 Dec 2024 14:17:54 -0800
Message-ID: <20241206221801.790690-6-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: B4cZHF9Fgl3G_wZy3ZtSR_TjHpbucMng
X-Proofpoint-GUID: B4cZHF9Fgl3G_wZy3ZtSR_TjHpbucMng
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Christoph Hellwig <hch@lst.de>

Export the granularity that write streams should be discarded with,
as it is essential for making good use of them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block | 8 ++++++++
 block/blk-sysfs.c                    | 3 +++
 include/linux/blkdev.h               | 7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index f67139b8b8eff..c454c68b68fe6 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -514,6 +514,14 @@ Description:
 		supported. If supported, valid values are 1 through
 		max_write_streams, inclusive.
=20
+What:		/sys/block/<disk>/queue/write_stream_granularity
+Date:		November 2024
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] Granularity of a write stream in bytes.  The granularity
+		of a write stream is the size that should be discarded or
+		overwritten together to avoid write amplification in the device.
+
 What:		/sys/block/<disk>/queue/max_segments
 Date:		March 2010
 Contact:	linux-block@vger.kernel.org
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index c514c0cb5e93c..525f4fa132cd3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -105,6 +105,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
 QUEUE_SYSFS_LIMIT_SHOW(max_write_streams)
+QUEUE_SYSFS_LIMIT_SHOW(write_stream_granularity)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -448,6 +449,7 @@ QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_RO_ENTRY(queue_max_segment_size, "max_segment_size");
 QUEUE_RO_ENTRY(queue_max_write_streams, "max_write_streams");
+QUEUE_RO_ENTRY(queue_write_stream_granularity, "write_stream_granularity=
");
 QUEUE_RW_LOAD_MODULE_ENTRY(elv_iosched, "scheduler");
=20
 QUEUE_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -583,6 +585,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
 	&queue_max_write_streams_entry.attr,
+	&queue_write_stream_granularity_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ce2c3ddda2411..7be8cc57561a1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -400,6 +400,7 @@ struct queue_limits {
 	unsigned short		max_discard_segments;
=20
 	unsigned short		max_write_streams;
+	unsigned int		write_stream_granularity;
=20
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
@@ -1249,6 +1250,12 @@ static inline unsigned short bdev_max_write_stream=
s(struct block_device *bdev)
 	return bdev_limits(bdev)->max_write_streams;
 }
=20
+static inline unsigned int
+bdev_write_stream_granularity(struct block_device *bdev)
+{
+	return bdev_limits(bdev)->write_stream_granularity;
+}
+
 static inline unsigned queue_logical_block_size(const struct request_que=
ue *q)
 {
 	return q->limits.logical_block_size;
--=20
2.43.5


