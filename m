Return-Path: <io-uring+bounces-5116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C73C9DB6C2
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0B10281A53
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE5019C54F;
	Thu, 28 Nov 2024 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q2unj1Sh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA7719D072
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794364; cv=none; b=QfMpbkHvicU0PAG/0koUvghBZGEjrxGaw2mJPky/AQ+2YBVbFSSY2Q1EBEvbiPjfCM47iHXxeH0+AjbFKRd1q9aYJnNjrwJpUdj2/gi8CR1Reggjt3bCtB0/caJFU1QPucQLcoP9SrXS8AkqJTL3y62DAfXwzwzwJT30SsrJ2/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794364; c=relaxed/simple;
	bh=ZIkdyJlOm3c2bE0cQ6pelSYB5Gra8HNzZg1GmGSloUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=SoIpGb8Qkl8Y7J9cN1LKTCCsAYIG4RWK38uUmdHNOhL+mk2iksC8iENugTeBah01tHmEiML+W5Svkj27wcqdDVYeC+0uO1Sbr4R/3hvlOl8iWarrPe2FIuatFOejonfA7uHjEiZJh2CqChuMAE5cWPi4COaij8gdSFPaOWOkt+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Q2unj1Sh; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241128114600epoutp035ad5c88d74ba8d17c58baf37c32102e6~MH0o9liPM3197231972epoutp03G
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241128114600epoutp035ad5c88d74ba8d17c58baf37c32102e6~MH0o9liPM3197231972epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794360;
	bh=r23oSTZl50mKsH838ytL5lDlNxkmkMYy4oR7U1Ruz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2unj1ShZtgvlk2yRO3idObv1vytSo5DVSiniR/4MNoGEBz4drzVLN8SJAzjiUerv
	 rSF1W7R9Lh+xKqCYVFcxBmFME/oZga+nJIfzlHtfy4wqgBBEvpQgbZN+y33FNYIrwm
	 x4IKDB0m0AqN/CxB/wFUPEihRz2atHUKDOPyWQzI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241128114559epcas5p4de7b1ade7af45ae9ef8be4d17549089f~MH0oL_Y7l1496914969epcas5p4W;
	Thu, 28 Nov 2024 11:45:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XzZJP6Fj4z4x9Pp; Thu, 28 Nov
	2024 11:45:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D1.6F.20052.5F758476; Thu, 28 Nov 2024 20:45:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241128113101epcas5p3fefab67892c16c7bbaba8063c5c4a2c1~MHnjpWL2V2753027530epcas5p3_;
	Thu, 28 Nov 2024 11:31:01 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241128113101epsmtrp22eed36114a530ac46f9ef1b852596c9f~MHnjoKm1w0053700537epsmtrp2k;
	Thu, 28 Nov 2024 11:31:01 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-79-674857f59385
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FD.4E.18949.57458476; Thu, 28 Nov 2024 20:31:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113058epsmtip24543a12bd1e65a89a01572043324f0af~MHnhO3wlj2509525095epsmtip2V;
	Thu, 28 Nov 2024 11:30:58 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v11 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Thu, 28 Nov 2024 16:52:33 +0530
Message-Id: <20241128112240.8867-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmlu7XcI90gycbDS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzx98ZmpYI9cxe7LHg2M2yS7GDk5JARM
	JG5N2MLUxcjFISSwm1Fi3oxNbBDOJ0aJmS9vMEM43xglzr78xwbTMvfoUqjEXkaJ5iO3oPo/
	M0ocXPofrIpNQF3iyPNWRpCEiMAeRonehadZQBxmgQlMEu0T57CDVAkLJEjM6lnMDGKzCKhK
	nDn/iwXE5hWwkNhx4wQrxD55iZmXvoPVcwpYSsy+9o0VokZQ4uTMJ2D1zEA1zVtng90kIXCD
	Q2Lryw52iGYXiQkz1rNA2MISr45vgYpLSXx+txfqoXSJH5efMkHYBRLNx/YxQtj2Eq2n+oGG
	cgAt0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyYB2MrSbSvnANlS0jsPdfABDJGQsBD4nS/
	FSS0eoChdfw88wRGhVlI3pmF5J1ZCJsXMDKvYpRMLSjOTU8tNi0wzEsth0dzcn7uJkZwQtfy
	3MF498EHvUOMTByMhxglOJiVRHgLuN3ThXhTEiurUovy44tKc1KLDzGaAsN7IrOUaHI+MKfk
	lcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAtHMaE4+yxIQfjheF
	LFUOJ286/JUz8uEtPx9dqUvXq/oDbC7XnL2t8qa0PH2R3KXMlblq8vmKbq3cz/ryC653drQy
	WirWeFe++Ns97fGut+ftuO9/MM/OaQjU2GNqo+HPUtXz3jfPL/7vxDviJXr+6qtlNl6KZvJb
	FzR3d03UtuJUuQbhs9MTp39/98KXoe7FgX8da+ryb9y+mdw6L55l/Z4FZoIKT2atO9B5mW9h
	5zSuuaerjHmcnfrcKzYf4HjknPXLcwLn8cWLzj5W5/AIO8p4ZefWa2u+3SnVeBm3+8qixFUl
	RiEruXnmrHg505TVtuia41plPvfJmj9n5pffd/SPKbfYdPb7hccNs86tVWIpzkg01GIuKk4E
	AHpzDANxBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG5piEe6QesxbouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6Mpy8+MxXskavY
	fdmjgXGbZBcjJ4eEgInE3KNLmUFsIYHdjBIr/ipCxCUkTr1cxghhC0us/PecvYuRC6jmI6NE
	T8NcdpAEm4C6xJHnrWBFIgInGCXmT3QDKWIWmMEk0fNrBRtIQlggTuLOpIlgDSwCqhJnzv9i
	AbF5BSwkdtw4wQqxQV5i5qXvYDWcApYSs699Y4W4yELi8uPrrBD1ghInZz4B62UGqm/eOpt5
	AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMebltYOxj2rPugd
	YmTiYDzEKMHBrCTCW8Dtni7Em5JYWZValB9fVJqTWnyIUZqDRUmc99vr3hQhgfTEktTs1NSC
	1CKYLBMHp1QD04oefuHpb1vcQs8Fb7pUvUw0/h7jVp66HoGlOrsCV1Q/1tdkK36u2slQe9l5
	c7K6/dMpNn4fLRcmd4cETTvTxxOxcHlb5L7l2acXuh/4eJBp97b3n2ycA+ucCpIVtFeIrOwP
	bSu79j1B9hvfQZbiq7nemQYmfuvsTbS/cKba7TaXv2d6cOd2BanZG9ifLfTvlfFRr2Zd23HB
	j+tQ1XmLRQYLFX+ve6juZnVy7+uN5X/tlhTHnsyIP75r+ok1hppb7keeZV5ik5fa/cDu3ucL
	UUnqNhNCl1+94qKosmYZy9fai4o2wRwnNkjnvzw+c67eCQYhRQe2zeXnH3/9skBFtPzKx2qG
	137Ru455LDqTrMRSnJFoqMVcVJwIAFS07ZImAwAA
X-CMS-MailID: 20241128113101epcas5p3fefab67892c16c7bbaba8063c5c4a2c1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113101epcas5p3fefab67892c16c7bbaba8063c5c4a2c1
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113101epcas5p3fefab67892c16c7bbaba8063c5c4a2c1@epcas5p3.samsung.com>

This patch refactors bio_integrity_map_user to accept iov_iter as
argument. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 12 +++++-------
 block/blk-integrity.c         | 10 +++++++++-
 include/linux/bio-integrity.h |  5 ++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 4341b0d4efa1..f56d01cec689 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -302,16 +302,15 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
+	size_t offset, bytes = iter->count;
 	unsigned int direction, nr_bvecs;
-	struct iov_iter iter;
 	int ret, nr_vecs;
-	size_t offset;
 	bool copy;
 
 	if (bio_integrity(bio))
@@ -324,8 +323,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
 	else
 		direction = ITER_SOURCE;
 
-	iov_iter_ubuf(&iter, direction, ubuf, bytes);
-	nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS + 1);
 	if (nr_vecs > BIO_MAX_VECS)
 		return -E2BIG;
 	if (nr_vecs > UIO_FASTIOV) {
@@ -335,8 +333,8 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(&iter, align, align);
-	ret = iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offset);
+	copy = !iov_iter_is_aligned(iter, align, align);
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index b180cac61a9d..4a29754f1bc2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -115,8 +115,16 @@ EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
 			      ssize_t bytes)
 {
-	int ret = bio_integrity_map_user(rq->bio, ubuf, bytes);
+	int ret;
+	struct iov_iter iter;
+	unsigned int direction;
 
+	if (op_is_write(req_op(rq)))
+		direction = ITER_DEST;
+	else
+		direction = ITER_SOURCE;
+	iov_iter_ubuf(&iter, direction, ubuf, bytes);
+	ret = bio_integrity_map_user(rq->bio, &iter);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 0f0cf10222e8..58ff9988433a 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -75,7 +75,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len);
+int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -101,8 +101,7 @@ static inline void bioset_integrity_free(struct bio_set *bs)
 {
 }
 
-static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
-					 ssize_t len)
+static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	return -EINVAL;
 }
-- 
2.25.1


