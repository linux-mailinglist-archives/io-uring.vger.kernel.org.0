Return-Path: <io-uring+bounces-9609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC3CB46465
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 22:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2B363B4860
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 20:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDA02868A9;
	Fri,  5 Sep 2025 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XiA6swW2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B6D2AF00
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757103019; cv=none; b=IlAVTgLvhK2bNWZ4Qxp2cVNk2LLvlVhvqbLWlBnYy/rqx3xgYR/kdjIsI4mZK5WF4BEVbScin4DB1SZd15i7osLMvS14r34bX6RYqAPH2XuiefKVO3KsxdZrqKkHG0/wQfm+nm4+qcvINnEcocAamoUv4XcdqI5SiA21Yy1WVZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757103019; c=relaxed/simple;
	bh=ihZ/KBvVTM2viHT4uIXRQE2vVg3YunnikfyRSjOyZD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N5Vs3wyp9I3s6H2NVsaexdBoDj54+vndZ2anpjzwfMc1seuRv38iAhNK7ACLQQxNcQc6C2PwDH7vjL6TB9e4EsN35GSe8ieAYm8Di08ulmIrStJUs46iJgVLXeD6jCSMB3QXoz5M8nfj0JwKjABoqLaBkVCY8nJeKrFKECx/HYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XiA6swW2; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aff0775410eso488796566b.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 13:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757103015; x=1757707815; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xddsR/Pe+eD7cGTppeQ6zoun06h85L7v8WnJ4cYLHhY=;
        b=XiA6swW2YwGna0wpaiZQE6oStvn0paKdfaWmXPnedCWhxv3SUw9Z6ijTQ+68WNCM8I
         bkHhlTLb1Kkia20OdS44HHuC+/4aXPAC/E5pI5BUal4q72/8TtljxMRY5xGjgLxcZdtu
         USXIls/hFcVv8w/dd7pKgOsSjf1H63Q3yeMIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757103015; x=1757707815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xddsR/Pe+eD7cGTppeQ6zoun06h85L7v8WnJ4cYLHhY=;
        b=LoFmu6Y9yQL6tB8ZsqaqMozVMjYDPmSJeQsnre6Fx+Lp7kcwpfFeCVEGxS7FnkqhXh
         FWWf79SRVCbweSvz0HbarC4T2xjzpAmMNhOZn1ftIGu1/4iC1NIneQO0yit+XoUexeWK
         s6ACaPc+lLZnOwILXQH/DTZA4gFHSqaxRFrXRoPqR4IlPgiA+d1CEd6f2ukAG3/S2spg
         dOMOyaSaNhV8CRuGG+lmMwEzcRhg2T+a1lKHrbwumuOcErPrH00aT6LA6QNWWcdCD8Rm
         xwZqaNWMkNJvyFM4e3VLIJBZqedN9DbxpV9sIo5eZRgmKIXBeyd5Qm3d66Wa2a0qrsR2
         5+kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg1OeaNe10ojg1NAX9kFtO/J3qbVMf7pKyu8Njk2hUzdcLoYs5PBJboCdXc/6KRyxKvzoVKW8ISQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrYqdMmdxOH5szSsp23KeJhM44D4+fyreQjWuOsi1uZftwQVxo
	vELvn0hWW+K0JJnC8YuaetTMEzGQ8q/CmiUUkW8MBZNXhq3tIuxx2vwP2QHu+8sIsgkSxXw3Hx7
	1AR20N4Q=
X-Gm-Gg: ASbGncvekee1eBTyGRR5ZIn6Jx6gzWW0kdhSzqktbe0fkEXytHxaaNGyjw5OLK6BBfg
	LqIsDhxlBS+pplIUhpE9DwjZUvFFvVRBO13b9GMRL3VobFEUxCR+68R4aZ5e3Xs3tI2lb4qCeJT
	s+TP19ZDnb6BCfKGcv5j9X7/YrXnEUUagshKeiopy7iMF7zQdmZW2WLu+ZnHHGlJ9xBMyxNeIrE
	v8eSsP/pykdOJDE/54t208CLqx5Jka0lmeIuJY23w/pUuA9c8ofy6yql6j8Oyzms7KglY2wAWez
	avZfMT7mkRM86AYruYOwLNTfjjcfpC89hj0ADKyCmjAL1MhxJnytscy2ImVDKRglvjiVJudvCK3
	yAX/YV8Z5yNrlVpHS0w6rsefbjVA7sYoXBj6rat0QTI2JcMZavI6zI9TLOqWCd293e6nasqxiTg
	dkX5+qPp0=
X-Google-Smtp-Source: AGHT+IExIGeRt8o9rQ9Z7oDI9yPpGaAiOokN7L/o1XFCem7rAEZeIBZF9OS3Yk3LJcrTM/3sJuiEZA==
X-Received: by 2002:a17:907:3d91:b0:af9:70f0:62e3 with SMTP id a640c23a62f3a-b04931f4a7emr502249766b.15.1757103014783;
        Fri, 05 Sep 2025 13:10:14 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm1619621566b.12.2025.09.05.13.10.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 13:10:14 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so6612239a12.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 13:10:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6uGXVTo3gh3VlPLF9Bfeec6iwwo/QqfW+48Epz/wxG8kmnyqLoWEdqV8kamH1O0YT46J3W2ckcQ==@vger.kernel.org
X-Received: by 2002:a17:906:dc93:b0:b02:d867:b837 with SMTP id
 a640c23a62f3a-b0493084d31mr511145266b.7.1757103013782; Fri, 05 Sep 2025
 13:10:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur> <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
In-Reply-To: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 13:09:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh7_K-8HxSuxvYAOiWy+1UkVyOs5qPLdZEj5bjn+-7PnQ@mail.gmail.com>
X-Gm-Features: Ac12FXyvC8KlB-60GW4lzH7j8EzgCz1sz-rbVM2idRV4lq9qeYgMZVtZcK0__N4
Message-ID: <CAHk-=wh7_K-8HxSuxvYAOiWy+1UkVyOs5qPLdZEj5bjn+-7PnQ@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>, 
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 12:33, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> We do support this usage using `b4 shazam -M` -- it's the functional
> equivalent of applying a pull request and will use the cover letter contents
> as the initial source of the merge commit message. I do encourage people to
> use this more than just a linear `git am` for series, for a number of reasons:

I think that works well for more complex series, yes.

> This does create a lot more non-linear history, though. Judging from some of
> my discussions on the fediverse, some maintainers are not sure if that's okay
> with you.

I do *not* think it makes sense for random collections of patches, or
some minor two-patch series, no.

But I do think it makes sense for patch series that (a) are more than
a small handful of patches and (b) have some real "story" to them (ie
a cover letter that actually explains some higher-level issues).

Put another way: I would be unhappy if that model is used mindlessly.
No "let's automatically encourage this", please. That was, I feel, the
problem with "-l".

For example, just looking at things that happened today on lore, something like

  https://lore.kernel.org/all/20250905191357.78298-1-ryncsn@gmail.com/T/#t

looks like it could be handled very well with that actual merge model.
Just look at that cover letter: it has relevant numbers for the
series, exactly the kinds of things you do *not* want in individual
commit messages, but that make sense as a merge message.

That said, from what I've seen, these kinds of series are often MM,
and I don't think it matches the flow that Andrew tends to use. We
finally got Andrew to use git fairly recently, I'm not convinced
getting him to have a fancy non-linear history is in the cards.

(That said, Andrew clearly deals with series internally, and his pull
requests tend to actually describe things as such, so maybe he
wouldn't be too annoyed by something less linear).

I would worry a bit that  people would use odd merge bases for this.
Because one of the advantages of a linear history is that it's
simpler, and in particular that you only mess up the beginning point
of that linear history *once*. And yes, people do mess that up (we
have a whole section about the whole "pick a good base" in the docs
and people have gotten it wrong).

With non-linear history, there's just more complexity and getting
things wrong is easier and can be even more confusing.

So while I do think do that "b4 shazam -M" can be a very good thing, I
also think it's something that *definitely* needs a fair amount of
forethought.

It should not be some "default flow", in other words.

                 Linus

