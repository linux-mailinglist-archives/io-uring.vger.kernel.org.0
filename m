Return-Path: <io-uring+bounces-4058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6049B2ABD
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 09:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A145280FAD
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 08:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4211B190678;
	Mon, 28 Oct 2024 08:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IBs0bFui"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00E19047C
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105409; cv=none; b=bZ9X20gSSWlprw4RQboOXq/6851Z53EPURtIgbh5phi/DSIoXHfmrPWvJgXW62+NvvE4ZmaMwe70ruK5ME3LXZThPImuLoO3jsDQo/4IElJ9pQe932LKiU3GqFSEHVBSaK0tYmwsqQWYtFPRg3TZ5kQPqT+dxMOXtf2xdYEzPKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105409; c=relaxed/simple;
	bh=psGOAh1xDaVlwmbZcuHH+an4/P6ezHhtJBNPJeQCvTs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=nFuk29D2n8nuUyxHdw4JX0GVghz5KcrjlhWXe2ZmuX2N3js6cyF2Sihn/GVQfKR95Yi1l9zfanva6CzUoyPOnTQwJHTuLLjbcvPUid3+MbYF1TcAl6rnxkoe/yZ07e+pfmY5gYLXsKoP6+hV71cYKot/yvJMy246J4umqwXNR6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IBs0bFui; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241028084447epoutp013cc7db1363fa55d813759ab4d63c54e9~CkWkx3kLH0169901699epoutp01Y
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:44:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241028084447epoutp013cc7db1363fa55d813759ab4d63c54e9~CkWkx3kLH0169901699epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730105087;
	bh=4YWjdESAaWOHQLDRBkDBnjjpfp6/Oe/mnF/yA4Ua2Kg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IBs0bFuiSaxg+yIcmJOKwhKx1aMro2eRZGZAHoUbedep3q+zqX3ybLev3rDFipVKx
	 UjK7ACfpLscH8BiCPtdJDUtNeMwrY7vBI7dWCdmNwBTqrRPD/3jz9HfHtPneqiSjWQ
	 I9XU7F9fLb3d9myHp1AvmQu6A/L/ztQwMPf4IDfU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241028084447epcas5p2f2f402718354850a4c53a830de020189~CkWkWUczT2138821388epcas5p2y;
	Mon, 28 Oct 2024 08:44:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XcRld2Swvz4x9QC; Mon, 28 Oct
	2024 08:44:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	02.1C.09420.DFE4F176; Mon, 28 Oct 2024 17:44:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241028074350epcas5p3146ecfc1b74ffb86a12ad15fc84c36f8~CjhWnjS_w0185901859epcas5p3t;
	Mon, 28 Oct 2024 07:43:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241028074350epsmtrp1dd556e6d979ff05b57d73a2b9472a7a2~CjhWmqjwx1621716217epsmtrp1S;
	Mon, 28 Oct 2024 07:43:50 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-e6-671f4efd9782
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.46.07371.6B04F176; Mon, 28 Oct 2024 16:43:50 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241028074348epsmtip100cb7f832806c698c1f6920688a6c71b~CjhU0x6sY2630526305epsmtip1R;
	Mon, 28 Oct 2024 07:43:48 +0000 (GMT)
Date: Mon, 28 Oct 2024 13:06:10 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241028073610.GB18956@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1sesolxa6.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH87u3lluy6h2U7awEYdeQTcejldJdplWzGXvJGCFjM5nL1nX0
	pjDgtuttfc1sMAMKmyAgDAoMshfYGiQFWaXjIeIq9YERmYOFIZmgDMOUOSPgcC0ti/99ft9z
	vr9zTs7vR+Ah54VSIoszsyZOm0MJgwUdZ9e/GPtvaqReNp8vpu/9syig62wdiLaPlQrpkd7T
	GH3cfg6jZwsuC+jyvl8Q/ePF73G6a/QluuGHySD6i+tOId3kXsLoQWtd0DYxc9o6FsQMXbIw
	DluRkGn77jPGNZInZO5NjgqYknYbYtoufML87VibJtqVvTmT1epYUxTLZRh0WZxeRb2ernlN
	k6iUyWPlSfTLVBSnzWVV1PaUtNgdWTnepqmo3doci1dK0/I8Fb9ls8lgMbNRmQberKJYoy7H
	qDDG8dpc3sLp4zjW/IpcJtuY6E38IDuztKYZM3aE7p0bHkd5aH5NMRIRQCrgsLMIK0bBRAjp
	QnCnqhb3H+YQtFxtCxweIGjoasRWLLUnigOBLgSHr/we8E8h6JxdWFWMCEJARsOFwRSfQUi+
	AP23CpCPJWQiVMydEvrycfIrDIqrHi4HQkk1VHePL7OYjIWZiz/hfn4aBmpuCnx3isgEaB7k
	fHIYuQ56O9zLdYHsJ2Dh81mBv7vtcPVSG/JzKPzpbg/ysxSmSwsDrIeHQ5OBaYxw8OfuQP5W
	KPCULtfFyUy4UlUe0COg0tOC+fXVcGTxZsArBufXK0zBoeN1AQboupyH+XoGkoHR4QM+OYS8
	hSDfHX0URVqfmMz6RDU/x0Cja05o9bpxMhyalgg/roeTnfGNaJUNPcca+Vw9yyca5Ry75/99
	ZxhyHWj5SW9IdqKxG3fj+hBGoD4EBE5JxPb3IvQhYp12337WZNCYLDks34cSvZsqw6VhGQbv
	n+DMGrkiSaZQKpWKpASlnHpWPFNQrwsh9Vozm82yRta04sMIkTQPK+v+q0AmAfP01EBketNU
	UT/Xgmf/uvRNbE/lznxigjnpMn4YLk5wSthjjw+Uf/SM2jNw39KTqtK/MVn/oE43PaqIaB6u
	a3h7TbQcnSM179rkrvkdFmJtnGePa+atkl3dEqwsImbqVaV1i0J1XdL6zjXx6l7ZofT9R26f
	v51uVqea38QXgkdbS659W/1l+InJibCarjORteqou++De8ThTobC8fuenQsZ+36bc3IHpWlD
	1lPDDWN4dMXuvRLdphuOVokkxdYqibFU9EoLtw07Pj1Wf7Zzq6Xk46ZN1Y8jLZV/3FlUxz/v
	edQm6tvYQ9hVj9rrDTqNPVkdceboxFM8JeAztfINuInX/gemvdR1WwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJTnebg3y6we11khYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TBbn
	Z81hd+D12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6Mnwf+shV8E6g4+3YRWwPjJd4uRk4OCQETidlrupi7GLk4hAR2M0p8OHyN
	GSIhIXHq5TJGCFtYYuW/5+wQRU8YJS6unALkcHCwCKhKnD7vA1LDJqAuceR5K1i9iICpxORP
	W9lA6pkFZjJJrJqwlB0kISzgLjFj332wIl4BXYnXZ/ZAbX7OKLHh5UGohKDEyZlPWEBsZgEt
	iRv/XjKBLGMWkJZY/o8DxOQUMJZYcT4PpEJUQFniwLbjTBMYBWchaZ6FpHkWQvMCRuZVjJKp
	BcW56bnJhgWGeanlesWJucWleel6yfm5mxjB8aWlsYPx3vx/eocYmTgYDzFKcDArifCujpVN
	F+JNSaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyWiYNTqoGJ04ZvTYhm
	hRlz2Wo/75TTvRrtR8oNlrSVfevvvZfK9HJy3AaPydcWrn3Y3dPxJC9u6bSNt5uEE3M279+l
	Xe490/+69k69ZfMuT0l6w7nedumS9d23P/DyzVD21LQ/ynvfYO+sZHnB6VKr1q0xc/0dc+K2
	2IyAiW0p2Ux5J2PVlx82tJLVbxDacP5hlblqg9fxyyktW9UO+N8VLJol6d71wa1A5MrFqMUH
	uV66s7OofbFwrDL6tW/nyte8Xv7XI+dyO+Xby/Xl/jhS4fA1nmf76YQJN3yeNM2L3JHo7rFC
	Y9XFl1sag6J5cu3eVb7Ic3u4ZuGtAw0F77urj3+x7oo6terPsUfee5c2Ny/XEHFXYinOSDTU
	Yi4qTgQAtCYN/R4DAAA=
X-CMS-MailID: 20241028074350epcas5p3146ecfc1b74ffb86a12ad15fc84c36f8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7f461_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>
	<20241016112912.63542-12-anuj20.g@samsung.com>
	<yq1sesolxa6.fsf@ca-mkp.ca.oracle.com>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7f461_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Oct 21, 2024 at 09:58:57PM -0400, Martin K. Petersen wrote:
> 
> Anuj,
> 
> > +/*
> > + * Can't check reftag alone or apptag alone
> > + */
> > +static bool sd_prot_flags_valid(struct scsi_cmnd *scmd)
> > +{
> > +	struct request *rq = scsi_cmd_to_rq(scmd);
> > +	struct bio *bio = rq->bio;
> > +
> > +	if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> > +	    !bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> > +		return false;
> > +	if (!bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> > +	    bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> > +		return false;
> > +	return true;
> > +}
> 
> This breaks reading the partition table.
> 
> The BIP_CHECK_* flags should really only control DIX in the SCSI case.
> Filling out *PROTECT is left as an exercise for the SCSI disk driver.
> It's the only way we can sanely deal with this. Especially given ATO,
> GRD_CHK, REF_CHK, and APP_CHK. It just gets too complicated.
> 
> You should just drop sd_prot_flags_valid() and things work fine. And
> then with BIP_CHECK_* introduced we can drop BIP_CTRL_NOCHECK.

So I will keep the fine grained userspace/bip flags (which we have in
this version). And drop the sd_prot_flags_valid() and BIP_CTRL_NOCHECK
like below [1]. Hope that looks fine

[1]

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76ad..0913bd43f48a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -814,14 +814,14 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 		if (bio_integrity_flagged(bio, BIP_IP_CHECKSUM))
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
 
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
+		if (bio_integrity_flagged(bio, BIP_CHECK_GUARD)
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
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7f461_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7f461_--

