Return-Path: <io-uring+bounces-3666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3D199D576
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2FD1F245DF
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52ED71AE877;
	Mon, 14 Oct 2024 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="DJD2pN76"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975D1C3043
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728926334; cv=none; b=bWQLf/REe2xe/tMTC6dNrS4/sNg1NesmRhGM0579thaewSdJYy1INUspGDxoK0kAbAwezI4dne6+g+m+Tv13SRHMtDGfz48m7BP5e/FMA3ntUcoKwPP76JEf1LJZxDf9b516pzPdb4UBi7NoBR7idMbPy4lwDs/dCgn/IyPr30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728926334; c=relaxed/simple;
	bh=u8khLLW0mzAXMiZS0b/PXGtg1M2asSzaC2A75PtYCGY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmOU6saQoLUmDRraGmbmWxB2+bx7gQuRu0OK4eMTpORCRdwpFNXxeVXfmiZTgcpk2uhGF4BlfDM6R+PiOmUF1vcTq3i0ZQ23co79vl54x/z8rD7kc934xpFSHZgpNw6jc+aRvSQeLlsAn9yP2jlLIMyIgvU0c29MeGD5/yX29c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=DJD2pN76; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFpvAk016458
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=Q
	bK7XlHj81nVEGT/LQTkXlSZupLHFZV6qwSB1jiwNpo=; b=DJD2pN76iOfwyGOse
	h/e6P3QfV3V4DA3UNNRs1pPN2FdoJz87ckE+VQvT9CuwWZVjN5aJATBEqV+QUf/F
	kx4W5AS2krrs/gD7VFdEjsERDBwPabpM2x/tDppxU/4F3qIQ7M5ZsA+f7zvgbcLH
	GLoVhy8iovaUENmUMo/HvgirGo=
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4291qjtmy8-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:51 -0700 (PDT)
Received: from twshared13976.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 14 Oct 2024 17:18:46 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 5E0357C37EFA; Mon, 14 Oct 2024 18:18:41 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 4/5] btrfs: add nowait parameter to btrfs_encoded_read
Date: Mon, 14 Oct 2024 18:18:26 +0100
Message-ID: <20241014171838.304953-5-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: LvH7s88OhNF9H3IaBJ9o_BBqKQ8GLwOO
X-Proofpoint-GUID: LvH7s88OhNF9H3IaBJ9o_BBqKQ8GLwOO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

Adds a nowait parameter to btrfs_encoded_read, which if it is true
causes the function to return -EAGAIN rather than sleeping.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h |  2 +-
 fs/btrfs/inode.c       | 59 ++++++++++++++++++++++++++++++++----------
 fs/btrfs/ioctl.c       |  2 +-
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 3a0b519c51ca..2334961e71ed 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -618,7 +618,7 @@ int btrfs_encoded_read_regular_fill_pages(struct btrf=
s_inode *inode,
 					  void *cb_ctx);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded,
-			   struct extent_state **cached_state,
+			   bool nowait, struct extent_state **cached_state,
 			   u64 *disk_bytenr, u64 *disk_io_size);
 ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *=
iter,
 				   u64 start, u64 lockend,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e58284d33b35..c536e37cb6b6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8999,7 +8999,7 @@ static ssize_t btrfs_encoded_read_inline(
 				struct extent_state **cached_state,
 				u64 extent_start, size_t count,
 				struct btrfs_ioctl_encoded_io_args *encoded,
-				bool *unlocked)
+				bool *unlocked, bool nowait)
 {
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_root *root =3D inode->root;
@@ -9018,6 +9018,9 @@ static ssize_t btrfs_encoded_read_inline(
 		ret =3D -ENOMEM;
 		goto out;
 	}
+
+	path->nowait =3D !!nowait;
+
 	ret =3D btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(inode),
 				       extent_start, 0);
 	if (ret) {
@@ -9254,7 +9257,7 @@ ssize_t btrfs_encoded_read_regular(struct kiocb *io=
cb, struct iov_iter *iter,
=20
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded,
-			   struct extent_state **cached_state,
+			   bool nowait, struct extent_state **cached_state,
 			   u64 *disk_bytenr, u64 *disk_io_size)
 {
 	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
@@ -9268,7 +9271,10 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, str=
uct iov_iter *iter,
=20
 	file_accessed(iocb->ki_filp);
=20
-	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
+	ret =3D btrfs_inode_lock(inode,
+			       BTRFS_ILOCK_SHARED | (nowait ? BTRFS_ILOCK_TRY : 0));
+	if (ret)
+		return ret;
=20
 	if (iocb->ki_pos >=3D inode->vfs_inode.i_size) {
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
@@ -9281,21 +9287,45 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 	 */
 	lockend =3D start + BTRFS_MAX_UNCOMPRESSED - 1;
=20
-	for (;;) {
+	if (nowait) {
 		struct btrfs_ordered_extent *ordered;
=20
-		ret =3D btrfs_wait_ordered_range(inode, start,
-					       lockend - start + 1);
-		if (ret)
+		if (filemap_range_needs_writeback(inode->vfs_inode.i_mapping,
+						  start, lockend)) {
+			ret =3D -EAGAIN;
 			goto out_unlock_inode;
-		lock_extent(io_tree, start, lockend, cached_state);
+		}
+
+		if (!try_lock_extent(io_tree, start, lockend, cached_state)) {
+			ret =3D -EAGAIN;
+			goto out_unlock_inode;
+		}
+
 		ordered =3D btrfs_lookup_ordered_range(inode, start,
 						     lockend - start + 1);
-		if (!ordered)
-			break;
-		btrfs_put_ordered_extent(ordered);
-		unlock_extent(io_tree, start, lockend, cached_state);
-		cond_resched();
+		if (ordered) {
+			btrfs_put_ordered_extent(ordered);
+			unlock_extent(io_tree, start, lockend, cached_state);
+			ret =3D -EAGAIN;
+			goto out_unlock_inode;
+		}
+	} else {
+		for (;;) {
+			struct btrfs_ordered_extent *ordered;
+
+			ret =3D btrfs_wait_ordered_range(inode, start,
+						lockend - start + 1);
+			if (ret)
+				goto out_unlock_inode;
+			lock_extent(io_tree, start, lockend, cached_state);
+			ordered =3D btrfs_lookup_ordered_range(inode, start,
+							lockend - start + 1);
+			if (!ordered)
+				break;
+			btrfs_put_ordered_extent(ordered);
+			unlock_extent(io_tree, start, lockend, cached_state);
+			cond_resched();
+		}
 	}
=20
 	em =3D btrfs_get_extent(inode, NULL, start, lockend - start + 1);
@@ -9315,7 +9345,8 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 		em =3D NULL;
 		ret =3D btrfs_encoded_read_inline(iocb, iter, start, lockend,
 						cached_state, extent_start,
-						count, encoded, &unlocked);
+						count, encoded, &unlocked,
+						nowait);
 		goto out_em;
 	}
=20
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e2ecf0bcda24..8c9ff4898ab0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4579,7 +4579,7 @@ static int btrfs_ioctl_encoded_read(struct file *fi=
le, void __user *argp,
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos =3D pos;
=20
-	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
+	ret =3D btrfs_encoded_read(&kiocb, &iter, &args, false, &cached_state,
 				 &disk_bytenr, &disk_io_size);
=20
 	if (ret =3D=3D -EIOCBQUEUED) {
--=20
2.44.2


