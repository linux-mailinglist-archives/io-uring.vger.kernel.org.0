Return-Path: <io-uring+bounces-2727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CA394F913
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 23:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E2D9B2229F
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA211957E9;
	Mon, 12 Aug 2024 21:46:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B94D112
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 21:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499161; cv=none; b=ggRopbCEn9yAjCM6BAQs5LkDC/s3JyP9lCUSOZFj2KSlHg3d5ONqLW9oBuoFgqZnC548cV2mm50lNWm4zsPprnH0w7K2yxJiyY31AIm5o1yR2bCYNdYkDkVJB8m3NktCn9rq+++RkQDGwyNiXBzjxmoKfxu88mMQrOkbaa9B1gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499161; c=relaxed/simple;
	bh=96H/cCKyEgSBimeiZA594WjOl2rvn65nAEPYx2Tmxnw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g32Aln4MQNzQBpy777MhhAhpmrDjJI2kNSIPNhYXGO6tqgciHJjemogmBzvE16mQoLubFwJNXRcxzXijfg45eSRtmLkzRki0CRj1Rpg1TzS96PzY3JtvFY4iiXj3lG7CCLYnW/eWvvyr6yZg5oS+EBySOxxfnIAd0AKhkgDBazE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=54090 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdcrU-0007Kw-0i;
	Mon, 12 Aug 2024 17:45:56 -0400
Message-ID: <64d635e9bf39878d21f9b9a7a5d6e74614ad7c66.camel@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Mon, 12 Aug 2024 17:45:55 -0400
In-Reply-To: <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
References: 
	<145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
	 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
	 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
	 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
	 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
	 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
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

On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>=20
> @@ -174,9 +174,8 @@ static void io_napi_blocking_busy_loop(struct
> io_ring_ctx *ctx,
> =A0	do {
> =A0		is_stale =3D __io_napi_do_busy_loop(ctx,
> loop_end_arg);
> =A0	} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
> !loop_end_arg);
> -	rcu_read_unlock();
> -
> =A0	io_napi_remove_stale(ctx, is_stale);
> +	rcu_read_unlock();
> =A0}
>=20
> @@ -309,9 +309,8 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx
> *ctx)
> =A0
> =A0	rcu_read_lock();
> =A0	is_stale =3D __io_napi_do_busy_loop(ctx, NULL);
> -	rcu_read_unlock();
> -
> =A0	io_napi_remove_stale(ctx, is_stale);
> +	rcu_read_unlock();
> =A0	return 1;
> =A0}
> =A0
>=20
Jens,

I have big doubts that moving the rcu_read_unlock() call is correct.
The read-only list access if performed by the busy loops block.

io_napi_remove_stale() is then modifying the list after having acquired
the spinlock. IMHO, you should not hold the RCU read lock when you are
updating the data. I even wonder is this could not be a possible
livelock cause...


