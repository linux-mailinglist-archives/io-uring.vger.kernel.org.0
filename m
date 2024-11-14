Return-Path: <io-uring+bounces-4690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D629C88C1
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD0F284244
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56BB1F8EEA;
	Thu, 14 Nov 2024 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Mraw92l0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139FB1F9A9F
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583228; cv=none; b=Ut+Q/KzmKK65VAR2v88NyJ0H8PMbVArqPzsui4egzApM43IKCaqlaWyLFn9oUVu6i92+D2/nzOXfhhnciSrnjdXFhT/S0AzdUwkbsRy5ST+qsdl81QK7tRwrdsvFBimesSnRbXxYFHKWLYbXkp7Im8tHydKc1q3XrGpsyk8kS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583228; c=relaxed/simple;
	bh=wf16SXbPE7IKcuRRSTK3G6OqCzknXrmBf1Mn0Cr7weM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tedTUotNKaVF0mrE7ibSyfL0iW0nQwuGS3/0Ue64saIsWavNgVm99lmU3ndA8A8+Kl3hADgO4tT4Ie5ajfbcwPiRXk0A7W7h/ltP50d3/IiSiW+TQayQDae/wZEjpfA0mQllCoKvZbT0VA+ZNF8hUm+47eznqQPsWlUlJP/Jiao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Mraw92l0; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114112025epoutp0153166c29c21bc38684e844a1cd35bd3c~H0cTj7qGS2499424994epoutp01E
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114112025epoutp0153166c29c21bc38684e844a1cd35bd3c~H0cTj7qGS2499424994epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583225;
	bh=DV5DBIpEJMoashvJk+4uhGWWufd3TPgC6b7DXtx2rfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mraw92l0VTxVNPIgrxdp4KDv/btGJpKItYoy2wNip5+pDtJyfjELuqn9c4/CsrY3z
	 8r4z48j0YgLp+W1h4N/tZHzMPQfe3ruTZf4HQwmq4efDV0uHPLO7oXJKe4/McMGyFX
	 qRviu6s0/LALVMSmFuFGFvnUxbQ22k6qEvKw0wN0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241114112024epcas5p48d9c06b1bc34a8bbfb319ae30a8394c3~H0cTD0v7c0985309853epcas5p4Z;
	Thu, 14 Nov 2024 11:20:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XpyPL2Ttjz4x9Q2; Thu, 14 Nov
	2024 11:20:22 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DB.4F.37975.36CD5376; Thu, 14 Nov 2024 20:17:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241114105416epcas5p3a7aa552775cfe50f60ef89f7d982ea12~H0FeHIZif2916029160epcas5p3E;
	Thu, 14 Nov 2024 10:54:16 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105416epsmtrp1ba676ae188c5ea171608ff0bdbbdb333~H0FeGSpZv1676716767epsmtrp1d;
	Thu, 14 Nov 2024 10:54:16 +0000 (GMT)
X-AuditID: b6c32a50-085ff70000049457-e5-6735dc632dbb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.B3.08227.7D6D5376; Thu, 14 Nov 2024 19:54:15 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105413epsmtip2b05a4c14310035d341e7ef6031e99ca4~H0Fbx4AkK1420714207epsmtip2W;
	Thu, 14 Nov 2024 10:54:13 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 10/11] scsi: add support for user-meta interface
Date: Thu, 14 Nov 2024 16:15:16 +0530
Message-Id: <20241114104517.51726-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmlu6XO6bpBru3cVh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygd5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
	BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlPD95kLTgvWvH2/CfGBsYrgl2MnBwSAiYSpy6d
	Yuti5OIQEtjDKHFv/j1GCOcTo8SZ7cugMt8YJY4uPM0K03Jh6nd2iMReRokXU58yQzifGSWO
	tU5nBqliE1CXOPK8FWyWCMjg3oWnWUAcZoGXjBJLVy1iAakSFnCWWLqkGayDRUBVYt7S72A7
	eAWsJG5vOcIGsU9eYuYlkH2cHJxA8RUNW5khagQlTs58AjaHGaimeetssDMkBM5wSPSc2QLU
	wAHkuEhcm8IFMUdY4tXxLewQtpTEy/42KDtd4sflp0wQdoFE87F9jBC2vUTrqX5mkDHMApoS
	63fpQ4RlJaaeWscEsZZPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPids9i6BB18so8fZt
	B+MERoVZSN6ZheSdWQirFzAyr2KUSi0ozk1PTTYtMNTNSy2HR3Ryfu4mRnAq1wrYwbh6w1+9
	Q4xMHIyHGCU4mJVEeE85G6cL8aYkVlalFuXHF5XmpBYfYjQFBvhEZinR5HxgNskriTc0sTQw
	MTMzM7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoEpxkrNKpwjNu/YjdJcmReSD+b5
	pq1euaNFc077784rQmv2cfoU1cwS4qrtU+5SS7jloKD40+vBIYWnjPzv8yOepbDPmNx2eMqU
	xEfRT5nWno6ZVx4/Xz1oX1US35Wi2S83a0oHn2/J2Jp/b8GtK7HzpEXO/GP4mJjq1qB979qM
	fYe3Cp417xHVzUl+JLRBPP9y27TWb5PFe5pMqy2aTwXtfG/dHfH3nsTUyohY0/r/k8Q+8RuE
	5f893T3L8PfMhw0vt7819tTl/lr7bOeabV0JohEhlyuWn32/X8/1n650kvNLpYdSWQY6c+cd
	4I6Rmjj5aPIdBpsjXEqlM6+K91x9eUJT6/CljDMbtWV+SPorsRRnJBpqMRcVJwIAEnqjyW4E
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXvf6NdN0g5WHrCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxtODN1kLzotWvD3/ibGB
	8YpgFyMnh4SAicSFqd/ZQWwhgd2MEq392RBxCYlTL5cxQtjCEiv/PQeq4QKq+cgosffzI2aQ
	BJuAusSR561gRSICJxgl5k90AyliBima8GU2C0hCWMBZYumSZrAGFgFViXlLv7OC2LwCVhK3
	txxhg9ggLzHzEsQVnEDxFQ1bgeo5gLZZSnxfLwJRLihxcuYTsJHMQOXNW2czT2AUmIUkNQtJ
	agEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAo09Lawbhn1Qe9Q4xMHIyHGCU4
	mJVEeE85G6cL8aYkVlalFuXHF5XmpBYfYpTmYFES5/32ujdFSCA9sSQ1OzW1ILUIJsvEwSnV
	wNQULBquKmor8Pb5gYClllbxdydMveB9bMF9YVv3ot7Zp9eaNBlGz12+XPWmpdKkCuaU7S2l
	Wx9OO6N+L1RZ7IJ5zUpLPrXeoH8pOwVqPrTNejclsf1i6XF9k9ffrlfrKCzOXpMkx+69WHHr
	zwWbTd7V2vFwp21d2Hw3Svye8pt3FjOcnK5/PGqtpHp5QZDF450l8vPYJRxi9tZHbJi2+P51
	8//Gaf6bfb+dzZof7ZFZ2Wq44KFUZjj3BYGipgqP31GfDXsZlr6Y53VrqshM/abOZO2/Xvc7
	xObfbdkfvHVPziy32jXlSSv9/DRDI8pv5Mn+fKj6+fIFm4Wr17q8t6yU/yyfL/Fxon3Lm4mV
	U5RYijMSDbWYi4oTAT5DThchAwAA
X-CMS-MailID: 20241114105416epcas5p3a7aa552775cfe50f60ef89f7d982ea12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105416epcas5p3a7aa552775cfe50f60ef89f7d982ea12
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105416epcas5p3a7aa552775cfe50f60ef89f7d982ea12@epcas5p3.samsung.com>

Add support for sending user-meta buffer. Set tags to be checked
using flags specified by user/block-layer.
With this change, BIP_CTRL_NOCHECK becomes unused. Remove it.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c             |  4 ++--
 include/linux/bio-integrity.h | 16 +++++++---------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8947dab132d7..cb7ac8736b91 100644
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
index fe2bfe122db2..2195bc06dcde 100644
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
@@ -33,8 +32,7 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
-#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_IP_CHECKSUM | \
 			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-- 
2.25.1


