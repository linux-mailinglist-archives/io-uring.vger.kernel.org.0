Return-Path: <io-uring+bounces-4821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BF09D257C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1691D2845D5
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6941CEAD0;
	Tue, 19 Nov 2024 12:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qeePtjZX"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B461CDFD1;
	Tue, 19 Nov 2024 12:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018621; cv=none; b=X/9A66aE5V8Fihqs6y41bXzDs5/R+AaW5Xn88XK5gT5oNoRrTUHFONiaTK2MFuczw6XNOF0sstUh/96pKurq1kxOy3KeteaNOfTUrSjRA7rgU793RdczEZLYWzThpKiqeuWdgH+BaYhjKyWwRAFZshOJ0x2QFNuS0Y/9ZiA0+ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018621; c=relaxed/simple;
	bh=G3OhZoNPeqafjhWSjs/wFTomnt0V6qUyGYnXonXgjF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idhAnEwlMX88NrBgRhQlXziFdLbhgznyF3lVKAhQWfj+DqxEp+h1KP3KODWpJYevCAbXQsxl2hoZhTDmwxskfm5UOGlFiQCwCsF05I+GGK+OlZK7F0HtdGtnFApBUo/aHxoKDfHbYbjzEPVyL/G/aloUk/dCajEr4WmIKweDRxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qeePtjZX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CvqY3cPqB1wQ6o4YF0pmFYAwVVeww6iPefJx83TZ+DM=; b=qeePtjZXJciAZogkGML+6X6j1J
	VP5OVB4FsyidKET985y65wtU1NvevhlZNnuszPb/fA3WIHZu2RGUsb72571v2/fozYlLmnce82EKZ
	evTNAXCco9pSljXXqHadRKhQKvdpiFSI5kSwQFBTiy0XNqWPlHl0Lb1Q+vrYevLIulVyp78VoeSfs
	YGkNJa1XiDgaJLjOXUJJXY2L0OIJ/DBAsM4W6hUO+zcCsc+2lnC+khHj5bWGMe6yENldCzr/kptTt
	W5nRq/7yZMUzdOW/WNIcSkzcrt/gwZTnNNzTL8zPZU0VX25bhq52ym9J/oHdqRyTr8Roo4fChJgX8
	nGQikq+A==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNA8-0000000CJ1e-3iPv;
	Tue, 19 Nov 2024 12:16:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 07/15] block: introduce max_write_streams queue limit
Date: Tue, 19 Nov 2024 13:16:21 +0100
Message-ID: <20241119121632.1225556-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Keith Busch <kbusch@kernel.org>

Drivers with hardware that support write streams need a way to export how
many are available so applications can generically query this.

Note: compared to Keith's origina version this does not automatically
stack the limit.  There is no good way to generically stack them.  For
mirroring or striping just mirroring the write streams will work, but
for everything more complex the stacking drive actually needs to manage
them.

Signed-off-by: Keith Busch <kbusch@kernel.org>
[hch: renamed from max_write_hints to max_write_streams]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/ABI/stable/sysfs-block | 7 +++++++
 block/blk-sysfs.c                    | 3 +++
 include/linux/blkdev.h               | 9 +++++++++
 3 files changed, 19 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 835361110715..ae8644726422 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -506,6 +506,13 @@ Description:
 		[RO] Maximum size in bytes of a single element in a DMA
 		scatter/gather list.
 
+What:		/sys/block/<disk>/queue/max_write_streams
+Date:		November 2024
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] Maximum number of write streams supported, 0 if not
+		supported. If supported, valid values are 1 through
+		max_write_streams, inclusive.
 
 What:		/sys/block/<disk>/queue/max_segments
 Date:		March 2010
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4241aea84161..c514c0cb5e93 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -104,6 +104,7 @@ QUEUE_SYSFS_LIMIT_SHOW(max_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_discard_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_integrity_segments)
 QUEUE_SYSFS_LIMIT_SHOW(max_segment_size)
+QUEUE_SYSFS_LIMIT_SHOW(max_write_streams)
 QUEUE_SYSFS_LIMIT_SHOW(logical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(physical_block_size)
 QUEUE_SYSFS_LIMIT_SHOW(chunk_sectors)
@@ -446,6 +447,7 @@ QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_kb");
 QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
 QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
 QUEUE_RO_ENTRY(queue_max_segment_size, "max_segment_size");
+QUEUE_RO_ENTRY(queue_max_write_streams, "max_write_streams");
 QUEUE_RW_LOAD_MODULE_ENTRY(elv_iosched, "scheduler");
 
 QUEUE_RO_ENTRY(queue_logical_block_size, "logical_block_size");
@@ -580,6 +582,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_max_discard_segments_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
+	&queue_max_write_streams_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a1fd0ddce5cf..202e1becd410 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -395,6 +395,8 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
 
+	unsigned short		max_write_streams;
+
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
 
@@ -1236,6 +1238,13 @@ static inline unsigned int bdev_max_segments(struct block_device *bdev)
 	return queue_max_segments(bdev_get_queue(bdev));
 }
 
+static inline unsigned short bdev_max_write_streams(struct block_device *bdev)
+{
+	if (bdev_is_partition(bdev))
+		return 0;
+	return bdev_limits(bdev)->max_write_streams;
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	return q->limits.logical_block_size;
-- 
2.45.2


