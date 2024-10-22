Return-Path: <io-uring+bounces-3914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 045689AB15F
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 142CE1C22A87
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018601A0BE0;
	Tue, 22 Oct 2024 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="LVGMSqG8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAAD7DA7C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608647; cv=none; b=X3I64rpKy1xnLFgA00/KUhPj2h5rdX6yoUC1x2sslfxgm2jTrVi7cMU13XC2BKZC831wQrPnriJPI7izt3qYz9BUV0QcoGf3Q74pC8UvzDUnZ9t0E0CR3Kw0YrncAOCJsh+qyKNziday0yEaDk5m/PE8h4Uvw6Cq0JgEfpQmqd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608647; c=relaxed/simple;
	bh=ZQqI/idDGj2CcTB3dUSpIKbEX1BYlGP7SaJ9M8tuCHw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IB5ERYv6gyYK95v6cg2SQzUqf/+Eq7YXrstJmNhzbpBCpDb800zSkWwj7W7tO1xIkhHVNxshaUbeKcC7emr5rsMetapuEz9QyJQFpqayLff2J028e681dLa9bNzH/jQqgZEi5YYZkrwMKZsluYvq7f9UYJNITzM2AEIL4zPaB+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=LVGMSqG8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MDnDJn014113
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=T
	XiqcxvRqPMP5YK4fmGwC9B8y6cWCpznsjSL1sQcVq0=; b=LVGMSqG898tmEsf3+
	tLj+mkUC70JSfigWrsKUJ+M8pHkz8m2LcJPtS7Q5SbX5RcziGTjh5BjYWC2scxuX
	4nyAfMATxlL0XESdgvqAC23E8NIIeACUHqXU7W2nE+OT5EhSvhj5hyglsV6NGyBw
	sq6cjdm0Shhe60Xiogp5wV2kOk=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ea7psg41-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:43 -0700 (PDT)
Received: from twshared17102.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 22 Oct 2024 14:50:36 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id B90F97FDCDAE; Tue, 22 Oct 2024 15:50:32 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 4/5] btrfs: move priv off stack in btrfs_encoded_read_regular_fill_pages
Date: Tue, 22 Oct 2024 15:50:19 +0100
Message-ID: <20241022145024.1046883-5-maharmstone@fb.com>
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
X-Proofpoint-GUID: Pg9jJLrA0VVTJLuycRzR_uzEB9LIOyK3
X-Proofpoint-ORIG-GUID: Pg9jJLrA0VVTJLuycRzR_uzEB9LIOyK3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Change btrfs_encoded_read_regular_fill_pages so that the priv struct is
allocated rather than stored on the stack, in preparation for adding an
asynchronous mode to the function.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/inode.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c0753f20d54..5aedb85696f4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9086,16 +9086,21 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 					  struct page **pages)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
-	struct btrfs_encoded_read_private priv =3D {
-		.pending =3D ATOMIC_INIT(1),
-	};
+	struct btrfs_encoded_read_private *priv;
 	unsigned long i =3D 0;
 	struct btrfs_bio *bbio;
+	int ret;
=20
-	init_waitqueue_head(&priv.wait);
+	priv =3D kmalloc(sizeof(struct btrfs_encoded_read_private), GFP_NOFS);
+	if (!priv)
+		return -ENOMEM;
+
+	init_waitqueue_head(&priv->wait);
+	atomic_set(&priv->pending, 1);
+	priv->status =3D 0;
=20
 	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-			       btrfs_encoded_read_endio, &priv);
+			       btrfs_encoded_read_endio, priv);
 	bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 	bbio->inode =3D inode;
=20
@@ -9103,11 +9108,11 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 		size_t bytes =3D min_t(u64, disk_io_size, PAGE_SIZE);
=20
 		if (bio_add_page(&bbio->bio, pages[i], bytes, 0) < bytes) {
-			atomic_inc(&priv.pending);
+			atomic_inc(&priv->pending);
 			btrfs_submit_bbio(bbio, 0);
=20
 			bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-					       btrfs_encoded_read_endio, &priv);
+					       btrfs_encoded_read_endio, priv);
 			bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 			bbio->inode =3D inode;
 			continue;
@@ -9118,13 +9123,15 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 		disk_io_size -=3D bytes;
 	} while (disk_io_size);
=20
-	atomic_inc(&priv.pending);
+	atomic_inc(&priv->pending);
 	btrfs_submit_bbio(bbio, 0);
=20
-	if (atomic_dec_return(&priv.pending))
-		io_wait_event(priv.wait, !atomic_read(&priv.pending));
+	if (atomic_dec_return(&priv->pending))
+		io_wait_event(priv->wait, !atomic_read(&priv->pending));
 	/* See btrfs_encoded_read_endio() for ordering. */
-	return blk_status_to_errno(READ_ONCE(priv.status));
+	ret =3D blk_status_to_errno(READ_ONCE(priv->status));
+	kfree(priv);
+	return ret;
 }
=20
 ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *=
iter,
--=20
2.45.2


