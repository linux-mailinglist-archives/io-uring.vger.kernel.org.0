Return-Path: <io-uring+bounces-4066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3549B33D4
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8C7F1F21D87
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 14:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E02F1DDC34;
	Mon, 28 Oct 2024 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BgBK/j43"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA0D1DDA1B
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126451; cv=none; b=IdLuyhENx3RfjNSH/ASQrR+I64v8oIIBmjfIGKm0g7pEjmJbsRE4jbd8DfCdqkkrHJvRONBvTzQSI1KKUEhliyqrGKpSmaz7s/VjeaLPc2zkxSXjImQVwdH40Qf4J0erHj2O160xdENTZCkkIp2TpHweHJYXndn9j+0NsUupGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126451; c=relaxed/simple;
	bh=+W9H+/a1AR3pvwSexpegNolrKbZESTD8KY620mmaRgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=T3NFjTRDkJzNUrbc+7mwEbxaZxiNa/58zfXw2P/fjCihWYT/uhBCleRMnMdfMGekZPGUNcCxhlCTTdAO1DfjhadZGpDpfiMKh3EicyKoN6H8cqM4MBDZuL1tY9s1bYzgrNvuOT2eWFvcuI57hsb7o0V69HkIApTtez1CjLZGB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BgBK/j43; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241028144046epoutp013be53f73633a72c0dc28caa10ef8c952~CpNYtTo6t2460924609epoutp01B
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 14:40:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241028144046epoutp013be53f73633a72c0dc28caa10ef8c952~CpNYtTo6t2460924609epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730126446;
	bh=T55b8XTY+UM6hmZKkI27A+z3EC7/CEwwqFInuUnPr7g=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=BgBK/j43WVhlvhPip0OnT4RkQjVCmcwcoNZ7zNb7USBMAJCkdR68ON1EfY4C19WPd
	 vo9DI0ZoYwavxvrjVxVlR4garnqXwCnUf9otlSOPUBX0o0AmSX9yvLLWaYe5Tac9Mt
	 T8/jvt8EoVFC/o+BjTQgz9b4iqJiaPFTiV9HF4S4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241028144045epcas5p21d6bfc8a173149d569dea73fe637acf7~CpNYD9X-h1603716037epcas5p2z;
	Mon, 28 Oct 2024 14:40:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XcbfN21Kjz4x9Pp; Mon, 28 Oct
	2024 14:40:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.5A.09800.C62AF176; Mon, 28 Oct 2024 23:40:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241028144043epcas5p1a1867fb53cbfc69dd78c95c2a3bbcd30~CpNWIiyY63010430104epcas5p1n;
	Mon, 28 Oct 2024 14:40:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241028144043epsmtrp2080041b470ffdd7a33e3b7651fb8f653~CpNWH4Z8q1117611176epsmtrp2N;
	Mon, 28 Oct 2024 14:40:43 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-49-671fa26c60f3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.F6.08229.B62AF176; Mon, 28 Oct 2024 23:40:43 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241028144042epsmtip29836bee4c94a08085db9de127166f9e2~CpNUoiBwO1063710637epsmtip2W;
	Mon, 28 Oct 2024 14:40:42 +0000 (GMT)
Message-ID: <45c046df-e940-47d0-bb29-f3aaeb28b458@samsung.com>
Date: Mon, 28 Oct 2024 20:10:02 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 3/7] block: allow ability to limit partition write
 hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, javier.gonz@samsung.com,
	bvanassche@acm.org, Keith Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241025213645.3464331-4-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmlm7OIvl0g32fuC2mffjJbLFy9VEm
	i3et51gsHt/5zG4x6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW3Rf38HmwOVx+Yq3x6ZVnWwe
	m5fUe+y+2cDmce5ihUffllWMHp83yQWwR2XbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkp
	MCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzmi7/JOp4AJrxdK5VxgbGI+zdDFyckgImEh86Z3A
	1MXIxSEksJtRYkJ3CyNIQkjgE6PE042OEIlvjBI7dv1khOmY9fYeO0RiL6PEvyNP2CE63jJK
	vP9SD2LzCthJnD6wlRnEZhFQldjz9DMzRFxQ4uTMJ2CrRQXkJe7fmgHWKywQILF7/QxmkKEi
	AjMYJWbfngCWYBaoldi2aw0rhC0ucevJfKBbOTjYBDQlLkwuBQlzCphLLNvRzAhRIi+x/e0c
	sDkSAis5JG7u+w9WLyHgIrFrigvEA8ISr45vYYewpSQ+v9vLBmFnSzx49AAaLDUSOzb3sULY
	9hINf26wgoxhBlq7fpc+xCo+id7fT6Cm80p0tAlBVCtK3Jv0FKpTXOLhjCVQtofEi91rmSHB
	tp1R4n/XfpYJjAqzkEJlFpInZyH5ZhbC5gWMLKsYJVMLinPTU4tNC4zzUsvh0Z2cn7uJEZxw
	tbx3MD568EHvECMTB+MhRgkOZiUR3tWxsulCvCmJlVWpRfnxRaU5qcWHGE2B0TORWUo0OR+Y
	8vNK4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamC6uOzCTc1DQivD
	Dhs93/3n5ZOfxkwBDZlrXy/kjC755JPf93++0r/GXL6etWvVvqRcSjNj/snrfmKSe1jmCcWD
	D4znrlz8+oR0+AHlOClPrty1V85tVWuzSDviJR4m0fd86cGFJfGznjQukQs+9nT+tBn2Wbde
	Fmn49a9ZPcHsadH7vW+enHZ32bNI6/DzjL1yO5++l0re7/lRKGDxpHoDw+oHQSdzQwKU9m02
	rjFLlfi25PumeR1xChkG3ILi/kq3JzGc0DLQd+7Wb91zbsbixboLfGeeSjC5HvtG97N0iHH0
	00BbF/Onu9h7N8ZoGO1+q5eu8Ojf6jzF99+TEs6+XLMn0KFjwi6D/qdn88+HK7EUZyQaajEX
	FScCAIsoMEJBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJXjd7kXy6wYL7uhbTPvxktli5+iiT
	xbvWcywWj+98ZreYdOgao8WZqwtZLPbe0rbYs/cki8X8ZU/ZLbqv72Bz4PK4fMXbY9OqTjaP
	zUvqPXbfbGDzOHexwqNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy2i7/ZCq4wFqxdO4VxgbG
	4yxdjJwcEgImErPe3mPvYuTiEBLYzSixufMOI0RCXKL52g92CFtYYuW/51BFrxklmr5dZAVJ
	8ArYSZw+sJUZxGYRUJXY8/QzM0RcUOLkzCdgG0QF5CXu35oBNkhYwE/i35RlTCCDRARmMEos
	XPYEKMHBwSxQK9F9zQ5iwXZGiRNvr4INYga64taT+UwgNWwCmhIXJpeChDkFzCWW7WhmhCgx
	k+ja2gVly0tsfzuHeQKj0CwkZ8xCMmkWkpZZSFoWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0u
	zUvXS87P3cQIjjAtzR2M21d90DvEyMTBeIhRgoNZSYR3daxsuhBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXFe8Re9KUIC6YklqdmpqQWpRTBZJg5OqQYmkfXxDpO97eewNs7et4dTWKg+vuLvLklT
	ramHU39qPTx7MqhEtrIwJeXSlJsHbtvnRIv8athvek79q+Wep3vUmDbqzJCU83CydzA9N+vf
	84BVe40v+iSGTw1c+b/i9KoK522yfkrNLT2PhKovzz/dnFJ0apfQ7rLH/rzs3OZJ2vem5Of9
	3MJy7Uqk2nX+trKDXjIqk47VKgsYPH82oXv5H31l7wDpl1/vmDvf7YmY0tXEvXdpB//dm605
	mjznD2bOWMulXME/uf6FU0XSgl+m+se5KkxFfm2duOFvkbO73JmNjh+zdHw+bTE3mXXH6fj2
	KWeVOk7NcknqvPnw0btPW//mmJ3/kO7fZ2kYtOWKEktxRqKhFnNRcSIAiXcXux8DAAA=
X-CMS-MailID: 20241028144043epcas5p1a1867fb53cbfc69dd78c95c2a3bbcd30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241025213717epcas5p2d70619c312135cd1bb67dc78ca7d7b2b
References: <20241025213645.3464331-1-kbusch@meta.com>
	<CGME20241025213717epcas5p2d70619c312135cd1bb67dc78ca7d7b2b@epcas5p2.samsung.com>
	<20241025213645.3464331-4-kbusch@meta.com>

On 10/26/2024 3:06 AM, Keith Busch wrote:
> +static ssize_t part_write_hint_mask_store(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	struct block_device *bdev = dev_to_bdev(dev);
> +	unsigned short max_write_hints = bdev_max_write_hints(bdev);
> +	unsigned long *new_mask;
> +	int size;
> +
> +	if (!max_write_hints)
> +		return count;
> +
> +	size = BITS_TO_LONGS(max_write_hints) * sizeof(long);
> +	new_mask = kzalloc(size, GFP_KERNEL);
> +	if (!new_mask)
> +		return -ENOMEM;
> +
> +	bitmap_parse(buf, count, new_mask, max_write_hints);
> +	bitmap_copy(bdev->write_hint_mask, new_mask, max_write_hints);

kfree(new_mask) here.


