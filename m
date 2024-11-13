Return-Path: <io-uring+bounces-4638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9159C6A58
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 09:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C080E1F266B5
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 08:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DE918B466;
	Wed, 13 Nov 2024 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JixVPPHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0FB18A6B7
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731485394; cv=none; b=uCIa4csGdALqfVPh9xtmCqZrlNPGuk161Ls0IxFyfSTb/j/rIFJLmoa9mDtYCXb36KuyaVKEXEbAwyhvyyH8ZWtZHw8qDxwwd5U8WVfm+VK7FxTHFAxjuoSp5xfAEXfCA8N73q1zs6jH5zPXHZ76J2/berqxe9cjuS3dU0AFtV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731485394; c=relaxed/simple;
	bh=wFfGVtOOO8iSnlVYHciZ1o6MJIpDCj7KgiR8xXeP6Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kFVYmkIpq44R3qjTHCxw/VImd0y3PO5jQee46rObjfqLOZ/wdNoutSUogXjopKqkxAw0W54P5VB3A4uKpg8NVk+9rFwiwqJUjxBdvmooHneJ0aOeu1ux1uXUYT70Nzd5uEGYJxCchavChM3zZNjBSG+74ub5yuiOkZNPZB8e4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JixVPPHL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241113080944epoutp0357bc1f0690cf686c353d4ee01dd85b0a~HeMh8lrhL2323623236epoutp03H
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:09:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241113080944epoutp0357bc1f0690cf686c353d4ee01dd85b0a~HeMh8lrhL2323623236epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731485384;
	bh=RyFOd82kYkkpZFtQtf0fXTlTEZle1JXlmJJowfDBW6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JixVPPHLlNJ6qK/835fo8oAu59hKYExVpj07W9qqb6Al62ZAS77atZ2U1qnAAYt5+
	 57zNG52ShGSecheM1Jh2dHW8FI9mOA9x72+LKRQOfiGe7Z+gBSXTGIufNXoxvIFOKN
	 vIELJcU89qlFdppcWe3efVFjbM3Kcl3xyZ68jU3Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241113080943epcas5p10416481432486314e444904050bece82~HeMht6oke1656716567epcas5p1Z;
	Wed, 13 Nov 2024 08:09:43 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XpGCp3z9fz4x9Q5; Wed, 13 Nov
	2024 08:09:42 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	44.8B.09770.4CE54376; Wed, 13 Nov 2024 17:09:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241113062517epcas5p22b01ddf9f29123ddcd7ffc63f2ce9254~HcxVqhlwm0903409034epcas5p2O;
	Wed, 13 Nov 2024 06:25:17 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241113062517epsmtrp11fea1240e2b0df8017fddf590eb3cfc3~HcxVp0ngY2929529295epsmtrp1d;
	Wed, 13 Nov 2024 06:25:17 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-5d-67345ec4470f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.7D.08227.D4644376; Wed, 13 Nov 2024 15:25:17 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241113062516epsmtip26896c22d9cac6aa8f62da07ee7ead0af~HcxU5zl4x2154521545epsmtip2D;
	Wed, 13 Nov 2024 06:25:16 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH liburing] test: add test cases for hybrid iopoll
Date: Wed, 13 Nov 2024 14:25:11 +0800
Message-ID: <20241113062511.3079688-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <c5848ad2-94e6-4951-9266-b21f14b848e2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTXfdInEm6wZmZ5hZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ0w7NZCn4xlpx
	7EttA+Mrli5GTg4JAROJT1NOsncxcnEICexmlLj17CuU84lR4n77YTYI5xujxOGdM1hhWk7N
	XQdVtZdR4tX5T2AJIYEfjBJtB4NAbDYBJYn9Wz4wdjFycIgISEn8vssBEmYW8Jb4/OQtE4gt
	LOAhMWXReTaQEhYBVYnGthqQMK+AtcTPz/1MEKvkJRbvWM4MYnMK2Eos2v6LCaJGUOLkzCcs
	ECPlJZq3zmYGOUdC4BK7xL+jc6GaXST2vrzJDGELS7w6voUdwpaSeNnfBmXnS0z+vp4Rwq6R
	WLf5HTRYrCX+XdnDAnIbs4CmxPpd+hBhWYmpp9YxQezlk+j9/QRqFa/EjnkwtpLEkiMroEZK
	SPyesAgabB4Skw5MYoOE1ARGifPTsiYwKsxC8s4sJO/MQti8gJF5FaNkakFxbnpqsWmBUV5q
	OTyGk/NzNzGC06KW1w7Ghw8+6B1iZOJgPMQowcGsJMJ7ytk4XYg3JbGyKrUoP76oNCe1+BCj
	KTC4JzJLiSbnAxNzXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFIN
	TGmNGzN51s91Nbu5fTHH7UetNTuY4wP3RZg86DRf8c57TWcXQ/vq1sXP3l/13X9k6i899u1t
	tQ92u1klX/bX+Cl1ojnt3LqWttRvmyqYrs4XXLvDd2cME2P8I8ZWCyuGte0Bn9bmmmx12POk
	3Orh8sQpyTU6D5hnLtjq+HZnwMQ6X7eO+eyJpdds9Mzlb3ssW7ZkoucygU1lc3a8P8WW3jd/
	3fYX5Ye9dla8TE7MYJ2udo3T93DjiZB3dU4WK3aset2f6+bEOf/xI56FHCyXunskP4usLegs
	q1wpr6q9JWHF2W8ct3Inn76W/PyJta7jTb63gjc7HxVOdjA/WZFV4x1R1bKsauPtebfVvbW4
	05VYijMSDbWYi4oTASk0d/AUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSvK6vm0m6we0rMhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBnTDs1kKfjGWnHsS20D4yuWLkZODgkBE4lTc9exg9hCArsZJda8VISIS0jsePSHFcIW
	llj57zlUzTdGiYnPzUFsNgElif1bPjB2MXJwiAhISfy+ywESZhbwl7j/bS8TiC0s4CExZdF5
	NpASFgFVica2GpAwr4C1xM/P/UwQ0+UlFu9YzgxicwrYSiza/osJYpONxMllW5kg6gUlTs58
	wgIxXl6ieets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc
	tlpaOxj3rPqgd4iRiYPxEKMEB7OSCO8pZ+N0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzfXvem
	CAmkJ5akZqemFqQWwWSZODilGpgCLjxfqqDD2rDvcFNCU1C42cKlB5VvXvOS6gufwHxS421S
	GN9GR8cFtxetCZo7JfqzksCZ5AyxkiLOA9LLlLYsmr9iesjc5+fZdbSm7mntDn3BdLPDclIC
	T4HrstZDR3yyr05SkNnsv2nllStV9gviyj5Xrd9xcca2HocX12UtK38FLV2bpquc5V7goR3F
	1fFXa714dG7WOjtjZq9n988VN146W8wQ8Sdu4SmhXVwPJic9Vz+9baNzEvvJ81E7wq7cTTMK
	n7465JDxg8nKXUzPK78n57gJxR1wS60/JdaUYvHbK8vs84+uUEtv6Ucm1toyFauVG04XPjhr
	/POfrYaLLqPLO64MswtJBTNjFyuxFGckGmoxFxUnAgC+ltVyygIAAA==
X-CMS-MailID: 20241113062517epcas5p22b01ddf9f29123ddcd7ffc63f2ce9254
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241113062517epcas5p22b01ddf9f29123ddcd7ffc63f2ce9254
References: <c5848ad2-94e6-4951-9266-b21f14b848e2@gmail.com>
	<CGME20241113062517epcas5p22b01ddf9f29123ddcd7ffc63f2ce9254@epcas5p2.samsung.com>

On 11/13/24 3:32, Pavel Begunkov wrote:
>On 11/11/24 12:36, hexue wrote:
>> Add a test file for hybrid iopoll to make sure it works safe.Testcass
>> include basic read/write tests, and run in normal iopoll mode and
>> passthrough mode respectively.
>>
>> Signed-off-by: hexue <xue01.he@samsung.com>

>If it's not covered already please add tests for failure cases.
>E.g. when SETUP_HYBRID_IOPOLL is set without SETUP_IOPOLL

I'll thinking about this part.

>> +	ring_flags |= IORING_SETUP_SQE128;
>> +	ring_flags |= IORING_SETUP_CQE32;
>> +	ring_flags |= IORING_SETUP_HYBRID_IOPOLL;
>> +
>> +	if (sqthread)
>> +		ring_flags |= IORING_SETUP_SQPOLL;

>Doesn't it also need IORING_SETUP_IOPOLL?

You're right, will fix this.

--
hexue

