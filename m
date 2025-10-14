Return-Path: <io-uring+bounces-9989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E01E0BD71C2
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 04:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 158EC188E22A
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 02:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E65A8306B32;
	Tue, 14 Oct 2025 02:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fqOdyATx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2D306B2C
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 02:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409539; cv=none; b=bcK4WOnfvzF+1B/jgQ5RocP2YcrPN+bZ81RL+bu9fHH+N5IiJbQCY+HVHYO1mWa5+oNMRnjcEqZrt/me1tDADxzJvk29DaTXXXgH49IRYQXcRwEZ3g6ZVvlopmycpPX0FCpFb2sRzbyTrww16jvWeDgKPQZ9NAkJwK0L9EbiXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409539; c=relaxed/simple;
	bh=XeoEz+BWxO/GEUuwbp8y7/YZ6e6tmUqWW80GEDF9jB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HgpaKLvuehtHZi4zHVYBeAz3BmQGiXWHC8ZJHH7TkE8ahxwSBu2PJHJKq9I6MxANc5XnSJcOoNPix0YmT7GWqn9rK9NMEzi2peZHvQwVeZsqSbmpGiBLO3ugQJsUJ6AXX9HHUCXxN98osnS3KgG8rL6347d1xFL9C7kjxGhqU+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fqOdyATx; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3729f8eaa10so891031fac.3
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 19:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760409534; x=1761014334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4L1zhkBqvLQzDevAfrUfktHs5nXflBPR+xwPlqwGNI=;
        b=fqOdyATxaByLDlljotibKBrmWvBXpnx28MEoc7mBeCjOc9+xO5WQnzgBQZeW55id9x
         GU2Na8HQiO/5AD2rdZv6JszIaHXyWMqW5DQ6flea3/p0EI2cs2AKMQvmPC+vgQunBzVR
         ZHoZ0saE8acJNv7P7dzmoN/jPa45M7nVzV1tjmZ0hwvXk9d/70Ukuc0v5eSs6uMSHQpc
         sQ3tTLf3pRtgP28YqpfYqsP6YAvAz6RJ1xg19Zt/nqANAgiX17iSLh0lORNZagGmK2sB
         wVmaJRt8txc1LHHrk4i7HUdUWV9K7j9Qn6+SZJYmjLqX+V6l6yrJ+YphMeCwwM+DE6/R
         L0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760409534; x=1761014334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4L1zhkBqvLQzDevAfrUfktHs5nXflBPR+xwPlqwGNI=;
        b=Yfs0cP8kaeBZXwBWLvXielDLENYE6AwFFoag3ruXSvqEDQMdxkIhaEmIroXHn6iy3Y
         K/7OexR+6BDq3TdlntrNnM9QQa6mAOV9DxgqHLkWvq5NNPo3CQv5plvfsHTMOwBaj2KN
         qBAYo5AhwKSBtmxuqcvizRFMTpiQFW+RMGBLMgbtDw46KUKhYMji/DfbG5RWQlTdKBM8
         FxXE6paGZGE4LNqFOjam7dl25+UNcQkW3Du+WSIl3Ui6rWxalpJxB4Br0baGJn5rqfPE
         se08AgWi273x+gltXGOxJIXFZqtj+QsIjKa54gY41RkzsIjhCXD9KOXd3kVCMT0kjead
         ViLA==
X-Forwarded-Encrypted: i=1; AJvYcCValUbgdVsOIUR+sRxJTqc4xKBICBQ651zdreJEXUaw4gJ4tndRmi1rU0i5+Gd5cc1mRIWdasN22g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVPAJZpVNaJG2KaJ4pJEKCppYh2d7YSY8fQqhusm66mwNsqajv
	aWfOAugmedfCq6iZu3vkOfO6HyEEGhJdaPy1W0KWV8kCkQCDc3BYA3d6s9V2TznvXoC/COlgBXS
	pf/cc9orBMgociqNjh0c9byZL7aD0nU2z3b0ShaTOLA==
X-Gm-Gg: ASbGncvhUYLVaWDB3wv68Y9jbhByzytAaWDHpwMJmvjV0TRLsQavKYIc6KULHky9W88
	1qJ/k8Gw3D4bWZN0Bdq1dpmHRxy06AujlbjXYovmt57BpF4vCOVPwWC+qFVVxsDwwXmvY9kP0P0
	TLdgllbp/oH/Uf1+hbs75cK97jFk3rnRN0BBjylnPvSDyVTBVQ4bJv2Dl+G3mSfS0i6blk0nR9Y
	ckUHHdghxI8Gr34Ga3MD7ZI82glFl6YG5c=
X-Google-Smtp-Source: AGHT+IGQB7yz9d/NTqBoNxUfSU6VqXWYlLIOaf82MjkY0LCd2An9VUVdyDl70ezObbIGAYkR9zA2rthSY6/YNH42+m0=
X-Received: by 2002:a05:6870:a54a:b0:35b:7d80:b175 with SMTP id
 586e51a60fabf-3c0f81feda8mr9491761fac.44.1760409533973; Mon, 13 Oct 2025
 19:38:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com>
 <aOxxBS8075_gMXgy@infradead.org> <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
 <aOyb-NyCopUKridK@infradead.org> <CAPFOzZumoCERUj+VuegQNoAwFCoGxiaASD6R_4bE+p1TVbspUA@mail.gmail.com>
 <d785cc8e-d8fd-4bee-950c-7f3f7d452efc@gmail.com>
In-Reply-To: <d785cc8e-d8fd-4bee-950c-7f3f7d452efc@gmail.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Tue, 14 Oct 2025 10:38:43 +0800
X-Gm-Features: AS18NWANM39t4RPcrlXYrv0Im7Lg9gLSnbpSWNZytM4PRJZOtaL1X_BkUQywkT4
Message-ID: <CAPFOzZs5mJ9Ts+TYkhioO8aAYfzevcgw7O3hjexFNb_tM+kEZA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] block: enable per-cpu bio cache by default
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, fengnan chang <fengnanchang@gmail.com>, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	willy@infradead.org, djwong@kernel.org, ritesh.list@gmail.com, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2025=E5=B9=B410=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=B8=80 21:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/13/25 13:58, Fengnan Chang wrote:
> > Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B410=E6=9C=88=
13=E6=97=A5=E5=91=A8=E4=B8=80 14:28=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On Mon, Oct 13, 2025 at 01:42:47PM +0800, fengnan chang wrote:
> >>>> Just set the req flag in the branch instead of unconditionally setti=
ng
> >>>> it and then clearing it.
> >>>
> >>> clearing this flag is necessary, because bio_alloc_clone will call th=
is in
> >>> boot stage, maybe the bs->cache of the new bio is not initialized yet=
.
> >>
> >> Given that we're using the flag by default and setting it here,
> >> bio_alloc_clone should not inherit it.  In fact we should probably
> >> figure out a way to remove it entirely, but if that is not possible
> >> it should only be set when the cache was actually used.
> >
> > For now bio_alloc_clone will inherit all flag of source bio, IMO if onl=
y not
> > inherit REQ_ALLOC_CACHE, it's a little strange.
> > The REQ_ALLOC_CACHE flag can not remove entirely.  maybe we can
> > modify like this:
> >
> > if (bs->cache && nr_vecs <=3D BIO_INLINE_VECS) {
> >      opf |=3D REQ_ALLOC_CACHE;
> >      bio =3D bio_alloc_percpu_cache(bdev, nr_vecs, opf,
> >      gfp_mask, bs);
> >      if (bio)
> >          return bio;
> >      /*
> >       * No cached bio available, bio returned below marked with
> >       * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
> >      */
> > } else
> >          opf &=3D ~REQ_ALLOC_CACHE;
> >
> >>
> >>>>> +     /*
> >>>>> +      * Even REQ_ALLOC_CACHE is enabled by default, we still need =
this to
> >>>>> +      * mark bio is allocated by bio_alloc_bioset.
> >>>>> +      */
> >>>>>        if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <=3D BIO_INL=
INE_VECS)) {
> >>>>
> >>>> I can't really parse the comment, can you explain what you mean?
> >>>
> >>> This is to tell others that REQ_ALLOC_CACHE can't be deleted here, an=
d
> >>> that this flag
> >>> serves other purposes here.
> >>
> >> So what can't it be deleted?
> >
> > blk_rq_map_bio_alloc use REQ_ALLOC_CACHE to tell whether to use
> > bio_alloc_bioset or bio_kmalloc, I considered removing the flag in
> > blk_rq_map_bio_alloc, but then there would have to be the introduction
> > of a new flag like  REQ_xx. So I keep this and comment.
>
> That can likely be made unconditional as well. Regardless of that,
Agree, IMO we can remove bio_kmalloc in blk_rq_map_bio_alloc, just
use bio_alloc_bioset.  Do this in another patch maybe better ?

> it can't be removed without additional changes because it's used to
> avoid de-allocating into the pcpu cache requests that wasn't
> allocated for it. i.e.
>
> if (bio->bi_opf & REQ_ALLOC_CACHE)
>         bio_put_percpu_cache(bio);
> else
>         bio_free(bio);
>
> Without it under memory pressure you can end up in a situation
> where bios are put into pcpu caches of other CPUs and can't be
> reallocated by the current CPU, effectively loosing the mempool
> forward progress guarantees. See:

Thanks for your remind.

>
> commit 759aa12f19155fe4e4fb4740450b4aa4233b7d9f
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Nov 2 15:18:20 2022 +0000
>
>      bio: don't rob starving biosets of bios
>
> --
> Pavel Begunkov
>

