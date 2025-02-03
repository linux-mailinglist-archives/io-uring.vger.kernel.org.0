Return-Path: <io-uring+bounces-6245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E68A26B64
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 06:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FCDE3A6F55
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 05:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC228632C;
	Tue,  4 Feb 2025 05:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AUu1xDuZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD141171E43
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 05:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738647071; cv=none; b=Hi5hObU3ty89R0SmnEj/amJfwF3SQwLnA93P3xnicM099moVj44yHXbzLxJuhXMuXLzhfPqm2twiyDgg67lizcoL1cogZmaGKBfQ7gvDUhZL5l9ZY62/iPpiKA1qd7Ks+QutL4XwdfZ71ycfjtJmrEUbBwAwHf7hcLwW6+lDlnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738647071; c=relaxed/simple;
	bh=PCN6BSDqgPcfSNKaZIAupKQk76R/FYJVzH3vGhPXDrY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=L6mKQUWVVUQ1dliB+Gwbx5f3tVwHKY+wTVcsxmspgvX265ughZaOsMwicwwX5/GEP0F6l+ZShht0hOC/E9qg+gQjEFBzZ2wYXRDhzrtNMpbE64HLcEaSrTru0wPInzsJiFQ2zJwWTANgbb0iSjeJgppfIMiKcFgFJQuAs3FWqZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AUu1xDuZ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250204053105epoutp04c2523080fe2dc05b3550451ef534d3e3~g6ktiOiiX2082320823epoutp04i
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 05:31:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250204053105epoutp04c2523080fe2dc05b3550451ef534d3e3~g6ktiOiiX2082320823epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1738647065;
	bh=d+w9M9YoUAvSGZfteBcBIVBmN6FPU951O7mIxkYvjro=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AUu1xDuZ5YMCbddmm6yoUW3fKa8jfgK50xwfkkJWQd4HC8eqQxJYL71kqwPaHWn31
	 WCLIXoZwo+rQLyGXsrXbyfykOdPtX7f+IWorvnToUt74PQS5YWomLt1a6pH1gCn9jz
	 xL/3XOdODA2heNGwabngapzj1PCFJ8GHqKUW/fKU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250204053105epcas5p3257817e15d0d2296321c33e49ea9ff8d~g6ks_B9ab1272512725epcas5p3I;
	Tue,  4 Feb 2025 05:31:05 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YnBmR26p4z4x9QJ; Tue,  4 Feb
	2025 05:31:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.06.19710.716A1A76; Tue,  4 Feb 2025 14:31:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250203144800epcas5p42bc46752c8353c2a34c7b7a6691a9d4e~guhrleqri2470424704epcas5p4P;
	Mon,  3 Feb 2025 14:48:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250203144800epsmtrp2a1ae9366eb3a7143b1416d8d75c253da~guhrkplix1519215192epsmtrp20;
	Mon,  3 Feb 2025 14:48:00 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-f8-67a1a6174c2a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.79.18729.027D0A76; Mon,  3 Feb 2025 23:48:00 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250203144758epsmtip1bff49deb539d8b23f41706ce22046714~guhpUQejQ1320113201epsmtip1o;
	Mon,  3 Feb 2025 14:47:58 +0000 (GMT)
Date: Mon, 3 Feb 2025 20:09:48 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20250203143948.GA17571@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250203065331.GA16999@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0wTZxjH996Vu4OkzVFRXzG67nRTkGIrBQ4CzGSE3DZ/EBe2yDLgAmdh
	lGtzLbhBFnEIUxyiJuqAOmAz8mvO0bGOglVWfkUYMIdjE3Rz2uIPgo7iwIWBK1xZ/O/zPO/3
	+z7v8z7vS6ByFxZIZPEmTuBZHYX5SaydQcHK1edrtar+EoKe+ntOQpsbrYBuulWO0ROdbkDf
	6LAhdENTN0I/Kh6U0FVnihC6+9kkRp90jADaPrqFvmS/KqGrz7tw+uivrRhd17uA0EPzvT70
	UKUZ3+7P2Cpv4czwQC5jaTyCMd+eO8C03yjEmCnXqIQ51tIImB9runBm2rKesTgnkUS/5OyY
	TI7N4AQFx6frM7J4bSz15lupr6WGR6jUSnUUHUkpeDaHi6XidyQqE7J0nnYoRR6ry/WkElmj
	kdoaFyPoc02cIlNvNMVSnCFDZ9AYQo1sjjGX14bynClarVJtC/cI07Iz6yeKccO4/wdlp5vx
	QnBbVgp8CUhq4FlriU8p8CPkZDuAV1zfIGLgBvDJzB1cDGYALOsox5Yt7norKi7YATzYcNZr
	GQdwYq7JZ1ElITfCm9enJIuMkZtg171isMgBJAVdDwfAogElK1A4WP3dkmgFuRcOLTTjiywl
	ldBiu4CK7A+vVjiXNL5kCHSPm5c2WklugB3WXkQ8kpOAI78IIsfDiws/AZFXwIe9LbjIgXD6
	kd3bghY+HXZ5vQZY1HPZq38VFveVL9VFyUw4/0OZ17sOnur7GhHzMlg25/R6pbD182Wm4CcN
	Zi9DaB8s9DIDZ+dLvNc1BuBdW6vkOHix8rneKp+rJ3IIrGl3Y5WA8PBaWLdAiBgEL7ZtrQE+
	jWANZzDmaLn0cIOa5/b/P/J0fY4FLL334PhW8Fv1QqgDIARwAEigVIC0//sarVyawX6Yzwn6
	VCFXxxkdINwzrBNo4Mp0vefD8KZUtSZKpYmIiNBEhUWoqdXSItshrZzUsiYum+MMnLDsQwjf
	wEKEGQlU/TPdYe6PGd1ziHX9+UTQDdy93zm7rzbg2m5nQnL5puZ9X05emD15auzTj/JmS4/m
	nTnySl1pSF9BklHeo/FPaQ9jlbbofGVhy4lt8de5LafvBKmtze+VpP38cfLwukFbRtg7fNzh
	+++iuzbMPYi75qx9e+L3Vf2X7Q8O41Vofsq5ktgrSd0qbZWw/fHTlGQ4ZmeRnAamLS1+7Ks9
	wcjMmvXWAOaAVDZn6np/c7q5/mBC423L60mJeUXWtegLj7HiVoWMHVI76qLtPm3WN/bfjJIc
	68vfu+tS5DP35t2ygSblZ/+ahvmCl+tDXiL+irxXIKtTfGHdsQrfWdETIDj+oCTGTFYdjApG
	9j/LIdJjeAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnK7C9QXpBgeu61l8/PqbxWLOqm2M
	Fqvv9rNZvD78idHi5oGdTBYrVx9lsnjXeo7FYvb0ZiaLo//fsllMOnSN0WLvLW2LPXtPsljM
	X/aU3aL7+g42i+XH/zFZnP97nNXi/Kw57A6CHjtn3WX3uHy21GPTqk42j81L6j1232xg8/j4
	9BaLR9+WVYweZxYcYff4vEnOY9OTt0wBXFFcNimpOZllqUX6dglcGWvmJxQs46948TSugXEn
	TxcjJ4eEgInEpxXbmEFsIYHdjBKr/6lAxCUkTr1cxghhC0us/PecvYuRC6jmCaPE3asQDSwC
	KhJ3rnxkAbHZBNQljjxvBWsQEVCSePrqLCNIA7PAbGaJ1xMegzUIC0RK9M+/zQRi8wroSmza
	uRZq811GiU/ntCHighInZz4BG8osoCVx499LoHoOIFtaYvk/DpAwp4COxKdnc8B2iQooSxzY
	dpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzgetTR3
	MG5f9UHvECMTB+MhRgkOZiUR3tPbF6QL8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCe
	WJKanZpakFoEk2Xi4JRqYJr5pMJtisbP9kuej6Q/T9rFIsT0pZXF/1uqROLysBNbdDfZ37b4
	a9q19vLTsEW39wcHTY1fo7b29V+mRGN5lq+LszZoiHlkMx576up96Gbh5gXMJa9MV5UX/8my
	fZL/o+USl3DV5zynL4u8m59eOtQ669kU9VW9zKGu9/sqXY91Pb3FyNLzjaH+W1tZko//tWMZ
	6StkmJ3C/iav+PX26v4QX+YzmyztJe6kB/9fxfFg89M+I5mrcul3HS7nm7htiviVckGP+YJA
	wJMvWQ85zn71aGNtkp7N83Re0tbHMScnn+Bol/xQF3uwaPn8gqeWyUkf/lxpWO9hMCllvncv
	57UoIzW7p4/vi6zxd7yz8aUSS3FGoqEWc1FxIgBq4p1SNgMAAA==
X-CMS-MailID: 20250203144800epcas5p42bc46752c8353c2a34c7b7a6691a9d4e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----8pCVYZkCOGUjObx0wm0yJlGbi0Dl-Xo5m.-jYkYL.P4N.DQv=_2404f_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com>
	<20241128112240.8867-8-anuj20.g@samsung.com> <20250203065331.GA16999@lst.de>

------8pCVYZkCOGUjObx0wm0yJlGbi0Dl-Xo5m.-jYkYL.P4N.DQv=_2404f_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Feb 03, 2025 at 07:53:31AM +0100, Christoph Hellwig wrote:
> Hi Anuj,
> 
> I just stumbled over this patch when forward porting my XFS PI support
> code over the weekend, which failed badly because it didn't set the
> new BIP_CHECK_GUARD and BIP_CHECK_REFTAG flags.  Now for the XFS side
> that was just me being to lazy to forward port, but when I started
> looking over bio_integrity_add_page users as part of doing this I think
> I found a regression caused by this patch.
> 
> The scsi and nvme targets never sets these new flags when passing on PI,
> so that will probably stop working.  So we'll need to set them and for
> nvmet we could also improve the code to actually pass through the
> individual flags.  Note that this is just by observation, I didn't find
> time to actually set up the SCSI and NVMe target code with PI support.

Hi Christoph,

Thanks for sharing. Right, the target code is not setting these flags.
I tried to reproduce it by creating a target setup. nvme-tcp doesn't
support T-10 PI (it doesn't set the NVMF_METADATA_SUPPORTED flag).
nvme-rdma supports T-10 PI, trying to reproduce it there.

Something like this (compile-tested only) [1] could work for
nvme-fabrics. Will investigate more and test.

[1]

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index c1f574fe3280..a3152699b7de 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -210,6 +210,10 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 		return PTR_ERR(bip);
 	}
 
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
+		bip->bip_flags |= BIP_IP_CHECKSUM;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	/* virtual start sector must be in integrity interval units */
 	bip_set_seed(bip, bio->bi_iter.bi_sector >>
 		     (bi->interval_exp - SECTOR_SHIFT));


Thanks,
Anuj Gupta

------8pCVYZkCOGUjObx0wm0yJlGbi0Dl-Xo5m.-jYkYL.P4N.DQv=_2404f_
Content-Type: text/plain; charset="utf-8"


------8pCVYZkCOGUjObx0wm0yJlGbi0Dl-Xo5m.-jYkYL.P4N.DQv=_2404f_--

