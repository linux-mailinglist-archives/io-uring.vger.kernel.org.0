Return-Path: <io-uring+bounces-4136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE649B5056
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6A71C22AF3
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E012719992D;
	Tue, 29 Oct 2024 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jeX2xZC/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0C81D9A40
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222619; cv=none; b=FDXnje1ASrdWhyenrPURL2hYEqiGPI9U5CZlrrUDkSOgqWAHkptQGmEVcF3NrfvIJm/dqH333Bfi+//B+IvBi2pDL5v2eJb+y2smEQGTAvNVt8F250YuDtKj1TtcfkKkKo3JjFi2/Ma1sntQA8vVon5MfoEVBlf+00+S3h22vu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222619; c=relaxed/simple;
	bh=u4sUcEX/k+wez75P184+zcG/4LIpxzsuKCd9h01C0oc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Bf/8suT2YiiVSX/fIdK6/CrdQ0qCQneGNN2Ernji3S5MTRAqZGIkkNUb5/AGbydAKkIs3gUV2nUL+ndXLfGmnS5q9Sr798ki7jCeZ9Gi8MTdIWA40Aiq7IN7IAgXqTvvYB+x4ZtFHR+LhooQ0OuK6nkwUtMTIycG/Ipew6K3XJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jeX2xZC/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241029172335epoutp0461af01ae31c3b55fc60db8e930771603~C-E1W7yYt0698406984epoutp04I
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241029172335epoutp0461af01ae31c3b55fc60db8e930771603~C-E1W7yYt0698406984epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222616;
	bh=1yEesIXP8hqj3mWCayZYKotAS9KxK7WmVJifezfxMwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeX2xZC/LBi4YoC6cDzUO00POu0r7qcvQKL9zvWCUGWP1lhqzwJnveJPhBYv8u0V2
	 HWhzpuf6jUxX/cQafdMm5s9vjr+MNOrvstwQzgY0IUPhOH8ZGXpolGwzPmrIGhO1Xo
	 YH0IGb9Vj4+/xeNI/l088ZxyHCEDEERZqREFPlkc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241029172335epcas5p4b9aeaf624b86420921a9231cc1551bee~C-E0vVZsB1636716367epcas5p4B;
	Tue, 29 Oct 2024 17:23:35 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdHCn3w11z4x9Pv; Tue, 29 Oct
	2024 17:23:33 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	02.F9.09420.51A11276; Wed, 30 Oct 2024 02:23:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241029163214epcas5p1069ca93a2a9d8840e4f142cc4b713775~C_X-v4_OV2340523405epcas5p1A;
	Tue, 29 Oct 2024 16:32:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241029163214epsmtrp1c51dc3fc90333bdd1c5a8dcc372ba54f~C_X-vDYut0708307083epsmtrp1K;
	Tue, 29 Oct 2024 16:32:14 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-52-67211a15b45d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D4.07.08227.E0E01276; Wed, 30 Oct 2024 01:32:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163212epsmtip2c07a03b121b4c271c42f7bd3adf8681f~C_X9alVN10998409984epsmtip2W;
	Tue, 29 Oct 2024 16:32:12 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v5 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
Date: Tue, 29 Oct 2024 21:53:54 +0530
Message-Id: <20241029162402.21400-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029162402.21400-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmpq6olGK6waXHkhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsajO2vZC87xVUzbcpulgXE9TxcjJ4eEgInE7J0r
	WboYuTiEBHYzSkzf+JkRwvnEKLHm4l5mCOcbo8SMXY9YYFp+P/nODpHYyyhxZeFpqP7PjBIP
	t79kBqliE1CXOPK8FWyWiMAeRoleqCpmgZeMEktXLQKbJSyQLDH71i+gDg4OFgFViecfC0DC
	vAKWEnf//IFaJy8x8xLIOk4OTgEriWNH9zBB1AhKnJz5BKyGGaimeetsZoj6CxwSzx4HQ9gu
	Epd6QB4CsYUlXh3fwg5hS0m87G+DstMlflx+ygRhF0g0H9sHVW8v0XqqH+w0ZgFNifW79CHC
	shJTT61jgljLJ9H7+wlUK6/EjnkwtpJE+8o5ULaExN5zDVC2h8Tuv2uggdXLKLHj/lHWCYwK
	s5C8MwvJO7MQVi9gZF7FKJlaUJybnlpsWmCYl1oOj+bk/NxNjOA0ruW5g/Hugw96hxiZOBgP
	MUpwMCuJ8K6OlU0X4k1JrKxKLcqPLyrNSS0+xGgKDO6JzFKiyfnATJJXEm9oYmlgYmZmZmJp
	bGaoJM77unVuipBAemJJanZqakFqEUwfEwenVANT3OdX668caFp2tfHbbul/Kb/Xs3b7vuNI
	4YnYVhbYGtvak+r+54OMaFhv7cQajZA1gkd8a1v1eYQNlG4/mq2m/LbEbY6B4t0dYc96H8kt
	ZrL9dpV902bm1anZ85R7GkPiP3TEs/BLPvxbLLXfbbIej8sVG27XEqGC4x/PFioduf2nwrHp
	aeBy82m9VqmHJz3xFp7K0nz4YPwGlrp5p3/zi076XmnObKQ9V0numbqHoMfx37ruRa0LPkxJ
	iT9ncObW4+3Mf3bLmgYySBucmdrwz0+JY9Ks54zXrnVuPfD4bZr8TJ6Gmf4Bf748Dvx2Yvml
	O9//rw2dYJJjF5tp87ph3qtbRSukUqVi20zu/eJTYinOSDTUYi4qTgQA8EEGXmwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXpePTzHd4OMiZYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV8ejOWvaCc3wV07bcZmlg
	XM/TxcjJISFgIvH7yXf2LkYuDiGB3YwSZyb/Y4RISEicerkMyhaWWPnvOVTRR0aJD9P62EES
	bALqEkeet4IViQicYJSYP9ENpIgZpGjCl9ksIAlhgUSJC3enANkcHCwCqhLPPxaAhHkFLCXu
	/vnDArFAXmLmpe9gMzkFrCSOHd3DBFIuBFRzcpIbRLmgxMmZT8DKmYHKm7fOZp7AKDALSWoW
	ktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBUaaltYNxz6oPeocYmTgYDzFK
	cDArifCujpVNF+JNSaysSi3Kjy8qzUktPsQozcGiJM777XVvipBAemJJanZqakFqEUyWiYNT
	qoHJ8c/HDRcuyYQZXO20c5sQdmHJz3JDY8fDJu2GP2a902toc9q78m3NSybVq1uDkzlrfbQF
	Mu5X67H/+h654cCFv1PPrG7m9t/5w/nJ/L7De9+kGe14dZ7P7Kjjfr2KeJaMA08+7Th/8Kj7
	srw7XGpdZw/esX0if+ffHFNpaXf7E7+rjn3wtmaokCxMNZ86Vyhkfgab78H9+1517LK8YGmc
	f52Pf4fQnG47o7ZNybZXzu1U2i4m9nD/rSibGS0z27T+/JE2EnsW/59B45xKNuvz/87ZH2fZ
	Zr1fu/pGpY/1OcPKF01+q42kJsoqrNoQddDh6P5//qsj5FIKzq548HChhQ+vZu753U/nZdxy
	vvVUUYmlOCPRUIu5qDgRAL6ZvHUhAwAA
X-CMS-MailID: 20241029163214epcas5p1069ca93a2a9d8840e4f142cc4b713775
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163214epcas5p1069ca93a2a9d8840e4f142cc4b713775
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163214epcas5p1069ca93a2a9d8840e4f142cc4b713775@epcas5p1.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Copy back the bounce buffer to user-space in entirety when the parent
bio completes. The existing code uses bip_iter.bi_size for sizing the
copy, which can be modified. So move away from that and fetch it from
the vector passed to the block layer. While at it, switch to using
better variable names.

Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[hch: better names for variables]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a448a25d13de..4341b0d4efa1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -118,17 +118,18 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
 
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 {
-	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
-	struct bio_vec *copy = &bip->bip_vec[1];
-	size_t bytes = bip->bip_iter.bi_size;
-	struct iov_iter iter;
+	unsigned short orig_nr_vecs = bip->bip_max_vcnt - 1;
+	struct bio_vec *orig_bvecs = &bip->bip_vec[1];
+	struct bio_vec *bounce_bvec = &bip->bip_vec[0];
+	size_t bytes = bounce_bvec->bv_len;
+	struct iov_iter orig_iter;
 	int ret;
 
-	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	iov_iter_bvec(&orig_iter, ITER_DEST, orig_bvecs, orig_nr_vecs, bytes);
+	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
 }
 
 /**
-- 
2.25.1


