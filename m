Return-Path: <io-uring+bounces-1639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B78E58B28B6
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 21:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F72B2822F4
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 19:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDC91509B1;
	Thu, 25 Apr 2024 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N+ac4jHa"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8815099C
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714071954; cv=none; b=msWofq6xKghO5xcIswL6hB/dpRwk6VLs8Pija5Af+bwyJ4xIOKWF7zKnnlB7lEojE4Pr1rkD5pvbahWbvW3zEIhW/bQ+ZSTkOSAsSGgZfIhANnIfqoWHKHAVWfP0mrAGEpdyTTYw1xU+kbSPfXn8H6HNVysAPv2hbP8D0Tr2uLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714071954; c=relaxed/simple;
	bh=c8hEzC0av1LFbIqhp+2+0Uw8vZUNUY0UZz0gqmRpmUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=OZuRZgbbCANfVxo8QOqw6y6Xqm0hM8Ba1SPwHIq6nig7bmn3ThMRNJCA2r5hxw3DMutYb1MiPRchiSLrGslT14EjE9Tj1toBcOPqTIhWj9kr2ropFcv+9BT2PIDDSMxdhhyO5+O4tGv2M7smRuuvKRzqjQ43K+iLXT35jaiPL1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N+ac4jHa; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425190549epoutp01228ba1f6d0fd23145cc9c995a1daca37~Jm1s9Yd561880418804epoutp01O
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 19:05:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425190549epoutp01228ba1f6d0fd23145cc9c995a1daca37~Jm1s9Yd561880418804epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714071949;
	bh=151Oaj2s9Y1sdU/FgXIre2kL6k2ZCPieMl5MCzcqUo8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=N+ac4jHa4EWbwtKLfb1A/g4c2V+9GrqEQobBVwYV5mk0g0TF4CeQ25W5dGDMTDBhE
	 BIwRQT7hohp4uQ0LjTuBM/lEnINKQwfmBhEPPuMS9JDmTaHnJc2Br3c11Cwr1JhUrA
	 /ERJ/JfTizC+yrD0Ch1L9WR3gDlO92b8fSCFv4j8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240425190548epcas5p29ea0fe2600c2b1bc86ab497e5a3bb482~Jm1sORmj40538105381epcas5p2p;
	Thu, 25 Apr 2024 19:05:48 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VQQL32HJZz4x9Pq; Thu, 25 Apr
	2024 19:05:47 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	07.F7.19431.B89AA266; Fri, 26 Apr 2024 04:05:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240425190546epcas5p4c7f30b1c106e19da80290ad6a26e8620~Jm1p-csxy0110401104epcas5p4L;
	Thu, 25 Apr 2024 19:05:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425190546epsmtrp1932629e7a7874f7536436d9a63101f36~Jm1p_vCTV1088510885epsmtrp1S;
	Thu, 25 Apr 2024 19:05:46 +0000 (GMT)
X-AuditID: b6c32a50-f57ff70000004be7-69-662aa98b3424
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.68.08924.989AA266; Fri, 26 Apr 2024 04:05:46 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425190544epsmtip1a297c966f8b0a97ba75c11dd0fedd390~Jm1ov55cN0909109091epsmtip15;
	Thu, 25 Apr 2024 19:05:44 +0000 (GMT)
Message-ID: <0811b271-9323-85cc-5b01-85021cb0a861@samsung.com>
Date: Fri, 26 Apr 2024 00:35:43 +0530
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
To: Pavel Begunkov <asml.silence@gmail.com>, martin.petersen@oracle.com,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <0c8f64b3-8ca7-4424-ac50-08222f6401c1@gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmlm73Sq00gxWnuC0+fv3NYjFn1TZG
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0rZYfvwfkwOHx85Zd9k9Lp8t9di0qpPNY/fNBjaP
	j09vsXh83iQXwBaVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1
	xMrQwMDIFKgwITvj6ZZrjAV72Sv+fv7J0sD4h7WLkZNDQsBE4nXHeyCbi0NIYA+jxI3Tu9kh
	nE+MEt+nzGaGcL4xSvT/PALX8vHpQiYQW0hgL6PEzetlEPZbRolpV2tAbF4BO4meKZPB6lkE
	VCW2tfxigogLSpyc+YQFxBYVSJb42XWArYuRg0NYwELi2iVHkDCzgLjErSfzmUDCIgKVEqt/
	WEKEgyRevmkBq2YT0JS4MLkUxOQUsJU4s8sHokJeYvvbOWAHSwhM5ZDYOfcHG8TBLhKv1+5h
	h7CFJV4d3wJlS0m87G+DspMlLs08xwRhl0g83nMQyraXaD3Vzwyyixlo7fpd+hC7+CR6fz8B
	O1JCgFeio00IolpR4t6kp9BgEpd4OGMJlO0h0fBqAhMkLA8wSrS1LmebwKgwCylIZiH5fRaS
	d2YhbF7AyLKKUSq1oDg3PTXZtMBQNy+1HB7Zyfm5mxjBKVUrYAfj6g1/9Q4xMnEwHmKU4GBW
	EuG9+VEjTYg3JbGyKrUoP76oNCe1+BCjKTByJjJLiSbnA5N6Xkm8oYmlgYmZmZmJpbGZoZI4
	7+vWuSlCAumJJanZqakFqUUwfUwcnFINTBXi+4ri35buOdmw4qW66Zl0UX23zZ/L7k8yOnDq
	xNf3h3OXlzmePP/5unXZZNdZjcrnqy/t0Fiu+9jJ/HVzfJvl3p0THbzC2wufn+iblufWu8Kb
	4+S7TZuld8ib/xNtrOQKcwud/WdTnWJPx/2YErGrGpXP77MlWkfWa+nM/TtVclXS31TpX6We
	HwuCFrobV77V++S5cNPit9KXos68eVlVXbZ3heSFwzO9fneWdT/rn9u4+qmG0aKQrUc0d0W9
	ynG2Xcz+6fwcHq85SoquWmt2cC/omagfJMwhJO/MwBhVfCgs6b5+zpYjzZe/VNntvFUo6Ja8
	WHNjqmrJtfwG9lsZ+ee3bN5zNSPg8y8zYyWW4oxEQy3mouJEAEVidXcyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnG7XSq00g13HmC0+fv3NYjFn1TZG
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0rZYfvwfkwOHx85Zd9k9Lp8t9di0qpPNY/fNBjaP
	j09vsXh83iQXwBbFZZOSmpNZllqkb5fAlfF0yzXGgr3sFX8//2RpYPzD2sXIySEhYCLx8elC
	pi5GLg4hgd2MErNfLmSBSIhLNF/7wQ5hC0us/PcczBYSeM0osfRhNYjNK2An0TNlMtggFgFV
	iW0tv5gg4oISJ2c+AZsjKpAs8fLPRKBeDg5hAQuJa5ccQcLMQONvPZkPVi4iUCnx6X4jE0Q8
	SGLW01ksEPccYJT4dG8bK0gvm4CmxIXJpSAmp4CtxJldPhDlZhJdW7sYIWx5ie1v5zBPYBSa
	heSIWUi2zULSMgtJywJGllWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMERpKW5g3H7
	qg96hxiZOBgPMUpwMCuJ8N78qJEmxJuSWFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6Yklq
	dmpqQWoRTJaJg1Oqgclf5XVqsG7vJLZ81r5OpVca/9wXcMj7+WS5L2bx3tRTvmk3w+bHra3m
	YjqXHlz1zbgXMt9lg+Ubtr7zk1bpihfMmGr0MSL/RABLnTGXaN407UWxe+xeC+zj/v3Y7M5k
	7++i2cqmTjWnNQo+3exY9yO1IPi2RlzBonq9HxqnJ8t2X2h3XHL/zkGfNtWMnK0aQqn5Lxdo
	/bpw2qNSZcM84zkTTj/v+r7kwIWyix5zMzLt67c+NGN+POuM0runt3blqSg9TgmL+j9plfnn
	Cu3poT3C5xdGOS+0jTpbv2Xj4+8/Lr1xinx/levRprJ1rEwske+eShZN7IkU9/1xg6GKY5I+
	/4OmTsbIN9v0ah8WzlNiKc5INNRiLipOBAC8C+31DwMAAA==
X-CMS-MailID: 20240425190546epcas5p4c7f30b1c106e19da80290ad6a26e8620
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563
References: <CGME20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563@epcas5p3.samsung.com>
	<20240322185023.131697-1-joshi.k@samsung.com>
	<0c8f64b3-8ca7-4424-ac50-08222f6401c1@gmail.com>

On 4/7/2024 3:00 AM, Pavel Begunkov wrote:
> On 3/22/24 18:50, Kanchan Joshi wrote:
>> This patchset is aimed at getting the feedback on a new io_uring
>> interface that userspace can use to exchange meta buffer along with
>> read/write.
>>
>> Two new opcodes for that: IORING_OP_READ_META and IORING_OP_WRITE_META.
>> The leftover space in the SQE is used to send meta buffer pointer
>> and its length. Patch #2 for this.
> 
> I do remember there were back and forth design discussions about that
> back when some other guy attempted to implement it, but have you tried
> to do it not as a separate opcode?

Did not try that in the first cut, thinking it would help in not 
touching the hot (non-meta) io path. But open to this.

> It reads like all read/write opcodes might benefit from it, and it'd
> be unfortunate to then be adding IORING_OP_READ_META_FIXED and
> multiplicatively all other variants.

Right, that's a good point.

