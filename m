Return-Path: <io-uring+bounces-371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2DA821F48
	for <lists+io-uring@lfdr.de>; Tue,  2 Jan 2024 17:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 102EC1F22DD8
	for <lists+io-uring@lfdr.de>; Tue,  2 Jan 2024 16:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0577814ABF;
	Tue,  2 Jan 2024 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xdvm8H+X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D84314F65
	for <io-uring@vger.kernel.org>; Tue,  2 Jan 2024 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-555144cd330so7020333a12.2
        for <io-uring@vger.kernel.org>; Tue, 02 Jan 2024 08:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704211923; x=1704816723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqAcAJvK0gwNUTbSW3CjQlsOCezKK1PboNYWGcW3ipU=;
        b=Xdvm8H+XyNWjNzpsH+AOgVJh4DxLOjAoK3dSfV8EE4a1vzEvYwhWHtWgDjKAxMaWnQ
         TEJ6YYuu2MEAFWAkN0HJ7JTlezqG11N2nrF2DPmiyy6w2DBuB0JRP3VKKtOuYSBHbUUi
         A0hlRWfzlnHlzligrwXU7R/7JoU8QE2fRMU8NJvBTGEzv71lqdUG5n6YAwh32aLxWVS5
         h76Ps3aVrXxcOl33GvIedSuW2pdI8BErfCPB/7AYdyczHQqng+XhE/x/GUjZX4TS0GQA
         3IPAkHLshgPotmxG5JDIsGTuUM2NVw8prVR2AazP5kYQDrShJfjBnFhKzqOI5uIu537F
         vSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704211923; x=1704816723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqAcAJvK0gwNUTbSW3CjQlsOCezKK1PboNYWGcW3ipU=;
        b=O/Vr5NNUAciBEKMKCspD7gH5j2QYovGClwm+05rPHPgm7klj3zbTe2nU0A3rHYX0DT
         QXej0E7rOldJrUytIXxjkBybkJjd3MP/mYhTKYJxzHXl0XyJ2W5KeyARlITIkTPsI1Ws
         P6+EKFVKB5WR0A6c2f76hcwKXECYdOZFGdGgj7ioiv5smlCkE+t1zWaHScykyUyxRgAp
         FqjfIhoeJVxJhArZZsZ4Rc8vILEGEVaRSZkSWGQ7+32xGSgsQGU4fJO4iLEc3H5Gs8K0
         Lm6LdOBRyu+gYz6vAiQ1KgYaXvFiQcxUZ6fgaglLFR/eMWqnbW8KA/21NT+Bb5fJxzwm
         GCKQ==
X-Gm-Message-State: AOJu0YxIqrN9e0BuZdvMDdiCJuYHGU1UL1JJeychoUNyAPVaHWNl0yRd
	MUj0pDO87DnHesQKyuvU8P8bKjNqj2wPlXBNQ1kdZa7zmNtI
X-Google-Smtp-Source: AGHT+IFbbQOUZHyvkck+bNRUtx0jkbQqzf8vcbORHAFjDKfpv3QV1eUvusHb9ga4pwHFdRSMqc35X18gsM0N3h9jp7w=
X-Received: by 2002:a17:906:7490:b0:a27:7cd5:7e9b with SMTP id
 e16-20020a170906749000b00a277cd57e9bmr3103321ejl.141.1704211923473; Tue, 02
 Jan 2024 08:12:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-3-dw@davidwei.uk>
 <CAHS8izO0ADnYqKczEkfNts2VLDfiYEkQ=AzJ-xzb+Kh2ZpFjbg@mail.gmail.com> <9f5ea0cb-215a-4b43-92dc-d306015c8c7a@gmail.com>
In-Reply-To: <9f5ea0cb-215a-4b43-92dc-d306015c8c7a@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 2 Jan 2024 08:11:49 -0800
Message-ID: <CAHS8izN49uEcfajKMHrOHAkZJ8jpWieyudHocQ6bzT7N5-yNsg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/20] tcp: don't allow non-devmem originated ppiov
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 5:34=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 12/19/23 23:24, Mina Almasry wrote:
> > On Tue, Dec 19, 2023 at 1:04=E2=80=AFPM David Wei <dw@davidwei.uk> wrot=
e:
> >>
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> NOT FOR UPSTREAM
> >>
> >> There will be more users of struct page_pool_iov, and ppiovs from one
> >> subsystem must not be used by another. That should never happen for an=
y
> >> sane application, but we need to enforce it in case of bufs and/or
> >> malicious users.
> >>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: David Wei <dw@davidwei.uk>
> >> ---
> >>   net/ipv4/tcp.c | 7 +++++++
> >>   1 file changed, 7 insertions(+)
> >>
> >> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >> index 33a8bb63fbf5..9c6b18eebb5b 100644
> >> --- a/net/ipv4/tcp.c
> >> +++ b/net/ipv4/tcp.c
> >> @@ -2384,6 +2384,13 @@ static int tcp_recvmsg_devmem(const struct sock=
 *sk, const struct sk_buff *skb,
> >>                          }
> >>
> >>                          ppiov =3D skb_frag_page_pool_iov(frag);
> >> +
> >> +                       /* Disallow non devmem owned buffers */
> >> +                       if (ppiov->pp->p.memory_provider !=3D PP_MP_DM=
ABUF_DEVMEM) {
> >> +                               err =3D -ENODEV;
> >> +                               goto out;
> >> +                       }
> >> +
> >
> > Instead of this, I maybe recommend modifying the skb->dmabuf flag? My
> > mental model is that flag means all the frags in the skb are
>
> That's a good point, we need to separate them, and I have it in my
> todo list.
>
> > specifically dmabuf, not general ppiovs or net_iovs. Is it possible to
> > add skb->io_uring or something?
>
> ->io_uring flag is not feasible, converting ->devmem into a type
> {page,devmem,iouring} is better but not great either.
>
> > If that bloats the skb headers, then maybe we need another place to
> > put this flag. Maybe the [page_pool|net]_iov should declare whether
> > it's dmabuf or otherwise, and we can check frag[0] and assume all
>
> ppiov->pp should be enough, either not mixing buffers from different
> pools or comparing pp->ops or some pp->type.
>
> > frags are the same as frag0.
>
> I think I like this one the most. I think David Ahern mentioned
> before, but would be nice having it on per frag basis and kill
> ->devmem flag. That would still stop collapsing if frags are
> from different pools or so.
>

This sounds reasonable to me. I'll look into applying this change to
my next devmem TCP RFC, thanks.

> > But IMO the page pool internals should not leak into the
> > implementation of generic tcp stack functions.
>
> --
> Pavel Begunkov



--=20
Thanks,
Mina

