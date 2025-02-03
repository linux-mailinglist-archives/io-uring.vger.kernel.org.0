Return-Path: <io-uring+bounces-6236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E702A262C6
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E22997A1E1E
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7430C1922F6;
	Mon,  3 Feb 2025 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cb5NDdv2"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A919938D
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608241; cv=none; b=QZ+BUIJu/D1GPi9H+L3zsijVEPycD8imOT63R/yMxymxU2RUz8PBwWFJVMpCW1xmirQl3qiyuSi5jdMSzGpxszV7o4M2xEcFkVbfpGJepPMEQe1+PprvHs+CJXJWT1v3KUSHmnooQlVAE1r42mDfxK2KrQNb10NrqLq/+ZZkFwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608241; c=relaxed/simple;
	bh=ktr9PiP+oadbzrXwSkUjSXD2dPHBC0UhG57Ju1uoEuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jcp/9pFFjZbgNc3WsFljrJU9r13wxWCC1M7wngCfuPGGbqIKrbAdbrnW5zJN18WI49tbvkiHf5rgPl6QFtsofhn3vx3GfSktZ7APLbYaw9V8hMGy2UuFLTeKdY+iQlGqOJZaHJZitQBDli6BZRNB0vbFtDYB8xWOtZAs/0xfMc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cb5NDdv2; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 513IHqSe006896
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:43:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=vD+7nw2tYMtvjJDa1Yiet8R2DOiSYjvA3pTIKc83e0U=; b=cb5NDdv286fe
	BxtdSO0DIgVsyN/eMzpAwWDAw2FWXpf7to23pxs4TydYyYthX1L2fHZ/6JsCr456
	EdF+Y7LrMPMgzh1rh9bNfDl0vILtN9A80ZofsjxDwga2OwJqQPJTdSdcxxb4ZHoq
	uUVBHBhZ6BkMjKlRxiMj3zJMdBWNVAQyA9aJrkgGHxTtf8Uk6Ug4TbLUXO4vHsLr
	L73fiaOVT3cn6fmjufx3B7VR47hCaTWSkjSvdkavNztAk6Ld1bzlQ/rzv9Sep99K
	+SVVvwQs+7c2DBnrCUWtWVhgs50Jc+fRBCOq9KbOa+yPcqFHe8oYZKchQPvU7aXd
	6NF/b7+tXA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 44k21sgr9b-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:43:58 -0800 (PST)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:43:52 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 95317179C2627; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Keith Busch
	<kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCHv2 03/11] block: introduce max_write_streams queue limit
Date: Mon, 3 Feb 2025 10:41:21 -0800
Message-ID: <20250203184129.1829324-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
References: <20250203184129.1829324-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ktjnUTJvgj_2uY2_8c_UXlKY6lw_Mumm
X-Proofpoint-GUID: ktjnUTJvgj_2uY2_8c_UXlKY6lw_Mumm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Drivers with hardware that support write streams need a way to export how
many are available so applications can generically query this.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[hch: renamed hints to streams, removed stacking]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block | 7 +++++++
 block/blk-sysfs.c                    | 3 +++
 include/linux/blkdev.h               | 9 +++++++++
 3 files changed, 19 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index 0cceb2badc836..f67139b8b8eff 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -506,6 +506,13 @@ Description:
 		[RO] Maximum size in bytes of a single element in a DMA
 		scatter/gather list.
=20
+What:		/sys/block/<disk>/queue/max_write_streams
+Date:		November 2024
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] Maximum number of write streams supported, 0 if not
+		supported. If supported, valid values are 1 through
+		max_write_streams, inclusive.
=20
 What:		/sys/block/<disk>/queue/max_segments
 Date:		March 2010
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e09b455874bfd..8b8f2b0f0c048 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -106,6 +106,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
+QUEUE_SYSFS_LIMIT_SHOW(max_write_streams)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -434,6 +435,7 @@ QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_=
kb");
 QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_RO_ENTRY(queue_max_segment_size, "max_segment_size");
+QUEUE_RO_ENTRY(queue_max_write_streams, "max_write_streams");
 QUEUE_RW_LOAD_MODULE_ENTRY(elv_iosched, "scheduler");
=20
 QUEUE_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -568,6 +570,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_max_discard_segments_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
+	&queue_max_write_streams_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 76f0a4e7c2e5d..f92db4b35f4b6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -397,6 +397,8 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
=20
+	unsigned short		max_write_streams;
+
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
=20
@@ -1245,6 +1247,13 @@ static inline unsigned int bdev_max_segments(struc=
t block_device *bdev)
 	return queue_max_segments(bdev_get_queue(bdev));
 }
=20
+static inline unsigned short bdev_max_write_streams(struct block_device =
*bdev)
+{
+	if (bdev_is_partition(bdev))
+		return 0;
+	return bdev_limits(bdev)->max_write_streams;
+}
+
 static inline unsigned queue_logical_block_size(const struct request_que=
ue *q)
 {
 	return q->limits.logical_block_size;
--=20
2.43.5


