Return-Path: <io-uring+bounces-1632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4748B285C
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CC42281708
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0257014F9EF;
	Thu, 25 Apr 2024 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EkWk0nZF"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEFA14E2CC
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070826; cv=none; b=LyP7MNXrszjQ3aUd/OQS7SedGAfZzXcMkeThqf5mxd9LbS3Wtsknnn0H9nsz0ZiKI+30L7I7H+iYB00UdULoF+fWAgu0OyaGEW1j4+4NnuLVs6yZOHQHrQ7J4uMe/Im9WrhDREFtzZJGHPUGjR4teD95fnzlifEHUO78neGP4R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070826; c=relaxed/simple;
	bh=kOhpakvYf08EPjB71ahhoVsLQyFkjn3TrcLEzDp72jc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LCIMItR5rStawilXfIRfxIk+UE3HcSbEcAav1T6qZzxmJlqoLOoCjgBVDvhLJzNSf5H+91D2Kj05cIWSe8kTHB6hlN0TUC3IUGQygppd3PWsXbUGqs/2sxC3nQU39vk7+dKrhqiGItNGFNmBTDvyvuI3H+7KFOz98CACNpjGmms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EkWk0nZF; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240425184657epoutp046f2c493667ebe7411d818bfac29cfbbc~JmlOb3-TQ0315103151epoutp040
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:46:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240425184657epoutp046f2c493667ebe7411d818bfac29cfbbc~JmlOb3-TQ0315103151epoutp040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070817;
	bh=8UjWzASLbE281aLekYBWGcVUrDYfR/50j9EjsKMziS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkWk0nZFFZR+UZPyMT3GvkvBnqBu8Ir0x2eKAXzvLVPGuZ/zaYZ+XLZ7vPDMFrndK
	 6CdiDg98Eole7XqWegqjEo7GV6nC2/+lY+bGx1B+3vcv1aJyLaabEr11jwQbyHz0gl
	 p5rjRcNhC0GFBvJAB2wyJTeFCvDRtSEHAH+HkE3g=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240425184656epcas5p35ee096051f0bbb21f8542a38aabb4ea6~JmlNhW5YC0824808248epcas5p3h;
	Thu, 25 Apr 2024 18:46:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VQPwG354Fz4x9Pp; Thu, 25 Apr
	2024 18:46:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A7.20.09665.E15AA266; Fri, 26 Apr 2024 03:46:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7~JmlLj1-nc2219922199epcas5p2p;
	Thu, 25 Apr 2024 18:46:53 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425184653epsmtrp15999b231b11a167202adf9a316909721~JmlLjFbN_0085200852epsmtrp1N;
	Thu, 25 Apr 2024 18:46:53 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-13-662aa51ea6f3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F8.F0.07541.D15AA266; Fri, 26 Apr 2024 03:46:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184652epsmtip15304991c802986bd2c08f53595bdaacf~JmlJv392M3082730827epsmtip1Y;
	Thu, 25 Apr 2024 18:46:51 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of bip_vcnt
 during clone
Date: Fri, 26 Apr 2024 00:09:35 +0530
Message-Id: <20240425183943.6319-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhq7cUq00g1k3BC2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvF0f9v2SwmHbrGaLH3lrbF/GVP2S2W
	H//H5MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKOy
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
	KQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfs
	vPaCteA+R8WxZzdZGhgXs3cxcnJICJhIHH1+ma2LkYtDSGA3o8SyVX1QzidGiSk7b0E53xgl
	NrcdY4RpubV+IytEYi+jxKFDq8ASQgKfGSXO/+foYuTgYBPQlLgwuRQkLCKQIvFq3WuwEmaB
	p4wSPzqZQGxhgXCJU/ufMIKUswioSlz6bQQS5hUwl5i2spcVYpW8xMxL38Eu5RSwkJh88TQ7
	RI2gxMmZT1ggRspLNG+dzQxyjoTAWg6JX3Ofs0E0u0hs7ZsG9aawxKvjW6BsKYmX/W1QdrLE
	pZnnmCDsEonHew5C2fYSraf6mUFuYwZ6Zf0ufYhdfBK9v58wgYQlBHglOtqEIKoVJe5Negp1
	srjEwxlLWCFKPCQOb6iDhE03o8TBT9kTGOVnIXlgFpIHZiHsWsDIvIpRMrWgODc9tdi0wDgv
	tRweqcn5uZsYwQlXy3sH46MHH/QOMTJxMB5ilOBgVhLhvflRI02INyWxsiq1KD++qDQntfgQ
	oykwgCcyS4km5wNTfl5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxS
	DUwnok1m2C/6InaQza+hSHte4bZfnX7Pjwv9mhnIVxH0lUFha5LDDs3/87gZYhZMnWZ9/Wzi
	C83LOpO3TvPm973uVi5d3Whr96JSMVrX7FuNmGN9wOYP3G2T2z0nFhheWfdo54t+hVjLluXV
	SVeKr2/6eOX8v1cyu/8rbFO3mCRr9JMhPdu/vshuXlfX3psXnyqw692aM0HPWVrg0gXtaScO
	+2twS29oERNnCo17t/NR1CHJC0pfpxwW8zHQXMHc9JsnR6Ij74L51S3tJ+ez7QuRt7PP/tZz
	JeugQUL5o1nF5apvs3qMY2bGvT0stDn9ru6KWccP7+Fl6Gi0K3A+6lGYxlyoGVNyfJ77iZ27
	WZVYijMSDbWYi4oTAUZyiMNBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSnK7sUq00g03NZhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsXi6P+3bBaTDl1jtNh7S9ti/rKn7BbL
	j/9jcuD1uDZjIovHzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fnTXIBnFFc
	NimpOZllqUX6dglcGTuvvWAtuM9RcezZTZYGxsXsXYycHBICJhK31m9k7WLk4hAS2M0oMXPS
	BGaIhLhE87UfUEXCEiv/PWeHKPrIKHF43mSWLkYODjYBTYkLk0tBakQEsiT29l8Bq2EWeMso
	Mf/vHrBBwgKhEn+mv2AGqWcRUJW49NsIJMwrYC4xbWUvK8R8eYmZl76D7eIUsJCYfPE0mC0E
	VDN1zSJGiHpBiZMzn7CA2MxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcZMMCw7zUcr3i
	xNzi0rx0veT83E2M4JjR0tjBeG/+P71DjEwcjIcYJTiYlUR4b37USBPiTUmsrEotyo8vKs1J
	LT7EKM3BoiTOazhjdoqQQHpiSWp2ampBahFMlomDU6qB6cipWw3Fkw+dXl0YKXFwZ+fyhIDT
	m7Y/O//9g5+4uNbFxddDJ8clLyh+Vt4x36vRVfmo/WXzBUVSbeeZ7/K67/Ce81HnopRDaMxt
	lozC+isvl8vPyXhawL10YsH85b6HSjw+vHjVNFM12DPHR+Nc66atGdsUmAKTxX8+j5p66Okf
	0Ul/RaIr2D+bsB79wb6sqpzf1T+F713Lz3s2KxsFrgTysvoe8/fr7b1WfSzNfHFf9bvnnNKX
	b1icuch3J/lK1eHr6cL976J9583TvDD357omcb7FTRKiu/7snXTd5JRTJtf81Uldmbs1/m/K
	9TG0X6PmWWW4fErwtszZgXtvCYX46O9TXeA7+1/apefdfkosxRmJhlrMRcWJAG8TR5QIAwAA
X-CMS-MailID: 20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
is one greater than bip_vcnt. In this case bip_max_vcnt vecs needs to be
copied to cloned bip.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e3390424e6b5..c1955f01412e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -622,12 +622,12 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
+	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_max_vcnt);
 	if (IS_ERR(bip))
 		return PTR_ERR(bip);
 
 	memcpy(bip->bip_vec, bip_src->bip_vec,
-	       bip_src->bip_vcnt * sizeof(struct bio_vec));
+	       bip_src->bip_max_vcnt * sizeof(struct bio_vec));
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
-- 
2.25.1


