Return-Path: <io-uring+bounces-2603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E809413DF
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 16:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC5A51C22CEC
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6153A86AEE;
	Tue, 30 Jul 2024 14:04:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA21DA24
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722348297; cv=none; b=gGKWptEe5PmRj/Ly0CdK/5Sn8QeeVfVdY5+JRixGXhNeD1cWD1OVXQgwT1BbODRANdXRMJHFx7BiYQEuqdRk8nF8MwmoNGLDmp9CC3FwOVeQFPuzVzL3YxIFU4zWc2y6snCMpUxX0ArmxSjNMsY0NI/bP0AtL97Ts6oSZik4Oxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722348297; c=relaxed/simple;
	bh=D3UBA5pCS0scVgmNg+HGfGM4dvCak3wzOxuOMWQ0k/E=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=enr2iA0qnRpxZtxif9v9+qsssJVcHdMnBwRli0RQlxZaFYo2a0YDv0meSY4PWzOkL+Vz6iWHWPPP+CwqmqN7KkjeHjiDYrNaNTrU7Y8ljpZTZxMZGCswS/+7yFg/7IB3tgkcyHwHAxhhFjVHo1Rr3xmiU1tWmNqgXPBJJlLtQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=58848 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYnT8-0005Je-2t;
	Tue, 30 Jul 2024 10:04:50 -0400
Message-ID: <0ad8d8b1912f5d3b1115dca9ee229c6f6c0226b2.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org
Date: Tue, 30 Jul 2024 10:04:43 -0400
In-Reply-To: <99aa340f-2379-4bdb-9a7d-941eee4bf3bf@gmail.com>
References: 
	<bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
	 <99aa340f-2379-4bdb-9a7d-941eee4bf3bf@gmail.com>
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
User-Agent: Evolution 3.52.3 
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

Thank you Pavel for your review!

Since I have no indication if Jens did see your comment before applying
my patch, I will prepare another one with your comment addressed.

just ignore it if it is not needed anymore.

On Tue, 2024-07-30 at 12:05 +0100, Pavel Begunkov wrote:
> On 7/29/24 23:38, Olivier Langlois wrote:
> > this info may be useful when attempting to debug a problem
> > involving a ring using the feature.
>=20
> Apart from a comment below,
>=20
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>=20
> Maybe, Jens would be willing to move the block after the spin_unlock
> while applying.
>=20
>=20
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > ---
> > =A0 io_uring/fdinfo.c | 13 ++++++++++++-
> > =A0 1 file changed, 12 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> > index b1e0e0d85349..3ba42e136a40 100644
> > --- a/io_uring/fdinfo.c
> > +++ b/io_uring/fdinfo.c
> > @@ -221,7 +221,18 @@ __cold void io_uring_show_fdinfo(struct
> > seq_file *m, struct file *file)
> > =A0=A0			=A0=A0 cqe->user_data, cqe->res, cqe->flags);
> > =A0=20
> > =A0=A0	}
> > -
> > +#ifdef CONFIG_NET_RX_BUSY_POLL
> > +	if (ctx->napi_enabled) {
> > +		seq_puts(m, "NAPI:\tenabled\n");
> > +		seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx-
> > >napi_busy_poll_dt);
> > +		if (ctx->napi_prefer_busy_poll)
> > +			seq_puts(m,
> > "napi_prefer_busy_poll:\ttrue\n");
> > +		else
> > +			seq_puts(m,
> > "napi_prefer_busy_poll:\tfalse\n");
> > +	} else {
> > +		seq_puts(m, "NAPI:\tdisabled\n");
> > +	}
> > +#endif
> > =A0=A0	spin_unlock(&ctx->completion_lock);
>=20
> That doesn't need to be under completion_lock, it should move outside
> of the spin section.
>=20
>=20
> > =A0 }
> > =A0 #endif
>=20


