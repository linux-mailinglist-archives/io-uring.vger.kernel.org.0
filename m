Return-Path: <io-uring+bounces-4039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD949B11B2
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 23:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B1C3B218ED
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 21:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5102820C31E;
	Fri, 25 Oct 2024 21:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Awdmkbhk"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246E91C07FD
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729892242; cv=none; b=he4rffFsrmnC2FMlUN/EpcmS1q/uRfkuWmCHEoeliazzPf3mDqfJnqLhYjLinMfTSSyWXZvkxTJ7czq7N94w1SO7IO6mfLHRlhjU7RI49CnKBhwbo/z14vO/Wq2cpf9En+uAIhQizGElic3m0voPouPVd9hKSNqkvYcFfPCfFlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729892242; c=relaxed/simple;
	bh=nIbhCT8FS+QVdTnVTSEph5yt3h8bhMz1gJgLk/NyFU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cRt+gtJJwmPFWQBkseKP1irZDVEecOpPozBS3vCLwPvBT3w96U4sg4hDwwQshrgJrRLMq4lGySVt0ExXdkBqWB/1od/lyOxTjQCbBUS56SI4TklsbOAGx4n2OS6Rmtqqh9QNB315lQ7ju/vQChWqhjLCCEf/W4hn9VTs1yyzLhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Awdmkbhk; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PKXKeD027484
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:37:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=41I37dn6RfBbsfu3h2xMpU2bbYlrLzaeudide/nA534=; b=Awdmkbhk6Pa2
	1ZkCunt2pVUQZcC6FyLpA3ZhbSYyJgLfeZ52gM8hhYOxd+EloqgS5+z4B/vxZUaj
	EaNtGpUevNQGxWLeDZTcKJfMWlWLES/zd1adakS6mltUaLmmhtgx3vdhaftQ7+RI
	QVaKNefPWrHEu1f2Dq3s8/MhgjEbm6sxKKS2jmVaBpPDEpOeTGQXLb/BkAHT+bu7
	FLxWpdTuvx1iKGGWrHXh/Hq+2glxvcLkqO1dMbn3ZctGZ2/G2n3EqvfYCtJpkzSX
	uHyTFoJdHjqF17EJrU57HX4qH/P7nCuuLx3tIy3bSMXPaa0kDZUi+bR+8AMxFBpn
	EleN/NYIKA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ggrd16dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:37:18 -0700 (PDT)
Received: from twshared23455.15.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 25 Oct 2024 21:37:18 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8B2DA1476D73D; Fri, 25 Oct 2024 14:37:06 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <hch@lst.de>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, <bvanassche@acm.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv9 4/7] block, fs: add write hint to kiocb
Date: Fri, 25 Oct 2024 14:36:42 -0700
Message-ID: <20241025213645.3464331-5-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241025213645.3464331-1-kbusch@meta.com>
References: <20241025213645.3464331-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0RHCC4ntu986H9dXai6Jyb2YNb-zTDrv
X-Proofpoint-ORIG-GUID: 0RHCC4ntu986H9dXai6Jyb2YNb-zTDrv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

This prepares for sources other than the inode to provide a write hint.
The block layer will use it for direct IO if the requested hint is
within the block device's capabilities.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c       | 26 +++++++++++++++++++++++---
 include/linux/fs.h |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 2d01c90076813..e3f3f1957d86d 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -71,7 +71,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *=
iocb,
 		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
 	}
 	bio.bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-	bio.bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_hint =3D iocb->ki_write_hint;
 	bio.bi_ioprio =3D iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |=3D REQ_ATOMIC;
@@ -200,7 +200,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb,=
 struct iov_iter *iter,
=20
 	for (;;) {
 		bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-		bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_hint =3D iocb->ki_write_hint;
 		bio->bi_private =3D dio;
 		bio->bi_end_io =3D blkdev_bio_end_io;
 		bio->bi_ioprio =3D iocb->ki_ioprio;
@@ -316,7 +316,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb =
*iocb,
 	dio->flags =3D 0;
 	dio->iocb =3D iocb;
 	bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
-	bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_hint =3D iocb->ki_write_hint;
 	bio->bi_end_io =3D blkdev_bio_end_io_async;
 	bio->bi_ioprio =3D iocb->ki_ioprio;
=20
@@ -362,6 +362,23 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb=
 *iocb,
 	return -EIOCBQUEUED;
 }
=20
+static u16 blkdev_write_hint(struct kiocb *iocb, struct block_device *bd=
ev)
+{
+	u16 hint =3D iocb->ki_write_hint;
+
+	if (!hint)
+		return file_inode(iocb->ki_filp)->i_write_hint;
+
+	if (hint > bdev_max_write_hints(bdev))
+		return file_inode(iocb->ki_filp)->i_write_hint;
+
+	if (bdev_is_partition(bdev) &&
+	    !test_bit(hint - 1, bdev->write_hint_mask))
+		return file_inode(iocb->ki_filp)->i_write_hint;
+
+	return hint;
+}
+
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *ite=
r)
 {
 	struct block_device *bdev =3D I_BDEV(iocb->ki_filp->f_mapping->host);
@@ -373,6 +390,9 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, s=
truct iov_iter *iter)
 	if (blkdev_dio_invalid(bdev, iocb, iter))
 		return -EINVAL;
=20
+	if (iov_iter_rw(iter) =3D=3D WRITE)
+		iocb->ki_write_hint =3D blkdev_write_hint(iocb, bdev);
+
 	nr_pages =3D bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <=3D BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b5cad44a1268..1a00accf412e5 100644
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
--=20
2.43.5


