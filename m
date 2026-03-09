Return-Path: <io-uring+bounces-12599-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHmCL9P3rmnZKgIAu9opvQ
	(envelope-from <io-uring+bounces-12599-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 17:39:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F6E23CDF9
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 17:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB1EE30FF98F
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 16:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FCED3E8C69;
	Mon,  9 Mar 2026 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="afhafXXs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D423E8C58
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073765; cv=none; b=bNcx5gfenzrDrUUXMWEVOlbS5pVx9bpR1PJ1mSoaNwd40Ji8Ht6Sg63yvGPPwemvmR9InQPPiBvOqL2DbfBmwZNonkN7dB7ktQIMs8YTK73nlIQlHBRiTdd3GbpE5YWl/txkOy3PiMTvpl7Oh9FHaaPaFrz3n9fyiUHTIVyHisY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073765; c=relaxed/simple;
	bh=UzNWTyd3SfcrfOQYE9PSx3JhKAI8b4XbeA/73gkXD0g=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=YgRhkQbMD24jMv5JyknHlqhbk8LqWUFyvxcOanhpT2p7P/Vc6WBfY3iUROTS+OsgQq5t51Y9fyfV1QnIKUn6KvUamcqONCnUSshT5uoVaSmuLbQSHwTLmWDVn16Z3dPdHz3arXIbHyI/o5l0OtB1Mv96rR0zn/WAEkknighMcA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=afhafXXs; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12776bebe9fso5417797c88.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 09:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773073762; x=1773678562; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vUO4Zji7vHPsyKdLX1pAkmn2sfTGcz9pCB1/6/pG8iA=;
        b=afhafXXscLyUuPmfBoF6UYtHkGCA4YE5Ygv/uiJZjnqOU/3n170qMHcp/D8qEghc5U
         Vjn1IPS2rqCN8MaU+gBDCkNYsvzf+Ua6vf9mRYcGasDcQYFfZLZqWNwUm2GbkhF5Yd1l
         nkbvmnHW5HVFx6mVdrYXQN2g0vSDj63u2VcloewOhkSbwXZifMoGLsrZsA/RzcRcXyfK
         +LReS280jFbREykmKNjPk6tLqfnEcgEBNcoZ2RtYSaDLLB0i/qO8yjdk6NFM9jetMYBP
         6wZenlfgdozzKSjkiHql1tQOAei/sOeRohghJbW1fsTQEvfuCfAZIrCP6x1mDAl1pdnG
         PyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073762; x=1773678562;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vUO4Zji7vHPsyKdLX1pAkmn2sfTGcz9pCB1/6/pG8iA=;
        b=rw7FfyIwbNQnVOQtBu8qQLJDmaPH3WkoRO9FUmGxMo81PmxmwzE8g3JsBmx1XziZH0
         gaQlAO5aqtl78hVvIeAVnCcdUrVIMoJJhwV+RiNOdRXNQNWLVZNWZlLv8cWS3qDPHlkt
         0pdxRo+2bSLwANBbDYYbX0U3x4U9UUTa5Au3AlxBY3aKQY2uhp87DqN9ecs1K8gm/8Zg
         eNFkq1MVa0Lcp9V9xAkmFXrG2GY/J8arWNxPlHAr+KWxASJqy+lHOKbKW5uWE+m7KErY
         6Y7EoIa2pkkkumy0Dasfj+VGPnQgL4mbZvyALYSHStbhl3jRqcuhZtvUaq66dK5JihhS
         3nGg==
X-Forwarded-Encrypted: i=1; AJvYcCXT1ON5k9rjBlerzJXpdH/HqM3p85svnWVTsemToMc8FauQoiz9uQc1+k8J+9Hsdm8lPfTnF3EAlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYqgqEZkb6om41sxW03kqrBSxZ9jgZ0MqdlqTlQLROChqRg40U
	6QRQO6nu0K4S8feFnAZrBIy/pSOuKh0t28jubR/RksJwli4CKcgs9Mms4kspvLOc3N4=
X-Gm-Gg: ATEYQzyNxFGSBfmIugw8/5G2eqSZt6Eg2U8p920qfLyQqqZgb/dClU8k/3qpxkWRmvw
	wLRvJOAB+miO6z8iKDjkFtggUr2Ax4yqLtsUt/0U/3grtr/y8BaSO/c79VC4KJ01EQwNt4y91OM
	FL+67is6Pc20ZagU2NeoiGvN3rHQMw3cRvlIigPcX4S07wXavK02WOVBWGstoa6UD5DtLkBtqRq
	CdwabuazgZ5qExqSY/buaiWhBG79jBOGFEdGZoUdwbA2t3nBMPvxDKQwy1XxKeZK0JKeCg9qqd8
	MW8U+asJG+DNTaIC2+e7RmydY6xim3VBOmov/wCx3dkE1zqYX+danPEA8sD0N3gnOD9KqviGKdI
	fFAMO5WxGBPpWWuDBF9Udr5qW/JJBSp96eCS08euR1gvTkunQLhjYDSN2MBpdH8qEv16mfUy5lT
	P/DswO+kDuOf6TJ8Bz4Sa0q06oiv3/IFX3XcokFxCVGOLGu8aeFrc2L/GXdqBonvWBYZ5r6U6vT
	mXUil+fNFJsP9qKx9ffW2w+4bR/bO4cHSJU9E11l1lShUM=
X-Received: by 2002:a05:7022:e1e:b0:128:d455:8501 with SMTP id a92af1059eb24-128d4558a50mr2367107c88.37.1773073762275;
        Mon, 09 Mar 2026 09:29:22 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:746e:1a72:40e9:6056:eb6b:53f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128db3d79fbsm2178258c88.4.2026.03.09.09.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 09:29:21 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in io_register_resize_rings
Date: Mon, 9 Mar 2026 10:29:10 -0600
Message-Id: <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
X-Mailer: iPhone Mail (23D8133)
X-Rspamd-Queue-Id: 20F6E23CDF9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12599-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	APPLE_IOS_MAILER_COMMON(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.981];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Mar 9, 2026, at 10:05=E2=80=AFAM, Linus Torvalds <torvalds@linuxfoundatio=
n.org> wrote:
>=20
> =EF=BB=BFOn Mon, 9 Mar 2026 at 06:11, Jens Axboe <axboe@kernel.dk> wrote:
>>=20
>> You probably want something ala:
>>=20
>> mutex_lock(&ctx->mmap_lock);
>> spin_lock(&ctx->completion_lock();
>> + local_irq_disable();
>=20
> How could that ever work?
>=20
> Irqs will happily continue on other CPUs, so disabling interrupts is
> complete nonsense as far as I can tell - whether done with
> spin_lock_irq() *or* with local_irq_disable()/.
>=20
> So basically, touching ctx->rings from irq context in this section is
> simply not an option - or the rings pointer just needs to be updated
> atomically so that it doesn't matter.
>=20
> I assume this was tested in qemu on a single-core setup, so that
> fundamental mistake was hidden by an irrelevant configuration.
>=20
> Where is the actual oops - for some inexplicable reason that had been
> edited out, and it only had the call trace leading up toit? Based on
> the incomplete information and the faulting address of 0x24, I'm
> *guessing* that it is
>=20
>        if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>                atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>=20
> in io_req_normal_work_add(), but that may be complete garbage.
>=20
> So the actual fix may be to just make damn sure that
> IORING_SETUP_TASKRUN_FLAG is *not* set when the rings are resized.
>=20
> But for all I know, (a) I may be looking at entirely the wrong place
> and (b) there might be millions of other places that want to access
> ctx->rings, so the above may be the rantings of a crazy old man.

Nah you=E2=80=99re totally right. I=E2=80=99m operating in few hours of slee=
p and on a plane. I=E2=80=99ll take a closer look later. The flag mask prote=
cting it is a good idea, another one could be just a specific irq safe resiz=
e lock would be better here.

Jens

