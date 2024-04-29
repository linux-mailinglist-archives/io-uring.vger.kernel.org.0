Return-Path: <io-uring+bounces-1662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB498B55EA
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 12:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FAAD1C2329E
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 10:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B8A3A8EF;
	Mon, 29 Apr 2024 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ng3MPmLx"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E9BA2E
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714388387; cv=none; b=EwVe71iO1d650GF1Ny8hWD67THq1sT2a619R6tSZl8T79cv8mXhWxaX0z4Xbhc8eU/GW/a0MlyA5KBkDE9ogHMMnTo6PqWoa8mlCzEjtvgxLNvhdvcQQWofiePnnT8mnae1xe3ex57mN1PryFzrsyOrpWeei03dQ3GJZ23/zU80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714388387; c=relaxed/simple;
	bh=yAB3+LWej9MKVKpCtFaho06TLU9/GZ2naH/2mASmXPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=KnCo//YXJNM36mDWG1EALg8cHXBe8HzQuGz/VJOLKUhtem4eWkkK8YE6WEyTe7zgCsm5mCdhwlSKFfYESHMgB6fBrL3LhipaOHPsUAOHES+qrEdpxPO+nrbBqF5sKS+VSg90gUB7Ek9oE9bQ8q8GQRx/xlJ7aPlcHNmF9VI3/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ng3MPmLx; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240429105936epoutp018a0be70424eb766362a521d4685de5cb~KuyUYMTtW3000930009epoutp01E
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 10:59:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240429105936epoutp018a0be70424eb766362a521d4685de5cb~KuyUYMTtW3000930009epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714388376;
	bh=Az+hRiv5av28fx/NMox4ku8zhbC9n/++KSpp75bjFT8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ng3MPmLxV/sEyqlNUj42GGAua8XRgEzOmi6yY4bUogxWit5aLQInBEvSUIjE5pWi5
	 Gexpj1MzBuL+4ViOMbyomXNiBbcKw9XbDMb8gTXS207mqn6e0g2pTc8Cp0tnVK7gXv
	 kYIomg+cATYt5W26qHRoJ2ncjunE14rX+v3Ue3lY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240429105935epcas5p3c89a15e085f6801054e7b7694902dbe7~KuyTzmNpC1482714827epcas5p3w;
	Mon, 29 Apr 2024 10:59:35 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VSgM96YZ2z4x9Pv; Mon, 29 Apr
	2024 10:59:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.5E.09665.59D7F266; Mon, 29 Apr 2024 19:59:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240429105933epcas5p271bec7690d5e6e2e9264754fab4a7b3d~KuyR2RPLB0104201042epcas5p2p;
	Mon, 29 Apr 2024 10:59:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240429105933epsmtrp145532c8f3c6f5865a68786f88cd3c04b~KuyRxgbZJ0970609706epsmtrp1V;
	Mon, 29 Apr 2024 10:59:33 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-9c-662f7d954ace
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.28.08390.59D7F266; Mon, 29 Apr 2024 19:59:33 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240429105931epsmtip1cc615a2ad8041ab968fb6c42a7a1c350~KuyQCkEtc2520925209epsmtip1Y;
	Mon, 29 Apr 2024 10:59:31 +0000 (GMT)
Message-ID: <53be2abc-5a46-fef6-1cb3-cd791e3f42be@samsung.com>
Date: Mon, 29 Apr 2024 16:29:30 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 01/10] block: set bip_vcnt correctly
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmlu7UWv00g7aJxhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDMq2yYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGzhmvWAo2
	sVb8/rOWtYFxBUsXIyeHhICJxJUv+5lAbCGB3YwSK17zdjFyAdmfGCUu/uxihnC+MUpceHuR
	Dabj1OrNUIm9jBKLp29mgnDeMko83LGOHaSKV8BO4tSpncwgNouAqsTivvfMEHFBiZMzn4Dt
	FhVIlvjZdQBsqrCAhcSuf7/B4swC4hK3nswHu0lEwFnib+95sAXMAo1MEhtenAdq4OBgE9CU
	uDC5FKSGU8BKoqVzKitEr7zE9rdzwK6TEDjDITHvQjc7xNkuEifWToCyhSVeHd8CZUtJvOxv
	g7KTJS7NPMcEYZdIPN5zEMq2l2g91c8MspcZaO/6XfoQu/gken8/YQIJSwjwSnS0CUFUK0rc
	m/SUFcIWl3g4YwmU7SHx9/gORkhYdTBJzF62iG0Co8IspGCZheT9WUjemYWweQEjyypGydSC
	4tz01GLTAuO81HJ4hCfn525iBKdnLe8djI8efNA7xMjEwXiIUYKDWUmEd9Mc7TQh3pTEyqrU
	ovz4otKc1OJDjKbA+JnILCWanA/MEHkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqem
	FqQWwfQxcXBKNTA95voZ2jxjjVHYvPJP1rHs+ZHbHFasmrrtuP/jb9GFM/KecLXmvdZYx/NO
	m786kT1S+liQkMZ0y3lr7Yva83yOyF3LX77+l7tMmI/9v118Rn5qpc++hsev2/s2Z887d8m7
	JytTejTen4639L6pdVvzX3TAUr2stBNWH5POyGlISPtq8lrsK9La7jPp16b8vwrbvgpZZ1zf
	6m52+dGsjBKHWWZLfWscXCZX5JXeu+Vn/Gvv6ZDfv6KXrC/evoRL79Gnf3GpK9cuNJi19u3K
	8PsRdwR5tISyD14+NklL/muCxB/+CUrVd2zLZyx+9Oeb2OcfbvO/cj85wM256o3Ss2DO0Jrn
	3duKPd8lvlA+GPZMiaU4I9FQi7moOBEANCsywlgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWy7bCSnO7UWv00g2+3+SyaJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvFpEPXGC323tK2mL/sKbvF8uP/mBx4
	PK7NmMjisXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1ZxejxeZNcAGcUl01Kak5m
	WWqRvl0CV8bOGa9YCjaxVvz+s5a1gXEFSxcjJ4eEgInEqdWbmUFsIYHdjBK/dxhAxMUlmq/9
	YIewhSVW/nsOZHMB1bxmlOhZM5UNJMErYCdx6tROsGYWAVWJxX3vmSHighInZz4BWyAqkCzx
	8s9EsEHCAhYSu/79BoszAy249WQ+E4gtIuAs8bf3PBPIAmaBRiaJpQvmsEBc1MEk8fmMcBcj
	BwebgKbEhcmlIGFOASuJls6prBBzzCS6tnYxQtjyEtvfzmGewCg0C8kZs5Csm4WkZRaSlgWM
	LKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYIjUUtrB+OeVR/0DjEycTAeYpTgYFYS
	4d00RztNiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2ampBalFMFkmDk6pBqYA
	643qJq/CrzDFcr8L3hq38+dJh7TmLxMsT21SuRsWLdllffjRxMlr3c91pgdttpzQv3uS6q6f
	ifcFmBdJ/Syye6GtFKTFvHHzPd6v3obPdKb8X6h59AvPPvVsa8NtmZtjKuL3rDjyLK6dM/hN
	JP9UEW/tCVrWxVm/1JS8Agz7FnHyp9XKGvgu2BZ976uZUflyqSN2K3/rJp1I/OrMOVOe8w6z
	ic17Y/7coOMb/J43qix+Lb/j+KZbU6YrPbg4R/3i8vssH/V/yltMNVP29+bZLPnqU0O+1QGt
	NZ2zBLWt2OL+p/B23qzf0FRnI/7+sfGZJ78XcbOy3uX8VC6foWnvkZu/Y7Z59pZ/zy+ZSSqx
	FGckGmoxFxUnAgAEw6XRMwMAAA==
X-CMS-MailID: 20240429105933epcas5p271bec7690d5e6e2e9264754fab4a7b3d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com>
	<20240425183943.6319-2-joshi.k@samsung.com> <20240427070214.GA3873@lst.de>
	<Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>

On 4/27/2024 7:46 PM, Keith Busch wrote:
>> Looks good:
>>
>> Reviewed-by: Christoph Hellwig<hch@lst.de>
>>
>> Please add a Fixes tag and submit it separately from the features.
>>
>> I'm actually kinda surprised the direct user mapping of integrity data
>> survived so far without this.
> The only existing use case for user metadata is REQ_OP_DRV_IN/OUT, which
> never splits, so these initial fixes only really matter after this
> series adds new usage for generic READ/WRITE.
> 

Yes. It did not seem that there is any harm due to these missing pieces 
(first 6 patches).
Therefore, "Fixes" tag is not there, and patches were not sent 
separately from the features.


