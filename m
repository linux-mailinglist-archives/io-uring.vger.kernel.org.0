Return-Path: <io-uring+bounces-3915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C5D9AB162
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 288ACB24188
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B7D1A0BFD;
	Tue, 22 Oct 2024 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="owvaURYa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7770C1A073F
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608655; cv=none; b=Au7NW7PsmyeaN4ivICkh1Dpk/iURYHEuerygd5QefwQonyu6X6ZYWzZqveRTyrJbm5X5DMDSK0GLZxjrdJMv7poJZlnYx+uXJ9dH6DA7Jq+s0spbUf44Y5U45cPYFUk9lIBuabZaNhHUUyMnTF2o8kYQSV8YAKleQErG9pyjo+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608655; c=relaxed/simple;
	bh=gdmi89HQ7TNSYH7JlAJVYY3f6nr2PfZf9Mi+IV8vrkg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGv3GK2+HA5JxIdBToOEIErFxzEnbhD7MpgrhPvrpEonuO0KgeKgphTWvQ16+pAll489Ah11SW4cSR2kUUgly1f05wdgtfjX27HqxPbDhVFn2AU2CuFqYd9lUKMmvqkAebca4CjmkH0MCEFEBjaVZKebQMTLexFeCrqFk/RBi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=owvaURYa; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MDnDJv014113
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=Z
	K6rUQeoLW8URSECIC2LEbudIAhAq48FcZfX9+aUF1g=; b=owvaURYa7hDSKQdbd
	B2pl9k0tu75Fmm32tlmjdXGt6VXGQtEl8Ffy1sotzJbBG/Ksg8TuWKNN5LtR26z6
	8GwYfjPbHnBY5CjdnbTDofrXSqqNBg7TfZy1IjfP7WYc6bzo/u/ApFB8NVROubOE
	9athDKIhzcpBrlp8HF0r4XMVUM=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ea7psg41-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:52 -0700 (PDT)
Received: from twshared4239.05.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 22 Oct 2024 14:50:39 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id BD32E7FDCDB0; Tue, 22 Oct 2024 15:50:32 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Date: Tue, 22 Oct 2024 15:50:20 +0100
Message-ID: <20241022145024.1046883-6-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241022145024.1046883-1-maharmstone@fb.com>
References: <20241022145024.1046883-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: p1gbrwGz8pZ67jQV6EJu_xfsbCP4YK0A
X-Proofpoint-ORIG-GUID: p1gbrwGz8pZ67jQV6EJu_xfsbCP4YK0A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Adds an io_uring command for encoded reads, using the same interface as
the existing BTRFS_IOC_ENCODED_READ ioctl.

btrfs_uring_encoded_read is an io_uring version of
btrfs_ioctl_encoded_read, which validates the user input and calls
btrfs_encoded_read to read the appropriate metadata. If we determine
that we need to read an extent from disk, we call
btrfs_encoded_read_regular_fill_pages through btrfs_uring_read_extent to
prepare the bio.

The existing btrfs_encoded_read_regular_fill_pages is changed so that if
it is passed a uring_ctx value, rather than waking up any waiting
threads it calls btrfs_uring_read_extent_endio. This in turn copies the
read data back to userspace, and calls io_uring_cmd_done to complete the
io_uring command.

Because we're potentially doing a non-blocking read,
btrfs_uring_read_extent doesn't clean up after itself if it returns
-EIOCBQUEUED. Instead, it allocates a priv struct, populates the fields
there that we will need to unlock the inode and free our allocations,
and defers this to the btrfs_uring_read_finished that gets called when
the bio completes.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |   3 +-
 fs/btrfs/file.c        |   1 +
 fs/btrfs/inode.c       |  43 ++++--
 fs/btrfs/ioctl.c       | 309 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h       |   2 +
 fs/btrfs/send.c        |   3 +-
 6 files changed, 349 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ab1fbde97cee..f551444b498e 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -613,7 +613,8 @@ int btrfs_encoded_io_compression_from_extent(struct b=
trfs_fs_info *fs_info,
 					     int compress_type);
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 disk_bytenr, u64 disk_io_size,
-					  struct page **pages);
+					  struct page **pages,
+					  void *uring_ctx);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded,
 			   struct extent_state **cached_state,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5e0a1805e897..fbb753300071 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3710,6 +3710,7 @@ const struct file_operations btrfs_file_operations =
=3D {
 	.compat_ioctl	=3D btrfs_compat_ioctl,
 #endif
 	.remap_file_range =3D btrfs_remap_file_range,
+	.uring_cmd	=3D btrfs_uring_cmd,
 	.fop_flags	=3D FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
 };
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5aedb85696f4..759ae076f90b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9057,6 +9057,7 @@ static ssize_t btrfs_encoded_read_inline(
=20
 struct btrfs_encoded_read_private {
 	wait_queue_head_t wait;
+	void *uring_ctx;
 	atomic_t pending;
 	blk_status_t status;
 };
@@ -9076,14 +9077,23 @@ static void btrfs_encoded_read_endio(struct btrfs=
_bio *bbio)
 		 */
 		WRITE_ONCE(priv->status, bbio->bio.bi_status);
 	}
-	if (!atomic_dec_return(&priv->pending))
-		wake_up(&priv->wait);
+	if (atomic_dec_return(&priv->pending) =3D=3D 0) {
+		int err =3D blk_status_to_errno(READ_ONCE(priv->status));
+
+		if (priv->uring_ctx) {
+			btrfs_uring_read_extent_endio(priv->uring_ctx, err);
+			kfree(priv);
+		} else {
+			wake_up(&priv->wait);
+		}
+	}
 	bio_put(&bbio->bio);
 }
=20
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 disk_bytenr, u64 disk_io_size,
-					  struct page **pages)
+					  struct page **pages,
+					  void *uring_ctx)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	struct btrfs_encoded_read_private *priv;
@@ -9098,6 +9108,7 @@ int btrfs_encoded_read_regular_fill_pages(struct bt=
rfs_inode *inode,
 	init_waitqueue_head(&priv->wait);
 	atomic_set(&priv->pending, 1);
 	priv->status =3D 0;
+	priv->uring_ctx =3D uring_ctx;
=20
 	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
 			       btrfs_encoded_read_endio, priv);
@@ -9126,12 +9137,23 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 	atomic_inc(&priv->pending);
 	btrfs_submit_bbio(bbio, 0);
=20
-	if (atomic_dec_return(&priv->pending))
-		io_wait_event(priv->wait, !atomic_read(&priv->pending));
-	/* See btrfs_encoded_read_endio() for ordering. */
-	ret =3D blk_status_to_errno(READ_ONCE(priv->status));
-	kfree(priv);
-	return ret;
+	if (uring_ctx) {
+		if (atomic_dec_return(&priv->pending) =3D=3D 0) {
+			ret =3D blk_status_to_errno(READ_ONCE(priv->status));
+			btrfs_uring_read_extent_endio(uring_ctx, ret);
+			kfree(priv);
+			return ret;
+		}
+
+		return -EIOCBQUEUED;
+	} else {
+		if (atomic_dec_return(&priv->pending) !=3D 0)
+			io_wait_event(priv->wait, !atomic_read(&priv->pending));
+		/* See btrfs_encoded_read_endio() for ordering. */
+		ret =3D blk_status_to_errno(READ_ONCE(priv->status));
+		kfree(priv);
+		return ret;
+	}
 }
=20
 ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *=
iter,
@@ -9160,7 +9182,8 @@ ssize_t btrfs_encoded_read_regular(struct kiocb *io=
cb, struct iov_iter *iter,
 		}
=20
 	ret =3D btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
-						    disk_io_size, pages);
+						    disk_io_size, pages,
+						    NULL);
 	if (ret)
 		goto out;
=20
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d502b31010bc..7f2731ef3dbb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -29,6 +29,7 @@
 #include <linux/fileattr.h>
 #include <linux/fsverity.h>
 #include <linux/sched/xacct.h>
+#include <linux/io_uring/cmd.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "export.h"
@@ -4720,6 +4721,314 @@ static int btrfs_ioctl_encoded_write(struct file =
*file, void __user *argp, bool
 	return ret;
 }
=20
+/*
+ * struct btrfs_uring_priv is the context that's attached to an encoded =
read
+ * io_uring command, in cmd->pdu. It contains the fields in
+ * btrfs_uring_read_extent that are necessary to finish off and cleanup =
the I/O
+ * in btrfs_uring_read_finished.
+ */
+struct btrfs_uring_priv {
+	struct io_uring_cmd *cmd;
+	struct page **pages;
+	unsigned long nr_pages;
+	struct kiocb iocb;
+	struct iovec *iov;
+	struct iov_iter iter;
+	struct extent_state *cached_state;
+	u64 count;
+	u64 start;
+	u64 lockend;
+	int err;
+	bool compressed;
+};
+
+static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
+				      unsigned int issue_flags)
+{
+	struct btrfs_uring_priv *priv =3D
+		*io_uring_cmd_to_pdu(cmd, struct btrfs_uring_priv *);
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->iocb.ki_filp));
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	unsigned long i;
+	u64 cur;
+	size_t page_offset;
+	ssize_t ret;
+
+	if (priv->err) {
+		ret =3D priv->err;
+		goto out;
+	}
+
+	if (priv->compressed) {
+		i =3D 0;
+		page_offset =3D 0;
+	} else {
+		i =3D (priv->iocb.ki_pos - priv->start) >> PAGE_SHIFT;
+		page_offset =3D offset_in_page(priv->iocb.ki_pos - priv->start);
+	}
+	cur =3D 0;
+	while (cur < priv->count) {
+		size_t bytes =3D min_t(size_t, priv->count - cur,
+				     PAGE_SIZE - page_offset);
+
+		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
+				      &priv->iter) !=3D bytes) {
+			ret =3D -EFAULT;
+			goto out;
+		}
+
+		i++;
+		cur +=3D bytes;
+		page_offset =3D 0;
+	}
+	ret =3D priv->count;
+
+out:
+	unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state)=
;
+	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+	add_rchar(current, ret);
+
+	for (unsigned long index =3D 0; index < priv->nr_pages; index++)
+		__free_page(priv->pages[index]);
+
+	kfree(priv->pages);
+	kfree(priv->iov);
+	kfree(priv);
+}
+
+void btrfs_uring_read_extent_endio(void *ctx, int err)
+{
+	struct btrfs_uring_priv *priv =3D ctx;
+
+	priv->err =3D err;
+
+	*io_uring_cmd_to_pdu(priv->cmd, struct btrfs_uring_priv *) =3D priv;
+	io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished);
+}
+
+static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *=
iter,
+				   u64 start, u64 lockend,
+				   struct extent_state *cached_state,
+				   u64 disk_bytenr, u64 disk_io_size,
+				   size_t count, bool compressed,
+				   struct iovec *iov,
+				   struct io_uring_cmd *cmd)
+{
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	struct page **pages;
+	struct btrfs_uring_priv *priv =3D NULL;
+	unsigned long nr_pages;
+	int ret;
+
+	nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
+	pages =3D kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
+	if (!pages)
+		return -ENOMEM;
+	ret =3D btrfs_alloc_page_array(nr_pages, pages, 0);
+	if (ret) {
+		ret =3D -ENOMEM;
+		goto fail;
+	}
+
+	priv =3D kmalloc(sizeof(*priv), GFP_NOFS);
+	if (!priv) {
+		ret =3D -ENOMEM;
+		goto fail;
+	}
+
+	priv->iocb =3D *iocb;
+	priv->iov =3D iov;
+	priv->iter =3D *iter;
+	priv->count =3D count;
+	priv->cmd =3D cmd;
+	priv->cached_state =3D cached_state;
+	priv->compressed =3D compressed;
+	priv->nr_pages =3D nr_pages;
+	priv->pages =3D pages;
+	priv->start =3D start;
+	priv->lockend =3D lockend;
+	priv->err =3D 0;
+
+	ret =3D btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
+						    disk_io_size, pages,
+						    priv);
+	if (ret && ret !=3D -EIOCBQUEUED)
+		goto fail;
+
+	/*
+	 * If we return -EIOCBQUEUED, we're deferring the cleanup to
+	 * btrfs_uring_read_finished, which will handle unlocking the extent
+	 * and inode and freeing the allocations.
+	 */
+
+	return -EIOCBQUEUED;
+
+fail:
+	unlock_extent(io_tree, start, lockend, &cached_state);
+	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+	kfree(priv);
+	return ret;
+}
+
+static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs,
+					     flags);
+	size_t copy_end;
+	struct btrfs_ioctl_encoded_io_args args =3D { 0 };
+	int ret;
+	u64 disk_bytenr, disk_io_size;
+	struct file *file =3D cmd->file;
+	struct btrfs_inode *inode =3D BTRFS_I(file->f_inode);
+	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov =3D iovstack;
+	struct iov_iter iter;
+	loff_t pos;
+	struct kiocb kiocb;
+	struct extent_state *cached_state =3D NULL;
+	u64 start, lockend;
+	void __user *sqe_addr =3D u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret =3D -EPERM;
+		goto out_acct;
+	}
+
+	if (issue_flags & IO_URING_F_COMPAT) {
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+		struct btrfs_ioctl_encoded_io_args_32 args32;
+
+		copy_end =3D offsetofend(struct btrfs_ioctl_encoded_io_args_32,
+				       flags);
+		if (copy_from_user(&args32, sqe_addr, copy_end)) {
+			ret =3D -EFAULT;
+			goto out_acct;
+		}
+		args.iov =3D compat_ptr(args32.iov);
+		args.iovcnt =3D args32.iovcnt;
+		args.offset =3D args32.offset;
+		args.flags =3D args32.flags;
+#else
+		return -ENOTTY;
+#endif
+	} else {
+		copy_end =3D copy_end_kernel;
+		if (copy_from_user(&args, sqe_addr, copy_end)) {
+			ret =3D -EFAULT;
+			goto out_acct;
+		}
+	}
+
+	if (args.flags !=3D 0)
+		return -EINVAL;
+
+	ret =3D import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovst=
ack),
+			   &iov, &iter);
+	if (ret < 0)
+		goto out_acct;
+
+	if (iov_iter_count(&iter) =3D=3D 0) {
+		ret =3D 0;
+		goto out_free;
+	}
+
+	pos =3D args.offset;
+	ret =3D rw_verify_area(READ, file, &pos, args.len);
+	if (ret < 0)
+		goto out_free;
+
+	init_sync_kiocb(&kiocb, file);
+	kiocb.ki_pos =3D pos;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		kiocb.ki_flags |=3D IOCB_NOWAIT;
+
+	start =3D ALIGN_DOWN(pos, fs_info->sectorsize);
+	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
+
+	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
+				 &disk_bytenr, &disk_io_size);
+	if (ret < 0 && ret !=3D -EIOCBQUEUED)
+		goto out_free;
+
+	file_accessed(file);
+
+	if (copy_to_user(sqe_addr + copy_end, (char *)&args + copy_end_kernel,
+			 sizeof(args) - copy_end_kernel)) {
+		if (ret =3D=3D -EIOCBQUEUED) {
+			unlock_extent(io_tree, start, lockend, &cached_state);
+			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+		}
+		ret =3D -EFAULT;
+		goto out_free;
+	}
+
+	if (ret =3D=3D -EIOCBQUEUED) {
+		u64 count;
+
+		/*
+		 * If we've optimized things by storing the iovecs on the stack,
+		 * undo this.
+		 */
+		if (!iov) {
+			iov =3D kmalloc(sizeof(struct iovec) * args.iovcnt,
+				      GFP_NOFS);
+			if (!iov) {
+				unlock_extent(io_tree, start, lockend,
+					      &cached_state);
+				btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+				ret =3D -ENOMEM;
+				goto out_acct;
+			}
+
+			memcpy(iov, iovstack,
+			       sizeof(struct iovec) * args.iovcnt);
+		}
+
+		count =3D min_t(u64, iov_iter_count(&iter), disk_io_size);
+
+		/* Match ioctl by not returning past EOF if uncompressed */
+		if (!args.compression)
+			count =3D min_t(u64, count, args.len);
+
+		ret =3D btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
+					      cached_state, disk_bytenr,
+					      disk_io_size, count,
+					      args.compression, iov, cmd);
+
+		goto out_acct;
+	}
+
+out_free:
+	kfree(iov);
+
+out_acct:
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
+
+	return ret;
+}
+
+int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	switch (cmd->cmd_op) {
+	case BTRFS_IOC_ENCODED_READ:
+#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
+	case BTRFS_IOC_ENCODED_READ_32:
+#endif
+		return btrfs_uring_encoded_read(cmd, issue_flags);
+	}
+
+	return -EINVAL;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 19cd26b0244a..2b760c8778f8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,5 +22,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *in=
ode);
 int __pure btrfs_is_empty_uuid(const u8 *uuid);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 				     struct btrfs_ioctl_balance_args *bargs);
+int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void btrfs_uring_read_extent_endio(void *ctx, int err);
=20
 #endif
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 03b31b1c39be..cadb945bb345 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5669,7 +5669,8 @@ static int send_encoded_extent(struct send_ctx *sct=
x, struct btrfs_path *path,
 	ret =3D btrfs_encoded_read_regular_fill_pages(BTRFS_I(inode),
 						    disk_bytenr, disk_num_bytes,
 						    sctx->send_buf_pages +
-						    (data_offset >> PAGE_SHIFT));
+						    (data_offset >> PAGE_SHIFT),
+						    NULL);
 	if (ret)
 		goto out;
=20
--=20
2.45.2


