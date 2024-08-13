Return-Path: <io-uring+bounces-2754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79986950F2E
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 23:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A81AF1C218B2
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 21:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2925613AA4E;
	Tue, 13 Aug 2024 21:34:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4B617CC
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723584874; cv=none; b=k32CUtVVyhJoJX+wRrmDlngTs6iFtC25Nw2d99bjM2VnjuzFro82LM9klsKNQhE/HcchhN7vALNSM84IRMb5nk14HVVjuBwtvw2szWqm1l5z1KCBzQxIekSEuI7r4+n7WH7sMN2x9q1vVNhJXrfo+qoD9RVRI9btP5tohnpC9CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723584874; c=relaxed/simple;
	bh=yZGYAJ1kCjayOGosw0khwnt6sGQwYHzsnrW03dOTHrQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qJvU+dNyGDsrIz92UFqN1S6t4fYp748uNODWOhu0K0xwtuUMM9SRbF8FCxl63x3zFXTztkDk+xvaAjkGv9VpEsiMQXd/8DMX+zw40Dxadj8X2tKCtEaQEmCjvbou1guTJoyu5tzU7f49xw4qRra44t5DdcJpkEMhQFICHLRlDmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=54982 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdz9y-0002t0-1m;
	Tue, 13 Aug 2024 17:34:30 -0400
Message-ID: <a825ae96ea73b74ffd278ba33fa513a6914ec828.camel@trillion01.com>
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Tue, 13 Aug 2024 17:34:29 -0400
In-Reply-To: <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
References: <cover.1723567469.git.olivier@trillion01.com>
	 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
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

On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
> On 8/13/24 10:44 AM, Olivier Langlois wrote:
> > the actual napi tracking strategy is inducing a non-negligeable
> > overhead.
> > Everytime a multishot poll is triggered or any poll armed, if the
> > napi is
> > enabled on the ring a lookup is performed to either add a new napi
> > id into
> > the napi_list or its timeout value is updated.
> >=20
> > For many scenarios, this is overkill as the napi id list will be
> > pretty
> > much static most of the time. To address this common scenario, a
> > new
> > abstraction has been created following the common Linux kernel
> > idiom of
> > creating an abstract interface with a struct filled with function
> > pointers.
> >=20
> > Creating an alternate napi tracking strategy is therefore made in 2
> > phases.
> >=20
> > 1. Introduce the io_napi_tracking_ops interface
> > 2. Implement a static napi tracking by defining a new
> > io_napi_tracking_ops
>=20
> I don't think we should create ops for this, unless there's a strict
> need to do so. Indirect function calls aren't cheap, and the CPU side
> mitigations for security issues made them worse.
>=20
> You're not wrong that ops is not an uncommon idiom in the kernel, but
> it's a lot less prevalent as a solution than it used to. Exactly
> because
> of the above reasons.
>=20
if indirection is a very big deal, it might be possible to remove one
level of indirection.

I did entertain the idea of making copies of the io_napi_tracking_ops
structs instead of storing their addresses. I did not kept this option
because of the way that I did implement io_napi_get_tracking()...

but if this would be an acceptable compromise, this is definitely
something possible.


