Return-Path: <io-uring+bounces-5120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CD29DB6CF
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 095DB281B57
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A7019AD89;
	Thu, 28 Nov 2024 11:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="F3Y1uDVN"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37D419ABAB
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794383; cv=none; b=acfI/hao0BeVBwhaWMEI8JywnQB+bes43fsJUWTPwIWF2yoNdL+6m/DLhNdZCzRwuVJ8hcWnTC21G/QOA12z3M+ajwpS7X/HsMUAsU0sX7eUpMyVlf5VStzNSPN06Ew1c7iuBTvfqGaECdM8OW9gn8+UKDT1Zgw/TJtFMc3X3c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794383; c=relaxed/simple;
	bh=4bwNPqd2mgS/me72gS6c9qKx3N7iAIorybNdKO8yxVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MO/tELRXk4Rde/nagW6foEH3/XcaDIuBmS//cGfR8Olb0Xg7B98YWIwPD7kH9ffw+cs3I0U+q6o7CHBN22a1fvgaxgmoFsK+oq6dg9VKuSCL4AzPb5bFsvMBpP0nBwPAy7l0dkdLm+gQ5KBUQ69ai5NpbeyzcZuxGJCE4SEHLRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=F3Y1uDVN; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241128114618epoutp0173938be63e4233479e4af4c6ceebd1d5~MH06Tpc8x2993029930epoutp01T
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241128114618epoutp0173938be63e4233479e4af4c6ceebd1d5~MH06Tpc8x2993029930epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794379;
	bh=1yhnn/JEQDkJO7MPiDYhPt3P6x3KI+3HedoJWLZAeh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3Y1uDVNHO04Ku4DjWtzVtqj3/wnub/RCvMqJ8tlBpb8ctucKLggP+FU/ATCXPE50
	 Vd6my0dIOwzW2b+LLx8hoZw1nwPUtnu7EEtr1f4skmA0wo8XNUWdBZrc7GC1bBCC5+
	 c5Ls2Z/Dwaclt2ldUBqnIDId+V9icFnvlhDBwvew=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241128114618epcas5p3f9f6ccf5ec4f291d7f4098c9d987ebaa~MH052gaEm0106501065epcas5p3T;
	Thu, 28 Nov 2024 11:46:18 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XzZJm5NH1z4x9Py; Thu, 28 Nov
	2024 11:46:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.29.29212.80858476; Thu, 28 Nov 2024 20:46:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991~MHntuBwUR1791917919epcas5p1c;
	Thu, 28 Nov 2024 11:31:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241128113112epsmtrp25d1f830f2feb39b0e70c41359d978bd0~MHntswlK40091000910epsmtrp2i;
	Thu, 28 Nov 2024 11:31:12 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-f1-67485808a646
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.0D.18729.F7458476; Thu, 28 Nov 2024 20:31:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113109epsmtip2bdc64c13144c3424731d23c2f580c086~MHnrRmIYR2660826608epsmtip2V;
	Thu, 28 Nov 2024 11:31:09 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v11 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Thu, 28 Nov 2024 16:52:37 +0530
Message-Id: <20241128112240.8867-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1DTZRzHe77fL9sXdN13E+WRLprfjhCLsenAB3HhqcXXgpxweOVZ6+v4
	3uAY224/KqurGYcmQfw6MjdKZ5zGxjlaalCM+CmHpYYSApdG3SAPDkw5ocOI9ovyv9fned7v
	5/PjeR4SF43xYslCnZkz6lgtzYsiLnQnJiSRLzMaafdAPLp7/wGBPqhaxFG98wJArpuVPDTV
	fQ+gkY5WDDW6ejE0U3qFQPZjJRjqXZrmoZquIYC8o0+jNm8/gU6cHuejj2608NCZvn8wdHWx
	LwJdtdXzt4mYVttNPnP9soXxOI/ymK8b3me+G7HymLvjowTz8TknYH482cNnZj1xjMc3jSmj
	9hVtLeDYfM4o5nRqfX6hTqOgX8xV7VClpEplSbI0tJkW69hiTkHvzFImPV+o9fdEi99gtRb/
	kpI1mejkZ7ca9RYzJy7Qm8wKmjPkaw1yg8TEFpssOo1Ex5m3yKTSjSl+4etFBZW9I8Awsfat
	+VovYQVnVpeBSBJSctjoGybKQBQpotoA/OTXwXBwD8CBP6fxUDAHoP38Am/Z0jT6YVjlBbBk
	qRwLBbMAdk58GRFQ8agE2PNHKQhsRAcOrnD8ELTgVBUGj1TX8wOqVVQevPZTe9BBUPGw7pTb
	zyQpoBDsO70rlO4JePzafFAeSaVB+9BcUC6ghLD/uI8IMO7XlJy3B2uF1BgJ2yo+xUPmnbDn
	UDsR4lVwsu8cP8SxcHbGG+5HA/+6Po6F2ABLLraDEGfA0kuVeKAenEqE7m+TQ8uPw7pLZ7FQ
	3kdhxQNf2CqALZ8vMw2PNNaHGULvFWuYGTi/eDg803IAvzpq51cBse2hfmwP9WP7P/VJgDtB
	LGcwFWs4dYpBlqTj3vzvotX6Yg8IPvUNyhbgal6UdAGMBF0AkjgdLTCsyNSIBPnswbc5o15l
	tGg5UxdI8Q+8Go9drdb7/4rOrJLJ06Ty1NRUedqmVBkdI5gq/SxfRGlYM1fEcQbOuOzDyMhY
	K3Yse6UkhV0/lpc0Mdjj+62Zqh19TWmpsb30JD/H4d79yve3Vp5idb/EwZjeuLOL2xRfbPc+
	pc5aR+5F3XvtEft3RzgaWnM2TRlhQ0Zyds8umDlbVDqDJLI++Ex6fMVAr+v+ls6cAyuEO9aK
	Oy2Zju0S94wjWhWZEZ3tIz3Tk5cPzSVsptYtNdVMLtTcYBLZxInBshcUTY+lPfLzN84D4MRz
	yeXrtWVZhQvv9N/xKjsuCvfYW7gYL6i5la6v+7vDOvOqrM3a6q6rlHVZFFPpY4XvSQ7uqx7m
	3Vkz7HKIDtcOLe1x2Jvb3s1V5XpAnl1ctb+lU7hxzW15YuftuXrh7zRhKmBlG3Cjif0XKlo4
	MnMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvG59iEe6wbYvNhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZ/UdvMhY8k6z4
	PnkvSwPjctEuRk4OCQETiTW3Oli6GLk4hAR2M0rcuf+EFSIhIXHq5TJGCFtYYuW/5+wQRR8Z
	JSaf28QMkmATUJc48rwVrEhE4ASjxPyJbiBFzAIzmCR6fq1gA0kICwRL7GybwgJiswioSkxd
	tB5oAwcHr4CFxPFlnhAL5CVmXvrODmJzClhKzL72DewIIaCSy4+vg9m8AoISJ2c+ARvDDFTf
	vHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOOC3NHYzb
	V33QO8TIxMF4iFGCg1lJhLeA2z1diDclsbIqtSg/vqg0J7X4EKM0B4uSOK/4i94UIYH0xJLU
	7NTUgtQimCwTB6dUA5OF6vZOac1bjvZz1BRePnr/tYztdv370z5Pdx/N//gz+uH/zVG+0a2P
	J9pW553hXL5NRfwal36Sxq7fd3S2vFJ2flOfon/dQ+/wnykblmnIPjgtq8W7/LBT6V2TNeaO
	D0pKWb2cT+1M9VG7VL3S0P0m/+/GK2ufqtYLFjR3e3J9/an10D3ZSMn3+fwsjsCcEpudn764
	NSlZltzaWnp+mbWAed/JQx5+LyN8mZP1r3666fSpjMu/i+Upt9Drifuq34ezepQvfMT/+NnO
	zJlzDu6R0zO/Jfrb0HPN5jP2Xz84+IZEKc6ZfqVcn23udNOnG4TSXLbGnv73/dyH4C/z/065
	UHPomW1R8pQ40a7rZgxKLMUZiYZazEXFiQCST9uyJwMAAA==
X-CMS-MailID: 20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com>

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
index 40e7be3b0339..e4e3653c27fb 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1017,18 +1017,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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


