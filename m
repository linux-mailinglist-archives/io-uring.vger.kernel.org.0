Return-Path: <io-uring+bounces-13794-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4fe3EGZpNWqRvgYAu9opvQ
	(envelope-from <io-uring+bounces-13794-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 18:08:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B879C6A6F14
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 18:08:05 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=iFvfCnfV;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13794-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13794-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=krisman.be;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 77AFC3026FA7
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 16:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0293B960F;
	Fri, 19 Jun 2026 16:07:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B403BB682;
	Fri, 19 Jun 2026 16:07:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781885262; cv=none; b=RPpZXFEG/sunr1v+mYhx5CjAE7wC39LZDaAjcARLbrqkl5gGG2Wvq8utdekver/ZwfWVftGvDjsiInSXteIGyyRp/XXwu8FELHMuo8Oo9i9J7LCOY63K4VSxySG3WT1oaXEAReF1jfYJkODR4Xowi7nn9TAPMVLupD9RRliZhuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781885262; c=relaxed/simple;
	bh=fE67BqjDyTheSgqd4EZb5JKPlSAJ3XTJgI08s/KrHZQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c4Z6EFFpnyJJ6J/QDz9coebSmg0duKO5ijkIcP5gfEwgIo+7ZYAq5xF7z+FZLkaLtGC9QWQYzL3B9t7W0qaLvac020kloSK4b7Hmo4iPd1fcBGsGi/4lDb0u25/Pis7HmuLIpEGPt6ewRg4ZzYyQcDWBrmq/pMEIbCuIXOlIaEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=krisman.be; spf=pass smtp.mailfrom=krisman.be; dkim=pass (2048-bit key) header.d=krisman.be header.i=@krisman.be header.b=iFvfCnfV; arc=none smtp.client-ip=80.241.56.172
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4ghjD66TF5z9tll;
	Fri, 19 Jun 2026 18:07:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=MBO0001;
	t=1781885255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yD4xHJw2ixlS54/w1wwmeUxIlbpa8OqFoDWj8fXiZY=;
	b=iFvfCnfVzZyPln9esVpNbq5l7C+0oARS3Lvf8iWOzCduA+XDjoAKv6ubs39TTbv1XNUnJC
	vHwsFy4eAjJ7eGfDeRKeiO6JaMG4xrOh2G2of6GTUYk8fUJkRlZVQX1Rswgrl4Q/2ykqGy
	PSZTCPoJoNmjUJ/LNV396/zodn3QLAt1mPm2YKUuFBnDam9UMeQdrGRKC1D6vd8is+VShg
	YhlSZOeLAR6hoVtWoJlzih55kcGxg5Gbxim6z+gZnvSKesO+vpZ8CyPNSvGgJ11M70ZBTk
	4SREkuweUa1dE2Rc12DhDsBjwDQCnpsJukUt/BNQZrmQs1hKbppzDXTxpWxQQw==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Cyber_black <Cyberblackk@proton.me>, "io-uring@vger.kernel.org"
 <io-uring@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "axboe@kernel.dk" <axboe@kernel.dk>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>, "gregkh@linuxfoundation.org"
 <gregkh@linuxfoundation.org>
Subject: Re: [BUG] io_uring: possible CQE32 overflow flush inconsistency in
 __io_cqring_overflow_flush()
In-Reply-To: <6oAi5ghNgkCrElyHzHJrE8l3g7Dg7Uc9PpeZmbGD93Xic5x5MI54B1pehHhjiGrb5VB0icQvFaemtH-Pvb8bJkivv6qxD_NZUEvwyFkk62k=@proton.me>
References: <6oAi5ghNgkCrElyHzHJrE8l3g7Dg7Uc9PpeZmbGD93Xic5x5MI54B1pehHhjiGrb5VB0icQvFaemtH-Pvb8bJkivv6qxD_NZUEvwyFkk62k=@proton.me>
Date: Fri, 19 Jun 2026 12:07:30 -0400
Message-ID: <87ik7eqzst.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[krisman.be,none];
	R_DKIM_ALLOW(-0.20)[krisman.be:s=MBO0001];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:Cyberblackk@proton.me,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,s:lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[gabriel@krisman.be,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13794-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gabriel@krisman.be,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[krisman.be:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,proton.me:email,linuxfoundation.org:email,mailhost.krisman.be:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B879C6A6F14

Cyber_black <Cyberblackk@proton.me> writes:

> On Fri, Jun 19, 2026 at 04:49:32AM +0000, Greg KH wrote:> Please turn thi=
s into a real patch that you have gregkh@linuxfoundation.org to verify it
>> resolves the issue so you get full credit for the fix.
>
> Hi Greg,
>
> Apologies for the previous mail's format. The patch compiles cleanly
> on arm64. My current environment does not support io_uring (ENOSYS)
> so I was unable to run the liburing suite, but the fix itself is
> straightforward.

What's the context, was this sent against stable?  The issue exists
in mainline.

> From 522b70bdd3ac64c64dd21842cb5901e59a1fb058 Mon Sep 17 00:00:00 2001
> From: Eneshan Erdogan Karaca <cyberblackk@proton.me>
> Date: Fri, 19 Jun 2026 07:59:58 +0000
> Subject: [PATCH] io_uring: fix cqe_size/is_cqe32 inconsistency in overflow
> =C2=A0flush

Ideally, send it as a patch to the list with [PATCH] so it doesn't vanish u=
nder a [BUG]
tag.
>
> When IORING_SETUP_CQE32 is set, Block A doubles cqe_size to handle
> 32-byte CQEs. Block B then resets is_cqe32 to false so that
> io_get_cqe_overflow() uses its own ctx flag check internally, but
> fails to reset cqe_size. This leaves cqe_size=3D32 while a 16-byte
> slot is allocated, causing memcpy() to write beyond the allocated
> CQE slot.

How was this found?  Do you have a syzbot or a trigger?  The fix looks
good but the patch appears corrupted, with a bunch of NBSP.

>
> Fix this by also resetting cqe_size when is_cqe32 is cleared.
>
> Signed-off-by: Eneshan Erdogan Karaca <cyberblackk@proton.me>
> ---
> =C2=A0io_uring/io_uring.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1ea2fca34a36..f9690291633a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -543,8 +543,10 @@ static void __io_cqring_overflow_flush(struct io_rin=
g_ctx *ctx, bool dying)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 is_cqe32 =3D true;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cqe_size <<=3D 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ctx->flags & IORIN=
G_SETUP_CQE32)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ctx->flags & IORIN=
G_SETUP_CQE32) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 is_cqe32 =3D false;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 cqe_size =3D sizeof(struct io_uring_cqe);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dying) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!io_get_cqe_overflow(ctx, &cqe, true, is_cqe32))
> --
> 2.34.1
>
> Thanks,
> Eneshan Erdogan Karaca

--=20
Gabriel Krisman Bertazi

