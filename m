Return-Path: <io-uring+bounces-4019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D939AFA42
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 08:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E65291F2299E
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 06:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEFA18E029;
	Fri, 25 Oct 2024 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZY47b+MV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB8518CBFF
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838847; cv=none; b=jyItC/tV1Yu1yPtCp6hSrOowY/qy6qzFjdQ/eB9PN5b1wXOin8DbmoyW3UmlmHummll9n+AyeLsU4hafUGa7p6P3mnlQmskAkor+f+aNZNfDyDOQfWqsDa2W6jS+nqR6YSLwRbYnb0HRt8wVpDidUbM7k+29iSWHUnqVz8CCYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838847; c=relaxed/simple;
	bh=y+GFTNaiiNCvu/E/cjxjx3vJfDPj/k5tRFPQhzmKTsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IDNror/tHgq2s0rAE+iyNzibSINNoQF3hdmeVHz0M89hMOfKEkbHup/T/tW0hUBUCRLFChHqUTH6iQgVmPhmp0wYJsdn1MXYC4yKMDShnCHrCQKsOgBWYrTJ+pDIMGIDOi/2XQtzjjCbAfKqAy9ENZrQR+PrzK4P5koJ95z9pss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZY47b+MV; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241025064715epoutp03ded5ca31c649b8d60bed81cc1f46a4c6~Bn0GTiA6L1745317453epoutp03o
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 06:47:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241025064715epoutp03ded5ca31c649b8d60bed81cc1f46a4c6~Bn0GTiA6L1745317453epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729838835;
	bh=y+GFTNaiiNCvu/E/cjxjx3vJfDPj/k5tRFPQhzmKTsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY47b+MVTvbUdMvg5iDizzo5uhcjRTOYE85MRF4/qLG3EaFkO6aMGl7BwfdYmOS59
	 oZ6tNi17OdmpagDT2qaQUdwD7tg961JMjetKoWBVAph2BxSFnMVfvPbGZK+ShlexEd
	 b/vLYWtKUng/Jt7qXqwVNGnKjhC3basDn1az9LY0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241025064715epcas5p39d505507a9186a50445807615f7baae2~Bn0GBZQVX2439624396epcas5p3F;
	Fri, 25 Oct 2024 06:47:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XZYHP5DvFz4x9Q7; Fri, 25 Oct
	2024 06:47:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	71.53.09770.1FE3B176; Fri, 25 Oct 2024 15:47:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241025061108epcas5p173629b3149be6e3b96853eb32e61b9ab~BnUjsgopU2531625316epcas5p1A;
	Fri, 25 Oct 2024 06:11:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241025061108epsmtrp1a03e57351e610dc599c005daec147395~BnUjrVCJG0440304403epsmtrp10;
	Fri, 25 Oct 2024 06:11:08 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-30-671b3ef1df61
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1C.44.08229.C763B176; Fri, 25 Oct 2024 15:11:08 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241025061107epsmtip19e31d0d8b4e4ae59263c4efb1492dfeb~BnUi1KX5U2452724527epsmtip12;
	Fri, 25 Oct 2024 06:11:07 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v8] io_uring: releasing CPU resources when polling
Date: Fri, 25 Oct 2024 14:10:59 +0800
Message-Id: <20241025061059.1172576-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <62e57b0e-b646-4f96-bb83-5a0ecb4050da@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTQ/ejnXS6wfaJahZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ+153MRbsYa14
	evkdawPjGpYuRk4OCQETiaXfj7N3MXJxCAnsZpR4dG0zE4TziVHi6eWpzBDON0aJ2Q8+w7X8
	fH0Qqmovo8TuSV9ZIJwfjBLPf55jBKliE1CS2L/lA5gtIqAt8frxVLBuZgEribNzfoLZwgJe
	Eu83gizn5GARUJX4/2slK4jNK2AtsfzcWnaIbfISN7v2M4PYnAK2Ev87drND1AhKnJz5BGqm
	vETz1tlgp0oIXGOX6G8+ztbFyAHkuEj0LuCGmCMs8er4FqiZUhIv+9ug7HyJyd/XM0LYNRLr
	Nr+D+tJa4t+VPSwgY5gFNCXW79KHCMtKTD21jgliLZ9E7+8nTBBxXokd82BsJYklR1ZAjZSQ
	+D1hESuE7SEx79cesLiQwARGiVffgiYwKsxC8s0sJN/MQti8gJF5FaNkakFxbnpqsWmBUV5q
	OTySk/NzNzGCk6OW1w7Ghw8+6B1iZOJgPMQowcGsJMJ7MUMyXYg3JbGyKrUoP76oNCe1+BCj
	KTC4JzJLiSbnA9NzXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFIN
	TN33bQ4cr1xvLery9c8HvkP7UybcnOyl+EFpwanba9bFKk71kM/T9ZrjMHH5kv7GOv3QNPcP
	wWs/7Yj/MMU5PPsa+ztx5/UOslmCOkECAa1sC/8unVc++cDagPm7pAzk0o0PqmszTRfaVcE4
	v99887XJ7PeNfl/3cUn93aK755OYdEhDlEPUCi2G/mD10EcTblvbn6qb/v//2l/zG0UtOuNP
	9Xf8abpweJL3bp6ctNR4hk/rRd/knKsse5bbMt39kEzQhcQPUWyd6q9yuSY97LQ41FibtNdJ
	kIM5YauYurKB5IQXS/TzitJ/b06Zf+BnT39t2glR55MTXqwNd9rKeuGY9Dwtsy8PFcMNnH7f
	UGIpzkg01GIuKk4EAMetzqkXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSnG6NmXS6wdYZQhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBn7XncxFuxhrXh6+R1rA+Mali5GTg4JAROJn68PMnUxcnEICexmlNgwYwozREJCYsej
	P6wQtrDEyn/P2SGKvjFKzJjfCVbEJqAksX/LB8YuRg4OEQFdica7CiBhZgEbiZ0tW9hBbGEB
	L4n3G4+D2SwCqhL/f60Em8krYC2x/Nxadoj58hI3u/aDjeQUsJX437EbLC4ENGdC/2k2iHpB
	iZMzn7BAzJeXaN46m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefn
	bmIEh6+W5g7G7as+6B1iZOJgPMQowcGsJMJ7MUMyXYg3JbGyKrUoP76oNCe1+BCjNAeLkjiv
	+IveFCGB9MSS1OzU1ILUIpgsEwenVAOTxPRXUaIOJkJLeIyYX7ZLXXwwvfPpNVHLXmH+nznf
	/214fXJW8cJlqcYBS3l3zrzmlzdXz5K9NCrvQsbOkLM3PCWnSn3rzw5YYbFG8t0vlqS4Ew0G
	/IEfXmiktEUe3SEuM/HS/d0Sl3vPvPjso9j1vH917LqLn67tu1cooZj+NNoyRUpAfdZXvU1N
	Nm+eb9htsNjwd3a/aMzX1osWOtuWpXGIVsbemNz4PaeWeXfdk37l2+08nxmEdocIqBWZSkm0
	lWz5EanJ4qaxiTEuxUegwf7Wuq3pn08HfV7uGrXiUsHGD/OX6XZ/2q1w9lVKzOOrnGWqbR9C
	FDjfbhGQyPIrb5HbG6a6zJiJT6mJZ5MSS3FGoqEWc1FxIgAQAnMYzgIAAA==
X-CMS-MailID: 20241025061108epcas5p173629b3149be6e3b96853eb32e61b9ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241025061108epcas5p173629b3149be6e3b96853eb32e61b9ab
References: <62e57b0e-b646-4f96-bb83-5a0ecb4050da@kernel.dk>
	<CGME20241025061108epcas5p173629b3149be6e3b96853eb32e61b9ab@epcas5p1.samsung.com>

On 10/24/24 14:49 Jens Axboe wrote:
>On 10/24/24 8:49 AM, Pavel Begunkov wrote:
>> On 10/24/24 15:40, Jens Axboe wrote:
>>> On 10/24/24 8:26 AM, Pavel Begunkov wrote:
>>>> On 10/24/24 15:18, Jens Axboe wrote:
>>>>> On 10/23/24 8:38 PM, hexue wrote:
>>>>>> On 9/25/2024 12:12, Pavel Begunkov wrote:
>>>> ...

>Ah true, well some other spot then, should be pretty easy to find 8
>bytes for iopoll_start. As mentioned, the point is really just to THINK
>about where it should go, rather than lazily just shove it at the end
>like no thought has been given to it.

Thanks a lot for these suggestions and help. I will revise and submit a
complete v9 patch, thank you very much.

--
Xue

