Return-Path: <io-uring+bounces-3668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0397199D579
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DDB2849F6
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C006C1C729E;
	Mon, 14 Oct 2024 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="Gkefsznx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F7D29A0
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728926337; cv=none; b=S9g77iMiNxRnVPvjhKME2w9PxCz+YlgSROFRaRJvy3qKxujFan+mHqEOTrvt6eUv+sUBRpt4nJGdrtcQJFFE4LQMrBJ5y9dU3l753y1kPSa2CUp7twMeKBwDUDw8lG9alv18YXnJXGzEN59Q1KH/FKbEQFap5fk9Sxhn0xYGtJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728926337; c=relaxed/simple;
	bh=gZNDHpfC23c/I9LTrE8X/5vGbZ/NuhvSCAwj777XHt4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DretWdT0iXNBR76YblS8KiBayIjfImR1MPQwiyw3Ad72jbdv7Ad00v+8hr5Qei8WFvNjvwAEV7hvHFoD6kBVjeGjExKAylZJp9Pc1oQD8Ux6hqduEk3ASqKUkY+wYjeDHI1UcbY8Z0H+hKflFLKnJOpbXW05p2WFkCmiUhh65IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=Gkefsznx; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFq0uc016802
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=C
	3igu5BiI/pdNFcgJWdGeSICoP469Hw4Poh8Sq9YsCE=; b=GkefsznxCUtFngwMF
	B+yFbL/DZjjoeN/zlb3LeAMa3OEnpVJ7T5xIE64xHp6G9Cygd9v0v+P2OpBBPgwT
	dvKmXdu+jAykRH5NJNgKT3xZSNckk0dJ03W4F3udxKkqEd08XFjUBL23nWf18EDF
	7LimXeMQOGsqHKmWfN/0RlpmBs=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4291qjtmxc-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:55 -0700 (PDT)
Received: from twshared16035.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 14 Oct 2024 17:18:52 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 5B0B97C37EF8; Mon, 14 Oct 2024 18:18:41 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 3/5] btrfs: change btrfs_encoded_read so that reading of extent is done by caller
Date: Mon, 14 Oct 2024 18:18:25 +0100
Message-ID: <20241014171838.304953-4-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: O4sZhuVlemsJnRSccYQYK1OE9x2reb6G
X-Proofpoint-GUID: O4sZhuVlemsJnRSccYQYK1OE9x2reb6G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

Change the behaviour of btrfs_encoded_read so that if it needs to read
an extent from disk, it leaves the extent and inode locked and returns
-EIOCBQUEUED. The caller is then responsible for doing the I/O via
btrfs_encoded_read_regular and unlocking the extent and inode.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h | 10 +++++++-
 fs/btrfs/inode.c       | 58 ++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c       | 33 +++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6aea5bedc968..3a0b519c51ca 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -617,7 +617,15 @@ int btrfs_encoded_read_regular_fill_pages(struct btr=
fs_inode *inode,
 					  btrfs_encoded_read_cb_t cb,
 					  void *cb_ctx);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded);
+			   struct btrfs_ioctl_encoded_io_args *encoded,
+			   struct extent_state **cached_state,
+			   u64 *disk_bytenr, u64 *disk_io_size);
+ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *=
iter,
+				   u64 start, u64 lockend,
+				   struct extent_state **cached_state,
+				   u64 disk_bytenr, u64 disk_io_size,
+				   size_t count, bool compressed,
+				   bool *unlocked);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from=
,
 			       const struct btrfs_ioctl_encoded_io_args *encoded);
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b5abe98f3af4..e58284d33b35 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9174,13 +9174,12 @@ void btrfs_encoded_read_wait_cb(void *ctx, int er=
r)
 	wake_up(&priv->wait);
 }
=20
-static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
-					  struct iov_iter *iter,
-					  u64 start, u64 lockend,
-					  struct extent_state **cached_state,
-					  u64 disk_bytenr, u64 disk_io_size,
-					  size_t count, bool compressed,
-					  bool *unlocked)
+ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *=
iter,
+				   u64 start, u64 lockend,
+				   struct extent_state **cached_state,
+				   u64 disk_bytenr, u64 disk_io_size,
+				   size_t count, bool compressed,
+				   bool *unlocked)
 {
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
@@ -9254,15 +9253,16 @@ static ssize_t btrfs_encoded_read_regular(struct =
kiocb *iocb,
 }
=20
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded)
+			   struct btrfs_ioctl_encoded_io_args *encoded,
+			   struct extent_state **cached_state,
+			   u64 *disk_bytenr, u64 *disk_io_size)
 {
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	ssize_t ret;
 	size_t count =3D iov_iter_count(iter);
-	u64 start, lockend, disk_bytenr, disk_io_size;
-	struct extent_state *cached_state =3D NULL;
+	u64 start, lockend;
 	struct extent_map *em;
 	bool unlocked =3D false;
=20
@@ -9288,13 +9288,13 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 					       lockend - start + 1);
 		if (ret)
 			goto out_unlock_inode;
-		lock_extent(io_tree, start, lockend, &cached_state);
+		lock_extent(io_tree, start, lockend, cached_state);
 		ordered =3D btrfs_lookup_ordered_range(inode, start,
 						     lockend - start + 1);
 		if (!ordered)
 			break;
 		btrfs_put_ordered_extent(ordered);
-		unlock_extent(io_tree, start, lockend, &cached_state);
+		unlock_extent(io_tree, start, lockend, cached_state);
 		cond_resched();
 	}
=20
@@ -9314,7 +9314,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 		free_extent_map(em);
 		em =3D NULL;
 		ret =3D btrfs_encoded_read_inline(iocb, iter, start, lockend,
-						&cached_state, extent_start,
+						cached_state, extent_start,
 						count, encoded, &unlocked);
 		goto out_em;
 	}
@@ -9327,12 +9327,12 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 			     inode->vfs_inode.i_size) - iocb->ki_pos;
 	if (em->disk_bytenr =3D=3D EXTENT_MAP_HOLE ||
 	    (em->flags & EXTENT_FLAG_PREALLOC)) {
-		disk_bytenr =3D EXTENT_MAP_HOLE;
+		*disk_bytenr =3D EXTENT_MAP_HOLE;
 		count =3D min_t(u64, count, encoded->len);
 		encoded->len =3D count;
 		encoded->unencoded_len =3D count;
 	} else if (extent_map_is_compressed(em)) {
-		disk_bytenr =3D em->disk_bytenr;
+		*disk_bytenr =3D em->disk_bytenr;
 		/*
 		 * Bail if the buffer isn't large enough to return the whole
 		 * compressed extent.
@@ -9341,7 +9341,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 			ret =3D -ENOBUFS;
 			goto out_em;
 		}
-		disk_io_size =3D em->disk_num_bytes;
+		*disk_io_size =3D em->disk_num_bytes;
 		count =3D em->disk_num_bytes;
 		encoded->unencoded_len =3D em->ram_bytes;
 		encoded->unencoded_offset =3D iocb->ki_pos - (em->start - em->offset);
@@ -9351,44 +9351,42 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 			goto out_em;
 		encoded->compression =3D ret;
 	} else {
-		disk_bytenr =3D extent_map_block_start(em) + (start - em->start);
+		*disk_bytenr =3D extent_map_block_start(em) + (start - em->start);
 		if (encoded->len > count)
 			encoded->len =3D count;
 		/*
 		 * Don't read beyond what we locked. This also limits the page
 		 * allocations that we'll do.
 		 */
-		disk_io_size =3D min(lockend + 1, iocb->ki_pos + encoded->len) - start=
;
-		count =3D start + disk_io_size - iocb->ki_pos;
+		*disk_io_size =3D min(lockend + 1, iocb->ki_pos + encoded->len) - star=
t;
+		count =3D start + *disk_io_size - iocb->ki_pos;
 		encoded->len =3D count;
 		encoded->unencoded_len =3D count;
-		disk_io_size =3D ALIGN(disk_io_size, fs_info->sectorsize);
+		*disk_io_size =3D ALIGN(*disk_io_size, fs_info->sectorsize);
 	}
 	free_extent_map(em);
 	em =3D NULL;
=20
-	if (disk_bytenr =3D=3D EXTENT_MAP_HOLE) {
-		unlock_extent(io_tree, start, lockend, &cached_state);
+	if (*disk_bytenr =3D=3D EXTENT_MAP_HOLE) {
+		unlock_extent(io_tree, start, lockend, cached_state);
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		unlocked =3D true;
 		ret =3D iov_iter_zero(count, iter);
 		if (ret !=3D count)
 			ret =3D -EFAULT;
 	} else {
-		ret =3D btrfs_encoded_read_regular(iocb, iter, start, lockend,
-						 &cached_state, disk_bytenr,
-						 disk_io_size, count,
-						 encoded->compression,
-						 &unlocked);
+		ret =3D -EIOCBQUEUED;
+		goto out_em;
 	}
=20
 out_em:
 	free_extent_map(em);
 out_unlock_extent:
-	if (!unlocked)
-		unlock_extent(io_tree, start, lockend, &cached_state);
+	/* Leave inode and extent locked if we need to do a read */
+	if (!unlocked && ret !=3D -EIOCBQUEUED)
+		unlock_extent(io_tree, start, lockend, cached_state);
 out_unlock_inode:
-	if (!unlocked)
+	if (!unlocked && ret !=3D -EIOCBQUEUED)
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e0a664b8a46a..e2ecf0bcda24 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4516,12 +4516,17 @@ static int btrfs_ioctl_encoded_read(struct file *=
file, void __user *argp,
 	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs,
 					     flags);
 	size_t copy_end;
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(file));
+	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov =3D iovstack;
 	struct iov_iter iter;
 	loff_t pos;
 	struct kiocb kiocb;
 	ssize_t ret;
+	u64 disk_bytenr, disk_io_size;
+	struct extent_state *cached_state =3D NULL;
=20
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret =3D -EPERM;
@@ -4574,7 +4579,33 @@ static int btrfs_ioctl_encoded_read(struct file *f=
ile, void __user *argp,
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos =3D pos;
=20
-	ret =3D btrfs_encoded_read(&kiocb, &iter, &args);
+	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
+				 &disk_bytenr, &disk_io_size);
+
+	if (ret =3D=3D -EIOCBQUEUED) {
+		bool unlocked =3D false;
+		u64 start, lockend, count;
+
+		start =3D ALIGN_DOWN(kiocb.ki_pos, fs_info->sectorsize);
+		lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
+
+		if (args.compression)
+			count =3D disk_io_size;
+		else
+			count =3D args.len;
+
+		ret =3D btrfs_encoded_read_regular(&kiocb, &iter, start, lockend,
+						 &cached_state, disk_bytenr,
+						 disk_io_size, count,
+						 args.compression,
+						 &unlocked);
+
+		if (!unlocked) {
+			unlock_extent(io_tree, start, lockend, &cached_state);
+			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+		}
+	}
+
 	if (ret >=3D 0) {
 		fsnotify_access(file);
 		if (copy_to_user(argp + copy_end,
--=20
2.44.2


