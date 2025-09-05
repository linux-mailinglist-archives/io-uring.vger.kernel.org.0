Return-Path: <io-uring+bounces-9602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F21B4634D
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 385AFAA0D74
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B71E1B0437;
	Fri,  5 Sep 2025 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IeAv/sL4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737AC315D2E
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757099643; cv=none; b=kPVtn/8/YFP3RL/pH8VIQWAFSCmBw3oqw4GC8Bmhg4UZbAzd57/hmay9TDkN5wMiRNRpM2p6bML8nVCJhIap6T6izpuJNoyViZgbnYraB7l3Fn2M+sZl+G2nj55BwNQNCjrDTVHJZfmAVFHNbCX/ERavOfFCaMp5GeVmhI++KjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757099643; c=relaxed/simple;
	bh=ogRuMQFeAGOymg8wQrX8REfn0ikj+Fj0MUpDTeWOh+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kk4DgIzjdHXiEccje0qsiY8jiHupUXTen23tG6CEcFx8H3aKRGYOa5YAt+ZvGxf//QCGXmlVP9MpcZcmyy0zsXvS4g6Hl9cCzR+Gat+KfnfTOUIryLdDKtjVS/TEVR5gfl+gaN5hjJDgO7fvhzQ7EYVKzEYjxdDNPijtqu9VZEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IeAv/sL4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-772759a7dfbso231647b3a.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757099641; x=1757704441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fX9Q1Z82rqELs3VftvCK7vHHBqL7+0LiZF2iKflj/qU=;
        b=IeAv/sL4+FEvDjvCgGqbdUbGM4UNWBUwK5BfhHt7Pl58cBSSvhPC2LVvWc4S0SpDKn
         uF+qxsPSBKmJV/mowvc8H3XA6Ukw07//CM71ss65JfvFDviK/gYoupXJ+UVaMRyHCIWt
         nVnQ7Z5xYzODRIlp2HQuss8iwi7Y+d6pK3V+8j1Mponl3K1qbpZDyyzYGXZxEcja+RNW
         mC3E0QCUCnAP2Pc3QxV/Q1pstVlKSwM/SmsXFMc8rwZunwkjaCSCD+dOTwNYvSKsgB1D
         N/cLS4pdwSXtrZda3WqftIYgoDgSogAggItqGBUieEYNmTn+fOn5Bs7b3SYugTaR8FOc
         s5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099641; x=1757704441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fX9Q1Z82rqELs3VftvCK7vHHBqL7+0LiZF2iKflj/qU=;
        b=ioBGn+mpX+qzjT8kSaRjEVVzBPyZzbyDB7D9DLupEmwQRWEjg77RUn70ktEM7NdTB7
         RyODvp1xViGUE1LrJUTXLSf1/EP26H8dHHA9k7bWdNAN6cCyiXNmpe9JCkrTmN5sqwRk
         BmQfWT1AgHUZQh7G/+c6nthh+8Esx0avNbUxdyb0IV1C8dUgzZrKW5pgS4x7HKLfN2G0
         jeXHbH1571Rk4iSsaHzOwG/8e8KiZvlJfIM0H9/uGAWl8xJNxa49ai12eZZRQNolcvSn
         QJmXURHhdRyqPwQJoYhM4EzJJ9EhFoZ+EJPiL58fzcQEhQJFaN0nFDwqKgplv16ah0ur
         k4dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHIJYbD1nEYSUa4IYDdAM4QIy5teBkyc38/5zGJDLmh0ktAPWL3X9xWlj4KJ7CtKxcmAPgoLAyOw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxpWrkRBDaeSLLsL+H0gA1ZwMOd0kIlsh77nZAOIcoYa7TSu6Nh
	Tbx3U1ittorH71Yn2cU9S1xHj/2FtfhEqpVQt+CfJXfUUke/Vnf1OHImrhs6O1Zl8NJJvL+/kFr
	5xEyoPuTxvJLIDIkaNxo+SQgI3atCrYjDZcbSk9V1Sw==
X-Gm-Gg: ASbGncshv8NQyNrg+Bm/0wwGDk3MCUCzp9gSbS6vDSecs7ZSjIVmZ5joHC8Vh3+ObPq
	A3itas+x9F2oRYnF+fA7g19I7luhuzPds0wG3LKDBb+pWSQmAWrk7oi1PWN5ShzeaTilHBqBOJM
	EcRIC4hXuGmFJmfKGyzkmVfW+vkheFUaVDyraA8QYo7lMNxnHCaKCQIyoLO6oGNlJAel/m3jxqg
	AQs5XtF3NBe9N+k2ufBzC0=
X-Google-Smtp-Source: AGHT+IEE8PufdF6KPU2wS1JXaMJ8NvTMJ0aXU61DIrasRN8b4fzlkUHR1cqvp0DPHwSxoz0q3HbmuL/CFtGR2b9loy8=
X-Received: by 2002:a17:90b:2250:b0:32b:aed4:aa1a with SMTP id
 98e67ed59e1d1-32baed4ade9mr3970756a91.4.1757099640579; Fri, 05 Sep 2025
 12:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com> <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
In-Reply-To: <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 5 Sep 2025 12:13:48 -0700
X-Gm-Features: Ac12FXyQVbvCNly74ch1I2GsEZiW4vUkm2Ern8Oy5ByKcadZy4GawEnB--JoHHU
Message-ID: <CADUfDZr+pvC5o-y2f1WqwyxButkTN2Lesu0Ya5qrg2nVXVF9pQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 12:04=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/5/25 11:24 AM, Linus Torvalds wrote:
> > On Fri, 5 Sept 2025 at 04:18, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Just a single fix for an issue with the resource node rewrite that
> >> happened a few releases ago. Please pull!
> >
> > I've pulled this, but the commentary is strange, and the patch makes
> > no sense to me, so I unpulled it again.
> >
> > Yes, it changes things from kvmalloc_array() to kvcalloc(). Fine.
> >
> > And yes, kvcalloc() clearly clears the resulting allocation. Also fine.
> >
> > But even in the old version, it used __GFP_ZERO.
> >
> > In fact, afaik the *ONLY* difference between kvcalloc() and
> > kvmalloc_array() array is that kvcalloc() adds the __GFP_ZERO to the
> > flags argument:
> >
> >    #define kvcalloc_node_noprof(_n,_s,_f,_node)  \
> >       kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
> >
> > so afaik, this doesn't actually fix anything at all.
>
> Agree, I think I was too hasty in queueing that up. I overlooked that we
> already had __GFP_ZERO in there. On the road this week and tending to
> these kinds of duties in between, my bad. Caleb??

Sorry, this is my fault. I misread the code, the __GFP_ZERO does
ensure the correct behavior. kvcalloc() might more clearly indicate
the intent, but there's no bug. Apologies for the hasty patch, and
agree it can be dropped.

Best,
Caleb


>
> > And dammit, this commit has that promising "Link:" argument that I
> > hoped would explain why this pointless commit exists, but AS ALWAYS
> > that link only wasted my time by pointing to the same damn information
> > that was already there.
>
> [snip long rant on Link: tags]
>
> I just always add these, because discussion might happen after the fact.
> For example, someone might run into an issue from an added patch, and
> reply to the list. That does happen.
>
> IMHO it's better to have a Link and it _potentially_ being useful than
> not to have it and then need to search around for it. Searching is MUCH
> worse than the disappointment of a Link that tells you nothing that
> isn't in the commit already, and it wastes a lot more time.
>
> And if you're applying a series of patches, then it'll take you to the
> cover letter. Which is useful. All without needing to go search on lore.
> You could argue that you could turn any applied series into a merge and
> add the cover letter there, or link it at least, but lots of things
> don't end up in a merge commit before you pull it.
>
> What is the hurt here, really, other than you being disappointed there's
> nothing extra in the link?
>
> I, and everybody else, can surely start making judgement calls on when
> to add the Link or not. But that seems error prone, and might indeed
> miss useful cases because a bug report comes in AFTER the fact.
>
> In any case, if it really bothers you that much, then just make it
> policy. Historically I suppose policy has very much been formed by Linus
> rants in replies, which then gets picked up by LWN and others and then
> it becomes part of "Linux kernel lore" of this is what Linus expects.
> But I bet you that LWN would pick up a Linus email on the topic that
> isn't a reply, which said that you've observed Link: tag being used
> frivilously and why you find that annoying. And THAT would save you a
> lot more time rather than need to rant about it multiple times.
>
> --
> Jens Axboe

