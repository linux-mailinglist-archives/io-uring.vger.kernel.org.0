Return-Path: <io-uring+bounces-4498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0233E9BF056
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 261191C20A11
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A116D203707;
	Wed,  6 Nov 2024 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bjg7bWLQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F1202F84
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903381; cv=none; b=j1qbAZCfVScmLR0+ySzyiz3IvL5X4xslDklxihTWwUmalGBQuQXd0861wclAzSgS/28Jq4mmf3aZ9YM0dL+5k2PWlidcPUYqDOwXNxBjVsmsCIE437mLaZ7Kqy4I270AGMIvccVfGPfFEwDPorSz+h2pHtDTuVES74Byb4XwSGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903381; c=relaxed/simple;
	bh=jraNWLaKHsTQe0pu2Jm0KWwiaQvYjmTAMdus/DUn6fU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hasN1QxelFDkQT9+hbXcj5H2fsVMrzexNKwnLEGlepovRTP4n44/3ZFMGmkslbUdMptRixFADGevlN3rrJFq6e4c+8eHBimOEqa5WTa04WPhtX7MUVk3dZBTTyr016rG5PJXOHJ8YsZ8ryWRyK9F+WUDbF9gd6qOefj1Wsy5qb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bjg7bWLQ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241106142938epoutp03038bf9d6743473d519703860ae930382~FZ3Ob3wyA2018720187epoutp03Q
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241106142938epoutp03038bf9d6743473d519703860ae930382~FZ3Ob3wyA2018720187epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903378;
	bh=og22ywRlDp0pEXMrdTg3MkhTF5pEsbsojrZbbFE+yGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjg7bWLQ9a8OQt8nVelvpapavWPRC9Nr9sBd2OB6kN+TwpcMOG+XutOdb8a2lLoX1
	 lLLbIm+lq61Tzfv6fJLJ1+GWqkhvcqSuXcp2lY5ZMiCjpUTurGhh6M1jWuo5eb3wKV
	 nRF9YPALQqhepUtBDTHQqTsiNR0CgDOfaLhdJE5c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241106142937epcas5p3f7494817e484f48662c295bde7629a55~FZ3N-l8zu2414124141epcas5p3i;
	Wed,  6 Nov 2024 14:29:37 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xk6zM5nhXz4x9Pv; Wed,  6 Nov
	2024 14:29:35 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.3F.09420.F4D7B276; Wed,  6 Nov 2024 23:29:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122718epcas5p184094be8de895aa606170da9f4204ae0~FYMbDZH0R0260102601epcas5p1l;
	Wed,  6 Nov 2024 12:27:18 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241106122718epsmtrp1397a6b6955997363c5489e49ce41e211~FYMbCWeiW2054020540epsmtrp1P;
	Wed,  6 Nov 2024 12:27:18 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-73-672b7d4f01bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	3D.75.18937.6A06B276; Wed,  6 Nov 2024 21:27:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122716epsmtip12c34a08a7c5a7b109f9440d887ed60b1~FYMYpssUO0886208862epsmtip1E;
	Wed,  6 Nov 2024 12:27:15 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v8 09/10] scsi: add support for user-meta interface
Date: Wed,  6 Nov 2024 17:48:41 +0530
Message-Id: <20241106121842.5004-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmuq5/rXa6Qcc6LYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQP0jpJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWn
	wKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2Pqtx72gvOiFQ2ve9kbGK8IdjFyckgImEh86m9n
	6mLk4hAS2M0osXh5FzOE84lR4sH/fexwDjCUWGBaphz/BdWyk1Hiw4/TLBDOZ0aJFc+7mECq
	2ATUJY48b2UESYgI7GGU6F0IUcUs8JJRYumqRUAOB4ewgLPEjleVIA0sAqoSfz6tYgOxeQUs
	JZo/TGaDWCcvMfPSd3YQmxMofvbzNkaIGkGJkzOfgJ3EDFTTvHU2M0T9BQ6Jz4+lIWwXiaPb
	IQ6SEBCWeHV8CzuELSXxsr8Nyk6X+HH5KVRNgUTzsX2MELa9ROupfmaQM5kFNCXW79KHCMtK
	TD21jgliLZ9E7+8nUK28EjvmwdhKEu0r50DZEhJ7zzVA2R4S8xs+QMO3h1Fi2e1etgmMCrOQ
	vDMLyTuzEFYvYGRexSiZWlCcm55abFpgmJdaDo/m5PzcTYzgNK7luYPx7oMPeocYmTgYDzFK
	cDArifD6R2mnC/GmJFZWpRblxxeV5qQWH2I0BYb3RGYp0eR8YCbJK4k3NLE0MDEzMzOxNDYz
	VBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBqWynckLL1s/+p6O/y09M99tQu7P29rz+Jbuj
	BK7s1It1/pe+gUN+xu324E7ZT8tzIjcuvap194/w6o38aSYzJfrN+jpVJ6mpMcmI8Db0r/xf
	/Zjzvprdv137b956FSezUSdj+saovS8TpX4YfRW9XPYj2Mgub5+UHJOZYUPr1Ldul27YGC3z
	rYyIfLC4oHu+3sZja24GTrA+zjBtzY3XMberl543XH4m7MHXjxzO9V6Sac9r3ObcZNxzbmdB
	9DI5Kxulqm3X7CvPnnvzIs7killhzDrZLa9EiqV7oqJOfZwwe4Wow/TNepwGc5PLFFSPmLPO
	ea3XJ6CgNGdGpumuFAXFHxHnVuUdCWmRc970WImlOCPRUIu5qDgRAIS4g95sBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJTndZgna6wc4eOYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CVMfVbD3vBedGKhte97A2M
	VwS7GDk5JARMJKYc/8XUxcjFISSwnVFi47SVTBAJCYlTL5cxQtjCEiv/PWcHsYUEPjJKrPkh
	DGKzCahLHHneClYjInCCUWL+RDeQQcwgNRO+zGbpYuTgEBZwltjxqhKkhkVAVeLPp1VsIDav
	gKVE84fJbBDz5SVmXvoONp8TKH728zZGiF0WEn8W9DFD1AtKnJz5hAXEZgaqb946m3kCo8As
	JKlZSFILGJlWMYqmFhTnpucmFxjqFSfmFpfmpesl5+duYgRHl1bQDsZl6//qHWJk4mA8xCjB
	wawkwusfpZ0uxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUIJsvEwSnV
	wLQj5GEOS/ErmUg17ldLZR7O0r64/0vppjSvc3M7LBe94q/IYnrsw9zw7d9F7jO8Z9QN/3F6
	3Xx376rL90qvo0KfRRQSPIxOBsTInxHSaBPYG7R436moSQkJqU4b5vQ2Ci464hWuwP9BNdqj
	4N0yP7uOrUsaXGw38Lt99c3e4Pltu/ahsOwjJ9LXu909toPx1uTjbevfP9xvI/bodlDgqeWX
	/trejwt6ffvKpDs7l0dxyisdiji13DTM6PFNn8tnE57GK8l+fba+bsLcA9csYqwTX695oXLq
	cBLDo/Pfz7XdmTD1ofsrkXkLub6uajp26NPLukKWyadmPX1lHlWUXVNZcOzEmSX3nKfZzbm1
	2jJbQYmlOCPRUIu5qDgRADIYf8EdAwAA
X-CMS-MailID: 20241106122718epcas5p184094be8de895aa606170da9f4204ae0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122718epcas5p184094be8de895aa606170da9f4204ae0
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122718epcas5p184094be8de895aa606170da9f4204ae0@epcas5p1.samsung.com>

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


