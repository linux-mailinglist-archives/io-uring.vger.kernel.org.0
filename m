Return-Path: <io-uring+bounces-7522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AD9A9203F
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 16:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52FC716D5B7
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E087347B4;
	Thu, 17 Apr 2025 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LHmHsI3s"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38B2517A6
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744901500; cv=none; b=u6Vs54cgRp5YJ1J47POMByb8vc8F+28TdgW8DaIEmwRCzrBTtKr82WeYQL/cDXL9ybjckpE6sEDMTSwDTg2Ok7NJR7HhZbpd2vpGSLBh873HRbH6F8ae5ypz79VMsKWueHxsfATjgbivEtkz2HZ8p+MstOYhFUbDbGWwxWJrIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744901500; c=relaxed/simple;
	bh=dKNZI1TryXcw6VzolzKuVdPBvPwm5VdWqe0hxIfCi3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=HE0ueBxZn8lAUwpEjEL+0IzKjzUp3S8xpaDtpQG7YFKXzj8VKTfYtatV7oorOzAc6TqcOsX/ErYvXvdpWr+Gx3ruyPnkKtds6HuKzpXPZ7dFbt0HnKHlGbyXt4XnuyySRy+Ie0hTRGx5mWe+xvvsf4s9hqovWcArGadOiJIn2oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LHmHsI3s; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250417145136epoutp014eac1d27d2b87e8c44566aa5f65b4345~3IqqPYc0k2400324003epoutp01j
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 14:51:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250417145136epoutp014eac1d27d2b87e8c44566aa5f65b4345~3IqqPYc0k2400324003epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744901496;
	bh=mkSc79zr1oHNOBsREfodn8izxEQXbJ4x5eDoTEe1eEg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=LHmHsI3sXdcrSqf+65xj7lmPJoEfMnj9BAHZapiEdnlVS+1BnmRbBhOQoRVnP7b9L
	 PA01zx/vPnY0LXeO4rftzKvPMn3kl4vcrQEhSRRyXQjuOGh/4Hy2KZQW/GCUKzLwxM
	 jriK9n+LKKJ11ZGxpP7F5wk1Kk7/zFB0pX5XMPok=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250417145135epcas5p27cb6875c22e2fb1a5481ec57148b45b1~3IqpM8rFv0835908359epcas5p2S;
	Thu, 17 Apr 2025 14:51:35 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.183]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4Zdgnx4Wzrz2SSKY; Thu, 17 Apr
	2025 14:51:33 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250417145133epcas5p220d664523fa39e55030cf22160aa0cc0~3IqnJJJfn2767127671epcas5p2C;
	Thu, 17 Apr 2025 14:51:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250417145133epsmtrp2fa9b80d20bf75053e1b78c44f660201a~3IqnIkOV71718217182epsmtrp2F;
	Thu, 17 Apr 2025 14:51:33 +0000 (GMT)
X-AuditID: b6c32a29-566fe7000000223e-fb-68011575f486
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.0A.08766.57511086; Thu, 17 Apr 2025 23:51:33 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250417145132epsmtip1294ddf238cdd3696aae2c943ca9ac999~3IqmQ0fSg2949529495epsmtip1N;
	Thu, 17 Apr 2025 14:51:32 +0000 (GMT)
Message-ID: <3606b88e-67f3-45c1-94b5-db01c20c9d2a@samsung.com>
Date: Thu, 17 Apr 2025 20:21:31 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liburing/io_passthrough: use metadata if format
 requires it
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20250416162802.3614051-1-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnG6pKGOGwb7t7Bar7/azWbxrPcdi
	MenQNUaLM1cXsjiweFw+W+qxaVUnm8e5ixUenzfJBbBEcdmkpOZklqUW6dslcGXMmNPPXjCX
	seLNpYVMDYwVXYycHBICJhJn569n7WLk4hAS2M0ocWtnByNEQlyi+doPdghbWGLlv+dgtpDA
	a0aJrmnqIDavgJ3EtZWvmEFsFgFVia+PtrFCxAUlTs58wgJiiwrIS9y/NQOsV1ggSGL/pp9g
	9SICPhLrpi4Hq2EWUJbo7PnIDnFEF6PE+ebtzBAJcYlbT+YzdTFycLAJaEpcmFwKEuYUMJe4
	2L+QFaLETKJraxcjhC0vsf3tHOYJjEKzkJwxC8mkWUhaZiFpWcDIsopRMrWgODc9t9iwwDAv
	tVyvODG3uDQvXS85P3cTIzgOtDR3MG5f9UHvECMTB+MhRgkOZiUR3nPm/9KFeFMSK6tSi/Lj
	i0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJxcEo1MIk8zRLqmSn/YvX9taZx66au
	y1IuWqJf6J9qKcUm6KmQ/HnrhQ0e919tqT6W57Ro97RAU1lroadXtj7p2GpxccL/x97Vpw4s
	YNefOcNz4zWX+8yprx4cTPAIb6x9uSvp+MIQRfMbh7imT1q3KvqcjnLFs6D8BC73Bxfk//TN
	FdogE71q2Q2Bt60u3EpbZW8xmJk/Ffn8ZC+7cJnJtMuz/we48bOdn6xU6jBd9MzcfYFqrsbV
	FjxGK+5M+V6zaIO2Z+fCnZoL5x9ObevQM3543mVj8bFbCf9nTxaY5RCj5R8hy/yCwU9j3XHD
	B43vN0R2rWJW2Pg+Uft+4vta964j9lcTzituWKHyUCiQO0N5yl4lluKMREMt5qLiRAAY+eHK
	8gIAAA==
X-CMS-MailID: 20250417145133epcas5p220d664523fa39e55030cf22160aa0cc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250416162937epcas5p462a7895320769fbf9f5011c104def842
References: <CGME20250416162937epcas5p462a7895320769fbf9f5011c104def842@epcas5p4.samsung.com>
	<20250416162802.3614051-1-kbusch@meta.com>

The patch looks fine.
Just that it seems to have a conflict with the topmost patch [*] at this 
point.

[*] man: Fix syscall wrappers in example code


