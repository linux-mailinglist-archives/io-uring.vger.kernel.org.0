Return-Path: <io-uring+bounces-3210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE8F97A7B2
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 21:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EED3E1C24DB5
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 19:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2E2135A54;
	Mon, 16 Sep 2024 19:18:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8C13210D
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726514283; cv=none; b=Md/lui0QDYUIBF+rOxoqiF+cEHM8VcTVXX53Go9kgpHjVDV210DZYRqAyt9f8HWTQxmZ75ZH0JaweaO5Q6lO4lopMU2acUQICsutnIy4rHuQw5LxpgAVYtnRoEogg6IXeRS9YjisjQ6DdrVRmI/FkdPyXCZHuZzEqL381tftOUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726514283; c=relaxed/simple;
	bh=KkmgTUX1K9ClwcOh9AsML5vBT5NXzqxEO9OMcslwl/8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q510kg/gxFAJqB76o0yMMxIGnrruPtdyJeAGBe0mBS5cAnVaqnh2PBo/uyR2rYnn2/XvtSHUCU+wYLAFET6gK7whXM6qf/qGs8KdaseIHUTloK0EhH+UqY9zVY+NIbWsNa3eKboV80Vy93JUQPLqCYTW8L3179UAd5LcO4QTZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=33234 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sqGTf-0003Ee-1O;
	Mon, 16 Sep 2024 14:29:35 -0400
Message-ID: <87554286fec3a8c3003312e6cb31061a731b777f.camel@trillion01.com>
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org
Date: Mon, 16 Sep 2024 14:29:34 -0400
In-Reply-To: <c3a3f99a-586f-4910-9eda-facc8e6bf588@gmail.com>
References: <cover.1723567469.git.olivier@trillion01.com>
	 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
	 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
	 <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
	 <f899f21be48509d72ed8a1955061bef98512fab4.camel@trillion01.com>
	 <1b13d089da46f091d66bbc8f96b1d4da881e53d1.camel@trillion01.com>
	 <c3a3f99a-586f-4910-9eda-facc8e6bf588@gmail.com>
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

On Fri, 2024-08-16 at 15:26 +0100, Pavel Begunkov wrote:
> I pushed what I had (2 last patches), you can use it as a
> reference, but be aware that it's a completely untested
> draft with some obvious problems and ugly uapi.
>=20
> https://github.com/isilence/linux.git=A0manual-napi
> https://github.com/isilence/linux/commits/manual-napi/
>=20
I did review what you have done...
I like your take on this feature idea... especially the autoremove
field.

the one aspect that I prefer in my version over yours, it is that my
implementation avoids totally to call __io_napi_add() which includes a
table lookup from io_poll_check_events() which is big chunk of the
dynamic tracking overhead.

also, when the napi devices are iterated in __io_napi_do_busy_loop(),
my version totally remove the conditional branching from the loop by
having 2 distinct busy loop functions.

but I guess the last point is arguably unimportant since the code is
busy polling...

Anyway, I had the time to create a v2 version of my implementation to
address the remarks made about v1 that I have completed testing. It has
been running on my system for the last 24h flawlessly...

I will post it here shortly. Please take a look at it and pick the best
features of both implementation.


