Return-Path: <io-uring+bounces-5428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9349EC492
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 07:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47BEC188A761
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 06:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7655F1AA7A9;
	Wed, 11 Dec 2024 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ucsq29td"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DF65661
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 06:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733897123; cv=none; b=kQdUU5F20UAZHgB3uYQvTvjrov36ciU/KbOE5WbwBUVv5lvwAIgM/3KPR5OIkRwLCaf0l+q/a/lRh9Ip+0QO8GAjEzY4t1702uFAqskTdhBOWdOPqvGNIiOYVny7sPT819/BupIV1Phv34OMax9H3WebZ8ax1sxy9aEeDP4kIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733897123; c=relaxed/simple;
	bh=Vm19+8sOgCyjcKR5yqhjiOJVXNKsya0wck8wtg9WOpM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=L0I5cHJpn/+cXa94uABoTtF+dZ/L1G13mPSfM1cBbEYwiDWLEtcy/CosdiB9F/DiXWWjIWwQl6CiM3WMJyhcwqfC+yVVhPlJwH/wIqFHG/1cvr4yqwQHLphExFVkmqq2kBuYiq7PvmcF8isg++3peFK/rSa0M9gOxiklDoIxEgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ucsq29td; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241211060518epoutp025c9101a15a2a65a75dd969bfa1adda62~QCj4ehTj60496004960epoutp02G
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 06:05:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241211060518epoutp025c9101a15a2a65a75dd969bfa1adda62~QCj4ehTj60496004960epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733897118;
	bh=Vm19+8sOgCyjcKR5yqhjiOJVXNKsya0wck8wtg9WOpM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ucsq29tdHx5dcoWteh5TVMXildanDu5GhhiQht0z+TdjXJd0Aj6aafWlge6iyJl+C
	 o0p34nSj9VmKYdqsJcrNJNQ4ocOk0RyLIOwR6tQ5d7ilEC/aC/Z+3biYkHvb9483ql
	 4nKMnxiWfb3nHXAgKXX1fYz/L7v8qo3CuZV1tWAU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241211060518epcas5p4ef4139564e0b0712747035d944e65bb1~QCj4NAmn23068330683epcas5p4s;
	Wed, 11 Dec 2024 06:05:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Y7Q7J4BBrz4x9QH; Wed, 11 Dec
	2024 06:05:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B4.CF.19956.C9B29576; Wed, 11 Dec 2024 15:05:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241211060149epcas5p4d16e78bd3d184e57465c3622a2c8e98d~QCg1bUOvW1834618346epcas5p4_;
	Wed, 11 Dec 2024 06:01:49 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241211060149epsmtrp296e709724194137f267d2e9faf7ed067~QCg1aWPr_1301813018epsmtrp27;
	Wed, 11 Dec 2024 06:01:49 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-da-67592b9c33aa
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.6D.33707.CCA29576; Wed, 11 Dec 2024 15:01:48 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241211060146epsmtip1e124f3dc0500e8c37c58f735158b5ae7~QCgzfbfBH1931819318epsmtip18;
	Wed, 11 Dec 2024 06:01:46 +0000 (GMT)
Date: Wed, 11 Dec 2024 11:23:54 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 05/11] block: expose write streams for block device
 nodes
Message-ID: <20241211055354.ozous6df7gpgjcpp@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241210194722.1905732-6-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmlu4c7ch0g3Mb5S2aJvxltpizahuj
	xeq7/WwWexZNYrJYufook8W71nMsFkf/v2WzmHToGqPFmasLWSz23tK22LP3JIvF/GVP2S3W
	vX7P4sDrsXPWXXaP8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB5nLtY4dG3ZRWjx+bT1R6fN8kF
	cEVl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa6k
	UJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpM
	yM54dsivYC1bxZ81zg2MJ1m7GDk5JARMJGZsmc3WxcjFISSwm1HiZudfFgjnE6PErWmzEZxX
	jasYYVqaPyxihkjsZJT4d/MQVNUTRon7N9axg1SxCKhKPJiyHWgwBwebgLbE6f8cIGERAUWJ
	88DAAKlnFtjMJPGxsx/sEGGBIIntRz4zg9TzAm3YuqkaJMwrIChxcuYTFhCbU8Bc4uWy/2C9
	EgJbOCRe7WmEushFYvatW0wQtrDEq+Nb2CFsKYnP7/ayQdjlEiunrIBqbmGUmHV9FlSzvUTr
	qX5mEJtZIEPi6+LPLBBxWYmpp9YxQcT5JHp/P4FawCuxYx6MrSyxZv0CqAWSEte+N4I9LCHg
	IfFqYR0kULYzSny9v49xAqPcLCQPzUKyDsK2kuj80MQ6C6idWUBaYvk/DghTU2L9Lv0FjKyr
	GCVTC4pz01OLTQuM81LL4XGcnJ+7iRGclLW8dzA+evBB7xAjEwfjIUYJDmYlEV4O79B0Id6U
	xMqq1KL8+KLSnNTiQ4ymwPiZyCwlmpwPzAt5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeW
	pGanphakFsH0MXFwSjUwXW0KnlIju/HZtrqfOdc8OwtlZ3+f+UlMvPRwf/jFPYrSJtO8Feff
	M+EILE56KL4qSal0/uuLKtyct91u+83S/bpj504Hft10J9mldz/cbj7R/mRV8wyjeaY8Crr7
	uH0OPzP2/XGzYc8b55+3pYu4T0W9nHZS8pzkmXs1x5V0b6zgjJb9uDS8j2nZ72klfa9L56Sf
	CzO3NS/53j87mWOJaPGyBL9n5xtu267//8jdgVNym0D0RLa7u8RSbp6eZs1V7DshYf7flFKO
	3/FxzisWpQkpzt4XmNgVd1DjyIQ+bx5BnXObH73YZp08e5/p0x/5e3gjd7W9U6v33H7FbrPS
	Gz2NA4VXjyXfcV/g6G5kr8RSnJFoqMVcVJwIACLN3OVTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWy7bCSnO4Zrch0gwPfzSyaJvxltpizahuj
	xeq7/WwWexZNYrJYufook8W71nMsFkf/v2WzmHToGqPFmasLWSz23tK22LP3JIvF/GVP2S3W
	vX7P4sDrsXPWXXaP8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB5nLtY4dG3ZRWjx+bT1R6fN8kF
	cEVx2aSk5mSWpRbp2yVwZTxac5G94D5zxZunIQ2MU5m7GDk5JARMJJo/LAKyuTiEBLYzSnTs
	XAOVkJRY9vcIlC0ssfLfc3aIokeMElNnXWICSbAIqEo8mLKdrYuRg4NNQFvi9H8OkLCIgKLE
	eaCLQOqZBTYzSezt/c8CkhAWCJLYfuQzM0g9L9DmrZuqQcJCAskSH/Z/ANvFKyAocXLmE7By
	ZgEziXmbH4KVMwtISyz/BzaeU8Bc4uWy/2wTGAVmIemYhaRjFkLHAkbmVYyiqQXFuem5yQWG
	esWJucWleel6yfm5mxjBMaQVtINx2fq/eocYmTgYDzFKcDArifByeIemC/GmJFZWpRblxxeV
	5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBKNTBZrZLWUNvobnFnmyWv/Dvr/rXz
	FszaZqmxK1/2TFzlikUbqm+cer5CP+vMye9zruxR/f1bL7E8Ocn3Ae/y9O2t81+aPHczf9/o
	/+Vg/Ey759rC5o1SKctsPy2Wq9t05X/hrpieVVc/ByS4sF7ervWva2ZsrZn2TnbplIedyUpr
	GYPCkze22f068s0p+ZLe8n9XbGc8ip/ntV6+Y5/o3GN5FX2P+Z58tNBeEy4ubaxy/x3X5D1m
	Nkmd/A++9VcGnmtc4Ptsy4S8nb2VF/MLVD9/qovy+sDuyjjpx/EJMsInotbI9ptEih2eVu56
	wb/z7D2mW5wMV+MvFtiu03YUS5X6rHwi9VNTFp9qMNeGcDclluKMREMt5qLiRAB/NER6EAMA
	AA==
X-CMS-MailID: 20241211060149epcas5p4d16e78bd3d184e57465c3622a2c8e98d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_75e31_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241211060149epcas5p4d16e78bd3d184e57465c3622a2c8e98d
References: <20241210194722.1905732-1-kbusch@meta.com>
	<20241210194722.1905732-6-kbusch@meta.com>
	<CGME20241211060149epcas5p4d16e78bd3d184e57465c3622a2c8e98d@epcas5p4.samsung.com>

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_75e31_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/12/24 11:47AM, Keith Busch wrote:
>From: Christoph Hellwig <hch@lst.de>
>
>Use the per-kiocb write stream if provided, or map temperature hints to
>write streams (which is a bit questionable, but this shows how it is
>done).
>
>Reviewed-by: Hannes Reinecke <hare@suse.de>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>[kbusch: removed statx reporting]
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_75e31_
Content-Type: text/plain; charset="utf-8"


------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_75e31_--

