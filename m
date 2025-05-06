Return-Path: <io-uring+bounces-7847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20EF7AAC409
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D7B61C27480
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEB6281351;
	Tue,  6 May 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qR0Ah4uX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C1727FD75
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534407; cv=none; b=Akx90KAfpBQRVz7cpIORwOQNq7y2OMk3reVmtfakmoW/3yUqWNTPVTjbkBtoQI6gVCVaVDrbRMiOPpitt3uwNhgevtFrYNMuYY8doxUbmYLDuVcHqCyjF60x8gT1QlDorxW7Pmwry8EYBzxlzhHk+ywfbhNP7o4CxN+4uonfU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534407; c=relaxed/simple;
	bh=JBuCk5+txZsZVz3D+uozImjyu7MVNP4f9JZ1SuRhjNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=fUgNbn45d70uVs+Nynlm1OTynLLCtCTN0Dn6EyguV25eL2cI8ydgVibluXZU6I/q85LWu0u6pXrPHlJGl3dre1Djgh5i5fyHkOHrG4F4EsgsKx+xcCiVIBIN0yLDLItpsqhjxWwyRx9upRNOrNRS+PShGtNe0p4NrpA4WaaWNVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qR0Ah4uX; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250506122644epoutp030c12fe112e3e7b3abebc4d267fbd83cf~878l7ZZjM2443224432epoutp03k
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250506122644epoutp030c12fe112e3e7b3abebc4d267fbd83cf~878l7ZZjM2443224432epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534404;
	bh=EXxGmU6aDCPfoWn8iCPhL+6RC10HrMWdYq5g/ZNmkgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qR0Ah4uX8H9gxCdYM9UkfqhxMHL0CnobKeWcxWjWCWq1Qr6ktcf++7EUlKwCaAPF3
	 IwLwhT8pjLr5fXVQo9FGzNmZw4omCaAhWfgIr+92fx7Xd2p6jB+jqQ2xozdEWAaTbJ
	 atTmdSrOrlf8W1u4qGV0S3vlVyqc/S3sfbyL60A0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250506122643epcas5p3b0574413a9631966738d5970fbbd2b6d~878k_JyeO0387503875epcas5p3R;
	Tue,  6 May 2025 12:26:43 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.176]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZsHh139xpz6B9m5; Tue,  6 May
	2025 12:26:41 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250506122640epcas5p43b5abe6562ad64ee1d7254b1215906d4~878iqKwUC2065220652epcas5p4w;
	Tue,  6 May 2025 12:26:40 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250506122640epsmtrp1d9d5ce74dbb9c3eb0dc030f7234af567~878ipcdSV2555625556epsmtrp17;
	Tue,  6 May 2025 12:26:40 +0000 (GMT)
X-AuditID: b6c32a28-46cef70000001e8a-e7-681a000018fe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.E5.07818.0000A186; Tue,  6 May 2025 21:26:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122638epsmtip2bc5bc95e5d6f3c8d9175e52eaf5c84cb~878hDgoda1704417044epsmtip2S;
	Tue,  6 May 2025 12:26:38 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 04/11] block: introduce a write_stream_granularity queue
 limit
Date: Tue,  6 May 2025 17:47:25 +0530
Message-Id: <20250506121732.8211-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvC4Dg1SGwdIrShZzVm1jtFh9t5/N
	Ys+iSUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22LP3pMsFvOXPWW32PZ7PrMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Nh8utrj8ya5AI4oLpuU1JzMstQifbsEroxbL/Yz
	FtyVqDj/lbOBcb9oFyMnh4SAicTWE5fZuxi5OIQEdjNK3Ds8kxkiIS7RfO0HO4QtLLHy33Oo
	oo+MEk0Tt7F0MXJwsAloSlyYXApSIyIQIPFy8WNmkBpmgQ+MEnsmzmYESQgLBEnMbv4ENpRF
	QFXizepFTCC9vALmEn17CyDmy0vMvPQdbBengIXE8j2zwFqFgEpeHD0CFucVEJQ4OfMJC4jN
	DFTfvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nz002LDDMSy3XK07MLS7NS9dLzs/dxAiOCC2N
	HYzvvjXpH2Jk4mA8xCjBwawkwnv/vmSGEG9KYmVValF+fFFpTmrxIUZpDhYlcd6VhhHpQgLp
	iSWp2ampBalFMFkmDk6pBqaJD4PNP+hkxfSLXnDu99lmJWb/6IX/jcKeeT+mzOQ+uavE9FyY
	U73Y5UVibN/qci4uiOs9ufJ9xJ7ka4t7Fs5NK9C+25np38cgep15R0f/ySsC63Ze2fIoL7RO
	ouvF/ZoVlr+kMl9kFig8P6dbvXyDtbfbar4GvySnQpfnh9bNDOBjYDruPdfuevnxJjuV3L9F
	LJmbPNI2rd/85kT4hJjUl+t4yo9zhp9KuhpkxfovxOEzyx6plbPqUi0vcZ4K7Z05W0VkGovU
	9unnTl1mlXwozNK36G76p+2aax3DgtmPS82dr79N58Ue5/3L/RfMX7ma90PEsQ91z1ekV8/h
	qLv9QGR9xq13OR/3qZ5W+9ekxFKckWioxVxUnAgA6vArCPcCAAA=
X-CMS-MailID: 20250506122640epcas5p43b5abe6562ad64ee1d7254b1215906d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122640epcas5p43b5abe6562ad64ee1d7254b1215906d4
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122640epcas5p43b5abe6562ad64ee1d7254b1215906d4@epcas5p4.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Export the granularity that write streams should be discarded with,
as it is essential for making good use of them.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 Documentation/ABI/stable/sysfs-block | 8 ++++++++
 block/blk-sysfs.c                    | 3 +++
 include/linux/blkdev.h               | 1 +
 3 files changed, 12 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 8bbe1eca28df..4ba771b56b3b 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -555,6 +555,14 @@ Description:
 		supported. If supported, valid values are 1 through
 		max_write_streams, inclusive.
 
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
index 986cdba4f550..ed00dedfb9ce 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -135,6 +135,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
 QUEUE_SYSFS_LIMIT_SHOW(max_write_streams)
+QUEUE_SYSFS_LIMIT_SHOW(write_stream_granularity)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -490,6 +491,7 @@ QUEUE_LIM_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_LIM_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_LIM_RO_ENTRY(queue_max_segment_size, "max_segment_size");
 QUEUE_LIM_RO_ENTRY(queue_max_write_streams, "max_write_streams");
+QUEUE_LIM_RO_ENTRY(queue_write_stream_granularity, "write_stream_granularity");
 QUEUE_RW_ENTRY(elv_iosched, "scheduler");
 
 QUEUE_LIM_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -645,6 +647,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
 	&queue_max_write_streams_entry.attr,
+	&queue_write_stream_granularity_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3747fbbd65fa..886009b6c3e5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -403,6 +403,7 @@ struct queue_limits {
 	unsigned short		max_discard_segments;
 
 	unsigned short		max_write_streams;
+	unsigned int		write_stream_granularity;
 
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
-- 
2.25.1


