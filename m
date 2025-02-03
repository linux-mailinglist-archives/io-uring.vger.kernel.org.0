Return-Path: <io-uring+bounces-6234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F58AA262C0
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03F081881ACC
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CBD1ADC94;
	Mon,  3 Feb 2025 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZXBdj27W"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F18194AEC
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608237; cv=none; b=AGvmIPp07j41CDtvwXNElIL8sY/IO1sez5wjAKtL/MjqHKSgXKeY4YjvqnuElfbMqP9qGq84ugW2CEFIgdrjLBrkgyOIq+szta+2aqghtoeU/jrvRKpH4bkcP1Zl1AbBoMJw+EevbyvXU+aBgGYH9lonkEu5lDqZdbtLPw9Jypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608237; c=relaxed/simple;
	bh=rHXuJVlwM6MHiXntSK70gQzihbKi5IYzSwVqyr8z7Rs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C3f/1rGRsjL3my5oMkEVpzhLEhnlzIReYCUmB7Gu5tdmOvf+LBzdV0l8yynC1fxMi6zh8qY0Ju+1Ho74FqTxNDgOmRipsEjrUiLKMDf++/0CdkpED0a12UpP9QY2XFqvevg89AzOniQpR9+YAweiyEGyS0CIrw3+Ga/5m96ysvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZXBdj27W; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513IHpki029078
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:43:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=nQyaNOkEiJKrwg1pUGQQuMbh9usC9AVDbq//1SwlJY4=; b=ZXBdj27W7V6X
	q6/8WAD/w6DV/L2MggOWZhVrOxfBHQtD+Z/eGv4ypjgxh3vM85vqV2lv1NZo4kSs
	NSy4eTDWFoDvK0sVTpnrJWpUGmvhZmL4rV/pUVuXcjWg7rZjyIiKkdpTwR3sYKIr
	hXXQ1u0trOFIkyPGeKHQQXiBIWXPr0yEphU+bCi5hLd4Bs0EXlTbEN0K0YdlYBcs
	X3ejwEySnSdH5nRPv4OI6Z0zPdmnn81k5+Ketx8uBouKfBwi/pt4HpAu5a2vC2++
	cb0uin3i4L5isnnHRxcdr79Ewp8aSipuFNtd6wtKzWakXhqGv1/qR3p2JVLC4taF
	wMeNpMA6Yw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k2e9ghex-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:43:54 -0800 (PST)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:43:52 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id A168E179C2629; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Hannes Reinecke
	<hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv2 04/11] block: introduce a write_stream_granularity queue limit
Date: Mon, 3 Feb 2025 10:41:22 -0800
Message-ID: <20250203184129.1829324-5-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: DxYhimu1Kd5duq4CQLh64SvrvR4uG1dV
X-Proofpoint-GUID: DxYhimu1Kd5duq4CQLh64SvrvR4uG1dV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Christoph Hellwig <hch@lst.de>

Export the granularity that write streams should be discarded with,
as it is essential for making good use of them.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/ABI/stable/sysfs-block | 8 ++++++++
 block/blk-sysfs.c                    | 3 +++
 include/linux/blkdev.h               | 1 +
 3 files changed, 12 insertions(+)

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
index 8b8f2b0f0c048..a4badc1f8d904 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -107,6 +107,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
 QUEUE_SYSFS_LIMIT_SHOW(max_write_streams)
+QUEUE_SYSFS_LIMIT_SHOW(write_stream_granularity)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -436,6 +437,7 @@ QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_RO_ENTRY(queue_max_segment_size, "max_segment_size");
 QUEUE_RO_ENTRY(queue_max_write_streams, "max_write_streams");
+QUEUE_RO_ENTRY(queue_write_stream_granularity, "write_stream_granularity=
");
 QUEUE_RW_LOAD_MODULE_ENTRY(elv_iosched, "scheduler");
=20
 QUEUE_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -571,6 +573,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
 	&queue_max_write_streams_entry.attr,
+	&queue_write_stream_granularity_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f92db4b35f4b6..927d5531930e3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -398,6 +398,7 @@ struct queue_limits {
 	unsigned short		max_discard_segments;
=20
 	unsigned short		max_write_streams;
+	unsigned int		write_stream_granularity;
=20
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
--=20
2.43.5


