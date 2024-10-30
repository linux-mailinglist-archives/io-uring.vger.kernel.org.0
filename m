Return-Path: <io-uring+bounces-4236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B710A9B6BD4
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2385FB20FE2
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E6C1CBEA3;
	Wed, 30 Oct 2024 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PExMpOWM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C6C1D0DC7
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311826; cv=none; b=KSsAbev90MRl/xIhfEFiYmo7Mr0WyeybU20qtouK55SSJoefC9TXG+g+t8fJRmm4oQKi6QTqXnPFmQQpVpVdtfNdzwZqaDXi8LIgiMKQxTEAk3uIU5jnXkgVSaovkZuz6A9ZqzjQ90B5jWQ8qmQEHOQJOlkInjOFRqqEhVujogQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311826; c=relaxed/simple;
	bh=YXb7qnO3lu5vkwg1bZcdx5PFo4CJX/dp1xu0WKlJFxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=b/0W9JZRJ9rRTwTi7l53EHGbiJHL5bvGUMwFbaINhbaNyDvUEnpXIsIRRC0rbm0n3GytNB/dK5gCQPLUL6CuiaDEj5qg+HaiAO4b1t5c2L2NMTM7nwU6El2dSKayhY6gQGpHmuVqNytS0yjlMZ6JyPrdh7UUdad+MLWIYJ4qdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PExMpOWM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030181019epoutp04bdc9ad7441d6afd18099e95e846eba79~DTW6QBpbT0312803128epoutp04Y
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030181019epoutp04bdc9ad7441d6afd18099e95e846eba79~DTW6QBpbT0312803128epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311819;
	bh=1mlKPMPKFIJBhlmH3o5xGb/9qatIJGaThyCajlxzjfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PExMpOWMWYHvT5UCN3TUMoRTmBIducyLf+QJvlxHgsTIwTOi2NjgE0ceO4GWa6lup
	 j/tzE8ID/bYQD5vuEHQFFeflLHmseE8dNG/0++tEiQhFIKJIATcEGo6z7v9MMZPRid
	 jvJTKBWLfGUWGgSBCEyOhHpufEvWjK95EDYfSDkE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241030181018epcas5p147bd46c689df9a0893db55d290631dc6~DTW5uEoup1452514525epcas5p1G;
	Wed, 30 Oct 2024 18:10:18 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdwCD695wz4x9Pt; Wed, 30 Oct
	2024 18:10:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B7.2C.18935.88672276; Thu, 31 Oct 2024 03:10:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241030181016epcas5p3da284aa997e81d9855207584ab4bace3~DTW3ybWDS3027830278epcas5p3D;
	Wed, 30 Oct 2024 18:10:16 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030181016epsmtrp141d51540d875f3db54687f7596e4f268~DTW3xl6V00151201512epsmtrp1-;
	Wed, 30 Oct 2024 18:10:16 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-b5-6722768892c4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.C6.08227.88672276; Thu, 31 Oct 2024 03:10:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181013epsmtip267fc962ebcf5efff16e5a37bbf763948~DTW1USSch0238402384epsmtip2q;
	Wed, 30 Oct 2024 18:10:13 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Wed, 30 Oct 2024 23:31:09 +0530
Message-Id: <20241030180112.4635-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmlm5HmVK6Qd8ZPYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuqGybjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCflBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2
	SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGffer2AqmChVce78ZbYGxtOiXYycHBIC
	JhInNlxj72Lk4hAS2MMoce7XbTaQhJDAJ0aJO490IBLfGCUart1j7WLkAOu4OCsaIr6XUaJx
	/n9WCOczo8T2ya3sIEVsApoSFyaXggwSEVjKKLHyOlgDs8ByJol366cwgiSEBUIk/rXcYgGx
	WQRUJW6evcIC0ssrYC5xeachxHXyEjMvfWcHsTkFLCQ+7LgJVs4rIChxcuYTMJsZqKZ562xm
	kPkSAg84JBZP38YM0ewi8frkZEYIW1ji1fEt7BC2lMTL/jYoO1viwaMHLBB2jcSOzX2sELa9
	RMOfG2APMwP9sn6XPsQuPone30+YIOHAK9HRJgRRrShxb9JTqE5xiYczlkCDykOi/UYoJHS6
	GSXmbv3NPIFRfhaSD2Yh+WAWwrIFjMyrGKVSC4pz01OTTQsMdfNSy+HRmpyfu4kRnLC1AnYw
	rt7wV+8QIxMH4yFGCQ5mJRFeyyDFdCHelMTKqtSi/Pii0pzU4kOMpsAgnsgsJZqcD8wZeSXx
	hiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MOVYyLyNP/xAzDjN1ksh
	0lpsYRift51V9N3ySYW2Qge1tJct+HDvJVOxo9+niYcmLv24pDSfPXNiuWBI/cF5J/r1ejfy
	Ln84z6DTobHwqszOgsCL+pueumdppvdE/4/csHause0y0V18TMa8Xic+cljsfH1RY7rvzb1H
	+0vZNqxUO787iWlFvmvh2VMz/GMMZRctcbzpfnTSW86Jb/Y6H2GRNnA+EZ9smhIfHbDxl//T
	49xcMw/0ye5VcDHZt1cpkOGwfYpW5fzdE5TrJljvlcxx7q+4bHS8MvO7+KVD1058cbLTfnPd
	s+9CZJv1G4WPS7JsXQ4k37yqmHl8zcXwgwWbt0cc83W/Ee5TzNIroMRSnJFoqMVcVJwIACit
	YqVhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG5HmVK6wcv5whYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZ996vYCqYKFVx
	7vxltgbG06JdjBwcEgImEhdnRXcxcnEICexmlFiw5ixzFyMnUFxcovnaD3YIW1hi5b/n7BBF
	HxklGtf0M4M0swloSlyYXAoSFxFYzyhxdu8EFhCHWWAjk8SUjecYQbqFBYIk+s8dYQWxWQRU
	JW6evcIC0swrYC5xeachxAJ5iZmXvoMt4xSwkPiw4yYLiC0EVHJ94RmwOK+AoMTJmU/A4sxA
	9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4HjT0trB
	uGfVB71DjEwcjIcYJTiYlUR4LYMU04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5Y
	kpqdmlqQWgSTZeLglGpgciqbE7Uycknay4OmrBIBqZnyD9/4RR3w23hzquTyEnHONi0dO5O3
	HhLn6hpYbk6/29Ln/7B8pemKc4b7HC3Px8WGTcvlzqwqmvZR92qkOVugxuzi3JVbBVq0Zroy
	2FWbb9cM+rbW04b5SuWCe592Wlopnuq/Juy29aarslydIMvO57a1pSaru/fwRcl7mMw+3/BM
	7G7k7TCxJ5INO0+muK1f9P/ti7ZrP59XF71dae5RVrHzc+S9d1s8XrGU+C0Q2O+iYzkvIeXb
	Skmu2IXaKz7rip171X1E4c0F6xcxHivXnCxWqm2ZF9EnZ9ono3zRpKV32XFT6Q/T36r9XpH2
	aP/2s8/WC276dHV209oNSizFGYmGWsxFxYkAFlkzZSYDAAA=
X-CMS-MailID: 20241030181016epcas5p3da284aa997e81d9855207584ab4bace3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181016epcas5p3da284aa997e81d9855207584ab4bace3
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181016epcas5p3da284aa997e81d9855207584ab4bace3@epcas5p3.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the integrity payload.
BIP_CHECK_GUARD/REFTAG are conversion of existing semantics, while
BIP_CHECK_APPTAG is a new flag. The driver can now just rely on block
layer flags, and doesn't need to know the integrity source. Submitter
of PI decides which tags to check. This would also give us a unified
interface for user and kernel generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 11 +++--------
 include/linux/bio-integrity.h |  6 +++++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index f56d01cec689..3bee43b87001 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -434,6 +434,11 @@ bool bio_integrity_prep(struct bio *bio)
 	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 		bip->bip_flags |= BIP_IP_CHECKSUM;
 
+	/* describe what tags to check in payload */
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len) {
 		printk(KERN_ERR "could not attach integrity payload\n");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3de7555a7de7..79bd6b22e88d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1004,18 +1004,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 			control |= NVME_RW_PRINFO_PRACT;
 		}
 
-		switch (ns->head->pi_type) {
-		case NVME_NS_DPS_PI_TYPE3:
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_GUARD))
 			control |= NVME_RW_PRINFO_PRCHK_GUARD;
-			break;
-		case NVME_NS_DPS_PI_TYPE1:
-		case NVME_NS_DPS_PI_TYPE2:
-			control |= NVME_RW_PRINFO_PRCHK_GUARD |
-					NVME_RW_PRINFO_PRCHK_REF;
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_REFTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_REF;
 			if (op == nvme_cmd_zone_append)
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
-			break;
 		}
 	}
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 58ff9988433a..fe2bfe122db2 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -11,6 +11,9 @@ enum bip_flags {
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 6, /* guard check */
+	BIP_CHECK_REFTAG	= 1 << 7, /* reftag check */
+	BIP_CHECK_APPTAG	= 1 << 8, /* apptag check */
 };
 
 struct bio_integrity_payload {
@@ -31,7 +34,8 @@ struct bio_integrity_payload {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


