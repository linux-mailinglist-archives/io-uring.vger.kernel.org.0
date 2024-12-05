Return-Path: <io-uring+bounces-5249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 296999E4FAA
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 09:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AED081881E2A
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 08:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572461D45F2;
	Thu,  5 Dec 2024 08:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dhvO6R51"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B6E195985
	for <io-uring@vger.kernel.org>; Thu,  5 Dec 2024 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733387182; cv=none; b=TeOO35jlS1w77q5gqUoG1dGOuM3naWegtALHFn1gyVNIegw73XmK+h9aqjb/IsHM5/EjH+YtoSkCahMxrSxOGawpZz21CghZzOJNil7yVASnq/vvigcTTtroispk1pOgfhkeTM+ovqzoQzAwJynUYGlFdUggU2ywrDM12ANTW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733387182; c=relaxed/simple;
	bh=TtjFf7C6Xuy5I0dmsPLQjBXwLuerSpSpTjntSZXh6KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=glzGEJhy0RM+csoB8qa+arhu6FlXvwb+mN2uXxqKYBaAe3UhgX4rY3enMPi48kcqp2TQxpBDJ9wF96zLqgaaAjsmrF+nnjF6Kci9YWCr0qh2zSPlrz3TZEyPdU/GT9SjIap+0oBnaH0HMx6B7oMhni9k9fRn8boFYyCbwsyIYe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dhvO6R51; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241205082612epoutp04896fd73c33307f45344c5f7fb8c5b1f7~OOnMCzpiJ0459904599epoutp04-
	for <io-uring@vger.kernel.org>; Thu,  5 Dec 2024 08:26:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241205082612epoutp04896fd73c33307f45344c5f7fb8c5b1f7~OOnMCzpiJ0459904599epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733387172;
	bh=UV1e2bi5qE0BqSSdWSdaqUPIoqcZCdduWKPI134vkAI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dhvO6R51Y36QfOhU5NKQU2PBqlwhcSD7qq7hV8PXaot0rhiPWWnXurySt63Sty+P5
	 YgnmGcgO0fEJL/jao/IajWt1k7V+65skfvIP6+65F9yjJsjfmh9NavttHd+hsqgaGh
	 x6FYiyyP0PYaXfA4EC2WnfIxv1zPV9LUgt8+Bj+g=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241205082611epcas5p27a3a1f906e800cee085635df480ec707~OOnLgmNL11781617816epcas5p2k;
	Thu,  5 Dec 2024 08:26:11 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Y3nXd6xG4z4x9Pt; Thu,  5 Dec
	2024 08:26:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CB.06.19710.1A361576; Thu,  5 Dec 2024 17:26:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1~OOaemwNM41369513695epcas5p2X;
	Thu,  5 Dec 2024 08:11:38 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241205081138epsmtrp289fb89319b441006a678e93267fce7e3~OOael7NZr2489924899epsmtrp2i;
	Thu,  5 Dec 2024 08:11:38 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-63-675163a1e70a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	94.72.33707.A3061576; Thu,  5 Dec 2024 17:11:38 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241205081136epsmtip2d65f1e7cc98bb7fb9ca9c8ebd7f63b2a~OOacI2QhT2555725557epsmtip2P;
	Thu,  5 Dec 2024 08:11:35 +0000 (GMT)
Date: Thu, 5 Dec 2024 13:33:42 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Javier Gonzalez
	<javier.gonz@samsung.com>, Matthew Wilcox <willy@infradead.org>, Keith Busch
	<kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241205080342.7gccjmyqydt2hb7z@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmhu7C5MB0g/knzS2mffjJbLFy9VEm
	i3et51gsHt/5zG5x9P9bNotJh64xWpy5upDFYu8tbYs9e0+yWMxf9pTdovv6DjaL5cf/MVn8
	/jGHzYHX4/IVb4/NK7Q8Nq3qZPPYvKTeY/fNBjaPcxcrPD4+vcXi0bdlFaPH501yAZxR2TYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iznh76
	wVYwka/i8s1GxgbGg9xdjJwcEgImEq9a1zN2MXJxCAnsZpS4tGULM4TziVHi/rz3THDOyo9z
	mWFaehb0Q1XtZJTYtfU2G4TzhFFi0YdbQC0cHCwCKhK/F4qDmGwC2hKn/3OA9IoImEpM/rSV
	DcRmFjjJItF9zQLEFhZwluiZe5cRxOYFmn94dhMThC0ocXLmExYQm1PAWOL4qXUsIKskBLZw
	SFxevR/qIBeJr0f/s0LYwhKvjm9hh7ClJD6/28sGYZdLrJyygg2iuYVRYtb1WYwQCXuJ1lP9
	zBAXZUicmfwFqkFWYuqpdUwQcT6J3t9PmCDivBI75sHYyhJr1i+AqpeUuPa9Ecr2kGi90skO
	CZTtLBKPP79im8AoNwvJR7OQ7IOwrSQ6PzSxzgIGGLOAtMTyfxwQpqbE+l36CxhZVzFKphYU
	56anJpsWGOallsNjOTk/dxMjOB1ruexgvDH/n94hRiYOxkOMEhzMSiK8lWGB6UK8KYmVValF
	+fFFpTmpxYcYTYHxM5FZSjQ5H5gR8kriDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0t
	SC2C6WPi4JRqYErNvHvSjX+P2B6FmkqnfzIZeWzqAiGM1hMfHvzDuFF7hwtn5IzZP99/Zla+
	ueDlZNsNznumFfDOPtJ8Vu7//JruKhZHidIY6fneviefc7T8Sl0zMXwz+3wB+Rc8ea/UeX7c
	fPDt4cwPTEY/A+/9XXtxl9FRfqvHzz6s25a55cUvG519YtPfFScpCRrwe2rfFVwQctt6sdGf
	j98/CL7gPOMqavRukn/XqeaKwn0TD7Ndu8QyNTH53YzVXN8CelnXZp1dnxbY6jb14d0Ptwqf
	XfP/vm7aqZ8y0z8xb3sgc/PNh8vlmyrPsVlEcS/tnSNczxz/M7TF4vqRbUvP2zlJbZx9Ka3F
	e1Fvqv1xj6heuy+WSizFGYmGWsxFxYkAKWMo6VAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSvK5VQmC6wbwrOhbTPvxktli5+iiT
	xbvWcywWj+98Zrc4+v8tm8WkQ9cYLc5cXchisfeWtsWevSdZLOYve8pu0X19B5vF8uP/mCx+
	/5jD5sDrcfmKt8fmFVoem1Z1snlsXlLvsftmA5vHuYsVHh+f3mLx6NuyitHj8ya5AM4oLpuU
	1JzMstQifbsEroxlzWdZCw5zV1z5/Je1gbGXs4uRk0NCwESiZ0E/cxcjF4eQwHZGiZ0vrrJC
	JCQllv09wgxhC0us/PecHcQWEnjEKDGhsaKLkYODRUBF4vdCcRCTTUBb4vR/DpAKEQFTicmf
	trKBjGQWOMsi8e7rAyaQhLCAs0TP3LuMIDYv0N7Ds5uYIPY+ZpbY37GWHSIhKHFy5hMWEJtZ
	wExi3uaHzCALmAWkJZb/A1vAKWAscfzUOpYJjAKzkHTMQtIxC6FjASPzKkbR1ILi3PTc5AJD
	veLE3OLSvHS95PzcTYzg2NEK2sG4bP1fvUOMTByMhxglOJiVRHgrwwLThXhTEiurUovy44tK
	c1KLDzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGpg8+U8Izd5cNaeH5dK/TVJfP32d
	U35KTS+AwVG+fcvRJwdaH21V7+eWa38RzSp9s+Lb2tqF/sfbw9N576bObPZhUbi3LG3WmmXP
	cw/bCm889uVGZ92aWxen/NvgZNPEuch25+KcNyH3bXfue5zEnnP98JP+Ez0752ff5nJJXRfU
	Zpd58u7zHAWXFX/Emw/GqPde7k9wOHLA0WxXa3L4Ys1n9yc3r67v0z7iLvN82UGXbCvN06LR
	i46X9+X1R185etCu8+PjF1lqIboppq3dB9ObZ4TbyWokTPy8uE+jQVhhIr/y5af5V75Z5LAm
	B2vZbf3bc97954lY0elmUTVajjOCpIOFEvWvHVJ7wS7ELqbEUpyRaKjFXFScCACzSDagDAMA
	AA==
X-CMS-MailID: 20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_5d6c0_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_5d6c0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 27/11/24 03:14PM, Martin K. Petersen wrote:
>
>Bart,
>
>> Submitting a copy operation as two bios or two requests means that
>> there is a risk that one of the two operations never reaches the block
>> driver at the bottom of the storage stack and hence that a deadlock
>> occurs. I prefer not to introduce any mechanisms that can cause a
>> deadlock.
>
>How do you copy a block range without offload? You perform a READ to
>read the data into memory. And once the READ completes, you do a WRITE
>of the data to the new location.
>
>Token-based copy offload works exactly the same way. You do a POPULATE
>TOKEN which is identical to a READ except you get a cookie instead of
>the actual data. And then once you have the cookie, you perform a WRITE
>USING TOKEN to perform the write operation. Semantically, it's exactly
>the same as a normal copy except for the lack of data movement. That's
>the whole point!
>
Martin

This approach looks simpler to me as well.
But where do we store the read sector info before sending write.
I see 2 approaches here,
1. Should it be part of a payload along with write ?
	We did something similar in previous series which was not liked
	by Christoph and Bart.
2. Or driver should store it as part of an internal list inside
namespace/ctrl data structure ?
	As Bart pointed out, here we might need to send one more fail
	request later if copy_write fails to land in same driver.

Thanks,
Nitesh Shetty

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_5d6c0_
Content-Type: text/plain; charset="utf-8"


------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_5d6c0_--

