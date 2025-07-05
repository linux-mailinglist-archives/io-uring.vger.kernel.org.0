Return-Path: <io-uring+bounces-8604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE91AF9F4D
	for <lists+io-uring@lfdr.de>; Sat,  5 Jul 2025 11:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2306B7B4802
	for <lists+io-uring@lfdr.de>; Sat,  5 Jul 2025 09:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB75F1FE474;
	Sat,  5 Jul 2025 09:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="rh7fjgVz"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2089734545;
	Sat,  5 Jul 2025 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751706822; cv=none; b=gFci4kFdmTuKYjimqhVE83KADgDAY+3jjPtDz+8ADypRGr3OioMsTSLTGFjtUO6hpJH3Lu7mabNwj3dykTQz7Uu37FuYNF8MbCOwxUi+24asANSoORf9Xv42uL1gPiP7/2qFsr5QB5tcMESZCvdfKW52kAWivYWlXOz/8gPqDeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751706822; c=relaxed/simple;
	bh=+k58njZRa+tf5dSyA26KnEzAwXavd9dDcbpl8IokLhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGChBgNl7wVg9zRPuw2p1/KLitidQl/lL94yVxsisEfNB7VwKDGNMxPTV1Nvz38fSBya2nVvfiXDRsNRHFVsKRkZos+7Y0blakz+2v+YyUSw8ecZIPdzeoLT8Ljp6Gk+3YKvfZ41bYNB2yaNdz5f02i6Ovs+r6Te3G1g5ZqL790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=rh7fjgVz; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1751706818; x=1752311618; i=deller@gmx.de;
	bh=GknidmtbS5Yh18JIKsjTK0SS+YuBF48OVinhthcTMSw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rh7fjgVzE0+WkUaR/xkgae51Rsex1Brb8h9aOOToMgMJ3bgepUXJszXN939gCOoE
	 ohWiuJVlri6W/WJIoYpcp8DxZ+epr03hGb7sWNDQfV9AnMWyEW0tyWqkR7wPzVK+9
	 s8JahTfAxpRrWnhaesmZwxyzAtbaQdcsyX+LjU9q0TX6s9+TWyl2i1I0tGM7peZVw
	 MA+umhQBJ2vxYmG7xN3F16RFaJx58G8FM7T/Ei/4hQ4SvDz8C8BbV5fa3quOOpUDX
	 8L1filj/p7rBTPEXr1B0vIYQiV2yOJZJUqc/VTlHK/X4M44zSbokyWAicwnwKuSby
	 IajIIaFHMBzpe/SbWg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.173] ([109.250.63.117]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8hVB-1ucfvk34bZ-00GMK0; Sat, 05
 Jul 2025 11:13:37 +0200
Message-ID: <6353f411-071f-41f8-8dc8-b2bfeea75ca0@gmx.de>
Date: Sat, 5 Jul 2025 11:13:36 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: Fix addr usage on get_unmapped_area()
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@nvidia.com>,
 io-uring@vger.kernel.org
References: <20250625200310.1968696-1-peterx@redhat.com>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <20250625200310.1968696-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9Ke4193ba19YKO2RDex92Fe/h7JTJ76yy4hEwVLHbzO1gZ+ugiF
 sq4MTsTh9xQmXEuMiZD1UafGCFnnJNDK3xwj+iRbNoW+gaadjZep+z+BqxhpWpN58gFazMe
 LBW/jV4BpNc/9B2S2wwLFZ+qTHxtD+HslD7hkh4eUqxAEjbCxz/sRcOJTxx4+ar1iodbFMk
 m5nqXicG1aQczRQVQ5zmw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TDgXrhcBLxQ=;vLxZthMzALfTEhbGTRhgVG/XEI7
 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

On 6/25/25 22:03, Peter Xu wrote:
> mm_get_unmapped_area() is an internal mm API to calculate virtual addres=
ses
> for mmap().  Here, addr parameter should normally be passed over from an
> userspace as hint address.  When with MAP_FIXED, it's required to use th=
e
> address or fail the mmap().
>=20
> When reviewing existing mm_get_unmapped_area() users, I stumbled upon th=
is
> use case, where addr will be adjusted to io_uring_validate_mmap_request(=
).
> That internally uses io_region_get_ptr() to fetch the kernel address tha=
t
> io_uring used, by either page_address() or vmap() from io_region_init_pt=
r()
> calls.
>=20
> Here, the io_mapped_region.ptr isn't a valid user address, hence passing=
 it
> over to mm_get_unmapped_area() is misleading if not wrong.
>=20
> The problem should be about parisc having issues with cache aliasing whe=
n
> both io_uring kernel and the userspace may map the same pages.  Here wha=
t
> matters should be pgoff rather than the address hint. =20

The whole aliasing is quite fragile on parisc, and if I remember that
code it sometimes does depend on the address too.
I really want to test your patch completely, before it should go in.
I will try to test during the next few days.

Thanks!
Helge

> Simplify the code to
> keep addr=3D0, while setup pgoff only to make sure the VA to be calculat=
ed
> will satisfy VIPT's cache aliasing demand.
>=20
> Cc: Helge Deller <deller@gmx.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> Marking this as RFC because I don't have parisc hence no test done, but
> raise this issue.
> ---
>   io_uring/memmap.c | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 725dc0bec24c..8b74894489bc 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -371,21 +371,17 @@ unsigned long io_uring_get_unmapped_area(struct fi=
le *filp, unsigned long addr,
>   	 * kernel memory *and* userspace memory. To achieve that:
>   	 * - use a NULL file pointer to reference physical memory, and
>   	 * - use the kernel virtual address of the shared io_uring context
> -	 *   (instead of the userspace-provided address, which has to be 0UL
> -	 *   anyway).
> -	 * - use the same pgoff which the get_unmapped_area() uses to
> -	 *   calculate the page colouring.
> +	 *   to calculate pgoff, which will be used later in parisc va
> +	 *   allocator to calculate VIPT-safe aliasing va.
>   	 * For architectures without such aliasing requirements, the
> -	 * architecture will return any suitable mapping because addr is 0.
> +	 * architecture will return any suitable mapping because pgoff is 0.
>   	 */
>   	filp =3D NULL;
>   	flags |=3D MAP_SHARED;
> -	pgoff =3D 0;	/* has been translated to ptr above */
>   #ifdef SHM_COLOUR
> -	addr =3D (uintptr_t) ptr;
> -	pgoff =3D addr >> PAGE_SHIFT;
> +	pgoff =3D (uintptr_t)ptr >> PAGE_SHIFT;
>   #else
> -	addr =3D 0UL;
> +	pgoff =3D 0;
>   #endif
>   	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flag=
s);
>   }


