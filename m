Return-Path: <io-uring+bounces-5036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F829D7C8A
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98270B22877
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D438F155747;
	Mon, 25 Nov 2024 08:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I0l+aS0/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AED187FF4
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522146; cv=none; b=b776/O5bK3Bb4p4vfBaMPpbTFTAm7cbaL0RJYm57AP1sFn+Z9Dho+rTMQJMkXUY0jbJqntmc0Rg08iB4rHTFixDj2DU7+1ypsm+ISK9A9ucQU/QEPriG/Lo7hR3TywgpvUb+d3TViKJl3EnMdkzR/suUo+xltdAQ8baxSHx1pPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522146; c=relaxed/simple;
	bh=wf16SXbPE7IKcuRRSTK3G6OqCzknXrmBf1Mn0Cr7weM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=i7QYczUo594SPV+CLPWOaCXKxEUikYNTD7JSudDWbWsxoleK3gO8rJv358CiSfsefWRIcjwo7g8IArYOf4Ks6kk6Wu9y9JOBsTU4L83CQ/Jat++GI4AVavvCxW6mpsfDH8nOZhKKcetiFrG4PIagvw7Rg2yTBVTkqCA3lBlQRRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I0l+aS0/; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241125080903epoutp013192446002ca456b8373b33ba8a8ddcd~LJ7XTpUCE1285112851epoutp01E
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:09:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241125080903epoutp013192446002ca456b8373b33ba8a8ddcd~LJ7XTpUCE1285112851epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522143;
	bh=DV5DBIpEJMoashvJk+4uhGWWufd3TPgC6b7DXtx2rfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0l+aS0/4sNUdfdntSSEN/eqWE9k6Zxq2/rFWVJQTCB3D9pNMWjRom90tLyaFULhK
	 Gjq/H76aXcofLWgubfLDGwVu8EVM3cN7HjGvlF3wMrF6VGgUcAuTQhB3PwFn+SI66n
	 9gsQKsA3RVW775xNdrBgJ1QXu5I2VJhdYyUf9Rj4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241125080902epcas5p4974fd53f6f0600871071d337ac22d246~LJ7WgZ6QY1684116841epcas5p4R;
	Mon, 25 Nov 2024 08:09:02 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XxddS48Kqz4x9Q9; Mon, 25 Nov
	2024 08:09:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.C6.19710.C9034476; Mon, 25 Nov 2024 17:09:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241125071510epcas5p47a424c419577f1e5c09375ce39a880c3~LJMUXmqzs1933019330epcas5p46;
	Mon, 25 Nov 2024 07:15:10 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071510epsmtrp2709d00e20d479c3c192298df43eb9d77~LJMUWsvqX0316003160epsmtrp2G;
	Mon, 25 Nov 2024 07:15:10 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-4c-6744309c17b8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	1E.9E.18937.EF324476; Mon, 25 Nov 2024 16:15:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071508epsmtip1759915efa0c70e6cd4a3435cfd11f706~LJMSCDVT50361903619epsmtip1u;
	Mon, 25 Nov 2024 07:15:07 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 09/10] scsi: add support for user-meta interface
Date: Mon, 25 Nov 2024 12:36:32 +0530
Message-Id: <20241125070633.8042-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJsWRmVeSWpSXmKPExsWy7bCmhu4cA5d0g+ZL8hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbTgzdZC86LVrw9/4mxgfGKYBcjJ4eEgInEhp3L
	WboYuTiEBHYzStx8NpMNwvnEKLHo1REWOOfnw+NMXYwcYC1fTztDxHcySrzYcAuq4zOjxKc9
	s1lA5rIJqEsced7KCJIQEdjDKNG78DTYKGaBl4wSS1ctAqsSFnCR+HXjGjuIzSKgKrFl8Qs2
	EJtXwFJi39RdTBAXykvMvPQdrIYTKP627QALRI2gxMmZT8BsZqCa5q2zmUEWSAic4ZDouTWN
	HaLZRWLa8ZdQg4QlXh3fAhWXkvj8bi8bhJ0u8ePyU6iaAonmY/sYIWx7idZT/cwgPzMLaEqs
	36UPEZaVmHpqHRPEXj6J3t9PoFp5JXbMg7GVJNpXzoGyJST2nmuAsj0kni2YzAwJrh5GiU09
	G9gmMCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arJpgWFeajk8npPzczcxghO5lssOxhvz/+kd
	YmTiYDzEKMHBrCTCyyfunC7Em5JYWZValB9fVJqTWnyI0RQY4BOZpUST84G5JK8k3tDE0sDE
	zMzMxNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBiZGHpFazsT3SnlX1AvvnGb49bvN
	Ql/3cpRhp+NK83e+qeeXX9j50stQ6K+35Jp3rZNeTr6gGlSt8+Jo/oRJ9w/N+137h2+yss0E
	rQtKO1RC6hQbmAuPO1pM+NqoJOS2ZsHftU8sXk4NT5/fymb+UWn//oULmh5u0FI+v/6AdlpZ
	9oNT0+xvysT/vrefxTdf4cmliVGPl51bFsrbw9h+xX2TosoHK83XyofiTzhqau996/rctSNf
	Y3HRtmcKx7++21yooPclOqBi1a70iECp7xknPxy+r2HQu8qhd1r7Dc7IV2oVtp6l+2yCY77a
	prht2PLeRrRvt2dhbfTy7Y9+pT9s/+wQ97v6l+RFX9b0jxuVWIozEg21mIuKEwHRvkAzbQQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJTvefsku6wfJl0hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEr4+nBm6wF50Ur3p7/xNjA
	eEWwi5GDQ0LAROLraecuRi4OIYHtjBLH//5m7WLkBIpLSJx6uYwRwhaWWPnvOTtE0UdGiTvH
	m5lBEmwC6hJHnreCFYkInGCUmD/RDaSIGaRowpfZLCAJYQEXiV83rrGD2CwCqhJbFr9gA7F5
	BSwl9k3dxQSxQV5i5qXvYDWcQPG3bQfAeoUELCRmda5khagXlDg58wlYnBmovnnrbOYJjAKz
	kKRmIUktYGRaxSiaWlCcm56bXGCoV5yYW1yal66XnJ+7iREcX1pBOxiXrf+rd4iRiYPxEKME
	B7OSCC+fuHO6EG9KYmVValF+fFFpTmrxIUZpDhYlcV7lnM4UIYH0xJLU7NTUgtQimCwTB6dU
	AxPvprzW2VHrDhx5efZFRIOtgf/OyMXW5+Y9+63++enRVoEcsbSlaowpKioqvcofarsd9Sy7
	ogR23Pery7TlCVw1O2h2TKzdgZvCD3wN2med/PbmSdiFyryzz06Ilqu4/r7TbRMqLfO6+P4W
	y5TzZnU/zfWV92i9drY/Zhz+W/7D4XSf2Ws2Pz4oOM3sa8WtXexneEXE7b3e/ZJcVmPsLf/1
	TdKN1uZ7ezotu9g5Ntff/aTIe928od34X1vb6nytoIU+R/M5lj6cmpwXdiurWEW788hpMeP+
	NQ4H3d9amTJO/6F7q9545TeZN7c9ffzeO9boditlH1UtynFZyD6JaZnnIRZhBtMtRS+/PzJ5
	rcRSnJFoqMVcVJwIACZk9b4eAwAA
X-CMS-MailID: 20241125071510epcas5p47a424c419577f1e5c09375ce39a880c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071510epcas5p47a424c419577f1e5c09375ce39a880c3
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071510epcas5p47a424c419577f1e5c09375ce39a880c3@epcas5p4.samsung.com>

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


