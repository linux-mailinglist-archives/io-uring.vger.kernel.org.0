Return-Path: <io-uring+bounces-2781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDDC953D73
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 00:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426D61F2395F
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 22:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664E81552E3;
	Thu, 15 Aug 2024 22:44:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D75155314
	for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761889; cv=none; b=ladKPVnX8BAL1v8Uc2pUJPOpIPTf1v/hMucl2KGSVZytME9bZKwXYvpnLZPWqRyS2BYL/eN+08VLuDUsMhR3kQJLhtUpT/mWLIBN7SSXJF9XhlKm6/AUG82GmeSPiA/6IEadWBmH7tA1UiB66OafG3CzTOJOkd0zmx79QU1pDUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761889; c=relaxed/simple;
	bh=CMsw78qj/l3OlO3KHZS1JJpd9VQvkl14TSChROLxjhU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=at5H4gg0pxK/G0WiW3iwoE+4ANSEPWUWTT16Z1jg/YreH39pZjpnatqWXrQ3BH5basgrtYCKVkfv12YyFSf5DBoctR13CN6I65xJgpieFt1EjQMxjjLdI71qeGuNNx2Pdvj3fvGj5KP6PBy2m3rE31/AsUvtPxI1YPNpMGNzcXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=54318 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sejD3-0003m4-32;
	Thu, 15 Aug 2024 18:44:45 -0400
Message-ID: <1b13d089da46f091d66bbc8f96b1d4da881e53d1.camel@trillion01.com>
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Thu, 15 Aug 2024 18:44:45 -0400
In-Reply-To: <f899f21be48509d72ed8a1955061bef98512fab4.camel@trillion01.com>
References: <cover.1723567469.git.olivier@trillion01.com>
	 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
	 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
	 <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
	 <f899f21be48509d72ed8a1955061bef98512fab4.camel@trillion01.com>
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

On Thu, 2024-08-15 at 18:17 -0400, Olivier Langlois wrote:
>=20
> To my eyes, what is really important, it is that absolute best
> technical solution is choosen and the only way that this discussion
> can
> be done, it is with numbers. So I have created a small created a
> small
> benchmark program to compare a function pointer indirect call vs
> selecting a function in a 3 branches if/else if/else block. Here are
> the results:
>=20
> ----------------------------------------------------------
> Benchmark=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Time=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 CPU=A0=A0 Iterations
> ----------------------------------------------------------
> BM_test_virtual=A0=A0=A0=A0=A0 0.628 ns=A0=A0=A0=A0=A0=A0=A0 0.627 ns=A0=
=A0=A0 930255515
> BM_test_ifElse=A0=A0=A0=A0=A0=A0=A0 1.59 ns=A0=A0=A0=A0=A0=A0=A0=A0 1.58 =
ns=A0=A0=A0 446805050
>=20
I have fixed my benchmark:

----------------------------------------------------------
Benchmark                Time             CPU   Iterations
----------------------------------------------------------
BM_test_virtual       2.57 ns         2.53 ns    277764970
BM_test_ifElse        1.58 ns         1.57 ns    445197861

code:
using Func_t =3D bool (*)();

bool testVirtual(Func_t ptr)
{
    return ptr();
}

void BM_test_virtual(benchmark::State &state)
{
    volatile Func_t ptr =3D &static_tracking_do_busy_loop;

    for (auto _ : state) {
        benchmark::DoNotOptimize(testVirtual(ptr));
    }
}


