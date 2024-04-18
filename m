Return-Path: <io-uring+bounces-1583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 632818A92C6
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 08:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CDF8281EEB
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 06:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98D058129;
	Thu, 18 Apr 2024 06:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B60hEjle"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFD360260
	for <io-uring@vger.kernel.org>; Thu, 18 Apr 2024 06:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713420468; cv=none; b=Yt8l7c9sj+xMTDLJcniBlDgw3PLJoB7qUcBcYlPaWsFbhcSCQrUWX+wbLbeHc4Hdi604/GHRSWSXeTiiJ21Um/GNWtJMQ/cKiorhnD6MmQ9EkSvVAo+rVzu6LnS04kWKiR94UgQ4sLT9TKDBE2ovaVqZS7/Jfdzgn8jrph0gJro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713420468; c=relaxed/simple;
	bh=2zbeNB4UEUSv0tRdWxRl7JgDBqxdn92aemf8vhXkIyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DAqMfW8SUIebA8pebaF+1dRQpUayFEdqF/MQSGaXk+UIdxui3M2sD1bncjAFMv9A2bgsKbqZGSSO4qIgX4635z9UFW7HTCJD04FSWjkUawYTPKa8LlMc0/mbNq5SlahWESshCVvrXUyHlNXGgdbFEUAOWliPGG8L6uCF/DJ5+m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B60hEjle; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240418060738epoutp022595b39d3eda101d86e50d69a65b8cce~HStQgvMQI3159431594epoutp022
	for <io-uring@vger.kernel.org>; Thu, 18 Apr 2024 06:07:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240418060738epoutp022595b39d3eda101d86e50d69a65b8cce~HStQgvMQI3159431594epoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713420458;
	bh=GARoinIZn0P9UkofwovI5gzz4zQlePWSAFAbJWwKGwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B60hEjle2QHMbK9t8u5XPWMEv6AoP3LB8PFijgmJZyvLMeaeTwQIiErDbs/TSUwl4
	 uuVAwTz9rDlCXT/eeAkSX/QJINNmPT81ljZYMWRO7tT9qolJL0+JRsqE8ZqWVWKxoy
	 Q2nlDQJj/lp7M9CNWUOpt7f6F7PDaoxlQHIhAujU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240418060737epcas5p1fd7b9cd84d6a53c2996885ed4cee9040~HStPnoAo72391223912epcas5p1s;
	Thu, 18 Apr 2024 06:07:37 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VKnPM6ZvDz4x9Q1; Thu, 18 Apr
	2024 06:07:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	25.04.09666.7A8B0266; Thu, 18 Apr 2024 15:07:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240418060723epcas5p148ac18fa70b10a2bbbde916130277a18~HStCdsCfo1391213912epcas5p1k;
	Thu, 18 Apr 2024 06:07:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240418060723epsmtrp21425e576dd6f78b4d02b3d2cbd6be9c7~HStCcmzRq2659726597epsmtrp2n;
	Thu, 18 Apr 2024 06:07:23 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-13-6620b8a7bc3b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	17.8C.08390.A98B0266; Thu, 18 Apr 2024 15:07:22 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240418060721epsmtip16446b4b5e8d6538138e0e7eb9b9a2033~HStA4c-XM2182521825epsmtip1g;
	Thu, 18 Apr 2024 06:07:21 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: anuj20.g@samsung.com, asml.silence@gmail.com, cliang01.li@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com,
	wenwen.chen@samsung.com, xiaobing.li@samsung.com, xue01.he@samsung.com
Subject: Re: Re: io_uring: releasing CPU resources when polling.
Date: Thu, 18 Apr 2024 14:07:16 +0800
Message-Id: <20240418060716.1210421-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <f7f547aa-998f-4e9f-89e1-1b10f83912d6@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmpu7yHQppBu+uG1s0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07WyK8ktL
	UhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjOmtf1gKrjOXdE+v4+pgXE2
	ZxcjJ4eEgInEhp4HzCC2kMBuRolJE526GLmA7E+MEqsfXGSFcL4xSuzceZ8FpmPW9qVQib2M
	EntmdjJBOD8YJe5v/84KUsUmoCSxf8sHRhBbREBYYn9HKwtIEbPAWiaJjbfPMoEkhAUcJK51
	NLKD2CwCqhLrbswDa+YVsJaYcOAZE8Q6eYmbXfvBDuQUsJU42L2LCaJGUOLkzCdgJzED1TRv
	nc0MskBCYCaHxIXHc5khml0k7hyZwwZhC0u8Or6FHcKWkvj8bi9UPF9i8vf1jBB2jcS6ze+g
	/rSW+HdlD5DNAbRAU2L9Ln2IsKzE1FPrmCD28kn0/n4CdSevxI55MLaSxJIjK6BGSkj8nrCI
	FcL2kPi8p4sFEloTGCW+PfrPOoFRYRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OLTQsM81LL4dGc
	nJ+7iRGceLU8dzDeffBB7xAjEwfjIUYJDmYlEd4WYdk0Id6UxMqq1KL8+KLSnNTiQ4ymwACf
	yCwlmpwPTP15JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwec1c
	8eyirVT6AUGHPaz9q7uTpARnrXl3bMrbpKgdF+4GvbpjsM9ol2TQlaKC48uPJDnd52LOMNl+
	XPzG5w/J2wOn+nAXLOLd/1vu1vHZzq8di89XeBisWxh90OHumkdTGRKjEi4GblqtvZH7Vova
	nYUzV8fy+71dstlMNP26W84K3nAl3q/cH1MVkzOTO8UjYyLaNXiaoly+bbxfI/684fIyjaUT
	L/877GJkohr1+eBx85lfS1f/ErA1MplqLD95vdL+VLd0tQ+K5vJsC5lq1hc2cxZ0N28VZvj5
	YkaAdnZM2rWqs9v9XpetF7LQD/6yYlOIQwkTs+EmTwOGyJiqNRZn11QY9u9lK4/oT5RSYinO
	SDTUYi4qTgQAVOeKUkUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSnO6sHQppBpvPWlg0TfjLbDFn1TZG
	i9V3+9ksTv99zGLxrvUci8XR/2/ZLH5132W02PrlK6vF5V1z2Cye7eW0+HL4O7vF2QkfWC2m
	btnBZNHRcpnRouvCKTYHfo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGdPa
	fjAVXOeuaJ/fx9TAOJuzi5GTQ0LARGLW9qWsXYxcHEICuxklmneeY4ZISEjsePSHFcIWllj5
	7zk7RNE3Rom5p18wgSTYBJQk9m/5wAhiiwAV7e9oZQEpYhbYyyRx/8N1sCJhAQeJax2N7CA2
	i4CqxLob88Cm8gpYS0w48IwJYoO8xM2u/WCbOQVsJQ527wKKcwBts5F4flocolxQ4uTMJywg
	NjNQefPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjODK0
	tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeFmHZNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK83173pggJ
	pCeWpGanphakFsFkmTg4pRqYti1ofaX2Q447esIGy67P7Fn60yI2hkyI2sKp/tTo1xKDZXbb
	dp0XNq38f/UBT3CC9cS9cnfjOnaVuJz657bebaqp1FxxubVsTtH1n9y/eugqVphsPb/yxdwd
	9QZpU95pFbxL7To8yTlow0PZae1RrNpZCrfSEyfPUJto+J/fODzm837GLKFtPR6P92wvOx3L
	rXru6pTQhyH5Baumf8zQy2aVVQ64unfDU+2LO659bp/bGXa5Pd4u4eCF4p1TjA/48aXMNTP+
	veZ9zgKz+PQJf44xzbXNiJjG6e3z6bX6i0lvz+zfLSdowhEZ4XPpyKX0F+wPTULtF67omBKs
	/oJx2f/u2OfWW778Tn+qz5o/Q4mlOCPRUIu5qDgRALrD0Tj7AgAA
X-CMS-MailID: 20240418060723epcas5p148ac18fa70b10a2bbbde916130277a18
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240418060723epcas5p148ac18fa70b10a2bbbde916130277a18
References: <f7f547aa-998f-4e9f-89e1-1b10f83912d6@kernel.dk>
	<CGME20240418060723epcas5p148ac18fa70b10a2bbbde916130277a18@epcas5p1.samsung.com>

On 3/26/24  3:39, Jens Axboe wrote:
>On 3/25/24 9:23 PM, Xue wrote:
>> Hi,
>> 
>> I hope this message finds you well.
>> 
>> I'm waiting to follow up on the patch I submitted on 3.18,
>> titled "io_uring: releasing CPU resources when polling".
>> 
>> I haven't received feedback yet and wondering if you had
>> a chance to look at it. Any guidance or suggestions you could
>> provide would be greatly appreciated.
>
>I did take a look at it, and I have to be honest - I don't like it at
>all. It's a lot of expensive code in the fast path, for a problem that
>should not really exist. The system is misconfigured if you're doing
>polled IO for devices that don't have a poll queue. At some point the
>block layer returned -EOPNOTSUPP for that, and honestly I think that's a
>MUCH better solution than adding expensive code in the fast path for
>something that is really a badly configured setup.

Sorry for my late reply, if you think that the scenario where if you're 
doing polled IO for devices that don't have a poll queue is just a 
misconfigured and does not need to be changed too much, then I'm inclined
to extend this scenario to all devices, I think it's an effective way to
release CPU resources, and I verified this and found that it does have a
very good benefit. At the same time I have reduce the code in the fast
path. I will release the v2 version of the code with my test results,
and please reconsider the feasibility of this solution.

--
Xue

