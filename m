Return-Path: <io-uring+bounces-5612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8D39FD5F4
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 17:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 560F91885EAC
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 16:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4C41F76AE;
	Fri, 27 Dec 2024 16:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="q2QmrCh0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50051885AD;
	Fri, 27 Dec 2024 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735316850; cv=none; b=oAxYJNSJm4SHnAL+7195H+kXORPSTumFPWKIU4zpavpyAhNYBEMvkBRrltH7EcpPCzxusXAreJYSuJW0zIbJ4kzyRLUdgDSvJvIEjc/JHOt4bo19KcMY4OOLxG3oRjpcEV7bktDltw5U2YSASTz1nFJPN+zzzL5Me0hzOfAYpQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735316850; c=relaxed/simple;
	bh=AbJZOdMLGW1l6VGwcuCZfCHeO+0RTAfZY/bUW8n5Vog=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=QRFT2sQzR6xa560pLmxUmxuODMhp6AUL+CPZCmJEGDp03cmwaZCnqfkdtsycDUenMRwOgUlwOUD0XWRC21Cg0H3bZFtJ4+LxTwW9kQvHGhY9ioVRTy991qdL8INpRijr3skIJHna5X2bflgDqyJs6rNwflBkApEYEWuv03863sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=q2QmrCh0; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1735316759;
	bh=AbJZOdMLGW1l6VGwcuCZfCHeO+0RTAfZY/bUW8n5Vog=;
	h=From:Mime-Version:Subject:Date:Message-Id:To;
	b=q2QmrCh0n8Z7jaO/dXdS9s5HeEZQ/ig+fjHjfN82hbjemUQZh5I/RJTqCkJj24N6N
	 q0qUMfo+agDAq/tBPpUh0s4CtPmZwKscMuhbHONbRTaWlc/NzngGvjISULH0g1uXLd
	 IxjpfkL3reHvL+nlY6mVXzAKTIeMSfycKWg46k+w=
X-QQ-mid: bizesmtpip4t1735316752taka9iu
X-QQ-Originating-IP: plj88YPIfy5SVB+iS2m+vOGLRsJzBzY3s885Vdg1C/Y=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 28 Dec 2024 00:25:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11289566790179459649
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
X-QQ-XMAILINFO: Nco2gOFShP5n4dDejblPLELuqV1xEfuuIB5U/rHcjvXXpT0a/7QgsnWA
	80BW1r2EgDd71ADhVLtvmrEQtjMpbJl3POKMaGy8itsGFhFdPOLaB+zl082DP/aJueVaBtt
	UcVlodlJvtFu6Lp2xewTqlqjkU+r7Ha+0yAG3mNRaNfp/LrygN1mqa1oSa6vylK9wir7dqU
	8QdHIy737iNuMHWOACMMbBkca549vLtsN+hS3EZCMNDozr4nqA5VcN/vKvt3NBodx8PWEU5
	A3KvDFe5qFdZgrhQIIe3slheh1k5E1cS+00YuxqKzS1KrzF9pfD6QtXH4DkR28cvzjrEe4g
	n4YwlJwqsCIYufWj5fvt8Dvo8OMx+iG2xS4oyfqDF/ynqIkZgL5pIILTD/FrwX9SMXm8uFK
	jjuebWOVA6ulgJma5nXohTaRDkTi/jy7nXOdkO4DdvFGLxc6e1bAxwJ5l/E+wqJTUHt2exo
	o5YD0TyT2hsWy3JyG64vLLoBVeizJlLkuYe6mzrE8ZAriLPjWLLEXn0M8JSM2M3cqxguAjU
	IGbDKwjP6MRxgdn4Du+elS/ikZNYI4A+Ai9JnY9hxLRZvokyv1+Bkh3M/vlJmiACp1BybdC
	46yIOCAVCpjIoO7JemSkLCIxug8h4adGGaZSS7Jor8UQdQT5u4hu+VBqYji0UmV1tX1jbAa
	7+ft12eBI+f5sntAsY7rat2tvp/y+y/ZA5v/CPFLMcT9xtrKCnk5aghty0PdTySzIwzMrTq
	P0IE8mr01mPxHFEYVrBWmWL3u3ywrM9xbyxtJux3jwN102i8Ko2iXJl7Nsakl7zN2X4Rg8/
	zGp5gcbDWOt+0HCh30oYuoICmDi3LjzdLBFXCyQ1msCNP/V+0oxgcUsMr+8oIDwOvOXxEqX
	ESuXRLXuKKB7y48QhjG0wWu/zLYIVaiuA4ymQZliVrUFZI3HskJlsA==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
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


