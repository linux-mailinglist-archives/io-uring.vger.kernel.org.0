Return-Path: <io-uring+bounces-4490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA4B9BF026
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3D21F24871
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA481201244;
	Wed,  6 Nov 2024 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZsWKY+Lt"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE567201102
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903317; cv=none; b=V5D/76KqsKdj4RSfjee/xikckttUE2o+TEAI/U46syYIaKkUADBV8LuEKd4ipDsCvSrq5aTA3lP20r0JU6zwAmvy109kV9cGb8zOWUVsQ283SYuL7IBVI3rzm/dCuOIHwZjzIEoekQKo6y5ibDEIKJI6YyT6+OcYC0CEHwiiWhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903317; c=relaxed/simple;
	bh=z3oZCEUpNWP6ssVVNnvaEMGwTgZ5HxAO2xsIC7OVOu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Bg3vtf5ZlmM/HPL8tNGsrzEBG0PS7IrKkTKn+BYfmjHYixO1EywDmANcp4bcv2pU91cEE1QpiyClaCtJN2ZD13bFr1KJyDWCCyIa7OSZZ1Ab6Jgs6pqwqVja4v4cwHYgElTZGrVjHeqvy29fHjBn5QforbZ3lIt1Gp7u5Fynfvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZsWKY+Lt; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241106142833epoutp025eb13b8473e1af5e8dbc70fe72fe0da5~FZ2StJa6A1325913259epoutp02G
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241106142833epoutp025eb13b8473e1af5e8dbc70fe72fe0da5~FZ2StJa6A1325913259epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903313;
	bh=n6LNHR2UxOEOGCqUSfrJ4D/dcAXYHqklNM5hsVN/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsWKY+Lt9PpUDRxrn3BelXKNZf6eTdHyECHUaHjOE+wV3Gq6Y2YEFcAKI6NTO/uP1
	 CBNt82jpReMVCeOHNPlpDAJZX4vgcH8+uH401uZx+ZaRhrdPVkKJceHTJEMeMiLGfq
	 XRjuXkQE4iV3Rp9bvVDa4HKcg5V+6yfe8QgZHUzM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241106142833epcas5p4ec41e3f4046880d717c7eaead6e5c3bd~FZ2R8pyL31567015670epcas5p4B;
	Wed,  6 Nov 2024 14:28:33 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xk6y736Qyz4x9Pp; Wed,  6 Nov
	2024 14:28:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	79.2F.09420.F0D7B276; Wed,  6 Nov 2024 23:28:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241106122656epcas5p2aa5c312dd186b125b7c3f1af199b46d8~FYMGkhdTq3036530365epcas5p2l;
	Wed,  6 Nov 2024 12:26:56 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241106122656epsmtrp104fdee9b354f8a312a6b861c083ace4a~FYMGiFpe51944919449epsmtrp1V;
	Wed,  6 Nov 2024 12:26:56 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-0d-672b7d0fce31
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.75.18937.0906B276; Wed,  6 Nov 2024 21:26:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122653epsmtip1199a2b710a75c14bba0affe9f37bdabc~FYMEG0B3U0722607226epsmtip1h;
	Wed,  6 Nov 2024 12:26:53 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v8 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Wed,  6 Nov 2024 17:48:33 +0530
Message-Id: <20241106121842.5004-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmhi5/rXa6wZM/ghYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkb/rWWMBZe4K471b2JsYHzH2cXIySEhYCKx/2gX
	cxcjF4eQwG5GiR3PO1ghnE+MEptefkBw5k7tZYRpOb16BQtEYiejxP+3h6D6PzNK/L56nhmk
	ik1AXeLI81ZGkISIwB5Gid6Fp8FamAVeMkosXbWIBaRKWCBOYvbTY2wgNouAqsT+a89ZQWxe
	AQuJj0fWMkHsk5eYeek7O4jNKWApcfbzNkaIGkGJkzOfgM1hBqpp3job7AwJgTMcEnfaJ0A1
	u0ise/2IHcIWlnh1fAuULSXxsr8Nyk6X+HH5KVR9gUTzsX1Qj9pLtJ7qBxrKAbRAU2L9Ln2I
	sKzE1FPrmCD28kn0/n4C1corsWMejK0k0b5yDpQtIbH3XAOU7SHxdOoRaKD2MEo07PzCOoFR
	YRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OLTQsM81LL4RGdnJ+7iRGcyrU8dzDeffBB7xAjEwfj
	IUYJDmYlEV7/KO10Id6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPzCZ5JfGGJpYGJmZmZiaW
	xmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwdWguzU919W77LWK3wj/Sz+2qpVXMrsu1
	qo2N7orFJoEXlVJiZ3ntMC+Ren/bXu2Gnf45vpIgmbWFzAUGSz9OfKH4+JWLYf88rqrdCbPn
	sKxaXxl3clarbcqGOQV2+1UnXzrI46xu8PrfDy2Nfn6tv22cDXZrl5tWJy/UTCs1lHFU+ybx
	ve4zq0HHRSntpLmrU8PW7zu6v+x60J+jF6e9dZblvP9ZSl7gQ8ijKyYMCSuUTHuf+x/wf3fj
	Wp+DcDuz2uTj632+5J6crdtQ/DTJ5Grwd8nl3nY8AiIuhe+OPFl/ZmOrpBSn0I5Nmz5bR9rf
	Xpz6RHb1pjnvG2pPmka2fbHbl7joR3/6FZGd0W+UWIozEg21mIuKEwGXkwerbgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJTndCgna6QdNTSYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV0X9rGWPBJe6KY/2bGBsY
	33F2MXJySAiYSJxevYKli5GLQ0hgO6PE682XWSASEhKnXi5jhLCFJVb+e84OUfSRUeLs3uNg
	RWwC6hJHnreCFYkInGCUmD/RDaSIGaRowpfZYEXCAjESZ5+8ZgOxWQRUJfZfe84KYvMKWEh8
	PLKWCWKDvMTMS9/ZQWxOAUuJs5+3gQ0VAqr5s6CPGaJeUOLkzCdgM5mB6pu3zmaewCgwC0lq
	FpLUAkamVYyiqQXFuem5yQWGesWJucWleel6yfm5mxjBEaYVtINx2fq/eocYmTgYDzFKcDAr
	ifD6R2mnC/GmJFZWpRblxxeV5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBKNTD1
	Gq7dbSi28UCBcarJ1WtmP18uPztF8KLXur9+MwvrFHaZqpeVMlZd3uh9y7ldt+zIoo0/Dm/y
	bzRmFQ+9siGt+g6/wH8r1WPRVX2vC0KW7Znge/bnXWXTo8uTeJOPHOiZ9fUoj4/ZpSPf4h1m
	Sge/X6W3izuQU+WRylHZc/k3phjUKX13Unx/WnSjlubnuLqejZHVP7lyV953aZ7WdzxW/bzC
	PnchpdqmHrsFVY07/y4xuMq7XJbNtbZvikrD1jouyX+7U41l7NOK9m9cGBT1aMUcm8NbeJ6k
	TZ1XVymWO63/Q3j3K9/rCvxWc+//uWbdF+MudlrMyCjUy27jJXWGs6rzyvecFGgxOCLu8FuJ
	pTgj0VCLuag4EQA5U+F2HwMAAA==
X-CMS-MailID: 20241106122656epcas5p2aa5c312dd186b125b7c3f1af199b46d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122656epcas5p2aa5c312dd186b125b7c3f1af199b46d8
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122656epcas5p2aa5c312dd186b125b7c3f1af199b46d8@epcas5p2.samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2a4bd6611692..a448a25d13de 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -559,7 +559,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dbf0f74c1529..0f0cf10222e8 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,9 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 #define bip_for_each_vec(bvl, bip, iter)				\
-- 
2.25.1


