Return-Path: <io-uring+bounces-2925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A2E95D363
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 18:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5548A2868C8
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4950518DF9D;
	Fri, 23 Aug 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="fRoDFgyV"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4750118BBA3
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430507; cv=none; b=DxOBE7AfpXC54LPayAV04NMnDYt5tWZNm4WWPWZm4qQNHxCXwEy1wB7Ue5U+BSiz73fuXWXLo3aTsPRqlpMELWgvTTLngJg/OUveuxy+SHr7bzDK7xXyJ0A3qPkKkFHGqrKHrlS/lZtXJmxAyHhLWPiIKRbRRE48ljdXEfHl5b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430507; c=relaxed/simple;
	bh=i58b04qaxPVST6vUqbZGlxk/Pj6JQzbPpV+FhClYSkM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+hfJM7ox6YBasTswcFsxl11jO2gqHavmbacNgqZ3lQO+u8v04817uwBlVO1Bt4kkoLYIEhPQyiRBA4B7LE7aJO1E6//SBdndO+KFGNKKGylGc1hjT/ddZ6oPOiImNFK8Wq6P7pzV2nLSX9qyvGt6rvr6zYUXLUZ5PacjoqurKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=fRoDFgyV; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47NAA3Pn028815
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	facebook; bh=56tSw8LAbfe/7f+rOT6P2Pmfo9Da5NoPKXydiAMzV08=; b=fRo
	DFgyVhfnjSQvHiHS+VsGfkVc+MlNmzFGR7suUeGCDWUAdlcKZ/8/i8FLYkkGLaFY
	mhcdEhnCBkMFiPBH/bbYzaPxe9zmYwCwShV3hfxqSG5L15wzXmuTxYJ9fKMas4hL
	HhkixNs80JunvJapIzE0nirkR68Mv9/Q+9OBoi74=
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 416reaa29v-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:24 -0700 (PDT)
Received: from twshared4354.35.frc1.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 23 Aug 2024 16:28:19 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 385C65CB7F77; Fri, 23 Aug 2024 17:28:13 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <io-uring@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 1/6] btrfs: remove iocb from btrfs_encoded_read
Date: Fri, 23 Aug 2024 17:27:43 +0100
Message-ID: <20240823162810.1668399-2-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240823162810.1668399-1-maharmstone@fb.com>
References: <20240823162810.1668399-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2KY-nzH1k0OnS8P6LfDUJ_rroup8EOCl
X-Proofpoint-GUID: 2KY-nzH1k0OnS8P6LfDUJ_rroup8EOCl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_13,2024-08-22_01,2024-05-17_01

We initialize a struct kiocb for encoded reads, but this never gets
passed outside the driver. Simplify things by replacing it with a file,
offset pair.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  3 ++-
 fs/btrfs/inode.c       | 59 ++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c       |  6 +----
 3 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 3056c8aed8ef..affe70929234 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -605,7 +605,8 @@ int btrfs_encoded_read_regular_fill_pages(struct btrf=
s_inode *inode,
 					  u64 file_offset, u64 disk_bytenr,
 					  u64 disk_io_size,
 					  struct page **pages);
-ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
+ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
+			   struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from=
,
 			       const struct btrfs_ioctl_encoded_io_args *encoded);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1b6564ab68f..a0cc029d95ed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8993,7 +8993,7 @@ int btrfs_encoded_io_compression_from_extent(struct=
 btrfs_fs_info *fs_info,
 }
=20
 static ssize_t btrfs_encoded_read_inline(
-				struct kiocb *iocb,
+				struct btrfs_inode *inode, loff_t pos,
 				struct iov_iter *iter, u64 start,
 				u64 lockend,
 				struct extent_state **cached_state,
@@ -9001,7 +9001,6 @@ static ssize_t btrfs_encoded_read_inline(
 				struct btrfs_ioctl_encoded_io_args *encoded,
 				bool *unlocked)
 {
-	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_root *root =3D inode->root;
 	struct btrfs_fs_info *fs_info =3D root->fs_info;
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
@@ -9034,7 +9033,7 @@ static ssize_t btrfs_encoded_read_inline(
 	ptr =3D btrfs_file_extent_inline_start(item);
=20
 	encoded->len =3D min_t(u64, extent_start + ram_bytes,
-			     inode->vfs_inode.i_size) - iocb->ki_pos;
+			     inode->vfs_inode.i_size) - pos;
 	ret =3D btrfs_encoded_io_compression_from_extent(fs_info,
 				 btrfs_file_extent_compression(leaf, item));
 	if (ret < 0)
@@ -9051,12 +9050,12 @@ static ssize_t btrfs_encoded_read_inline(
 		}
 		count =3D inline_size;
 		encoded->unencoded_len =3D ram_bytes;
-		encoded->unencoded_offset =3D iocb->ki_pos - extent_start;
+		encoded->unencoded_offset =3D pos - extent_start;
 	} else {
 		count =3D min_t(u64, count, encoded->len);
 		encoded->len =3D count;
 		encoded->unencoded_len =3D count;
-		ptr +=3D iocb->ki_pos - extent_start;
+		ptr +=3D pos - extent_start;
 	}
=20
 	tmp =3D kmalloc(count, GFP_NOFS);
@@ -9151,15 +9150,14 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 	return blk_status_to_errno(READ_ONCE(priv.status));
 }
=20
-static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
-					  struct iov_iter *iter,
+static ssize_t btrfs_encoded_read_regular(struct btrfs_inode *inode,
+					  loff_t offset, struct iov_iter *iter,
 					  u64 start, u64 lockend,
 					  struct extent_state **cached_state,
 					  u64 disk_bytenr, u64 disk_io_size,
 					  size_t count, bool compressed,
 					  bool *unlocked)
 {
-	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	struct page **pages;
 	unsigned long nr_pages, i;
@@ -9190,8 +9188,8 @@ static ssize_t btrfs_encoded_read_regular(struct ki=
ocb *iocb,
 		i =3D 0;
 		page_offset =3D 0;
 	} else {
-		i =3D (iocb->ki_pos - start) >> PAGE_SHIFT;
-		page_offset =3D (iocb->ki_pos - start) & (PAGE_SIZE - 1);
+		i =3D (offset - start) >> PAGE_SHIFT;
+		page_offset =3D (offset - start) & (PAGE_SIZE - 1);
 	}
 	cur =3D 0;
 	while (cur < count) {
@@ -9217,10 +9215,11 @@ static ssize_t btrfs_encoded_read_regular(struct =
kiocb *iocb,
 	return ret;
 }
=20
-ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
+ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
+			   struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded)
 {
-	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(file));
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	ssize_t ret;
@@ -9230,17 +9229,17 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 	struct extent_map *em;
 	bool unlocked =3D false;
=20
-	file_accessed(iocb->ki_filp);
+	file_accessed(file);
=20
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
=20
-	if (iocb->ki_pos >=3D inode->vfs_inode.i_size) {
+	if (offset >=3D inode->vfs_inode.i_size) {
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		return 0;
 	}
-	start =3D ALIGN_DOWN(iocb->ki_pos, fs_info->sectorsize);
+	start =3D ALIGN_DOWN(offset, fs_info->sectorsize);
 	/*
-	 * We don't know how long the extent containing iocb->ki_pos is, but if
+	 * We don't know how long the extent containing offset is, but if
 	 * it's compressed we know that it won't be longer than this.
 	 */
 	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
@@ -9277,10 +9276,11 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 		 */
 		free_extent_map(em);
 		em =3D NULL;
-		ret =3D btrfs_encoded_read_inline(iocb, iter, start, lockend,
-						&cached_state, extent_start,
-						count, encoded, &unlocked);
-		goto out;
+		ret =3D btrfs_encoded_read_inline(inode, offset, iter, start,
+						lockend, &cached_state,
+						extent_start, count, encoded,
+						&unlocked);
+		goto out_em;
 	}
=20
 	/*
@@ -9288,7 +9288,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 	 * that.
 	 */
 	encoded->len =3D min_t(u64, extent_map_end(em),
-			     inode->vfs_inode.i_size) - iocb->ki_pos;
+			     inode->vfs_inode.i_size) - offset;
 	if (em->disk_bytenr =3D=3D EXTENT_MAP_HOLE ||
 	    (em->flags & EXTENT_FLAG_PREALLOC)) {
 		disk_bytenr =3D EXTENT_MAP_HOLE;
@@ -9308,7 +9308,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 		disk_io_size =3D em->disk_num_bytes;
 		count =3D em->disk_num_bytes;
 		encoded->unencoded_len =3D em->ram_bytes;
-		encoded->unencoded_offset =3D iocb->ki_pos - (em->start - em->offset);
+		encoded->unencoded_offset =3D offset - (em->start - em->offset);
 		ret =3D btrfs_encoded_io_compression_from_extent(fs_info,
 							       extent_map_compression(em));
 		if (ret < 0)
@@ -9322,8 +9322,8 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 		 * Don't read beyond what we locked. This also limits the page
 		 * allocations that we'll do.
 		 */
-		disk_io_size =3D min(lockend + 1, iocb->ki_pos + encoded->len) - start=
;
-		count =3D start + disk_io_size - iocb->ki_pos;
+		disk_io_size =3D min(lockend + 1, offset + encoded->len) - start;
+		count =3D start + disk_io_size - offset;
 		encoded->len =3D count;
 		encoded->unencoded_len =3D count;
 		disk_io_size =3D ALIGN(disk_io_size, fs_info->sectorsize);
@@ -9339,16 +9339,13 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 		if (ret !=3D count)
 			ret =3D -EFAULT;
 	} else {
-		ret =3D btrfs_encoded_read_regular(iocb, iter, start, lockend,
-						 &cached_state, disk_bytenr,
-						 disk_io_size, count,
-						 encoded->compression,
+		ret =3D btrfs_encoded_read_regular(inode, offset, iter, start,
+						 lockend, &cached_state,
+						 disk_bytenr, disk_io_size,
+						 count, encoded->compression,
 						 &unlocked);
 	}
=20
-out:
-	if (ret >=3D 0)
-		iocb->ki_pos +=3D encoded->len;
 out_em:
 	free_extent_map(em);
 out_unlock_extent:
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e0a664b8a46a..406ed70814f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4520,7 +4520,6 @@ static int btrfs_ioctl_encoded_read(struct file *fi=
le, void __user *argp,
 	struct iovec *iov =3D iovstack;
 	struct iov_iter iter;
 	loff_t pos;
-	struct kiocb kiocb;
 	ssize_t ret;
=20
 	if (!capable(CAP_SYS_ADMIN)) {
@@ -4571,10 +4570,7 @@ static int btrfs_ioctl_encoded_read(struct file *f=
ile, void __user *argp,
 	if (ret < 0)
 		goto out_iov;
=20
-	init_sync_kiocb(&kiocb, file);
-	kiocb.ki_pos =3D pos;
-
-	ret =3D btrfs_encoded_read(&kiocb, &iter, &args);
+	ret =3D btrfs_encoded_read(file, pos, &iter, &args);
 	if (ret >=3D 0) {
 		fsnotify_access(file);
 		if (copy_to_user(argp + copy_end,
--=20
2.44.2


