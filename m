Return-Path: <io-uring+bounces-4496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BA99BF04D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBD93B2243A
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6214B202F94;
	Wed,  6 Nov 2024 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SE1x7xjJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88170204F99
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903367; cv=none; b=TmPsKLFlw3x1GhgyGLcIwxsRq2mkIGoYZ9wY+uPLNu7qaywG9hlCa1NUbhQybCjqwKsL4rRL5X4/xTNlrBGn197uxAApmIujGiwuvcnqCUPlkXvp4eqO/c4l781UgKRBcVHI6N+KHKKMp50t/wCK2VfV96BoKIipWs1Q+v1xIHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903367; c=relaxed/simple;
	bh=qGAzfkEOHOpm8kpRVtxmLwS1O3CyRbF7YVklUKFKOj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Vxpxz/dt1IyX0urLEtEdy3EJLzIf6pmeMYyh2ksADlOAv5kcj9FLL1zjnq7OkYr8vUdaojFc6itn70Iq4pgDmbCMEroWYV8qFjA5ixPQFuHX+tquLWDNHxmrx2JPrK851V2oSkrqOzoc25NDg9uVtK5Qse0iV35+2AMekt4SnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SE1x7xjJ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241106142923epoutp03e08ee6a6877da32bbc68734383047170~FZ3BQPtmS2080220802epoutp033
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241106142923epoutp03e08ee6a6877da32bbc68734383047170~FZ3BQPtmS2080220802epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903363;
	bh=OTz/QgjwERHOOBHdZDM2jYUNAR5ftRU78+qZ7ID4M2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SE1x7xjJ0zkZL2Jt/W9SPh4YR7lrGbNbJMeYJ9Z+9fUz+UU5DjTsU55ntdCsSp9YT
	 PW0/6HKLj73My995FbuuHZaFiQbFF3IekX6OGzhH8iavc3OopjvEh4VBEOgvz9fB0o
	 pW8uQiBjLj+HTrKagituiW6Eg3geT0IlAdPPAFyI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241106142923epcas5p3d41245122c5a779a11d78178e7a4c5ab~FZ3AuoV5m2414024140epcas5p3h;
	Wed,  6 Nov 2024 14:29:23 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xk6z53w6Yz4x9Pp; Wed,  6 Nov
	2024 14:29:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	72.FC.08574.14D7B276; Wed,  6 Nov 2024 23:29:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241106122713epcas5p433c4b14f82da79176c3e8bf6835054fe~FYMWAHqgo0572105721epcas5p4o;
	Wed,  6 Nov 2024 12:27:13 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241106122713epsmtrp1e1718f0909b7b5f8621d106e3b081bb1~FYMV-JcQv2054020540epsmtrp1G;
	Wed,  6 Nov 2024 12:27:13 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-dd-672b7d4124c8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.26.07371.0A06B276; Wed,  6 Nov 2024 21:27:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122710epsmtip1cd212eea3ee9400a5707d69507477895~FYMTZzBpc0844908449epsmtip1e;
	Wed,  6 Nov 2024 12:27:10 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v8 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Wed,  6 Nov 2024 17:48:39 +0530
Message-Id: <20241106121842.5004-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHOfde7+7CrN0WmA6UCNecBATZWNZDio+BYe6kM9Ho1Ix/SHd2
	rwvDPm77qMgYKFqY8MGjURLXQCJ2XGZEQF4BashDKHCCEiHQSmAl2uKhbUZAu+xS/vf5/c73
	e36/33kIcckEGSxM1xo5vZZV06Qv0XQzfFvU/qxIVUxdJUTzj5cI9FHRMo4stiaAaiYKSTR7
	cwGg0RutGLpU042h382DBDpfmouh7lUHiUo67wDUMRaJ2jv6CFRePSVAJ0ZaSGTtXcHQ7eXe
	Deh2mUWwT8K0lk0ImOEBE1Nv+4RkGqqymbbRHJKZnxojmNNXbYD5tqJLwCzWhzD1kw4sxfdI
	xu40jlVy+lBOq9Ap07WqBPrAodTE1Dh5jDRKGo920qFaVsMl0EkHU6KS09WumejQd1i1yZVK
	YQ0Gesee3XqdyciFpukMxgSa45VqXsZHG1iNwaRVRWs54yvSmJiX41zCtzLSii0/kfx00HtV
	zlksB1gDC4BICCkZvNbdu6EA+AolVBuAuasWzBMsADgyfAZzqyTUnwAuT2SsOx4uOEiPqAPA
	3/ruAE+wCKB1rnvNQVIvwS67eW0hgGoH8NTFbwh3gFNFGMwvtggKgFDoTx2GFrPCbSCorXD1
	+xnSnRZTCDqd3v42w3NDToGbRVQ8HFhsAm4WU8/CvnOThJtxlya38Tzu3h5S40JoHbATHnMS
	zBt6IvCwP/y196qXg+FMYZ6XVfCv4SnMwzzM7bkGPLwXmvsLcXc/OBUOa7/a4Ulvgmf6L2Oe
	uhvhqaVJr1UMWz5fZxrmX7J4GcKOwRwvM/Csc4rwHNZJAJvmB/AiEFr21DxlT81T9n/pCoDb
	QBDHGzQqThHHS7Xcu//dskKnqQdr7zwiqQXcLV+J7gSYEHQCKMTpAPFrRyJVErGSzXyf0+tS
	9SY1Z+gEca7zLsaDAxU610fRGlOlsvgYmVwul8XHyqX0c+JZ8wWlhFKxRi6D43hOv+7DhKLg
	HCyvOj3rHx+kXJqusnYRx8xVn1Ykgq6j1tSRFzOrH2e119ET7Vt9tt1qrNwf/pARJc+dvJJc
	+QJuc4h+aDxu1/bEG5j5iudReElznd/ekITPAounNXW2/LYvbnV/OJc9HKk+eK/ZFPZL6Uqi
	j+neyLjsy1d7NoZl8/oLRXOO037yQ/aU+z/mXrfacLt9VL75WGvE4eND2x0NhT7jysrVkp3E
	WNXfAeUPMht2KW7U9jYHzfy85WjpSqMPv6lG79/f9+bHd9/o+bqWvfzd283BD+7v8rf77jkR
	vsK2+z0J2V54AJxFjzSahLDGnMG4DzpssXxS5x/PRJpF84+uvM5e943t3+ekCUMaK43A9Qb2
	X93kuUxwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSnO7CBO10g/s8Fh+//maxaJrwl9li
	zqptjBar7/azWbw+/InR4uaBnUwWK1cfZbJ413qOxWL29GYmi6P/37JZTDp0jdFi7y1tiz17
	T7JYzF/2lN2i+/oONovlx/8xWZz/e5zV4vysOewOQh47Z91l97h8ttRj06pONo/NS+o9dt9s
	YPP4+PQWi0ffllWMHmcWHGH3+LxJzmPTk7dMAVxRXDYpqTmZZalF+nYJXBkT5zxgK3gmWbHk
	+2umBsblol2MnBwSAiYSLz69Zeti5OIQEtjNKLF7zw5WiISExKmXyxghbGGJlf+es0MUfWSU
	mPtsP1gRm4C6xJHnrWBFIgInGCXmT3QDKWIWmMEk0fNrBRtIQlggSOLngvtgNouAqsT/Ky+B
	bA4OXgELie/foa6Ql5h56Ts7iM0pYClx9vM2sJlCQCV/FvQxg9i8AoISJ2c+YQGxmYHqm7fO
	Zp7AKDALSWoWktQCRqZVjJKpBcW56bnJhgWGeanlesWJucWleel6yfm5mxjB8aalsYPx3vx/
	eocYmTgYDzFKcDArifD6R2mnC/GmJFZWpRblxxeV5qQWH2KU5mBREuc1nDE7RUggPbEkNTs1
	tSC1CCbLxMEp1cCUeUpXzazW96mt0+tZ24ozH2dws7SYuJZd+/V9/w1embcCjZqG+6f03l80
	4YPAFW2brsueWWpaNu81tjw/pG3T78pdwWDXX5XzyvTy3akaUipVpXLzlZvYN6x8YWngdMxq
	7o2b8xO8z04NC/O4NM3HQr6caX5V3tru4OkzG4+XO5z0vX308F/RtNW3OCdsNj+huELx3/Yr
	3KXveJ1jj162cPHyvMnOK6ql8lA7M+n7j63hap0CJTvPV7r8EjE3CO2uTHlQpXr9osa9XTwS
	LIdcHJi+rlt8QKLhSVj2350buC5/d9SfISu6d9/T5TqnP/IZPOpjLRcr6f17a5GQzcrOt/OC
	k9hUjATlqwouGiuxFGckGmoxFxUnAgB1i4kFJgMAAA==
X-CMS-MailID: 20241106122713epcas5p433c4b14f82da79176c3e8bf6835054fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122713epcas5p433c4b14f82da79176c3e8bf6835054fe
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122713epcas5p433c4b14f82da79176c3e8bf6835054fe@epcas5p4.samsung.com>

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
index b5b5d5dd6b51..f1d1b243d8bc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1015,18 +1015,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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


