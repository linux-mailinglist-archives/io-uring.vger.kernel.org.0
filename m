Return-Path: <io-uring+bounces-4237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F679B6BD7
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D4C1F22442
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868D51CBEBC;
	Wed, 30 Oct 2024 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DarVl7UE"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F01D0BB5
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311828; cv=none; b=NbnjrVnKDqBwtYYmdnkECAflOryi5KaSz9wkanmaT0bOejdf/nSdbu6fljOsv4b9h0P0fPb1ihkhNMIAQsSX8mtF24TuTca1vSuRyYK3eUeWf/2xF6L/gDvu54WcnvRizeshNcwy3HgmcKtT1ibSaXpW+XJs2gPtOI2u6eNFUWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311828; c=relaxed/simple;
	bh=sQxwKRZlHhNgwu0txpT3fwJ+Hu21CWymOAy7nWG4zDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dbo27K/XgdfMT6Oadu8vDRrI8ktqq7JFFd841bTB7ch3ZSpi6K0m+60TnrvK2rfvAGmRYqNv9AiDGENnP4wSUwv+jMf1eciuoonYdLSk54VMBru1cHohRVtXTdEotGT/cpvMkpJ0poJpNAc1P8ScyJqLDqvynQObMO8EXe1BWKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DarVl7UE; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030181024epoutp0498437e5c984d1bc0d96dc2c431fa1d5b~DTW-bsIHq0272302723epoutp04Z
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030181024epoutp0498437e5c984d1bc0d96dc2c431fa1d5b~DTW-bsIHq0272302723epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311824;
	bh=9c3rZENSKdkXmC+Y3kw02fQnQ6vNnysPx+30NOoEsu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DarVl7UE/diJY5MbNvUNcfEWSuTB5KKnUk1y05KYV+JzUI0mHmqIePshlLyO8IBEf
	 s+MtiQhwJIBD7i7kGekHu5Esfgto/yxW424z+oRVGmw+/XIuVIjLeohl+3am/Pmp4X
	 DIxV2kN3P56bXriYaBlDN5AT95czJ0TwRLqe1gQc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241030181023epcas5p49db274db2b4b25e1ae9120d610e9d65b~DTW_k0gMP1541015410epcas5p4G;
	Wed, 30 Oct 2024 18:10:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XdwCL3wYNz4x9Pq; Wed, 30 Oct
	2024 18:10:22 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	51.76.09770.E8672276; Thu, 31 Oct 2024 03:10:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241030181021epcas5p1c61b7980358f3120014b4f99390d1595~DTW8rfk241837718377epcas5p1W;
	Wed, 30 Oct 2024 18:10:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030181021epsmtrp199e7663d2fadc8cc15bb501dc62f18cb~DTW8qsdqQ0197101971epsmtrp1a;
	Wed, 30 Oct 2024 18:10:21 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-0f-6722768e1a3c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.78.08229.D8672276; Thu, 31 Oct 2024 03:10:21 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181019epsmtip2cb564bdb3fa071b80e23e2d436037294~DTW6XM2mN0238402384epsmtip2s;
	Wed, 30 Oct 2024 18:10:19 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v6 09/10] scsi: add support for user-meta interface
Date: Wed, 30 Oct 2024 23:31:11 +0530
Message-Id: <20241030180112.4635-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmhm5fmVK6wb4bEhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbb9VtYCy6KVkw+d5GlgfGsYBcjJ4eEgInE+7Y1
	TF2MXBxCArsZJTZv7WWFcD4xSjQu3cYC4XxjlJg+dysLTMu1WTMZIRJ7GSUuP5zMDpIQEvjM
	KDFlg2cXIwcHm4CmxIXJpSBhEYGljBIrr0eD1DMLNDBJ9N7tZQapERZwlli+PwWkhkVAVeLS
	1yuMIDavgIXEt7272CF2yUvMvPQdzOYEin/YcZMFokZQ4uTMJ2A2M1BN89bZzCDzJQSucEjs
	et7DBtHsInFn5ypGCFtY4tXxLVBDpSRe9rdB2dkSDx49gHqsRmLH5j5WCNteouHPDVaQO5mB
	flm/Sx9iF59E7+8nTCBhCQFeiY42IYhqRYl7k55CdYpLPJyxBMr2kFiw9w80DLsZJeZ2L2Sc
	wCg/C8kLs5C8MAth2wJG5lWMkqkFxbnpqcWmBUZ5qeXweE3Oz93ECE7UWl47GB8++KB3iJGJ
	g/EQowQHs5IIr2WQYroQb0piZVVqUX58UWlOavEhRlNgGE9klhJNzgfmirySeEMTSwMTMzMz
	E0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpjkjBQK16w+fvK/q9bJP+29mRfsldm4
	Hx/bKZR9yfb1gZuPJj+S087r2uPv5he6TydZTOGpbL6L/Pnu8AtBn+TFtRNmZOmJ8bzO0Hp7
	XD7HW2RSe0+Dp93f8KdXjZNLg1dVhyS8fzC9UaBFIZwt1+DS/7zL6Wf4n4nP7es+XNcq32zO
	c17AvGSGy8frCg/91Da6ffpcfPLk8aCuiBmF+5cXaH/9wdO/5WRSBuuOTdMl9vTerbc3ONPi
	obDosJTHB7ncD281cutbzDpcdEwPRjerfpzh0DRJ9+b7or3MEjuaL0s3BHqrfX2dmKN/ZN5p
	7tPnZ+4q3pNqUZ3t41O5vEHRZJ/g64pJbUvbp3y4pcRSnJFoqMVcVJwIALgxjUNdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXre3TCnd4NtOFYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV8Xb9FtaCi6IVk89dZGlg
	PCvYxcjJISFgInFt1kzGLkYuDiGB3YwSizqOM0MkxCWar/1gh7CFJVb+e84OUfSRUWLNpZVA
	RRwcbAKaEhcml4LERQTWM0qc3TuBBaSBWaCLSeLyBm6QGmEBZ4nl+1NAwiwCqhKXvl5hBLF5
	BSwkvu3dBTVfXmLmpe9gNidQ/MOOm2BjhATMJa4vPMMOUS8ocXLmE6jx8hLNW2czT2AUmIUk
	NQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAo09Lcwbh91Qe9Q4xMHIyH
	GCU4mJVEeC2DFNOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJx
	cEo1MJWEPhBJ1Cvg3/NtPteiyNrqW2EhN27Pe/NPnzvr+5zA77uFaoXX1oh91imTaWJetV35
	x5/k5ac/dm4IkLiTw/DjRarRor23NIo+p14Ik13a91CY9WjZT2Zn69jqLVPFDFaod3cs8722
	7OKpqWKSUold3SaJ76LUlieH5QnubTv62JtHL2T6JtYU/pA/W+Ybx1mrRd9X+qj+4r7ih0LO
	+rhlrM8ucR2tXLpY79+pP5d2zPvz4enT2nXm3LlnW5cIWy8TkP5c8If15bUrc2bFXJs776aM
	53P55o/FIdHsfx9mmqv/uNiy/ObPaVPO/r3EY9Gw8n6Q2ZH+sz+PcS39eDFtg5wP67kDkbOC
	pl04o7xIiaU4I9FQi7moOBEA7niN9SEDAAA=
X-CMS-MailID: 20241030181021epcas5p1c61b7980358f3120014b4f99390d1595
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181021epcas5p1c61b7980358f3120014b4f99390d1595
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181021epcas5p1c61b7980358f3120014b4f99390d1595@epcas5p1.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Add support for sending user-meta buffer. Set tags to be checked
using flags specified by user/block-layer.
With this change, BIP_CTRL_NOCHECK becomes unused. Remove it.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c             |  4 ++--
 include/linux/bio-integrity.h | 17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76ad..d1a2ae0d4c29 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -814,14 +814,14 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 		if (bio_integrity_flagged(bio, BIP_IP_CHECKSUM))
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
 
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
+		if (bio_integrity_flagged(bio, BIP_CHECK_GUARD))
 			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
 
 	if (dif != T10_PI_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
 		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
 
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
+		if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG))
 			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
 	}
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index fe2bfe122db2..0046c744ea53 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -7,13 +7,12 @@
 enum bip_flags {
 	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
-	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
-	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
-	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
-	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
-	BIP_CHECK_GUARD		= 1 << 6, /* guard check */
-	BIP_CHECK_REFTAG	= 1 << 7, /* reftag check */
-	BIP_CHECK_APPTAG	= 1 << 8, /* apptag check */
+	BIP_DISK_NOCHECK	= 1 << 2, /* disable disk integrity checking */
+	BIP_IP_CHECKSUM		= 1 << 3, /* IP checksum */
+	BIP_COPY_USER		= 1 << 4, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 5, /* guard check */
+	BIP_CHECK_REFTAG	= 1 << 6, /* reftag check */
+	BIP_CHECK_APPTAG	= 1 << 7, /* apptag check */
 };
 
 struct bio_integrity_payload {
@@ -34,8 +33,8 @@ struct bio_integrity_payload {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
-			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
+			 BIP_IP_CHECKSUM | BIP_CHECK_GUARD | \
+			 BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


