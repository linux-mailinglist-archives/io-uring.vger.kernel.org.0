Return-Path: <io-uring+bounces-7538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66504A93148
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 06:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 644C646400A
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 04:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F173A24E008;
	Fri, 18 Apr 2025 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PJooVYih"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8DC1DA21
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744951676; cv=none; b=irZPXZifMrasyCdaKaFm+UwdYc9NkJC2hcNjyrrWLTWYF6PvoVrm1SNFvuswbPx1zE5cMNAN10Ol867XoQ8C057GMLv2/JhUSv5QwBv8bFPTpPAN+YyWA9CdVTZ244AGOUM9i7xl72Q60wNVc7nMdsVHP9w8P+D2UVpEBpl7Z9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744951676; c=relaxed/simple;
	bh=4jaHpDn1xcEf4s8ispj5AlMHF52wlD+fgRScI3d2fBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ELYEFfhXsyW/5DlDB8SJA1ccTX/5qE9otE0K8ZGVrafj0A0d0jy7ciplj6nGdM7DnAR6m7Sk2vnJcgjS94KuoM+u0wyzP2ibuS4TrQlHDOBSPTYyvlwy6/+YO2trd6tqOPjOAB2CnMo9N1iGsg/DpThK3LPV1hL+W5N3EnT3HSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PJooVYih; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250418044751epoutp03ba0c3051b06077816a9f0b8749a823d7~3UEzPM93l0418604186epoutp03S
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 04:47:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250418044751epoutp03ba0c3051b06077816a9f0b8749a823d7~3UEzPM93l0418604186epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744951671;
	bh=WSIZYZZZG2YiidMguDGjyIffIYhtZa9jL7+xufXww8Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=PJooVYihmo805n9ZA9clfr5AOykE3s+dYGQgvtYB4qWeLXigqt5knV0uUIS1mWFii
	 qIzJEuhdjCkWHweD7RKL7Zda3m/19Ue+XYycT0ZG3KLe65h3g4eI6LwB8+EGGzJBs7
	 Js/iObvwEkWhhd1PioZD6yWXsrCwZXB/g1QcxYDU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250418044751epcas5p12a2a570ab724558b1f5498c3e653f33f~3UEzDcPci2226222262epcas5p13;
	Fri, 18 Apr 2025 04:47:51 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.181]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4Zf2Ls5lnpz3hhT9; Fri, 18 Apr
	2025 04:47:49 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250418044749epcas5p1dae7fd0636efc8cfe6a48e6ab26c4580~3UExJMk1a2226222262epcas5p1r;
	Fri, 18 Apr 2025 04:47:49 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250418044749epsmtrp24e2dcb1464b58f2d68b39ab057ba1ce0~3UExIoQvH2057520575epsmtrp2M;
	Fri, 18 Apr 2025 04:47:49 +0000 (GMT)
X-AuditID: b6c32a2a-d63ff70000002265-f1-6801d975eca8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.B5.08805.579D1086; Fri, 18 Apr 2025 13:47:49 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250418044748epsmtip1cb7cc5a16fb847aab53e2cad5009991d~3UEwZSAze1455314553epsmtip12;
	Fri, 18 Apr 2025 04:47:48 +0000 (GMT)
Message-ID: <e047580f-d7b2-4a14-9b6f-6653d7ed01a7@samsung.com>
Date: Fri, 18 Apr 2025 10:17:47 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liburing/io_passthrough: use metadata if format
 requires it
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <67cffda3-c211-419c-8e49-cf38def85b63@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnG7pTcYMg469rBar7/azWbxrPcdi
	MenQNUaLM1cXsjiweFw+W+qxaVUnm8e5ixUenzfJBbBEcdmkpOZklqUW6dslcGVM//6SseAy
	Y8Wxu42MDYzLGLsYOTkkBEwk3r67zgpiCwnsZpS4ey4EIi4u0XztBzuELSyx8t9zIJsLqOY1
	o8SF21/AErwCdhIP95xgArFZBFQl2v8eYoGIC0qcnPkEzBYVkJe4f2sGWL2wQJDE/k0/mUFs
	EYFoiY6ZC8BqmAWUJTp7PkIt+MQoMfnfdEaIhLjErSfzgRZwcLAJaEpcmFwKYnIK2Ep83e8H
	UWEm0bW1C6paXmL72znMExiFZiG5YhaSQbOQtMxC0rKAkWUVo2RqQXFuem6xYYFRXmq5XnFi
	bnFpXrpecn7uJkZwHGhp7WDcs+qD3iFGJg7GQ4wSHMxKIrznzP+lC/GmJFZWpRblxxeV5qQW
	H2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbLxMEp1cAU1ZZcVnjrzDShkMXXrtXHfAzW8TLm
	bGdq/5ZtcvLoC8Et21cs+r+3uMP35u1TNXIPG64xcsQJ7+ixyBLLrmzKjJ7yf3WZgfxame5o
	4U8y1zdfij96zVcq18LWf121kMKzF69UTgsfbz/vJzsrj/tq6+1bfc8LDyqdjW4K+Zovub+W
	68GLvdG3HvAU3XmQuWTCtpWcJ0z2zFNgWeaXwlebe+5Z25ekWbuT761blrvzocD1AulJM1/c
	Vruc3OhSZWqR1cA0xd2wTWaKasqytpeGHxZmrhKQ3fVXXsDeSdDlbeRlTbWKJc/VX4qXLFB5
	5n9bY13zQbZdJ624X1hWdR6emZ7z9ol7a3rZu7O1PbOVWIozEg21mIuKEwER4PCS8gIAAA==
X-CMS-MailID: 20250418044749epcas5p1dae7fd0636efc8cfe6a48e6ab26c4580
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250416162937epcas5p462a7895320769fbf9f5011c104def842
References: <CGME20250416162937epcas5p462a7895320769fbf9f5011c104def842@epcas5p4.samsung.com>
	<20250416162802.3614051-1-kbusch@meta.com>
	<3606b88e-67f3-45c1-94b5-db01c20c9d2a@samsung.com>
	<67cffda3-c211-419c-8e49-cf38def85b63@kernel.dk>

On 4/17/2025 11:28 PM, Jens Axboe wrote:
> Confused, there should be zero overlap between this patch and the
> posted one?

Since you are able to apply fine, I must have hallucinated. Sorry for 
the fuss.

