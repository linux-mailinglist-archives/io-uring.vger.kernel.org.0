Return-Path: <io-uring+bounces-5609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C11E9FCDB3
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 21:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8988161855
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 20:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7C585260;
	Thu, 26 Dec 2024 20:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="ICu9SZbp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3C323D;
	Thu, 26 Dec 2024 20:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735246070; cv=none; b=rJVkba9t9GiNLxWYUxLjstkBPCLsRocHMtY5jOb/9gAhyDgmlcB0dOI9xzecrC26R0Ry6eIEvZbREcrAamgbt4hmLA89csYmoVwGXL2IAQwIa6c7VlJ8IGCMT80+pHnd1CztcfuFkUot/bKKicXPnvjvXGLiHFlTioQ0hL13J2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735246070; c=relaxed/simple;
	bh=AbJZOdMLGW1l6VGwcuCZfCHeO+0RTAfZY/bUW8n5Vog=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=bdMujTUrZstbOckp2Dx6NA8RLkE/uQrPuaWIt2MGgtdceQgumBF3u+VIhKVixeJpRcEF064aCVWooMZbykydoY2LksaUxLS7HptveCtVXtY8gF+7L6MmQrp6778sEkGmcwt0so5M51zm77gI4algatpe4hhqakH7z5qv27JhSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=ICu9SZbp; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1735245933;
	bh=AbJZOdMLGW1l6VGwcuCZfCHeO+0RTAfZY/bUW8n5Vog=;
	h=From:Mime-Version:Subject:Date:Message-Id:To;
	b=ICu9SZbpz4UsvQUBrnlMC4IwEL9nimivtaa34cSK2BNSucRad6fCzRAuP8c9/PwkP
	 WLqbwCK6oYwBOV1KxrVfbm2CrvNYekXdRSeuJIMpH3KLwZvI5yP42NnOcl9khHrOvP
	 SEzyAeh0aiyEVMrPIA0nvjFR1/iSgEz2qyKmrgl4=
X-QQ-mid: bizesmtpip4t1735245926t8akn96
X-QQ-Originating-IP: /BmEPIias2EYHT9LZz29w3KOG2VCLhGuoeAvc52zyz8=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 27 Dec 2024 04:45:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11289566792857868994
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Fudam <huk23@m.fudan.edu.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
Date: Fri, 27 Dec 2024 04:45:14 +0800
Message-Id: <DA2747F7-5D2A-4515-9764-B214AAD1DB37@m.fudan.edu.cn>
References: <d4d4da73-5d00-4476-9fd2-bee4e64b1304@gmail.com>
Cc: Waiman Long <llong@redhat.com>, axboe@kernel.dk, peterz@infradead.org,
 mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
 linux-kernel@vger.kernel.org, jjtan24@m.fudan.edu.cn,
 io-uring@vger.kernel.org
In-Reply-To: <d4d4da73-5d00-4476-9fd2-bee4e64b1304@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: iPhone Mail (22C152)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: Me+wKRRrSrO/Z7hxBQ9Lo6qeWxLuM1s7sV44osJnr3j4yZSvKPY2VTad
	97YrMKzKS7bPx8q5GtyAkcobkz9osWA0mImvMQVexyu2aHJGqd4yH7A1gaYLKGMdrEZk7/w
	/8IjVc9lEGEwk51SRQgvACYOL56i2L8KjjtHf72Fn3BHWI6QaAybcIMdG/gfsXvLIKw0w7f
	+ClrTepLy5MZn956C3Myk2HwK8r7SIHEfGJw/Rxp6x3SG6mSB1fCBtxTdglYRvIAQFEOVXt
	HJ3BvY8wojiU1vQHko5Ek2q8j6lp2y4UTFhv9fhtWFR5IEubMCvzrC8Y+NMlWl9pVxTf2ce
	xpzeQ8cEZiDWAkN9h62r40AeahioUvfuopbkuIwcSjF/+F65vQJTju6RFcrzAWdx35p3bc/
	EZBWFI7imFf6kVYCVXXwhn44wCAx6jae/12iioGFbCmMcM7aauGOF6la1VwpphEjyNO3TTG
	jSIN2dA0z4JCMhnMtuZLZTO2G/y6CIK0eDXc9ZCuST7wK5tFuULjBLtZNAd7T0a8OMB/0b/
	szuB+3uUcJArV2VvejJz+9O8O0GFhZg6YS5SpIPK35IrJOXa31vHyJ1i/gpHDn/Alc2fDSQ
	ME2ijyg/ZZX0m5PSzPT+FZTuUlur/9Fdk/WNMOQsiREaqCYYJNusyhmH8alMZyDST/f3zBE
	h9mGEc2hRbu6F1LYyIPwyG/fbMOzhlo9G+jm3PtgCbjeW6waufrzpnSUJ5pW0+zSK4nov+V
	+VI7rxAXe5hHSemtv+sUvo4GY9hZqk61O+/Eiyv5hokp1zUrM7K1pn2eucvGuQjHyXW16md
	acNBhqsZcGuSPothWVLPzTOi5buHxuhZ8u3M8VzG3Lce9ZPv3IhT5XFPm0GmLvgtpMeWhTz
	kej57PjYAsoTgqRl33EJWPnuvkpqhRmiVwg4spOBX7s=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

> Kun Hu, can you try out the patch I sent? It should likely be
> it, but I couldn't reproduce without hand tailoring the kernel
> code with sleeping and such.


Okay, I=E2=80=99ll try again. Please wait for me for a moment. But you mean y=
ou couldn=E2=80=99t reproduce using the c program I provided unless you tail=
or the kernel code?

> =E5=9C=A8 2024=E5=B9=B412=E6=9C=8827=E6=97=A5=EF=BC=8C00:56=EF=BC=8CPavel B=
egunkov <asml.silence@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> =EF=BB=BFOn 12/26/24 03:43, Kun Hu wrote:
>>> This is not caused by a locking bug. The freed structure is a task_struc=
t which is passed by io_sq_thread() to try_to_wake_up(). So the culprit is p=
robably in the io_uring code. cc'ing the io_uring developers for further rev=
iew.
>> Thanks. This also seems to involve sqpoll.c and io_uring.c. I'm sending a=
n email to both Pavel Begunkov and Jens Axboe, with a cc to io_uring.
>=20
> Kun Hu, can you try out the patch I sent? It should likely be
> it, but I couldn't reproduce without hand tailoring the kernel
> code with sleeping and such.
>=20
> --
> Pavel Begunkov
>=20
>=20


