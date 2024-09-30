Return-Path: <io-uring+bounces-3332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 420E898ABFC
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1E15282D83
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00594199958;
	Mon, 30 Sep 2024 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ew3s4Btb"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF10199957
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720466; cv=none; b=E7LzGZToiH+/Y4gPdm7mXBgeJ1fhw6maXjk21/Gdsm2JZcIt2zXqJkyJGboUEqeYxRV8QceiMP0BfEdvsTyVWm82407ZhV69muW7ZdEK657+2ZC7zI0poQNXjmZ1y2Qm/86fnVm5K1Ab+417pScoIYvTc7KlVha9gff4n8TS7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720466; c=relaxed/simple;
	bh=VSwCLEvRnPbXOvMic/tH/TbJClaceq6m4BaPRoKdrjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=H0pU57LD3Bt+oVy9fM37RPNLmuuXkwhCok1xK4iqBTniFjoJZakYVjZNlUoUCWbZwdM0iHHtNhjfZn4f3X8DT8Mu8zbX9OUmeMt6cmtc+RQvtEQzp1jsIT9urb7oCZrP07QRvNgQPqLa/mA4jfGDsGC4mIr9XyIhnfVCVK/9BS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ew3s4Btb; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240930182102epoutp02704dbc3354ecd3f076677c3755d9b4bc~6GJtu6ndg0776207762epoutp02t
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:21:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240930182102epoutp02704dbc3354ecd3f076677c3755d9b4bc~6GJtu6ndg0776207762epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727720462;
	bh=hyooDSKS7SUXPMRtV3IrWwIut5VpyE7/Ysl0cxIi+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ew3s4BtbXf8v0ezKEctp91YN2XePSsT123lKrEr78iFn9hTGJNle4FwSHkh6V2J6z
	 h6jRodhABerI3mbQ72JzG3bp40/6nR5Q9/HXI1zijQ7pEmyKIcYUYSAd5Xyg3pJs9t
	 YJznOp5WLFn0tK7Z3aOvG12sjjvPtbPGLD4fu+ac=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240930182102epcas5p4995ee0bade62c149e74e02e48a74482a~6GJtHQqZa0453304533epcas5p4O;
	Mon, 30 Sep 2024 18:21:02 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XHTsS3ckHz4x9Pq; Mon, 30 Sep
	2024 18:21:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BF.88.08574.C0CEAF66; Tue,  1 Oct 2024 03:21:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240930182100epcas5p31a010c225f3c76aa4dc54fced32abd2a~6GJrC6v632158621586epcas5p3E;
	Mon, 30 Sep 2024 18:21:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240930182100epsmtrp2930bb9ae674a89b937077c890d8a79de~6GJrCAAv52734427344epsmtrp2c;
	Mon, 30 Sep 2024 18:21:00 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-e3-66faec0cf793
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	61.19.08229.B0CEAF66; Tue,  1 Oct 2024 03:20:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240930182056epsmtip225762a12393553a4f7235980b0e9161b~6GJn1QD4f2505325053epsmtip2M;
	Mon, 30 Sep 2024 18:20:56 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
	dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH v7 2/3] block, fs: restore kiocb based write hint processing
Date: Mon, 30 Sep 2024 23:43:04 +0530
Message-Id: <20240930181305.17286-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1AbVRT27m6yAUtZoAwXHAuuUQSHkFjAixZ1ptSuA7U46Iz4o7gmC2ES
	QiYJD8UBSmmHZoDSgFCgCArCJChYSpFXmPIq7fgAwT6gwNAWflAotESsiFATFrX/vnPOd853
	v3PniHD3PNJHlKQxcDoNq6aFzkT7QMBLQbuW/kqQTvVAdM7SDlDT9GkhMm61EWhxYBWgsgfr
	OFrO3SDQxKVODPV8bcKQuWkIQ8snfiFQVflxDM21VOLo7pSNREOP7wuRqf86QKVluQBZJ19G
	PdarBKppmCdR4/AWhto3anDUvLhCoJHNYQEaqTxHvgWZ8d+imM7KaZIZmTlPMOM/pzKtllNC
	pnXVRDIX6rOZ7okcIfNwfpJgVnqvCZmiNgtgfqodtBd/zGRsrXuZ1rn7WIzrR6r9So5VcDo/
	TiNPUSRpEiPoqNj4A/GhYVJZkCwcvUr7adhkLoKOjI4JejtJbV8E7ZfGqlPtqRhWr6eD39iv
	S0k1cH7KFL0hgua0CrU2RCvRs8n6VE2iRMMZXpNJpa+E2okfq5RlpgpSe0OScbK8XJgDRl80
	ApEIUiHwwQ96I3AWuVPdAE6UrmN8sArgmjmX5IM/ALx3rQc3AqftjrsrdwBfsAJY1ndmJ7AB
	uP59L+GYK6QC4GhJqiO/hyrF4ESThXB041Q9Bm/MujqwBxUNRx+2CByYoF6At/LrSQd2oRCc
	KqgmeTVfWDH2aBs7UeGwZDwf5zlu8GrF3M5MX3j8YhXuEINUoxPsnijYeWokNI5/C3jsAe8N
	t+0M9YG2ZauQxyo4e2eW4PHnsONCkYDHb8Kcv28KHGZwu5mWrmBeazcs3JjD+N25wPyT7jz7
	OThjmt/p9IK3z9YLeAoDm45l8espANB8eRIvBr6VTziofMJB5f9itQC3AG9Oq09O5OShWpmG
	S//vX+Upya1g+xwCIzvAzZotST/ARKAfQBFO73GZ6V9PcHdRsJ9+xulS4nWpak7fD0LtKz6D
	+3jKU+z3pDHEy0LCpSFhYWEh4fvCZLSXy+KJaoU7lcgaOBXHaTndv32YyMknB1NcKvH6rjha
	8CGnEnc65+0Tu/qPpIcb8MddAx+0ez8vNsfNZHjCwW9YrTmuV6I6tiXxlOunI4KefS/K+crk
	wS/nD/1+pAEyi17ery/uWrhsanmXGyqK9vhq4UBPeuEn1xefEV+EHDWW/r5SfcUQf0uwElDY
	IY/ae3gwOM0ca14alpyua2ASqpTWP+liJ+NyWNapp6yb3c2/5kX2TUVuJov9AhuzJx+x/s05
	Av8yNZHWlb90aKHd3+N2/oHshky6aSz0qPIwOZRxdvDp8iXa2+YjLrYIXedK8qozRJmxtjVy
	1ig9snbU953d54GSq8sKTo7ZMsy4uvXX9sV94TZTRxN6JSsLxHV69h/5BX4vlwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWy7bCSvC73m19pBl82GlnMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLG4e2MlksWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Ht/5zG5x9P9bNotJh64xWkyZ1sRosfeWtsWevSdZLOYve8pusfz4PyaLbb/nM1use/2exeL8
	3+OsFudnzWF3kPC4fMXbY+esu+we5+9tZPG4fLbUY9OqTjaPTZ8msXtsXlLvsftmA5vHx6e3
	WDze77vK5tG3ZRWjx5kFR4CSp6s9Pm+S89j05C1TAH8Ul01Kak5mWWqRvl0CV8a0STPZC67r
	VbRNn87WwHhBrYuRk0NCwETi8ftHjF2MXBxCArsZJSa1PWKCSIhLNF/7wQ5hC0us/PcczBYS
	+Mgo8Xu7XBcjBwebgKbEhcmlIL0iAiuYJLY9+csC4jALbGCSaFmyB6xBWMBH4sLH9awgNouA
	qsTtjiVgcV4BC4k7PXOhFshLzLz0HczmFLCUmHy5gxliGVDNj3ZmiHpBiZMzn7CA2MxA9c1b
	ZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4NjW0tzBuH3V
	B71DjEwcjIcYJTiYlUR47x36mSbEm5JYWZValB9fVJqTWnyIUZqDRUmcV/xFb4qQQHpiSWp2
	ampBahFMlomDU6qBKW+jUabEh4xw7p9fnPfs1d30w2e7RyHX8+oosWDti/Gr126e/X/Dmjce
	hj9vCDvX3Xmn57fLSfncGmvvo+wXkw5V/IxbmvWU7/neT7vjd91Nd/BkWXzye35Vx5y60Om7
	a7VPWK/k1eiul17j2KexZkt5s6lsvbBgvOrlku/tPIWBCUwbljz0vrx5e3zbLtUN/w80zA1m
	3NGmY+F9KjY5b9bekgk/jF+Eu27b+yP/LNf3iIp/gu1J9XnXjW0USqp3b58sW5S1dfP30tNW
	X0OELBQvns6uqf3Tajl9mZWi5raDnazen5f3mJypyLnAc61OWkEv5IFIBNNUFu/b09UWHg7M
	zJc5UnLGR7ggJnutEktxRqKhFnNRcSIAH9aBE1wDAAA=
X-CMS-MailID: 20240930182100epcas5p31a010c225f3c76aa4dc54fced32abd2a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240930182100epcas5p31a010c225f3c76aa4dc54fced32abd2a
References: <20240930181305.17286-1-joshi.k@samsung.com>
	<CGME20240930182100epcas5p31a010c225f3c76aa4dc54fced32abd2a@epcas5p3.samsung.com>

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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
index e696ae53bf1e..85b9b97d372c 100644
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
index f637aa0706a3..fff43f121ee6 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -397,7 +397,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 					  GFP_KERNEL);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
-		bio->bi_write_hint = inode->i_write_hint;
+		bio->bi_write_hint = dio->iocb->ki_write_hint;
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e3c603d01337..3dfe6de7b611 100644
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
@@ -2337,12 +2338,18 @@ static inline bool HAS_UNMAPPED_ID(struct mnt_idmap *idmap,
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
 
@@ -2353,6 +2360,7 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
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


