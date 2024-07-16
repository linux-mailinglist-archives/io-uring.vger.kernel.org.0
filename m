Return-Path: <io-uring+bounces-2518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9AEE93211F
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 09:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91750282087
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 07:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C1C22619;
	Tue, 16 Jul 2024 07:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aM3iVPmz"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0124B29
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721114538; cv=none; b=a6+Ecqpu58FekBlIOsjHM6Y/KysBPux2o5E4vPbohai8KNXRcQvWQekDAEjtNb4VQneMUz1fP19RtWwYisdh1oVDdaGF7U8qQjz3WdYLN5HSbk4ehe+mKEb+FG4tbObJMGOXkTO0dBhpJx0kMOKgzHiO78kdasjMMs8F/vhmqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721114538; c=relaxed/simple;
	bh=CYWFic7WpGeIaUQ5kese89wQm1aU8AJ7EQWqzIEeaR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=md8JGH9kFUCg7Czd/EPzaFPkZ1xcbxORNYuYruf+dhQZBFsso3DZJDIpQNA/X1at8kpPvx6AqwXo0hu9hOrIEnW6OlA0g7yHnPpmpKOEU9gzqQ35EaMRkTaRvTRnHdlxnyD44PQR5HNG7Jhmh7GQOZrdj5vRqEA2SK0S0gB4sxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aM3iVPmz; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240716072212epoutp034e1829ea5f64cc889c990509abee4c9c~ioIxv80YF0816708167epoutp03Y
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 07:22:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240716072212epoutp034e1829ea5f64cc889c990509abee4c9c~ioIxv80YF0816708167epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721114532;
	bh=CYWFic7WpGeIaUQ5kese89wQm1aU8AJ7EQWqzIEeaR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM3iVPmz3j5pFGpPZjWmUQPyq9pJMsQ7pIMYvNQVjstngD6ibnFUhtkbZ2FVfJIuT
	 1EiRCkNy5A0V/zJbQgNL+WCNS7/69BqwmHtuQl/q1McxcYmT74wPov7ilWkbQEV1W6
	 A+t1PLqeUI9cYkyIzeY/B46ByXpY9/TsL8x11KME=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240716072212epcas5p1e1dfdece1dfb2c80241fbddaa6c6db28~ioIxLREl-2819828198epcas5p1E;
	Tue, 16 Jul 2024 07:22:12 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WNVrL15Fzz4x9QB; Tue, 16 Jul
	2024 07:22:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.88.19174.F9F16966; Tue, 16 Jul 2024 16:22:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240716071617epcas5p11b0423d0ee1c66167f7658c071384586~ioDm-qNF01664316643epcas5p1d;
	Tue, 16 Jul 2024 07:16:17 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240716071617epsmtrp2126ec89d386b07c493af9e4281c57279~ioDm_9GPf2573425734epsmtrp2a;
	Tue, 16 Jul 2024 07:16:17 +0000 (GMT)
X-AuditID: b6c32a50-b33ff70000004ae6-96-66961f9ff557
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.98.18846.14E16966; Tue, 16 Jul 2024 16:16:17 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240716071616epsmtip1afd89d557540acaaf08f5a0cce4915f2~ioDlvjpSE0109101091epsmtip1p;
	Tue, 16 Jul 2024 07:16:16 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, hch@infradead.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: Avoid polling configuration errors
Date: Tue, 16 Jul 2024 15:16:12 +0800
Message-Id: <20240716071612.1503734-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <7aba7c09-9c21-46cc-95fc-d2b9b5bbcd3b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmlu58+WlpBvt3ClrMWbWN0WL13X42
	i9MTFjFZvGs9x2JxedccNgdWj52z7rJ7bF6h5XH5bKnH501yASxR2TYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
	JakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZzSuvsxR84K64uGwjWwPj
	Ds4uRk4OCQETie+72xm7GLk4hAT2MEosv7iaDcL5xCixqKWfFc7Zs/ApM0zLjFPTmSASOxkl
	Hh17CtXyg1Hi1f4XbCBVbAJKEvu3fGAEsUUEhCX2d7SydDFycDALpEu0vfACCQsLuEhc7FrP
	AmKzCKhKvLr/FKycV8Ba4mDfRXaIZfISN7v2gy3mFLCVaO2YzQpRIyhxcuYTsF5moJrmrbOZ
	QW6QENjHLjGjcysjyC4JoAVn+pQg5ghLvDq+BWqmlMTnd3vZIOx8icnf1zNC2DUS6za/Y4Gw
	rSX+XdkDdbKmxPpd+hBhWYmpp9YxQazlk+j9/YQJIs4rsWMejK0kseTICqiREhK/JyxihbA9
	JH7OPsMOCaoJjBKnGxexTWBUmIXknVlI3pmFsHoBI/MqRqnUguLc9NRk0wJD3bzUcngsJ+fn
	bmIEp0StgB2Mqzf81TvEyMTBeIhRgoNZSYR3AuO0NCHelMTKqtSi/Pii0pzU4kOMpsAAn8gs
	JZqcD0zKeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MPG35Qo6
	VK0/O2n9VruEhds+npqvXLVKfaqMU1n1va47Zssun5eauODvidzEE8pzvp5/8dHwYrJn7tZ3
	F5encHmutpzHWSq021pVlqmAb+rXDBu9h+w3hK9Z2s6VFlgxP3EFy1yvwq6nL45n6eWq/TwS
	ZiLqoMC626p7SlHbs4CtB7i1lW6WLEp5uXP5zVdyu9Nmv/SZZNvUbyE93SAgN+7D+QINfsmo
	rSYXytlPrZmnlRH/wiL8X4A6/8HZWS/YIoXrH+dfupXNLHC88OW9hqvqZmZhM+4cMTQ+LnBJ
	xvZhwFLVTxEvX8w9E7NPQLE05vmjtZPjrOLtGHLW7LbMspXbduHb0eAA5wu1R7Md1ymxFGck
	GmoxFxUnAgCx0nQGEgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnK6j3LQ0g+3dYhZzVm1jtFh9t5/N
	4vSERUwW71rPsVhc3jWHzYHVY+esu+wem1doeVw+W+rxeZNcAEsUl01Kak5mWWqRvl0CV0bz
	yussBR+4Ky4u28jWwLiDs4uRk0NCwERixqnpTCC2kMB2Romfc3gh4hISOx79YYWwhSVW/nvO
	DlHzjVHi4FJREJtNQEli/5YPjCC2CFDN/o5WFhCbWSBbYu+sa2C9wgIuEhe71oPFWQRUJV7d
	fwpWzytgLXGw7yI7xHx5iZtd+5lBbE4BW4nWjtmsELtsJI482ssEUS8ocXLmE6j58hLNW2cz
	T2AUmIUkNQtJagEj0ypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4EDVCtrBuGz9X71DjEwc
	jIcYJTiYlUR4JzBOSxPiTUmsrEotyo8vKs1JLT7EKM3BoiTOq5zTmSIkkJ5YkpqdmlqQWgST
	ZeLglGpgMur/esojWXfBnpv+0noFm6r3Rq3cemu7937GrbUPDJp9euRijm0zTnxyMiPpVn3t
	4js1Jsev1Cj4WSv6dQaWFOhlHS/PrfwVLLrZ7bnsjIONq/qWW8nGpcrnFMQ4nbaxlbsqs7w6
	kjFx706m21v7TPsT9R5a8u9q8StoeTTlzZV7V36znCh5rMiySvX4s7nCU2qWOYfrn/w1PcDN
	8X7w/4m7Sw7M3HxnQceeVIMVv9KmTVZdEse2/dc2lnSDt3a7ci6vai33jyydaVzg3FHxVX2f
	llfeTQsXjQXLJV7PCGF60RGxkod/p6ZS9Revhe1bf+ecWTM5/vzZX5xm/vM+RYtc6OzT+bFk
	XTXLwx2hSizFGYmGWsxFxYkAtEay5cMCAAA=
X-CMS-MailID: 20240716071617epcas5p11b0423d0ee1c66167f7658c071384586
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240716071617epcas5p11b0423d0ee1c66167f7658c071384586
References: <7aba7c09-9c21-46cc-95fc-d2b9b5bbcd3b@kernel.dk>
	<CGME20240716071617epcas5p11b0423d0ee1c66167f7658c071384586@epcas5p1.samsung.com>

On 7/15/24 10:59 AM, Jens Axboe wrote:
>On 7/14/24 8:39 PM, hexue wrote:
>>> My stance is still the same - why add all of this junk just to detect a
>>> misuse of polled IO? It doesn't make sense to me, it's the very
>>> definition of "doctor it hurts when I do this" - don't do it.
>>>
>>> So unless this has _zero_ overhead or extra code, which obviously isn't
>>> possible, or extraordinary arguments exists for why this should be
>>> added, I don't see this going anywhere.
>>
>> Actually, I just want users to know why they got wrong data, just a
>> warning of an error, like doctor tell you why you do this will hurt. I
>> think it's helpful for users to use tools accurately. and yes, this
>> should be as simple as possible, I'll working on it. I'm not sure if I
>> made myself clear and make sense to you?
>
>Certainly agree that that is an issue and a much more worthy reason for
>the addition. It's the main reason why -EOPNOTSUPP return would be more
>useful, and I'd probably argue the better way then to do it. It may
>indeed break existing use cases, but probably only because they are
>misconfigured.
>
>That then means that it'd be saner to do this on the block layer side,
>imho, as that's when the queue is resolved anyway, rather than attempt
>to hack around this on the issuing side.

Implementing it at the block layer is indeed more reasonable, thanks for
your affirmation and suggestion, I will look for an appropriate place in
the path to perform the check. Thanks.

