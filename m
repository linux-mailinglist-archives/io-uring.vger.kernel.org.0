Return-Path: <io-uring+bounces-7947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 516EEAB36DE
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 14:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C081167652
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 12:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C39929290F;
	Mon, 12 May 2025 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pzmtOihY"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0640F265CDF
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747052510; cv=none; b=YZPsx9LAHksO5Msjr+4WZRi3Z+Pk2V0jJCrHGfHMDjjGfbdCdmqEe2iO3VkwPFRN9I9xwzs1vybCONiYJ2+gv1+gkgDvumTQDc+3Unp7wvrTLIs5++zlIE9rkDzFaObraR11W4B7NTlPuO9p0IORk7u5/AYnVGjl2asnZVlcN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747052510; c=relaxed/simple;
	bh=E8Q0t4tYPPEBMuJEvjp55laKSxT9IdSbrYeq30WraHI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:In-Reply-To:
	 Content-Type:References; b=DsIb7nnGfqgLsIl7lpg86DI5yx3eORuvJP4tXjCzZJ0M7wcnrISr+NP8LGVcLKoevcMCZteglkkJFedtgTHp2S5ZUgTBoiFEBY72jekctQyqbYNxOIqvPouiC/txTFBHpN94oJPoz/ai40Zdq6xoFFkrH/7Dzz1clWeXEALEBks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pzmtOihY; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250512122144epoutp03fcadb937e8b6e3eae14149bda9d9d766~_xv8l_WkJ2348223482epoutp03U
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 12:21:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250512122144epoutp03fcadb937e8b6e3eae14149bda9d9d766~_xv8l_WkJ2348223482epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747052504;
	bh=90yH+fOYwmwgLgQ5fSmeg9hn5rwHaXe/i+CF88wYckg=;
	h=Date:From:Subject:To:In-Reply-To:References:From;
	b=pzmtOihYFyAg/X+/tQPEQeim8Hyl9HdQfK5jO52N9anMtEQnNkW1zXlCNnnILZF1t
	 bQ4JgUlkvVRRm9uem5OpiCvas28uVl+9E+v/sKWnnqq2/a4U0kC6WbMrfuADLHytEa
	 bR89GMpZSM3Abgz55LEs7ZlJmxIf6eDZNvGOK62c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250512122144epcas5p31fd52c7f1cffd406a5cd6c707be76a43~_xv8Suwac3232732327epcas5p3T;
	Mon, 12 May 2025 12:21:44 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.176]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4ZwzHV6P6Fz2SSKZ; Mon, 12 May
	2025 12:21:42 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250512122142epcas5p3ee943a941e0a6daca487552343014157~_xv6dHv-I3011730117epcas5p37;
	Mon, 12 May 2025 12:21:42 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250512122142epsmtrp23acfa5728aaa0c164e00746941fc0ee8~_xv6cjwDW1707417074epsmtrp2V;
	Mon, 12 May 2025 12:21:42 +0000 (GMT)
X-AuditID: b6c32a28-46cef70000001e8a-99-6821e7d6c651
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.45.07818.6D7E1286; Mon, 12 May 2025 21:21:42 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250512122141epsmtip27b69053d787f4d8e089b6a8ad983047e~_xv5lSWyB1768717687epsmtip2G;
	Mon, 12 May 2025 12:21:41 +0000 (GMT)
Message-ID: <2a4cf64a-ec6b-4daf-ae0e-dcac2a51fda1@samsung.com>
Date: Mon, 12 May 2025 17:51:32 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kanchan Joshi/Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH] io_uring/uring_cmd: fix hybrid polling initialization
 issue
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk, asml.silence@gmail.com,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
In-Reply-To: <20250512052025.293031-1-xue01.he@samsung.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSvO6154oZBpta+C3mrNrGaLH6bj+b
	xbvWcywWl3fNYbPounCKzYHVY+esu+wel8+WevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	56arzAXfWSour2NpYGxl6WLk4JAQMJFY/pOpi5GLQ0hgN6PEvMMv2LsYOYHi4hLN135A2cIS
	K/89Z4coes0osfHDXBaQBK+AncTh3a/BilgEVCWePb3IDBEXlDg58wlYjaiAvMT9WzPAatgE
	zCW2zzsDViMsECQx//ETVpChIgLNjBJfL+xhhNjQxyhxde0SVpAqZqAzbj2ZzwRicwpYS9yZ
	fpMFIm4m0bW1ixHClpfY/nYO8wRGwVlIls9C0j4LScssJC0LGFlWMUqmFhTnpucmGxYY5qWW
	6xUn5haX5qXrJefnbmIEh7+Wxg7Gd9+a9A8xMnEwHmKU4GBWEuFt3K6YIcSbklhZlVqUH19U
	mpNafIhRmoNFSZx3pWFEupBAemJJanZqakFqEUyWiYNTqoGpPsL4X9TJw7xyAVoTz32VjG42
	fT73r5XbcjudX5/Dd1id9vqifVbW6CjPXcUNlXenuUr3HLXo0LLX+PPY/X9Gl/pb1YmcZVFN
	17ebd9V2LHlwbbW+Ase5SY++Zrcv8aoyunz06/b7kQ4az2c93mTAuUxO6jiHrvH/Ja4qJ054
	1t5c0DlpV+CMfPsXv8o+r2n4v2HFkttawS/P3bq0vjDhStDuGZujg3RFmpf55rVtnW+0+39t
	Dcc1rZOzJVd+PfPwfJ3hj11HfdMuJEau39PYefm/EZOlJ9t37+WZKxS/WF+OfvM6aa3pSy8v
	FY2KCSGF1/XSfotLTf/y0CLpbnbRlWtRjosLT8443Lfg+Y+GD0osxRmJhlrMRcWJAEaXqSnu
	AgAA
X-CMS-MailID: 20250512122142epcas5p3ee943a941e0a6daca487552343014157
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250512052032epcas5p46bb23adcb4a467aa7f66b82d3548b124
References: <CGME20250512052032epcas5p46bb23adcb4a467aa7f66b82d3548b124@epcas5p4.samsung.com>
	<20250512052025.293031-1-xue01.he@samsung.com>

On 5/12/2025 10:50 AM, hexue wrote:
> Modify the defect that the timer is not initialized during IO transfer
> when passthrough is used with hybrid polling to ensure that the program
> can run normally.
> 
> Fixes: 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
> Signed-off-by: hexue<xue01.he@samsung.com>

So without this patch, liburing passthrough test 
(io_uring_passthrough.t) gets stuck.
With this patch, I do not see the issue and test runs to completion.

This may need stable tag though
Cc: stable@vger.kernel.org # 6.13+

With that,
Reviewed and Tested by: Kanchan Joshi <joshi.k@samsung.com>

