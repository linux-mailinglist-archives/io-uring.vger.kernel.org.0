Return-Path: <io-uring+bounces-6274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18015A28A5D
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 13:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D771673F6
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524F821D5AD;
	Wed,  5 Feb 2025 12:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Da5XInYN"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55051151987
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738758927; cv=none; b=RjoxEjua0a8GvBCqeFPkK0cVoSGpLxKD2JgQo2d9deoOZjLCmCR6WCpHgOkxFo874BLRFl7q2gr2Q5+YYMqhaDjzuL3ZOqQxjhBF4B8az4tOqS6eOU12nZv6yPBbhWev9iyrk3xR8HtQzU9oPxGqEpzZBc2v3MbELUgvMIPJf1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738758927; c=relaxed/simple;
	bh=vXPUaXRhwSc0w98Bhb/lgKRgy81BGYtAixlspIMZ14E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=KYcq/m/ziKHarwGZHHWH7je/tN5oSnS+ER1X7XxvNkqwS0jXSZfhWXDoTygKxkNjZUOKfkeI/0a9b+WXbmUVPBEw9oHQRVKsZCtk4h0UsIngSogb6gkd9X6ffiAbBJC9z9HTq5S++ZN8xEd5PUqHedoOjcs/CC0yZnQ8T27K4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Da5XInYN; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250205122636epoutp02a512eda359156dc443641802c4d22c8f~hT4ykHvG40265602656epoutp02z
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 12:26:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250205122636epoutp02a512eda359156dc443641802c4d22c8f~hT4ykHvG40265602656epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1738758396;
	bh=OFXNe1O8H7u+VEHWybFlvY72xtEvNQblJAGg9yvCBQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Da5XInYNO4QRtc31pU0iHWRlKtF7oUWVl/bKQ/mlDuw80ksdnXhAj4AKS8Rs3Tp9U
	 ZhrmHCUYPsPd4fHCl6jUNeIlHcQ57iJsrxFSt5uGfqvKZ7NOkbyQFY5OcxnLVY2UaM
	 9OWPkoQIJo3vnUUeXmdTG5PjV/4ijzswXMqyV+fM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250205122636epcas5p1c4e24fc8327dff774be9c7231ce0a822~hT4yDsC3S1755017550epcas5p1L;
	Wed,  5 Feb 2025 12:26:36 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4YnzxQ1vl0z4x9Pt; Wed,  5 Feb
	2025 12:26:34 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.9A.29212.AF853A76; Wed,  5 Feb 2025 21:26:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250205115945epcas5p3fe280131617e4b986d93b618f7a68e90~hThVzYXPP2773727737epcas5p3c;
	Wed,  5 Feb 2025 11:59:45 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250205115945epsmtrp25acddee2195c7aa42dc3e72a28d4e07d~hThVyeLum1749417494epsmtrp2C;
	Wed,  5 Feb 2025 11:59:45 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-e5-67a358fa37d8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.9F.18949.0B253A76; Wed,  5 Feb 2025 20:59:45 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250205115942epsmtip2d33bc80b6db05cc115c8726412cee178~hThTa-h__2344223442epsmtip2O;
	Wed,  5 Feb 2025 11:59:42 +0000 (GMT)
Date: Wed, 5 Feb 2025 17:21:34 +0530
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
Message-ID: <20250205115134.GA16697@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250204053914.GA28919@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA03Tf0wTVwAHcN9dez3qas4K462OUc9lBBRspZRDQUlk7BJdRrJMkAW7E86W
	UdraH25zJmMiGjCKopNRqxQdMGDjpyIMqoYfMuWXk4wVE5AtdEQ2YMLYHBa2loPF/z738v2+
	H/fucFTswiR4us7MGnWMlsSEvMb24ODQ+aRrallJuZB6OvecR9kqGwFVNZyPUb+1zwBq6E4z
	QlVUdSLUVE4fj7pUmI1Qnf9OYlRB2yCgHI82Ua2OezyquMwloE791IRR5V2LCNW/0MWn+q02
	Qexautk6LKAHei10fWUuRjd89RndMpSF0U9dj3j0meuVgO6xdwjo2frX6PqxSSRBmJwRrWGZ
	NNYoZXWp+rR0nTqG3P2uapcqQimTh8qjqEhSqmMy2Rgybk9CaHy61nMcUnqY0Vo8QwmMyURu
	2RFt1FvMrFSjN5ljSNaQpjUoDGEmJtNk0anDdKx5m1wm2xrhCX6QobEPP0ANduJj9+QJkAWc
	ojzgg0NCAUsuLWB5QIiLiVYAS3OP8biHGQAvj7ej3pSY+AvAgsHwlUaN1S7gQg4AL7bO87jQ
	rwBaa/d4zSNeh9Ul83yvMSIIdoznAK99CRK6JnqBt4wSRSjsK76xVF5H7IP9i3UCr0VEKHSO
	TqCc18J7RWNLGR9iM6zpvLI0qR+xEd5p7EK8E0FiDIfOsw/53PbiYNHjfh7ndXCi67qAswTO
	Tjkwzmr4bMCFcDbA7Lu3AOedMOd+/tLCKKGBNrtruRsAv7hfjXDja+Dp52PLXRFsurJiEp6s
	sC0bQkdf1rJp+PfCCZR7XcUI/OZcP3IWBFpfOJz1hfU4b4b2lhnMCnCP18PyRZxjMKz5bosd
	8CuBhDWYMtVsaoRBHqpjP/r/ylP1mfVg6XsPSWgCVbULYW0AwUEbgDhK+oq6b9rVYlEa88kR
	1qhXGS1a1tQGIjzXdQ6V+KXqPT+MzqySK6JkCqVSqYgKV8pJf1F283G1mFAzZjaDZQ2scaWH
	4D6SLGRf4lBnNpNfVh+f4Y5GG5S3B6f5juMDVeNHXx5NL6ySgrrCtyJtp0PmU/zfi58U/T49
	siFxa8veb3W3vj6w8/2TtU6/ngdX/2lw/3AtQRbwdh3BXx2TapuO3R1T+qk7oEMSqwk4T+B1
	c9SN4B5w/qA4r/D2oTXr3aXbKzv8VlnfeCkpSBR0NPgiOVKd+Kzjl+E5t6rtkDB8anG/qOHV
	qcjylNyNm+CkMKXi2M8hCmlc4c0kFjsykqy9fHC6tED1x5/uwS/9e/d+ePjHx76wc/WTsm2K
	UsvD2Xe2bziw/8L3iVdfcb5Jt+TGn7obOD3b8/kT3arAkQv+87t2uEe7nZbm5DP+3aMkz6Rh
	5CGo0cT8B/dM+eV4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSvO7GoMXpBrMPMVl8/PqbxWLOqm2M
	Fqvv9rNZvD78idHi5oGdTBYrVx9lsnjXeo7FYvb0ZiaLo//fsllMOnSN0WLvLW2LPXtPsljM
	X/aU3aL7+g42i+XH/zFZnP97nNXi/Kw57A6CHjtn3WX3uHy21GPTqk42j81L6j1232xg8/j4
	9BaLR9+WVYweZxYcYff4vEnOY9OTt0wBXFFcNimpOZllqUX6dglcGU8abzAXPOCt+PUjoIFx
	I3cXIyeHhICJxPpZC9i7GLk4hAR2M0rMmbaXBSIhIXHq5TJGCFtYYuW/51BFTxglFl1/wwyS
	YBFQkVi38BcriM0moC5x5HkrWIOIgJLE01dnGUEamAVmM0u8nvAYrEFYIFKif/5tJhCbV0BX
	4saDV8wQUxczSfw5/BAqIShxcuYTsDOYBbQkbvx7CRTnALKlJZb/4wAJcwroSKw/Og9ssaiA
	ssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKj
	UktrB+OeVR/0DjEycTAeYpTgYFYS4T29fUG6EG9KYmVValF+fFFpTmrxIUZpDhYlcd5vr3tT
	hATSE0tSs1NTC1KLYLJMHJxSDUy5misV90W9mNEzz7xhq0LYy+tLvqjsUN/rUJ+xZ/denzUb
	3lxJOf6sxODWDrb7i57oMhf2tXDWC+olBKp2h2vETlhwr/PfFeFi19dJjSGXLC8pLrdftu15
	dFuS9DFxbUldpiuF3r8uFndwmMTXiay66RHfObeViV1aJaH4zAS5bZ8rfosl/spe1H45Ueqx
	RGWhl7cUf02m0nVlfYmtO/9UzL12tfHSS+H3vRbls3/JW54r2Wekk1mStXvRsVM7ZSZfl37r
	80JSXYl791r2RsfZEmy5hW1fOSx6JA231f4RYd+YXl5gLLWxJu7J03USK358SY436n2xPkYn
	5s+fi1WvZHYJR83Ovj1PmMv6kBJLcUaioRZzUXEiAHPBooI5AwAA
X-CMS-MailID: 20250205115945epcas5p3fe280131617e4b986d93b618f7a68e90
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----knAlFONTECbX-FcfvlefBkarukSN3r7qQKLuxxl86w44aglH=_2dec9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113112epcas5p186ef86baaa3054effb7244c54ee2f991@epcas5p1.samsung.com>
	<20241128112240.8867-8-anuj20.g@samsung.com> <20250203065331.GA16999@lst.de>
	<20250203143948.GA17571@green245> <20250204053914.GA28919@lst.de>

------knAlFONTECbX-FcfvlefBkarukSN3r7qQKLuxxl86w44aglH=_2dec9_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Feb 04, 2025 at 06:39:14AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 03, 2025 at 08:09:48PM +0530, Anuj Gupta wrote:
> > +	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
> > +		bip->bip_flags |= BIP_IP_CHECKSUM;
> 
> We'll also need to set the BIP_CHECK_GUARD flag here I think.

Right, I think this patch should address the problem [*]
I couldn't test this patch, as nvme-tcp doesn't support T10-PI and so
does rdma_rxe. I don't have rdma h/w to test this.
It would be great if someone can give this a run.

[*]

Subject: [PATCH] nvmet: set bip_flags to specify integrity checks

A recent patch [1] changed how the driver sets checks for integrity buffer.
The checks are now specified via newly introduced bip_flags that indicate
how to check the integrity payload. nvme target never sets these flags.
Modify it, so that it starts using these new bip_flags.

[1] https://lore.kernel.org/linux-nvme/20241128112240.8867-8-anuj20.g@samsung.com/

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index c1f574fe3280..4bab24bcd6e8 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -210,6 +210,10 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 		return PTR_ERR(bip);
 	}
 
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	/* virtual start sector must be in integrity interval units */
 	bip_set_seed(bip, bio->bi_iter.bi_sector >>
 		     (bi->interval_exp - SECTOR_SHIFT));
-- 
2.25.1

------knAlFONTECbX-FcfvlefBkarukSN3r7qQKLuxxl86w44aglH=_2dec9_
Content-Type: text/plain; charset="utf-8"


------knAlFONTECbX-FcfvlefBkarukSN3r7qQKLuxxl86w44aglH=_2dec9_--

