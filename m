Return-Path: <io-uring+bounces-2698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6930294E459
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 03:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2694A281DF6
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 01:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB1214265;
	Mon, 12 Aug 2024 01:00:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF98F6AD7
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723424454; cv=none; b=QXr1f2dSo7OoYmH9NzxLp3wWxzYxAgrnZ7E+cAxGkWJYr0L88TAwEekf6NIk6lzHopU+ineFChLqaHKMpE7Niwa5xSJOqb/n5IqJcKYR6snmKglTIKpyeLbaltas5aQO1LWDjprzMH0n13EO44t19nJYow3C04uTVrvwOrlEZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723424454; c=relaxed/simple;
	bh=k3c8cEm6qLK9QLSgmMkdPTDGUoN7HeyFy5Y7qzLYqAE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dkRUUZj0hYont9Awj7XqWhlxmiA4fpFTgbdb0TtJnQOKgvGvwPEY8U3maNH0eacaUksQLLz5t/TaWAcuPKDQwuYiSs2T/H2xJFrEpz03msPrAJo0dEYBRdknD3Xi3q+w/uTtTqrUM5ZIBSWbKtt8qt/IXpJm85gzIoLTK5Qa6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=57008 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdJQZ-0007Qn-0p;
	Sun, 11 Aug 2024 21:00:51 -0400
Message-ID: <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Sun, 11 Aug 2024 21:00:50 -0400
In-Reply-To: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
References: 
	<145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
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

On Sun, 2024-08-11 at 20:34 -0400, Olivier Langlois wrote:
> io_napi_entry() has 2 calling sites. One of them is unlikely to find
> an
> entry and if it does, the timeout should arguable not be updated.
>=20
> The other io_napi_entry() calling site is overwriting the update made
> by io_napi_entry() so the io_napi_entry() timeout value update has no
> or
> little value and therefore is removed.
>=20
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
> =A0io_uring/napi.c | 1 -
> =A01 file changed, 1 deletion(-)
>=20
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index 73c4159e8405..1de1d4d62925 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -26,7 +26,6 @@ static struct io_napi_entry
> *io_napi_hash_find(struct hlist_head *hash_list,
> =A0	hlist_for_each_entry_rcu(e, hash_list, node) {
> =A0		if (e->napi_id !=3D napi_id)
> =A0			continue;
> -		e->timeout =3D jiffies + NAPI_TIMEOUT;
> =A0		return e;
> =A0	}
> =A0
I am commenting my own patch because I found something curious that I
was not sure about when I was reviewing the code.

Should the remaining e->timeout assignation be wrapped with a
WRITE_ONCE() macro to ensure an atomic store?


