Return-Path: <io-uring+bounces-3917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B45B99AB165
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E358EB240CC
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2001A0BCA;
	Tue, 22 Oct 2024 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="JqT0438M"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5271A2625
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608658; cv=none; b=S4xRPqq2C/rIBKw00QzE8HVv/TzVF5iWa5cS2nyre7HtRtU+gWvzYDnkViE5HO8+Fe/DaJ2oY41I5EQMa1iyRjnaY0B8m1d4OteATpv0HhYSU7yHVjnlwAfLjDeKlyY9AhaIKQquKfs99G+wFjLjqIa4AvKIpopvZ2TEIsem6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608658; c=relaxed/simple;
	bh=f9wbl/1eX7VxXVjF/NIOrNOYgbnJ+/NGVcPbU1q1Fm8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUniGoPphZXmyQPGM6HFWBwFl3WvCV7ixU9yigH4QNW2b3hHs1nWhqAJgc1NG+jM7G0sDqxoDCaXUCvE8ikmGu1Fz1bVPtDMjG2CbasuePaTH1v95Hik4vKxd5ErSx28UW0VARq6c2ZWryRiIDzSTFCShZHW9mh1ubcHy4eoGVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=JqT0438M; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MELR9N024551
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=3
	gyl93d9CXuarbYsxeBNAg2bX1ItLNvyUtgtZltQC3k=; b=JqT0438MXUS7tUeWz
	iQLRPEGWPYT1f7g/jwC0xChz4QGmSFBmw8kN1CkJR4AWpZ54KUh6lV/zqIb42J/t
	fDW0J4Id6As77AsHvVbxpffGxIjJ/FwXzZWaL1HBHho6PG/CIGegLpcgjY//nqqh
	ZCY69ibb71db2vMdmaaX5flrvg=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42edr5r6a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:55 -0700 (PDT)
Received: from twshared11671.02.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 22 Oct 2024 14:50:43 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id B2FCF7FDCDAB; Tue, 22 Oct 2024 15:50:32 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 3/5] btrfs: don't sleep in btrfs_encoded_read if IOCB_NOWAIT set
Date: Tue, 22 Oct 2024 15:50:18 +0100
Message-ID: <20241022145024.1046883-4-maharmstone@fb.com>
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
X-Proofpoint-GUID: 644BQD0sIEH3g-38TOAED0L89Q1VEF4_
X-Proofpoint-ORIG-GUID: 644BQD0sIEH3g-38TOAED0L89Q1VEF4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Change btrfs_encoded_read so that it returns -EAGAIN rather than sleeps
if IOCB_NOWAIT is set in iocb->ki_flags.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/inode.c | 54 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0a4dc85769c7..0c0753f20d54 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8984,12 +8984,16 @@ static ssize_t btrfs_encoded_read_inline(
 	unsigned long ptr;
 	void *tmp;
 	ssize_t ret;
+	bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
=20
 	path =3D btrfs_alloc_path();
 	if (!path) {
 		ret =3D -ENOMEM;
 		goto out;
 	}
+
+	path->nowait =3D !!nowait;
+
 	ret =3D btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(inode),
 				       extent_start, 0);
 	if (ret) {
@@ -9200,11 +9204,15 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
ruct iov_iter *iter,
 	size_t count =3D iov_iter_count(iter);
 	u64 start, lockend;
 	struct extent_map *em;
+	bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
 	bool unlocked =3D false;
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
@@ -9217,21 +9225,45 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, st=
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
--=20
2.45.2


