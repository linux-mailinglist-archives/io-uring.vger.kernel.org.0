Return-Path: <io-uring+bounces-3667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0954699D578
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81BBD1F243F7
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3271C7269;
	Mon, 14 Oct 2024 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="h4nVAtGI"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203181C6886
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728926336; cv=none; b=GwSTAfSRLBQ51vw4RSTOxAjY9O+XNJrLYScpAqeCvFvHcKUtgtfPWob66729Kp3VpGrpfFv7Sb5MhC300A2Z7+7jymjQ1nbJCs+mrDPog+hkuQvsXXAA88i1WvoQfcosLdPGvbxS16pQf7mhovvQKQVEKCtk7t2fligO7ILLPlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728926336; c=relaxed/simple;
	bh=+jY2ttBP5Dig9IMRXttT5Dd7VoHVmaV+FazNYGqs79o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dq8ptdPa3sAIRYbBPDVRuLoQM2fEfL3gc9vdDxGJxJBPC1rqpktdpbIwk8yvLLRVzUKKlclgonO60S+a45HP0gyi38H2les4eY4mPC7T5Z1w0den9XL96lDHBNjFUy8sKielgfMpdCvOOzL/ch/zOwkthGQJHTNj5Xh1faQTQmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=h4nVAtGI; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFq0ua016802
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=A
	QdFIrDSIxHKgMU2pzl/PxzqqU8KNckItGcEWUOYJ64=; b=h4nVAtGIidS/QSqwE
	cobbtGc4tvLIHNSXwlQd1MWZ5pC0xRvUIKenWVm00mEGLBeT07M4M/xGqZjEpEp1
	3BA6eLZajCZp8MKI8s/hLcUOUbussbaqxHZhnmah2NqHYIX+t429qTRKOPFd47nR
	omLU8sdfAQabK3mn8ztWlUzHkM=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4291qjtmxc-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:54 -0700 (PDT)
Received: from twshared15700.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 14 Oct 2024 17:18:51 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 59FAD7C37EF7; Mon, 14 Oct 2024 18:18:41 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 2/5] btrfs: change btrfs_encoded_read_regular_fill_pages to take a callback
Date: Mon, 14 Oct 2024 18:18:24 +0100
Message-ID: <20241014171838.304953-3-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: EdVAb20QHJClolSwux1-6XpU-pHMT1hA
X-Proofpoint-GUID: EdVAb20QHJClolSwux1-6XpU-pHMT1hA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

Change btrfs_encoded_read_regular_fill_pages so that it takes a callback
rather than waiting, and add new helper function btrfs_encoded_read_wait_=
cb
to match the existing behaviour.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/btrfs_inode.h | 13 +++++++-
 fs/btrfs/inode.c       | 70 ++++++++++++++++++++++++++++++++----------
 fs/btrfs/send.c        | 15 ++++++++-
 3 files changed, 79 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 3056c8aed8ef..6aea5bedc968 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -601,10 +601,21 @@ int btrfs_run_delalloc_range(struct btrfs_inode *in=
ode, struct page *locked_page
 int btrfs_writepage_cow_fixup(struct page *page);
 int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_in=
fo,
 					     int compress_type);
+typedef void (btrfs_encoded_read_cb_t)(void *, int);
+
+struct btrfs_encoded_read_wait_ctx {
+	wait_queue_head_t wait;
+	bool done;
+	int err;
+};
+
+void btrfs_encoded_read_wait_cb(void *ctx, int err);
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 file_offset, u64 disk_bytenr,
 					  u64 disk_io_size,
-					  struct page **pages);
+					  struct page **pages,
+					  btrfs_encoded_read_cb_t cb,
+					  void *cb_ctx);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from=
,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b024ebc3dcd6..b5abe98f3af4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9080,9 +9080,10 @@ static ssize_t btrfs_encoded_read_inline(
 }
=20
 struct btrfs_encoded_read_private {
-	wait_queue_head_t wait;
 	atomic_t pending;
 	blk_status_t status;
+	btrfs_encoded_read_cb_t *cb;
+	void *cb_ctx;
 };
=20
 static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
@@ -9100,26 +9101,33 @@ static void btrfs_encoded_read_endio(struct btrfs=
_bio *bbio)
 		 */
 		WRITE_ONCE(priv->status, bbio->bio.bi_status);
 	}
-	if (!atomic_dec_return(&priv->pending))
-		wake_up(&priv->wait);
+	if (!atomic_dec_return(&priv->pending)) {
+		priv->cb(priv->cb_ctx,
+			 blk_status_to_errno(READ_ONCE(priv->status)));
+		kfree(priv);
+	}
 	bio_put(&bbio->bio);
 }
=20
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 file_offset, u64 disk_bytenr,
-					  u64 disk_io_size, struct page **pages)
+					  u64 disk_io_size, struct page **pages,
+					  btrfs_encoded_read_cb_t cb,
+					  void *cb_ctx)
 {
 	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
-	struct btrfs_encoded_read_private priv =3D {
-		.pending =3D ATOMIC_INIT(1),
-	};
+	struct btrfs_encoded_read_private *priv;
 	unsigned long i =3D 0;
 	struct btrfs_bio *bbio;
=20
-	init_waitqueue_head(&priv.wait);
+	priv =3D kmalloc(sizeof(struct btrfs_encoded_read_private), GFP_NOFS);
+	if (!priv)
+		return -ENOMEM;
+
+	atomic_set(&priv->pending, 1);
=20
 	bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-			       btrfs_encoded_read_endio, &priv);
+			       btrfs_encoded_read_endio, priv);
 	bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 	bbio->inode =3D inode;
=20
@@ -9127,11 +9135,11 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 		size_t bytes =3D min_t(u64, disk_io_size, PAGE_SIZE);
=20
 		if (bio_add_page(&bbio->bio, pages[i], bytes, 0) < bytes) {
-			atomic_inc(&priv.pending);
+			atomic_inc(&priv->pending);
 			btrfs_submit_bio(bbio, 0);
=20
 			bbio =3D btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-					       btrfs_encoded_read_endio, &priv);
+					       btrfs_encoded_read_endio, priv);
 			bbio->bio.bi_iter.bi_sector =3D disk_bytenr >> SECTOR_SHIFT;
 			bbio->inode =3D inode;
 			continue;
@@ -9142,13 +9150,28 @@ int btrfs_encoded_read_regular_fill_pages(struct =
btrfs_inode *inode,
 		disk_io_size -=3D bytes;
 	} while (disk_io_size);
=20
-	atomic_inc(&priv.pending);
+	atomic_inc(&priv->pending);
+	priv->cb =3D cb;
+	priv->cb_ctx =3D cb_ctx;
+
 	btrfs_submit_bio(bbio, 0);
=20
-	if (atomic_dec_return(&priv.pending))
-		io_wait_event(priv.wait, !atomic_read(&priv.pending));
-	/* See btrfs_encoded_read_endio() for ordering. */
-	return blk_status_to_errno(READ_ONCE(priv.status));
+	if (!atomic_dec_return(&priv->pending)) {
+		cb(cb_ctx, blk_status_to_errno(READ_ONCE(priv->status)));
+		kfree(priv);
+	}
+
+	return 0;
+}
+
+void btrfs_encoded_read_wait_cb(void *ctx, int err)
+{
+	struct btrfs_encoded_read_wait_ctx *priv =3D ctx;
+
+	priv->err =3D err;
+	priv->done =3D true;
+
+	wake_up(&priv->wait);
 }
=20
 static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
@@ -9166,6 +9189,7 @@ static ssize_t btrfs_encoded_read_regular(struct ki=
ocb *iocb,
 	u64 cur;
 	size_t page_offset;
 	ssize_t ret;
+	struct btrfs_encoded_read_wait_ctx wait_ctx;
=20
 	nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
 	pages =3D kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
@@ -9177,11 +9201,23 @@ static ssize_t btrfs_encoded_read_regular(struct =
kiocb *iocb,
 		goto out;
 		}
=20
+	wait_ctx.done =3D false;
+	init_waitqueue_head(&wait_ctx.wait);
+
 	ret =3D btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr=
,
-						    disk_io_size, pages);
+						    disk_io_size, pages,
+						    btrfs_encoded_read_wait_cb,
+						    &wait_ctx);
 	if (ret)
 		goto out;
=20
+	io_wait_event(wait_ctx.wait, wait_ctx.done);
+
+	if (wait_ctx.err) {
+		ret =3D wait_ctx.err;
+		goto out;
+	}
+
 	unlock_extent(io_tree, start, lockend, cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	*unlocked =3D true;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 619fa0b8b3f6..52f653c6671e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5613,6 +5613,7 @@ static int send_encoded_extent(struct send_ctx *sct=
x, struct btrfs_path *path,
 	u64 disk_bytenr, disk_num_bytes;
 	u32 data_offset;
 	struct btrfs_cmd_header *hdr;
+	struct btrfs_encoded_read_wait_ctx wait_ctx;
 	u32 crc;
 	int ret;
=20
@@ -5671,6 +5672,9 @@ static int send_encoded_extent(struct send_ctx *sct=
x, struct btrfs_path *path,
 		goto out;
 	}
=20
+	wait_ctx.done =3D false;
+	init_waitqueue_head(&wait_ctx.wait);
+
 	/*
 	 * Note that send_buf is a mapping of send_buf_pages, so this is really
 	 * reading into send_buf.
@@ -5678,10 +5682,19 @@ static int send_encoded_extent(struct send_ctx *s=
ctx, struct btrfs_path *path,
 	ret =3D btrfs_encoded_read_regular_fill_pages(BTRFS_I(inode), offset,
 						    disk_bytenr, disk_num_bytes,
 						    sctx->send_buf_pages +
-						    (data_offset >> PAGE_SHIFT));
+						    (data_offset >> PAGE_SHIFT),
+						    btrfs_encoded_read_wait_cb,
+						    &wait_ctx);
 	if (ret)
 		goto out;
=20
+	io_wait_event(wait_ctx.wait, wait_ctx.done);
+
+	if (wait_ctx.err) {
+		ret =3D wait_ctx.err;
+		goto out;
+	}
+
 	hdr =3D (struct btrfs_cmd_header *)sctx->send_buf;
 	hdr->len =3D cpu_to_le32(sctx->send_size + disk_num_bytes - sizeof(*hdr=
));
 	hdr->crc =3D 0;
--=20
2.44.2


