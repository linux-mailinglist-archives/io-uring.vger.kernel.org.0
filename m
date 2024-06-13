Return-Path: <io-uring+bounces-2200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C14A8906224
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 04:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48B1E283120
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 02:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9589833062;
	Thu, 13 Jun 2024 02:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ddslYG9F"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D10179AF
	for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 02:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718246998; cv=none; b=hzu0yL8CPOKCkkedkc78PBsnKZxODqlqLjHCwfruDRSVY/7qFPUhsOlThQPCRpZZQ+wOF6miJWcMKihauNSq7li/3nuPxGIoQ+EcAl3myn1ywcnS86tD40G1XzVntyla4MPOmQYG7Y/cR/h9iodF3KWIQQ5b7TpxkdiHS+hj+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718246998; c=relaxed/simple;
	bh=Roy4y+aEEKiEHlVpW8JopOu8VBeDjmfKYATDhL5JJGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dgfiPOVRcZ0CRUx/0PfqckhCXt879MDghL383RqcuMjLqCe5uxt5OzYofkc8NlfET6Q90B7z16GqtwpFyVXWAT2jh3ZmHVcrPa1qHSQRmCQaO65fWPqZfIfHoDEM4fWkQjeXWBVPcQcoORHHlHZ8VhindeCQpuwB7Sz2mK+I+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ddslYG9F; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240613024947epoutp020a37ab02edf1fee9eaacd889070d4f25~YcIgAS6uv0526205262epoutp02o
	for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 02:49:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240613024947epoutp020a37ab02edf1fee9eaacd889070d4f25~YcIgAS6uv0526205262epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718246987;
	bh=Roy4y+aEEKiEHlVpW8JopOu8VBeDjmfKYATDhL5JJGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddslYG9FRTmmto32gYdf5Via76H8l2SOgv1RyWwv0uxxBApmnoKJsaZToXyoWfqAd
	 ZVsm1HUmdWcHHsHnmkmTrXaBJc+IFJ9tt0L3r9MX9OaQu/H9uKhf8b4V4Z+FP1uUcd
	 /84TIEHFEwbLW/Z8ULyUwWoItVIwQQ2JaN/y9gr8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240613024946epcas5p17c2fb3a59a61614d897b8316df2f32b9~YcIffg6FA1249712497epcas5p10;
	Thu, 13 Jun 2024 02:49:46 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W06MF08RLz4x9Q0; Thu, 13 Jun
	2024 02:49:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.1D.09989.84E5A666; Thu, 13 Jun 2024 11:49:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240613024932epcas5p2f053609efe7e9fb3d87318a66c2ccf53~YcISIk5162528325283epcas5p2c;
	Thu, 13 Jun 2024 02:49:32 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240613024932epsmtrp2798d458ea3810c6677083da535886893~YcISHubTy0768907689epsmtrp26;
	Thu, 13 Jun 2024 02:49:32 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-f1-666a5e48e953
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.02.08622.C3E5A666; Thu, 13 Jun 2024 11:49:32 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240613024930epsmtip28ad92257223a66ff8d5198566c5a96f0~YcIQiSk3g1763917639epsmtip2F;
	Thu, 13 Jun 2024 02:49:30 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: cliang01.li@samsung.com
Cc: anuj1072538@gmail.com, anuj20.g@samsung.com, asml.silence@gmail.com,
	axboe@kernel.dk, gost.dev@samsung.com, io-uring@vger.kernel.org,
	joshi.k@samsung.com, kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Thu, 13 Jun 2024 10:49:26 +0800
Message-Id: <20240613024926.2925-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530051044.1405410-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmlq5HXFaawbceS4uPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxO/33MYnHzwE4mi3et51gsjv5/y2bxq/suo8XWL19ZLZ7t5bQ4O+EDqwOP
	x85Zd9k9Lp8t9ejbsorR4/MmuQCWqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6
	xYm5xaV56Xp5qSVWhgYGRqZAhQnZGX+2HmItuMdacbz5InsD43OWLkZODgkBE4nvt3+zdzFy
	cQgJ7GaUWD9lAiOE84lR4t3HG1DON0aJya8+M8K0TOiawQ5iCwnsZZS4vs4GoqiJSaJ9dTNY
	gk1AR+L3il9gO0QEpCVebVvNBFLELHCJUeJ8/1OwImGBSInFC7rAprIIqEpcudLECmLzClhL
	vDrVDbVNXmL/wbPMIDangL3EytWX2SBqBCVOznwCtoAZqKZ562xmkAUSAo0cEk2n10J95yIx
	a/lNKFtY4tXxLewQtpTE53d7gQZxANnFEsvWyUH0tjBKvH83B2qxtcS/K3tYQGqYBTQl1u/S
	hwjLSkw9tY4JYi+fRO/vJ0wQcV6JHfNgbFWJCwe3Qa2Sllg7YSszxCoPieb76ZDAmsQosfrC
	GcYJjAqzkLwzC8k7sxA2L2BkXsUomVpQnJueWmxaYJSXWg6P5eT83E2M4MSq5bWD8eGDD3qH
	GJk4GA8xSnAwK4nwnolJTxPiTUmsrEotyo8vKs1JLT7EaAoM74nMUqLJ+cDUnlcSb2hiaWBi
	ZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA9PK9MWHFi+XOTJv4+sb/Op74tfH
	SaZu+hTf3NpteMLPVNtYJJ3x2qnTqv0djTn+zqcfVKQ81lSWVstWe67Dtyko6OkyQ7duswjW
	wJf/yp/p3fboyp1gsS1yeu49/wuxB5O5V7V1c8o4nXC567KBx33egYaKEO8qzsd83Jsmn5Bb
	KPy5ccWtOQVMO61n8MzVnqfscYp/qs3zqRNUrtnu4D844dx6niCv+azlE3geqjBZv6yOcv98
	O+2wpsPRWKUTO/mEHi37K+l/9Y6uz3Grqw9iVx1h3pIwZ1fyRMPFexctCXxyMld8Qvfv6z8P
	tqensM0TTWb2Ndi7KFT1TnXGvqqzbTud8287f73y7E/J061KLMUZiYZazEXFiQA6WEdHNQQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSvK5NXFaawYcJvBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1mc/vuYxeLmgZ1MFu9az7FYHP3/ls3iV/ddRoutX76yWjzby2lxdsIHVgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZf7YeYi24x1pxvPkiewPjc5Yu
	Rk4OCQETiQldM9i7GLk4hAR2M0qcWrQeKiEt0XGolR3CFpZY+e85VFEDk8SyKY/ZQBJsAjoS
	v1f8AmsQAWp4tW01E4jNLHCPUaJ3qy2ILSwQLrFs+iZGEJtFQFXiypUmVhCbV8Ba4tWpbkaI
	BfIS+w+eZQaxOQXsJVauvgw2X0jATuLwWYiDeAUEJU7OfMICMV9eonnrbOYJjAKzkKRmIUkt
	YGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHPpaWjsY96z6oHeIkYmD8RCjBAez
	kgjvmZj0NCHelMTKqtSi/Pii0pzU4kOM0hwsSuK83173pggJpCeWpGanphakFsFkmTg4pRqY
	UsxKvln/sTG5Ws/0ZLLzuoCgP1u6pTqZm4JfzXo5/UHpVY33EtyvplzX0tC28ORhqVKM+LzM
	4oxC0qyWyyzZW57f4lb7rFgyjY1f8E5s+f37m9atvW24WcVwu09P6ZeuWZtipqQ01WdoVQZH
	cAjs9C6TzLnv1f9wr8VRSdUTm6ddnsMe2GOTcXG+q4NYpEBmkZHqFdEp99/kb1/+zmF2YmeY
	mEAV8xGP9yrLtq12brIs7HP4zcR2/9yCp9EzTzwUT90bvmjSro+lE7cozW/ytr+jNLH+nZbc
	seuSp05sPKixpPFh9NQAtSmpc+pMJkzZKb5yybajUq/7tzHuUxGdwmhudV7okt62zY6ab4/r
	KbEUZyQaajEXFScCAH9hN47sAgAA
X-CMS-MailID: 20240613024932epcas5p2f053609efe7e9fb3d87318a66c2ccf53
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240613024932epcas5p2f053609efe7e9fb3d87318a66c2ccf53
References: <20240530051044.1405410-1-cliang01.li@samsung.com>
	<CGME20240613024932epcas5p2f053609efe7e9fb3d87318a66c2ccf53@epcas5p2.samsung.com>

On Thu, 30 May 2024 13:10:44 +0800, Chenliang Li wrote:
> On Thu, 16 May 2024 08:58:03 -0600, Jens Axboe wrote:
>> The change looks pretty reasonable to me. I'd love for the test cases to
>> try and hit corner cases, as it's really more of a functionality test
>> right now. We should include things like one-off huge pages, ensure we
>> don't coalesce where we should not, etc.
>
> Hi Jens, the testcases are updated here:
> https://lore.kernel.org/io-uring/20240530031548.1401768-1-cliang01.li@samsung.com/T/#u
> Add several corner cases this time, works fine. Please take a look.

Hi, a gentle ping here.
The latest liburing testcase: https://lore.kernel.org/io-uring/20240531052023.1446914-1-cliang01.li@samsung.com/

