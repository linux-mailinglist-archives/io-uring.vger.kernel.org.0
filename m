Return-Path: <io-uring+bounces-2723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D70BE94F835
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 22:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54BEF1F2288D
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C08B186E30;
	Mon, 12 Aug 2024 20:29:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A316C854
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 20:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723494557; cv=none; b=I2KEnRq2N9DbYVV2+7HWnc9GaPT4/qy8D+PRdG09u+Jubn0wkmR5PtwJwGD4NtJGXZtBct26kk4c4UakW1QZqfQ35CCryZHjhYqG0nVDmdCz2mIxrTibTgt9QLfBN2Zyp6LoOxXvvZ/3VdIKK4LZJzdAHGRIGWmoCMbm4aqBdbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723494557; c=relaxed/simple;
	bh=ZNHyRNvGB7jr+ikDaK8n2TqQPyhOgSEG1FH9rMvthfA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lGcJvDUgkPLY2ac8UhCEFj3T0MpttkvrLapprg6NMSZzrdbOGjcov9P1qCoVTl4HFON8vQmVPMjDAWZUMkOIFOEeysT+q642Ud72wO4EITV1myJX0AnrurnVqI/+UtYwanfvtDEjS/+ROOs6QVcR2ZGUpoYahZgdDsMQZudmxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=41174 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdbfF-0002rj-2F;
	Mon, 12 Aug 2024 16:29:13 -0400
Message-ID: <cfc648a82ca633af4c1566447195b955d901777b.camel@trillion01.com>
Subject: Re: [PATCH v2] io_uring: do the sqpoll napi busy poll outside the
 submission block
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Mon, 12 Aug 2024 16:29:12 -0400
In-Reply-To: <44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
References: 
	<44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
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

On Tue, 2024-07-30 at 17:10 -0400, Olivier Langlois wrote:
> there are many small reasons justifying this change.
>=20
> 1. busy poll must be performed even on rings that have no iopoll and
> no
> =A0=A0 new sqe. It is quite possible that a ring configured for inbound
> =A0=A0 traffic with multishot be several hours without receiving new
> request
> =A0=A0 submissions
> 2. NAPI busy poll does not perform any credential validation
> 3. If the thread is awaken by task work, processing the task work is
> =A0=A0 prioritary over NAPI busy loop. This is why a second loop has been
> =A0=A0 created after the io_sq_tw() call instead of doing the busy loop
> in
> =A0=A0 __io_sq_thread() outside its credential acquisition block.
>=20
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
> =A0io_uring/napi.h=A0=A0 | 9 +++++++++
> =A0io_uring/sqpoll.c | 6 +++---
> =A02 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 88f1c21d5548..5506c6af1ff5 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -101,4 +101,13 @@ static inline int
> io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
> =A0}
> =A0#endif /* CONFIG_NET_RX_BUSY_POLL */
> =A0
> +static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
> +{
> +	int ret =3D 0;
> +
> +	if (io_napi(ctx))
> +		ret =3D io_napi_sqpoll_busy_poll(ctx);
> +	return ret;
> +}
> +
> =A0#endif
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index cc4a25136030..7f4ed7920a90 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -195,9 +195,6 @@ static int __io_sq_thread(struct io_ring_ctx
> *ctx, bool cap_entries)
> =A0			ret =3D io_submit_sqes(ctx, to_submit);
> =A0		mutex_unlock(&ctx->uring_lock);
> =A0
> -		if (io_napi(ctx))
> -			ret +=3D io_napi_sqpoll_busy_poll(ctx);
> -
> =A0		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
> =A0			wake_up(&ctx->sqo_sq_wait);
> =A0		if (creds)
> @@ -322,6 +319,9 @@ static int io_sq_thread(void *data)
> =A0		if (io_sq_tw(&retry_list,
> IORING_TW_CAP_ENTRIES_VALUE))
> =A0			sqt_spin =3D true;
> =A0
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +			io_do_sqpoll_napi(ctx);
> +		}
> =A0		if (sqt_spin || !time_after(jiffies, timeout)) {
> =A0			if (sqt_spin) {
> =A0				io_sq_update_worktime(sqd, &start);

any updates on this patch rework sent more than a week ago?

on my side, it has been abundantly tested and I am currently using it
on my prod setup...


