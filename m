Return-Path: <io-uring+bounces-2928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9D695D368
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 18:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18B741F213AC
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE3B18BBAC;
	Fri, 23 Aug 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="BfFMyyHJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF3A18BBA3
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430514; cv=none; b=eUajpJc0Gwzq0YThmE2PiiO6xFPkI9cdTrPke4gA7s5KH1r6YRpOOO6FUBiPqd7WHcvCPL7BA9CTJ8YtTED2rsHxrY3DhwRl8sQ2LvOJx7tOtxeeR+f2qNrYg87HbwVpBqo4jCIkld6XqmS4iIrPpF+Dw70QJptxLF49OSEaARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430514; c=relaxed/simple;
	bh=3BUjJP6euw9heKTHs5na1R+iVCs+Nh6MPzOueJpzpYQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTAvxAJtYLq32unaaQJsl8uuPFWmAlFw5vDhqA8MGNOkEQH6CsZZvuygN2fT1ABisZfX7GHyf5cQANJ3zznXegdvryRNBt+7yb6XguB74tGdLYoYNhU3SQ6fRgnPt6uK1TWyKrNLTvhVqPL92lmHpdTL2WxEtgTbtKIr9loKyjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=BfFMyyHJ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 47NB7bn2019959
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	facebook; bh=F/ztbZY2l7t/Mj+l4zbIEwOJD41eU6L39figuRFSLxQ=; b=BfF
	MyyHJO5qTp/e8VhxzhjsPnJYteqJx8AwgpbLCiqtU1PoTYBEPadk30+O1KS4L8UM
	j1/e4cHDzBXkPk3RntuFnpGxbZprQFlBNZL6Y5Sy/ClxIVPRb2Wgp/vWYCCDgZIv
	bLtlJgIH876NtFqbmyCfEGhDGy2SMMpaueeIj6ec=
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 416c985qyf-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 09:28:31 -0700 (PDT)
Received: from twshared12613.02.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 23 Aug 2024 16:28:21 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 3C7975CB7F79; Fri, 23 Aug 2024 17:28:13 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <io-uring@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 2/6] btrfs: store encoded read state in struct btrfs_encoded_read_private
Date: Fri, 23 Aug 2024 17:27:44 +0100
Message-ID: <20240823162810.1668399-3-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: z0DP7hNAVUurq8UIBURVpiDDOzPXvV_v
X-Proofpoint-GUID: z0DP7hNAVUurq8UIBURVpiDDOzPXvV_v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_13,2024-08-22_01,2024-05-17_01

Move the various stack variables needed for encoded reads into struct
btrfs_encoded_read_private, so that we can split it into several
functions.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  20 ++++-
 fs/btrfs/inode.c       | 170 +++++++++++++++++++++--------------------
 fs/btrfs/ioctl.c       |  60 ++++++++-------
 3 files changed, 135 insertions(+), 115 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index affe70929234..5cd4308bd337 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -605,9 +605,23 @@ int btrfs_encoded_read_regular_fill_pages(struct btr=
fs_inode *inode,
 					  u64 file_offset, u64 disk_bytenr,
 					  u64 disk_io_size,
 					  struct page **pages);
-ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
-			   struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded);
+
+struct btrfs_encoded_read_private {
+	wait_queue_head_t wait;
+	atomic_t pending;
+	blk_status_t status;
+	unsigned long nr_pages;
+	struct page **pages;
+	struct extent_state *cached_state;
+	size_t count;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov;
+	struct iov_iter iter;
+	struct btrfs_ioctl_encoded_io_args args;
+	struct file *file;
+};
+
+ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from=
,
 			       const struct btrfs_ioctl_encoded_io_args *encoded);
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0cc029d95ed..c1292e58366a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9078,12 +9078,6 @@ static ssize_t btrfs_encoded_read_inline(
 	return ret;
 }
=20
-struct btrfs_encoded_read_private {
-	wait_queue_head_t wait;
-	atomic_t pending;
-	blk_status_t status;
-};
-
 static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
 {
 	struct btrfs_encoded_read_private *priv =3D bbio->private;
@@ -9104,33 +9098,31 @@ static void btrfs_encoded_read_endio(struct btrfs=
_bio *bbio)
 	bio_put(&bbio->bio);
 }
=20
-int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
-					  u64 file_offset, u64 disk_bytenr,
-					  u64 disk_io_size, struct page **pages)
+static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *i=
node,
+					u64 file_offset, u64 disk_bytenr,
+					u64 disk_io_size,
+					struct btrfs_encoded_read_private *priv)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
-	struct btrfs_encoded_read_private priv =3D {
-		.pending =3D ATOMIC_INIT(1),
-	};
 	unsigned long i =3D 0;
 	struct btrfs_bio *bbio;
=20
-	init_waitqueue_head(&priv.wait);
+	init_waitqueue_head(&priv->wait);
=20
 	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-			       btrfs_encoded_read_endio, &priv);
+			       btrfs_encoded_read_endio, priv);
 	bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 	bbio->inode =3D inode;
=20
 	do {
 		size_t bytes =3D min_t(u64, disk_io_size, PAGE_SIZE);
=20
-		if (bio_add_page(&bbio->bio, pages[i], bytes, 0) < bytes) {
-			atomic_inc(&priv.pending);
+		if (bio_add_page(&bbio->bio, priv->pages[i], bytes, 0) < bytes) {
+			atomic_inc(&priv->pending);
 			btrfs_submit_bio(bbio, 0);
=20
 			bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-					       btrfs_encoded_read_endio, &priv);
+					       btrfs_encoded_read_endio, priv);
 			bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 			bbio->inode =3D inode;
 			continue;
@@ -9141,8 +9133,21 @@ int btrfs_encoded_read_regular_fill_pages(struct b=
trfs_inode *inode,
 		disk_io_size -=3D bytes;
 	} while (disk_io_size);
=20
-	atomic_inc(&priv.pending);
+	atomic_inc(&priv->pending);
 	btrfs_submit_bio(bbio, 0);
+}
+
+int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
+					  u64 file_offset, u64 disk_bytenr,
+					  u64 disk_io_size, struct page **pages)
+{
+	struct btrfs_encoded_read_private priv =3D {
+		.pending =3D ATOMIC_INIT(1),
+		.pages =3D pages,
+	};
+
+	_btrfs_encoded_read_regular_fill_pages(inode, file_offset, disk_bytenr,
+					       disk_io_size, &priv);
=20
 	if (atomic_dec_return(&priv.pending))
 		io_wait_event(priv.wait, !atomic_read(&priv.pending));
@@ -9150,54 +9155,56 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 	return blk_status_to_errno(READ_ONCE(priv.status));
 }
=20
-static ssize_t btrfs_encoded_read_regular(struct btrfs_inode *inode,
-					  loff_t offset, struct iov_iter *iter,
+static ssize_t btrfs_encoded_read_regular(struct btrfs_encoded_read_priv=
ate *priv,
 					  u64 start, u64 lockend,
-					  struct extent_state **cached_state,
 					  u64 disk_bytenr, u64 disk_io_size,
-					  size_t count, bool compressed,
 					  bool *unlocked)
 {
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
-	struct page **pages;
-	unsigned long nr_pages, i;
+	unsigned long i;
 	u64 cur;
 	size_t page_offset;
 	ssize_t ret;
=20
-	nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
-	pages =3D kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
-	if (!pages)
+	priv->nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
+	priv->pages =3D kcalloc(priv->nr_pages, sizeof(struct page *), GFP_NOFS=
);
+	if (!priv->pages)
 		return -ENOMEM;
-	ret =3D btrfs_alloc_page_array(nr_pages, pages, false);
+	ret =3D btrfs_alloc_page_array(priv->nr_pages, priv->pages, false);
 	if (ret) {
 		ret =3D -ENOMEM;
 		goto out;
 		}
=20
-	ret =3D btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr=
,
-						    disk_io_size, pages);
+	_btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
+					       disk_io_size, priv);
+
+	if (atomic_dec_return(&priv->pending))
+		io_wait_event(priv->wait, !atomic_read(&priv->pending));
+
+	ret =3D blk_status_to_errno(READ_ONCE(priv->status));
 	if (ret)
 		goto out;
=20
-	unlock_extent(io_tree, start, lockend, cached_state);
+	unlock_extent(io_tree, start, lockend, &priv->cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	*unlocked =3D true;
=20
-	if (compressed) {
+	if (priv->args.compression) {
 		i =3D 0;
 		page_offset =3D 0;
 	} else {
-		i =3D (offset - start) >> PAGE_SHIFT;
-		page_offset =3D (offset - start) & (PAGE_SIZE - 1);
+		i =3D (priv->args.offset - start) >> PAGE_SHIFT;
+		page_offset =3D (priv->args.offset - start) & (PAGE_SIZE - 1);
 	}
 	cur =3D 0;
-	while (cur < count) {
-		size_t bytes =3D min_t(size_t, count - cur,
+	while (cur < priv->count) {
+		size_t bytes =3D min_t(size_t, priv->count - cur,
 				     PAGE_SIZE - page_offset);
=20
-		if (copy_page_to_iter(pages[i], page_offset, bytes,
-				      iter) !=3D bytes) {
+		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
+				      &priv->iter) !=3D bytes) {
 			ret =3D -EFAULT;
 			goto out;
 		}
@@ -9205,42 +9212,40 @@ static ssize_t btrfs_encoded_read_regular(struct =
btrfs_inode *inode,
 		cur +=3D bytes;
 		page_offset =3D 0;
 	}
-	ret =3D count;
+	ret =3D priv->count;
 out:
-	for (i =3D 0; i < nr_pages; i++) {
-		if (pages[i])
-			__free_page(pages[i]);
+	for (i =3D 0; i < priv->nr_pages; i++) {
+		if (priv->pages[i])
+			__free_page(priv->pages[i]);
 	}
-	kfree(pages);
+	kfree(priv->pages);
 	return ret;
 }
=20
-ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
-			   struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded)
+ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv)
 {
-	struct btrfs_inode *inode =3D BTRFS_I(file_inode(file));
+	struct btrfs_inode *inode =3D BTRFS_I(file_inode(priv->file));
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
 	struct extent_io_tree *io_tree =3D &inode->io_tree;
 	ssize_t ret;
-	size_t count =3D iov_iter_count(iter);
 	u64 start, lockend, disk_bytenr, disk_io_size;
-	struct extent_state *cached_state =3D NULL;
 	struct extent_map *em;
 	bool unlocked =3D false;
=20
-	file_accessed(file);
+	priv->count =3D iov_iter_count(&priv->iter);
+
+	file_accessed(priv->file);
=20
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
=20
-	if (offset >=3D inode->vfs_inode.i_size) {
+	if (priv->args.offset >=3D inode->vfs_inode.i_size) {
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		return 0;
 	}
-	start =3D ALIGN_DOWN(offset, fs_info->sectorsize);
+	start =3D ALIGN_DOWN(priv->args.offset, fs_info->sectorsize);
 	/*
-	 * We don't know how long the extent containing offset is, but if
-	 * it's compressed we know that it won't be longer than this.
+	 * We don't know how long the extent containing priv->args.offset is,
+	 * but if it's compressed we know that it won't be longer than this.
 	 */
 	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
=20
@@ -9251,13 +9256,13 @@ ssize_t btrfs_encoded_read(struct file *file, lof=
f_t offset,
 					       lockend - start + 1);
 		if (ret)
 			goto out_unlock_inode;
-		lock_extent(io_tree, start, lockend, &cached_state);
+		lock_extent(io_tree, start, lockend, &priv->cached_state);
 		ordered =3D btrfs_lookup_ordered_range(inode, start,
 						     lockend - start + 1);
 		if (!ordered)
 			break;
 		btrfs_put_ordered_extent(ordered);
-		unlock_extent(io_tree, start, lockend, &cached_state);
+		unlock_extent(io_tree, start, lockend, &priv->cached_state);
 		cond_resched();
 	}
=20
@@ -9276,10 +9281,11 @@ ssize_t btrfs_encoded_read(struct file *file, lof=
f_t offset,
 		 */
 		free_extent_map(em);
 		em =3D NULL;
-		ret =3D btrfs_encoded_read_inline(inode, offset, iter, start,
-						lockend, &cached_state,
-						extent_start, count, encoded,
-						&unlocked);
+		ret =3D btrfs_encoded_read_inline(inode, priv->args.offset,
+						&priv->iter, start,
+						lockend, &priv->cached_state,
+						extent_start, priv->count,
+						&priv->args, &unlocked);
 		goto out_em;
 	}
=20
@@ -9287,62 +9293,60 @@ ssize_t btrfs_encoded_read(struct file *file, lof=
f_t offset,
 	 * We only want to return up to EOF even if the extent extends beyond
 	 * that.
 	 */
-	encoded->len =3D min_t(u64, extent_map_end(em),
-			     inode->vfs_inode.i_size) - offset;
+	priv->args.len =3D min_t(u64, extent_map_end(em),
+			     inode->vfs_inode.i_size) - priv->args.offset;
 	if (em->disk_bytenr =3D=3D EXTENT_MAP_HOLE ||
 	    (em->flags & EXTENT_FLAG_PREALLOC)) {
 		disk_bytenr =3D EXTENT_MAP_HOLE;
-		count =3D min_t(u64, count, encoded->len);
-		encoded->len =3D count;
-		encoded->unencoded_len =3D count;
+		priv->count =3D min_t(u64, priv->count, priv->args.len);
+		priv->args.len =3D priv->count;
+		priv->args.unencoded_len =3D priv->count;
 	} else if (extent_map_is_compressed(em)) {
 		disk_bytenr =3D em->disk_bytenr;
 		/*
 		 * Bail if the buffer isn't large enough to return the whole
 		 * compressed extent.
 		 */
-		if (em->disk_num_bytes > count) {
+		if (em->disk_num_bytes > priv->count) {
 			ret =3D -ENOBUFS;
 			goto out_em;
 		}
 		disk_io_size =3D em->disk_num_bytes;
-		count =3D em->disk_num_bytes;
-		encoded->unencoded_len =3D em->ram_bytes;
-		encoded->unencoded_offset =3D offset - (em->start - em->offset);
+		priv->count =3D em->disk_num_bytes;
+		priv->args.unencoded_len =3D em->ram_bytes;
+		priv->args.unencoded_offset =3D priv->args.offset - (em->start - em->o=
ffset);
 		ret =3D btrfs_encoded_io_compression_from_extent(fs_info,
 							       extent_map_compression(em));
 		if (ret < 0)
 			goto out_em;
-		encoded->compression =3D ret;
+		priv->args.compression =3D ret;
 	} else {
 		disk_bytenr =3D extent_map_block_start(em) + (start - em->start);
-		if (encoded->len > count)
-			encoded->len =3D count;
+		if (priv->args.len > priv->count)
+			priv->args.len =3D priv->count;
 		/*
 		 * Don't read beyond what we locked. This also limits the page
 		 * allocations that we'll do.
 		 */
-		disk_io_size =3D min(lockend + 1, offset + encoded->len) - start;
-		count =3D start + disk_io_size - offset;
-		encoded->len =3D count;
-		encoded->unencoded_len =3D count;
+		disk_io_size =3D min(lockend + 1, priv->args.offset + priv->args.len) =
- start;
+		priv->count =3D start + disk_io_size - priv->args.offset;
+		priv->args.len =3D priv->count;
+		priv->args.unencoded_len =3D priv->count;
 		disk_io_size =3D ALIGN(disk_io_size, fs_info->sectorsize);
 	}
 	free_extent_map(em);
 	em =3D NULL;
=20
 	if (disk_bytenr =3D=3D EXTENT_MAP_HOLE) {
-		unlock_extent(io_tree, start, lockend, &cached_state);
+		unlock_extent(io_tree, start, lockend, &priv->cached_state);
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		unlocked =3D true;
-		ret =3D iov_iter_zero(count, iter);
-		if (ret !=3D count)
+		ret =3D iov_iter_zero(priv->count, &priv->iter);
+		if (ret !=3D priv->count)
 			ret =3D -EFAULT;
 	} else {
-		ret =3D btrfs_encoded_read_regular(inode, offset, iter, start,
-						 lockend, &cached_state,
+		ret =3D btrfs_encoded_read_regular(priv, start, lockend,
 						 disk_bytenr, disk_io_size,
-						 count, encoded->compression,
 						 &unlocked);
 	}
=20
@@ -9350,7 +9354,7 @@ ssize_t btrfs_encoded_read(struct file *file, loff_=
t offset,
 	free_extent_map(em);
 out_unlock_extent:
 	if (!unlocked)
-		unlock_extent(io_tree, start, lockend, &cached_state);
+		unlock_extent(io_tree, start, lockend, &priv->cached_state);
 out_unlock_inode:
 	if (!unlocked)
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 406ed70814f5..770bd609f386 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4512,19 +4512,19 @@ static int _btrfs_ioctl_send(struct btrfs_inode *=
inode, void __user *argp, bool
 static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp=
,
 				    bool compat)
 {
-	struct btrfs_ioctl_encoded_io_args args =3D { 0 };
 	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io_ar=
gs,
 					     flags);
 	size_t copy_end;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov =3D iovstack;
-	struct iov_iter iter;
 	loff_t pos;
 	ssize_t ret;
+	struct btrfs_encoded_read_private priv =3D {
+		.pending =3D ATOMIC_INIT(1),
+		.file =3D file,
+	};
=20
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret =3D -EPERM;
-		goto out_acct;
+		goto out;
 	}
=20
 	if (compat) {
@@ -4535,53 +4535,55 @@ static int btrfs_ioctl_encoded_read(struct file *=
file, void __user *argp,
 				       flags);
 		if (copy_from_user(&args32, argp, copy_end)) {
 			ret =3D -EFAULT;
-			goto out_acct;
+			goto out;
 		}
-		args.iov =3D compat_ptr(args32.iov);
-		args.iovcnt =3D args32.iovcnt;
-		args.offset =3D args32.offset;
-		args.flags =3D args32.flags;
+		priv.args.iov =3D compat_ptr(args32.iov);
+		priv.args.iovcnt =3D args32.iovcnt;
+		priv.args.offset =3D args32.offset;
+		priv.args.flags =3D args32.flags;
 #else
 		return -ENOTTY;
 #endif
 	} else {
 		copy_end =3D copy_end_kernel;
-		if (copy_from_user(&args, argp, copy_end)) {
+		if (copy_from_user(&priv.args, argp, copy_end)) {
 			ret =3D -EFAULT;
-			goto out_acct;
+			goto out;
 		}
 	}
-	if (args.flags !=3D 0) {
+	if (priv.args.flags !=3D 0) {
 		ret =3D -EINVAL;
-		goto out_acct;
+		goto out;
 	}
=20
-	ret =3D import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovst=
ack),
-			   &iov, &iter);
-	if (ret < 0)
-		goto out_acct;
+	priv.iov =3D priv.iovstack;
+	ret =3D import_iovec(ITER_DEST, priv.args.iov, priv.args.iovcnt,
+			   ARRAY_SIZE(priv.iovstack), &priv.iov, &priv.iter);
+	if (ret < 0) {
+		priv.iov =3D NULL;
+		goto out;
+	}
=20
-	if (iov_iter_count(&iter) =3D=3D 0) {
+	if (iov_iter_count(&priv.iter) =3D=3D 0) {
 		ret =3D 0;
-		goto out_iov;
+		goto out;
 	}
-	pos =3D args.offset;
-	ret =3D rw_verify_area(READ, file, &pos, args.len);
+	pos =3D priv.args.offset;
+	ret =3D rw_verify_area(READ, file, &pos, priv.args.len);
 	if (ret < 0)
-		goto out_iov;
+		goto out;
=20
-	ret =3D btrfs_encoded_read(file, pos, &iter, &args);
+	ret =3D btrfs_encoded_read(&priv);
 	if (ret >=3D 0) {
 		fsnotify_access(file);
 		if (copy_to_user(argp + copy_end,
-				 (char *)&args + copy_end_kernel,
-				 sizeof(args) - copy_end_kernel))
+				 (char *)&priv.args + copy_end_kernel,
+				 sizeof(priv.args) - copy_end_kernel))
 			ret =3D -EFAULT;
 	}
=20
-out_iov:
-	kfree(iov);
-out_acct:
+out:
+	kfree(priv.iov);
 	if (ret > 0)
 		add_rchar(current, ret);
 	inc_syscr(current);
--=20
2.44.2


