Return-Path: <io-uring+bounces-4688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EFD9C890F
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79900B285AF
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2C01F9424;
	Thu, 14 Nov 2024 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PF0mD+1U"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D83192D9D
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583214; cv=none; b=lRLXi0QtSlv50Qj/6a5UUfJ4Tvz+dEZXmKU+auxiT7/bZiUxZl3JFCOIBKXcJ1NQ6q98CUlWYFvxInPjlfc/chN1S/ekyfAmYqzqiPlNsY7BHan05z0wIRCFW4ngY9dAh8oDiO1OlM8VpZbnT2EgpdHUhNrAuEDxpl6qSpiAhWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583214; c=relaxed/simple;
	bh=ZIkdyJlOm3c2bE0cQ6pelSYB5Gra8HNzZg1GmGSloUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=N3PXfl3ipSZCiBLdOUg+9QF0USe4DiWfcyaxNm2jt8XSEZVQEScMevHSPKeh0g93A271LtE7ykq7sPrjdlKbjQdfMrtfksQGUFobzSULpV48FDXqEzf0kpGEBSMUY59Ci9rrGIkwfEB06PCqM0mY+OFZ2RFOTube6bte2N9Z+u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PF0mD+1U; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241114112010epoutp02ddeffc0d711fed4b91eaa67cae270058~H0cGCJEsX0582205822epoutp02Z
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241114112010epoutp02ddeffc0d711fed4b91eaa67cae270058~H0cGCJEsX0582205822epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583210;
	bh=r23oSTZl50mKsH838ytL5lDlNxkmkMYy4oR7U1Ruz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PF0mD+1Uc3ABHp9igVRJZyx9VaORGt6+h0rso+f6Mcecfr7dCmURgXPMzqR0FXF3i
	 BY/+AAww+r/cFmJQ79gWtASLesNIoEKUxQmzSzdmgeGtMUXKL3x7a6hMXJZxK7RwFP
	 CDnbpAkXajupTBxeMhm3Gp2lMYUULrUmZiGhrLqU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241114112010epcas5p2c05eedd7aade60c18125b1c28d7d0e6c~H0cFvN30Z0550505505epcas5p2J;
	Thu, 14 Nov 2024 11:20:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XpyP45js1z4x9Px; Thu, 14 Nov
	2024 11:20:08 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0B.DA.09420.44CD5376; Thu, 14 Nov 2024 20:17:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241114105357epcas5p41fd14282d4abfe564e858b37babe708a~H0FMtRb9B0515805158epcas5p4n;
	Thu, 14 Nov 2024 10:53:57 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105357epsmtrp1348781fd0532b9999f94192cc2b3c546~H0FMsY4QM1621616216epsmtrp1M;
	Thu, 14 Nov 2024 10:53:57 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-e0-6735dc44f93e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.C6.18937.5C6D5376; Thu, 14 Nov 2024 19:53:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105354epsmtip256d59d467f449bb7ec6122186b09da67~H0FKKnhPi1403514035epsmtip2R;
	Thu, 14 Nov 2024 10:53:54 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v9 03/11] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Date: Thu, 14 Nov 2024 16:15:09 +0530
Message-Id: <20241114104517.51726-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHPfde2gux27WAHjBjeKfOzgAta7vLhE0tw6vz0ekSnXF2HdwV
	pLRNH+pM1ApjZGwUEAysKwNlDikGoXY8hPLoeGTgHhm4V4QsAgEcMKBhDyvTllt0/33O7/v7
	5vc45+Aof4QTiWdojIxeo1STnBCs6axAEDPxu0QlzOt8llpY8mJUdtEyStnsTYCqGynkULfO
	LgLqelcrQtXW9SLUXO4FjDpRloNQvf/Mcqiv3VcA5brxPNXuOodRlacnuNTRqy0cqqb/AUJd
	XO4Poi5abdwX+XSrdYRLD5030Q77EQ7986kv6bbrZg69MHEDoy1OO6B/rerh0h5HFO0Yn0Xk
	Ie9nJqYzyjRGH81oUrVpGRpVErnzHYVMIZEKRTGiBGoLGa1RZjFJZPLr8piUDLVvJjL6Y6Xa
	5AvJlQYDGbctUa81GZnodK3BmEQyujS1TqyLNSizDCaNKlbDGLeKhMJ4iS9xX2b6xJQH0bVH
	fdo2RJtBU0Q+CMYhIYZDU71IPgjB+UQbgN6/plC/wCcWAWzw7GEFH1flD3NWHd2j5iBWaAXQ
	2fcbyh48Pru7BPFncYiNsGcyF/iFMKIdwIJvBzH/ASWKEJhXbOPmAxwPJRTw5D2h34ARz8CS
	q3lcP/OIBDja/FWg3Hp4/PLdlXgwsRX+YD6DsjmPwXPHxzE/o76cnDMnVrqAxDUcFk/NA9ac
	DI/dsWAsh8I/+51cliPhdOHhAKvgvaEJhGUdzOnrCHi3w9yBQtTfJ0oI4E+/xLHhdfCbgXqE
	rbsGFnjHA1YebDm5yiTMq7UFGELXBXOAaXiq+j7GbqsAwPaiHqwIRFsfmsf60DzW/0tXAdQO
	IhidIUvFGCQ6kYb55L9bTtVmOcDKO9/0agsYuTkf6wYIDtwA4igZxhuQbVbxeWnKg58xeq1C
	b1IzBjeQ+BZejEaGp2p9H0VjVIjECUKxVCoVJ2yWisgneLdyK9L4hEppZDIZRsfoV30IHhxp
	RpCZ8hG5Y21Iu/eoydn8ON147NDgLjgcXzNTXtP895oHtre+B9aX1J9nWfd0yyLIxdu2He9+
	IHPxfsx2binbN/dacL+cH18d9xF9SePdXzxTEeF6eekO8gZHFiJYqm7b9cd8sNxUXictTQ7d
	HYVfU51vsKe3vjdoZ17ZMGYxXc7e8KGlcpYrrjdVPHq6KKOv+83Opw7vvd9svCLcSeY6cZnl
	tvtJzyOlXTq6wzN3KRGGq8Mbb36x97uNtcmlkwfC5NP7D1WNlXldfNfajueeVkUN3317YSou
	Luzg9PaUhhcm14U1HxitXy5J2b0t1jRmHq4UdFUf6dTxJEMpDgpfH9S4g8QM6UrRJlRvUP4L
	Q/aJu3AEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXvfoNdN0g5Y2fouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6Mpy8+MxXskavY
	fdmjgXGbZBcjJ4eEgInEwXsNrCC2kMB2Ronb72wg4hISp14uY4SwhSVW/nvO3sXIBVTzkVFi
	0vpLLCAJNgF1iSPPW8GKRAROMErMn+gGUsQsMINJoufXCjaQhLBArMSOY3PBNrAIqEpMvt7O
	DmLzClhK3NveyAaxQV5i5qXvYHFOASuJFQ1bmbsYOYC2WUp8Xy8CUS4ocXLmE7C9zEDlzVtn
	M09gFJiFJDULSWoBI9MqRtHUguLc9NzkAkO94sTc4tK8dL3k/NxNjOAo0wrawbhs/V+9Q4xM
	HIyHGCU4mJVEeE85G6cL8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwREkhPLEnNTk0tSC2C
	yTJxcEo1MDUWp14xbfkppsni9sziS/CE+Se+yV11mTbBNzr5iYTjkgO/KgSuBtgu3JeevVL0
	4/23E3rv1X19t1r3b/kB07NMBzz+9PL7TFoRstI2rcJL+LI2/+8d3X6zbYIf7rJmPHA6cp5G
	GrdGGPPOANaOXCmfbKErcxTPpJ9/+muzS8qJ3JfZghNXL/01Idc3NnjVUelzvP35P13TnP8/
	+b7rTLni0TINp186n5/yel7eoHj6PePm71MzVvImnM5ZemLFE+e/RzcdcVSZ6vp1yz/F3F1s
	t/vntjTZ88RtSHN+d+pvpUguG2dnk++CU/VF3VKsrCtmTphdtWtPkUXgjKfJRhltt+coK+f2
	TSlIlROO7VZiKc5INNRiLipOBAClUBqXIQMAAA==
X-CMS-MailID: 20241114105357epcas5p41fd14282d4abfe564e858b37babe708a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105357epcas5p41fd14282d4abfe564e858b37babe708a
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105357epcas5p41fd14282d4abfe564e858b37babe708a@epcas5p4.samsung.com>

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


