Return-Path: <io-uring+bounces-1612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2C68ADC5C
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 05:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CFA81C20E91
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 03:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12451C2AD;
	Tue, 23 Apr 2024 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YUMnUKHu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838C615E89
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 03:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713843827; cv=none; b=FTIDG2hhC+P1nFlaf65I+zumPuO9kkgxsXDdKd1iwFJxa10TWB+wdGvNo5qD3q0POzgb9rrY8J+uAVUFLCwOuJEzg+R2XpUfMcbgzFoICzjwX5Dg4qUCLO9M6+79fUtsTmu2El9Wl6aRJlypT4xwMQgb10epl4Ki3++9Ahdzs9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713843827; c=relaxed/simple;
	bh=hNHEA6ccYnXv3lZ/1N2MV3Y3bDt/cuPB5SfWk4zbMMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lWNuQBaMz61jX20sQR2dj7FQwe6OXKdoc2vcdQLhSsYYwaCicK5NLh3yO7h/gKRevZ4K71kpFov4URTfklQFoFEwcLSzS6VTwM5789jP9Rx3gDKEkRz8LdE364df7sxRCoBkEUFKQ2PX9HY7ykic2n6XhhpoouyH7uGIcXV6xvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YUMnUKHu; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240423034342epoutp01741ebdcc5e31207538bff13881b76da8~Iy_A2mzdx1116311163epoutp01K
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 03:43:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240423034342epoutp01741ebdcc5e31207538bff13881b76da8~Iy_A2mzdx1116311163epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713843822;
	bh=/3lH6JmubFkHYjtCbMv/Rjqjgq4yJpzd2+PUGN+/hE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUMnUKHuguqUF5uCvP2UU793sypxawpZlodjoWCsvNydLHr1fzyQHcdwqjhX/OiFM
	 5ONP99SQEbTWSFzg42nizpJCdWURj52x6L8UZD+o+A+evAXoF596iMVWVkID9jFHn3
	 rqCzQvOVcaN6rTL0u1A8oMcQUdv+A4rL7h64IHJ8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240423034341epcas5p16d4574060c424fb4367038103018e808~Iy_AMXyDy0740507405epcas5p1D;
	Tue, 23 Apr 2024 03:43:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VNnyy6pPdz4x9Q4; Tue, 23 Apr
	2024 03:43:38 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.61.09665.A6E27266; Tue, 23 Apr 2024 12:43:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240423032657epcas5p4d97f377b48bd40e792d187013c5e409c~IyvZkh1-q0716607166epcas5p42;
	Tue, 23 Apr 2024 03:26:57 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240423032657epsmtrp19fa8ee7399a25e71d6556845f2c94b23~IyvZjwKNM1313413134epsmtrp1p;
	Tue, 23 Apr 2024 03:26:57 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-5d-66272e6a7463
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	44.1C.19234.18A27266; Tue, 23 Apr 2024 12:26:57 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240423032655epsmtip1fdd4d1799bb8254f77809e6fca773541~IyvX3ceZp1684016840epsmtip12;
	Tue, 23 Apr 2024 03:26:55 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: anuj20.g@samsung.com, asml.silence@gmail.com, cliang01.li@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com, xue01.he@samsung.com
Subject: Re: Re: [PATCH v2] io_uring: releasing CPU resources when polling
Date: Tue, 23 Apr 2024 11:26:45 +0800
Message-Id: <20240423032645.2546766-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <e8c28f87-ff8a-4f30-b252-46e2260357c9@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmpm6Wnnqawc82U4umCX+ZLeas2sZo
	sfpuP5vF6b+PWSzetZ5jsTj6/y2bxa/uu4wWW798ZbW4vGsOm8WzvZwWXw5/Z7c4O+EDq8XU
	LTuYLDpaLjNadF04xebA77Fz1l12j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoTiWFssScUqBQQGJxsZK+nU1RfmlJ
	qkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkbT9yuMBWv5Ko6uVmpgnM7d
	xcjJISFgIrFg7SsmEFtIYDejxN/mgC5GLiD7E6PEzeYN7HBO3+IX7DAdf05+ZIZI7GSU2Hp8
	FQuE84NR4mrDDxaQKjYBJYn9Wz4wgtgiAsIS+ztawYqYBdYySWy8fRZoIQeHsICXxNteJ5Aa
	FgFViQ0bZoLdwStgLbHpzX+obfISN7v2M4PYnAK2Emsv3WKHqBGUODnzCdguZqCa5q2zwS6S
	EJjKIfF15TsmiGYXiW+PL7FC2MISr45vgRoqJfGyvw3KzpeY/H09I4RdI7Fu8zsWCNta4t+V
	PSwgdzILaEqs36UPEZaVmHpqHRPEXj6J3t9PoFbxSuyYB2MrSSw5sgJqpITE7wmLoE7wkJg2
	D+IEIYEJjBJNt3UnMCrMQvLOLCTvzELYvICReRWjZGpBcW56arFpgXFeajk8jpPzczcxglOu
	lvcOxkcPPugdYmTiYDzEKMHBrCTC++uPSpoQb0piZVVqUX58UWlOavEhRlNgeE9klhJNzgcm
	/bySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpisCoR+Cm3OYI76
	e8LQ5NnNSI450rK3r5x3PPPepmFK5Uxe40s5/G6bZnisF1u7XnHe3eiGop3rW48xZzU+fdaa
	skbUyHZW9NUbvJtePVmyyqNDMEX5vCtv9yepNY0vc6IV186wfR59WI29TctpmXXxQ46gha/Z
	FOcaFM+7ecfhfMDKb3EX7pd9dl++c2n/xfInm9YpbpN5EcXdvc7BOGLVPYajU/IvWXmHbUlR
	rjH/Zy2jr3goOefmYetHtbeOXgzded7ypHVLgsSrwqeHp607HfW+5n3ynXWTZ9UmCE5eNr85
	7k248bLd7efjfx+tXvk9sfLB959c4a42r555XjQ9vslEm1v9Ad/+fc3160qOK7EUZyQaajEX
	FScCANIvX8pCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnG6jlnqawc3l2hZNE/4yW8xZtY3R
	YvXdfjaL038fs1i8az3HYnH0/1s2i1/ddxkttn75ympxedccNotnezktvhz+zm5xdsIHVoup
	W3YwWXS0XGa06Lpwis2B32PnrLvsHpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRtP3
	K4wFa/kqjq5WamCczt3FyMkhIWAi8efkR+YuRi4OIYHtjBKn3jxnh0hISOx49IcVwhaWWPkP
	JA5S9I1RYuKTdkaQBJuAksT+LR/AbBGgov0drSwgRcwCe5kk7n+4ztTFyMEhLOAl8bbXCaSG
	RUBVYsOGmUwgNq+AtcSmN/+hlslL3OzazwxicwrYSqy9dIsdpFVIwEaiY44FRLmgxMmZT1hA
	bGag8uats5knMArMQpKahSS1gJFpFaNoakFxbnpucoGhXnFibnFpXrpecn7uJkZwNGgF7WBc
	tv6v3iFGJg7GQ4wSHMxKIry//qikCfGmJFZWpRblxxeV5qQWH2KU5mBREudVzulMERJITyxJ
	zU5NLUgtgskycXBKNTDpFd8784J9W1vi1av74gzU6n/9fTLxN0vOQZc/3mLy6Qu+Rr2u6Viy
	acqac9wznJtXvA23LOe4YjZvQfO1aQwpP5V+GmT/0S5dY/30isCUJaJzn+rwx/Uaxz5XOvJI
	ePGdRwzFrcavF+ewNfQe5vm7Z73uqhlnb/yZILL0rVx0+uV/X03sVX7U59Yxvvz5JvjvlFP3
	lY5Njpwrrja9ZNvOviNz1XVYD30yuzP3zf9v1SFyQZKPLh08xlX8ovKEJq93gc9V78CFPdyC
	JZ9cTPTlD/eetfX+vZ/nB9P5n4s2+5yMeeX5Mubk+9TLZjunsIocXlfMq9MpxhAyI2P7WsWQ
	C4s2HXT5VeNnw+6o5nX6hRJLcUaioRZzUXEiAJ6eQ/31AgAA
X-CMS-MailID: 20240423032657epcas5p4d97f377b48bd40e792d187013c5e409c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240423032657epcas5p4d97f377b48bd40e792d187013c5e409c
References: <e8c28f87-ff8a-4f30-b252-46e2260357c9@kernel.dk>
	<CGME20240423032657epcas5p4d97f377b48bd40e792d187013c5e409c@epcas5p4.samsung.com>

On 4/22/24 18:11, Jens Axboe wrote:
>On 4/18/24 3:31 AM, hexue wrote:
>> This patch is intended to release the CPU resources of io_uring in
>> polling mode. When IO is issued, the program immediately polls for
>> check completion, which is a waste of CPU resources when IO commands
>> are executed on the disk.
>> 
>> I add the hybrid polling feature in io_uring, enables polling to
>> release a portion of CPU resources without affecting block layer.
>> 
>> - Record the running time and context switching time of each
>>   IO, and use these time to determine whether a process continue
>>   to schedule.
>> 
>> - Adaptive adjustment to different devices. Due to the real-time
>>   nature of time recording, each device's IO processing speed is
>>   different, so the CPU optimization effect will vary.
>> 
>> - Set a interface (ctx->flag) enables application to choose whether
>>   or not to use this feature.
>> 
>> The CPU optimization in peak workload of patch is tested as follows:
>>   all CPU utilization of original polling is 100% for per CPU, after
>>   optimization, the CPU utilization drop a lot (per CPU);
>> 
>>    read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
>>    randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%
>> 
>>   Compared to original polling, the optimised performance reduction
>>   with peak workload within 1%.
>> 
>>    read  0.29%     write  0.51%    randread  0.09%    randwrite  0%
>
>As mentioned, this is like a reworked version of the old hybrid polling
>we had. The feature itself may make sense, but there's a slew of things
>in this patch that aren't really acceptable. More below.

Thank you very much for your patience in reviewing and correcting, I will
improve those as soon as possible and submit the v3 patch later.

