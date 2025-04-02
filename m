Return-Path: <io-uring+bounces-7369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE287A78F9C
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 15:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF523B2C04
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 13:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296EA235375;
	Wed,  2 Apr 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Fx4SQlT6"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD723A990
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743600087; cv=none; b=UdkGR/vnji8SQ4WXeryUnTMBo4ovi3VOiXG+o7grdLxaMruCGSgHbtP2P4Q23nOhTXlleUfIvjyDBgeIaEhlHtHzJeywYmSW/ukooBwYP/wrcUb8588DCs7VQiEw3MusWQ0EkNP7RQNZVqf3OLlBOmD93yN/okeP1eZSfh8iwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743600087; c=relaxed/simple;
	bh=E4a4QPkVxLQnQSAJ3gMsfo/vKUKAMQjCjdoWo1bROC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=IImCFwAPr8yK1s6wlwBFjlQR/vQgTyC5RpFFncAPz4S9unRJJLz0A+53uBV9iImr0NMoZmmkzhIYNBKvz4NzIdDMcecISDePk5a/tcIiBYFTpRLmkJxptO3XkxmXKbbtOtFQV+Z1Lg0w84zoZozuKrNDWbXnhZK7AgfFBX1Gh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Fx4SQlT6; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250402132117epoutp02a42261892625b2a447ae737ac74f06e9~ygwhPTBmK0038900389epoutp02D
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 13:21:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250402132117epoutp02a42261892625b2a447ae737ac74f06e9~ygwhPTBmK0038900389epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1743600077;
	bh=E4a4QPkVxLQnQSAJ3gMsfo/vKUKAMQjCjdoWo1bROC0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Fx4SQlT6xpR1gLFnURpCdtu9hnIM2YWEci4Ovxm4Le9XQcVhqMZ9UZbaE5ENOnBo6
	 ohf5KjtZ6k0NaFzkVV2vW03aRTv7d8B1eYHoyjrd/aBZJJFwqkdyckEoabhHIkoHNA
	 91Mcf3Bv/bvp5QG5H3y3l4pC8uPSYc0ySyUFAhBo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250402132116epcas5p36172588119bb80373180f5a4c1d05e6b~ygwgzGXiT0421804218epcas5p3B;
	Wed,  2 Apr 2025 13:21:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZSQVg0LzTz6B9m4; Wed,  2 Apr
	2025 13:21:15 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D5.53.09853.AC93DE76; Wed,  2 Apr 2025 22:21:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250402132114epcas5p3dd1ea9335fb7e7b851820410c29b9265~ygweLXxh10400704007epcas5p3W;
	Wed,  2 Apr 2025 13:21:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250402132114epsmtrp1365f215a05329a109fd4f445cee78f4f~ygweKqyhm0388903889epsmtrp16;
	Wed,  2 Apr 2025 13:21:14 +0000 (GMT)
X-AuditID: b6c32a4a-048e07000000267d-6c-67ed39ca0049
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	87.5B.08805.9C93DE76; Wed,  2 Apr 2025 22:21:14 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250402132112epsmtip164f0a3332ab9afbd1a6783e64129bfaa~ygwcqGxk82563025630epsmtip1g;
	Wed,  2 Apr 2025 13:21:12 +0000 (GMT)
Message-ID: <8b7085de-cc9b-45dc-b5bf-1800085fd01d@samsung.com>
Date: Wed, 2 Apr 2025 18:51:11 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] nvme/ioctl: move fixed buffer lookup to
 nvme_uring_cmd_io()
To: Keith Busch <kbusch@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
	<sagi@grimberg.me>, Pavel Begunkov <asml.silence@gmail.com>, Chaitanya
	Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <Z-qoevl5Jaf7WFsQ@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmlu4py7fpBtc6bCzmrNrGaLH6bj+b
	xf+Fc1ktVq4+ymTxrvUci8WkQ9cYLZ5encVkcXnXHDaL+cuesluse/2exYHLY+esu+we5+9t
	ZPG4fLbUY9OqTjaPzUvqPXbfbGDz6G1+x+ax7WEvu8fnTXIBnFHZNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07WyK8ktL
	UhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjO+npnFVrCKq+Ld1ifMDYz7
	OboYOTkkBEwklu94yNbFyMUhJLCbUWLz553MEM4nRonDPzdDOd8YJdZdn8EG03K6bR8rRGIv
	o8Sm469YIJy3jBK/7r1hAqniFbCTeLv9BguIzSKgIjG7bwMzRFxQ4uTMJ2BxUQF5ifu3ZrCD
	2MICkRI93RsZQWwRAWWJu/Nngm1gFtjPJLHmfRNYA7OAuMStJ/OBFnBwsAloSlyYXApicgrY
	S9x+rAVRIS+x/e0csKslBPZwSNz5e4sR4moXiTNT9jBB2MISr45vYYewpSRe9rdB2dkSDx49
	YIGwayR2bO5jhbDtJRr+3GAF2cUMtHb9Ln2IXXwSvb+fgF0jIcAr0dEmBFGtKHFv0lOoTnGJ
	hzOWQNkeEjd7n0GDaiOTxO2/J9kmMCrMQgqVWUienIXknVkImxcwsqxilEwtKM5NTy02LTDK
	Sy2HR3hyfu4mRnAy1vLawfjwwQe9Q4xMHIyHGCU4mJVEeAu13qYL8aYkVlalFuXHF5XmpBYf
	YjQFRs9EZinR5HxgPsgriTc0sTQwMTMzM7E0NjNUEudt3tmSLiSQnliSmp2aWpBaBNPHxMEp
	1cDE4XZeTGGKzjNGu2VZr+at5/7hKqo9u4ZpoZbJ9hsR8/d/vmzs91a8OHTrAvNN999IGFa/
	uFfwVHpb0/lTNj+y9dWE4uYHF5wWXcTz1+EG95QXM23rxU/MrWrpnGNatt2tLzrKysCAY89W
	vd1b/vVyfTaO8fHorlgZ9Mz0a0t5I4fJeyGGFQHuz+W79rPazbC6WHEkw0vytZOr2Hv19Km7
	Z2vGXV0aLsgqxXnrv77jhs1uHO/XX9z5qM1BNZfZ65Cd/Pab8z98+cTMsKvNX/nBspxdKkmf
	DosWFp2xiJN8vXLZ+lsbchOrko+bbXKKq10xT6jY9pUBR0tA2f3DO6fmTl3Ge6yiKdxxlZnE
	NhElluKMREMt5qLiRADumLO0TwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnO4py7fpBh+eMVnMWbWN0WL13X42
	i/8L57JarFx9lMniXes5FotJh64xWjy9OovJ4vKuOWwW85c9ZbdY9/o9iwOXx85Zd9k9zt/b
	yOJx+Wypx6ZVnWwem5fUe+y+2cDm0dv8js1j28Nedo/Pm+QCOKO4bFJSczLLUov07RK4Mr6e
	mcVWsIqr4t3WJ8wNjPs5uhg5OSQETCROt+1j7WLk4hAS2M0o8eLBZyaIhLhE87Uf7BC2sMTK
	f8/ZIYpeM0qseLwLLMErYCfxdvsNFhCbRUBFYnbfBmaIuKDEyZlPwOKiAvIS92/NAKsXFoiU
	6OneyAhiiwgoS9ydPxNsM7PAfiaJz7ubmCA2bGSSeDlvLVgHM9AZt57MB0pwcLAJaEpcmFwK
	YnIK2EvcfqwFUWEm0bW1ixHClpfY/nYO8wRGoVlIzpiFZNAsJC2zkLQsYGRZxSiZWlCcm55b
	bFhglJdarlecmFtcmpeul5yfu4kRHHlaWjsY96z6oHeIkYmD8RCjBAezkghvodbbdCHelMTK
	qtSi/Pii0pzU4kOM0hwsSuK83173pggJpCeWpGanphakFsFkmTg4pRqYmt8mCRfuSDhe3cnC
	ZPnp5Can/pBjL5Yas+jvYJ9rtrcu/JhlxzMumUMH533/qibtFiprylbZk2my5ee21iVnHd58
	XV5RrXrpwr7TYV9YBOXf+vP2TM++EvJqlu1am3MV/GG2gSKal598WfXowP0oTuazc7RNVYLW
	11/728Vu+dfn8H3p5uq8Z3X53dLsrw2kfi4VcOtLfqG5V9HU68Kpzy1zk7llv86sORJ48tW5
	+5UGaktjmwuijj128d8+L2UKQ+kOb/clJydEd7xXFnupv9JqmtfcSb8WrJOVVF+5mk2leemP
	m8eUT6zY/XpV+MkTBmcmXDDJYRA2NGPh3mJV/ZWz/67O+7/CNhu2uMzeq8RSnJFoqMVcVJwI
	AJ2sI+UrAwAA
X-CMS-MailID: 20250402132114epcas5p3dd1ea9335fb7e7b851820410c29b9265
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250328155548epcas5p2368eb1a59883b133a9baf4ac39d6bac6
References: <20250328154647.2590171-1-csander@purestorage.com>
	<CGME20250328155548epcas5p2368eb1a59883b133a9baf4ac39d6bac6@epcas5p2.samsung.com>
	<20250328154647.2590171-4-csander@purestorage.com>
	<48b9a876-0e3b-4c89-9aa3-b48f502868c3@samsung.com>
	<Z-qoevl5Jaf7WFsQ@kbusch-mbp.dhcp.thefacebook.com>

On 3/31/2025 8:06 PM, Keith Busch wrote:
> On Mon, Mar 31, 2025 at 12:16:58PM +0530, Kanchan Joshi wrote:
>> On 3/28/2025 9:16 PM, Caleb Sander Mateos wrote:
>>> For NVMe passthru operations with fixed buffers, the fixed buffer lookup
>>> happens in io_uring_cmd_import_fixed(). But nvme_uring_cmd_io() can
>>> return -EAGAIN first from nvme_alloc_user_request() if all tags in the
>>> tag set are in use. This ordering difference is observable when using
>>> UBLK_U_IO_{,UN}REGISTER_IO_BUF SQEs to modify the fixed buffer table. If
>>> the NVMe passthru operation is followed by UBLK_U_IO_UNREGISTER_IO_BUF
>>> to unregister the fixed buffer and the NVMe passthru goes async, the
>>> fixed buffer lookup will fail because it happens after the unregister.
>> while the patch looks fine, I wonder what setup is required to
>> trigger/test this. Given that io_uring NVMe passthru is on the char
>> device node, and ublk does not take char device as the backing file.
>> Care to explain?
> Not sure I understand the question. A ublk daemon can use anything it
> wants on the backend. Are you just referring to the public ublksrv
> implementation? That's not used here, if that's what you mean.

got it, I did not think beyond public ublksrv.
The userspace block over nvme char-device sounds interesting.

