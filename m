Return-Path: <io-uring+bounces-513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2450844958
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 22:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CCF128EE1B
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 21:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B9E1E4B3;
	Wed, 31 Jan 2024 21:03:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E7C38DF1;
	Wed, 31 Jan 2024 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706735011; cv=none; b=PSIkP/c7/leVOrMSCv/vsmxH0GlTjFRwcR0aCuRXgQE7tm96Uh9kEUBZYI98tZBgfb2cQsS46Db6nzl3H2XktylHRj7fSQPSUkt4AG9Q0pFJIhxdgxtaEx3ILPfDEL0dM6VuEIo/tEgTx3Uu6/HZ4Jmu3gecFR7J8dzhVDG4HXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706735011; c=relaxed/simple;
	bh=nE+usYLWSwj/fc4Kxs9p3qqYu9nlHuOs/mGtpFn0Pn4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j3rfJd7JNu4cZLii59QRm1EFISqBQ/zFQvhXRtV/RNzcJb6ZFtlt60kDJ09vQ98mJj28+UB16SA4ecSrAkimoLtvnUL8NYnTe8kaJOQsf2SPCV5+PSlTswLp36Nrnqb61eXt51LhEOyTIXWP0XMY5dVeLNrAUhvKu6SlXwkruAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=55234 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1rVHjz-0000T4-22;
	Wed, 31 Jan 2024 16:03:27 -0500
Message-ID: <4200ddd9182f426c8c046a2058810384205f7f35.camel@trillion01.com>
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@devkernel.io>, 
	io-uring@vger.kernel.org, kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
Date: Wed, 31 Jan 2024 16:03:26 -0500
In-Reply-To: <a0f5b96b-c876-4c0a-a7b5-3809c26077d6@kernel.dk>
References: <20230608163839.2891748-1-shr@devkernel.io>
	 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
	 <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
	 <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
	 <b6dc538a-01eb-4f87-a9d4-dea17235ff85@kernel.dk>
	 <34560e193660122ea142daa0fbeb381eb7b0eb6d.camel@trillion01.com>
	 <c28b3f5f40ed028ba9d74e94e3cc826c04f38bf7.camel@trillion01.com>
	 <a0f5b96b-c876-4c0a-a7b5-3809c26077d6@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=mQINBFYd0ycBEAC53xedP1NExPwtBnDkVuMZgRiLmWoQQ8U7vEwt6HVGSsMRHx9smD76i5rO/iCT6tDIpZoyJsTOh1h2NTn6ZkoFSn9lNOJksE77/n7HNaNxiBfvZHsuNuI53CkYFix9JhzP3tg5nV/401re30kRfA8OPivpnj6mZhU/9RTwjbVPPb8dPlm2gFLXwGPeDITgSRs+KJ0mM37fW8EatJs0a8J1Nk8wBvT7ce+S2lOrxDItra9pW3ukze7LMirwvdMRC5bdlw2Lz03b5NrOUq+Wxv7szn5Xr9f/HdaCH7baWNAO6H/O5LbJ3zndewokEmKk+oCIcXjaH0U6QK5gJoO+3Yt5dcTo92Vm3VMxzK2NPFXgpLa7lR9Ei0hzQ0zptyFFyftt9uV71kMHldaQaSfUTsu9dJbnS2kI/j+F2S1q6dgKi3DEm0ZRGvjsSGrkgPJ5T16GI1cS2iQntawdr0A1vfXiB9xZ1SMGxL/l6js9BVlIx/CBGOJ4L190QmxJlcAZ2VnQzrlramRUv01xb00IPJ5TBft5IJ+SY0FnY9pIERIl6w9khwLt/oGuKNmUHmzJGYoJHYfh72Mm8RQ1R/JSo6v85ULBGdEC3pQq1j//OPyH3egiXIwFq6BtULH5CvsxQkSqgj1MpjwfgVJ8VbjNwqwBXHjooEORjvFQqWQki6By3QARAQABtDJPbGl2aWVyIExhbmdsb2lzIChNeSBrZXkpIDxvbGl2aWVyQHRyaWxsaW9uMDEuY29tPokCNwQTAQgAIQUCVh3TJwIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBlakaGGsWHEI1AD/9sbj+vnFU29WemVqB4iW+9RrHIcbXI4Jg8WaffTQ8KvVeCJ4otzgVT2nHC2A82t4PF0tp21Ez17CKDNilMvOt8zq6ZHx36CPjoqUVjAdozOiBDpC4qB6ZKYn+gqSENO4hqmmaOW57wT
	9vIIv6mtHmnFvgpOEJl6wbs8ArHDt0BLSjc8QQfvBhoKoWs+ijQTyvFGlQl0oWxEbUkR1J3gdft9Oj9xQG4OFo73WaSEK/L9IalU2ulCBC+ucSP9McoDxy1i1u8HUDrV5wBY1zafc9zVBcMNH6+ZjxwQmZXqtzATzB3RbSFHAdmvxl8q6MeS2yx7Atk0CXgW9z5k2KeuZhz5rVV5A+D19SSGzW11uYXsibZx/Wjr9xBKHB6U7qh5sRHaQS191NPonKcsXXAziR+vxwQTP7ZKfy+g5N/e6uivoUnQrl9uvUDDPXEpwVNSoVwsVn4tNyrGEdN11pHDbH5fSGzdpbY8+yczUoxMmsEQe/fpVwRBZUqafRn2TVUhV0qqzsUuQcTNw1zIZJgvkqrHgd4ivd2b1bXBczmu/wMGpEnF6cWzSQDiwC1NF3i+gHCuD8IX1ujThWtzXsn0VtrMkrRCbnponVQ6HcbRYYXPuK0HRRjCSuAKo5porVONepiOSmu0FBrpGqBkpBtLrzKXoi1yt/7a/wGdMcVhYGgvLkCDQRWHdMnARAAyH1rGDNZuYMiNlo4nqamRmhnoRyHeBsEqrb4cBH5x5ASEeHi0K1AR4+O5Cm5/iJ/txhWkPOmSo7m0JTfYBC6XCPs0JscpKCHIBCbZX5wkq6XKu1lxoJefjE+Ap4T7wEuiD5XPvy2puJYsPGnmaKuuQ0EwOelEtMWcaQtkN71uZ4wRw5QGRFQ4jrt4UlggBfjemS1SbmKOWPp+9Zm9QCujh/qPNC2EmaJzIBezxmwCu+e/GL4p7/KrA9ZcmS2SrbkQ4RO0it0S+Fh8XyZc1FyrJua4cgxjbMYgGWH+QdCzBNg4wp9o8Xlv1UvTCFhSptQBehxtkNO4qSO7c/yAtmV5F6PC68tYbc+cVw/V2I8SZhTmPDM/xf6PbkCpJGZa8XRFKvaShkAGnLmUUJ8xMwTnuV0+tFY+1ozd6gaVxMHNkmavvc3rHZcLz
	1i8wf+UEryTNuWzbHJnJrXpnfa9sRm85/LrgyDcdBQRaNSaWcGwGcM6pHaSmCTVdI4eVzjBFIr8J0QkR7VLv3nmSNf+zZZAUIVO+fMQWIf6GNqMpfplrQb8GZAbHo/M8GE7PFCcYeBMngQKnEdjUPObXXT16iAZ2yg/gr2LeJHR+lYwaBA8kN6EwTq+H+36AD5MAN5nV2HHL2GboaZP9zQK/gG8DBagWgHFGLa7elQ6bgYXKwNK5EAEQEAAYkCHwQYAQgACQUCVh3TJwIbDAAKCRBlakaGGsWHECguD/46lqS+MBs6m0ZWZWw0xOhfGMOjjJkx8oAx7qmXiyyfklYee5eLMFw+IEIefXw+S8Gx3bz2FMPC+aHNlEhxMlwmgAZuiWf1ezU1HeZtwgn3LipQbeddtPmsIry458eTos9qTdA/etig8zRuqrt0oSbu1HtvgXgRwng9CdHpX+fWs3a24C1BuE0prsnzSiqjvO9rdJ9EkE+kPCjikttNYfura4fv3RqsY0lhwWebRaQpPefjAoNpAhNGJgB6gK1aFOxjHvk6zVm6pOAIoqwyONYcZXZD5yOStvQ6eC9NZ5DppBIBRxLsrUeBnBHgVMg+czVNmu1olDKM0P4WTFIG1aJ73OYPS2qjQbB9rdFSfBjVqwk3kUZAl69KE1iKqmZzlGlP+iyMFwyUIR3MlCVipsAxhxiG7paZygB8dLSK6gWI4LvIpDXtWF0nHniYcfGVF4mlMJoujhzP+/4gZXPiVYIeFJIwTMF7Fp17wKAb3YpF9xlNfq9daxW7NX+H/1pa0X/tv94RlhLlDmshfahQiy8QFlAHYZ+00ANCsNmL04CUcEhKrNYo5p3LzthKSYPak9tRuPBjfgDajmkb6q6kOrYxDtxGoiDZ+UY8Chyaeu8hmi4LtMW6FaaYZesBz2IhKSBPQxhQ1kr0fI+B2jPnul0//8Y1jvm58avLk0u0sIuqsQ==
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
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

On Wed, 2024-01-31 at 13:52 -0700, Jens Axboe wrote:
> Also happy to try and run it here, if you can share it? If not I have
> some other stuff I can try as well, with netbench.
>=20

No, it is not an option... It is a small test driver app running on top
of an unpublished closed source 500,000+ lines of code applicative
framework...

but do not worry... I am pretty sure to have access to a much better
testing setup before the end of the week...

I'll report back more significative results with my test very soon...

Greetings,


