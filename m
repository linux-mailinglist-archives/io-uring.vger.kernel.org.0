Return-Path: <io-uring+bounces-1603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA858AC73B
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 10:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F69F1F21492
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 08:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FAF502BD;
	Mon, 22 Apr 2024 08:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TVymIE84"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87101502B4
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 08:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713775149; cv=none; b=Ebu8k3gR0pTrxD1nWgXjacq4klcut/kg1A+Xv6cJI1FOoxjLBhLsoWqqkUsaYFThg3Ivk7oSuOPEcC1Nq9tGSsPZ3jkpHXvBX5oY9R4Npl4RL39oQK+T20mZ8YdFylkf4WYFYjQnffs5R3SKB6RFZZy9rGtuPlkFOnpypVkw/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713775149; c=relaxed/simple;
	bh=4h4630NBcffFLd43owEzq3/6Wwj2iMy/33KJfwU0EQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sQvXzAT0TWWwBuVp35e37aeJWB25+CJ3M/5B2xkQRoI1UIOz/OQWnu0TiwFm+G7NaGdcfcHiLQwhhXzoltGOb5WCg08F65cg+KuwBHBSZ92RGr3qX+eWmDG85UoKBL6gZ0ybNZ+7lFQ7Jr8TGF1F52BsQNt6ldnjQSGwt4EioTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TVymIE84; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240422083312epoutp01234298fccc8ef4dc86a5fab50349c3cf~IjRfsME7v1680616806epoutp01l
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 08:33:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240422083312epoutp01234298fccc8ef4dc86a5fab50349c3cf~IjRfsME7v1680616806epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713774792;
	bh=BOEbA516Jm64T4WqID42LxQKCDujqnFQ2P/+LMNsxW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVymIE848Y96fu29wd+CR0aHOzA05zFU01q+xZ5oIzx5UhAe2UAxIBHw4WoNtrgUy
	 z1lYuYNpIS2YeyyC62iu/3ELlmXDTTKQ7viecSEjP4XzZONxtV1Qz9cRHLxp/yHxqh
	 K4yBTzGF4tTtofH2cWnAiDJlyIvV/5MwV7L8GIas=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240422083311epcas5p3dd871c8501c9c3bd1cc7aa2fc5f91da5~IjRfSYeJr1257312573epcas5p3g;
	Mon, 22 Apr 2024 08:33:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VNJRV4J6Cz4x9QJ; Mon, 22 Apr
	2024 08:33:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	91.84.09665.7B026266; Mon, 22 Apr 2024 17:32:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240422081827epcas5p21ba3154cfcaa7520d7db412f5d3a15d2~IjEnpVCpk2667726677epcas5p2O;
	Mon, 22 Apr 2024 08:18:27 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240422081827epsmtrp1cef82adf44c3f2c9fdfec058da8b330d~IjEnonSTg0981409814epsmtrp1C;
	Mon, 22 Apr 2024 08:18:27 +0000 (GMT)
X-AuditID: b6c32a4b-5cdff700000025c1-ae-662620b78d6e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.6D.08390.35D16266; Mon, 22 Apr 2024 17:18:27 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240422081825epsmtip28adab640203b0fb84c1425d09984348c~IjEmI9bIQ1697016970epsmtip2p;
	Mon, 22 Apr 2024 08:18:25 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com, xue01.he@samsung.com
Subject: Re: Re: io_uring: io_uring: releasing CPU resources when polling
Date: Mon, 22 Apr 2024 16:18:16 +0800
Message-Id: <20240422081816.2486247-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <26e38785-4f48-4801-a8c1-895bf8d78f7a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTZxTfd29pb8mqlwLbZzdcufERu4CtlO4yqDFITBeckrGZjCWrN/QC
	DX2tD6pkWxpecwVHFVgm4zEFFKtSw4pUEGSoc9BgjHVxNalzjpmImysKsrQCa7l187/fd/J7
	nHO+g6F8F1uAqXVm2qijNAQ7nnXu0iZR2qBwQ4n4Qvh1ssqxiJJtznOAPBVoZJPexd9Z5KPa
	ayzyyvJfbDJUHwDkwNx8HOkbamOT90e45NylBQ455QjGkS1uD0IeqPEB0n59kr1tteJ8a4Cj
	8E1ZFF+5nUDxpH9tAauoPKeMplS0UUjrivUqta5UTuQXKrcrM2ViSZoki3yLEOooLS0n8nYW
	pO1QayJ9EsIKSmOJlAook4nYvDXHqLeYaWGZ3mSWE7RBpTFIDekmSmuy6ErTdbT5bYlYvCUz
	QtxbXtbT60QM1Wv2Dc4+4NjAZKIdcDGIS2GLtw3YQTzGx4cB/HHxSw7zeAxg/69dcVEWH38K
	oGd6rx1gK4quw6kMZwTAZVtnTPAPgNXtfjQqYOMEvOgOgqggCRfAcACLclD8OAKHT3WwopxE
	/B04a1viRDELXw+HloIrWh6eDS87x+KY9t6AfvtFNOrDxeVwOpTLUBLgxJHpFRs0Qqke+BaN
	+kP8CAadgTsIo82Dd91P2QxOhDNX3RwGC+CDxroY1sOmBRdg8Kew7/tHLAZnw6WbF1jRXBTf
	BF1Dm5lyCmyZ7EOY3FXwYHg6FsWDno7nmIDdl3tjlhCGHcdioyhguLcntmkHgLcb5xEHELa+
	ME/rC/O0/h/9HUCdYA1tMGlLaVOmIUNHW//742K9th+sXK4o3wPu3Q2mjwMEA+MAYiiRxAs9
	W1fC56mo/ZW0Ua80WjS0aRxkRvZ9CBUkF+sjp68zKyXSLLFUJpNJszJkEuJV3sPadhUfL6XM
	dDlNG2jjcx2CcQU2ZObzH4JtW5qd3SkjiN/z2cZUjnK6uOZ0Hj5f85F/Ys9C5ei+taKTtXO/
	TX0wm8zVWqeenbnfJ/lwI/CO+vRJgxWHYdFgjiBU0Vz5kqwF53Np14nOoYaM966a6723S/5Y
	1dgVUN8YiQ8cvYanKhMEPi51YPgVTd3ZW+9rC1dv3TnW3W4Q85b8RSdHZVxw7N3UATr553Vn
	nhxdvyE3DUtpmrmREaIfxqnvJOQQiubFx2/eug7+3k1kN9ULd91cqtux2N/wyydfDO15LZ9r
	7fi46sSyy4a159YctH6zS2eVV/UcOv3nTy97Ebm/SXH2/PL+7WNf94oa7vVNFAa3WXqudKZk
	EyxTGSURoUYT9S/dg+XpQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvG6wrFqawZMDnBZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtIV
	q5gKmiUrtn98yd7AeEq4i5GDQ0LARGLxJMUuRi4OIYHdjBLzr0xk72LkBIpLSOx49IcVwhaW
	WPnvOTtE0TdGieU/JjCDJNgElCT2b/nACDJIREBK4vddDpAaZoFtTBL7Hq5jAakRFvCU+Njw
	D2woi4CqxK5/H8B6eQWsJY6sOgC1QF7iZtd+ZpA5nAK2Ek9+OYGEhQRsJC6sW8oIUS4ocXLm
	E7CRzEDlzVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg
	qNDS2sG4Z9UHvUOMTByMhxglOJiVRHh//VFJE+JNSaysSi3Kjy8qzUktPsQozcGiJM777XVv
	ipBAemJJanZqakFqEUyWiYNTqoEppUFeOdvWztlQZAIj91s+FsmLE4t1zq/3Ll+UL62p3V88
	b9LzV8VeNbPfr0gwPP7ixOkZh+/062rq3FsjkD0lIexkqlFu9KawspOT6u4EPvT1u277aAW/
	qFn38w+1tVr9+s6zOdPuL99pZp+Yw2jrK7+ItbTlzFzTOgPWWaJfJ0mbr+QVfvXsUfKXR9vc
	GFadNc5f3NwZuuX8lJ/eF9+cOmPltWd/J5u2VWL2WvWSIlvxLeuumc9l0f56uPV7x1QOJ2f5
	WaI2fcsaZc7ytVmelrGwErFnmrWuuSvbsXejep5UH/fC7xxck19m9TdFz56XwKS15fTWbW2/
	YkQOp4eZ7K7XTOh5e1Ltu+2et0osxRmJhlrMRcWJAJFl7er5AgAA
X-CMS-MailID: 20240422081827epcas5p21ba3154cfcaa7520d7db412f5d3a15d2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240422081827epcas5p21ba3154cfcaa7520d7db412f5d3a15d2
References: <26e38785-4f48-4801-a8c1-895bf8d78f7a@gmail.com>
	<CGME20240422081827epcas5p21ba3154cfcaa7520d7db412f5d3a15d2@epcas5p2.samsung.com>

On 4/19/24 13:27, Pavel Begunkov wrote:
>On 4/18/24 10:31, hexue wrote:
>> This patch is intended to release the CPU resources of io_uring in
>> polling mode. When IO is issued, the program immediately polls for
>> check completion, which is a waste of CPU resources when IO commands
>> are executed on the disk.
>> 
>> I add the hybrid polling feature in io_uring, enables polling to
>> release a portion of CPU resources without affecting block layer.
>
>So that's basically the block layer hybrid polling, which, to
>remind, was removed not that long ago, but moved into io_uring.

The idea is based on the previous blcok layer hybrid poll, but
it's not just for single IO. I think hybrid poll is still an effective
CPU-saving solution, and I've tested it with good results on both PCIe
Gen4 and Gen5 nvme devices.

>> - Record the running time and context switching time of each
>>    IO, and use these time to determine whether a process continue
>>    to schedule.
>> 
>> - Adaptive adjustment to different devices. Due to the real-time
>>    nature of time recording, each device's IO processing speed is
>>    different, so the CPU optimization effect will vary.
>> 
>> - Set a interface (ctx->flag) enables application to choose whether
>>    or not to use this feature.
>> 
>> The CPU optimization in peak workload of patch is tested as follows:
>>    all CPU utilization of original polling is 100% for per CPU, after
>>    optimization, the CPU utilization drop a lot (per CPU);
>
>The first version was about cases that don't have iopoll queues.
>How many IO poll queues did you have to get these numbers?

The test enviroment has 8 CPU 16G mem, and I set 8 poll queues this case.
These data of the test from Gen4 disk.

>>     read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
>>     randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%
>> 
>>    Compared to original polling, the optimised performance reduction
>>    with peak workload within 1%.
>> 
>>     read  0.29%     write  0.51%    randread  0.09%    randwrite  0%
>> 
>> Reviewed-by: KANCHAN JOSHI <joshi.k@samsung.com>
>
>Kanchan, did you _really_ take a look at the patch?
>

sorry I misunderstood the meaning of "reviewed", I've had some discussions
with Kanchan based on the test results, he just give some suggestions and
possible approach for changes but haven't reviewed the implementation yet.
This is my mistake, please ignore this "reviewed" message.

>> Signed-off-by: hexue <xue01.he@samsung.com>
>> ---
>>   include/linux/io_uring_types.h | 10 +++++
>>   include/uapi/linux/io_uring.h  |  1 +
>>   io_uring/io_uring.c            | 28 +++++++++++++-
>>   io_uring/io_uring.h            |  2 +
>>   io_uring/rw.c                  | 69 ++++++++++++++++++++++++++++++++++
>>   5 files changed, 109 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 854ad67a5f70..7607fd8de91c 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -224,6 +224,11 @@ struct io_alloc_cache {
>>   	size_t			elem_size;
>>   };
>

