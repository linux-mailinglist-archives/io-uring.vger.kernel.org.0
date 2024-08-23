Return-Path: <io-uring+bounces-2927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8C095D367
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 18:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56EAFB251C4
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1018E03B;
	Fri, 23 Aug 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="h6CSEA0q"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BAF18BC2F
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430513; cv=none; b=jgsIiSi22DpgBcpeUyv3vb0MGcEbZ6dJYuieO8DeBq0HsorGH2kRO5HIrYq550BfkCpnAKupIC5H8WfAcQdrNdB6WxU4hbPqbXdaobGi69AoCmSIZffmFkRpnpVkgFfFr+O5mpbvuDDvA7zvDqPDWDQU3K9g1ZH/zFbOMtJels4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430513; c=relaxed/simple;
	bh=vup+lbDEkNAQRqkCP5Qn+XYVcOT8xg+yjC+qXho+S04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/Kh6UHTm3wBj5/6oCM1cu1ojYscO2Nr44X/WbcmmlCbA1His+V5Yxk3BpYRWPXWSET90361DKt+Ub9eTrU9EkRo3s72+0fr5keaXDRucIRQ8bLQcJmxCVKl5gHeZgBnRescDP/MOWLqENfzmzhn6NiGNTaD9vPOuA8fhi0vxTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=h6CSEA0q; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 47NB7bn1019959
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	facebook; bh=VjP0L3VHYSRGm76Nt5v1NZ/6pnFxtkVG09MxxO60uWo=; b=h6C
	SEA0q86FFEsfw7VnH4NtzD+DO91MjRy//6IPO2EBCIOiCmKT+L508ybehT2aqb29
	Ja3QTnmuNE+51O+qvSzSN2TunVeQSh+5YppMAOTtci80iLLlnuWLHfYj5v1zrx5x
	uRKJsgHVrkG81ZH7PHhgXwp6+ISzWDY9DLuN3XVI=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 416c985qyf-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:30 -0700 (PDT)
Received: from twshared12613.02.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 23 Aug 2024 16:28:21 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 54F455CB7F7F; Fri, 23 Aug 2024 17:28:13 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <io-uring@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 5/6] btrfs: move wait out of btrfs_encoded_read
Date: Fri, 23 Aug 2024 17:27:47 +0100
Message-ID: <20240823162810.1668399-6-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: nLhjcISKNYVDXMIgbGDC7Wegf6iimykl
X-Proofpoint-GUID: nLhjcISKNYVDXMIgbGDC7Wegf6iimykl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_13,2024-08-22_01,2024-05-17_01

Makes it so that if btrfs_encoded_read has launched a bio, rather than
waiting for it to complete it leaves the extent and inode locked and retu=
rns
-EIOCBQUEUED. The caller is responsible for waiting on the bio, and
calling the completion code in the new btrfs_encoded_read_regular_end.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 81 +++++++++++++++++++++++-------------------
 fs/btrfs/ioctl.c       |  8 +++++
 3 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f4d77c3bb544..a5d786c6d7d4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -623,6 +623,7 @@ struct btrfs_encoded_read_private {
 };
=20
 ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
+ssize_t btrfs_encoded_read_regular_end(struct btrfs_encoded_read_private=
 *priv);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from=
,
 			       const struct btrfs_ioctl_encoded_io_args *encoded);
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e53977a4854..1bd4c74e8c51 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8999,7 +8999,7 @@ static ssize_t btrfs_encoded_read_inline(
 				struct extent_state **cached_state,
 				u64 extent_start, size_t count,
 				struct btrfs_ioctl_encoded_io_args *encoded,
-				bool *unlocked)
+				bool *need_unlock)
 {
 	struct btrfs_root *root =3D inode->root;
 	struct btrfs_fs_info *fs_info =3D root->fs_info;
@@ -9067,7 +9067,7 @@ static ssize_t btrfs_encoded_read_inline(
 	btrfs_release_path(path);
 	unlock_extent(io_tree, start, lockend, cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-	*unlocked =3D true;
+	*need_unlock =3D false;
=20
 	ret =3D copy_to_iter(tmp, count, iter);
 	if (ret !=3D count)
@@ -9155,42 +9155,26 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 	return blk_status_to_errno(READ_ONCE(priv.status));
 }
=20
-static ssize_t btrfs_encoded_read_regular(struct btrfs_encoded_read_priv=
ate *priv,
-					  u64 start, u64 lockend,
-					  u64 disk_bytenr, u64 disk_io_size,
-					  bool *unlocked)
+ssize_t btrfs_encoded_read_regular_end(struct btrfs_encoded_read_private=
 *priv)
 {
-	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
-	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	u64 cur, start, lockend;
 	unsigned long i;
-	u64 cur;
 	size_t page_offset;
-	ssize_t ret;
-
-	priv->nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
-	priv->pages =3D kcalloc(priv->nr_pages, sizeof(struct page *), GFP_NOFS=
);
-	if (!priv->pages) {
-		priv->nr_pages =3D 0;
-		return -ENOMEM;
-	}
-	ret =3D btrfs_alloc_page_array(priv->nr_pages, priv->pages, false);
-	if (ret)
-		return -ENOMEM;
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
+	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
+	struct extent_io_tree *io_tree =3D &inode->io_tree;
+	int ret;
=20
-	_btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
-					       disk_io_size, priv);
+	start =3D ALIGN_DOWN(priv->args.offset, fs_info->sectorsize);
+	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
=20
-	if (atomic_dec_return(&priv->pending))
-		io_wait_event(priv->wait, !atomic_read(&priv->pending));
+	unlock_extent(io_tree, start, lockend, &priv->cached_state);
+	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
=20
 	ret =3D blk_status_to_errno(READ_ONCE(priv->status));
 	if (ret)
 		return ret;
=20
-	unlock_extent(io_tree, start, lockend, &priv->cached_state);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-	*unlocked =3D true;
-
 	if (priv->args.compression) {
 		i =3D 0;
 		page_offset =3D 0;
@@ -9215,6 +9199,30 @@ static ssize_t btrfs_encoded_read_regular(struct b=
trfs_encoded_read_private *pri
 	return priv->count;
 }
=20
+static ssize_t btrfs_encoded_read_regular(struct btrfs_encoded_read_priv=
ate *priv,
+					  u64 disk_bytenr, u64 disk_io_size)
+{
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
+	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
+	u64 start =3D ALIGN_DOWN(priv->args.offset, fs_info->sectorsize);
+	ssize_t ret;
+
+	priv->nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
+	priv->pages =3D kcalloc(priv->nr_pages, sizeof(struct page *), GFP_NOFS=
);
+	if (!priv->pages) {
+		priv->nr_pages =3D 0;
+		return -ENOMEM;
+	}
+	ret =3D btrfs_alloc_page_array(priv->nr_pages, priv->pages, false);
+	if (ret)
+		return -ENOMEM;
+
+	_btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
+					       disk_io_size, priv);
+
+	return -EIOCBQUEUED;
+}
+
 ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv)
 {
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
@@ -9223,7 +9231,7 @@ ssize_t btrfs_encoded_read(struct btrfs_encoded_rea=
d_private *priv)
 	ssize_t ret;
 	u64 start, lockend, disk_bytenr, disk_io_size;
 	struct extent_map *em;
-	bool unlocked =3D false;
+	bool need_unlock =3D true;
=20
 	priv->count =3D iov_iter_count(&priv->iter);
=20
@@ -9278,7 +9286,7 @@ ssize_t btrfs_encoded_read(struct btrfs_encoded_rea=
d_private *priv)
 						&priv->iter, start,
 						lockend, &priv->cached_state,
 						extent_start, priv->count,
-						&priv->args, &unlocked);
+						&priv->args, &need_unlock);
 		goto out_em;
 	}
=20
@@ -9333,23 +9341,24 @@ ssize_t btrfs_encoded_read(struct btrfs_encoded_r=
ead_private *priv)
 	if (disk_bytenr =3D=3D EXTENT_MAP_HOLE) {
 		unlock_extent(io_tree, start, lockend, &priv->cached_state);
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-		unlocked =3D true;
+		need_unlock =3D false;
 		ret =3D iov_iter_zero(priv->count, &priv->iter);
 		if (ret !=3D priv->count)
 			ret =3D -EFAULT;
 	} else {
-		ret =3D btrfs_encoded_read_regular(priv, start, lockend,
-						 disk_bytenr, disk_io_size,
-						 &unlocked);
+		ret =3D btrfs_encoded_read_regular(priv, disk_bytenr, disk_io_size);
+
+		if (ret =3D=3D -EIOCBQUEUED)
+			need_unlock =3D false;
 	}
=20
 out_em:
 	free_extent_map(em);
 out_unlock_extent:
-	if (!unlocked)
+	if (need_unlock)
 		unlock_extent(io_tree, start, lockend, &priv->cached_state);
 out_unlock_inode:
-	if (!unlocked)
+	if (need_unlock)
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d2658508e055..c1886209933a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4516,6 +4516,9 @@ static ssize_t btrfs_encoded_read_finish(struct btr=
fs_encoded_read_private *priv
 					     flags);
 	unsigned long i;
=20
+	if (ret =3D=3D -EIOCBQUEUED)
+		ret =3D btrfs_encoded_read_regular_end(priv);
+
 	if (ret >=3D 0) {
 		fsnotify_access(priv->file);
 		if (copy_to_user(priv->copy_out,
@@ -4613,6 +4616,11 @@ static int btrfs_ioctl_encoded_read(struct file *f=
ile, void __user *argp,
=20
 	ret =3D btrfs_encoded_read(&priv);
=20
+	if (ret =3D=3D -EIOCBQUEUED) {
+		if (atomic_dec_return(&priv.pending))
+			io_wait_event(priv.wait, !atomic_read(&priv.pending));
+	}
+
 out:
 	return btrfs_encoded_read_finish(&priv, ret);
 }
--=20
2.44.2


