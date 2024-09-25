Return-Path: <io-uring+bounces-3305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACCA9861F1
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 17:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D92BBB2B851
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 14:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB6C18C341;
	Wed, 25 Sep 2024 13:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lc2HD6bl"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A7A18C022
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727270493; cv=none; b=i8bqoR7oo2cxo0/KwXsqc2v7T+yp7mzYR0VZQUVKyMgvI/Iwl8XwvrT9TmzS+/y1v6/Tw1/sojd+cyBLG6MMfJObUASqvpR2l1Eq1OMrPmyuxXlkuWEMIeiky4bTJ+tR2ZKkRgZLpdzOBmtcqZoYN23x+tRKWpZczHrfeJKpN2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727270493; c=relaxed/simple;
	bh=mnoe8Xd1F7ztDH7Q61E4LvL1QadZ2xUAO++ntgsh7/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=rgUzjDwaiXTKmeB5y2KE2lrup5OI4WxLfE4hc7ebWZGRVuxG2wzpKxQzDIWgqxtL+YRj2dvy38FhWQj7eldgcU4tdoXOQPV7eVPGGH0khyNQkbuYksgSMR5HE63KSVXb5nlQIrKt+doQR/uULyoErB14Wm1tPTPpAP+/E4MQpfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Lc2HD6bl; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240925132127epoutp031e9f4cd6a15704e2bf5fc8ab26e85024~4f1tV1YXa1330913309epoutp03d
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 13:21:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240925132127epoutp031e9f4cd6a15704e2bf5fc8ab26e85024~4f1tV1YXa1330913309epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727270487;
	bh=+1Yc1j/F9EUOGjp4C92RegYtPjoX8rRZqa0vTdTHK48=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Lc2HD6blpJLV/4WfxwsAMpBsi8DR/GOPrjWsVCPHq5pNPwKz1Gs5TMn5c8GQkysLI
	 5omKhiT71xcyqH1j/ZPBXqq2N/H1VD5qhpZb2PAV0d9v+dXE9fnnWpCb7McLLolakE
	 0WNG7VZu3dH6EYYYyk1EtjeTpayhfHnFRxa3wYyM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240925132126epcas5p2b8370189c618a80127d8cb97c040f7a7~4f1somcHI0162601626epcas5p2T;
	Wed, 25 Sep 2024 13:21:26 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XDHS52bxdz4x9Ps; Wed, 25 Sep
	2024 13:21:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	80.A5.08855.55E04F66; Wed, 25 Sep 2024 22:21:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240925132124epcas5p1cc362b7e5fec64e41bde11aec1ab9ea5~4f1qS-viC2284122841epcas5p1t;
	Wed, 25 Sep 2024 13:21:24 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240925132124epsmtrp1de7dc004f5a08b5d887f6fa16623a015~4f1qSD7971595215952epsmtrp1w;
	Wed, 25 Sep 2024 13:21:24 +0000 (GMT)
X-AuditID: b6c32a44-15fb870000002297-b7-66f40e5581c4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.C3.19367.35E04F66; Wed, 25 Sep 2024 22:21:23 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240925132120epsmtip1fc0524d7ed2f4e6e95512f107b748adb~4f1nR6kh43096430964epsmtip1w;
	Wed, 25 Sep 2024 13:21:20 +0000 (GMT)
Message-ID: <8665404f-604e-ef64-e8d7-2a2e9de60ba7@samsung.com>
Date: Wed, 25 Sep 2024 18:51:20 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Hannes Reinecke <hare@suse.de>,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Nitesh
	Shetty <nj.shetty@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <cb3302c0-56dd-4173-9866-c8e40659becb@gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1DTZRzH7/nuyzYo3NcJ8UCezVXegYFbwXzwQEyJ+wqeoV53FiEt9uXH
	bWxrP0Cgu8gOyl0OGYY0EEwpYXJ4DAQGA71JN1H5kQQBDV0xSuCGAXYlBLQxIv97PZ/P+33v
	5/N57mHS2GWMIGamVEUppEIJl+6Dt9wKDgl9Z9OTNN5tPQtVGloAujpeTEealWYczdyaB6js
	j6c0NHtqCUejN00YMl/SYaju6vcYmi3sw1HF+c8w5Limp6EJ2wID6SzDAJ0rOwVQ59hOZO7s
	wVH1d5MMdMW6gqGWpWoaaph5jKP+ZasX6tdXMvYFkIM/JpAm/TiD7H/QiJODvWrSaDhNJ43z
	OgbZVPMJ2TFaQCfnJsdw8nHXEJ3UNhsAee9it6t5N59cMG4jjQ4nlsh6TxyVQQlFlIJDSVNl
	okxpejQ34VjKgZQIAY8fyo9Eu7kcqTCLiubGHkoMjcuUuHbA5WQLJWpXKVGoVHJ37Y1SyNQq
	ipMhU6qiuZRcJJGHy8OUwiylWpoeJqVUe/g83usRLuEH4ozZykeYvIR50jltoheARroGeDMh
	EQ6nJ0cYbmYTHQA2n35FA3xcPA9gZ3UTtnFwtmoYG47yy7inYQKwR9u3bncCWDGb7GZfYi+c
	LDhHczNOvAqHp/6me+qbYc/XDtzN/sSHcHGoErh5CxEHmyr6vdxMIwLgmKN6LdmPMGHw9+WH
	dPeBRqwC+FWdwaViMulEMBwoVbvRm4iGc/YTHu9LsNVZSXPLIXHDGzospZjn1rHQbm/GPbwF
	Tlub16cJglPFResshvZf7euaj2Fbk9bLwzGw4J+RtViaK/Za+y5P1iZ4ZsmBucuQ8IVfFLE9
	6u3wgW5y3RkAfymv8fJISKhZPuxZ230M6qYasbOAo39mK/pnptc/M43+/+CLADeAQEquzEqn
	UiPkfCmVs/HcqbIsI1j7ICGxbWCkeiXMAjAmsADIpHH9fHWjc2lsX5EwN49SyFIUagmltIAI
	1/OU0IL8U2WuHyZVpfDDI3nhAoEgPPINAZ8b4DtTeEHEJtKFKkpMUXJK8Z8PY3oHFWDPr34e
	efd624HzXBtrtWX5uslywvnbRM3TrbJs0p6fPWC9uZg0ZDOHmi0Nmi8f2pNfCNhzKHfHQved
	Ny//FdpRP/Hn23NHqnKOaI/Xq80/JwR+GtX1TVVR1ftgoEXbvhI3ulj6shcLTxhOHjLyrqjr
	XsyLqt3fwW+focyHbfPlTxrz7MYLtuAYa28WK95vlX20py3wUq6O+e3x2nf9WfcT2IzsnO3i
	sJKF27263UofwbYbkj4+ETNm08RSE0kN8Zoigah1q+FMzXh+ak7XkvZk0sGDZfU7jg7WxFGF
	jyLFzxXv3CwpP1b5U0h3oJVzJ62PN3LvtfiPbEv794W8VWsK+yGQiyszhPwQmkIp/Bd5Uipy
	qQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWy7bCSnG4w35c0gxc3rCzmrNrGaLH6bj+b
	Rde/LSwWrw9/YrSY9uEns8W7pt8sFjcP7GSy2LNoEpPFytVHmSzetZ5jsZg9vZnJ4sn6WcwW
	j+98ZreYdOgao8WUaU2MFntvaVvs2XuSxWL+sqfsFsuP/2Oy2PZ7PrPFutfvWSzO/z3OanF+
	1hx2B3GPy1e8PXbOusvucf7eRhaPy2dLPTat6mTz2PRpErvH5iX1HrtvNrB5fHx6i8Xj/b6r
	bB59W1YxepxZcAQoebra4/MmOY9NT94yBfBHcdmkpOZklqUW6dslcGW8m/OCqWAiR8XbVzvZ
	Ghg3snUxcnJICJhIvJqxmKWLkYtDSGA7o8SfXXNZIRLiEs3XfrBD2MISK/89Z4coes0o0XRq
	Mlg3r4CdxNOGKcwgNouAqsS1lz+g4oISJ2c+YQGxRQWSJPbcb2QCsYUF3CQ2zz4PtoAZaMGt
	J/OZQIaKCOxkkvi48T8biMMs8J9RouPYMiaIdZeYJHa93QCU4eBgE9CUuDC5FMTkFLCV+Pgg
	DmKQmUTX1i5GCFteYvvbOcwTGIVmIbljFpJ9s5C0zELSsoCRZRWjaGpBcW56bnKBoV5xYm5x
	aV66XnJ+7iZGcKrQCtrBuGz9X71DjEwcjIcYJTiYlUR4J938mCbEm5JYWZValB9fVJqTWnyI
	UZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXAtGty91rZVe5KTw30j9rtT5U90HPz0buu
	I1u55tobHwuyyKmdd4VhWvP1rz9+WLO73TH4v/O5cvSMKWtkub1UZTae4+jWOr4gyY35iekh
	YQ2lrUFL5zL9zNryWrdU1KWIffO67WoMpQtEP3JPaWx8YzTDsKnJ8olqVtgcnbBvwVYL20zO
	r/nXsD5c535PaaF0dxun9QuR2Y9vVzWeePDfj8v1BXMiT73B5e8v9r/UuN75fpJoq/bCIl2e
	617qXBm/PPndHsw8+TV86uppvWuqFba+2b/yNkOE8oHrwU6Psz7naGQFp/9b/e349F6u3ILV
	7zYvVuP89zp7sWVYhcn14wxBqXILZeI7bh345/34sBJLcUaioRZzUXEiAE9puQyEAwAA
X-CMS-MailID: 20240925132124epcas5p1cc362b7e5fec64e41bde11aec1ab9ea5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53
References: <20240924092457.7846-1-joshi.k@samsung.com>
	<CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>
	<20240924092457.7846-4-joshi.k@samsung.com>
	<28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>
	<678921a8-584c-f95e-49c8-4d9ce9db94ab@samsung.com>
	<cb3302c0-56dd-4173-9866-c8e40659becb@gmail.com>

On 9/25/2024 5:53 PM, Pavel Begunkov wrote:
> On 9/25/24 12:09, Kanchan Joshi wrote:
>> On 9/25/2024 11:27 AM, Hannes Reinecke wrote:
> ...
>> As it stands the new struct will introduce
>>> a hole of 24 bytes after 'hint_type'.
>>
>> This gets implicitly padded at this point [1][2], and overall size is
>> still capped by largest struct (which is of 16 bytes, placed just above
>> this).
> 
> For me it's about having hardly usable in the future by anyone else
> 7 bytes of space or how much that will be. Try to add another field
> using those bytes and endianess will start messing with you. And 7
> bytes is not that convenient.
> 
> I have same problem with how commands were merged while I was not
> looking. There was no explicit padding, and it split u64 into u32
> and implicit padding, so no apps can use the space to put a pointer
> anymore while there was a much better option of using one of existing
> 4B fields.

How would you prefer it. Explicit padding (7 bytes), hint_type as u16 or 
anything else?

