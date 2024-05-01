Return-Path: <io-uring+bounces-1700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D4E8B8ADB
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 15:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEE251F22B1D
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 13:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD9612BEBE;
	Wed,  1 May 2024 13:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ShtHTO3w"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D748CE0
	for <io-uring@vger.kernel.org>; Wed,  1 May 2024 13:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714568581; cv=none; b=cZE5wNYcYPHUVbtzxkUAO1bX4DtXVtUAyqMNu5kJXZOlgUTCf3B9iIHgNw0ctapo7RLsPTOMFwbQkypz9CHSnojaeMeAu//JXLXuh0HCycBR/5FUYceBFL6KUqmqoOJZobvlwL9jTNHf4k88zxrLA1VLWLFw/RUJkqILiMbng+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714568581; c=relaxed/simple;
	bh=e7WlsEVs8y9JfMrLTeMdhRqa3HnHxQwE2pnPEj/p5Fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=YqRe7JkJ2G8ql2SQM1lhZj0XUCpuoRvBm/ks1X8tn+pI/xwEn8E6UnVVwyrddQ2NYeJTSm4td40cc4LPiDY9cfu8eP8QWQkZvDT/VBDqSp0kMcpupUxVoxG3b6m33VeWSYBRPc6dgOK1acszTfU+ThcVz0oio9vU2JCu3sPB/CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ShtHTO3w; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240501130250epoutp045a60482e3b3bcab2792f0fec77e702b4~LXwfZ7CgY3164431644epoutp04W
	for <io-uring@vger.kernel.org>; Wed,  1 May 2024 13:02:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240501130250epoutp045a60482e3b3bcab2792f0fec77e702b4~LXwfZ7CgY3164431644epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714568570;
	bh=ts5/PQQxoYzCnt9UpQpvjostlawKW54bYVKKXkC70bw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ShtHTO3wH5mjc/BOM+3BArrQbkYdxhyQtFrc72cfWIKf2JXUY8VGSCSrGiK7yHtxH
	 5GUPv0tHuklwMVohhMSZ5xe0OgJCfszt1V5/ddL3FAudn8IL0NPJNfsNOLupeFqQ2B
	 irDM+JdsOVjlAl3oTmz9w+YG3uSe2q+3EQqMwrek=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240501130249epcas5p4ef1abcc4e2285904cb8902d940320aeb~LXwe7qO1z3209832098epcas5p4e;
	Wed,  1 May 2024 13:02:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VTy0S1swlz4x9Pt; Wed,  1 May
	2024 13:02:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.72.09665.87D32366; Wed,  1 May 2024 22:02:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240501130247epcas5p3e44f8af41cdf1767853e0f4e6985e013~LXwc_VT7b0981309813epcas5p3A;
	Wed,  1 May 2024 13:02:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240501130247epsmtrp1da9d19b03103afb9e8c6ef249ecd5dcf~LXwc9NDGS2658926589epsmtrp1U;
	Wed,  1 May 2024 13:02:47 +0000 (GMT)
X-AuditID: b6c32a4b-5cdff700000025c1-a6-66323d78d635
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.08.07541.77D32366; Wed,  1 May 2024 22:02:47 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240501130245epsmtip112ff708b1ba8feb4c8b34c6907ecf4f4~LXwbO3r731216112161epsmtip1b;
	Wed,  1 May 2024 13:02:45 +0000 (GMT)
Message-ID: <ebeca5f1-8d80-e4d4-cf45-9a14ef1413a5@samsung.com>
Date: Wed, 1 May 2024 18:32:45 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec incase
 of cloned bio
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240429170929.GB31337@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmlm6FrVGaQe8CboumCX+ZLeas2sZo
	sfpuP5vF68OfGC1ezVjLZnHzwE4mi5WrjzJZvGs9x2Ix6dA1Rou9t7Qt5i97ym6x/Pg/Jgce
	j2szJrJ47Jx1l93j8tlSj02rOtk8Ni+p99h9s4HN4+PTWywefVtWMXp83iQXwBmVbZORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLCSQlliTilQKCCx
	uFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj+7sTrAVP
	OCom7jvD0sD4na2LkYNDQsBEYu7qsC5GLg4hgd2MEutv/2KHcD4xSkxcvI0ZwvnGKLFvwkbG
	LkZOsI4Xr2awgdhCAnsZJZ5ciYEoesso8fLFMhaQBK+AncTEnm6wIhYBFYlHiw8yQ8QFJU7O
	fAJWIyqQLPGz6wBYjbBAjMT219PB4swC4hK3nsxnArFFBJQknr46ywiygFlgGpPE2p6pLCB3
	swloSlyYXApSwymgI9F45wobRK+8xPa3c8CulhA4wyFx5fVJVoirXSSWrdgLZQtLvDq+hR3C
	lpJ42d8GZSdLXJp5jgnCLpF4vOcglG0v0XqqnxlkLzPQ3vW79CF28Un0/n7CBAlGXomONiGI
	akWJe5OeQm0Sl3g4YwmU7SHx89FEaOiuZ5LYcu0N0wRGhVlIwTILyfuzkLwzC2HzAkaWVYyS
	qQXFuempxaYFxnmp5fD4Ts7P3cQITs5a3jsYHz34oHeIkYmD8RCjBAezkgjvlIX6aUK8KYmV
	ValF+fFFpTmpxYcYTYHxM5FZSjQ5H5gf8kriDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnN
	Tk0tSC2C6WPi4JRqYLo5+6BUqUTENcmcWP+pKmdkz+c0lGiJLBd8tXlq9hndrr+n+A69uGWo
	k1bOVefYcHzOjvlT/r+rumu6+ebkCVckV5aHRzpOYam95abrK20V2Cszo/TjxLu33eetXyVt
	rSI93zlKVvttoKjakzfCHZtiM+IuVxecVWh7ITt5a9jVmsL5Aiu6vzP/rAl3cK6YGRUuslV6
	YZ54XHb2P2e7uL+XndN83vDNZrpxWpLTYkqvvpVtRdSuih+CIowT+g65vGEXf1l3xDHL23P1
	2j/Ghn+22biH3noicyD//YWPB7ZOfHjrsIHoD54p2z/rHGaMLO1cH3FD7qGdY6/q74w9Dwy1
	f/VZe7pLSUTvfPhMSYmlOCPRUIu5qDgRAADO+rFXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnG65rVGawdttOhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDOKyyYlNSez
	LLVI3y6BK+P7uxOsBU84KibuO8PSwPidrYuRk0NCwETixasZQDYXh5DAbkaJzVN2sUMkxCWa
	r/2AsoUlVv57zg5R9JpR4uytG8wgCV4BO4mJPd1gk1gEVCQeLT4IFReUODnzCQuILSqQLPHy
	z0SwQcICMRLbX08HizMDLbj1ZD4TiC0ioCTx9NVZRpAFzALTmCT6f25mhdi2nkni0pLlQB0c
	HGwCmhIXJpeCNHAK6Eg03rnCBjHITKJraxcjhC0vsf3tHOYJjEKzkNwxC8m+WUhaZiFpWcDI
	sopRMrWgODc9N9mwwDAvtVyvODG3uDQvXS85P3cTIzgatTR2MN6b/0/vECMTB+MhRgkOZiUR
	3ikL9dOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYCq4
	OeFNUnliAc/qq1X15xe8SefS2L63KW8pP8udmHMTHLNXaAtdC5hUwcI8cVOH2cG0pytfn1bM
	PHFHehXX1hUS9UGy4q4dM871yDdUL9rfY3DWtm9tyATGmtPTd+2pS3nrxhtQy6Nxbfb+BwI2
	uy/Ky6neZo/o8NrlUieybHHxYnbbrX3BPCfXreQ1uhO1x3TW/7o7Lz3F9j2YFf+F7fCNe1Ub
	fwtYmW9ateZPt8ma/S15jm/v32maYjb7xeqEScxZcZkMPxocI1+0mnCu41ZP+WMtZTTLa03m
	FY8f2gvDQg/qrAwTuHfWNengHIut9v0ui2q12ZtP+F++tZu72mJKsHlF+HXP8Ov6F1sF3iqx
	FGckGmoxFxUnAgDCrl8xNQMAAA==
X-CMS-MailID: 20240501130247epcas5p3e44f8af41cdf1767853e0f4e6985e013
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com>
	<20240425183943.6319-5-joshi.k@samsung.com> <20240427070508.GD3873@lst.de>
	<03cb6ac3-595f-abb1-324b-647ed84cfe6b@samsung.com>
	<20240429170929.GB31337@lst.de>

On 4/29/2024 10:39 PM, Christoph Hellwig wrote:
> On Mon, Apr 29, 2024 at 05:10:59PM +0530, Kanchan Joshi wrote:
>>> This feels wrong.  I suspect the problem is that BIP_COPY_USER is
>>> inherited for clone bios while it shouldn't.
>>>
>>
>> But BIP_COPY_USER flag is really required in the clone bio. So that we
>> can copy the subset of the metadata back (from kernel bounce buffer to
>> user space pinned buffer) in case of read io.
>>
>> Overall, copy-back will happen in installments (for each cloned bio),
>> while the unpin will happen in one shot (for the source bio).
> 
> That seems a bit odd compared to the bio data path.  If you think this
> is better than the version used in the data path let's convert the
> data path to this scheme first to make sure we don't diverge and get
> the far better testing on the main data map side.
> 

Can you please tell what function(s) in bio data path that need this 
conversion?
To me data path handling seems similar. Each cloned bio will lead to 
some amount of data transfer to pinned user-memory. The same is 
happening for meta transfer here.

