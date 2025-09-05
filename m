Return-Path: <io-uring+bounces-9599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22173B461AF
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 20:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0EAD174814
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 18:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619202F1FF3;
	Fri,  5 Sep 2025 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abYHo5l4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBE71DED4C
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095585; cv=none; b=U3MNFiANs+2916ZcGMRyoZsrSZpHDpSnBVHt3I0GmympEXbI1UiCq7ZoOHZVpYw3RdfM4k4qaodT2Y+NEGTqKmltG/Ct/s8mqaEOrgmXaaOS8NtCd+3M6lgIFSzDR51Ll6enLhY/taRFgpFb2cGGlcnxem/qEBp36x6lkW+4Gkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095585; c=relaxed/simple;
	bh=OEQWGZfgcWhUNnHjg1X8TOQvGJRch28d4HeV5zhsTTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NAbA8nfKR/FHJRAzqWElnLeqOV2xYm/A5xBDk8Gw6g3SA6aj4H2BPsrUvCSbcs4VO65L7d8+aVai2MuqDbne6f80CMcNKk1W89KfqWV48gKSNm5Yd0ju+IjnZwqRaeCOoLmu3NfEDBJs0bSAvvRL5Q3Diwoc78HHu9/G75SVi+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abYHo5l4; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6188b5b113eso3983107a12.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757095579; x=1757700379; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm3iXCah8M4VwRYBc/IsYVCDyU/KPnZRsRw6XBJaJJM=;
        b=abYHo5l40mHWNc0D+QkU5PUaW1TpcVYrgdo12F3mP56g+wQs0wCKr1p/7rVzFIcLDc
         htqGPdA8NQSAM9kF69uCy+UOxiHfsjvX/gDKz7SvbPa9DOj8qKrNyCeDEvmEk5DOxt4Z
         4GFpnxeJCPgdFesm3KouXbXX6sUPRWJinvX5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757095579; x=1757700379;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dm3iXCah8M4VwRYBc/IsYVCDyU/KPnZRsRw6XBJaJJM=;
        b=OQ0In1hYyt9JcL9QIK9Lg6FFNpvxowGUo71Co9eIEZl9Cimw0erD4CMyaNQyV/OR2/
         q/dbIs76DP48PQVYDGOAAbTRgW814dk9d51anQOXDGk03vBDqZ7DGtmFlQ3aRg9YSzYM
         RTDcP86s56J/yqmhjww/CDxFBrcqd8OjY95rw4CUDIk+URqtjmBCiIlprSgew5lFXPOx
         16kILc3GyDoXif1a1xc663f1/aJ/bmE83F5KhxLEilatAXp6UgOfQKLymBLlSUGyJaUB
         NN7mJ+hSP2va7C7xEjxbCvy7RPqSDEl9s9vZRv6E3uQ5mLhYtlAKBRmDF11CFXYciWZ3
         h5Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVbhCq4m5nIkdc5tyA95GLRsnSPLrM7nQSXAjDe/33rWsNSgqMt0c+k6HTsebS1KrWGS7vZ6TBV/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzznGmOPVYDw3frN5WZ3SjWy+URVGanp0/AoYqaQHr1xirNPtQw
	fV5iUOHXeGvh7svKQiLRvcMgGtpGLu7sInDwc5/8pVJPbAFloynEN7mn8CwofBtpDSE2Swgz+ta
	YuPYx7nM=
X-Gm-Gg: ASbGncsgRasdvR8JMFcd1bZGfd86eCi8zeI59frsIiETXFsJZvUbByeEhBQK6CMrv2c
	VqtZ8GE1ehVwdbFUFT7r24T8EmQ+kwHv4YGjFm2eUur8TJhlTrMAVIkjZnvk+Y4zQUUR2zvErjp
	3QC4/60ly2UCUo2BDz1cSFhbu6dHCAL+MJSNH1/QFNAi1t9X59BGbUoRE/laavECFzMFd0EoYHk
	If6G3InXyasUGjdiT2cDOOIGdxY1Z1VHK6xcON+vfK/lZ78QTT8O+BAvev8Ws7QpZtD5hai5hmz
	JeZ4M2dKj50obtY3ZLHyMRaLS5/mCUmKlGtBW5YbeZ7igJA7xBpRCsE+pFGdLB5VWXudXVzpwAW
	TY2r0MnxB/n4Nrp6QdEF+JYOGVxAekpuQRxqCwVP2MsGR4WkmhmQ9Fxmd3Pz/RxOcOOT2pghW
X-Google-Smtp-Source: AGHT+IEXWnU+tbblwBEmaOb0RQJ5vZ5tbSkrMzWuAypK5smCeovjp4B5+lqKDXFMUzcBzgBhEN0vCA==
X-Received: by 2002:a17:906:6a27:b0:b04:302c:fe14 with SMTP id a640c23a62f3a-b04302d0545mr1665893066b.21.1757095578673;
        Fri, 05 Sep 2025 11:06:18 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62069b79e1asm3514011a12.26.2025.09.05.11.06.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 11:06:18 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-622fbed96dfso572691a12.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 11:06:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtaRcIZC2xf6mtv3DQAiXEWtKjMBTaKuhng7H4zAG2JsU9s2yLNFDiPFVAppLELU/aOhNiiNwFJw==@vger.kernel.org
X-Received: by 2002:a17:907:d92:b0:b04:8435:fbe1 with SMTP id
 a640c23a62f3a-b048435fe62mr710277266b.5.1757095577504; Fri, 05 Sep 2025
 11:06:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com> <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
In-Reply-To: <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 11:06:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
X-Gm-Features: Ac12FXzmZ3xH0kS5gGF0ADZ6CaR58SY8jojpTrJcz99Wla0kP5z_gJbTB6VjxgI
Message-ID: <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> Do you just want this to become a no-op, or will it be better if it's used
> only with the patch.msgid.link domain namespace to clearly indicate that it's
> just a provenance link?

So I wish it at least had some way to discourage the normal mindless
use - and in a perfect world that there was some more useful model for
adding links automatically.

For example, I feel like for the cover letter of a multi-commit
series, the link to the patch series submission is potentially more
useful - and likely much less annoying - because it would go into the
merge message, not individual commits.

Because if somebody is actively looking at a merge message, they are
probably looking for some bigger picture background - or there's some
merge conflict - and at that point I expect that the initial
submission might be more relevant.

Of course, most people don't necessarily *use* the cover letter for a
merge, and only apply the patches as a series, so it's also less
annoying for the simple reason that it probably wouldn't exist in the
git history at all ;)

Anyway, the "discourage mindless use" might be as simple as a big
warning message that the link may be just adding annoying overhead.

In contrast, a "perfect" model might be to actually have some kind of
automation of "unless there was actual discussion about it".

But I feel such a model might be much too complicated, unless somebody
*wants* to explore using AI because their job description says "Look
for actual useful AI uses". In today's tech world, I assume such job
descriptions do exist. Sigh.

For example, since 'b4' ends up looking through the downstream thread
of a patch anyway in order to add acked-by lines etc, I do think that
in theory there could be some "there was lively discussion about this
particular patch, so a link is actually worth it" heuristic.

In theory.

And honestly, even if the discussion ends up being worthless, I do
suspect I would be a lot *less* annoyed by a link that at least leads
to some _thread_ (and not just the acked-by emails that already got
gathered up), rather than just leading to an email that was applied
and nobody really had any input on.

At least at that point I'd feel like there's something real there.

And yes, as always, I realize that people think that patch submissions
will get more email replies at some hypothetical _later_ date.  But in
practice, that seldom happens, because the downstream testing issues
typically create new threads, not replies to original emails (and if
they *do* react to the original email, we already can look up the
commit easily, and the lookup goes the other way anyway).

           Linus

