Return-Path: <io-uring+bounces-2912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B2295CADD
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DD0C2861BC
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0002187550;
	Fri, 23 Aug 2024 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Z5A7YMYA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05583185B79
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410121; cv=none; b=YoK3ktQ8HLJ7qWHGygeg0yteIX5ufkogFm9aqCuD2ZR93WwyebZSwR++U5V1W+Z72eV5CmoUI1O2IEF4FnVZOkCKqRBVLR1U2vAA36ezeXyocUP0Ybk8EhMg/6Qj4dPOrY4pZWIxKrPk1EeMyO3MoBxz46EeovU2YJEEP9dsjkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410121; c=relaxed/simple;
	bh=kmTSdUT+bP9tsddpB6eT+RYHgy7lddAPgpddvcZdAGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=R0D4au+xQa2VFpNXZW3Kzm+jwAixu96fT4nlo2Q1iho0UXOyvYADJ7nWa3sWTiQk7PXA6dwRGKcQh2tM64UwcVeQNq1aY/fbbN8VSVqff2up/ax0IyVP7KGxSXE+B5dcx4Go7C9A/RwQNApZEvn745W4hy0GcSiGtKmVluViMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Z5A7YMYA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240823104838epoutp03d8ea870e7c1178618bfa68b6547e9746~uVd21wqQF0936009360epoutp03a
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240823104838epoutp03d8ea870e7c1178618bfa68b6547e9746~uVd21wqQF0936009360epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410118;
	bh=fdfNA1BhNobCcdbbPzAPNJ/9rXGRREf8RhQ25IpYD8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5A7YMYA1WHguz4yOYEyKFvUbyrL/C5H8eNzgc4a6EWEzfQuFwq+vtG7Zj5R3su4k
	 MSh+KvefjCtvVddgxfjmn8KNCxWOSN7pn+BlS3lO80wYHbbe96AS9AFd9x875Sygke
	 /CSfrBV1B+UaVZUWo99Dqt1Yy7nrPYTESaL7GNiI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240823104837epcas5p32d9a9dc8cf2f2fea7aa784e76cfd6acf~uVd2BnkgP1753117531epcas5p3a;
	Fri, 23 Aug 2024 10:48:37 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Wqxcz21YFz4x9Pv; Fri, 23 Aug
	2024 10:48:35 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	16.9F.09743.20968C66; Fri, 23 Aug 2024 19:48:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240823104631epcas5p4f83b92081107fbefca78008ee319ff7e~uVcBWaqVh3268132681epcas5p4Z;
	Fri, 23 Aug 2024 10:46:31 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240823104631epsmtrp2e2734043b18a050e4c040ee8a12f55a1~uVcBUNJg30122301223epsmtrp2R;
	Fri, 23 Aug 2024 10:46:31 +0000 (GMT)
X-AuditID: b6c32a4a-14fff7000000260f-a1-66c869022573
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F3.6F.07567.78868C66; Fri, 23 Aug 2024 19:46:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104629epsmtip264a7069bed3357c5f3d97851eba59f08~uVb-Ui5Gi1453814538epsmtip2B;
	Fri, 23 Aug 2024 10:46:29 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 07/10] block,nvme: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Date: Fri, 23 Aug 2024 16:08:08 +0530
Message-Id: <20240823103811.2421-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmli5T5ok0g5m9OhZNE/4yW8xZtY3R
	YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi+5mlzBZ7b2lbzF/2lN2i+/oONovl
	x/8xOfB67Jx1l93j8tlSj02rOtk8Ni+p99h9s4HN4+PTWywefVtWMXpsPl3t8XmTXABnVLZN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDRSgpliTml
	QKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjHUT
	d7IVNElUnJ4i1MB4X7iLkYNDQsBEYtcH6y5GTg4hgd2MEqvmunQxcgHZnxgl9t7ZyQLhfGOU
	eDPpNzNIFUjDvLMb2CA69jJKrO3RgCj6zCgx5d4lJpAEm4C6xJHnrYwgtohApcTzXT/AJjEL
	3GSUOLT3GdgkYYFIidfLWlhBbBYBVYk9WzrYQWxeAQuJpy2rWSC2yUvMvPQdLM4pYCnRNLuB
	BaJGUOLkzCdgNjNQTfPW2VDXreSQWL2UCcJ2kbjQ+pIVwhaWeHV8CzuELSXx+d1eNgg7XeLH
	5adQ9QUSzcf2MULY9hKtp/qZQUHELKApsX6XPkRYVmLqqXVMEGv5JHp/P4Fq5ZXYMQ/GVpJo
	XzkHypaQ2HuuAcr2kFjTuAoaoj2MEp92n2ObwKgwC8k7s5C8Mwth9QJG5lWMkqkFxbnpqcWm
	BUZ5qeXwKE7Oz93ECE7FWl47GB8++KB3iJGJg/EQowQHs5IIb9K9o2lCvCmJlVWpRfnxRaU5
	qcWHGE2B4T2RWUo0OR+YDfJK4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj
	4uCUamASW/DnkNyxruUTb7jPnNGbdkXZRWhbxB5Zxwjf+a8eeb3Q443Uu8eXemeF9Z0Fcy40
	lFVwF27t69y7XKehKYaxp+PsbdYanR9H3b5ctFDfLbK0uIPd/Y3ghV6DFVMefNvLfqFfSYLr
	jNP513lG/uxbJDKi5VL7hHfFR60IfyBg8byN9dkpu58Ce7QfaUf0VKjnGgsEp0obXU/dvD97
	1vEQrayEGZfUYy1errptt+V+z0/uWZfj3lxw6Dp89nmQzo3WmD0b5k4Qlv+z+sFV58BzEisn
	rXtgvNB41trS564rTyaEleq+TC5kK51canJsMl93i/mXbslX/hoR9Y4/HA+6GIQV6YvN7ojn
	a9mxZa4SS3FGoqEWc1FxIgCKqavxTgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSvG57xok0g1vv9CyaJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jcuD12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6MdRN3shU0SVScniLUwHhfuIuRk0NCwERi3tkNbCC2kMBuRolH69Mg4hIS
	p14uY4SwhSVW/nvO3sXIBVTzkVHi8tLDYAk2AXWJI89bGUESIgKNjBJbmr+wgCSYBe4zSizo
	DgGxhQXCJQ7MngLWwCKgKrFnSwc7iM0rYCHxtGU1C8QGeYmZl76DxTkFLCWaZjewQFxkIbFs
	+RlGiHpBiZMzn0DNl5do3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfm
	pesl5+duYgRHjJbGDsZ78//pHWJk4mA8xCjBwawkwpt072iaEG9KYmVValF+fFFpTmrxIUZp
	DhYlcV7DGbNThATSE0tSs1NTC1KLYLJMHJxSDUy+ers2GR8W+tbO6X7f+b3D790tZYZrVqc8
	P1i6psx+8c5N79dPMaxr189c5Dt/cUupxYJH6z7MnK9ndmzfhg3uCl3HwrinTTreyZTeGnKr
	de8Sl03FAf3xEovmNdw6+tbDmpmjL+2Fy7s0oeYU1fP2Kjsu2y49lmlzcYlv62blKdKry/iO
	XZzOVrI+7PHfVM+fJyffZi4IeXX4xJkrCfE8206nVv/oEwk486fneZydqKgQL8sDo+XfWrJy
	apy0/q3pqHwUqKv73Z6785A7G3vDSbWdWoxv5my5/ML08Jau1pNa75SaxTuaI8U9I3839fMa
	Md1qrSzYtmjvrhuz5gmdvlYY+Ij/RCyP8exdG52UWIozEg21mIuKEwHX/atpBwMAAA==
X-CMS-MailID: 20240823104631epcas5p4f83b92081107fbefca78008ee319ff7e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104631epcas5p4f83b92081107fbefca78008ee319ff7e
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104631epcas5p4f83b92081107fbefca78008ee319ff7e@epcas5p4.samsung.com>

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the integrity payload. The
driver can now just rely on block layer flags, and doesn't need to
know the integrity source. Submitter of PI decides which tags to check.
This would also give us a unified interface for user and kernel
generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 12 +++---------
 include/linux/bio-integrity.h |  6 +++++-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index aaf67eb427ab..7fbf8c307a36 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -444,6 +444,11 @@ bool bio_integrity_prep(struct bio *bio)
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
index 33fa01c599ad..d4c366df8f12 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1002,19 +1002,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 				return BLK_STS_NOTSUPP;
 			control |= NVME_RW_PRINFO_PRACT;
 		}
-
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
index a1a9031a5985..c7c0121689e1 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -11,6 +11,9 @@ enum bip_flags {
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 6,
+	BIP_CHECK_REFTAG	= 1 << 7,
+	BIP_CHECK_APPTAG	= 1 << 8,
 };
 
 struct bio_integrity_payload {
@@ -40,7 +43,8 @@ struct uio_meta {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


