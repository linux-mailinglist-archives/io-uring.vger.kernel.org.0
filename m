Return-Path: <io-uring+bounces-6239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C85A262EB
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 785C43A38E0
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178E920B807;
	Mon,  3 Feb 2025 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Screztrm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700B21D63C5
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608418; cv=none; b=bmWe40zDF+muo7XOiS4JAOe2QakXYGBtkbLy0kDBsB4ORlbFjY1UuS1tg3EpY/ntZVzRPm7CEgVRVtGKsuhzptbTlpyqnq9qBP6yGnJGeRdtuVN0DGvRp9tV2n3pwKLNhBW5wMPJMQLXyOcNtr6ZymQnEpm0r6rQBP6Xw13gkeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608418; c=relaxed/simple;
	bh=/+wKU5EJqDJqXOd/rmfTWOgOxq2l6MFNquGYw1bk2Ao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGE/DFokYh4EelW3tszIDasks+n+66AB1QgYGZILm7CSCFREwg90MxXRSZ08c631ggdbfKiTWG2k9X+j7OD3RO+qdCTbbqLA/Uug15ShYY3O/fQJwFzWoRabe+kU5piZFE0hvn3GkHLtQaU89qQRQeZTgwI6rqmp5sqEV66uEE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Screztrm; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513IHnAc023598
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:46:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=fNIXKTXv0cNcZjIIi47wETlFoGESbcaSE+f+/sI3Kv4=; b=ScreztrmcYk+
	ik4FLgNhL9x1uriOEuoWH9gd8JsYQ5JEWkbQ/jbUTHo7eM0yw5BF5J4H09Kejr+J
	RAFpmDo9V4rHfzY6IdF65fqDiXtDsdIWqJhh2seZ847c9WmviqUKAP27jQ+n6YkR
	zMqn2icdmR8TaahvyVnVqkIYCOFsA9RKfbPC151Yhx4BIG+G6nJ65KKvOvLJ9rbm
	CqkJ1XpaHe2rQtXcb85b8x6BCD1Cl5WZf31aCH9S7tzFwDgQpWdRJs5OHBwhv40g
	CgSLfhmswjse5qOsWv1qHzPCa4s/j2qvoKa3KaspOCtyZ3ckp8NFyOJPkqTOzY5b
	3CbsOjcYKQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k2muge55-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:46:55 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:46:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id AD981179C262B; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Hannes Reinecke
	<hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv2 05/11] block: expose write streams for block device nodes
Date: Mon, 3 Feb 2025 10:41:23 -0800
Message-ID: <20250203184129.1829324-6-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
References: <20250203184129.1829324-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BIytgupAaLi-GoxDunS47HP1rRcXJGLs
X-Proofpoint-GUID: BIytgupAaLi-GoxDunS47HP1rRcXJGLs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Christoph Hellwig <hch@lst.de>

Use the per-kiocb write stream if provided, or map temperature hints to
write streams (which is a bit questionable, but this shows how it is
done).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[kbusch: removed statx reporting]
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index be9f1dbea9ce0..11902b7120af2 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -73,6 +73,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *=
iocb,
 	}
 	bio.bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
 	bio.bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_stream =3D iocb->ki_write_stream;
 	bio.bi_ioprio =3D iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |=3D REQ_ATOMIC;
@@ -206,6 +207,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb,=
 struct iov_iter *iter,
 	for (;;) {
 		bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
 		bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_stream =3D iocb->ki_write_stream;
 		bio->bi_private =3D dio;
 		bio->bi_end_io =3D blkdev_bio_end_io;
 		bio->bi_ioprio =3D iocb->ki_ioprio;
@@ -333,6 +335,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb =
*iocb,
 	dio->iocb =3D iocb;
 	bio->bi_iter.bi_sector =3D pos >> SECTOR_SHIFT;
 	bio->bi_write_hint =3D file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_stream =3D iocb->ki_write_stream;
 	bio->bi_end_io =3D blkdev_bio_end_io_async;
 	bio->bi_ioprio =3D iocb->ki_ioprio;
=20
@@ -398,6 +401,26 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, =
struct iov_iter *iter)
 	if (blkdev_dio_invalid(bdev, iocb, iter))
 		return -EINVAL;
=20
+	if (iov_iter_rw(iter) =3D=3D WRITE) {
+		u16 max_write_streams =3D bdev_max_write_streams(bdev);
+
+		if (iocb->ki_write_stream) {
+			if (iocb->ki_write_stream > max_write_streams)
+				return -EINVAL;
+		} else if (max_write_streams) {
+			enum rw_hint write_hint =3D
+				file_inode(iocb->ki_filp)->i_write_hint;
+
+			/*
+			 * Just use the write hint as write stream for block
+			 * device writes.  This assumes no file system is
+			 * mounted that would use the streams differently.
+			 */
+			if (write_hint <=3D max_write_streams)
+				iocb->ki_write_stream =3D write_hint;
+		}
+	}
+
 	nr_pages =3D bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <=3D BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
--=20
2.43.5


