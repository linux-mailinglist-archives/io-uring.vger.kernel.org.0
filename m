Return-Path: <io-uring+bounces-4491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CC09BF02F
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86038285824
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E249201278;
	Wed,  6 Nov 2024 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ebHZSSZV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3B201101
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903327; cv=none; b=uDqPxnipuLt12yCQqcqXtyX1Q4U3tNBo6atTS26kY41zm1yoBQXGl9YHm10kNYBYUzA+1LxCLdTVjk6deXC4tQgYZ5VrqcyzLiEX3KKyd5SgrLbOQpJJUXONX1/UDwIhicWCOxyTdAZ3KhOF4W3oDHMbgjBd98kZ8OcfnmZqH50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903327; c=relaxed/simple;
	bh=g2fp64Elfp9R80cl3zu6i89Ehrxw1OCNHe/eXuK93qM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dOpksZAc8udhE9Y3CCldSRCVDdTwaey0SqdUN8c9nZVe3pGvg9U2ohJnGcitu64clUPxdmbzaNDz+4M02E4C47W+MvvU66Uwp0u2n9qZUQoWdPaN7h5nUvV/148jMBZp3cvVpMLmMadyDezx9V1GCTDGDT572TD78KGtel+SDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ebHZSSZV; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241106142842epoutp03e3a4195c105e1fee06ba7a26ebc8cfaa~FZ2a06BhW2019520195epoutp03_
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241106142842epoutp03e3a4195c105e1fee06ba7a26ebc8cfaa~FZ2a06BhW2019520195epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903322;
	bh=FQM1oME+yjLcszh/NNdlGeevLgEVh+e4WfItNIpaOVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebHZSSZVpOVFzERRI/pT63le5Mxuhzazucfl39ecFWd9wowRzJRFLWDfaRYQKgsrw
	 vxZ0MGrB4wzgN//ZrRRqmm+aCZHOPA7+jhNBXlMvwF0vtrqTRD/+kS+h7W1v0Rh3/3
	 +a7tlXHcb8exou7Cb/+4p9gh6FnhPUnVNfje8YfA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241106142841epcas5p4c14347e219d955ba91889adee9e17d87~FZ2aOjGTs1566915669epcas5p43;
	Wed,  6 Nov 2024 14:28:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xk6yJ1g9bz4x9Pv; Wed,  6 Nov
	2024 14:28:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.D2.09800.81D7B276; Wed,  6 Nov 2024 23:28:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241106122659epcas5p28505a2288f3ac24408aaf138ac053793~FYMI9TjDC0502105021epcas5p2B;
	Wed,  6 Nov 2024 12:26:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241106122659epsmtrp25d9dbd51809b4af77c8f8fd43592fb90~FYMI7psJw2560925609epsmtrp27;
	Wed,  6 Nov 2024 12:26:59 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-14-672b7d189239
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.26.07371.2906B276; Wed,  6 Nov 2024 21:26:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122656epsmtip15daa342826f8e12932f9a06f871347b8~FYMGmHqSV0829608296epsmtip1p;
	Wed,  6 Nov 2024 12:26:56 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v8 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
Date: Wed,  6 Nov 2024 17:48:34 +0530
Message-Id: <20241106121842.5004-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmpq5ErXa6wbGTHBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbn2U1MBav5KlY1TGNrYJzE08XIySEhYCLRMHsr
	YxcjF4eQwG5GiUlPPkI5nxglfs67ygzhfGOUWHR6CRtMy5oLa1khEnsZJdbf+8gO4XxmlHg7
	bSYjSBWbgLrEkeetYLNEBPYwSvQuPM0C4jALvGSUWLpqEQtIlbBAssTvf3/AOlgEVCVubJzH
	BGLzClhI3Py+hAVin7zEzEvf2UFsTgFLibOftzFC1AhKnJz5BKyGGaimeetssGMlBC5wSDz/
	cxnqWBeJa+d3M0LYwhKvjm9hh7ClJD6/2wtVky7x4/JTJgi7QKL52D6oenuJ1lP9QEM5gBZo
	SqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsZUk2lfOgbIlJPaea4CyPSRunGhmggRXD6PE
	nueXWCcwKsxC8s8sJP/MQli9gJF5FaNkakFxbnpqsWmBcV5qOTyik/NzNzGCU7mW9w7GRw8+
	6B1iZOJgPMQowcGsJMLrH6WdLsSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgdkkryTe0MTS
	wMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJsGXUtO3uixsTpL+VyPWP7Fr
	r9iOPo0fdVacOwxarq1mLXl5v6q+2k82dSGvTnqed+bk+f3M19TiTVasPbP68er+e1LlFzQ0
	dV9P3yOaHOS99vMOa+3mvLVRF1c+X9pdzv3IfWmDpvjyzydtTVLmruF4WHp1mdJ3TuUbZybN
	PiP6pNx7oW/DuUu3a45uTXHee2YDk8yrUvEZS05p5hbM3H77aE+IkGnge3FzAZvLR/q3XN2q
	LCjX1Gx5ar2n7bVltr+44zaGLlhr0L9sxXMB9RWXemuO29bvLVF9/T9B+es1j5h3Lqp/hMWX
	7GeIvziryun++QUlO04FhZw/w5tx+V2uf9t8oxYvNdY7vrs6HymxFGckGmoxFxUnAgCxsso/
	bgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO7kBO10g6lzGS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxufZTUwFq/kqVjVMY2tg
	nMTTxcjJISFgIrHmwlrWLkYuDiGB3YwSJ7d/ZoNISEicermMEcIWllj57zk7RNFHRom12xey
	giTYBNQljjxvBSsSETjBKDF/ohtIETNI0YQvs1lAEsICiRIXVn0Fm8oioCpxY+M8JhCbV8BC
	4ub3JSwQG+QlZl76zg5icwpYSpz9vA1sqBBQzZ8FfcwQ9YISJ2c+AatnBqpv3jqbeQKjwCwk
	qVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgRHmpbGDsZ78//pHWJk4mA8
	xCjBwawkwusfpZ0uxJuSWFmVWpQfX1Sak1p8iFGag0VJnNdwxuwUIYH0xJLU7NTUgtQimCwT
	B6dUA1PwK7FrMzrjHZkk23aqRClUnHgwvXMPz+SspQeUE1fKRyYzKMnyHvT3nr1jNnsnL/P6
	tUvCpZcURrddXLo34u7j11G2s7sel+/8vqJhcRyXsdyrTa+vvKrbuM1XUCNMOLng0OOumA9N
	PAtbUsSn/hU3vSsRsHDt3CVV+RfnL8nhYQsy+ffs362XBwXnax9IUr3fKyXaY/Pioa/yy+Jo
	YYeipgvNipyv1MunifCLfy1qPJ7/yf1eLJPKzEPy/1iV7GpXe/n55Thdlp297rpE3JfQJ2mO
	24zaNime0Hs3kcWzoOThypTd0w7aOeYZf5hrkFnk8ePBth8h7x53/+gOS93QPbdxwpakr9xa
	tbZPtJRYijMSDbWYi4oTAVSSS2ojAwAA
X-CMS-MailID: 20241106122659epcas5p28505a2288f3ac24408aaf138ac053793
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122659epcas5p28505a2288f3ac24408aaf138ac053793
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122659epcas5p28505a2288f3ac24408aaf138ac053793@epcas5p2.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Copy back the bounce buffer to user-space in entirety when the parent
bio completes. The existing code uses bip_iter.bi_size for sizing the
copy, which can be modified. So move away from that and fetch it from
the vector passed to the block layer. While at it, switch to using
better variable names.

Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
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


