Return-Path: <io-uring+bounces-3664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A8199D572
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DBB41C22E06
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5E51B85C2;
	Mon, 14 Oct 2024 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="Z0I99Qx8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0235D824A0
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728926328; cv=none; b=jJpxq1hliJyVPv4QmCBACxWMVJ8o6QRkaMgcvjESUEZBCB9yOabrVxPHTK2oqm84vH3tqpOucz6/UnH9Yqc82FAOKwr8xAQ3g/PpwFWe+AHYHDXMmfVH79j63MaUNHM7TfKCbPsaiGKXyFYHjBI5LKdTrWy+Rtzd4TaKucKrkcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728926328; c=relaxed/simple;
	bh=C58ifGvWus9KLuTDVmdqSyOa2JXMf2YtxpKkxG10rpM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/3eGEsScHvYPyCGaLJJ5K5wQKMRqb3WV2wD2DidADWfoyPyxWE0ciHccxqyEGHL7r1ghene4nTt+Y6xntisusMlHZgiOzwY2g2UrECD2X8JyR7MON90qNCsuPBPvhxwgCtzk3QxCrKBcsBh9CiUxC1VaCn8kcmr3YYTJ+UXaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=Z0I99Qx8; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFq0uV016802
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=O
	sTQyju7Dp4E2be+OiS8g3uDBbnjjCsJmwHKLLwJnyo=; b=Z0I99Qx8mhe+RHcGV
	Xi3ebWsH5u8xGSR9vl2VxzCqYLRzc8mUv/N/VqQ4+j5Rv6Q3M+BXA4QdKY7eK0ZY
	oIbjNSz59GlDg/FINXXYTNjrHbEy0Kq30410Pb6lSAOT+B0Ihaw0HwhOkH8766nC
	l99YxabQi5y4HCvQLVe5trJM0Q=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4291qjtmxc-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:46 -0700 (PDT)
Received: from twshared60308.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 14 Oct 2024 17:18:44 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 6E6DD7C37EFC; Mon, 14 Oct 2024 18:18:41 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Date: Mon, 14 Oct 2024 18:18:27 +0100
Message-ID: <20241014171838.304953-6-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241014171838.304953-1-maharmstone@fb.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bISO-P5t7KYk40b0ibalnp6dCWEu2d13
X-Proofpoint-GUID: bISO-P5t7KYk40b0ibalnp6dCWEu2d13
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

Adds an io_uring command for encoded reads, using the same interface as
the existing BTRFS_IOC_ENCODED_READ ioctl.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/file.c  |   1 +
 fs/btrfs/ioctl.c | 283 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   1 +
 3 files changed, 285 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2aeb8116549c..e33ca73fef8c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3774,6 +3774,7 @@ const struct file_operations btrfs_file_operations =
=3D {
 	.compat_ioctl	=3D btrfs_compat_ioctl,
 #endif
 	.remap_file_range =3D btrfs_remap_file_range,
+	.uring_cmd	=3D btrfs_uring_cmd,
 	.fop_flags	=3D FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
 };
=20
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8c9ff4898ab0..c0393575cf5e 100644
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
@@ -4723,6 +4724,288 @@ static int btrfs_ioctl_encoded_write(struct file =
*file, void __user *argp, bool
 	return ret;
 }
=20
+struct btrfs_uring_priv {
+	struct io_uring_cmd *cmd;
+	struct page **pages;
+	unsigned long nr_pages;
+	struct kiocb iocb;
+	struct iovec *iov;
+	struct iov_iter iter;
+	struct extent_state *cached_state;
+	u64 count;
+	bool compressed;
+	u64 start;
+	u64 lockend;
+};
+
+static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
+				      unsigned int issue_flags)
+{
+	struct btrfs_uring_priv *priv =3D (struct btrfs_uring_priv *)*(uintptr_=
t*)cmd->pdu;
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->iocb.ki_filp));
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	unsigned long i;
+	u64 cur;
+	size_t page_offset;
+	ssize_t ret;
+
+	if (priv->compressed) {
+		i =3D 0;
+		page_offset =3D 0;
+	} else {
+		i =3D (priv->iocb.ki_pos - priv->start) >> PAGE_SHIFT;
+		page_offset =3D (priv->iocb.ki_pos - priv->start) & (PAGE_SIZE - 1);
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
+	for (unsigned long i =3D 0; i < priv->nr_pages; i++) {
+		__free_page(priv->pages[i]);
+	}
+
+	kfree(priv->pages);
+	kfree(priv->iov);
+	kfree(priv);
+}
+
+static void btrfs_uring_read_extent_cb(void *ctx, int err)
+{
+	struct btrfs_uring_priv *priv =3D ctx;
+
+	*(uintptr_t*)priv->cmd->pdu =3D (uintptr_t)priv;
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
+
+	ret =3D btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr=
,
+						    disk_io_size, pages,
+						    btrfs_uring_read_extent_cb,
+						    priv);
+	if (ret)
+		goto fail;
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
+	struct btrfs_ioctl_encoded_io_args args =3D {0};
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
+		if (copy_from_user(&args32, (const void *)cmd->sqe->addr,
+				   copy_end)) {
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
+		if (copy_from_user(&args, (const void *)cmd->sqe->addr,
+				   copy_end)) {
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
+	start =3D ALIGN_DOWN(pos, fs_info->sectorsize);
+	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
+
+	ret =3D btrfs_encoded_read(&kiocb, &iter, &args,
+				 issue_flags & IO_URING_F_NONBLOCK,
+				 &cached_state, &disk_bytenr, &disk_io_size);
+	if (ret < 0 && ret !=3D -EIOCBQUEUED)
+		goto out_free;
+
+	file_accessed(file);
+
+	if (copy_to_user((void*)(uintptr_t)cmd->sqe->addr + copy_end,
+			 (char *)&args + copy_end_kernel,
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
+		/* If we've optimized things by storing the iovecs on the stack,
+		 * undo this.  */
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
index 19cd26b0244a..288f4f5c4409 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,5 +22,6 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *in=
ode);
 int __pure btrfs_is_empty_uuid(const u8 *uuid);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 				     struct btrfs_ioctl_balance_args *bargs);
+int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
=20
 #endif
--=20
2.44.2


