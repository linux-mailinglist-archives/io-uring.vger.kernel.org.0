Return-Path: <io-uring+bounces-3733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A34239A0A07
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A17D1F24C20
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F93208970;
	Wed, 16 Oct 2024 12:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VkfxGp6I"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9F0207A09
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082249; cv=none; b=qSW/dd2+QbwkGnV35Eiwd0UbLh0NnCau0nZu2ugiW7wyE8Lj+UIjCe+H74P3nAR5HgM9oybx0eQDr5PreMU/ckwLPFN9SP9va4rCyDNePIFGJM78bdCR1SBIr10P/4wS6SqjIA034jxoLvFU9d/+vgR/3oe3yCXLERNvDaG84u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082249; c=relaxed/simple;
	bh=d/VW0lpwYUltDPxzsuM2m8RXMRUI3+BODfWq13zoDNc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=s4b0Zo+qNeV61JdGCKc1Ia/uqYm3uWeHZrvb41NTMkN9193WVjEAOhUfQy1vNAEde52F8E+49idWhOFHPqAAFxFPjEVzhugQKGZbMe4rxxdxRSj7G5Hb+12f4Z79DrQ2Fjs0n6hdOdN/DZZT7LfEB+Zlzpz0XfdyIFnqmdP3NpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VkfxGp6I; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241016123725epoutp043f92d6e6d9e231aece76677e3a6eb7c2~_7yQvol782079920799epoutp04T
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241016123725epoutp043f92d6e6d9e231aece76677e3a6eb7c2~_7yQvol782079920799epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082245;
	bh=onb9D8irMkDonXAnGDbuDg2oS2aLz5VgLMelslR2Osw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkfxGp6IawnhO+k2f7bkkXLKJp4o4OvAh+jDeixqrhbUXHN6cg4lsglOt1TgEshoJ
	 W66F8oZd+FuvCnv+wg33IOraUhoUJZLAXT3LVMREibL6jT0Ns8MbMNUrlPICp0v+P2
	 bJZHPmYk0127BKVneqBBFq4n8t4fg52jilUzTGKs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241016123725epcas5p44cc6c5183af4ca01042d96fb04e1510e~_7yQNsAlQ1720917209epcas5p4w;
	Wed, 16 Oct 2024 12:37:25 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XT9Tb2HDGz4x9Pv; Wed, 16 Oct
	2024 12:37:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1F.11.09770.383BF076; Wed, 16 Oct 2024 21:37:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e~_6_VVIcxJ1424214242epcas5p4s;
	Wed, 16 Oct 2024 11:37:57 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113757epsmtrp2cd5cd20f134d35a1e94a840bfb6c3a5a~_6_VUV7ny1554615546epsmtrp21;
	Wed, 16 Oct 2024 11:37:57 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-59-670fb383d50c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.AA.07371.595AF076; Wed, 16 Oct 2024 20:37:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113755epsmtip1a6461705654a11b705fdf0593467dbab~_6_TaGi1e3098130981epsmtip1G;
	Wed, 16 Oct 2024 11:37:54 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 11/11] scsi: add support for user-meta interface
Date: Wed, 16 Oct 2024 16:59:12 +0530
Message-Id: <20241016112912.63542-12-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmlm7zZv50g3e/eS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOOHBxEUtBl1DF4T2PWRsYf/F1MXJySAiYSOxdfpGli5GLQ0hgN6NE0/s7UM4nRonOs9+Y
	QaqEBL4xSuzd4ArTcer+EjaIor2MElM+NLJDOJ8ZJU682swEUsUmoC5x5HkrI4gtIjCJUeL5
	5VAQm1ngFKPE2l8KILawgLPE+yU7gSZxcLAIqEr8O60LEuYVsJJYOO0WC8QyeYmZl76zg9ic
	QPFT5w6yQ9QISpyc+YQFYqS8RPPW2cwgN0gI7OGQmPJ1CxtEs4vEjEeH2CFsYYlXx7dA2VIS
	n9/thapJl/hx+SkThF0g0XxsHyOEbS/ReqqfGeQ2ZgFNifW79CHCshJTT61jgtjLJ9H7+wlU
	K6/EjnkwtpJE+8o5ULaExN5zDUwgYyQEPCRuXa2BBFUvo8SpNw+YJjAqzELyziwk78xC2LyA
	kXkVo2RqQXFuemqxaYFRXmo5PI6T83M3MYLTspbXDsaHDz7oHWJk4mA8xCjBwawkwjupizdd
	iDclsbIqtSg/vqg0J7X4EKMpMLgnMkuJJucDM0NeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC
	6YklqdmpqQWpRTB9TBycUg1Mm01nr3i466Je+Lp8m0WPr1qadf293dtzd330m9N+hww+nXkh
	0Nkof/76ApvnlyKFbMMU//wx3sP50ERKJ8dmXubSwOVzch91zknsDyreeFKK43GnZNLtu5r2
	6/P5bstrp10z+x6UIrlUVrB2k4DHdmOPtXtO1mzSSd4i5XFi2qUtkocPeQQJzDmge2WdUOrs
	y7WH/q700bST8Pbt5uvlKc1YldReX9R+YF3Mld8lp3d0+fodtnpgK/PM8UBk3Skbyd3vp1yT
	YxTSvvioPP6Hx+HFO9Vu5ES1GX+WmDP33RUtz9NBRrvFzHgPXdkUM6EsfaKQDPOfhMmn2pX7
	qmvDbKRun4iLmV+ZPrPwzjIVJZbijERDLeai4kQAf+X/PFQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSnO7UpfzpBs/+sVh8/PqbxaJpwl9m
	izmrtjFarL7bz2Zx88BOJouVq48yWbxrPcdiMenQNUaL7WeWMlvsvaVtMX/ZU3aL7us72CyW
	H//HZHF+1hx2Bz6PnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Np6s9Pm+S
	C+CM4rJJSc3JLEst0rdL4Mo4cHERS0GXUMXhPY9ZGxh/8XUxcnJICJhInLq/hK2LkYtDSGA3
	o8SG9Z8ZIRISEqdeLoOyhSVW/nvODlH0kVHi558uZpAEm4C6xJHnrYwgCRGBWYwSh2fNZwJx
	mAUuMEpc3feMHaRKWMBZ4v2SnUA7ODhYBFQl/p3WBQnzClhJLJx2iwVig7zEzEvfwco5geKn
	zh0Es4UELCX+Tf7ACFEvKHFy5hOwemag+uats5knMAJtRUjNQpJawMi0ilEytaA4Nz032bDA
	MC+1XK84Mbe4NC9dLzk/dxMjOH60NHYw3pv/T+8QIxMH4yFGCQ5mJRHeSV286UK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5DWfMThESSE8sSc1OTS1ILYLJMnFwSjUwHZWdY/+wcbdfdGgy6zIr
	W7n3VSZRW/t3/etTN4nmW5UbrHBTe8L5C1q80wW63NpebH4Zfsruaba9ec7FHR2dYrOzBMKd
	pEt/FdW6L/vBLqp67svEBQ4+BxNlr09k4jv++8zNV7EL05iKr239d9/20Idk3oIJiQsWrn4k
	vdRC+GbWsmLbZNu1O/x8lFdlsai87Lj78ojzC4+uH9Nzz7086zMnLM0+Zapq7u/So3Gvd4gF
	633RWSq8T33H79SJEqsk+3uUHt07YnT0SdVtlRdXo0R55tV/ufP8yVzRBW8/ZFxN7WU6cKHh
	/grRFf5pS5+cnbJ73imfXy2TOrYf1V4VeXBXi+CCdzqK97+fvfmGj1uJpTgj0VCLuag4EQB2
	gniODgMAAA==
X-CMS-MailID: 20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>

Add support for sending user-meta buffer. Set tags to be checked
using flags specified by user/block-layer user and underlying DIF/DIX
configuration.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/scsi/sd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76ad..87ae19c9b29c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -802,6 +802,23 @@ static unsigned int sd_prot_flag_mask(unsigned int prot_op)
 	return flag_mask[prot_op];
 }
 
+/*
+ * Can't check reftag alone or apptag alone
+ */
+static bool sd_prot_flags_valid(struct scsi_cmnd *scmd)
+{
+	struct request *rq = scsi_cmd_to_rq(scmd);
+	struct bio *bio = rq->bio;
+
+	if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
+	    !bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
+		return false;
+	if (!bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
+	    bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
+		return false;
+	return true;
+}
+
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
@@ -814,14 +831,16 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 		if (bio_integrity_flagged(bio, BIP_IP_CHECKSUM))
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
 
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
+		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false &&
+		    (bio_integrity_flagged(bio, BIP_CHECK_GUARD)))
 			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
 
 	if (dif != T10_PI_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
 		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
 
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
+		if ((bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false) &&
+		    (!dix || bio_integrity_flagged(bio, BIP_CHECK_REFTAG)))
 			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
 	}
 
@@ -1373,6 +1392,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
 	dld = sd_cdl_dld(sdkp, cmd);
 
+	if (!sd_prot_flags_valid(cmd))
+		goto fail;
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
 	else
-- 
2.25.1


