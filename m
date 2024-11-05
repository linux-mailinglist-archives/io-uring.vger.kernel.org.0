Return-Path: <io-uring+bounces-4459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAD39BD10F
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 558AB1F23A7A
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 15:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8837114E2DF;
	Tue,  5 Nov 2024 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e9EdpSwo"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B08A13AD39
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821904; cv=none; b=t2PIf00R5BH4H320JdP3npFO9bJ3mbkY1P04qCEl0K2MkfZdSXW5XPW9lEVm+GOHhCE+toO3a11wZLR4A4IHevg13TZ6VcRulPHDRdoK1o/rcO9O7LwqcOvJaDFQr4q+GuaKtQpkrT6NZRlMc+5drxkrZykmAMWQJEwctsTLml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821904; c=relaxed/simple;
	bh=WZX+m/q8IQskzrinlGvdzepQLGy7nJ1HziizUY98qNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=TXS3NmpNfivS+2BCDCxK+AHHsCDSFkFNugE0rTByAoiitKHjNZKidiEtMouKj94mff1Xnkjiw3zRPCfkD5p8jxl689jd7RUOgrcb8q7vIgHfF2GmvnKu6awGFPMl21eiocDVKitJn82nLB9MQ83viCjViZKnzNCZ6YJ2aluzmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e9EdpSwo; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241105155133epoutp0291819da6a69f205e275f77d547bfb15c~FHVeNVxTe2978129781epoutp02J
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 15:51:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241105155133epoutp0291819da6a69f205e275f77d547bfb15c~FHVeNVxTe2978129781epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730821893;
	bh=0dRFIBPa8OwMlkhEGEGLngcmScmSlxQYXv2XXGiVABE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=e9EdpSwoZ7epWSCkGv3LUu2CnMALWPTZIHBe0nEebHZNc3uLIvtW5Uwyrh/2XW89z
	 zHFkqfnl/Nu056G/o5mtrR93IwPAnM9EP2QeTpTuTWid0zGD1dV/dGgrOG4CND51xI
	 zZzwbxz32nAM1dqS/Qtyrrgk+6GdRi60RsjWLaKA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241105155133epcas5p327a07412c788e3b0d2073ea64f0f6063~FHVdxu7nz2700527005epcas5p3U;
	Tue,  5 Nov 2024 15:51:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XjXrM4GvPz4x9Pp; Tue,  5 Nov
	2024 15:51:31 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D4.90.08574.30F3A276; Wed,  6 Nov 2024 00:51:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241105155130epcas5p14debaedbefe85fcba48cf256614df370~FHVbmqFKP0784807848epcas5p1t;
	Tue,  5 Nov 2024 15:51:30 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241105155130epsmtrp22f9e92b23d807e8d9172efaf859e54ff~FHVbl7gBF1464614646epsmtrp27;
	Tue,  5 Nov 2024 15:51:30 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-1e-672a3f03ef2a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	68.58.18937.20F3A276; Wed,  6 Nov 2024 00:51:30 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241105155128epsmtip23fc16e32dc8d09d9794e8e74d0234769~FHVZPL2PG2285722857epsmtip2V;
	Tue,  5 Nov 2024 15:51:28 +0000 (GMT)
Message-ID: <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com>
Date: Tue, 5 Nov 2024 21:21:27 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Christoph Hellwig <hch@lst.de>, Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241105135657.GA4775@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTZRzved932wvnupeJ7ZFMx86rwBuyGuOdgRRy+CpeUVzHpRG+By8D
	97P9MPU6XTPQwACthMbvwlAs0eER49flsJZXBFydwpIkGHWy8G5gnYjMtr2z+O/zfL+fz/P5
	/ngeHBVMcWPwEq2JMWhptZgbiXUNxsVL0LR4ZWLr6DrS9/cSRlqrl1Gyvr0LkOcnqrikd3Ae
	kOPfOBDy3PlvEfJO6U8YWVdzFCFPOa8Dst+9iezrv4aRTV/M8MiKG91css3lR8jhZReHHLbV
	816Mohy2CR7185CZsrd/wKU6W49QveMWLuWbcWNU5eV2QP3YfJVHLdjXU3bPHJIduVuVUszQ
	hYxBxGgLdIUlWmWqOCsnf1t+kjxRKpEqyGSxSEtrmFRxxq5sSWaJOtCOWLSfVpsDoWzaaBRv
	3ppi0JlNjKhYZzSlihl9oVov0ycYaY3RrFUmaBnTFmli4nNJAeJeVbH/6H1E7+Qf+OOfDq4F
	9ESWgwgcEjJY++AWWg4icQHRC2DTdR8WTAiIeQDvueVsIoBHRiqQR4o6fwuXTTgA/HLhfcAe
	5gDsOXM7JOcTW2Gp1RdSYMRGeOWsh8PGo+C1Tz0hzhpiA7zlruUF8WoiH7a1uAJxHI8mMuHd
	5ieCd6KEBYW9jvkQByWE0O1pQoIcLhEHRz4yB8MRxCY43vswTNkAv56rD7UDibs4LL3nDFed
	Ab879j1g8Wo467rMY3EMXLjTz2WxCk5OTWIsfhd2d1ZyWJwGLQ/GOEFfNODb0bOZ9Xocfrjk
	CZUDCT48XiZg2bHwt1MzYaUQ/l7bGsYUPHfxTHhugwgc7/oMqwYi24qp2FZ0aVvRju1/52aA
	tYO1jN6oUTIFSXqplnnnv30X6DR2EHrs8RndYKzJn+AECA6cAOKoOJrfyDyjFPAL6YOHGIMu
	32BWM0YnSAqs5yQas6ZAF/gtWlO+VKZIlMnlcpnieblULOR7SxsKBYSSNjEqhtEzhkc6BI+I
	sSCm3FWtI33Em3zfjrypsgsZuTuQOGqx+qk/3xK+INup1bw9PdCdt+3lXCtVbbJ2ES7Hky9d
	tGqGemZT7T94KvY4XrPWXLhvS//4QMuuqhM1fcfI6Uv46dL9yHtTE94B3tDr+/b29AtkB9FR
	NHZdGp2q2pJwO8c5U5l8cxWuWhQmTzpVlkb7XGd6w5VMTlaRShjV4Za8MnDz6dhD2+NTnvUL
	OfO/Lqrp0a+I2T3DaxubRW/oJJUpI73b/2qoKr/EHy96tS/dXjL7i6Iu+/P03Rsf5iiWvaOP
	8RY8/sOOjpKTSf15bYfX+yL2lUUvqLOK5o5f/WSp74bXM2aXH2mddp8dIsWYsZiWxqMGI/0v
	g62UM3UEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWy7bCSvC6TvVa6wYknehYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEr41/zL6aCQ7wVz76tZ2tg
	3MXVxcjJISFgIjH730K2LkYuDiGB7YwS6x+9ZoZIiEs0X/vBDmELS6z895wdoug1o8SWLweY
	QBK8AnYSrU0fwWwWARWJgyuesELEBSVOznzCAmKLCshL3L81A2yQsEC8RPPEJUALODhEBNwk
	viwQA5nJLNDALLFl3k8WiAWHmSTmzlsINpQZ6IpbT+YzgTSwCWhKXJhcChLmFNCWuLn7PztE
	iZlE19YuRghbXmL72znMExiFZiE5YxaSSbOQtMxC0rKAkWUVo2hqQXFuem5ygaFecWJucWle
	ul5yfu4mRnD8agXtYFy2/q/eIUYmDsZDjBIczEoivPNS1dOFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamBSe627rufBsUf2mzqsybGIHV/LKMG9heuHx
	roYvSbfhdMWR48Y2b+ZyeOrNr5yu8OMr55N36dMnXBVfGfPkdGrAplVKNtEHUswee/Y3TIoS
	q3biYlwe/9hLLGy+443+L6Lejacc7/q0lDda7TlYf9ZA1vRFyrzCrgMzyos/Pkqt2Dp3/e2b
	HmyPHkldldZ7d6lxQvuFnl2Pbre9ay6oMfjabqcc/2XmuRWlkQfP6G5pzL5kuXPZyV27grZ5
	L9uyaP0WjjWq9znmbz2iyHw/q/n4vLlHmsqsllj27Xohe7w1bUatd5Oc49LDnhqLNx/7XuPg
	JVO+YdmN9/pummFbv3k+V3jM1x2dWSiqPtFye48SS3FGoqEWc1FxIgDspQG2TgMAAA==
X-CMS-MailID: 20241105155130epcas5p14debaedbefe85fcba48cf256614df370
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com>
	<20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de>
	<CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
	<20241105135657.GA4775@lst.de>

On 11/5/2024 7:26 PM, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 06:34:29PM +0530, Anuj gupta wrote:
>> The field is used only at io_uring level, and it helps there in using the
>> SQE space flexibly.
> 
> How so?  There is absolutely no documentation for it in either the
> code or commit log.  And if it is about sqe space management, meta_type
> is about the most confusing possible name as well.  So someone please
> needs to write down how it is supposed to work and come up with a name
> that remotely makes sense for that.

Can add the documentation (if this version is palatable for Jens/Pavel), 
but this was discussed in previous iteration:

1. Each meta type may have different space requirement in SQE.

Only for PI, we need so much space that we can't fit that in first SQE. 
The SQE128 requirement is only for PI type.
Another different meta type may just fit into the first SQE. For that we 
don't have to mandate SQE128.

2. If two meta types are known not to co-exist, they can be kept in the 
same place within SQE. Since each meta-type is a flag, we can check what 
combinations are valid within io_uring and throw the error in case of 
incompatibility.

3. Previous version was relying on SQE128 flag. If user set the ring 
that way, it is assumed that PI information was sent.
This is more explicitly conveyed now - if user passed META_TYPE_PI flag, 
it has sent the PI. This comment in the code:

+       /* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
+       union {

If this flag is not passed, parsing of second SQE is skipped, which is 
the current behavior as now also one can send regular (non pi) 
read/write on SQE128 ring.







