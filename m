Return-Path: <io-uring+bounces-4829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6269D259D
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 740EC1F249D1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D14F1D0F50;
	Tue, 19 Nov 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MGZmuUG5"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064E01D0E3A;
	Tue, 19 Nov 2024 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018642; cv=none; b=maLenixWJr2KI9/8mWwp313dEQLo8dRkQWb2fwYkOEuYs1NFa5bT9v5O5P2JeMPpEFvdh0k/OoGq3iHc7wv1gH2W7uFGvCeFKVMTsyRTf61cahDTan2GuTTIdf5ukZdxwiboAxEZIKSF0p4lBPaJaMkniz86rcvrQ7V1SleZ3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018642; c=relaxed/simple;
	bh=0mruMxanft8RAOOhOn+R3dNkn6CDPrf8czsoxHAKvXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lvic9p91K4ZYNM+s+0Vtla7RuXqvRt4W7SC2Z2ClFfe6O4y7oz4oARySN+2cijIt2WbDyWO6sHQKKZb4evS0+ZxVb7MrePkb0jqPEBYe98WOAz6fj2A0xQdE/9zXGicMoD3dRYhinKcJ/Rb9nZLyyZ/m7WoihW+OCG9PBguOsNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MGZmuUG5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hi5wiGxgAmC0Cdjfsdl0g9zpBk10TijhAP5DsB115+4=; b=MGZmuUG5w97cSfwF4J9cGxZDwy
	aQzYCs6GoMDxhAgTIEdPCDR6J1HIu4GhTxJAg+TsGHVkk68cn8ptBmGgiYZCzLdkLJGIcLfNWZSKn
	X7q5icZsgLRFz1BosbfqEbsldSPfV4+7g4iZKzDrLyq5slY16l4mXKUdi2RrWb/phgNLkeNH5QEma
	//fyzeaQaMnHJ+d2K7tgHHVz4CKSUJqddal4HKFBZMND34ccirDLLdDAzvSKdtxXu2zQFayvqFQhT
	PzgpO19j/8Ew8xuL9cJW24D1IVNkQ2MH53TMv0abWK0UvDfi+ZhoPGrAA0NBQAlsPMnAzR++RjZiO
	tDWKDm7Q==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNAT-0000000CJP8-3EaH;
	Tue, 19 Nov 2024 12:17:18 +0000
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
Subject: [PATCH 15/15] RFC: block: allow write streams on partitions
Date: Tue, 19 Nov 2024 13:16:29 +0100
Message-ID: <20241119121632.1225556-16-hch@lst.de>
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

By default assign all write streams to partition 1, and add a hack
sysfs files that distributes them all equally.

This is implemented by storing the number of per-partition write
streams in struct block device, as well as the offset to the global
ones, and then remapping the write streams in the I/O submission
path.

The sysfs is hacky and undocumented, better suggestions welcome
from actual users of write stream on partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c              |  9 +++++++
 block/blk-core.c          |  2 ++
 block/genhd.c             | 52 +++++++++++++++++++++++++++++++++++++++
 block/partitions/core.c   |  6 +++--
 include/linux/blk_types.h |  7 ++++++
 include/linux/blkdev.h    |  2 +-
 6 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index c23245f1fdfe..f3549a8cdb3f 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -440,6 +440,15 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 		return NULL;
 	}
 	bdev->bd_disk = disk;
+
+	/*
+	 * Assign all write streams to the first partition by default.
+	 */
+	if (partno == 1) {
+		bdev->bd_part_write_stream_start = 0;
+		bdev->bd_part_write_streams = bdev_max_write_streams(bdev);
+	}
+
 	return bdev;
 }
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 666efe8fa202..9654937f9b2d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -574,6 +574,8 @@ static int blk_partition_remap(struct bio *bio)
 		return -EIO;
 	if (bio_sectors(bio)) {
 		bio->bi_iter.bi_sector += p->bd_start_sect;
+		if (bio->bi_write_stream)
+			bio->bi_write_stream += p->bd_part_write_stream_start;
 		trace_block_bio_remap(bio, p->bd_dev,
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
diff --git a/block/genhd.c b/block/genhd.c
index 79230c109fca..3156c70522b6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1070,6 +1070,54 @@ static ssize_t partscan_show(struct device *dev,
 	return sysfs_emit(buf, "%u\n", disk_has_partscan(dev_to_disk(dev)));
 }
 
+static ssize_t disk_distribute_write_streams_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	/* Anything useful to show here like the ranges? */
+	return sysfs_emit(buf, "0\n");
+}
+
+static ssize_t disk_distribute_write_streams_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct block_device *bdev = disk->part0, *part;
+	unsigned short total_write_streams =
+		disk->queue->limits.max_write_streams;
+	unsigned short part_write_streams, part_write_stream_start = 0;
+	unsigned long nr_partitions = 0, idx;
+	int error = 0;
+
+	if (!total_write_streams)
+		return -EINVAL;
+
+	mutex_lock(&disk->open_mutex);
+	if (atomic_read(&bdev->bd_openers)) {
+		error = -EBUSY;
+		goto out_unlock;
+	}
+
+	xa_for_each_start(&disk->part_tbl, idx, part, 1)
+		nr_partitions++;
+	if (!nr_partitions)
+		goto out_unlock;
+
+	part_write_streams = total_write_streams / nr_partitions;
+	xa_for_each_start(&disk->part_tbl, idx, part, 1) {
+		part->bd_part_write_streams = part_write_streams;
+		part->bd_part_write_stream_start = part_write_stream_start;
+		part_write_stream_start += part_write_streams;
+		dev_info(dev,
+			"assigning %u write streams at %u to partition %lu\n",
+			part_write_streams, part_write_stream_start, idx - 1);
+	}
+out_unlock:
+	mutex_unlock(&disk->open_mutex);
+	if (error)
+		return error;
+	return count;
+}
+
 static DEVICE_ATTR(range, 0444, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, 0444, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, 0444, disk_removable_show, NULL);
@@ -1084,6 +1132,9 @@ static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
 static DEVICE_ATTR(badblocks, 0644, disk_badblocks_show, disk_badblocks_store);
 static DEVICE_ATTR(diskseq, 0444, diskseq_show, NULL);
 static DEVICE_ATTR(partscan, 0444, partscan_show, NULL);
+static DEVICE_ATTR(distribute_write_streams, 0644,
+	disk_distribute_write_streams_show,
+	disk_distribute_write_streams_store);
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
@@ -1135,6 +1186,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_events_poll_msecs.attr,
 	&dev_attr_diskseq.attr,
 	&dev_attr_partscan.attr,
+	&dev_attr_distribute_write_streams.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 815ed33caa1b..a27dbb5589ce 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -245,8 +245,10 @@ static const struct attribute_group *part_attr_groups[] = {
 
 static void part_release(struct device *dev)
 {
-	put_disk(dev_to_bdev(dev)->bd_disk);
-	bdev_drop(dev_to_bdev(dev));
+	struct block_device *part = dev_to_bdev(dev);
+
+	put_disk(part->bd_disk);
+	bdev_drop(part);
 }
 
 static int part_uevent(const struct device *dev, struct kobj_uevent_env *env)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4ca3449ce9c9..02a3d58e814f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -74,6 +74,13 @@ struct block_device {
 #ifdef CONFIG_SECURITY
 	void			*bd_security;
 #endif
+
+	/*
+	 * Allow assigning write streams to partitions.
+	 */
+	unsigned short		bd_part_write_streams;
+	unsigned short		bd_part_write_stream_start;
+
 	/*
 	 * keep this out-of-line as it's both big and not needed in the fast
 	 * path
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9fda66530d9a..bb0921e642fb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1242,7 +1242,7 @@ static inline unsigned int bdev_max_segments(struct block_device *bdev)
 static inline unsigned short bdev_max_write_streams(struct block_device *bdev)
 {
 	if (bdev_is_partition(bdev))
-		return 0;
+		return bdev->bd_part_write_streams;
 	return bdev_limits(bdev)->max_write_streams;
 }
 
-- 
2.45.2


