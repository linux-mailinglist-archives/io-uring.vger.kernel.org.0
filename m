Return-Path: <io-uring+bounces-8019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F27ABA64C
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B12B504E87
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54071E9B2F;
	Fri, 16 May 2025 23:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XSms7Vqf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9458522DA15
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436942; cv=none; b=Ml59nSzTkiM8COeddZUk9pcbQyKlgrs0xdVGqzzdfh+K2KTvYTzhwZ6b68ZoGjcSr0SXe1P5bhr6ZP+Ub9vsO3TRQYFjv6yupcCvbCHesoB2X03NbI+g5ABi9GowNO5F2uc2C5BAwct0B8+VX0xbH3cgByw/DFHQ0ofDWg9uMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436942; c=relaxed/simple;
	bh=WqDN79khH6pIjFMkom0Rd/Vh30sfV18MkxWvZFvwv6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3xwJpsvccE/yjqlUwgVwj0pA0hJoeHxwstZm/JvbY/0FwqXuLuBDCyrJsKMyGQ1u7ND0JkU+G7c1m+/yMqQzSOK8Fs87uMpBZMr1eMQQiapxnljAgQTRqxJ5VhZHzWj66JgPPxpDa8XxnhCwmqHJXM/CdNU9qLvpj8OhpcfPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XSms7Vqf; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-73de140046eso436687b3a.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747436940; x=1748041740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQp0dxXnj5cwZg7UECYJoSecqxxUrGXdj9pKyTB7Er0=;
        b=XSms7Vqf8zLNEUnC0jWWcqOPZSfrS8TKsANLCN4HtsV2u6g/abiQLJvY8jczeZsNcy
         2+vb0KNJcCCF5mktwHrqt5A91lyPm+852RRqOmrq5d8hOvA6TyFMHHyQFbaOxO8UZIKI
         2/9yR0Eh69xx9Yi+G4VF6PUonlCtAdyfYnBitIeb7JdKsl0UjmGQMWcXupYYciyg0gQv
         PykPp7R/i53HYeeCdu3tTup14c/rQXlmFapgwa+uOvXGoPqDHctG7D9JXx+toi12cszr
         QJphA2NtFmRoI8j4IMMCMZzPEsc7LRoU2hzBNJOuZJlIsrjXRhw3VuKdX0hqvbaC7aiJ
         ev2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436940; x=1748041740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQp0dxXnj5cwZg7UECYJoSecqxxUrGXdj9pKyTB7Er0=;
        b=vLCzyka1vchtI/c5tkz7rd92WC6Jeloq4FSfRpvFyjQi6oSxvNqOaDriXLhXM+sPJb
         cYhdjlBYoztc8NbP7qx6L6rbP5lOu2wphB+TBdswbZDGryaoKbO5GOatQWGMonnq4EiS
         9KxU9xKMM0JIZuY3ei8ayK6hPJH+pAW2iLRhb/u6FuudClH4o7OICMUh4vjqrCr861kr
         GObfbU+h/CoS3TlMVgLC2y+CNzBJhWJ22BUYb40IbSJaOo1NR6Lm4RWQf/ufM0LC8WBZ
         1EkWeia11UQgwZbEij5brUmMEQjpZxKA60xWXTJ3bzlbwkgwppVDrY56dOJ9Hu8Oyx9r
         WCqQ==
X-Gm-Message-State: AOJu0Yw5y34zMOpmBz/14/Ehct+CCRrH7+bUoS16LL1b/jmGqiadLqcf
	/9c35gJtOwGOQ815PTsRVl1o8Vh9VEetKmTVjJPCFdrOhiFU25C5al269yCU81bbnA7IT+nNqDY
	/3jK1AZgTWcdCjl9nBbOTQWgBRgoPb0+1ofBvyXvPO+mvmK21ALO3vA0=
X-Gm-Gg: ASbGncs6jzhpN/26UCM/jnPnH/4fk1pGv83D5RgciFmEPXwFQbfNGY4apKDeD/9ACoX
	eNMg2DpBpQBWFJCBfsh1IZuKBd/UYDKRN9BxBt3E9cbMP/hKJuxkZ1zivzE5MZ4WJ98LvIW+uxz
	SjsOo/RTydGBE1BbYKbVPRpH4WAAFhssAXHaDaZZ36TA==
X-Google-Smtp-Source: AGHT+IGFbuRrcLDQCrYeIAOjblde1LMb4p0eT1D3M6wF3D/b82zCNqVvd497yvZcarBfOGXKG3AxHGTkCB3R5jL1BrI=
X-Received: by 2002:a17:903:b4e:b0:224:8bf:6d83 with SMTP id
 d9443c01a7336-231d43d1938mr26773395ad.8.1747436939703; Fri, 16 May 2025
 16:08:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516201007.482667-1-axboe@kernel.dk> <20250516201007.482667-4-axboe@kernel.dk>
 <CADUfDZqueYi3XNc3RjXfURwsDgbNgp6pwa8eOReKKv0h+g+RCg@mail.gmail.com>
In-Reply-To: <CADUfDZqueYi3XNc3RjXfURwsDgbNgp6pwa8eOReKKv0h+g+RCg@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 16:08:48 -0700
X-Gm-Features: AX0GCFvH5R1VLsLASMMqLyB34VNv31o335RymW_5agAIRIwKDFGwwX2EPCxyf5A
Message-ID: <CADUfDZqyh-ToAnLTLNOm46Qd9SwJVXBYqtNxjM4h81JAL+opbw@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 4:07=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Fri, May 16, 2025 at 1:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrot=
e:
> >
> > The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
> > take a struct io_cqe pointer rather than three sepearate CQE args. One
>
> typo: "separate"
>
> > path already has that readily available, add an io_init_cqe() helper fo=
r
> > the remainding two.
>
> typo: "remaining"
>
> >
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  io_uring/io_uring.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index b564a1bdc068..b50c2d434e74 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -724,8 +724,8 @@ static bool io_cqring_add_overflow(struct io_ring_c=
tx *ctx,
> >  }
> >
> >  static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
> > -                                            u64 user_data, s32 res, u3=
2 cflags,
> > -                                            u64 extra1, u64 extra2, gf=
p_t gfp)
> > +                                            struct io_cqe *cqe, u64 ex=
tra1,
> > +                                            u64 extra2, gfp_t gfp)
> >  {
> >         struct io_overflow_cqe *ocqe;
> >         size_t ocq_size =3D sizeof(struct io_overflow_cqe);
> > @@ -735,11 +735,11 @@ static struct io_overflow_cqe *io_alloc_ocqe(stru=
ct io_ring_ctx *ctx,
> >                 ocq_size +=3D sizeof(struct io_uring_cqe);
> >
> >         ocqe =3D kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
> > -       trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
> > +       trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe-=
>flags, ocqe);
> >         if (ocqe) {
> > -               ocqe->cqe.user_data =3D user_data;
> > -               ocqe->cqe.res =3D res;
> > -               ocqe->cqe.flags =3D cflags;
> > +               ocqe->cqe.user_data =3D cqe->user_data;
> > +               ocqe->cqe.res =3D cqe->res;
> > +               ocqe->cqe.flags =3D cqe->flags;
> >                 if (is_cqe32) {
> >                         ocqe->cqe.big_cqe[0] =3D extra1;
> >                         ocqe->cqe.big_cqe[1] =3D extra2;
> > @@ -806,6 +806,9 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx=
, u64 user_data, s32 res,
> >         return false;
> >  }
> >
> > +#define io_init_cqe(user_data, res, cflags)    \
> > +       (struct io_cqe) { .user_data =3D user_data, .res =3D res, .flag=
s =3D cflags }
>
> The arguments and result should be parenthesized to prevent unexpected
> groupings. Better yet, make this a static inline function.
>
> > +
> >  bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, =
u32 cflags)
> >  {
> >         bool filled;
> > @@ -814,8 +817,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 u=
ser_data, s32 res, u32 cflags
> >         filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
> >         if (unlikely(!filled)) {
> >                 struct io_overflow_cqe *ocqe;
> > +               struct io_cqe cqe =3D io_init_cqe(user_data, res, cflag=
s);
> >
> > -               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, =
0, GFP_ATOMIC);
> > +               ocqe =3D io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
> >                 filled =3D io_cqring_add_overflow(ctx, ocqe);
> >         }
> >         io_cq_unlock_post(ctx);
> > @@ -833,8 +837,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 us=
er_data, s32 res, u32 cflags)
> >
> >         if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
> >                 struct io_overflow_cqe *ocqe;
> > +               struct io_cqe cqe =3D io_init_cqe(user_data, res, cflag=
s);
> >
> > -               ocqe =3D io_alloc_ocqe(ctx, user_data, res, cflags, 0, =
0, GFP_KERNEL);
> > +               ocqe =3D io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
> >                 spin_lock(&ctx->completion_lock);
> >                 io_cqring_add_overflow(ctx, ocqe);
> >                 spin_unlock(&ctx->completion_lock);
> > @@ -1444,8 +1449,7 @@ void __io_submit_flush_completions(struct io_ring=
_ctx *ctx)
> >                         gfp_t gfp =3D ctx->lockless_cq ? GFP_KERNEL : G=
FP_ATOMIC;
> >                         struct io_overflow_cqe *ocqe;
> >
> > -                       ocqe =3D io_alloc_ocqe(ctx, req->cqe.user_data,=
 req->cqe.res,
> > -                                            req->cqe.flags, req->big_c=
qe.extra1,
> > +                       ocqe =3D io_alloc_ocqe(ctx, &req->cqe, req->big=
_cqe.extra1,
> >                                              req->big_cqe.extra2, gfp);
>
> If the req->big_cqe type were named, these 2 arguments could be
> combined into just &req->big_cqe.

Oops, I see you do this in the next patch. Looks good.

Best,
Caleb

