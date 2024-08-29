Return-Path: <io-uring+bounces-2975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD200964178
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 12:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FC8528224F
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 10:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7536818EFC0;
	Thu, 29 Aug 2024 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="syqWtkHI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF0018E049
	for <io-uring@vger.kernel.org>; Thu, 29 Aug 2024 10:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926735; cv=none; b=n8h+nUy7wrZxBtdeWO2svzefERdYMXkt7dEQcLUBmuFK1+GZRps3N23Hi+sCZ8fEtB6pXzaNCNOKTjMFm1IUbfDNq1qauup3aFPYlld0Ebb058prBssdFFijPKIhVI7e4c0RVQVZZ2YAZteHAUtR+cWF35asjhyf7+/Gbr841jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926735; c=relaxed/simple;
	bh=uVn9xh5ed7sIutzt3gisZrKdxjbUWePB7MHJXjJMF78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=M4brWq+n0kgeB6S129srgfaxX3++PQLPGDYArM6MIEOBGxIsMHfKIBp8IGzISH3y3uqNinu55XttwjFCbGqNQ4Y64u0asW1X1gbvnIU3Ut1uotbDpri7puz31QaF0BI0hp25lS/zTOGvpR9ZSeurFPVJ966ieQvc/de5eKo7zsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=syqWtkHI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240829101850epoutp048a466fae7ed742a95e0f566d053cb41d~wK7j7-tIw3244032440epoutp04j
	for <io-uring@vger.kernel.org>; Thu, 29 Aug 2024 10:18:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240829101850epoutp048a466fae7ed742a95e0f566d053cb41d~wK7j7-tIw3244032440epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724926730;
	bh=hSzswj1NNsgnJo6oCya0ujyGaZeNMIhhqc23NKTmwJk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=syqWtkHIefmjlpjo4k0oVuZM6bmrnitTv+blDCxurASIavzvuO73xT1HZUs3VV73A
	 GZ1svIuyi/bJU5mZxmucatYSpjGN0L51lfAXX9rJbOvULPoMbbndmh9SmIp04CE2lm
	 yrpJj8PLBSNCqjiqtz6E8rG20Y65YJvGihYQ7a/s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240829101850epcas5p37173ce4ff9649c3c3eb6126b19dd3aba~wK7jZb_8T0999309993epcas5p3V;
	Thu, 29 Aug 2024 10:18:50 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Wvcgr3LPTz4x9Pv; Thu, 29 Aug
	2024 10:18:48 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9C.45.09743.80B40D66; Thu, 29 Aug 2024 19:18:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240829101847epcas5p134da1e20a99136599a6c6f9000b1ed56~wK7hV62-_0719907199epcas5p1q;
	Thu, 29 Aug 2024 10:18:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240829101847epsmtrp26ed6682a8130a00ada0c2bb700f9b842~wK7hVOniN1264412644epsmtrp2T;
	Thu, 29 Aug 2024 10:18:47 +0000 (GMT)
X-AuditID: b6c32a4a-14fff7000000260f-4a-66d04b08e0c5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9F.04.07567.70B40D66; Thu, 29 Aug 2024 19:18:47 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240829101845epsmtip11c65f782df2f666bbea63fd929e0a1ec~wK7fKRtui2260422604epsmtip1S;
	Thu, 29 Aug 2024 10:18:45 +0000 (GMT)
Message-ID: <efe8215a-9b02-9dfe-db84-988e15d4abcf@samsung.com>
Date: Thu, 29 Aug 2024 15:48:44 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 09/10] nvme: add handling for app_tag
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
	krisman@suse.de, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <yq1cylsc9w2.fsf@ca-mkp.ca.oracle.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmhi6H94U0g0UtYhZNE/4yW8xZtY3R
	YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFabD+zlNli7y1ti/nLnrJbdF/fwWax/Pg/Jgce
	j52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8eovFo2/LKkaPzaerPT5vkgvgjMq2yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6V0mhLDGnFCgUkFhc
	rKRvZ1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQndH4ZjljQS9b
	xexHt9gaGJ+xdDFyckgImEjc7t7G2sXIxSEksJtR4tqx+cwQzidGiUnnmqAy3xglpr15ANdy
	feIjJojEXkaJF/e2sUA4b4GqFq8CauHg4BWwk3izwBCkgUVAVeL29qtsIDavgKDEyZlPwAaJ
	CiRJ/Lo6hxHEFhawkTg7exs7iM0sIC5x68l8JhBbRCBKom3RVDaQ+cwCrxglPvW1sIPMZxPQ
	lLgwuRTE5BQwltj+mAmiVV5i+9s5YB9ICJzhkJizbgoLSI2EgIvEwrteEPcLS7w6voUdwpaS
	+PxuLxuEnS3x4BHMjzUSOzb3sULY9hINf26AfcUMtHX9Ln2IVXwSvb+fMEFM55XoaBOCqFaU
	uDfpKVSnuMTDGUugbA+Jqyvugm0SEnjKKLH2lfMERoVZSGEyC8nvs5A8Mwth8QJGllWMkqkF
	xbnpqcWmBUZ5qeXw2E7Oz93ECE7LWl47GB8++KB3iJGJg/EQowQHs5II74njZ9OEeFMSK6tS
	i/Lji0pzUosPMZoCI2cis5Rocj4wM+SVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliSmp2a
	WpBaBNPHxMEp1cA0u1Hdy+66E4/8Od/63EMTpks6mVtp5rX6bDzF+Mja3fGl8aGPgXcX7b22
	9NvZF20iS5gmymk+fC278HTDCaW/NzXyzD6eeH8kJ/+vi4jV9CKl+RvXGi4K83V+6aks97Vi
	q7b2jn8Xp4n4vefXifsSEtXYPTGHPdeL/8TW5dWdX2ZF2ui8Lzl9fMPc5C+TmL0OXjmxcEbr
	h7dvl7zV0ajtet+uJvoq25RldkvDujcMS3Yo5a8r+lwiXcW8hVfaI/aoc5Gbgam0bLaozXLh
	U/umr+aa73Sv807p/Unm32p2z45nnf6YI2Jpx+Krz79pLLCsdFs10zq5Srha7sFXE853+eYX
	LfccDJwqt6V/17SLSizFGYmGWsxFxYkA8c0BgVQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSnC6794U0g8XnzS2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mW
	WqRvl8CV0fhmOWNBL1vF7Ee32BoYn7F0MXJySAiYSFyf+IgJxBYS2M0o8fe0PERcXKL52g92
	CFtYYuW/50A2F1DNa0aJBTf/snYxcnDwCthJvFlgCFLDIqAqcXv7VTYQm1dAUOLkzCdg80UF
	kiT23G8Emy8sYCNxdvY2sJnMQPNvPZkPFhcRiJJ4sKSTDWQ+s8ALRol5ez8wQSx7yigx69kE
	RpBlbAKaEhcml4KYnALGEtsfM0HMMZPo2trFCGHLS2x/O4d5AqPQLCRnzEKybhaSlllIWhYw
	sqxilEwtKM5Nz002LDDMSy3XK07MLS7NS9dLzs/dxAiOQi2NHYz35v/TO8TIxMF4iFGCg1lJ
	hPfE8bNpQrwpiZVVqUX58UWlOanFhxilOViUxHkNZ8xOERJITyxJzU5NLUgtgskycXBKNTBN
	nyfvt1n55OLV3HrZvTevPJBZN1//xqvw/jv625wq8rfaFqXn5p/X6Dnuabf0u2Jie+bsK4su
	XPASfHLb7rab9eNXK3+bnFY+aXYlOUJSamXdqidiy9L5uGNrZLcxemXNCP3vsS80md26fsmc
	2MqnixydJxvO9XrGET9F2ubt0b8H+09edtssIqdX8/xi+aGb63b4rtFN/nzH65khw5XVkzew
	nrP4lqug8floycdjrq5X5p9yP36kbj+7wpHI+/m212++uM13as4uvdDtubtYmUpCF+yL9576
	XWn7JRPL9Bguf7/fE5K3XfuaEPI75JR9bznPw0MybUsu8P7fcMKe6ScbN78pK48472sJ5a/y
	SizFGYmGWsxFxYkA4XW2aDEDAAA=
X-CMS-MailID: 20240829101847epcas5p134da1e20a99136599a6c6f9000b1ed56
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104636epcas5p4825a6d2dd9e45cfbcc97895264662d30
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104636epcas5p4825a6d2dd9e45cfbcc97895264662d30@epcas5p4.samsung.com>
	<20240823103811.2421-11-anuj20.g@samsung.com>
	<yq1cylsc9w2.fsf@ca-mkp.ca.oracle.com>

On 8/29/2024 8:30 AM, Martin K. Petersen wrote:
> 
> Anuj,
> 
>> With user integrity buffer, there is a way to specify the app_tag. Set
>> the corresponding protocol specific flags and send the app_tag down.
> 
> This assumes the app tag is the same for every block in the I/O? That's
> not how it's typically used (to the extent that it is used at all due to
> the value 0xffff acting as escape).
> 

NVMe spec allows only one value to be passed in each read/write command 
(LBAT for write, and ELBAT for read). And that's what controller checks 
for the entire block range covered by one command.
So per-io tag rather than per-block tag. The integrity buffer creator is 
supposed to put the same application-tag for each block if it is sending 
multi-block IO.

