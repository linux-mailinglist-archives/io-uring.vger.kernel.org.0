Return-Path: <io-uring+bounces-490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE31C83FEFA
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 08:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E944A1C231AF
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 07:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E682EB00;
	Mon, 29 Jan 2024 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E9vIl4BU"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F73C460
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 07:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513239; cv=none; b=c4mnz3z9ffAtSIOiFvZjb3jl5W0Z/ySaph+/F8qkCD8vL+EtuH59ViRBUFYke0olhcGdbPPUvkhV+l+ZtDMkxUx1GPGyxSGxt3KjSqPM5ctlcID6X+uvYdfwMTef5cLXwTc8e7r/40gvrme/kr6VHGHH6jVm9pXojw+CUXxXyzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513239; c=relaxed/simple;
	bh=UQg/5njUp9OZkRWZYCC4RzpOoedARfKxs5rcJ9UqsdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lMluimo7Gh/Lh5a8zGN5qGnIWdCZ9eojPgS+hvU6DGWX8p7dll32Xeb3FmTE+VIIUzNkhsr0x7HWvrlAEu0/lhXN2iH5xPqdGBw8t6Mc8rW0i4fPufhVq1EXAOcfI52pqnfUjZN3Ri9enAHKyclVDdpMvvTgg9glEQxzPydEuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E9vIl4BU; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240129072709epoutp03d8bb90a0509b7aa890ed1fd89ec9fa0e~uwL2S6_-F1535815358epoutp03K
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 07:27:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240129072709epoutp03d8bb90a0509b7aa890ed1fd89ec9fa0e~uwL2S6_-F1535815358epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706513229;
	bh=SlQ1IskImIa1p6m1vQ2rqgCrN2OhcIVK0Fav7DA6fWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9vIl4BU/B0LE37zwdoxwMvznp5XhTPdEtVvBHEhQa/M9HzTprBRXnbP/gH3PAvpr
	 bFnnJtaMfGQIlVpWAyJ6OMMDCkYFlE0dwOkIUal3VV7WmQ7PgR9lTkOhjvQ2sEwQ44
	 UTEIIILDLAibQIxJpmea+bAgIIGOqS6ZdJoh5smU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240129072708epcas5p22bcc24d03a515c53b530109181280576~uwL15IV6v1618316183epcas5p2c;
	Mon, 29 Jan 2024 07:27:08 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TNfy252S4z4x9Q9; Mon, 29 Jan
	2024 07:27:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	75.11.09672.94357B56; Mon, 29 Jan 2024 16:27:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240129072655epcas5p35d140dba2234e1658b7aa40770b93314~uwLpaXhW72948229482epcas5p3J;
	Mon, 29 Jan 2024 07:26:55 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240129072655epsmtrp2f78420a682b8202b3027a39fbfefe833~uwLpZjuDb0907209072epsmtrp2E;
	Mon, 29 Jan 2024 07:26:55 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-01-65b75349d03c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8C.E4.18939.F3357B56; Mon, 29 Jan 2024 16:26:55 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240129072654epsmtip2bb7a2b9f5aa86d3d4f891e5c5ecf9a1c~uwLoH6Q1u0936709367epsmtip2_;
	Mon, 29 Jan 2024 07:26:53 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v7] io_uring: Statistics of the true utilization of
 sq threads.
Date: Mon, 29 Jan 2024 15:18:44 +0800
Message-Id: <20240129071844.317225-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8e104175-7388-4930-b6a2-405fb9143a2d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmpq5n8PZUgyX75S3mrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM84tusxc0Mhbcaj5M1MD4xvOLkZODgkBE4lnv7tZuxi5
	OIQEdjNKTJ/+FMr5xCjROP0VgjOx5z8TTEvb9H4miMRORonm+6/ZIZyXjBI/GvewglSxCWhL
	XF/XBWaLCAhL7O9oZQEpYhb4yygx4eVvZpCEsECkxIKPM9hAbBYBVYkd59+ygNi8ArYSh/tO
	s0Ksk5fYf/AsWD0nUPzojelsEDWCEidnPgGrZwaqad46mxlkgYTAX3aJtpOr2SCaXSSuL1/L
	DmELS7w6vgXKlpL4/G4vVE2xxJGe76wQzQ3AILh9FarIWuLflT1AGziANmhKrN+lDxGWlZh6
	ah0TxGI+id7fT6DhwiuxYx6MrSqx+tJDFghbWuJ1w2+ouIfEudYbzJDgmgAMrtZ1jBMYFWYh
	eWgWkodmIaxewMi8ilEytaA4Nz212LTAOC+1HB7Ryfm5mxjB6VXLewfjowcf9A4xMnEwHmKU
	4GBWEuH9qbk1VYg3JbGyKrUoP76oNCe1+BCjKTDEJzJLiSbnAxN8Xkm8oYmlgYmZmZmJpbGZ
	oZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTMpX1Zb3TeCY9nU/i8iCl02/q4/vW/u+5bDB
	VbNVjBf/XeNb2OzuYWM6VbHYY9YHkR31hl+N0uZ4vzU+3/p138bWMm9zL7Upx7O/mqcrN615
	vkQrZVZE0lcpjYezivwWybaEzXv75u0VpUWvxIK9V+//cmQpbyXrY/tHkbLbptlk3a0xW5zN
	2uN7cktHUlJYrPSZzLsnSxdMcf++0d5/810Bzjub2FibWJNu5xhcTmp0jlz8Mrsib+vnJf1+
	+VppEev9SgIPXrwnvvRYwfIj/Samp+UPSh9PE2GaP0fF4PODeaG2e+NZdkukXXrEevXYDtm/
	rzxYt0/YZ7fmhHPbz5oz77JO7dLby7iHfXPz9hNKLMUZiYZazEXFiQBrkeYdOAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSvK598PZUgwkTRC3mrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ5xZdZi5o5K041PyZqYHxDWcX
	IyeHhICJRNv0fqYuRi4OIYHtjBIXHq4GcjiAEtISf/6UQ9QIS6z895wdouY5o8SXiUuZQBJs
	AtoS19d1sYLYIkBF+ztaWUBsZoFOJonXn/VAbGGBcImVB3+A1bMIqErsOP8WrIZXwFbicN9p
	VogF8hL7D55lBrE5geJHb0xnA7GFBGwkPj3+ygRRLyhxcuYTqPnyEs1bZzNPYBSYhSQ1C0lq
	ASPTKkbR1ILi3PTc5AJDveLE3OLSvHS95PzcTYzggNcK2sG4bP1fvUOMTByMhxglOJiVRHh/
	am5NFeJNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamAKKzUr
	2LxG877Lba/myD2qyTbvJ83idzdoCZherJC/9P26I2/ZuniLC9ctNdv72Ku5NODrhMC1/zQd
	diw5w+/mxZvRN0d7tqbV7VNrWW6He+effVIVaX5Z6VGYV+XGY9oJHw5x3n2twrZb+E4rg+Sk
	XW6bWcLWffJV+Lai0s/1l0HLn+1Nd1+EZWZLvqg9qXZo3sSJW4QnRiRf0e9I+Xms48XepXVi
	uzkFi6Ny37hN/Px3fXTb1c1x29vNJ1atOKTuMWmROGv/vspF/w0s2n/t/Rxte2LCFtauK1sF
	DogwCmkvS5HnfHekLCNsDcuGmovxrvPWCIfsjax/5e2b7/PpOMdFxoi592dsuOxuErNTiaU4
	I9FQi7moOBEA8AX/zecCAAA=
X-CMS-MailID: 20240129072655epcas5p35d140dba2234e1658b7aa40770b93314
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240129072655epcas5p35d140dba2234e1658b7aa40770b93314
References: <8e104175-7388-4930-b6a2-405fb9143a2d@kernel.dk>
	<CGME20240129072655epcas5p35d140dba2234e1658b7aa40770b93314@epcas5p3.samsung.com>

On 1/18/24 19:34, Jens Axboe wrote:
>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>> index 8df37e8c9149..c14c00240443 100644
>> --- a/io_uring/sqpoll.h
>> +++ b/io_uring/sqpoll.h
>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>  	pid_t			task_pid;
>>  	pid_t			task_tgid;
>>  
>> +	long long			work_time;
>>  	unsigned long		state;
>>  	struct completion	exited;
>>  };
>
>Probably just make that an u64.
>
>As Pavel mentioned, I think we really need to consider if fdinfo is the
>appropriate API for this. It's fine if you're running stuff directly and
>you're just curious, but it's a very cumbersome API in general as you
>need to know the pid of the task holding the ring, the fd of the ring,
>and then you can get it as a textual description. If this is something
>that is deemed useful, would it not make more sense to make it
>programatically available in addition, or even exclusively?

Hi, Jens and Pavel
sorry for the late reply.

I've tried some other methods, but overall, I haven't found a more suitable 
method than fdinfo.
If you think it is troublesome to obtain the PID,  then I can provide
 a shell script to output the total_time and work_time of all sqpoll threads 
 to the terminal, so that we do not have to manually obtain the PID of each 
 thread (the script can be placed in tools/ include/io_uring).

eg:

PID    WorkTime(us)   TotalTime(us)   COMMAND
9330   1106578        2215321         iou-sqp-9329
9454   1510658        1715321         iou-sqp-9453
9478   165785         223219          iou-sqp-9477
9587   106578         153217          iou-sqp-9586

What do you think of this solution?

