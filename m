Return-Path: <io-uring+bounces-10314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B9DC26FF8
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 22:19:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9371F426965
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 21:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A6E30DD33;
	Fri, 31 Oct 2025 21:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmChgljY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987942F8BF0
	for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 21:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761945574; cv=none; b=SSps4m9RFhoXmnXJoBsZtVPOiQTE3+y+Z7zn5FWhfbV9p80CnwsJA8/GuWqWkdD9O5DYPQFkgtw6RcHG+iVMzuperRbid600YoYSy4u2I/+iCsYFF9EhWfP43PE06sXylbQn3XjQPoHWtx6PZwBfp/tFTuVBur9TgRddVe5xNTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761945574; c=relaxed/simple;
	bh=b/0txVgfYDXr/8G1IrSggcm94wwGv37ITJn01zowz0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iuO7edAxK0BQSFhfQJZTx3NNMbR9p+dCG6ahRNSMAU/yDI8MvAHerYlwt3so5gjUafQ3XTvLpt6Ogo1YYUX5TvTFNp7mWss/0uonleoqexDutt+JRIaRnSQo7AtFluz9SYhCE0mFuqSZIfSjMAYucxkXun6qyGywrTUmZ2PVv6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmChgljY; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ed02d102e2so30180991cf.1
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 14:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761945571; x=1762550371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/0txVgfYDXr/8G1IrSggcm94wwGv37ITJn01zowz0A=;
        b=HmChgljYltwGvumIYedYT0UPVDEKc62OUExzn7ENBdouQ7QL0t1iFalMZRBe1ia4xt
         cUIDSB9LYQaL4w1V8/fnO/jBzTn7Dm64hxWb10VLquZpfJcDe6YilsciEcGId48M1tkK
         pllc2s3IYLnAYDNCl979+aejycMO4gt+MYmfH1opQaCXVo/1UfLY7jb8k2VoAMkmHslI
         oppMpE/gGv1t95tBv1Z3W5+FalHqHaCSI6yuzsCLXP6S71QZq4c/zQtUVpZ0yXYCfKFE
         dnwGB33eM0eRiE99SnNzILP7ontF5YloTLrm2SjK7FcGXdcO2jNfjphFTSbkQPfoDEdc
         xfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761945571; x=1762550371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/0txVgfYDXr/8G1IrSggcm94wwGv37ITJn01zowz0A=;
        b=gXcVr6oehdVvtJXW1KYeWmmiYN1spV4eWjDyl0G8/IEsMRIZolL+bLAbIg0cvjFQMu
         afBwYP2BlXtAOz4F302f5fWv+guVryPptnI3+Azro2cC2wi3Ug5/5eCGmxX1+jatI6jJ
         qZrT/wh2rPWMnKcKmeLLixNLTGVHqRpxO4tvIdVAj3x72FVho3kivbKc4NJt5gkEYNU6
         E8Fn+4jFWQJlmGbO3jhkHA9+ufXJ3CSqwby4ZPvUhZZlbw4xKEweH2gtfIXHoAPLPYt4
         p9MVAsy3E+TRQX1w6Nq+ReZSlqbuVqQOaZkoK6QV5zJw6djvdKRoNV7Kw7FnKWt00aeb
         FhVw==
X-Forwarded-Encrypted: i=1; AJvYcCWIVSy0goxL15ftetwJNieE+xIxD5q4MSJxkU0kR3x3iXKaO+mQgWa7HUqMQxRT2vc4eIQfRNBBKA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmv5aoPr/VWc65o9gniO7CEeHIhT6c5Szn8dM6bkaaNJYeIRjj
	tCJQ7FzHvsYCatsUuRRM0SECkcKXQog/WhpTb6krr7qAxfL41cYzB+R0IJGF3nYC31LIgPTRvcL
	DzR6JyqtgIyRVtPykHiXbSB5aPUsoMGw=
X-Gm-Gg: ASbGncu7+i8fP6TH3c9JofIUx9X3N5shm8SOpWKb7cu3ACTaqIk4x0QUZbR7MUP5zZG
	b3qUssX3Qxde3ZOOKleXH4Av/1cYPshtJS3ESFlPcxHiPFsOvlV/ptG5icNGZzqHrMA5koT/GMN
	c+3g7zSFxPRNwcS27mJlt3z2M+CGzjNZjXxhfbq4wZUA0/PRhD8SVDP721KQWZELn0ENda1e9ks
	DL9rSYdedGh2t+iSNzjQKU7dM+mp981gvyFJoS6encTwHKJd85EN14wE1PZdVj3rzQ6pWanjgz3
	istU5+ORUaM8Xy6Dtmui/adgsCPjSbdY6H2JD9ghJxk=
X-Google-Smtp-Source: AGHT+IFJX2P1M70apw0nFyQz4o0INv/KHKAgN8dqmKmpRSuAuyAxUdXHsgwFTW9goOpBIvI5l1w3EEQR36rpTyq5w94=
X-Received: by 2002:a05:622a:347:b0:4e8:9ad9:f3da with SMTP id
 d75a77b69052e-4ed30df9500mr47279601cf.30.1761945571467; Fri, 31 Oct 2025
 14:19:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com> <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
 <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com> <96c4d33d-4f56-4937-bae7-9bda17f3264f@ddn.com>
 <CAJnrk1ah68G4NpDj8A41tX6J2M+NB6jNAUYdWEzTD3N_QrDJ_g@mail.gmail.com> <ebecc186-b5fd-4c55-a253-64c889f17062@ddn.com>
In-Reply-To: <ebecc186-b5fd-4c55-a253-64c889f17062@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 31 Oct 2025 14:19:20 -0700
X-Gm-Features: AWmQ_bno1ir54lWZLYFEmmRVsOwsvUudIz7RjkLPQJK6DmEHw0maxvDwvgL9E94
Message-ID: <CAJnrk1bNX27dZNNg-u0_8NVNdDWi+99ohUuk7kY3sZb_P47hfQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
To: Bernd Schubert <bschubert@ddn.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, "miklos@szeredi.hu" <miklos@szeredi.hu>, 
	"axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>, 
	"csander@purestorage.com" <csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 3:27=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> On 10/31/25 00:50, Joanne Koong wrote:
> > On Thu, Oct 30, 2025 at 3:24=E2=80=AFPM Bernd Schubert <bschubert@ddn.c=
om> wrote:
> >>
> >> On 10/30/25 19:06, Pavel Begunkov wrote:
> >>> On 10/29/25 18:37, Joanne Koong wrote:
> >>>> On Wed, Oct 29, 2025 at 7:01=E2=80=AFAM Pavel Begunkov <asml.silence=
@gmail.com> wrote:
> >>>>>
> >>>>> On 10/27/25 22:28, Joanne Koong wrote:
> >>>>>> Add an API for fetching the registered buffer associated with a
> >>>>>> io_uring cmd. This is useful for callers who need access to the bu=
ffer
> >>>>>> but do not have prior knowledge of the buffer's user address or le=
ngth.
> >>>>>
> >>>>> Joanne, is it needed because you don't want to pass {offset,size}
> >>>>> via fuse uapi? It's often more convenient to allocate and register
> >>>>> one large buffer and let requests to use subchunks. Shouldn't be
> >>>>> different for performance, but e.g. if you try to overlay it onto
> >>>>> huge pages it'll be severely overaccounted.
> >>>>>
> >>>>
> >>>> Hi Pavel,
> >>>>
> >>>> Yes, I was thinking this would be a simpler interface than the
> >>>> userspace caller having to pass in the uaddr and size on every
> >>>> request. Right now the way it is structured is that userspace
> >>>> allocates a buffer per request, then registers all those buffers. On
> >>>> the kernel side when it fetches the buffer, it'll always fetch the
> >>>> whole buffer (eg offset is 0 and size is the full size).
> >>>>
> >>>> Do you think it is better to allocate one large buffer and have the
> >>>> requests use subchunks?
> >>>
> >>> I think so, but that's general advice, I don't know the fuse
> >>> implementation details, and it's not a strong opinion. It'll be great
> >>> if you take a look at what other server implementations might want an=
d
> >>> do, and if whether this approach is flexible enough, and how amendabl=
e
> >>> it is if you change it later on. E.g. how many registered buffers it
> >>> might need? io_uring caps it at some 1000s. How large buffers are?
> >>> Each separate buffer has memory footprint. And because of the same
> >>> footprint there might be cache misses as well if there are too many.
> >>> Can you always predict the max number of buffers to avoid resizing
> >>> the table? Do you ever want to use huge pages while being
> >>> restricted by mlock limits? And so on.
> >>>
> >>> In either case, I don't have a problem with this patch, just
> >>> found it a bit off.
> >>
> >> Maybe we could address that later on, so far I don't like the idea
> >> of a single buffer size for all ring entries. Maybe it would make
> >> sense to introduce buffer pools of different sizes and let ring
> >> entries use a needed buffer size dynamically.
> >>
> >> The part I'm still not too happy about is the need for fuse server
> >> changes - my alternative patch didn't need that at all.
> >>
> >
> > With pinning through io-uring registered buffers, this lets us also
> > automatically use pinned pages for writing it out (eg if we're writing
> > it out to local disk, we can pass that sqe directly to
> > io_uring_prep_rw() and since it's marked as a registered buffer in io
> > uring, it'll skip that pinning/translation overhead).
>
> Ah that is good to know, maybe worth to be mentioned to the commit messag=
e.

Will do. I will add this to the commit message.

>
> Btw, I will start to work on libfuse around next week to add another
> io-uring interface, so that the application can own the ring and
> let libfuse submit and fetch from it. I.e. that way the same ring can be
> used for libfuse and application IO.

Sounds great! Looking forward to the changes.

Thanks,
Joanne
>
> Thanks,
> Bernd

