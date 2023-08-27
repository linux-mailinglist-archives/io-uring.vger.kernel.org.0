Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F7789F3E
	for <lists+io-uring@lfdr.de>; Sun, 27 Aug 2023 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjH0Neo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Aug 2023 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjH0NeV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Aug 2023 09:34:21 -0400
Received: from out-249.mta1.migadu.com (out-249.mta1.migadu.com [IPv6:2001:41d0:203:375::f9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEFFCC4;
        Sun, 27 Aug 2023 06:34:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693143249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SowR/5OB7dg0Ze+leVLqrAkBaJI/dvgnJq74oNV+rw=;
        b=QVXx/bTwdFCK3FigE3bkCbe2czyripMyGLUg4h+GStpxVumOjkcqldjziNgtEa+JIjEIdw
        2WdW9WAenCowl3yazyOwy/6Hrh3GC232u8ThOV7lZj17P/Dz8FfBitp2VsRMXLtCnx4lHo
        En1h8t6fO7bO07ca/V9kDbVI82xb9qY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Date:   Sun, 27 Aug 2023 21:28:31 +0800
Message-Id: <20230827132835.1373581-8-hao.xu@linux.dev>
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a boolean parameter for file_accessed() to support nowait semantics.
Currently it is true only with io_uring as its initial caller.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 arch/s390/hypfs/inode.c | 2 +-
 block/fops.c            | 2 +-
 fs/btrfs/file.c         | 2 +-
 fs/btrfs/inode.c        | 2 +-
 fs/coda/dir.c           | 4 ++--
 fs/ext2/file.c          | 4 ++--
 fs/ext4/file.c          | 6 +++---
 fs/f2fs/file.c          | 4 ++--
 fs/fuse/dax.c           | 2 +-
 fs/fuse/file.c          | 4 ++--
 fs/gfs2/file.c          | 2 +-
 fs/hugetlbfs/inode.c    | 2 +-
 fs/nilfs2/file.c        | 2 +-
 fs/orangefs/file.c      | 2 +-
 fs/orangefs/inode.c     | 2 +-
 fs/pipe.c               | 2 +-
 fs/ramfs/file-nommu.c   | 2 +-
 fs/readdir.c            | 2 +-
 fs/smb/client/cifsfs.c  | 2 +-
 fs/splice.c             | 2 +-
 fs/ubifs/file.c         | 2 +-
 fs/udf/file.c           | 2 +-
 fs/xfs/xfs_file.c       | 6 +++---
 fs/zonefs/file.c        | 4 ++--
 include/linux/fs.h      | 5 +++--
 mm/filemap.c            | 8 ++++----
 mm/shmem.c              | 6 +++---
 27 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index ee919bfc8186..55f562027c4f 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -157,7 +157,7 @@ static ssize_t hypfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!count)
 		return -EFAULT;
 	iocb->ki_pos = pos + count;
-	file_accessed(file);
+	file_accessed(file, false);
 	return count;
 }
 
diff --git a/block/fops.c b/block/fops.c
index a286bf3325c5..546ecd3c8084 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -601,7 +601,7 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		ret = kiocb_write_and_wait(iocb, count);
 		if (ret < 0)
 			goto reexpand;
-		file_accessed(iocb->ki_filp);
+		file_accessed(iocb->ki_filp, false);
 
 		ret = blkdev_direct_IO(iocb, to);
 		if (ret >= 0) {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fd03e689a6be..24c0bf3818a6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2013,7 +2013,7 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	if (!mapping->a_ops->read_folio)
 		return -ENOEXEC;
 
-	file_accessed(filp);
+	file_accessed(filp, false);
 	vma->vm_ops = &btrfs_file_vm_ops;
 
 	return 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbbb67293e34..50e9ae8c388c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10153,7 +10153,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct extent_map *em;
 	bool unlocked = false;
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 8450b1bd354b..1d94c013ac88 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -436,12 +436,12 @@ static int coda_readdir(struct file *coda_file, struct dir_context *ctx)
 			if (host_file->f_op->iterate_shared) {
 				inode_lock_shared(host_inode);
 				ret = host_file->f_op->iterate_shared(host_file, ctx);
-				file_accessed(host_file);
+				file_accessed(host_file, false);
 				inode_unlock_shared(host_inode);
 			} else {
 				inode_lock(host_inode);
 				ret = host_file->f_op->iterate(host_file, ctx);
-				file_accessed(host_file);
+				file_accessed(host_file, false);
 				inode_unlock(host_inode);
 			}
 		}
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 0b4c91c62e1f..dc059cae50a4 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -44,7 +44,7 @@ static ssize_t ext2_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ret = dax_iomap_rw(iocb, to, &ext2_iomap_ops);
 	inode_unlock_shared(inode);
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 	return ret;
 }
 
@@ -127,7 +127,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!IS_DAX(file_inode(file)))
 		return generic_file_mmap(file, vma);
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &ext2_dax_vm_ops;
 	return 0;
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index c457c8517f0f..2ab790a668a8 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -94,7 +94,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 	return ret;
 }
 
@@ -122,7 +122,7 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ret = dax_iomap_rw(iocb, to, &ext4_iomap_ops);
 	inode_unlock_shared(inode);
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 	return ret;
 }
 #endif
@@ -820,7 +820,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!daxdev_mapping_supported(vma, dax_dev))
 		return -EOPNOTSUPP;
 
-	file_accessed(file);
+	file_accessed(file, false);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
 		vm_flags_set(vma, VM_HUGEPAGE);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 093039dee992..246e61d78f92 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -524,7 +524,7 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!f2fs_is_compress_backend_ready(inode))
 		return -EOPNOTSUPP;
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &f2fs_file_vm_ops;
 	set_inode_flag(inode, FI_MMAP_FILE);
 	return 0;
@@ -4380,7 +4380,7 @@ static ssize_t f2fs_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	f2fs_up_read(&fi->i_gc_rwsem[READ]);
 
-	file_accessed(file);
+	file_accessed(file, false);
 out:
 	trace_f2fs_direct_IO_exit(inode, pos, count, READ, ret);
 	return ret;
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 8e74f278a3f6..8a43c37195dd 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -858,7 +858,7 @@ static const struct vm_operations_struct fuse_dax_vm_ops = {
 
 int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &fuse_dax_vm_ops;
 	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
 	return 0;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc4115288eec..3c4cbc5e2de6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2496,7 +2496,7 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
 		fuse_link_write_file(file);
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &fuse_file_vm_ops;
 	return 0;
 }
@@ -3193,7 +3193,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 		clear_bit(FUSE_I_SIZE_UNSTABLE, &fi_out->state);
 
 	inode_unlock(inode_out);
-	file_accessed(file_in);
+	file_accessed(file_in, false);
 
 	fuse_flush_time_update(inode_out);
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1bf3c4453516..3003be5b8266 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -601,7 +601,7 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 			return error;
 		/* grab lock to update inode */
 		gfs2_glock_dq_uninit(&i_gh);
-		file_accessed(file);
+		file_accessed(file, false);
 	}
 	vma->vm_ops = &gfs2_vm_ops;
 
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7b17ccfa039d..729f66346c3c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -161,7 +161,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	inode_lock(inode);
-	file_accessed(file);
+	file_accessed(file, false);
 
 	ret = -ENOMEM;
 	if (!hugetlb_reserve_pages(inode,
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index a9eb3487efb2..a857ebcf099c 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -119,7 +119,7 @@ static const struct vm_operations_struct nilfs_file_vm_ops = {
 
 static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &nilfs_file_vm_ops;
 	return 0;
 }
diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index d68372241b30..5c7a17995fe1 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -412,7 +412,7 @@ static int orangefs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	/* set the sequential readahead hint */
 	vm_flags_mod(vma, VM_SEQ_READ, VM_RAND_READ);
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &orangefs_file_vm_ops;
 	return 0;
 }
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 9014bbcc8031..77d56703bb09 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -597,7 +597,7 @@ static ssize_t orangefs_direct_IO(struct kiocb *iocb,
 		ret = total_count;
 	if (ret > 0) {
 		if (type == ORANGEFS_IO_READ) {
-			file_accessed(file);
+			file_accessed(file, false);
 		} else {
 			file_update_time(file);
 			if (*offset > i_size_read(inode))
diff --git a/fs/pipe.c b/fs/pipe.c
index 2d88f73f585a..ce1038d3de4b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -393,7 +393,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
 	kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	if (ret > 0)
-		file_accessed(filp);
+		file_accessed(filp, false);
 	return ret;
 }
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index efb1b4c1a0a4..ad69f828f6ad 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -267,7 +267,7 @@ static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!is_nommu_shared_mapping(vma->vm_flags))
 		return -ENOSYS;
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &generic_file_vm_ops;
 	return 0;
 }
diff --git a/fs/readdir.c b/fs/readdir.c
index b80caf4c9321..2f4c9c663a39 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -68,7 +68,7 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 			res = file->f_op->iterate(file, ctx);
 		file->f_pos = ctx->pos;
 		fsnotify_access(file);
-		file_accessed(file);
+		file_accessed(file, ctx->flags & DIR_CONTEXT_F_NOWAIT);
 	}
 	if (shared)
 		inode_unlock_shared(inode);
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a4d8b0ea1c8c..20156c5e83e6 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1307,7 +1307,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 		rc = target_tcon->ses->server->ops->copychunk_range(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
 
-	file_accessed(src_file);
+	file_accessed(src_file, false);
 
 	/* force revalidate of size and timestamps of target file now
 	 * that target is updated on the server
diff --git a/fs/splice.c b/fs/splice.c
index 004eb1c4ce31..e4dcfa1c0fef 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1104,7 +1104,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 done:
 	pipe->tail = pipe->head = 0;
-	file_accessed(in);
+	file_accessed(in, false);
 	return bytes;
 
 read_failure:
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 6738fe43040b..a27c73848571 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1603,7 +1603,7 @@ static int ubifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_ops = &ubifs_file_vm_ops;
 
 	if (IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
-		file_accessed(file);
+		file_accessed(file, false);
 
 	return 0;
 }
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 243840dc83ad..46edf6e64632 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -191,7 +191,7 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 
 static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &udf_file_vm_ops;
 
 	return 0;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4f502219ae4f..c72efdb9e43e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -227,7 +227,7 @@ xfs_file_dio_read(
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
@@ -257,7 +257,7 @@ xfs_file_dax_read(
 	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
-	file_accessed(iocb->ki_filp);
+	file_accessed(iocb->ki_filp, false);
 	return ret;
 }
 
@@ -1434,7 +1434,7 @@ xfs_file_mmap(
 	if (!daxdev_mapping_supported(vma, target->bt_daxdev))
 		return -EOPNOTSUPP;
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(inode))
 		vm_flags_set(vma, VM_HUGEPAGE);
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 92c9aaae3663..664ebae181bd 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -323,7 +323,7 @@ static int zonefs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	    (vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
 		return -EINVAL;
 
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &zonefs_file_vm_ops;
 
 	return 0;
@@ -736,7 +736,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			ret = -EINVAL;
 			goto inode_unlock;
 		}
-		file_accessed(iocb->ki_filp);
+		file_accessed(iocb->ki_filp, false);
 		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, 0, NULL, 0);
 	} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba54879089ac..ed60b3d70d1e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2204,10 +2204,11 @@ extern bool atime_needs_update(const struct path *, struct inode *);
 extern int touch_atime(const struct path *path, bool nowait);
 int inode_update_time(struct inode *inode, struct timespec64 *time, int flags);
 
-static inline void file_accessed(struct file *file)
+static inline int file_accessed(struct file *file, bool nowait)
 {
 	if (!(file->f_flags & O_NOATIME))
-		touch_atime(&file->f_path, false);
+		return touch_atime(&file->f_path, nowait);
+	return 0;
 }
 
 extern int file_modified(struct file *file);
diff --git a/mm/filemap.c b/mm/filemap.c
index 9e44a49bbd74..1f2032f4fd10 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2723,7 +2723,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		folio_batch_init(&fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
-	file_accessed(filp);
+	file_accessed(filp, false);
 
 	return already_read ? already_read : error;
 }
@@ -2809,7 +2809,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		retval = kiocb_write_and_wait(iocb, count);
 		if (retval < 0)
 			return retval;
-		file_accessed(file);
+		file_accessed(file, false);
 
 		retval = mapping->a_ops->direct_IO(iocb, iter);
 		if (retval >= 0) {
@@ -2978,7 +2978,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 
 out:
 	folio_batch_release(&fbatch);
-	file_accessed(in);
+	file_accessed(in, false);
 
 	return total_spliced ? total_spliced : error;
 }
@@ -3613,7 +3613,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (!mapping->a_ops->read_folio)
 		return -ENOEXEC;
-	file_accessed(file);
+	file_accessed(file, false);
 	vma->vm_ops = &generic_file_vm_ops;
 	return 0;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 2f2e0e618072..440b23e2d9e1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2317,7 +2317,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	/* arm64 - allow memory tagging on RAM-based files */
 	vm_flags_set(vma, VM_MTE_ALLOWED);
 
-	file_accessed(file);
+	file_accessed(file, false);
 	/* This is anonymous shared memory if it is unlinked at the time of mmap */
 	if (inode->i_nlink)
 		vma->vm_ops = &shmem_vm_ops;
@@ -2727,7 +2727,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 
 	*ppos = ((loff_t) index << PAGE_SHIFT) + offset;
-	file_accessed(file);
+	file_accessed(file, false);
 	return retval ? retval : error;
 }
 
@@ -2859,7 +2859,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	if (folio)
 		folio_put(folio);
 
-	file_accessed(in);
+	file_accessed(in, false);
 	return total_spliced ? total_spliced : error;
 }
 
-- 
2.25.1

