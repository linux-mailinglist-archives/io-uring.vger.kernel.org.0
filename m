Return-Path: <io-uring+bounces-5257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EC79E63AF
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 02:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5FF528571F
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 01:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C121E871;
	Fri,  6 Dec 2024 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CAmUP0Ow"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5313C677
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 01:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733450011; cv=none; b=n0Netxhs3vGKQ70+cWRsOH+Go9twZgtJbTW2aMNu3tMYhj4ErVtC/RAwuEw2mdG0x4LmrIycH+Mjmh8P+Yp52UKFJONIMu7pCRZI52kWDka6qanMdepLmpQH9nZrQmzpHdn/3PAnwdsHEIY19JQNMXI1cZ2e1G6WdsTZw1vkOyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733450011; c=relaxed/simple;
	bh=yHXFvDsEeK5TRGak0SpI6LYPt8+i/ACjWPHS2Ewq/9I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VKXtcP8m4LpVlTyTAKyFCzL+cPp1JKjgq1hYpvKlgEj1u0YWh6ZZW3Qn7htdjiMh2eoJxZnz86hCSB4P81DQfqAcWY+aI09vDF+IF91RzeTI4PVAB1IV+5VuS1+IrHWtR3uQNlDzwrJcyDj4fMinAAj0R4sYT77IrlrlfriKWd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CAmUP0Ow; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B603IVL012398
	for <io-uring@vger.kernel.org>; Thu, 5 Dec 2024 17:53:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=H1449KeqBHH2qLyX/UaGXiOFOGfVyFVyzOCCtWJaXls=; b=CAmUP0OwnaBe
	AZlMffA9J5WHd+5HmYW3a3yQ1M3kgnO5N7sxx7y9FfPPT2Jh5xEtYJ0KBZi+zSZU
	QDSfmTII3zudYRRZvi4o2iuDJHbd4o6iGy/YdHJh/kYN+d+VEpgNMKZrdiTwcxRK
	YmcsMvcH4mIF07xzggbtOS6W/tL1eqFhI2PWWpjVQL/win9zSaSmF85hs4l04LHY
	/0JWOCSvuOGCo+37omWz61VuSRpMio19dw0YVlywR+Q9tht44Vm7B/uMdnavV0Pa
	NBmyh4UIBtyp8eFBqL5e8up84IbPXiyLni/YmxhhUDltrZWa2U+IzHpxFvAhB7Ji
	+OlnwgVUzw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43bgr8udwa-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 05 Dec 2024 17:53:28 -0800 (PST)
Received: from twshared32179.32.frc3.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 01:53:22 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 312B315B21155; Thu,  5 Dec 2024 17:53:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 06/10] block: introduce a write_stream_granularity queue limit
Date: Thu, 5 Dec 2024 17:53:04 -0800
Message-ID: <20241206015308.3342386-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206015308.3342386-1-kbusch@meta.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fBt9DoCXizgs7IVE0Q1zvoa4fgWq4QYc
X-Proofpoint-ORIG-GUID: fBt9DoCXizgs7IVE0Q1zvoa4fgWq4QYc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

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


