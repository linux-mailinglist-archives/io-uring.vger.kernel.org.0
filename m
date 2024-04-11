Return-Path: <io-uring+bounces-1500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 952E48A04F1
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 02:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7DE11C20FFD
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 00:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA402CA7;
	Thu, 11 Apr 2024 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFcC2sUB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1535D51E;
	Thu, 11 Apr 2024 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712796769; cv=none; b=Q/zQoZsPeBBK4ud/FW8vIVurwLv/DN536vgCAf2SUYKkmdwM37TiO+2VtbPhW66CPZHMN9iK/XtPb5TPYdDt8VDB6A7k8p/H3eZcMVOeWgxT09hd9acWzs55umhI7MctrJd5UQxf+l1Nz42aWqE4LDs+7xVRoCLpcz3qB0DJJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712796769; c=relaxed/simple;
	bh=tDbOaO/1XU/356k6Y8UmDzuMfxh0VhDDmH7UHMOqrzM=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iEHuIkJzfi+nKZ56HNOaaeCXADq5ln/J4TkHsEcLsUeAA46rZ00AYZDTHOJQuwO4LRHKCpHHXl3T+shhlF5GLl/yxbJZTwx/ZTNR/byGr2eoxv4oYbwYDx2iX4rq9Ma17OQP3ZcDt+zVIOxEeaqJt9tUlAvURW1WQarxktnNPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFcC2sUB; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-346406a5fb9so1556668f8f.1;
        Wed, 10 Apr 2024 17:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712796766; x=1713401566; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tDbOaO/1XU/356k6Y8UmDzuMfxh0VhDDmH7UHMOqrzM=;
        b=FFcC2sUByX7Jwko4178i0m7PMwIlYvDoIkRPjAOnrg5ov7xTqla+AQmxl8sLJ3HSVa
         fmtKasR0tEvWvyyVEtW9ugB3Gg8j0MuAjLmfGQWNe0oiH4vfd+n7RPk1r4eRDK2caR5G
         T//NVt9qVnrWMnPEZIms/xmN5u+Bolkvs2vgjr+BUlScgocxfPVgMbVVLfIdjh5n31p9
         /iGllII+J02h4J9aVi+uOM+1QvMIyvdgeKoy+wF+gPrAIneK0k/Dgwz+r3ydhJRjnX2G
         8y8iAzyit4QUN4X8tIuwUMS9gd2UJpxg73GVqDEAwaVIMFN11I9G7dY8oCvGZ10Z3w44
         AqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712796766; x=1713401566;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDbOaO/1XU/356k6Y8UmDzuMfxh0VhDDmH7UHMOqrzM=;
        b=I500Sm6cCRc/Ozpx7wp6svQV5hg5gFX7DD2HTSmhc2jFYjHLltxeN6VJucRAFfX1V+
         SiIYENG5dbC2dw6Kwjv2ZfDMbg8I5e8zuQ2l6sTwiwtfKKLlgms5bn7c6k2pWvJBD0Tt
         j/dYAkoXk67eZxhpHTBHi2pZQDC2dqEvR/kJ4oUMtLtiCbJWaKO8nJSi1P9D6vf1uVBu
         VFK9/P+8SrnokVCSqzt215DHC0HrphwfLZkmP4dKXV8b6q7mkAqbp008EaEQ82R9cjsr
         nf6ioZY31/HsyQz2ZGTvyc2fnar8U8KBaoOSSTAxvS/sQWVrGmYLXC3ihw1Z1pcexaZG
         mFjA==
X-Forwarded-Encrypted: i=1; AJvYcCVtyZj51crUKrx733lvHtMU1coAqJOMEZh+ckClyeZpeBQNVTLyT1VoGm/xQKOzG+gZC/VJulXgfoKkmnQfbqSA4xJZAIoxTk/7EM6N
X-Gm-Message-State: AOJu0Yw9Tjp3GAu1/61fH/L/BnIu+ffx+C84gZbptlXsLxgc3JKYXtu5
	JSQfyYQrhTioVXRVVSCf+1cmKvUKZ9xiaYbGiimQlH0ERV540LRJPiOaqqAnLA67fiDPbZYcvTk
	wwZdgtcUgTXInfSN0x7Go5ARlRPM=
X-Google-Smtp-Source: AGHT+IHO4ErRa1hFQmFIoMyeFaR/i7qecuC11H78hkhdTewP1Qypp4aPxjXvBg/t8fNJ4AmDGblwU+cafaUWNRqW91g=
X-Received: by 2002:a5d:6d81:0:b0:346:75ae:471b with SMTP id
 l1-20020a5d6d81000000b0034675ae471bmr2294597wrs.51.1712796765761; Wed, 10 Apr
 2024 17:52:45 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 Apr 2024 17:52:45 -0700
From: Oliver Crumrine <ozlinuxc@gmail.com>
In-Reply-To: <8666ff9d-1cb6-4e92-a1b3-4f3b1fb0ac79@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com> <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com> <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com> <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
 <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com>
 <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com> <CAK1VsR3QDh3WiR+r=30f0YQkiYN3hw071Hi9=dkd_xLQ2itdvw@mail.gmail.com>
 <8666ff9d-1cb6-4e92-a1b3-4f3b1fb0ac79@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Wed, 10 Apr 2024 17:52:45 -0700
Message-ID: <CAK1VsR1+8nQdX4of4A6DoRj5WSyAt2uYFeqG3dAoQ7aR_vkRZg@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
To: Pavel Begunkov <asml.silence@gmail.com>, Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pavel Begunkov wrote:
> On 4/9/24 02:33, Oliver Crumrine wrote:
> > Pavel Begunkov wrote:
> >> On 4/7/24 20:14, Oliver Crumrine wrote:
> >>> Oliver Crumrine wrote:
> >>>> Pavel Begunkov wrote:
> >>>>> On 4/5/24 21:04, Oliver Crumrine wrote:
> >>>>>> Pavel Begunkov wrote:
> >>>>>>> On 4/4/24 23:17, Oliver Crumrine wrote:
> >>>>>>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> >>>>>>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
> >>>>>>>> understanding) the userspace program wouldn't receive the
> >>>>>>>> IORING_CQE_F_MORE flag in the result value.
> >>>>>>>
> >>>>>>> No. IORING_CQE_F_MORE means there will be another CQE from this
> >>>>>>> request, so a single CQE without IORING_CQE_F_MORE is trivially
> >>>>>>> fine.
> >>>>>>>
> >>>>>>> The problem is the semantics, because by suppressing the first
> >>>>>>> CQE you're loosing the result value. You might rely on WAITALL
> >>>>>> That's already happening with io_send.
> >>>>>
> >>>>> Right, and it's still annoying and hard to use
> >>>> Another solution might be something where there is a counter that stores
> >>>> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
> >>>> userspace could call a function like: io_wait_completions(int completions)
> >>>> which would wait until everything is done, and then userspace could peek
> >>>> the completion ring.
> >>>>>
> >>>>>>> as other sends and "fail" (in terms of io_uring) the request
> >>>>>>> in case of a partial send posting 2 CQEs, but that's not a great
> >>>>>>> way and it's getting userspace complicated pretty easily.
> >>>>>>>
> >>>>>>> In short, it was left out for later because there is a
> >>>>>>> better way to implement it, but it should be done carefully
> >>>>>> Maybe we could put the return values in the notifs? That would be a
> >>>>>> discrepancy between io_send and io_send_zc, though.
> >>>>>
> >>>>> Yes. And yes, having a custom flavour is not good. It'd only
> >>>>> be well usable if apart from returning the actual result
> >>>>> it also guarantees there will be one and only one CQE, then
> >>>>> the userspace doesn't have to do the dancing with counting
> >>>>> and checking F_MORE. In fact, I outlined before how a generic
> >>>>> solution may looks like:
> >>>>>
> >>>>> https://github.com/axboe/liburing/issues/824
> >>>>>
> >>>>> The only interesting part, IMHO, is to be able to merge the
> >>>>> main completion with its notification. Below is an old stash
> >>>>> rebased onto for-6.10. The only thing missing is relinking,
> >>>>> but maybe we don't even care about it. I need to cover it
> >>>>> well with tests.
> >>>> The patch looks pretty good. The only potential issue is that you store
> >>>> the res of the normal CQE into the notif CQE. This overwrites the
> >>>> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
> >>>> indicate to userspace that there will be another CQE, of which there
> >>>> won't.
> >>> I was wrong here; Mixed up flags and result value.
> >>
> >> Right, it's fine. And it's synchronised by the ubuf refcounting,
> >> though it might get more complicated if I'd try out some counting
> >> optimisations.
> >>
> >> FWIW, it shouldn't give any performance wins. The heavy stuff is
> >> notifications waking the task, which is still there. I can even
> >> imagine that having separate CQEs might be more flexible and would
> >> allow more efficient CQ batching.
> > I've actaully been working on this issue for a little while now. My current
> > idea is that an id is put into the optval section of the SQE, and then it
> > can be used to tag that req with a certain group. When a req has a flag
> > set on it, it can request for all of group's notifs to be "flushed" in one
> > notif that encompasses that entire group. If the id is zero, it won't be
> > associated with a group and will generate a notif. LMK if you see anything
> > in here that could overcomplicate userspace. I think it's pretty simple,
> > but you've had a crack at this before so I'd like to hear your opinion.
>
> You can take a look at early versions of the IORING_OP_SEND_ZC, e.g.
> patchset v1, probably even later ones. It was basically doing what
> you've described with minor uapi changes, like you had to declare groups
> (slots) in advance, i.e. register them.
My idea is that insead of allocating slots before making requests, "slots"
will be allocated as the group ids show up. Instead of an array of slots, a
linked list can be used so things can be kmalloc'ed on the fly to make
the uapi simpler.
>
> More flexible and so performant in some circumstances, but the overall
> feedback from people trying it is that it's complicated. The user should
> allocate group ids, track bound requests / buffers, do other management.
> The next question is how the user should decide what bind to what. There
> is some nastiness in using the same group for multiple sockets, and then
Then maybe we find a way to prevent multiple sockets on one group.
> what's the cut line to flush the previous notif? I probably forgot a
I'd make it the max for a u32 -- I'm (probably) going to use an atomic_t
to store the counter of how many reqs have been completed, so a u32 max
would make sense.
> couple more complaints.
>
> TL;DR;
>
> The performance is a bit of a longer story, problems are mostly coming
> from the async nature of io_uring, and it'd be nice to solve at least a
> part of it generically, not only for sendzc. The expensive stuff is
> waking up the task, it's not unique to notifications, recv will trigger
> it with polling as well as other opcodes. Then the key is completion
> batching.
Maybe the interface is made for sendzc first, and people could test it
there. Then if it is considered beneficial to other places, it could be
implemented there.
>
> What's interesting, take for example some tx only toy benchmark with
> DEFER_TASKRUN (recommended to use in any case). If you always wait for
> sends without notifications and add eventual *_get_events(), that would
> completely avoid the wake up overhead if there are enough buffers,
> and if it's not it can 1:1 replace tx polling.
Seems like an interesting way to eliminate waiting overhead.
>
> Try groups, see if numbers are good. And a heads up, I'm looking at
I will. Working hard to have the code done by Sunday.
> improving it a little bit for TCP because of a report, not changing
> uapi but might change performance math.
>
> --
> Pavel Begunkov

