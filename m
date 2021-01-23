Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7683014E7
	for <lists+io-uring@lfdr.de>; Sat, 23 Jan 2021 12:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbhAWLwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 06:52:22 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:40402 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbhAWLwW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 06:52:22 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2021 06:52:20 EST
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 9010F7F43D; Sat, 23 Jan 2021 13:41:52 +0200 (EET)
Date:   Sat, 23 Jan 2021 13:41:52 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210123114152.GA120281@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
arguments.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
This seems to work OK, but I'd appreciate a review from someone more
familiar with io_uring internals than I am, as I'm not entirely sure
I did everything quite right.

A dumb test program for IORING_OP_GETDENTS64 is available here:

	https://krautbox.wantstofly.org/~buytenh/uringfind.c

This does more or less what find(1) does: it scans recursively through
a directory tree and prints the names of all directories and files it
encounters along the way -- but then using io_uring.  (The uring version
prints the names of encountered files and directories in an order that's
determined by SQE completion order, which is somewhat nondeterministic
and likely to differ between runs.)

On a directory tree with 14-odd million files in it that's on a
six-drive (spinning disk) btrfs raid, find(1) takes:

	# echo 3 > /proc/sys/vm/drop_caches 
	# time find /mnt/repo > /dev/null

	real    24m7.815s
	user    0m15.015s
	sys     0m48.340s
	#

And the io_uring version takes:

	# echo 3 > /proc/sys/vm/drop_caches 
	# time ./uringfind /mnt/repo > /dev/null

	real    10m29.064s
	user    0m4.347s
	sys     0m1.677s
	#

These timings are repeatable and consistent to within a few seconds.

(btrfs seems to be sending most metadata reads to the same drive in the
array during this test, even though this filesystem is using the raid1c4
profile for metadata, so I suspect that more drive-level parallelism can
be extracted with some btrfs tweaks.)

The fully cached case also shows some speedup for the io_uring version:

	# time find /mnt/repo > /dev/null

	real    0m5.223s
	user    0m1.926s
	sys     0m3.268s
	#

vs:

	# time ./uringfind /mnt/repo > /dev/null

	real    0m3.604s
	user    0m2.417s
	sys     0m0.793s
	#

That said, the point of this patch isn't primarily to enable
lightning-fast find(1) or du(1), but more to complete the set of
filesystem I/O primitives available via io_uring, so that applications
can do all of their filesystem I/O using the same mechanism, without
having to manually punt some of their work out to worker threads -- and
indeed, an object storage backend server that I wrote a while ago can
run with a pure io_uring based event loop with this patch.

One open question is whether IORING_OP_GETDENTS64 should be more like
pread(2) and allow passing in a starting offset to read from the
directory from.  (This would require some more surgery in fs/readdir.c.)

 fs/io_uring.c                 |   51 ++++++++++++++++++++++++++++++++++++++++++
 fs/readdir.c                  |   25 ++++++++++++++------
 include/linux/fs.h            |    4 +++
 include/uapi/linux/io_uring.h |    1 
 4 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3f976d..5d79b9668ee0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -572,6 +572,12 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_getdents64 {
+	struct file			*file;
+	struct linux_dirent64 __user	*dirent;
+	unsigned int			count;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -699,6 +705,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_getdents64	getdents64;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -987,6 +994,11 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_GETDENTS64] = {
+		.needs_file		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -4552,6 +4564,40 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+static int io_getdents64_prep(struct io_kiocb *req,
+			      const struct io_uring_sqe *sqe)
+{
+	struct io_getdents64 *getdents64 = &req->getdents64;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	getdents64->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	getdents64->count = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_getdents64(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_getdents64 *getdents64 = &req->getdents64;
+	int ret;
+
+	/* getdents64 always requires a blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = vfs_getdents64(req->file, getdents64->dirent, getdents64->count);
+	if (ret < 0) {
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail_links(req);
+	}
+	io_req_complete(req, ret);
+	return 0;
+}
+
 #if defined(CONFIG_NET)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
@@ -6078,6 +6124,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_GETDENTS64:
+		return io_getdents64_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6337,6 +6385,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_GETDENTS64:
+		ret = io_getdents64(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/readdir.c b/fs/readdir.c
index 19434b3c982c..5310677d5d36 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -348,10 +348,9 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return -EFAULT;
 }
 
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+int vfs_getdents64(struct file *file, struct linux_dirent64 __user *dirent,
+		   unsigned int count)
 {
-	struct fd f;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -359,11 +358,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	};
 	int error;
 
-	f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error = iterate_dir(f.file, &buf.ctx);
+	error = iterate_dir(file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -376,6 +371,20 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error = count - buf.count;
 	}
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f = fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = vfs_getdents64(f.file, dirent, count);
 	fdput_pos(f);
 	return error;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..602202a8fc1f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3109,6 +3109,10 @@ extern const struct inode_operations simple_symlink_inode_operations;
 
 extern int iterate_dir(struct file *, struct dir_context *);
 
+struct linux_dirent64;
+int vfs_getdents64(struct file *file, struct linux_dirent64 __user *dirent,
+		   unsigned int count);
+
 int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 		int flags);
 int vfs_fstat(int fd, struct kstat *stat);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1e8ef9..5602414735f7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_GETDENTS64,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
