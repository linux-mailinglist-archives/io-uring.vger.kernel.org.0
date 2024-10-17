Return-Path: <io-uring+bounces-3794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1AD9A282C
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 841361F21049
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A023B7D3F4;
	Thu, 17 Oct 2024 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="R3hoP7VR"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880331D95B5
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181588; cv=none; b=aNGgxnwWhkgtpE5DxJTF7t5FX3/VvOm57zReLh3x+9btjomryksHI3hixNw57xDmGCdcUdZiG0Lv6hHu7Ne3FcnN1tvJ03zL4Dhq7v7F9IXJ2yTFzpeePXjX1D0inkOIEy11jLbpclj6T9KGtXbgTzXC80Chs0u6D0XuhSJmoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181588; c=relaxed/simple;
	bh=RaJWIJh/DiVAdUI7KCm5HwoZmUdvvS0hR2E+rcnqMhg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jhoadkSlLnJOX7BXYKTYltbHNcBW6yz1tHmf/nrNgViDAiVZW2WRpfj1KRQOHJ17a4dvusVVZ/G16ax5nV2Kxr9CXjrBDojVvYCEcGeBggEjUAtY0f6ArK1kK1dH0x39wU3F26zcRfVKV8j9+bPRozm6hUr/oX9Pq7IzjoTeVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=R3hoP7VR; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49HChDXC024703
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:13:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=iWtes4q52ch0yD+cMaKAQwN0cKm8w/0t0MM6PKPQXDs=; b=R3hoP7VRBd3E
	szLhqAtpjscsyJaGsll4Wyj6CbEk4HtJnWtZ1dUcp4TQ0wh12uL0xq7gO372ZOnk
	P5QzD70MtVn7feHhSYVF3SzjB6ddQIyi/fT+y2VGhuAqHzZdi8BWFhOYMFFcn0nP
	qYr48pzwYguZrTCabgV51PhnRxTBHjVSzkrwNG7MdxfIbd+q+jNNnkidyuErSXR5
	zOxRqpMvwypR3VU2fSq4l0sPqww6+99rDPDAq00+SWYhCng1QLZGWe983sWXgIpW
	RVo7kajYIOBwlxT5vEim3ZkMVHd6iZSQevoz3EfMazJZw2nADudlkenuDccN9Ulr
	EiGsGGAqMg==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 42a8wmb2by-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:13:02 -0700 (PDT)
Received: from twshared4354.35.frc1.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 17 Oct 2024 16:12:59 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 16DCD143A4AA1; Thu, 17 Oct 2024 09:09:57 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <axboe@kernel.dk>, <hch@lst.de>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
        Hannes
 Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv8 1/6] block, fs: restore kiocb based write hint processing
Date: Thu, 17 Oct 2024 09:09:32 -0700
Message-ID: <20241017160937.2283225-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241017160937.2283225-1-kbusch@meta.com>
References: <20241017160937.2283225-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 7_aiPOcYKegcvp5dpBxr4G6-i2keVuZU
X-Proofpoint-ORIG-GUID: 7_aiPOcYKegcvp5dpBxr4G6-i2keVuZU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Kanchan Joshi <joshi.k@samsung.com>

struct kiocb has a 2 bytes hole that developed post commit 41d36a9f3e53
("fs: remove kiocb.ki_hint"). But write hint returned with commit
449813515d3e ("block, fs: Restore the per-bio/request data lifetime
fields").

This patch uses the leftover space in kiocb to carve 2 byte field
ki_write_hint. Restore the code that operates on kiocb to use
ki_write_hint instead of inode hint value.

This does not change any behavior, but needed to enable per-io hints.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c         | 6 +++---
 fs/aio.c             | 1 +
 fs/cachefiles/io.c   | 1 +
 fs/direct-io.c       | 2 +-
 fs/iomap/direct-io.c | 2 +-
 include/linux/fs.h   | 8 ++++++++
 io_uring/rw.c        | 1 +
 7 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index e696ae53bf1e0..85b9b97d372c8 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -74,7 +74,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *=
iocb,
 		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
 	}
 	bio.bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-	bio.bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_hint =3D iocb->ki_write_hint;
 	bio.bi_ioprio =3D iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |=3D REQ_ATOMIC;
@@ -203,7 +203,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb,=
 struct iov_iter *iter,
=20
 	for (;;) {
 		bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-		bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_hint =3D iocb->ki_write_hint;
 		bio->bi_private =3D dio;
 		bio->bi_end_io =3D blkdev_bio_end_io;
 		bio->bi_ioprio =3D iocb->ki_ioprio;
@@ -319,7 +319,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb =
*iocb,
 	dio->flags =3D 0;
 	dio->iocb =3D iocb;
 	bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-	bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_hint =3D iocb->ki_write_hint;
 	bio->bi_end_io =3D blkdev_bio_end_io_async;
 	bio->bi_ioprio =3D iocb->ki_ioprio;
=20
diff --git a/fs/aio.c b/fs/aio.c
index e8920178b50f7..db618817e670d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1517,6 +1517,7 @@ static int aio_prep_rw(struct kiocb *req, const str=
uct iocb *iocb, int rw_type)
 	req->ki_flags =3D req->ki_filp->f_iocb_flags | IOCB_AIO_RW;
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |=3D IOCB_EVENTFD;
+	req->ki_write_hint =3D file_write_hint(req->ki_filp);
 	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
 		/*
 		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set, then
diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 6a821a959b59e..c3db102ae64e2 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -309,6 +309,7 @@ int __cachefiles_write(struct cachefiles_object *obje=
ct,
 	ki->iocb.ki_pos		=3D start_pos;
 	ki->iocb.ki_flags	=3D IOCB_DIRECT | IOCB_WRITE;
 	ki->iocb.ki_ioprio	=3D get_current_ioprio();
+	ki->iocb.ki_write_hint  =3D file_write_hint(file);
 	ki->object		=3D object;
 	ki->start		=3D start_pos;
 	ki->len			=3D len;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index bbd05f1a21453..73629e26becbe 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -409,7 +409,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdi=
o,
 		bio->bi_end_io =3D dio_bio_end_io;
 	if (dio->is_pinned)
 		bio_set_flag(bio, BIO_PAGE_PINNED);
-	bio->bi_write_hint =3D file_inode(dio->iocb->ki_filp)->i_write_hint;
+	bio->bi_write_hint =3D dio->iocb->ki_write_hint;
=20
 	sdio->bio =3D bio;
 	sdio->logical_offset_in_bio =3D sdio->cur_page_fs_offset;
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f637aa0706a31..fff43f121ee65 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -397,7 +397,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_i=
ter *iter,
 		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 					  GFP_KERNEL);
 		bio->bi_iter.bi_sector =3D iomap_sector(iomap, pos);
-		bio->bi_write_hint =3D inode->i_write_hint;
+		bio->bi_write_hint =3D dio->iocb->ki_write_hint;
 		bio->bi_ioprio =3D dio->iocb->ki_ioprio;
 		bio->bi_private =3D dio;
 		bio->bi_end_io =3D iomap_dio_bio_end_io;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3559446279c15..04e875a37f604 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -370,6 +370,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
+	u16			ki_write_hint;
 	union {
 		/*
 		 * Only used for async buffered reads, where it denotes the
@@ -2337,12 +2338,18 @@ static inline bool HAS_UNMAPPED_ID(struct mnt_idm=
ap *idmap,
 	       !vfsgid_valid(i_gid_into_vfsgid(idmap, inode));
 }
=20
+static inline enum rw_hint file_write_hint(struct file *filp)
+{
+	return file_inode(filp)->i_write_hint;
+}
+
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *fil=
p)
 {
 	*kiocb =3D (struct kiocb) {
 		.ki_filp =3D filp,
 		.ki_flags =3D filp->f_iocb_flags,
 		.ki_ioprio =3D get_current_ioprio(),
+		.ki_write_hint =3D file_write_hint(filp),
 	};
 }
=20
@@ -2353,6 +2360,7 @@ static inline void kiocb_clone(struct kiocb *kiocb,=
 struct kiocb *kiocb_src,
 		.ki_filp =3D filp,
 		.ki_flags =3D kiocb_src->ki_flags,
 		.ki_ioprio =3D kiocb_src->ki_ioprio,
+		.ki_write_hint =3D kiocb_src->ki_write_hint,
 		.ki_pos =3D kiocb_src->ki_pos,
 	};
 }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 80ae3c2ebb70c..ffd637ca0bd17 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1027,6 +1027,7 @@ int io_write(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res =3D iov_iter_count(&io->iter);
+	rw->kiocb.ki_write_hint =3D file_write_hint(rw->kiocb.ki_filp);
=20
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
--=20
2.43.5


