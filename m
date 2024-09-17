Return-Path: <io-uring+bounces-3218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEFF97AAEE
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 07:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D33A0B2434E
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 05:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A9F847B;
	Tue, 17 Sep 2024 05:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CO1oFkrk"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAF01EB3D
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 05:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726550191; cv=none; b=YBmhRt7wIOSeb8cu/1uP8jAd76drqL1h7o/gIQPqmyLRFJrU3xGYd+aZ37mtQ9qsC73IuoldPaMGofsTEb8DgAyCcFf3DrOnc+7KWoZHk28MnT650m/mwprTXvNCNRV2vWMszyZUlAB1Lpy6LQMF3vahiLhcVRN3q42j1MWlrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726550191; c=relaxed/simple;
	bh=OremXLnTyMUjs9f/UwkFzkvZ1jPHAzQczFz+Yr8WM6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=gBBAirXcuZSeZY/k/k5UxFxgAI826xfEPHDBHF4e24L5Wle/5wqdRNVISWH63/x6xcrlNhMddLphE37xElGkH7SViyiF1335Ib9z1/CXYeOvwC1QMIq8SN1v36aq4TxjTRw5UoKIaelf+RJ2OAFhqbRVq9TycGk1nbizqrauE0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CO1oFkrk; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240917051624epoutp03b25ffba1117bd429d48a710669333331~18D7U_omv1419314193epoutp03e
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 05:16:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240917051624epoutp03b25ffba1117bd429d48a710669333331~18D7U_omv1419314193epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726550184;
	bh=k4y/Audt1ZfuGNls27V0GLlWTEkt7ok1Ah1BNaCMpj0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=CO1oFkrkOIzfnTdG9neuYv3ADHnH8GYi1ywbAwPlJE4n2qY4scmVKrO3j0Py3qDHU
	 rIsizTNg9zPOzWSRnJ5ejJcQaHR3eb9hXT0O/FSR/7D3cbrcpQnXWG8zYEUsgOKR7f
	 6tu4FrM8pvGIVYeOGsB3RgqFQ3H8tQIF2zAMEcsM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240917051624epcas5p419fa0fc087c6c9fdf1e75df1e1ead5fc~18D7FWewa3082130821epcas5p4E;
	Tue, 17 Sep 2024 05:16:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4X79471tDtz4x9Ps; Tue, 17 Sep
	2024 05:16:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C4.05.19863.7A019E66; Tue, 17 Sep 2024 14:16:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240917051622epcas5p394a81dced67728a73b726e235eea6204~18D5R-VzQ0335703357epcas5p34;
	Tue, 17 Sep 2024 05:16:22 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240917051622epsmtrp24360cd1e03cfaa27f29625c2426ec616~18D5Rf8VL0112101121epsmtrp2p;
	Tue, 17 Sep 2024 05:16:22 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-3a-66e910a7ffd8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	FB.93.19367.6A019E66; Tue, 17 Sep 2024 14:16:22 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240917051621epsmtip11d29202a99091eba6ddff6f80895dcfb~18D4pGJS22374723747epsmtip1D;
	Tue, 17 Sep 2024 05:16:21 +0000 (GMT)
Message-ID: <2ae9e6c7-3032-52a3-ba48-1f66dd66e723@samsung.com>
Date: Tue, 17 Sep 2024 10:46:20 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/2] Shrink io_mapped_ubuf size
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: cliang01.li@samsung.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240915152315.821382-1-axboe@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhu5ygZdpBk9nslmsvtvPZnH672MW
	i3et51gcmD0uny316NuyitHj8ya5AOaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKT
	Ar3ixNzi0rx0vbzUEitDAwMjU6DChOyM2533mAsuMFY8f3OKqYFxKWMXIyeHhICJxI7Omywg
	tpDAHkaJZc/Tuxi5gOxPjBJNvzYxwTmnL+6E67ix8SYjRGIno8T8Ox+ZIZy3jBKfpz4Am8Ur
	YCcxq+MZWAeLgKrEln8nmCHighInZz4BqxEVSJL4dXUOUA0Hh7CAmUTbBW6QMLOAuMStJ/OZ
	QGwRASuJAzeWs0DEpSXePrrHBFLOJqApcWFyKUiYE6jzwvU+dogSeYntb+eAnSMhcIldYtnK
	p6wQR7tInNpzjA3CFpZ4dXwLO4QtJfH53V6oeLbEg0cQ50sI1Ejs2NwH1Wsv0fDnBivIXmag
	vet36UPs4pPo/f0E7BwJAV6JjjYhiGpFiXuTYLaKSzycsQTK9pD4OaObDRLQnYwS117KT2BU
	mIUUJrOQPD8LyTezEBYvYGRZxSiVWlCcm56abFpgqJuXWg6P7uT83E2M4ESoFbCDcfWGv3qH
	GJk4GA8xSnAwK4nw2v5+mibEm5JYWZValB9fVJqTWnyI0RQYOxOZpUST84GpOK8k3tDE0sDE
	zMzMxNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBqauqBVc5Yc3xlsou6svbDMQqJ/x
	eYGTQmmY9i8ejonra9MELJpa/uy6kNp7fKrDUekue/5fMddLpVPkzqq07jjySKH2423TpGuq
	Jw03/H6gI1wp/uXm0wDPRdZmsivCpq9mfxQ2a4lGRb23cwmrwvUET16GkxxcH7Pml1n6/v11
	+FhYu/XsUx/+cDJkRPTGmfjcUhfpXRXi53ezteX9AR15c+8M1vMGHfkz525/am7tmuH1t07v
	8oFsgbTf+vud7gcdncjZ1vv25ukLX86V3v15SS1MzWp/Kv+iV5YtIcKezWWdXBsKt6RO2/V5
	zVX7qfwRrR9q+fZqavOy2pW57FNgzVi9zXfz2qMzpwX9VmIpzkg01GIuKk4EAOju7LQNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO4ygZdpBue/yVmsvtvPZnH672MW
	i3et51gcmD0uny316NuyitHj8ya5AOYoLpuU1JzMstQifbsErozbnfeYCy4wVjx/c4qpgXEp
	YxcjJ4eEgInEjY03wWwhge2MEtu6hSDi4hLN136wQ9jCEiv/PQeyuYBqXjNKPDndCJbgFbCT
	mNXxDKyZRUBVYsu/E8wQcUGJkzOfsIDYogJJEnvuNzJ1MXJwCAuYSbRd4AYJMwPNv/VkPhOI
	LSJgJXHgxnIWiLi0xNtH95ggdnUySvzp/sMM0ssmoClxYXIpSA0n0JgL1/vYIerNJLq2djFC
	2PIS29/OYZ7AKDQLyRWzkKybhaRlFpKWBYwsqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGC
	g10raAfjsvV/9Q4xMnEwHmKU4GBWEuG1/f00TYg3JbGyKrUoP76oNCe1+BCjNAeLkjivck5n
	ipBAemJJanZqakFqEUyWiYNTqoFJ5vyVeu8vr7dFtqU8WHigidl5eduKkBs3b/8vT+Bbe059
	TUuho8xPozYBn4OWRUU6U4RvPbG5sXL3s0Rp5vVXi2x/n/8tIWNc3/B4XbRdcMOGU4e/tPge
	8zkddkvGu6NHOiXPYbdjfVhxjPPEfWoCTuufncl7mTK5OmJPwvlpVR3xWgsaG2Tcfs+Z531v
	j9Gl39V2uqt4PA3vVXPP9NwocYZnU5/VzEXsT37bLMtaxty8zr2yOoApYYvkl2lLGhKmuh3p
	FEzJN+9wnsTgtMhFPdFUMbPz7/O4c7z3G/f35S/imOv2NL1hy8RFh0T/HLuWqvsmSW5F026d
	jJsh89aETTbPM8w7IrDzPHfUvZ9KLMUZiYZazEXFiQAA+Rm85QIAAA==
X-CMS-MailID: 20240917051622epcas5p394a81dced67728a73b726e235eea6204
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240915152336epcas5p13d091902fa4a858903a4d5cc59973c00
References: <CGME20240915152336epcas5p13d091902fa4a858903a4d5cc59973c00@epcas5p1.samsung.com>
	<20240915152315.821382-1-axboe@kernel.dk>

On 9/15/2024 8:52 PM, Jens Axboe wrote:
> Hi,
> 
> This shrinks it from (now) 48 bytes to 32 bytes. No ill effects observed
> in terms of performance.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

