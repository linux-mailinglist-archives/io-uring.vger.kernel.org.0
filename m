Return-Path: <io-uring+bounces-5122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB299DB6D7
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB9DAB21D12
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C1F19D890;
	Thu, 28 Nov 2024 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cTuRySV7"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FAD19D880
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794390; cv=none; b=Ep/7Pq5U+F5ffjDs/+WX8xis4xv0+uMiG9uZQxurwHporRGlSom7TS96Sg9Ta/H1PGWUVToyWmvo6ig75YZU9jXj/I2b25IMVSMn9wQCp7yXGW7Srsxf1XfXWfqDmAo+KG52XsA53DXCU16y6RpP7JYT98oFnAN4Div31GeLbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794390; c=relaxed/simple;
	bh=wf16SXbPE7IKcuRRSTK3G6OqCzknXrmBf1Mn0Cr7weM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=d5LL8lDICANQS0KnV8TpY11CYh9IPkgeA+H10/E5PfdDPPAGnK32oK08HugGdPihyyPHdkw2fAm35irobiitDBjnnSweQHyEr/VZjWKFldJ5Eumuj+FqRB/cA4MpeQxHuHyl1PnyvWXJC6lfpWE1CEauEGjPZz4wL6TH+mc31vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cTuRySV7; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241128114627epoutp04e17a50b4f9095572f30a80d8df612763~MH1B8Fpib1118511185epoutp04-
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241128114627epoutp04e17a50b4f9095572f30a80d8df612763~MH1B8Fpib1118511185epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794387;
	bh=DV5DBIpEJMoashvJk+4uhGWWufd3TPgC6b7DXtx2rfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTuRySV7DlvhvJbVsB0nUI0Jc49zWMChkx1O2QVNG8iicrx8xvH6qFcWH2Kl5l1vi
	 IjJjNHXlmuwyfNIO6+tpbyjhEsdp2wTy9imzuyG/tIogt+GYKZtogukrdH1dD28GI3
	 VabQuy12fi5pfGKRzTOfe77r7UQJuDvSH7eS9NXw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241128114626epcas5p1c79a7d04daa6cf1c04dbe201992990a5~MH1BhLDsc0896108961epcas5p1H;
	Thu, 28 Nov 2024 11:46:26 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XzZJx3KsGz4x9Pt; Thu, 28 Nov
	2024 11:46:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C1.39.29212.11858476; Thu, 28 Nov 2024 20:46:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241128113117epcas5p3b0387c302753c5424ba410f5b38ddeb9~MHnypyjjI2977029770epcas5p3Z;
	Thu, 28 Nov 2024 11:31:17 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241128113117epsmtrp19dfd1807f91694943717847289ec2216~MHnyoz-sR0066100661epsmtrp1D;
	Thu, 28 Nov 2024 11:31:17 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-fe-67485811ff12
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1A.5E.18949.58458476; Thu, 28 Nov 2024 20:31:17 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113114epsmtip21bde63d90efc764733812a48cb33dd6b~MHnwYXNXU2084920849epsmtip2i;
	Thu, 28 Nov 2024 11:31:14 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 09/10] scsi: add support for user-meta interface
Date: Thu, 28 Nov 2024 16:52:39 +0530
Message-Id: <20241128112240.8867-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmhq5ghEe6wcy9ohYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbTgzdZC86LVrw9/4mxgfGKYBcjJ4eEgIlEV9t0
	ti5GLg4hgT2MEqcfHWGFcD4xSmxdsJQFwvnGKLFl5hcWmJbuL3+ZIBJ7GSX2NN2F6v/MKHF/
	7R9GkCo2AXWJI89bGUESIiCDexeeBpvFLPCSUWLpqkVgs4QFXCROTj3HCmKzCKhK3P3aDdbN
	K2ApsXXPRGaIffISMy99ZwexOYHis699Y4WoEZQ4OfMJ2BxmoJrmrbOZQRZICFzgkLjT/QDo
	Jg4gx0ViX1cwxBxhiVfHt7BD2FISL/vboOx0iR+XnzJB2AUSzcf2MULY9hKtp/qZQcYwC2hK
	rN+lDxGWlZh6ah0TxFo+id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JPb9ugQN4B5GidmT
	H7NPYFSYheSdWUjemYWwegEj8ypGqdSC4tz01GTTAkPdvNRyeEQn5+duYgSncq2AHYyrN/zV
	O8TIxMF4iFGCg1lJhLeA2z1diDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucDs0leSbyhiaWB
	iZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MuaVv1Vc80BVvfadqWKygXLD6
	0+/nbX2CUw2EQwy28jJIMX73a2TPObvo5bSMLfN2saVO+OD1M7d9GsORJ3EsBpMkF5vnO4Sc
	2zBJwKrPY5dxJVvlKWfGuhuzv2T6pGRnqUcrSoXn3zoi/8x10aIT2XJlGll7mJV3+13YVbcm
	V4bd5i+D98+C45N5itMNHpSxJoXrVcieZQn0r/zB+9TnmcRkiUu/M6L+vBTQOStb6Btqn7f5
	QKTiHtfJbh67dkR3qTy2O6ufW+Vgddd8kWrBms9aR/NshM4VLuJnfy+WaxBwSOzKhvkSFk9X
	OPmvnnTyxtXPv5inaD5xenJzaXXmn32no03nTlU97ZJVIaTEUpyRaKjFXFScCABW/kfmbgQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXrc1xCPd4NI2IYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV8fTgTdaC86IVb89/Ymxg
	vCLYxcjJISFgItH95S8TiC0ksJtRou+fOURcQuLUy2WMELawxMp/z9m7GLmAaj4ySjw4/x8s
	wSagLnHkeSuYLSJwglFi/kQ3kCJmkKIJX2azgCSEBVwkTk49xwpiswioStz92g3WwCtgKbF1
	z0RmiA3yEjMvfWcHsTmB4rOvfWOFuMhC4vLj66wQ9YISJ2c+AZvJDFTfvHU28wRGgVlIUrOQ
	pBYwMq1ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOMy2tHYx7Vn3QO8TIxMF4iFGC
	g1lJhLeA2z1diDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2ampBalFMFkmDk6p
	Bibjg/sevTg2L+nu/viXV8yro1dleL915tKWMTBpjUiz/+mgkORusv+17o//C3dGvl485/ff
	WV+WMz+Qlv2xX2LhiUbr4s38H8KZSzOfzLwoG9wQvPtGks7fGt4DG8Li5b2fLg0s25PQdfmF
	k+fKqT2pwqn1rf8qZxjO/PHm5CvBjp0ajEqF6XPc725X8Kq7HPc3TKRzUWNBiMP8R48d/6XE
	HvytnykV/JjHeo2h4G1WvedW6769Tm6Wz5Pt1vZb+rBEcdNOIYOKhEmtvNmrBC5UrK3VqXhk
	X7rn852TcV/z7+/9x1RhKyYcYNoiest7Vz/bPY0JPXll22/+ZNA2e7aj7zb3Loel7ye51Cma
	3FRiKc5INNRiLipOBACSvn51IgMAAA==
X-CMS-MailID: 20241128113117epcas5p3b0387c302753c5424ba410f5b38ddeb9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113117epcas5p3b0387c302753c5424ba410f5b38ddeb9
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113117epcas5p3b0387c302753c5424ba410f5b38ddeb9@epcas5p3.samsung.com>

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


