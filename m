Return-Path: <io-uring+bounces-3219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E60B597B1BD
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 17:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63578B21D2C
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 15:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33909188A2C;
	Tue, 17 Sep 2024 14:59:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8469187FE6
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726585145; cv=none; b=NgHJk+gZ37h6Sh6/xf/7J1c7oHQe/Cp9BJ7QGSufxJpuaDHj6RU8jyD/g0sZvL1p+rKvx0g1LTJvtiG84ONnZ5O98tLMQrgr2yTs/wNEp2TUzj6jS4zFVTvddQcN5hGbBXdu4xgu+Jp97RQd/1ng+QHjPy9q+1VYDBxtm5iKXhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726585145; c=relaxed/simple;
	bh=3f/M3AUa5oV0L+20frcqGoP9clsSu9NWXBB+rwaiS+s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jNexUzIZKVrcEhlqJ/SDfQHgpm5ZWhIdHUXGyvaHj+XAqNal2aoQRC0nmDiCGXAv0lZOOB6vIbUqUc2XnVS0QvYSbwi8Qj4EWLOEcQAdC1yJRggQSwOeoGwTdXQmAnPpZADCIhaqX/IUUJTkud2B/0+VaI6Djkt7UrdxcUYM33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=42868 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sqZfP-0006zg-0Y;
	Tue, 17 Sep 2024 10:58:59 -0400
Message-ID: <80e6166b162521d9ef1ac32d547f1209f2bc505e.camel@trillion01.com>
Subject: Re: [PATCH v2 3/3] io_uring/napi: add static napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Tue, 17 Sep 2024 10:58:57 -0400
In-Reply-To: <c676d789-6ed7-4855-8ace-df6a82460fdf@kernel.dk>
References: <cover.1726354973.git.olivier@trillion01.com>
	 <cd6dc57659b7fe0417189b2d019ba7c5a290c34c.1726354973.git.olivier@trillion01.com>
	 <c676d789-6ed7-4855-8ace-df6a82460fdf@kernel.dk>
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

On Mon, 2024-09-16 at 21:09 -0600, Jens Axboe wrote:
> On 9/16/24 1:20 PM, Olivier Langlois wrote:
> >=20
> > +static void napi_show_fdinfo(struct io_ring_ctx *ctx, struct
> > seq_file *m)
> > +{
> > +	switch (READ_ONCE(ctx->napi_track_mode)) {
> > +	case IO_URING_NAPI_TRACKING_INACTIVE:
> > +		seq_puts(m, "NAPI:\tdisabled\n");
> > +		break;
> > +	case IO_URING_NAPI_TRACKING_DYNAMIC:
> > +		common_tracking_show_fdinfo(ctx, m, "dynamic");
> > +		break;
> > +	case IO_URING_NAPI_TRACKING_STATIC:
> > +		common_tracking_show_fdinfo(ctx, m, "static");
> > +		break;
> > +	}
> > +}
>=20
> Maybe add an "unknown" default entry here, just in case it ever
> changes
> and someone forgets to update the fdinfo code.

ok
>=20
> > +static inline bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
> > +					=A0 void *loop_end_arg)
> > +{
> > +	if (READ_ONCE(ctx->napi_track_mode) =3D=3D
> > IO_URING_NAPI_TRACKING_STATIC)
> > +		return static_tracking_do_busy_loop(ctx,
> > loop_end_arg);
> > +	else
> > +		return dynamic_tracking_do_busy_loop(ctx,
> > loop_end_arg);
> > +}
> > +
>=20
> Minor style nit:
>=20
> 	if (READ_ONCE(ctx->napi_track_mode) =3D=3D
> IO_URING_NAPI_TRACKING_STATIC)
> 		return static_tracking_do_busy_loop(ctx,
> loop_end_arg);
> 	return dynamic_tracking_do_busy_loop(ctx, loop_end_arg);
>=20
> would do.
>=20
will do.

Also, after looking at Pavel work at

https://github.com/isilence/linux/commits/manual-napi/

I have found a way to improve patch #2 of this serie...

v3 is going to be sweet!


