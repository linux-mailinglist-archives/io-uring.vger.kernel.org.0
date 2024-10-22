Return-Path: <io-uring+bounces-3895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 013439A9D46
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 10:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 828071F24D52
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 08:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D48152166;
	Tue, 22 Oct 2024 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cRis2EHz"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55E156F34
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 08:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729586641; cv=none; b=cArkjm/Ipm4TlXAO5BjnOxY41UDNFK1LSxaX9HAr4pIPqQfHPnWne37/jdOUzAmIsZM1w7QEsRQZZBaUL6fT7XSE/NDl67tcNwfZgv4sZazfjL2NwKVBBvBP+ObBcI1q3cIybOiJzIF+d98s/dzrYkbdQZqoxwwQkjZAWRzdD5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729586641; c=relaxed/simple;
	bh=Kg5upAyQd/IcXa5QPonlkuKEgLKCbf1rFuf2R59/2mc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=NOflVIwxL2EKzFjk7SkQDxWgnuUJ3Xfkk9Z0WV+oyQ7ALQXzN2agESZXuh20MRVTaMo0c8YRzHeKXcJn/1lDyKMrReFkex/q4IGQqU8shA++hG3rYxw4NIoyTlqRfZOwiLWVir+mWUzz5jnkE1qYn3DzpyP7UwkJ84n24Wodvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cRis2EHz; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241022084349epoutp02a6d209949688276b81620925bf7920d7~AueBN48nL2158621586epoutp02b
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 08:43:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241022084349epoutp02a6d209949688276b81620925bf7920d7~AueBN48nL2158621586epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729586629;
	bh=+o2/KGXm9M8IMCoU7kYADvQJdYx+Hha09iNLOgy6o7k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cRis2EHz1hqsT4EuAUQDOQXURllIT76JSPHhbfJ3VdRzFAqz/rdiI20P96iO2r5As
	 kouh8loBTwlJaxVj4+aSmkAqZrakt6/nZWANflRoZQ2b7Lg8z8jgMlpi2eqMNhVohV
	 3hyCcQriKG/eTZas2q214QSCE1qjIuG6OK/YHsGs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241022084349epcas5p44bdac262e20e7102963f178f1ede2380~AueBC6huN0314903149epcas5p4h;
	Tue, 22 Oct 2024 08:43:49 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XXm1J2gdYz4x9Q7; Tue, 22 Oct
	2024 08:43:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5D.F0.18935.3C567176; Tue, 22 Oct 2024 17:43:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4~AucgCz1cL0106901069epcas5p10;
	Tue, 22 Oct 2024 08:42:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241022084205epsmtrp13715de901205bfa8185708d15d87bbe8~AucgCMRCS2241822418epsmtrp18;
	Tue, 22 Oct 2024 08:42:05 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-d3-671765c3e2df
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	15.37.08229.D5567176; Tue, 22 Oct 2024 17:42:05 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241022084204epsmtip1280928aa91f83faf9f0d45b8696a8f56~AucfXW2oh0198801988epsmtip1O;
	Tue, 22 Oct 2024 08:42:04 +0000 (GMT)
Date: Tue, 22 Oct 2024 14:04:24 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
Message-ID: <20241022083424.wz2cmebvkrdcgw2g@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f29d4778-b5f5-4f3c-a2e6-463c5432dd65@kernel.dk>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmpu7hVPF0g7nzjCxW3+1ns3jXeo7F
	4tDkZiYHZo/LZ0s93u+7yubxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
	gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGjYc32Aq2s1acvfWKuYHxJksXIyeHhICJxL6bXcxd
	jFwcQgJ7GCX+b73BBpIQEvjEKLH2gitE4hujxL1Vx4ASHGAdOyYHQsT3MkpsWDWDBcJ5xijR
	9KYHbCyLgKrEv4PHwGw2AXWJI89bGUFsEQEFiZ7fK8E2MAvYSJx4/xusRljATeJRx2ywGl4B
	M4lNE78xQ9iCEidnPgGr4RSwlXje+JodxBYVkJGYsfQr2NkSAufYJWbfXM8K8Y+LxK95C5kh
	bGGJV8e3sEPYUhIv+9ug7HSJH5efMkHYBRLNx/YxQtj2Eq2n+plBvmQWyJCYt0IUIiwrMfXU
	OiaIm/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe64ByvaQ+Pu1mxESok1MErv+pE9glJ+F5LVZ
	CNtmgW2wkuj80MQKEZaWWP6PA8LUlFi/S38BI+sqRqnUguLc9NRk0wJD3bzUcnh0J+fnbmIE
	J0KtgB2Mqzf81TvEyMTBeIhRgoNZSYRXqUQ0XYg3JbGyKrUoP76oNCe1+BCjKTCqJjJLiSbn
	A1NxXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTJP28C0KXbl/
	z4Nd6Vr3X85+r/Z+8j1jj83XJgSuWzzrh4DMPwPmey+3bNmx5NvzSQoJvza7Om7X85Sv1P3I
	F8PFLzdj4swj9ZVHpDTq8tp6n7y6V3Px/P28Ce3FU9o414hNNX9T6O0xb0HwS9MrqcoSSqWh
	Oet67FK/s6xN18hqrAvl5lm0NyXjwaFLbAVeTZzZ08olO2y9p3JEqYRHLvqcsW3ebJs7t6Mt
	86ZMvxhd92p32lqzuglxWyZ9LI9x9BLdcVfRcmFvXkf9/uM6WYbCjh9sV/LeOMHyeGlTf9nr
	EtclG+QmvNp15PeqjYInfvvKZogpxDbqz7iffUuDr42xfWX85P+qIiz1rLq5P5RYijMSDbWY
	i4oTAU8FzugNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnG5sqni6wdkLihar7/azWbxrPcdi
	cWhyM5MDs8fls6Ue7/ddZfP4vEkugDmKyyYlNSezLLVI3y6BK2Pb8SnMBS+ZKs4fmsXSwLiU
	qYuRg0NCwERix+TALkYuDiGB3YwS1xZOZO9i5ASKS0icermMEcIWllj57zk7RNETRonfL76x
	giRYBFQl/h08xgJiswmoSxx53grWICKgINHzeyUbiM0sYCNx4v1vsBphATeJRx2zwWp4Bcwk
	Nk38xgwxdAOjRNO7n0wQCUGJkzOfsEA0m0nM2/yQGeRSZgFpieX/OEDCnAK2Es8bX4MdKiog
	IzFj6VfmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAg
	1tLcwbh91Qe9Q4xMHIyHGCU4mJVEeJVKRNOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ84q/6E0R
	EkhPLEnNTk0tSC2CyTJxcEo1MAmwqUzuy5HvM9u2f/3d7YavKkTMPt1cyWv9z2V928RPV6Z+
	lXh5UriHi+nv/Fero7+9jv1h+l2jOO3GovKc6yl/Rd9t0tcvjt85jy1khQkLq8gnUZGnX+9u
	Youu+NIaY9/1P66tj7lOdc6WllD/q217VQ9H3XE1LbxYtf6Uw+mm6XMmXDKpvM/ytMiNzc5v
	+fISad41v5XbejfLK9Z437M9USyyUNw+tEBc6EVD3veQ3e+yOSoFJkeesHaPWN4nO3VOkM4/
	f53NV1dOv2eU3vVF6NcXu+utf37P+P7/EN8Mr7wK//Y+GadfD63S5wtmfJ0tw+Vauqn98MEf
	kQa6zaxzWDZMEzrjcDjn0MprckosxRmJhlrMRcWJADFwFD7RAgAA
X-CMS-MailID: 20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_6477b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4
References: <20241022020426.819298-1-axboe@kernel.dk>
	<20241022020426.819298-2-axboe@kernel.dk> <ZxcRQZzAmwm1XT3K@fedora>
	<f29d4778-b5f5-4f3c-a2e6-463c5432dd65@kernel.dk>
	<CGME20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4@epcas5p1.samsung.com>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_6477b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

>
>Gah indeed, in fact it always should be, unless it's forcefully punted
>to io-wq. I'll sort that out, thanks. And looks like we have zero tests
>for uring_cmd + fixed buffers :-(
>

We do have tests for uring_cmd + fixed-buffers in liburing [*].

[*] https://github.com/axboe/liburing/blob/master/test/io_uring_passthrough.c

>-- 
>Jens Axboe
>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_6477b_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_6477b_--

