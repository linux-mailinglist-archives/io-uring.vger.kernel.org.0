Return-Path: <io-uring+bounces-2915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCA195CAE5
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 837251F241D2
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B2217C211;
	Fri, 23 Aug 2024 10:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Zi/TY8EA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52E187872
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410136; cv=none; b=UbkcJYx8QogaVt4Nh6+q+0lvAdIJZt/DBtLg8Y1+GpCsprDdcpMGwBGX+DbmiLJFodejxpK3axXA/axRnbEAZwKFLH3o9Cr5488HhxcW7jCniRSJ8DbIf0xfqS5jmyJMKpXSqGy1F5vDyem2sJeYUAjZ5EpNz3o4dcwQWB1+ts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410136; c=relaxed/simple;
	bh=d8uLLwSdbzE5G1fR2VMdUPEYeU0UD3cRDnuIOnqv5P4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=A4y9XFMopzOA5EzW2Cbkh+AsYFjmATjSnIqcdIOErH+QfUYk5lUlsbAzGhf7zIlgpkdIFRVXJUkMz0k/+f1J5GUj0zaaXoe8ZnX2OclOGjpE6WOnmDks0Ai6K0RsEZeY2qpHWlh8kfQBLS5xAsrWNAfoR1IvfgsE7ywKGfjlFWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Zi/TY8EA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240823104852epoutp037deb05962356b93498202f1b83a528ae~uVeEgSHeV1192211922epoutp03V
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240823104852epoutp037deb05962356b93498202f1b83a528ae~uVeEgSHeV1192211922epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410132;
	bh=YAT9f3XY8IKgq4WGMiK0V4o2WovD1lxpk8P5rBhzxR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zi/TY8EA4txsjwhM/vQbcI663nD8acr+pVTsqZg9o4LAx+BMurmS8TPsWrc2qvn3f
	 AZix6GMsf784zmL6M3zfzBCbhu5kdll2tZAacIuMY3iNeUio9A19pItbqVZe0zPhkB
	 M9fDUgfbZNeW+Vs0jwEBlvLJWucYPvPm/9m1j1VA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240823104852epcas5p424c5a420f83babade5eb18c7b817db39~uVeEBmsGG1746017460epcas5p4S;
	Fri, 23 Aug 2024 10:48:52 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WqxdG4j1Yz4x9Pv; Fri, 23 Aug
	2024 10:48:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.28.09642.21968C66; Fri, 23 Aug 2024 19:48:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240823104639epcas5p11dbab393122841419368a86b4bd5c04b~uVcIMnAqt0371903719epcas5p1h;
	Fri, 23 Aug 2024 10:46:39 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240823104639epsmtrp2a5af888759a8b81fe7731ecd1c213759~uVcILd2ID0163301633epsmtrp2m;
	Fri, 23 Aug 2024 10:46:39 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-8d-66c86912ad23
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	5D.50.19367.F8868C66; Fri, 23 Aug 2024 19:46:39 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104636epsmtip20ab42e1096e1e413e32f65d84bf4f0bb~uVcFxtx0q1442714427epsmtip2y;
	Fri, 23 Aug 2024 10:46:36 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 10/10] scsi: add support for user-meta interface
Date: Fri, 23 Aug 2024 16:08:11 +0530
Message-Id: <20240823103811.2421-12-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmpq5Q5ok0g2sn5S2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGZVtk5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0r5JCWWJOKVAoILG4
	WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+PJu8tMBS0K
	FZvaVjE2MF6V6mLk5JAQMJFo2LmesYuRi0NIYDejxJ7fy9kgnE+MEr0fLzHDOR2dj5lgWjZO
	nMMCkdjJKLFo21mols+MEkvefGMEqWITUJc48rwVzBYRqJR4vusHWAezwCZGiV/Xj4GNEhZw
	lrjW+hyom4ODRUBV4tzxHJAwr4ClxNPbL9ggtslLzLz0nR3E5gSKN81uYIGoEZQ4OfMJmM0M
	VNO8dTbYqRICCzkkdp1bwQzR7CIx7XcrC4QtLPHq+BZ2CFtK4vO7vVAL0iV+XH4K9VqBRPOx
	fYwQtr1E66l+ZpDbmAU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvP
	NTCBjJEQ8JA4PAsaVj2MEtf297BMYFSYheSdWUjemYWweQEj8ypGydSC4tz01GLTAuO81HJ4
	LCfn525iBKdhLe8djI8efNA7xMjEwXiIUYKDWUmEN+ne0TQh3pTEyqrUovz4otKc1OJDjKbA
	4J7ILCWanA/MBHkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTB1
	Z5msFxLKXZn7snzOF7Wjbww+8W0WWZ/V8Kb928f2N34n2aN2PCna6nb6xvp5hXrhyrPSL66x
	f7N7ls4fhXcWn2qzTtzfxLhn5S4B9u86E5q3Lpyc6m+9bUVWe02r/LWA5X+23JJapGQqJiog
	814pU/0yZ4ui8Lwlk/jcn5yYYcoscH3D0cCApzdCPviUi9bOXhn3SXSz/A2TkuXtD9/HSm8t
	/tbvtYU9KjDy2q5bQU+NP93fkSbLcqsmz+46Y/jiKUE66/yXFb3kkX0oYBR/nC3phljT9szj
	ivWqLd8XhFRmTvKIWHtDvSZqc+RP28NC1wXXMXT6euQ5bmi5oPNqm6nQG7ld927dudevui9P
	iaU4I9FQi7moOBEALz1gXkwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvG5/xok0g6dnOC2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mW
	WqRvl8CV8eTdZaaCFoWKTW2rGBsYr0p1MXJySAiYSGycOIeli5GLQ0hgO6PE+k3XWSASEhKn
	Xi5jhLCFJVb+e84OUfSRUeL4pbfsIAk2AXWJI89bGUESIgKNjBJbmr+AjWIW2MEose7ZYrB2
	YQFniWutz9m6GDk4WARUJc4dzwEJ8wpYSjy9/YINYoO8xMxL38GGcgLFm2Y3gF0hJGAhsWz5
	GUaIekGJkzOfgMWZgeqbt85mnsAoMAtJahaS1AJGplWMoqkFxbnpuckFhnrFibnFpXnpesn5
	uZsYwTGiFbSDcdn6v3qHGJk4GA8xSnAwK4nwJt07mibEm5JYWZValB9fVJqTWnyIUZqDRUmc
	VzmnM0VIID2xJDU7NbUgtQgmy8TBKdXAVHnw3Kx58kwVyaVBhqX/OxqsgkISGQvlv/aern1V
	pxhYfWvrrP4XGef7JFSCMqbmf1ojoR9aduD1TVGFXecXhN5iai+8ym3XPbO5edvP/1wF77c5
	eAkcbTStYErufGHitWpHb8xkJmW/GpEPQR8ZrGVPPa696349/JjR/rR4UUUGsxaBpN1ezEaz
	/9XGOGlo58yqvJ6y/vqTnatnWmc9eHZ8vipr1VGJQzO8/LrcV5ROasy/GqD58tYUoTu65e0T
	Tglv/s7I9j663CTeJsz34tPblwTMLtn/ltYV2N0jOGnnl23Gx6Ieb5Gv7BcweXb5433F1Obz
	f/uXXLR+y8Uh+vbx/l/sQfesD1+b9vi8EktxRqKhFnNRcSIAVsx/6QADAAA=
X-CMS-MailID: 20240823104639epcas5p11dbab393122841419368a86b4bd5c04b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104639epcas5p11dbab393122841419368a86b4bd5c04b
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104639epcas5p11dbab393122841419368a86b4bd5c04b@epcas5p1.samsung.com>

Add support for sending user-meta buffer. Set tags to be checked
using flags specified by user/block-layer user and underlying DIF/DIX
configuration. Introduce BLK_INTEGRITY_APP_TAG to specify apptag.
This provides a way for upper layers to specify apptag checking.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity.c         |  2 ++
 drivers/scsi/sd.c             | 25 +++++++++++++++++++++++--
 drivers/scsi/sd_dif.c         |  2 +-
 include/linux/blk-integrity.h |  1 +
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 02b766c2e57d..ff7de4fe74c4 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -492,6 +492,8 @@ bool bio_integrity_prep(struct bio *bio)
 		bip->bip_flags |= BIP_CHECK_GUARD;
 	if (bi->flags & BLK_INTEGRITY_REF_TAG)
 		bip->bip_flags |= BIP_CHECK_REFTAG;
+	if (bi->flags & BLK_INTEGRITY_APP_TAG)
+		bip->bip_flags |= BIP_CHECK_APPTAG;
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len) {
 		printk(KERN_ERR "could not attach integrity payload\n");
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 699f4f9674d9..6ebef140cec2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -803,6 +803,23 @@ static unsigned int sd_prot_flag_mask(unsigned int prot_op)
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
@@ -815,14 +832,16 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
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
+			(!dix || bio_integrity_flagged(bio, BIP_CHECK_REFTAG)))
 			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
 	}
 
@@ -1374,6 +1393,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
 	dld = sd_cdl_dld(sdkp, cmd);
 
+	if (!sd_prot_flags_valid(cmd))
+		goto fail;
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
 	else
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index ae6ce6f5d622..6c53e3b9d7d7 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -50,7 +50,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
 		bi->csum_type = BLK_INTEGRITY_CSUM_CRC;
 
 	if (type != T10_PI_TYPE3_PROTECTION)
-		bi->flags |= BLK_INTEGRITY_REF_TAG;
+		bi->flags |= BLK_INTEGRITY_REF_TAG | BLK_INTEGRITY_APP_TAG;
 
 	bi->tuple_size = sizeof(struct t10_pi_tuple);
 
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 2ff65c933c50..865e0c4a7255 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -13,6 +13,7 @@ enum blk_integrity_flags {
 	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
 	BLK_INTEGRITY_REF_TAG		= 1 << 3,
 	BLK_INTEGRITY_STACKED		= 1 << 4,
+	BLK_INTEGRITY_APP_TAG		= 1 << 5,
 };
 
 const char *blk_integrity_profile_name(struct blk_integrity *bi);
-- 
2.25.1


