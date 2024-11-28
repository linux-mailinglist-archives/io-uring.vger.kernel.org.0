Return-Path: <io-uring+bounces-5113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 236279DB6B6
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87D17B21819
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC9919AD87;
	Thu, 28 Nov 2024 11:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ve7TH4UT"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A489C19ABAB
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794349; cv=none; b=b/cRc+jA0Qr8DoRxcUAavts3P6vhEWIh5n0PoQlhJVrmut5GHbi52J9Tqu84FkmezRl4Zqqh9pOAGrBRTrfi/DmJHROsMpDW0LKuWgDKcGzi/LIOuIQA7genzB+BPonNPLgSVkeN2BcM0XTs1kgmN+qNdcWzhGfMIyGfLwMlDsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794349; c=relaxed/simple;
	bh=z3oZCEUpNWP6ssVVNnvaEMGwTgZ5HxAO2xsIC7OVOu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dHxt80l4oG3rFSXwYtnttsheKL5IU0s8mRE+PHoCezenIEITzCZDxBScv2pLH0aO1gTohvu/ASTih6EZPLt4edGogNkAlLurKMzA5f9Dvciy+wB89ssWJ5l8sT+CCV3V5B09UxcFmFDbP23Mz0K2D/GxCiC02yizOm/xdHRcl0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ve7TH4UT; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241128114545epoutp03867dc385adffed92a4c82e290d94fa40~MH0bSqcLQ3191131911epoutp03G
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:45:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241128114545epoutp03867dc385adffed92a4c82e290d94fa40~MH0bSqcLQ3191131911epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794345;
	bh=n6LNHR2UxOEOGCqUSfrJ4D/dcAXYHqklNM5hsVN/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve7TH4UTrjaoxzxaVyMJPYLKmL3vANY90GJjHN+VnY21CbYuMJrOdMJegkLXxCz78
	 bT852QMNgL9IvFwKsR4cPeX6OCa0jPz5njFOjVb0Q09Pw1/v/S0UD/3nNcQcMORfFo
	 Xc5AF2u9oz9dV4iU1+xJcpUmaThhDslPikwBw/Gg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241128114545epcas5p315c08a232c61583b6ce602548eb40a87~MH0avYkSY0770307703epcas5p3G;
	Thu, 28 Nov 2024 11:45:45 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XzZJ737Jcz4x9Pq; Thu, 28 Nov
	2024 11:45:43 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B2.5F.20052.7E758476; Thu, 28 Nov 2024 20:45:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113056epcas5p2c9278736c88c646e6f3c7480ffb2211f~MHneuWfpJ0944809448epcas5p2b;
	Thu, 28 Nov 2024 11:30:56 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241128113055epsmtrp125914b31a9851fd5bfa2fbb23d18fb34~MHnetfzXq0051900519epsmtrp1w;
	Thu, 28 Nov 2024 11:30:55 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-5f-674857e7096b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	50.58.33707.F6458476; Thu, 28 Nov 2024 20:30:55 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113053epsmtip25c3e70b93be3b37eee03a79d53577f2a~MHnceONJ52429524295epsmtip2f;
	Thu, 28 Nov 2024 11:30:53 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Thu, 28 Nov 2024 16:52:31 +0530
Message-Id: <20241128112240.8867-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxjlvvf6C9ftgS67ksG6Nw0oAVql9eJEjRB8brqRLBnLhEBDX1rS
	0j77WodkyxoZiihUXZi0FIFtgNYFA6grFhZEB1FRFuVHYAOd0BEgCsjKfiBmpQXnf+f77nfO
	yfnuvUI8tJ8fJszRmxijXqmj+MHElesbomLG02i11N0Zgma9CwQ6fHIRRw7nFYAuDFv5aOr6
	U4AG21swdP7Czxh6UniXQBVnCjB0uqMfoLahaNTadpNAVXUeATo+4OKj+q7nGOpZ7OKhHrtD
	sDOEbrEPC+j7d8x0k/MYn27+/kvaPWjh07OeIYIuveQEdHf1DQE91xRBN409xlKDP9Vu0zBK
	FWOUMPpsgypHr06k3v8oMylTrpDKYmQJaAsl0StzmUQqeW9qTEqOzheHkhxU6sy+VqqS46i4
	7duMBrOJkWgMnCmRYliVjo1nYzllLmfWq2P1jGmrTCrdJPcNZmk11qE6wN5blddpbQIW8ERU
	DERCSMZDr72YWMKhpBtA2yNJMQj24acAjje0ghfFVWs7WGHMWk7zAowWAEcbpIGhOQAvz1wT
	LB3wyUh4Y7zQz15DtgJYUnObWCpwcgLAWue3fsPVZCbsLR7Ai4FQSJDrYf3owaW2mETQOzrO
	C7i9BW33/vKLisgEWNE/zwvMhMCbtjG/DO6bKbhcgS/pQ7JbCKvGHvg1IZkMvV9JAjqr4WTX
	JUEAh8EJ65FlrIZ/3/dgAczCgs6fllPugIW3rH4ZnNwAL16NC7TDYdmtBixg+yosWRhbpoqh
	6+wKpuDR845lDGHbXcsypmHt2W+wwOJOAPjgSNZJILG/lMb+Uhr7/87VAHeCtQzL5aoZTs7K
	9MxnL+4425DbBPwPfOMeFxh+OBPbATAh6ABQiFNrxOyq3epQsUp5KJ8xGjKNZh3DdQC5b9un
	8LDXsw2+H6I3ZcriE6TxCoUiPmGzQka9IZ4qrFSFkmqlidEyDMsYV3iYUBRmwTSP4QfR50r3
	Vv8z+N68rUi7PTyq8YuuN1F3XFSHLELK6n4d6eGt++34lsb6XjqNDNIdHXAjed7h/ZXRiROf
	f3xqsaaMX578w4+qZ7cdKcaFlNpXRC3e8qy1Q2n7rH1xNdZpXmjVSB/O8ejnkxkRBk/pzL/m
	oF7izM53FO4DX58L/zMjS45Gmj39+Scs3p5nLmffu3atN9KllrZjseOexrr5WXN6fnmyo9M4
	GfI7mK4Jmkv7I+9h/570XxYu2kMy2H2SyEdijiqq1VYOV9tea1OX7Egua9btdie9PX3g2P5r
	bFrjd0PCQ5t2RdxxtQet3zyVvrWOcH8SFexJKtr14TqK4DRK2UbcyCn/A3YEze5pBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJXjc/xCPd4OM5C4uPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV0X9rGWPBJe6KY/2bGBsY
	33F2MXJySAiYSHxsmMTaxcjFISSwnVHi8d5j7BAJCYlTL5cxQtjCEiv/PWeHKPrIKDHt7kkW
	kASbgLrEkeetYEUiAicYJeZPdAMpYgYpmvBlNliRsECsRPfXm0DdHBwsAqoSyx+XgYR5BSwk
	vj5+zgqxQF5i5qXvYIs5BSwlZl/7BhYXAqq5/Pg6K0S9oMTJmU/ARjID1Tdvnc08gVFgFpLU
	LCSpBYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGC40sraAfjsvV/9Q4xMnEwHmKU4GBW
	EuEt4HZPF+JNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamAK
	PardtHOhY1OXeqRFMP8hDrYsO6vM9EllbXU2E/RirnLZX5bt/HjrjsXqk5t9fvFt+t35MfS5
	tN71Tdc9NjSLNV6aWLZdbkmF+sy5Eo/+/bTUzn37/gLvrtatMRtDzyozuLiK2lzhSHG5blM9
	RfQn68qEgywd3N7aCds3l7053HJli6+46Qm5aVxXX3ZouTn6dalUCjekh100SyrzL7ges8n5
	24HZoncEZobFndXbPPfXk6mSti4zvgRnOva/NU5jqN76Y89rJRmnb9GSbDXOIVfOhy/jaxZ0
	KK95EPn09Ixwjd9nb++TXXuF+UxYqfO7+59nBPm+3xAlEPh0VXGc4SXH2Y6sp3R+C2oG1Cqx
	FGckGmoxFxUnAgALE1Q0HgMAAA==
X-CMS-MailID: 20241128113056epcas5p2c9278736c88c646e6f3c7480ffb2211f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113056epcas5p2c9278736c88c646e6f3c7480ffb2211f
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113056epcas5p2c9278736c88c646e6f3c7480ffb2211f@epcas5p2.samsung.com>

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


