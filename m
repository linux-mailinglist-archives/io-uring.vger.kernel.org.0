Return-Path: <io-uring+bounces-2728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAB294F921
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 23:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AB071C202F5
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12FB170A0F;
	Mon, 12 Aug 2024 21:50:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF51586D3
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499425; cv=none; b=dDHquZoB5s8n5x+Hk9PVfXJ91MbPkiZ2pHzPZjM3mzQSHTrVTYcJ/4w9Y7k12UWg9FV0sQZNe+In5bo5WKp6OPEnTywsF5SGX/DooNTNAFZsXcmRGBSMpgg4HMzFiDPXqK69Ol0nQiTLdZT9MjpM5HTU6d2ZeNTi77IymAknZb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499425; c=relaxed/simple;
	bh=mpGIuF/5zIvGdK/NRoHCN0vD17sq25jHQWo6e6zh1AA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YFBHb3EYhvu17xa/3Jqr88IjHMy5EB243cMoQRRJsxLUc7BlTbmDUb2B/RESJrzoxp0+4gI7tOsoMAkAgGUKVNI1KgYbeCuXz0JjbXCfWEBcHZNCn3u/AvQvsr5AwMq6pONzkVY9P8v+mfIr7zRW3w7rH4ISKBSt178h1PrAMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=52442 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdcvm-0007c7-1s;
	Mon, 12 Aug 2024 17:50:22 -0400
Message-ID: <c1a333db6bce30ac770a590f80f3d26e945c5065.camel@trillion01.com>
Subject: Re: [PATCH v2] io_uring: do the sqpoll napi busy poll outside the
 submission block
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Mon, 12 Aug 2024 17:50:21 -0400
In-Reply-To: <402e9573-2616-4cd9-8566-e7d99fe1ab53@kernel.dk>
References: 
	<44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
	 <402e9573-2616-4cd9-8566-e7d99fe1ab53@kernel.dk>
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

On Mon, 2024-08-12 at 14:31 -0600, Jens Axboe wrote:
> On 7/30/24 3:10 PM, Olivier Langlois wrote:
> > diff --git a/io_uring/napi.h b/io_uring/napi.h
> > index 88f1c21d5548..5506c6af1ff5 100644
> > --- a/io_uring/napi.h
> > +++ b/io_uring/napi.h
> > @@ -101,4 +101,13 @@ static inline int
> > io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
> > =A0}
> > =A0#endif /* CONFIG_NET_RX_BUSY_POLL */
> > =A0
> > +static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
> > +{
> > +	int ret =3D 0;
> > +
> > +	if (io_napi(ctx))
> > +		ret =3D io_napi_sqpoll_busy_poll(ctx);
> > +	return ret;
> > +}
> > +
>=20
> static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
> {
> 	if (io_napi(ctx))
> 		return io_napi_sqpoll_busy_poll(ctx);
> 	return 0;
> }
>=20
> is a less convoluted way of doing the same.

I agree. but if I am to produce a 3rd version. How about even not
returning anything at all since the caller ignores the return value?

I was hesitating about doing this but I did figure that a reviewer
would point it out if it was the right thing to do...


