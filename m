Return-Path: <io-uring+bounces-1248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DEA88EB90
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E069129EF48
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 16:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DC914D422;
	Wed, 27 Mar 2024 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYMjCzr7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1AA14D420;
	Wed, 27 Mar 2024 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557962; cv=none; b=LX4B/QIYjC2nK8LlFyrtMl9wtFTwmU5Amjqi7RwFKpxuE3skkXK7xDBudV6x7ryZYngfDRYdxnSMpQB1zelMEehnwu9bYANTeRT7cpzGzJD2xBlcjafm7BVJZJ1TIkOPvb+yJZQuT2AGLTdy0H8tSkXdvLNyk/UryCN2YQchmLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557962; c=relaxed/simple;
	bh=5bra0aGVJyAlPp86GdSCApT1pD4XtUTbN9yyw6gpOnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e5qCR82ZzQ7tF1sn16HomFKWkku4l0MEYKYT6s1e0HWubAFVcq6TFING15dDcUSlAKp3J8MBdZwgPCqR+OuvqsOe49xDxBCnqbocxjYjsE81RJHjUMEkCL0C480Y76we0DIZnAxdUdAcBhDvTw9DoUH8YpZOOr/ta3KhW89Bzek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYMjCzr7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69755C433F1;
	Wed, 27 Mar 2024 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711557962;
	bh=5bra0aGVJyAlPp86GdSCApT1pD4XtUTbN9yyw6gpOnQ=;
	h=From:To:Cc:Subject:Date:From;
	b=DYMjCzr7gfyfCRHBTXdn8CPXuDaXTNNiWD9JlkJ57LVjQmFqjsiKUQxbiKbXXsJrl
	 b712uFFlovVjhhrPt9jy/VwNEhzYKUh2r9l1l88zPAjrkiUN5uJvS8gt/T01BKynzC
	 rEwP14FNkVeg7WRYjVpgC7WozUXTj1aSCjBYj5iXUbEQekoKu9H+x9Pz34ntSAyj6n
	 hq7QLnI/DuepTbrGqeCTdqB7ePLGfIDHlRMSrJwrAghm1cr1fI4H9/8Gu5bP24HQMm
	 DZEgsGZ/iLhfHwR1aCzHznoAlyhMQ35Jikvc/ERLYBYPaPhcHe+TjzwBH0C+mwtpMG
	 jG47A4toH6Jbg==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	io-uring@vger.kernel.org
Subject: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Date: Wed, 27 Mar 2024 17:45:09 +0100
Message-ID: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12207; i=brauner@kernel.org; h=from:subject:message-id; bh=5bra0aGVJyAlPp86GdSCApT1pD4XtUTbN9yyw6gpOnQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSx+Ipu3HGi0nTrlUTbApZTzJPuObya6bzq2aVViobzp 5nceije11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARoTxGhufC4tpHjCtW/Sst VnVslnBUWLHgbHBWbsbEOyck2B26jjEyfDh4c1L7Swf3/arWjgwrTQ7NeXx/3W3r6EMNuTtnPGm bywEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

There's a bunch of flags that are purely based on what the file
operations support while also never being conditionally set or unset.
IOW, they're not subject to change for individual file opens. Imho, such
flags don't need to live in f_mode they might as well live in the fops
structs itself. And the fops struct already has that lonely
mmap_supported_flags member. We might as well turn that into a generic
fops_flags member and move a few flags from FMODE_* space into FOP_*
space. That gets us four FMODE_* bits back and the ability for new
static flags that are about file ops to not have to live in FMODE_*
space but in their own FOP_* space. It's not the most beautiful thing
ever but it gets the job done. Yes, there'll be an additional pointer
chase but hopefully that won't matter for these flags.

If this is palatable I suspect there's a few more we can move into there
and that we can also redirect new flag suggestions that follow this
pattern into the fops_flags field instead of f_mode. As of yet untested.

(Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
 well because they're also completely static but they aren't really
 about file operations so they're better suited for FMODE_* imho.)

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 block/bdev.c         |  2 +-
 block/fops.c         |  1 +
 drivers/dax/device.c |  2 +-
 fs/btrfs/file.c      |  4 ++--
 fs/ext4/file.c       |  6 +++---
 fs/f2fs/file.c       |  3 ++-
 fs/read_write.c      |  3 +--
 fs/xfs/xfs_file.c    |  8 +++++---
 include/linux/fs.h   | 25 +++++++++++++++----------
 io_uring/io_uring.c  |  2 +-
 io_uring/rw.c        |  4 ++--
 mm/mmap.c            |  3 ++-
 12 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index b8e32d933a63..dd26d37356aa 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -903,7 +903,7 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
 		disk_unblock_events(disk);
 
 	bdev_file->f_flags |= O_LARGEFILE;
-	bdev_file->f_mode |= FMODE_BUF_RASYNC | FMODE_CAN_ODIRECT;
+	bdev_file->f_mode |= FMODE_CAN_ODIRECT;
 	if (bdev_nowait(bdev))
 		bdev_file->f_mode |= FMODE_NOWAIT;
 	if (mode & BLK_OPEN_RESTRICT_WRITES)
diff --git a/block/fops.c b/block/fops.c
index 679d9b752fe8..a4c61cf55994 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -863,6 +863,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.fops_flags	= FOP_BUF_RASYNC,
 };
 
 static __init int blkdev_init(void)
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 93ebedc5ec8c..9ffc63e21af2 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -377,7 +377,7 @@ static const struct file_operations dax_fops = {
 	.release = dax_release,
 	.get_unmapped_area = dax_get_unmapped_area,
 	.mmap = dax_mmap,
-	.mmap_supported_flags = MAP_SYNC,
+	.fops_flags = FOP_MMAP_SYNC,
 };
 
 static void dev_dax_cdev_del(void *cdev)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f9d76072398d..704eae616281 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3719,8 +3719,7 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
 	int ret;
 
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
-		        FMODE_CAN_ODIRECT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 
 	ret = fsverity_file_open(inode, filp);
 	if (ret)
@@ -3850,6 +3849,7 @@ const struct file_operations btrfs_file_operations = {
 	.compat_ioctl	= btrfs_compat_ioctl,
 #endif
 	.remap_file_range = btrfs_remap_file_range,
+	.fops_flags	= FOP_BUF_RASYNC | FOP_BUF_WASYNC,
 };
 
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 54d6ff22585c..7deaad4a1178 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -885,8 +885,7 @@ static int ext4_file_open(struct inode *inode, struct file *filp)
 			return ret;
 	}
 
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC |
-			FMODE_DIO_PARALLEL_WRITE;
+	filp->f_mode |= FMODE_NOWAIT;
 	return dquot_file_open(inode, filp);
 }
 
@@ -938,7 +937,6 @@ const struct file_operations ext4_file_operations = {
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
 	.mmap		= ext4_file_mmap,
-	.mmap_supported_flags = MAP_SYNC,
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
@@ -946,6 +944,8 @@ const struct file_operations ext4_file_operations = {
 	.splice_read	= ext4_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
+	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC |
+			  FOP_DIO_PARALLEL_WRITE,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1761ad125f97..fea5ef1a36e8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -569,7 +569,7 @@ static int f2fs_file_open(struct inode *inode, struct file *filp)
 	if (err)
 		return err;
 
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |= FMODE_NOWAIT;
 	filp->f_mode |= FMODE_CAN_ODIRECT;
 
 	return dquot_file_open(inode, filp);
@@ -5045,4 +5045,5 @@ const struct file_operations f2fs_file_operations = {
 	.splice_read	= f2fs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fadvise	= f2fs_file_fadvise,
+	.fops_flags	= FOP_BUF_RASYNC,
 };
diff --git a/fs/read_write.c b/fs/read_write.c
index d4c036e82b6c..1b9f6ce1aec9 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1684,8 +1684,7 @@ int generic_write_checks_count(struct kiocb *iocb, loff_t *count)
 		iocb->ki_pos = i_size_read(inode);
 
 	if ((iocb->ki_flags & IOCB_NOWAIT) &&
-	    !((iocb->ki_flags & IOCB_DIRECT) ||
-	      (file->f_mode & FMODE_BUF_WASYNC)))
+	    !((iocb->ki_flags & IOCB_DIRECT) || fops_buf_wasync(file)))
 		return -EINVAL;
 
 	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 632653e00906..d13e21eb9a3c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1230,8 +1230,7 @@ xfs_file_open(
 {
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
-			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
+	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	return generic_file_open(inode, file);
 }
 
@@ -1490,7 +1489,6 @@ const struct file_operations xfs_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.mmap		= xfs_file_mmap,
-	.mmap_supported_flags = MAP_SYNC,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
@@ -1498,6 +1496,8 @@ const struct file_operations xfs_file_operations = {
 	.fallocate	= xfs_file_fallocate,
 	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
+	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
+			  FOP_DIO_PARALLEL_WRITE,
 };
 
 const struct file_operations xfs_dir_file_operations = {
@@ -1510,4 +1510,6 @@ const struct file_operations xfs_dir_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.fsync		= xfs_dir_fsync,
+	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
+			  FOP_DIO_PARALLEL_WRITE,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8dfd53b52744..1e2c843c7b8c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -165,9 +165,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 #define	FMODE_NOREUSE		((__force fmode_t)0x800000)
 
-/* File supports non-exclusive O_DIRECT writes from multiple threads */
-#define FMODE_DIO_PARALLEL_WRITE	((__force fmode_t)0x1000000)
-
 /* File is embedded in backing_file object */
 #define FMODE_BACKING		((__force fmode_t)0x2000000)
 
@@ -183,12 +180,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
 
-/* File supports async buffered reads */
-#define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
-
-/* File supports async nowait buffered writes */
-#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
-
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
@@ -2005,6 +1996,7 @@ struct offset_ctx;
 
 struct file_operations {
 	struct module *owner;
+	unsigned int fops_flags;
 	loff_t (*llseek) (struct file *, loff_t, int);
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
@@ -2017,7 +2009,6 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-	unsigned long mmap_supported_flags;
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
@@ -2048,6 +2039,20 @@ struct file_operations {
 				unsigned int poll_flags);
 } __randomize_layout;
 
+/* File ops support async buffered reads */
+#define FOP_BUF_RASYNC		BIT(0)
+/* File ops support async nowait buffered writes */
+#define FOP_BUF_WASYNC		BIT(1)
+#define FOP_MMAP_SYNC		BIT(2)
+/* File ops support non-exclusive O_DIRECT writes from multiple threads */
+#define FOP_DIO_PARALLEL_WRITE	BIT(3)
+
+#define __fops_supported(f_op, flag) ((f_op)->fops_flags & (flag))
+#define fops_buf_rasync(file) __fops_supported((file)->f_op, FOP_BUF_RASYNC)
+#define fops_buf_wasync(file) __fops_supported((file)->f_op, FOP_BUF_WASYNC)
+#define fops_mmap_sync(file) __fops_supported((file)->f_op, FOP_MMAP_SYNC)
+#define fops_dio_parallel_write(file) __fops_supported((file)->f_op, FOP_DIO_PARALLEL_WRITE)
+
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
 			    int (*) (struct file *, struct dir_context *));
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..dbf879fc128a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -471,7 +471,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 		/* don't serialize this request if the fs doesn't need it */
 		if (should_hash && (req->file->f_flags & O_DIRECT) &&
-		    (req->file->f_mode & FMODE_DIO_PARALLEL_WRITE))
+		    fops_dio_parallel_write(req->file))
 			should_hash = false;
 		if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0585ebcc9773..dd3e802bd4bf 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -683,7 +683,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
 	 */
-	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+	if (io_file_can_poll(req) || !fops_buf_rasync(req->file))
 		return false;
 
 	wait->wait.func = io_async_buf_func;
@@ -1024,7 +1024,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 		/* File path supports NOWAIT for non-direct_IO only for block devices. */
 		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
-			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
+			!fops_buf_wasync(kiocb->ki_filp) &&
 			(req->flags & REQ_F_ISREG))
 			goto copy_iov;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 6dbda99a47da..0115fc376428 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1294,7 +1294,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		if (!file_mmap_ok(file, inode, pgoff, len))
 			return -EOVERFLOW;
 
-		flags_mask = LEGACY_MAP_MASK | file->f_op->mmap_supported_flags;
+		if (fops_mmap_sync(file))
+			flags_mask |= MAP_SYNC;
 
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
-- 
2.43.0


