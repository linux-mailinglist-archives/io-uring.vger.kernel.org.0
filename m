Return-Path: <io-uring+bounces-3281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B8698423B
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 985331C2344B
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4DE15667D;
	Tue, 24 Sep 2024 09:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="s3eF3q5A"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF7B1714A1
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170381; cv=none; b=s1KxEOcjoFpfI08jqisuCq9xx4zzlLWpkDDOhRXQUzBzeNKaVs46GsQU6b71fFfTpmhj2F5E3cmYTuGJtPX6ZO/f9UElKNDBUGkYMmQWMd7voNZimtLl0QjOCFmf3dm/dHrNnseoeKGS3KwjUvzkQ+bBsqHZyDqLZOUSAxW4miU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170381; c=relaxed/simple;
	bh=OKLlLAoU4DsWbQlpvZxP4sN26gFnRxl+OHIXao4VPng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NZQzYKlpbDsNwRZELhYVdqkLtqPOzJczbbo5myc0Dt2K29ykLqcg/17spkzH1itBGTKMRG1cYWImzyJOMKTxQYhB5dpQIEztMR1EnItyQl9Ez1PRO2sMZUI0M4YtoWmaH4MwFCGmnF1mHAtT9A7YOaR0aX3peBO22iiVuSgtR2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=s3eF3q5A; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240924093257epoutp0422fbf98c17d560ee2931f601a091ff12~4JE6xHjvr2427024270epoutp046
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:32:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240924093257epoutp0422fbf98c17d560ee2931f601a091ff12~4JE6xHjvr2427024270epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727170377;
	bh=1GIS0gBDNBztIaJncjKU62C983VRWWu/9ICJO3AXzgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3eF3q5AV6MkNJxRYzeZSFjnOFTNNj88+yj/hFCD5v4ImHkNR1pG/VLZ5y5zYJKc7
	 2VlN4NxhN5CzRZQPQgwCADq0ejGAsoWykOf174oT3ufNoeFlzthXtFwyrtdyPn93x4
	 BmfXgA+l8LMp1dAxcwfJfCTdmLzou4ccN+YmY90k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240924093256epcas5p2c4744ddd70b34e675ca161af9c739780~4JE5wu-R91603616036epcas5p2d;
	Tue, 24 Sep 2024 09:32:56 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XCZQt5dqxz4x9Q4; Tue, 24 Sep
	2024 09:32:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.57.19863.64782F66; Tue, 24 Sep 2024 18:32:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240924093254epcas5p491d7f7cb62dbbf05fe29e0e75d44bff5~4JE3uHc8o1069010690epcas5p4D;
	Tue, 24 Sep 2024 09:32:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240924093254epsmtrp134d79fd2b500b18f508d861084346597~4JE3s7mrT0907709077epsmtrp1S;
	Tue, 24 Sep 2024 09:32:54 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-80-66f28746c234
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.C1.08964.64782F66; Tue, 24 Sep 2024 18:32:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240924093250epsmtip29673730402874f651515b59591442cc0~4JE0kHlso0088900889epsmtip2G;
	Tue, 24 Sep 2024 09:32:50 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH v6 2/3] block, fs: restore kiocb based write hint processing
Date: Tue, 24 Sep 2024 14:54:56 +0530
Message-Id: <20240924092457.7846-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924092457.7846-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTZRy/531ftmFCY0B73BmMt7MLDNh0jAcDfwRyr+kZ5R9ceAU79jKI
	/br9KOvqJBDKpSiECAOD04U4OkgciAgcDZQDlPkDIwiIZFwXJAgE3US0zZfK/z7f731+3Of7
	3MPBeY9YAk6W2kDr1DIlyVpHNHeFhoYnfrmQIaoZDEOV1maA6sZOsJDpiY1AM10LAJU+dOFo
	NneFQMOdVzB0oe4ahmbzBwhUcToPQ84GM44mRxfZ6NrTByxUbP8JoJLSXIDaRzajtvZeAlXV
	TLHR+Z4nGGpeqcJR/cwcgRyrPV7IYa5k7+RTdwf3UlfMY2zKMX6RoO7eNFKN1qMsqnGhmE1d
	shymrg7nsKj5qRGCmuu4x6IKbVZA3ajuZlOLjUFUo/MBluSbkh2bScvktE5Iq9M18iy1Io7c
	eyA1PjVKKhKHi2NQNClUy1R0HJmwLyk8MUvp7k8KP5Ipje5VkkyvJyO3x+o0RgMtzNToDXEk
	rZUrtRJthF6m0hvVigg1bdgmFom2RLmJadmZw+f7gNYacWjc0sfKAbWvmgCHA7kS2O3yMoF1
	HB63DcDfz/SymGEBQNfAEjABb/ewDGB/wbse7BHMTfQTDKkdwKbyHwEzLAL4/cAs4bFlcUPh
	rW+Mnn0AtwCDRyZKcY8a51owODTxogf7c/dBZ95ZzMMnuJtg9fX9nrUPNxp2/dVAMGHBsPzO
	32wP9uYiaB28RzAcP9hb7iQYy2CY11SBe7Igt8Ibjox868VUS4D1+RmMjz+c7rGxGSyAf5wo
	WMPZcOL+xFrWZ7DlUqEXg3fAnMc/P7PB3VUaWiOZKF94fMWJMe4+8KsCHsMOgePFU2tKPvyt
	zLKGKXju2HGcuc7XANorLOyTINj8XAPzcw3M/6dVA9wKBLRWr1LQ6VFacbia/vi/Z03XqBrB
	s08QltQC6n5YjbADjAPsAHJwMsCneHg+g+cjl33yKa3TpOqMSlpvB1HuExfhgsB0jfsXqQ2p
	YkmMSCKVSiUxW6Viku8zk39GzuMqZAY6m6a1tO5fHcbxFuRg2ODOVr+G3B2FJ3/9YjRP2Gvb
	tFCm0vU1xcXP800xkW8eGmo6++eFkhvTBydH6eSp1xcrS1f7sTeyTBHKZJftSGtAUMu05GFZ
	T96ujbhlaP0H3rb1JS1b42tPvVJxcNIvl3LUSfe8JLj8+Zbp+9df2/6oc/ktP1X2kmv4skjo
	1RFs313TrK+KDIxV/PKCrudYWqqcV7Qt/sMiKpB4ejhZJwk6V5Thj0bHbte11jfEivfPGnYl
	ROrIDb57QlI2PK6tvDXeEZ3/tvO95fmSi7EBt1tfloZkLm12kU5rcpr9gPEUn6+YUzrLtn/n
	CEqKc+xefP+dxJQ7TTdZlqPszu7RttNXN5KEPlMmDsN1etk/GF6Kno0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGe9/zds7ZYnaa0d5VFCyLzNKkwpdal/mhDhayPhRRUE49Xsip
	bS4rksxV1qQLs7KmpOjINitrXsqcUTOT2cXItBalkbMLUTqVsotWcwR9e/7P83v+Xx6Wkjah
	6WxqepagS9ekKWgxqm9WzF60Nn8wabGvgCYl9npAql6fpIlprBaRT82DgJwd+E6RL3k/EfHc
	aYDEVtUCyZfDjxEpLjJC4q22UKT31RBDWn5/ponZ1QXI6bN5gDS9DCPOJjcipRf7GFLZOgZJ
	/c9Silz91I9I+2jrRNJuKWHWyPiOZ+v5Bstrhm/vvo74jkcG3mE/RvOOQTPD11gP8I2eXJr3
	9b1EfP/tTpo/UWsH/MOyeww/5JjFO7yfoTpoq1iZKKSl7hZ0EavixCmeyjaQaQ/f021to3PB
	pXkmIGIxtxT3v3mA/FrKNQJcOyAP+DJs7BphAjoY28beMwHGB/C5d5QJsCzNheInhQYTELNT
	uXMQt126S/sPirsG8SGrc7wQzG3AXmM59BcQNxeX3Y/12xIuCjcPV6PA/9n4/NNv47iII9j+
	rBP5celfZrRQHcCnYPd57zhO/cWNdcXUKcBZ/oss/0VlANqBXMjUa5O1+sjMyHQhO1yv0eoN
	6cnhCRlaBxhfeEHoTXDDPhDuApAFLoBZSjFVYvb4kqSSRM3efYIuY4fOkCboXWAGixQyiezD
	8UQpl6zJEnYKQqag+5dCVjQ9F2Y1Fl07GrEpSlWyemF5S2hOvy2oDm0M+6iNWXHRkSNRyTS/
	1c27o8ly26SHqRfmO2FO7Y2a4eCVPeJdbnFXyWOl2MNGK6tH920rjH8etMS1pO7RnI6MxqW/
	5JNv7kjJNlZtr3wwdLRnplNt6D6g2mZN6JlrXvS1vDh3fpjaunnPBGVW6Te381br6iOdI4Qx
	51+BsVsK9nMud3ZaWavp4+XNEax3iki1f6cuzwcnJ9xdKG9PipOsg+ykAmvRtKjvRmlvVJ6t
	I36ENMx72nV5mDkT37IcvojeHnv1OqqJ1cyyV6gqzMqDbz94Q/DEZe4Ynzw/O0QUMy1EFtf3
	o5cokD5FE7mA0uk1fwCj0RycUAMAAA==
X-CMS-MailID: 20240924093254epcas5p491d7f7cb62dbbf05fe29e0e75d44bff5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093254epcas5p491d7f7cb62dbbf05fe29e0e75d44bff5
References: <20240924092457.7846-1-joshi.k@samsung.com>
	<CGME20240924093254epcas5p491d7f7cb62dbbf05fe29e0e75d44bff5@epcas5p4.samsung.com>

struct kiocb has a 2 bytes hole that developed post commit 41d36a9f3e53
("fs: remove kiocb.ki_hint").
But write hint has made a comeback with commit 449813515d3e ("block, fs:
Restore the per-bio/request data lifetime fields").

This patch uses the leftover space in kiocb to carve 1 byte field
ki_write_hint.
Restore the code that operates on kiocb to use ki_write_hint instead of
inode hint value.

This does not bring any behavior change, but needed to enable per-io
hints (by another patch).

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
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
index e69deb6d8635..3b8c0858a4fe 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -74,7 +74,7 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
-	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio.bi_write_hint = iocb->ki_write_hint;
 	bio.bi_ioprio = iocb->ki_ioprio;
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		bio.bi_opf |= REQ_ATOMIC;
@@ -203,7 +203,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	for (;;) {
 		bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
-		bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+		bio->bi_write_hint = iocb->ki_write_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
@@ -319,7 +319,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	dio->flags = 0;
 	dio->iocb = iocb;
 	bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
-	bio->bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
+	bio->bi_write_hint = iocb->ki_write_hint;
 	bio->bi_end_io = blkdev_bio_end_io_async;
 	bio->bi_ioprio = iocb->ki_ioprio;
 
diff --git a/fs/aio.c b/fs/aio.c
index e8920178b50f..db618817e670 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1517,6 +1517,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
 	req->ki_flags = req->ki_filp->f_iocb_flags | IOCB_AIO_RW;
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
+	req->ki_write_hint = file_write_hint(req->ki_filp);
 	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
 		/*
 		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set, then
diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 6a821a959b59..c3db102ae64e 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -309,6 +309,7 @@ int __cachefiles_write(struct cachefiles_object *object,
 	ki->iocb.ki_pos		= start_pos;
 	ki->iocb.ki_flags	= IOCB_DIRECT | IOCB_WRITE;
 	ki->iocb.ki_ioprio	= get_current_ioprio();
+	ki->iocb.ki_write_hint  = file_write_hint(file);
 	ki->object		= object;
 	ki->start		= start_pos;
 	ki->len			= len;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index bbd05f1a2145..73629e26becb 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -409,7 +409,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 		bio->bi_end_io = dio_bio_end_io;
 	if (dio->is_pinned)
 		bio_set_flag(bio, BIO_PAGE_PINNED);
-	bio->bi_write_hint = file_inode(dio->iocb->ki_filp)->i_write_hint;
+	bio->bi_write_hint = dio->iocb->ki_write_hint;
 
 	sdio->bio = bio;
 	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f3b43d223a46..583189796f0c 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -380,7 +380,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 					  GFP_KERNEL);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
-		bio->bi_write_hint = inode->i_write_hint;
+		bio->bi_write_hint = dio->iocb->ki_write_hint;
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0df3e5f0dd2b..00c7b05a2496 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -370,6 +370,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
+	enum rw_hint		ki_write_hint;
 	union {
 		/*
 		 * Only used for async buffered reads, where it denotes the
@@ -2336,12 +2337,18 @@ static inline bool HAS_UNMAPPED_ID(struct mnt_idmap *idmap,
 	       !vfsgid_valid(i_gid_into_vfsgid(idmap, inode));
 }
 
+static inline enum rw_hint file_write_hint(struct file *filp)
+{
+	return file_inode(filp)->i_write_hint;
+}
+
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
 		.ki_filp = filp,
 		.ki_flags = filp->f_iocb_flags,
 		.ki_ioprio = get_current_ioprio(),
+		.ki_write_hint = file_write_hint(filp),
 	};
 }
 
@@ -2352,6 +2359,7 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
 		.ki_filp = filp,
 		.ki_flags = kiocb_src->ki_flags,
 		.ki_ioprio = kiocb_src->ki_ioprio,
+		.ki_write_hint = kiocb_src->ki_write_hint,
 		.ki_pos = kiocb_src->ki_pos,
 	};
 }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index f023ff49c688..510123d3d837 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1023,6 +1023,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
+	rw->kiocb.ki_write_hint = file_write_hint(rw->kiocb.ki_filp);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-- 
2.25.1


