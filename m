Return-Path: <io-uring+bounces-9626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E34B476DD
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 21:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E65433A3B7B
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 19:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EB8286438;
	Sat,  6 Sep 2025 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fLHtMkAB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD614A8E
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757186401; cv=none; b=XmvgVQuwZo3N9kEVj1Nh0wfdQ0tprCGi5kP7FtYwOUgE7JphBc0MfbtJgAR8LRRb2Icq9l8lrLhHPObEEda1J7W8IwgYsegBaGsQhdnyaaz0Pb/YWMzWLU5nAWXxOKU8U3HIZbZFsDjk/4kFgLuxiUDBzAlSdfHi6ur1SyXzNl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757186401; c=relaxed/simple;
	bh=hYHMszme6h8QbWvH4Ei1/na8KCiKNvcEeq5inZjAvsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3agERcXpLU5WaLgFrZ8tGbz3/Hht+80iRXe0y6wDbtm74tpDkUfRepXKHt6+WD7cFrGbgIE0/9T27PoqhU5q3YEU9FxyHWPKMJPPZZAWoOMrwv6TfP9/sau1/um9MLTbsTHEvkcaTD+QG3nXUm+taPUySC+Ma8LhItQcPc4mwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fLHtMkAB; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b0472bd218bso533370366b.1
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 12:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757186397; x=1757791197; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3PsyEfWtapZbpxI5NrN12+zjKIm+vlmcngHXhUnlngY=;
        b=fLHtMkAB/QEvsP77SqdyVp+65xrGRtjR/xWP+kHl1RQFQPBcMrLV0zgwHkEILwvlGR
         a/9gyeqrFtaJex7evaT354nEhueQumPeLeYimBDvCGcATEoHR5ga5wu0fy1P6s6aQvOI
         2Wiv86hKi+0DttEn+V+Uj5wg9IctZ1HXFTrAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757186397; x=1757791197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3PsyEfWtapZbpxI5NrN12+zjKIm+vlmcngHXhUnlngY=;
        b=tbNXyImbIfYbdkcs0rQcJCaZCGQGOtTQIrNvtCP9REOpP+4vJLy9PfvPz8Djn1m/cp
         S083sRBNxnu0TGVYeOfTaOZwuBZ9rvGU9EEWzY0OUonWzaFgN5d1N1NDC/WdpLQJl8hV
         TzLs6RQJPvM3EV6iBTZ8WPxc756UHY3Q9Ik/fLv5MP4uM95hkKd/q5UIwOWvEA+vR7+e
         WQ9hD07eElhFNSfJNxReLoAwOQ9mhO6Hq9jV6UTSjT8R3cW9HcQULm/jk9dyXhQXWLnf
         LFY/Mi+/U7AsZd7qfssK3fL1eZotGHr/1w4pA/TMGoSjVKx/o6VAsUnU8fs8syF5B38y
         nykw==
X-Forwarded-Encrypted: i=1; AJvYcCWeYIkj/kL7PztcCFo8oKtug/x8aHPTO7zlX4rc7aQju62BRX6QdGmDA2+QrCrRJgRtmeIrn6FCPg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5PHFyKCyhboCrAPIRAs++da1lBKUbjyYdtUbFrhGd8RygG3tn
	+XDtQqj9Rx+ffVCD4A1GAftbOf/ie7p4UD6KafCDW3xLv6Cs/jgLUvvvqBx6yzJhWh9mXQoKu0Q
	yFsuISqI=
X-Gm-Gg: ASbGnctKHgBM+7RM/Wow+zwdfT8/aD1MHmt5bFdeDrwl7GfPBWfkGnb5mKCgwT9YN0u
	j6NyM/mOZnHLsmboEkpIxtlFOa/P8TLWrY6cJovSfixmfvD6qH+n5041DkOXm+mE0id+rQV1+cI
	SJYT3HnNjsqeydCjtePByR/sn1G7JUHBYFR0GEyEnP5p+wyxOujsMRb7JEomHumRE9JtSwZuBN7
	5dn3kc4ztEAjX0tJ2uBJW84lj8iRcGn2ghdWwcmHOITeFfmtGk7PE5vBS5p9U49vBJ1jmqC1wFs
	OmDMknL+gqBhpYhlhLF7gmzi/436PLydY/9+RbQDOdjgLj/aVNV1g6Dbaivlc1opozeO8wpkAVQ
	hRdS2AztOnC0TCui4JC7WqKWxu9Vvt/c3Zw7kt4f0X2dTwqy2Ljz4PiQ610Cveg0Wl1/f0rjVme
	TjWFrvXKc=
X-Google-Smtp-Source: AGHT+IFxjkhn2hHwhfAOw9HhEmRLFUCQVVCHjfGT0i37s6pFuVGWb30Kb88mKGOJlP1n6TXW4WKRHg==
X-Received: by 2002:a17:907:2d8e:b0:b04:563f:e120 with SMTP id a640c23a62f3a-b04b16d641emr249244266b.53.1757186397247;
        Sat, 06 Sep 2025 12:19:57 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04abb99e78sm267794666b.76.2025.09.06.12.19.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 12:19:56 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b0428b537e5so538484366b.3
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 12:19:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVd6/QwfXWsz5xBQBs79kr7O14qkkPT6aIGuVEHZab7hZEft2z5A6U+V2Y2jTRBiA7ucdl+vB92AA==@vger.kernel.org
X-Received: by 2002:a17:907:1c10:b0:b04:1a80:35b9 with SMTP id
 a640c23a62f3a-b04b13cd575mr276185666b.12.1757186395623; Sat, 06 Sep 2025
 12:19:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur> <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <2025090614-busily-upright-444d@gregkh>
 <20250906-almond-tench-of-aurora-3431ee@lemur> <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
 <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
In-Reply-To: <20250906-macho-reindeer-of-certainty-ff2cbb@lemur>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Sep 2025 12:19:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjVOhd6xt0TiSakQx9jKBBveQr8GZiqF6Y6M9Ti1suw-w@mail.gmail.com>
X-Gm-Features: AS18NWCb9_SlpOIYL1sw9Hdpl73ZkQWu1tJwuck0jHTJiMgA7QLGMXslNk_Anb4
Message-ID: <CAHk-=wjVOhd6xt0TiSakQx9jKBBveQr8GZiqF6Y6M9Ti1suw-w@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 6 Sept 2025 at 11:50, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> The primary consumer of this are the CI systems, though, like those that plug
> into patchwork

Yes, for a CI, it makes sense to try to have a fixed base, if such a
base exists.

But for that case, when a base exists and is published, why aren't
those people and tools *actually* using git then? That gets rid of all
the strangeness - and inefficiency - of trying to recreate it from
emails.

So I'd rather encourage people to have git branches that they expose,
if CI is the main use case.

For an example of how to do this right, look at what Al does. Recent
patch series posted at

   https://lore.kernel.org/all/20250906090738.GA31600@ZenIV/

is a good example, and notice Al saying:

  Branches are in
  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.path and
  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.f_path resp.;
  individual patches in followups.

in the cover letter.

In other words: if the series was exported from a git tree and you
have a base to use, why would it *EVER* be sane to then use 'b4
shazam' to get it?

So I think what 'b4 shazam' _should_ be looking at is when Greg says
"I like this a lot".

I think it should aim for supporting maintainers that apply patch
series as part of their workflow, not at CI tools that have the WRONG
workflow.

And yes, maybe fixing the CI tool workflow then involves having people
who post patch series post the git branch too.

I often find the git branches nicer for walking through some patch
series anyway. But it goes both ways: for short series, since I'm in
the MUA, just walking through five or six patches and replying to them
is simpler, for longer series that do more involved things, I find
doing a "git fetch" and then using git tooling to look at particular
_parts_ of the series can be a lot more powerful.

In fact, for long series that get reposted, just to not mess up my
mailbox I would generally prefer to just see the git branch over some
50-email patch bomb.

Maybe *that* would be a good addition for 'b4', where you can reply to
just the cover letter and say "Ack for this series" or explicitly
reply to particular patches - that might not even have been posted -
by mentioning their commit IDs.

That's my workflow much of the time, see for example

   https://lore.kernel.org/all/CAHk-=wgZEkSNKFe_=W=OcoMTQiwq8j017mh+TUR4AV9GiMPQLA@mail.gmail.com/

where I basically went through the series, and then replied to
individual patches.

I do like the "reply to individual patches" - even when I might
actually have looked at them in git - just because then I can quote
the part I reacted to. So I do think posting the patches makes sense
as long as it's not some excessive patch-bomb, but at the same time I
do know that a lot of patch series end up being of the type where
possibly dozens of people get cc'd, but only on the one or two patches
that are relevant to them.

And then the git workflow *really* shines, because it gets you that
context (and lots of people object to getting tens or hundreds of
patches in email when only one or two are relevant to them).

              Linus

