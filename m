Return-Path: <io-uring+bounces-239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CDD8059E2
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 17:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA6B0B21187
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A5055C1F;
	Tue,  5 Dec 2023 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j0ANLU4a"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09D2122
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 08:21:29 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231205162124epoutp0126ee124f1f6cb0d40955f238c2b50ab5~d_-nM4SU21224212242epoutp01B
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 16:21:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231205162124epoutp0126ee124f1f6cb0d40955f238c2b50ab5~d_-nM4SU21224212242epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1701793284;
	bh=VqJy3avQ+AZ7p4d6JxDtpGbwd1txWQN29W2AQEGmFiI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=j0ANLU4aVbEMnYY8NMLd6Mpt2D55SLqfYuzpdeVq2qCKtGmUpwfmyFSig8U4Fer77
	 vSfrk24w4kzqFw8GJw5uUpn8m1BKJfiUT6qsIYJ9yNSQ025xcy9hoY2nCK3TLt9wI5
	 3rQNmvzrlwTcWoQLPeq7wC903Xy+2Y9mjXK19RbU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231205162124epcas5p2f38d7da907923122f4f06ba35b84cb74~d_-mzj3_D0290202902epcas5p2t;
	Tue,  5 Dec 2023 16:21:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Sl5Pt2JKcz4x9Pp; Tue,  5 Dec
	2023 16:21:22 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	82.F3.19369.20E4F656; Wed,  6 Dec 2023 01:21:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231205162121epcas5p2c410526ed459a8e739c81fc6fe3ef4e5~d_-kgVKK70290202902epcas5p2o;
	Tue,  5 Dec 2023 16:21:21 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231205162121epsmtrp2d2b1675e7f05671d09cdc5b4fb2a12e7~d_-kfn_Zu1992219922epsmtrp2p;
	Tue,  5 Dec 2023 16:21:21 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-08-656f4e027a0e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.BD.08817.10E4F656; Wed,  6 Dec 2023 01:21:21 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231205162120epsmtip1b87bf7198a027ac080d4088336b41d06~d_-jR7RXN2618226182epsmtip1e;
	Tue,  5 Dec 2023 16:21:20 +0000 (GMT)
Message-ID: <4cc1ba06-ecfd-b351-962e-27042767657e@samsung.com>
Date: Tue, 5 Dec 2023 21:51:13 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: hch@lst.de, sagi@grimberg.me, asml.silence@gmail.com, Keith Busch
	<kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmpi6TX36qwY43PBZzVm1jtFh9t5/N
	YuXqo0wW71rPsVhMOnSN0eLM1YUsFvOXPWW3WPf6PYsDh8fOWXfZPc7f28jicflsqcemVZ1s
	HpuX1HvsvtnA5nHuYoXH501yARxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QHcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpMCvSK
	E3OLS/PS9fJSS6wMDQyMTIEKE7IzJr+4y1rwhqdi5QKWBsa1XF2MnBwSAiYSjzYsZOxi5OIQ
	EtjDKLFv6gp2COcTo8SfLd9YIJxvjBL/O/qYuhg5wFp2X/eCiO9llFh4dhFU0VtGiQNt5xlB
	5vIK2Em8ObmDDaSBRUBF4u8mQ4iwoMTJmU9YQGxRgSSJX1fnMIKUCAu4S3RM8QUJMwuIS9x6
	Mp8JxBYRqJbY03CBDSIeLXGmczlYOZuApsSFyaUgYU4BW4mOq/2sECXyEtvfzmEGuUZCYCmH
	xLmmGSwQX7pITFtxmRHCFpZ4dXwLO4QtJfH53V42CDtZ4tLMc0wQdonE4z0HoWx7idZT/cwg
	e5mB9q7fpQ+xi0+i9/cTaIjwSnS0CUFUK0rcm/SUFcIWl3g4YwmU7SEx89wMVnio7dj2jWUC
	o8IspECZheT7WUjemYWweQEjyypGqdSC4tz01GTTAkPdvNRyeGwn5+duYgSnWa2AHYyrN/zV
	O8TIxMF4iFGCg1lJhHferexUId6UxMqq1KL8+KLSnNTiQ4ymwNiZyCwlmpwPTPR5JfGGJpYG
	JmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUw6epdXGW3s7pZ8mvjJ4+dTScs
	IooCLPPTU94I3voqJt+YEr1X4uYZtQQNdaPcn4y/+I/7Jmwt3VIl8YunNOuF3/KZH3TUcl9+
	XeduLXtLZDIP49mUa2Y8O4TT670atnCtvVnifH1CMQPrlzwN4+Y6f0eTX9H7dn+5qH3rmOnD
	4lLPsFBl7Vv7L8/blLy1/5T4FFb2l86fZmyM80ucP6du999gZ2Hd71LC3yNKzn+7ZFG3STv0
	xM55cjFrKk12i8i6mn/U3byk+6PfjGPM7NqmhXG1YW+j1NwOdj3glb427cPOvS9n7K+5xcAR
	++CtYdAL5hfTpv3kXLxtac3LbvOLD9cHnNzudZchg3Hi6wpGJZbijERDLeai4kQAU+inajwE
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTpfRLz/VYOdnBYs5q7YxWqy+289m
	sXL1USaLd63nWCwmHbrGaHHm6kIWi/nLnrJbrHv9nsWBw2PnrLvsHufvbWTxuHy21GPTqk42
	j81L6j1232xg8zh3scLj8ya5AI4oLpuU1JzMstQifbsErozJL+6yFrzhqVi5gKWBcS1XFyMH
	h4SAicTu615djFwcQgK7GSW2vF7N1sXICRQXl2i+9oMdwhaWWPnvOTtE0WtGic7VOxhBErwC
	dhJvTu5gAxnEIqAi8XeTIURYUOLkzCcsILaoQJLEnvuNTCAlwgLuEh1TfEHCzEDjbz2ZzwRi
	iwhUSyw/+5AZIh4tsaK1jw1i1V5GiY7Lc1lAetkENCUuTC4FqeEUsJXouNrPClFvJtG1tYsR
	wpaX2P52DvMERqFZSK6YhWTdLCQts5C0LGBkWcUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpec
	n7uJERxRWlo7GPes+qB3iJGJg/EQowQHs5II77xb2alCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eb+97k0REkhPLEnNTk0tSC2CyTJxcEo1MImGLU1szHePubr7kO2qY+EhznkJV+zWPGrSbcw+
	cXHJXsuWY949PNJCe+axCmh6z21WOFm/d5do88cGEfX93cHea6tnPtfQuPvjyMzXLJ/cSmZb
	pBcJTdsyqdnxT9ny41umyty54RY3VVfxUcorYWF24WWffpqIvPvX98Fjw9EDE284zjY25pmu
	MEOWuYPHuiqB/y6zXGbMaefCp/d2Oi59Z7vs9gOpqK6oH+pLv5UfnC40Z6LJtvtqJ7k3agS/
	Z55kIXLO8BZXYOHd2gqlA0V/xBsf+utXGxlumz5l9/Od306FTjCUdNg3c1nxpOAKxhb57PPR
	fvoeYTO2cS2UPXZU5dbZXY/P7hD9ZJ/k+FuJpTgj0VCLuag4EQB7xFK1FwMAAA==
X-CMS-MailID: 20231205162121epcas5p2c410526ed459a8e739c81fc6fe3ef4e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231204180804epcas5p30002c71ae22125ae84549258d1cf6fe5
References: <20231204175342.3418422-1-kbusch@meta.com>
	<CGME20231204180804epcas5p30002c71ae22125ae84549258d1cf6fe5@epcas5p3.samsung.com>
	<a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>

On 12/4/2023 11:35 PM, Jens Axboe wrote:
> On 12/4/23 10:53 AM, Keith Busch wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 1d254f2c997de..4aa10b64f539e 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3980,6 +3980,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>>   		ctx->syscall_iopoll = 1;
>>   
>>   	ctx->compat = in_compat_syscall();
>> +	ctx->sys_admin = capable(CAP_SYS_ADMIN);
>>   	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>>   		ctx->user = get_uid(current_user());
> Hmm, what happens if the app starts as eg root for initialization
> purposes and drops caps after? That would have previously have caused
> passthrough to fail, but now it will work.


Does it sound any better if this 'super ring' type of ability is asked 
explicitly by a setup flag say IORING_SETUP_CAPABLE_ONCE.
It does not change the old behavior. It also implies that capable user 
knows what it asked for, so no need to keep things in sync if the 
process drops caps after ring setup is done.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4aa10b64f539..589e614144b6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3981,6 +3981,8 @@ static __cold int io_uring_create(unsigned 
entries, struct io_uring_params *p,

         ctx->compat = in_compat_syscall();
+       if (ctx->flags & IORING_SETUP_CAPABLE_ONCE && 
capable(CAP_SYS_ADMIN))
+               ctx->sys_admin = 1;
         if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
                 ctx->user = get_uid(current_user());

