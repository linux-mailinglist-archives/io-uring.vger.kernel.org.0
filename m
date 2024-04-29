Return-Path: <io-uring+bounces-1667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7948B5711
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 13:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A9D91C21736
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 11:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A24482DF;
	Mon, 29 Apr 2024 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SHVchpRV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B953C47F72
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714391237; cv=none; b=gZkYs/k6gAUAOk1bwU3LOzqvFjwJHQtXXU5EUAqLt9WIvs27N0u2U6F/4e7VYqtOy3L8Ddpfn7LFEmLja7giOjne9Mqivyokw51FKP9Xd8IBWqJnFRIYL665eZ5m8fNi+AY5VYwOWzar3WxW7Ol0T7HJZds9shUiCLkTNlaJVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714391237; c=relaxed/simple;
	bh=uZWSyroDHXmxIZLuYMrP3nLz4/FpZPL4XpmE8YSoKv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=V+foeFwJBsqQFV6jS/a+/NONG3h6Pj6UnF+M5r1PS2Hl0py9f6SJMmFgfLmuBxluszeYD6B0KJOrmMWjvoNKeoLrcGUnUItPRzbdVT71ERE7TiifSKtA4gCDcbzDnUR3k/lB4OCbUshZCuqi5BVWtUJNDScqFQqVO5Gbvmrq6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SHVchpRV; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240429114711epoutp029c0d2e3d859e62082a3d30caae71e0b8~Kvb4FXzNg0234902349epoutp02H
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:47:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240429114711epoutp029c0d2e3d859e62082a3d30caae71e0b8~Kvb4FXzNg0234902349epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714391232;
	bh=+0XhRoGE1qPFbsa9fpNYLOfvFVjRjsIUSKulInZuNas=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=SHVchpRVv+87uPt+4nWISGyA97mff9dyU8vgHnQ4kI+vuDpLAhdTVNNA+zCUHbyoO
	 B6HUA8rEmKvURyVIxRc9Z31OmrOzdkRwkzwvoEYLA7Ub7b1db++TQ/WR86pqm9x2EE
	 WBzvLznt7f94HN9Fid8RScLvGMd7Yl3r2WymDqNU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240429114711epcas5p1b423bbbd09b8f8244344da8954c4392d~Kvb3fqGqr2009320093epcas5p17;
	Mon, 29 Apr 2024 11:47:11 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VShQ61R6xz4x9Px; Mon, 29 Apr
	2024 11:47:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AD.D4.09666.EB88F266; Mon, 29 Apr 2024 20:47:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240429114709epcas5p26c338ab76152b8a5d129144a9e58caef~Kvb16Fndh2821028210epcas5p2m;
	Mon, 29 Apr 2024 11:47:09 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240429114709epsmtrp21fc1f57df3e9cc3c276093230e110bdb~Kvb15abvK0750207502epsmtrp2L;
	Mon, 29 Apr 2024 11:47:09 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-6b-662f88be12f2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	BF.69.19234.DB88F266; Mon, 29 Apr 2024 20:47:09 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240429114707epsmtip1a4bade1605d78db6ddc0eb14c0b8e031~Kvb0PT69p2805728057epsmtip18;
	Mon, 29 Apr 2024 11:47:07 +0000 (GMT)
Message-ID: <2f70941e-2a46-8e58-bb5f-97e9b8fccdda@samsung.com>
Date: Mon, 29 Apr 2024 17:17:06 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 09/10] block: add support to send meta buffer
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ZivGhB0rGwBb8Eic@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmpu6+Dv00g0WXOCyaJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvFpEPXGC323tK2mL/sKbvF8uP/mBx4
	PK7NmMjisXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1ZxejxeZNcAGdUtk1GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
	4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMb3d3MBds
	Zqq4tG0rewPjd8YuRg4OCQETiX+bnLsYOTmEBHYzSjx/otTFyAVkf2KU+LL8Nzucc7xzAwtI
	FUjDrpON7BAdOxklvl4qhSh6yyjxeOJTNpAEr4CdxPzZe8FsFgFViX2/drJCxAUlTs58AjZI
	VCBZ4mfXAbAaYQFHiQ3rN4LZzALiEreezGcCsUUElCXuzp/JCrKAWaCfSeJo3zcmkLPZBDQl
	LkwuBanhFLCXaOnsZYXolZfY/nYOM0i9hMAJDomV+56xQVztIrFh70NmCFtY4tXxLewQtpTE
	53d7oWqSJS7NPMcEYZdIPN5zEMq2l2g91c8MspcZaO/6XfoQu/gken8/YYKEIq9ER5sQRLWi
	xL1JT1khbHGJhzOWQNkeElOPPoMG6HtGiXkLe5gnMCrMQgqWWUjen4XknVkImxcwsqxilEwt
	KM5NTy02LTDMSy2HR3dyfu4mRnBq1vLcwXj3wQe9Q4xMHIyHGCU4mJVEeDfN0U4T4k1JrKxK
	LcqPLyrNSS0+xGgKjJ+JzFKiyfnA7JBXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZq
	akFqEUwfEwenVAPT+quLfy8x837Qvzkg4svfudUx7Ge9pkzpKX+8uo1jyayF4X8j1wvscvXM
	tvRaIOJYzbr78dr7gmdvLpM6/Ujbwl76p5lEZ13DW4uVMwuP9aTHFt0yWu88PSlJsHhbarvK
	Rk795+b87wO9chtsZl6q/P/+lcSE5Ij//Pbcd6Lvhh5ssn4vOde9XyQpyOf4R+ttwidvHrB4
	WXRzorzK2RVKFXqfDofbxnzZvGtu2vmMavkzO6LnH1XcYbjldrBk7MKsuOaQxw2HrJeG1r7i
	3mB5Re7JKZtFG01FvmxZenKxpvEb57Te2e6nfunEVnZfcNh/bdmc+LmmkysZCrT+b5+oytC2
	8/8+sQn3q3z1nS7vVmIpzkg01GIuKk4EALHUnPtWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSnO7eDv00g0snVCyaJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvFpEPXGC323tK2mL/sKbvF8uP/mBx4
	PK7NmMjisXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1ZxejxeZNcAGcUl01Kak5m
	WWqRvl0CV8a3uzuYCzYzVVzatpW9gfE7YxcjJ4eEgInErpON7F2MXBxCAtsZJTru7WeGSIhL
	NF/7wQ5hC0us/Pccqug1o8TuX7NZQBK8AnYS82fvZQOxWQRUJfb92skKEReUODnzCViNqECy
	xMs/E8EGCQs4SmxYvxGsnhlowa0n85lAbBEBZYm782eygixgFuhnktj4fgcTxLb3jBL79k0E
	ynBwsAloSlyYXArSwClgL9HS2csKMchMomtrFyOELS+x/e0c5gmMQrOQ3DELyb5ZSFpmIWlZ
	wMiyilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM4CrWCdjAuW/9X7xAjEwfjIUYJDmYlEd5N
	c7TThHhTEiurUovy44tKc1KLDzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGpi0vQUb
	5Cam20azzvrmfvMta+6kp0Y3V3Pw7HoRY5Evsq6Y5Uijz/rZJ1rfMNpM2cL+Jo1ZNejzncJv
	lyotjb5N7vz4+bAm/zWB8oy4neKSs8SmbZwp0WQloRx128vD9MLcO4fnTLR4KfThTNrbeJPK
	W49yo+dMyK64UK4w1XdHv33Z/H2pklZFi/+1Xvj8SeUz8+vVp3iEUliUbso/jry/K+bn0+h7
	d8LPd+Q+e9cbKPeQs9sydGlV+cJFj24fcLprdOPjkgN3X7NoCFsJbCs5L9I06+W5Q2+Xqzr8
	Dzk1a6FM5+IzBvKRU+MtmP2Wsk/XON+swWvB2OI151JPhJkWOw9n+vmpORYXHXoC2R2VWIoz
	Eg21mIuKEwENPLVuMQMAAA==
X-CMS-MailID: 20240429114709epcas5p26c338ab76152b8a5d129144a9e58caef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184708epcas5p4f1d95cd8d285614f712868d205a23115
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184708epcas5p4f1d95cd8d285614f712868d205a23115@epcas5p4.samsung.com>
	<20240425183943.6319-10-joshi.k@samsung.com>
	<ZivGhB0rGwBb8Eic@kbusch-mbp.dhcp.thefacebook.com>

On 4/26/2024 8:51 PM, Keith Busch wrote:
> Should this also be done for __blkdev_direct_IO and
> __blkdev_direct_IO_simple?


Right, this needs to be done for __blkdev_direct_IO.

But not for __blkdev_direct_IO_simple as that is for sync io. And we are 
wiring this interface up only for async io.

