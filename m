Return-Path: <io-uring+bounces-4144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 937A59B50C8
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09B0DB24E87
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F3920697E;
	Tue, 29 Oct 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r7ivlmEC"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D9206517
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222751; cv=none; b=PA6PN2lO/0mHCbtlOZUcbYzQjXaMVNoaAlsXa/iK+7emidoWd8Y128iMS0Vc+y1YW4HZ0s4SV7UrqHuF/Zuri39M4HB13etcQc588AFF5LBAe0xo0xNpwNmrXfuUM+GvYNR9WnlsjqbxEu3kKrF00a5bdHnThf/7v39FLoUrZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222751; c=relaxed/simple;
	bh=LnaNhp0NkZ+h1x7hNoh8dcamhZlSIZfnMvMK0uvlcQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ueGViEBxTPLcXFgRMfJfvQ/GKd2h/P+n/P2zos8owhp0BFFmYP0zL0JXZmv+G3MY+eLExd5kXkDp51OdNtZqmoeyec+gHNopm/zOC4miYN9Sn91jvlEeFcL80GLHUvtjph3bEkwXQL66GogqNRmjm/d2ONqt5eN4EYKAa5jM5WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r7ivlmEC; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241029172547epoutp03bc0ddd03fda8ef7af97f8c9f041149b4~C-GvxzU4Y0537505375epoutp03D
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:25:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241029172547epoutp03bc0ddd03fda8ef7af97f8c9f041149b4~C-GvxzU4Y0537505375epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222747;
	bh=8JozZTu1XSCEABsX3TkivbzX6vM8WnvmIwslWwYHbLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7ivlmECaV8wf5QrHiLPI+XMiUlv1fnlU4mGueqZn92jyQhmcCRe240PO3jBlj1Bc
	 vy4Q5EVH1OXMus+/oS1O+ouFM+NmS80Vw5AFLXVPQEICRq2aBQsr0YgEmtiovubdnH
	 jxNNeizemzNBOoj2IgYDTFmDiJ69UDSEMaNjmlJg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241029172546epcas5p3bec90d67d624ce23cd583d1956e0b8ce~C-Gu44GIQ2484924849epcas5p3P;
	Tue, 29 Oct 2024 17:25:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XdHGK1qJTz4x9Pq; Tue, 29 Oct
	2024 17:25:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.1A.09420.99A11276; Wed, 30 Oct 2024 02:25:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241029163233epcas5p497b3c81dcdf3c691a6f9c461bf0da7ac~C_YQ3_uT52670526705epcas5p4X;
	Tue, 29 Oct 2024 16:32:33 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241029163233epsmtrp1799296227aa898eaa6db6202340f0d68~C_YQ3LOAg0723107231epsmtrp10;
	Tue, 29 Oct 2024 16:32:33 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-2a-67211a99c54a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.4B.07371.02E01276; Wed, 30 Oct 2024 01:32:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163230epsmtip2b37587e74672e6bf9f7f3d746f1ccbb8~C_YOnT_e90998409984epsmtip2c;
	Tue, 29 Oct 2024 16:32:30 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v5 09/10] scsi: add support for user-meta interface
Date: Tue, 29 Oct 2024 21:54:01 +0530
Message-Id: <20241029162402.21400-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029162402.21400-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmhu5MKcV0g6aX7BYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsasHyEFyzkq/v74wNzA+JWti5GTQ0LAROLPmgtM
	XYxcHEICuxkldpzvZ4NwPjFK/FlymQXC+cYo8bXpJVzLnJVNUC17GSW2v//OCuF8ZpS4su8C
	C0gVm4C6xJHnrYwgCRGBPYwSvQtPg81iFnjJKLF01SKwKmEBZ4n2zx+YQGwWAVWJO6/3M4PY
	vAJWEq+3XGGF2CcvMfPSd3YQmxMofuzoHiaIGkGJkzOfgM1hBqpp3jqbGWSBhMAFDol1c28C
	FXEAOS4Sc1vTIOYIS7w6voUdwpaSeNnfBmWnS/y4/JQJwi6QaD62jxHCtpdoPdXPDDKGWUBT
	Yv0ufYiwrMTUU+uYINbySfT+fgLVyiuxYx6MrSTRvnIOlC0hsfdcA5TtIbHh50RoaPUySjT+
	2ss6gVFhFpJ3ZiF5ZxbC6gWMzKsYJVMLinPTU4tNCwzzUsvh0Zycn7uJEZzGtTx3MN598EHv
	ECMTB+MhRgkOZiUR3tWxsulCvCmJlVWpRfnxRaU5qcWHGE2B4T2RWUo0OR+YSfJK4g1NLA1M
	zMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamCafn+m+pwl649denbUPeEfc9uu
	BSr/627dbYus3vfi7JrIgMOCyyR+Tr7S/Hfi6rqz8oeXuh9f4yk6+UMoi9nljN78g44uAfI8
	nm92VL37XH6eOeaShsX93uVFZj/+rnSpE7lm7OUY+tjz4J7CH1Ol/l8MbvheaxaV2K9y6u7K
	J29U04p3TVF8p3tI8GXmvFec/ZM9f4kJzzX+ErdLPfun/q7NO6+7L2ZP8T/D+UJ0lRVf0pZN
	X/TeuDJ4MbkqF33jq3T+phw1gTecN/2Vdbze7YdS0y3np96r/PfXYeEWSf/W9x5fGaaULLx5
	IWNmUspUgf1/pu+533Tx8CODtOctAcUK+rov523ZdJQjPfNurBJLcUaioRZzUXEiACTaXNJs
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXleRTzHd4MB2JouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CVMetHSMFyjoq/Pz4wNzB+
	Zeti5OSQEDCRmLOyiamLkYtDSGA3o8Tlf99ZIBISEqdeLmOEsIUlVv57zg5R9JFR4tbal2Dd
	bALqEkeet4IViQicYJSYP9ENpIgZpGjCl9lgk4QFnCXaP39gArFZBFQl7rzezwxi8wpYSbze
	coUVYoO8xMxL39lBbE6g+LGje4DqOYC2WUqcnOQGUS4ocXLmE7CRzEDlzVtnM09gFJiFJDUL
	SWoBI9MqRsnUguLc9NxkwwLDvNRyveLE3OLSvHS95PzcTYzgKNPS2MF4b/4/vUOMTByMhxgl
	OJiVRHhXx8qmC/GmJFZWpRblxxeV5qQWH2KU5mBREuc1nDE7RUggPbEkNTs1tSC1CCbLxMEp
	1cB0K/vn1RopATEJjlsKT5Qe5k5/M9HD7cvDVy7CU2davft8PHcaC/O9N59+n7584PgifSmp
	W81Mjg9F1Hkq020vsKWeOCu34tSfne9+WwdN1bUwiDxyjuH17i1bovbnT3nueMu7+N3dkwKR
	XD8avPdJpleay8UwLRKPKj+R8WvmoZnT/9Qm5H7UOfPg9IqgtG9MWjP18gx7X11MuSxlU6/3
	JmLNu2c/PpbaCrg+m/SBjXOJH7+Z+OnpVmzcj1UfCWzL3LczUtmze2f6x3CRs+4LKjvnHOiV
	qo84Zc1hoXzlntAb0yCPLUvKSj65WPzN6PgmKa4wac+1WQ5xp3af+ufi7zjrSsmWoJ64Tasu
	n/z3UomlOCPRUIu5qDgRAM91qNEhAwAA
X-CMS-MailID: 20241029163233epcas5p497b3c81dcdf3c691a6f9c461bf0da7ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163233epcas5p497b3c81dcdf3c691a6f9c461bf0da7ac
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163233epcas5p497b3c81dcdf3c691a6f9c461bf0da7ac@epcas5p4.samsung.com>

Add support for sending user-meta buffer. Set tags to be checked
using flags specified by user/block-layer.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
2.25.1


