Return-Path: <io-uring+bounces-2768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2459C951A56
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 13:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33051F24465
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 11:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF971B012A;
	Wed, 14 Aug 2024 11:44:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DB31B0124
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723635851; cv=none; b=S/KihtyxFFDGtfb114lHNFRJVyeS4nxRmWZ5AvfpqcRd8lwdBlWN6HOcVybZFbeML8DzbQx71+/kZHRZKJn4tTD+X17ku3pwHUmXGaV409uvZZ7JEedqgCoGOQzksb8id3yxOfGNssJGawuq4rQHEBnJFOedpJ6uUuP9HEEOnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723635851; c=relaxed/simple;
	bh=A4XHFifphxgE+SkaW5hXnDUVRFY+4Y6mNqsdNReuhok=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P3ZIta2MuVmoRHms11Z0A3dLr+3fxXR9g1kukKOi4JqBVbSqPi1sJ0LnYYQQXrHcr4sbROvAGqYGY0Mz9qiVZfE8XkBJMyiGLf9wPZOXT5AYbD283ywU8vYPWf6cpedkMy91M1PPgVF9X9BOI1HQbye2QKyIjWDp0gtc9i4Geo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=52992 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1seCQB-0002O4-0c;
	Wed, 14 Aug 2024 07:44:07 -0400
Message-ID: <f86da1b705e98cac8c72e807ca50d2b4ce3a50a2.camel@trillion01.com>
Subject: Re: [PATCH 1/2] io_uring/napi: Introduce io_napi_tracking_ops
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Wed, 14 Aug 2024 07:44:05 -0400
In-Reply-To: <bfbb03a7ad6256b68d08429c0888a05032a1b182.1723567469.git.olivier@trillion01.com>
References: <cover.1723567469.git.olivier@trillion01.com>
	 <bfbb03a7ad6256b68d08429c0888a05032a1b182.1723567469.git.olivier@trillion01.com>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=mQINBFYd0ycBEAC53xedP1NExPwtBnDkVuMZgRiLmWoQQ8U7vEwt6HVGSsMRHx9smD76i
 5rO/iCT6tDIpZoyJsTOh1h2NTn6ZkoFSn9lNOJksE77/n7HNaNxiBfvZHsuNuI53CkYFix9JhzP3t
 g5nV/401re30kRfA8OPivpnj6mZhU/9RTwjbVPPb8dPlm2gFLXwGPeDITgSRs+KJ0mM37fW8EatJs
 0a8J1Nk8wBvT7ce+S2lOrxDItra9pW3ukze7LMirwvdMRC5bdlw2Lz03b5NrOUq+Wxv7szn5Xr9f/
 HdaCH7baWNAO6H/O5LbJ3zndewokEmKk+oCIcXjaH0U6QK5gJoO+3Yt5dcTo92Vm3VMxzK2NPFXgp
 La7lR9Ei0hzQ0zptyFFyftt9uV71kMHldaQaSfUTsu9dJbnS2kI/j+F2S1q6dgKi3DEm0ZRGvjsSG
 rkgPJ5T16GI1cS2iQntawdr0A1vfXiB9xZ1SMGxL/l6js9BVlIx/CBGOJ4L190QmxJlcAZ2VnQzrl
 ramRUv01xb00IPJ5TBft5IJ+SY0FnY9pIERIl6w9khwLt/oGuKNmUHmzJGYoJHYfh72Mm8RQ1R/JS
 o6v85ULBGdEC3pQq1j//OPyH3egiXIwFq6BtULH5CvsxQkSqgj1MpjwfgVJ8VbjNwqwBXHjooEORj
 vFQqWQki6By3QARAQABtDJPbGl2aWVyIExhbmdsb2lzIChNeSBrZXkpIDxvbGl2aWVyQHRyaWxsaW
 9uMDEuY29tPokCNwQTAQgAIQUCVh3TJwIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBlaka
 GGsWHEI1AD/9sbj+vnFU29WemVqB4iW+9RrHIcbXI4Jg8WaffTQ8KvVeCJ4otzgVT2nHC2A82t4PF
 0tp21Ez17CKDNilMvOt8zq6ZHx36CPjoqUVjAdozOiBDpC4qB6ZKYn+gqSENO4hqmmaOW57wT9vII
 v6mtHmnFvgpOEJl6wbs8ArHDt0BLSjc8QQfvBhoKoWs+ijQTyvFGlQl0oWxEbUkR1J3gdft9Oj9xQ
 G4OFo73WaSEK/L9IalU2ulCBC+ucSP9McoDxy1i1u8HUDrV5wBY1zafc9zVBcMNH6+ZjxwQmZXqtz
 ATzB3RbSFHAdmvxl8q6MeS2yx7Atk0CXgW9z5k2KeuZhz5rVV5A+D19SSGzW11uYXsibZx/Wjr9xB
 KHB6U7qh5sRHaQS191NPonKcsXXAziR+vxwQTP7ZKfy+g5N/e6uivoUnQrl9uvUDDPXEpwVNSoVws
 Vn4tNyrGEdN11pHDbH5fSGzdpbY8+yczUoxMmsEQe/fpVwRBZUqafRn2TVUhV0qqzsUuQcTNw1zIZ
 JgvkqrHgd4ivd2b1bXBczmu/wMGpEnF6cWzSQDiwC1NF3i+gHCuD8IX1ujThWtzXsn0VtrMkrRCbn
 ponVQ6HcbRYYXPuK0HRRjCSuAKo5porVONepiOSmu0FBrpGqBkpBtLrzKXoi1yt/7a/wGdMcVhYGg
 vA==
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Tue, 2024-08-13 at 13:10 -0400, Olivier Langlois wrote:
>=20
> ---
> =A0include/linux/io_uring_types.h | 12 +++++-
> =A0io_uring/fdinfo.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 ++
> =A0io_uring/napi.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 76 ++++=
++++++++++++++++++++++++++--
> --
> =A0io_uring/napi.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 11 +---=
-
> =A04 files changed, 86 insertions(+), 17 deletions(-)
>=20
> diff --git a/include/linux/io_uring_types.h
> b/include/linux/io_uring_types.h
> index 3315005df117..c1d1b28f8cca 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -217,6 +217,16 @@ struct io_alloc_cache {
> =A0	size_t			elem_size;
> =A0};
> =A0
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +struct io_napi_tracking_ops {
> +	void (*add_id)(struct io_kiocb *req);
> +	bool (*do_busy_loop)(struct io_ring_ctx *ctx,
> +			=A0=A0=A0=A0 void *loop_end_arg);
> +	void (*show_fdinfo)(struct io_ring_ctx *ctx,
> +			=A0=A0=A0 struct seq_file *m);
> +};
> +#endif
> +
I have kept thinking about the critic...

add_id is either NULL or equal to dynamic_tracking_add_id and the
pointer is even tested before calling it. This pointer is easily
removed.

show_fdinfo, well, this is is so unimportant, if you don't like it, it
is very easily removable too. nobody will notice.

the only thing that would remains is do_busy_loop. Its value can either
be:

- no_tracking_do_busy_loop
- dynamic_tracking_do_busy_loop
- static_tracking_do_busy_loop

so the whole io_napi_tracking_ops could be replaced by a single
function pointer

At this point, the only thing remaining point to determine is which
between calling a function pointer of calling a 2 conditional branches
code is more efficient. and I am of the opinion that the function
pointer is better due to my C++ background but this is debatable...


