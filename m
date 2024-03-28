Return-Path: <io-uring+bounces-1284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B125F88FE90
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 13:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE4F51C20A72
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 12:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB1B7D417;
	Thu, 28 Mar 2024 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YJIuEFJ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3374043ABE
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 12:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711627402; cv=none; b=SH6UUeVJU+EE/JckjxadykoeckxFh5fBSgzicFNjfucnAh6oA4HOv1FQerR5HEj5djeVdlhgsgrxGMmrYAwcOAOEhKxyalSVOgNazTQ82UTQR0jDwqwAbQfYO6bzj7m7BWGzO3bbOimzq4fYTPx3ALDH+bKBdYWp6ZYLiTzCQ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711627402; c=relaxed/simple;
	bh=njPfMt1yaE+k+q/O6YcP/r0RuDhf65Bw2LUvLU6CX/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=NpEFS3jqoH9aezPFJ9YIoDmFfu3L1RGheZpW4PXc6woQjaAK5tSE8Iv9Uxz89rppFo3092wVQixwSRC5UBAeg6LXVlpYaASuyUQIgP9H0wnnKl3f9Axva9IOcpB1/FdruDuVhQI8nG+UbplJS7gVBetyfqHvNF0d3nkstgz3P0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YJIuEFJ1; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240328120311epoutp015c74e6deb2136a9a928ad0d18e399ab9~A7Aswk1qa3002630026epoutp01x
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 12:03:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240328120311epoutp015c74e6deb2136a9a928ad0d18e399ab9~A7Aswk1qa3002630026epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711627391;
	bh=jeB9b7uMs5CCou5gNYnr4L+NZgPfGDPzOJrwNBiNxJ0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=YJIuEFJ1hGnkzQNt2f0svZOhKjnI3+Wrx/UZ01i3muvq9ma7u6S1Nj11EdNsDCRUk
	 Y3AnxmQPyyCrTqHZO5NrHMwcDRA6Xe3aM7D58Y/OHZjBcFgJFzsFKIbtm5xkqCIzdO
	 EQeuSYz4m2rJb12q9e2n1C93HsvabyTgEQT9tILU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240328120310epcas5p3f239c228b9276a17b0a267b61c0e3732~A7AsYypi21200412004epcas5p3o;
	Thu, 28 Mar 2024 12:03:10 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4V52HK0Mgxz4x9Px; Thu, 28 Mar
	2024 12:03:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.0A.09688.C7C55066; Thu, 28 Mar 2024 21:03:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240328120308epcas5p38f61bfb37c2e5fa2b600822b3470bc8c~A7AqUpvVp1063710637epcas5p3r;
	Thu, 28 Mar 2024 12:03:08 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240328120308epsmtrp265e8c6a89415ee2cb7d92839b183ca70~A7AqT-D1O1690816908epsmtrp2B;
	Thu, 28 Mar 2024 12:03:08 +0000 (GMT)
X-AuditID: b6c32a4a-837fa700000025d8-9f-66055c7c3926
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.9B.08390.C7C55066; Thu, 28 Mar 2024 21:03:08 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240328120307epsmtip125b510cd061ae5b88cdc668fdaa97307~A7ApElG7r0146001460epsmtip1b;
	Thu, 28 Mar 2024 12:03:07 +0000 (GMT)
Message-ID: <ef272148-9905-bcdf-89ee-9f6bd4a948a6@samsung.com>
Date: Thu, 28 Mar 2024 17:33:06 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH 0/4] Read/Write with meta buffer
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com,
	kbusch@kernel.org, hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <aa6530b9-6c85-44ef-b3d7-8017655725c5@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmum5NDGuawZZJ1hYfv/5msVh9t5/N
	YuXqo0wW71rPsVhMOnSN0WLvLW2L5cf/MTmwe+ycdZfd4/LZUo9NqzrZPHbfbGDz+Pj0FovH
	501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
	QJcoKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyM
	TIEKE7Iz3i67x1QwSaxi4lGdBsajQl2MnBwSAiYSK1++Yu9i5OIQEtjNKNHcdZkVwvnEKLFh
	z2mozDdGiYVnvrDBtNz/cQEqsZdRYn3TBCYI5y2jROu2F2BVvAJ2EhOeNDCB2CwCqhLbb8xi
	gYgLSpyc+QTMFhVIlvjZdQConoNDWMBC4tolR5Aws4C4xK0n88FaRQRiJb5tXMcOEQ+SePmm
	BaycTUBT4sLkUpAwp4CtRM+U2UwQJfIS29/OYQY5R0Kgl0Pix8wOZpB6CQEXiXcLnSDuF5Z4
	dXwLO4QtJfH53V6ov5IlLs08xwRhl0g83nMQyraXaD3VDzaGGWjt+l36EKv4JHp/P2GCmM4r
	0dEGDVBFiXuTnrJC2OISD2csgbI9JBpewQLqAKPE4W13mScwKsxCCpNZSJ6fheSbWQibFzCy
	rGKUTC0ozk1PLTYtMMpLLYfHdnJ+7iZGcCrV8trB+PDBB71DjEwcjIcYJTiYlUR4dx5lSRPi
	TUmsrEotyo8vKs1JLT7EaAqMnInMUqLJ+cBknlcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6
	YklqdmpqQWoRTB8TB6dUA5OgZKff1oiL90SVrl6Zp1w4T52Tv/VKZ8t893+xt6bKxzybm7Jk
	wvRLuu+ONz9/pH51ja4d87H+afbvDhdU7tI943xRZ8PM9mPhzvIPP3qcPvhja/WqmIyMgxI3
	HNJ9rFtPlj9c6rj107LO03VLXp2WZ2awv6V1IMVl0XZ+j65ye4v+pIh3HhMa9dpj/ngH/1Wp
	LYqdk7z4l+hB9WU8awsfzr2ilXfgf8K+AMVfE++d6JnAaPCth8t4Ecf2dTueFvbsy7X2+Wru
	eMhq195jOT8tlmfJle9fIPxUcekZJsbk+xFMzaEuTiaH3xTJbCs5pT0paUnacfXaB3Fsu9Sr
	VX8zODF4ODWwbQp2XcaxV0OJpTgj0VCLuag4EQBOZ7zXLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSnG5NDGuawc6tYhYfv/5msVh9t5/N
	YuXqo0wW71rPsVhMOnSN0WLvLW2L5cf/MTmwe+ycdZfd4/LZUo9NqzrZPHbfbGDz+Pj0FovH
	501yAWxRXDYpqTmZZalF+nYJXBlvl91jKpgkVjHxqE4D41GhLkZODgkBE4n7Py6wdzFycQgJ
	7GaUaJh3gx0iIS7RfO0HlC0ssfLfc6ii14wSq29sYwJJ8ArYSUx40gBmswioSmy/MYsFIi4o
	cXLmEzBbVCBZ4uWfiUDNHBzCAhYS1y45goSZgebfejKfCSQsIhArsbMjHyIcJDHrKcgUkFUH
	GCWe921nAalhE9CUuDC5FKSGU8BWomfKbCaIejOJrq1djBC2vMT2t3OYJzAKzUJyxCwk22Yh
	aZmFpGUBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzguNHS2sG4Z9UHvUOMTByM
	hxglOJiVRHh3HmVJE+JNSaysSi3Kjy8qzUktPsQozcGiJM777XVvipBAemJJanZqakFqEUyW
	iYNTqoHJYP62Do7ZQonHD1mIfDxd/6ZCm11w4mT9wPJDp+VL7j8wDLDI2/TDX7F/7+146+BX
	izw5BM7EMis/2jkl0tbp5QOT+ydY5ut9kv90aNnP1YdYIl2XnFroUrScp2HOUtvzm9a6nvPm
	XcI02WGRf/Rd++MrtNYuMFnzu7L/+E6NFf/XvFmewPjj4fGN6ae0fHp4jWekmXYs/e58emqU
	U/ScBY91KytPPzyYEeC6/tKkp1+tVyma1/6qsZfOO6TYvCudZ5fD02bu358fls/a531x/69M
	vg+T80zXHrnU1DnhSWi2RKTrvQs3lR08H/PoaV3NOHztpJuX4o9lB6R6Tr9cKto35WrhgsXb
	VI4ucfbju6jEUpyRaKjFXFScCACPNpDdCgMAAA==
X-CMS-MailID: 20240328120308epcas5p38f61bfb37c2e5fa2b600822b3470bc8c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563
References: <CGME20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563@epcas5p3.samsung.com>
	<20240322185023.131697-1-joshi.k@samsung.com>
	<aa6530b9-6c85-44ef-b3d7-8017655725c5@kernel.dk>

On 3/28/2024 5:08 AM, Jens Axboe wrote:

> This patchset should look cleaner if you rebase it on top of the current
> for-6.10/io_uring branch, as it gets rid of the async nastiness. Since
> that'll need doing anyway, could you repost a v2 where it's rebased on
> top of that?

Yes, next iteration will use that as the base.

> Also in terms of the cover letter, would be good with a bit more of a
> description of what this enables. It's a bit scant on detail on what
> exactly this gives you.

Will fix that.
But currently the only thing it gives is - pass meta buffer to/from the 
block-device.

It keeps things simple, and fine for PI type 0 (normal unprotected IO).
For other PI types, exposing few knobs may help. Using "sqe->rw_flags" 
if there is no other way.

>> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
>> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
>> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
>> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
>>
>> With this:
>> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
>> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
>> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
>> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
>> Engine=io_uring, sq_ring=128, cq_ring=128
>> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
>> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
> 
> Not that I don't believe you, but that looks like you pasted the same
> stuff in there twice? It's the exact same perf and pids.

Indeed :-(
Made a goof-up while pasting stuff [1] to the cover letter.

[1]
Before the patch:
# taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 
/dev/nvme0n1 /dev/nvme1n1
submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
Exiting on timeout
Maximum IOPS=10.04M

After the patch:
# taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 
/dev/nvme0n1 /dev/nvme1n1
submitter=1, tid=2412, file=/dev/nvme1n1, node=-1
submitter=0, tid=2411, file=/dev/nvme0n1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
IOPS=10.03M, BW=4.90GiB/s, IOS/call=31/31
IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
Exiting on timeout
Maximum IOPS=10.04M

