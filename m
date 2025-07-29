Return-Path: <io-uring+bounces-8862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E00F6B151CA
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 19:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6973D7A6280
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 17:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA70149C4D;
	Tue, 29 Jul 2025 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KG6LmSSD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1E3757EA
	for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753808485; cv=none; b=Y4nG3eFXkZ7fVzcVqSzFs3ayC/CQMuqGN0eYLGZ97pAZNgtp08MMZOqzXJ6KpX0MWyKXS7IazC1xJPkVDiX3veVIzxpLpO8NoEj2/5zmEfvBH/Rdc/OhCCYPOnZkUQcMseefviz82daq5Q6ZnavK4ZYIodBwFYSYoec4rhfnQ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753808485; c=relaxed/simple;
	bh=uLae6rGolk8xBHVpk0k+TCgO/RkNYprItl9+NHm0eIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJ3zjJusvdKy81lQg+SdYOzvuLe2Yh3AvKgFG5tSKA5PEYl85k94Yr07dT/Jg27Vaf+1JSI3LsXDm2Y750CjWeMYBZZUS+2YMfhP2Oevu5U+UFE1rpf6bvt7z49HSogoBfbHloSrFVJTas0ITIe8ab3xy9POdQ2J6CD73cO8Tz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KG6LmSSD; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24070dd87e4so5815ad.0
        for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 10:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753808483; x=1754413283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLae6rGolk8xBHVpk0k+TCgO/RkNYprItl9+NHm0eIk=;
        b=KG6LmSSDK+hyjnUs94SNNlRHnC3C9nxsijQy+ZHHQOa8scN8IdSMeh04YHwIGKLy/X
         WNl84sAa64cRHuD3AHk+C3e4Ysmvhs0/SfQnXasKoNav81aGPpM7kKYkOFPoS7eoRka8
         e+6kaJM3komxWXxdjrOlZYxPNw2W1ZGRAXF0e7pktkK4Jy49vBFWxSA+9GGAcvUYgJdt
         7p0RKs0L+1Mcsvnc7+uQbXKUZ346DK4Qh+Kh3NDRxzqSUEoOGdXi8U3fR+a3HGzlaFmL
         SYOLjVNXw7GR5dElTzge/E9Gqq29JCyN8lMjW7a1iTkaW5IHglK7pfRrxiISxCBZXkBg
         sGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753808483; x=1754413283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLae6rGolk8xBHVpk0k+TCgO/RkNYprItl9+NHm0eIk=;
        b=SQhHp3YpooABVxG04buP7sIo96TeLs5qlvfbAtAm+dJOMDDzizTdvuJlI3I/Pq1ea7
         1mcUEdYJEKGYaQl3qsaNje5DsjW9FJZP4lT1EtMrxIc2+TV58q+TMM9zBjdfTu15drxu
         BB+VWmz58+8n4sVfdfpuBITXIVmeS3l7aM13qLkUHfMLHGt8GCBUq4ThFFOqu7upZt2b
         GrAgbqID+ktgyAWA3trrdGCGv/RfwhwxGJNMSUeoHl8M5Df3jjRphB+tj6w+jDh5T4Po
         O8A5rE743268t62Iumw//e4pzGp9rNbAr7I2V4L7VntvFgvVQVWvQTHgfRdl+j7k4PnD
         qJVw==
X-Forwarded-Encrypted: i=1; AJvYcCX0/GovGR0HcnbS+YnQbSRQU45SUh9EEmEitlqQrecWfKhKRV/DWYcJikdHtEUTda9VIBasQzVtlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCw8PFTbkHdmBi4Z4lsKY2SId+kHBl8xPEqnZ+0EWJ/Ax3RbnE
	8lQ2l7RTnaHWPZeTzRfv0PI2oD5OzUGtS7wfWM6knEp+koSq1w6pxw8EHS0oI6nm2kkj5o7heBB
	GWJOgJDsbcE1IA9JsngClSH43cFy1f1VuwJ6vqvjA
X-Gm-Gg: ASbGncu+9sfZNQn2k+0hBqwiVPMSlkD/gjIBEXNSw0wGM2nQyRqB3MaeNBk17GMn1T5
	x9rl30qFpFLCJoLoN9DRguFt7GQerJ3qU/04Hau2IeFwq6xYiuKT5zp8MQSaD/7JTNGpCpg5Xxc
	lE8ijRF33yKG7Lw7X3h/lci7pfE5haD8hFog/qKasIAincFU9aMAM01SLUiQm8F9MXTuGyOTyA/
	iaE1PS70EfvtxPqZu4A+8nrXM3pxaXhj/nrwg==
X-Google-Smtp-Source: AGHT+IH/aIePrtO3DxKPZfMv5xT5hgN2m1/8dW+fivE+rpVDY5hycH/CbbQptXJfzcn/03b0x58bdoKkBVaXd0RCIyo=
X-Received: by 2002:a17:903:41c1:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-2406789c4c3mr4393805ad.8.1753808482526; Tue, 29 Jul 2025
 10:01:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com> <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com> <aIf0bXkt4bvA-0lC@mini-arch>
 <CAHS8izPLxAQn7vK1xy+T2e+rhYnp7uX9RimEojMqNVpihPw4Rg@mail.gmail.com> <aIj5nuJJy1FVqbjC@mini-arch>
In-Reply-To: <aIj5nuJJy1FVqbjC@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 29 Jul 2025 10:01:09 -0700
X-Gm-Features: Ac12FXy8tZ7XbjPhzDO9LU7INNX5RkKHJldwZGYBjM7YamieRaoD_r2_UGXNfKQ
Message-ID: <CAHS8izOh=ix30qQYDofSPG8byGDf1CDKKAdHU2WCovTMUe3oaw@mail.gmail.com>
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, 
	horms@kernel.org, davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 9:41=E2=80=AFAM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 07/28, Mina Almasry wrote:
> > On Mon, Jul 28, 2025 at 3:06=E2=80=AFPM Stanislav Fomichev <stfomichev@=
gmail.com> wrote:
> > >
> > > On 07/28, Pavel Begunkov wrote:
> > > > On 7/28/25 21:21, Stanislav Fomichev wrote:
> > > > > On 07/28, Pavel Begunkov wrote:
> > > > > > On 7/28/25 18:13, Stanislav Fomichev wrote:
> > > > ...>>> Supporting big buffers is the right direction, but I have th=
e same
> > > > > > > feedback:
> > > > > >
> > > > > > Let me actually check the feedback for the queue config RFC...
> > > > > >
> > > > > > it would be nice to fit a cohesive story for the devmem as well=
.
> > > > > >
> > > > > > Only the last patch is zcrx specific, the rest is agnostic,
> > > > > > devmem can absolutely reuse that. I don't think there are any
> > > > > > issues wiring up devmem?
> > > > >
> > > > > Right, but the patch number 2 exposes per-queue rx-buf-len which
> > > > > I'm not sure is the right fit for devmem, see below. If all you
> > > >
> > > > I guess you're talking about uapi setting it, because as an
> > > > internal per queue parameter IMHO it does make sense for devmem.
> > > >
> > > > > care is exposing it via io_uring, maybe don't expose it from netl=
ink for
> > > >
> > > > Sure, I can remove the set operation.
> > > >
> > > > > now? Although I'm not sure I understand why you're also passing
> > > > > this per-queue value via io_uring. Can you not inherit it from th=
e
> > > > > queue config?
> > > >
> > > > It's not a great option. It complicates user space with netlink.
> > > > And there are convenience configuration features in the future
> > > > that requires io_uring to parse memory first. E.g. instead of
> > > > user specifying a particular size, it can say "choose the largest
> > > > length under 32K that the backing memory allows".
> > >
> > > Don't you already need a bunch of netlink to setup rss and flow
> > > steering? And if we end up adding queue api, you'll have to call that
> > > one over netlink also.
> > >
> >
> > I'm thinking one thing that could work is extending bind-rx with an
> > optional rx-buf-len arg, which in the code translates into devmem
> > using the new net_mp_open_rxq variant which not only restarts the
> > queue but also sets the size. From there the implementation should be
> > fairly straightforward in devmem. devmem currently rejects any pp for
> > which pp.order !=3D 0. It would need to start accepting that and
> > forwarding the order to the gen_pool doing the allocations, etc.
>
> Right, that's the logical alternative, to put that rx-buf-len on the
> binding to control the size of the niovs. But then what do we do with
> the queue's rx-buf-len? bnxt patch in the series does
> page_pool_dev_alloc_frag(..., bp->rx_page_size). bp->rx_page_size comes
> from netlink. Does it need to be inherited from the pp in the devmem
> case somehow?

I need to review the series closely, but the only thing that makes
sense to me off the bat is that the rx-buf-len option sets the
rx-buf-len of the queue as if you called the queue-set API in a
separate call (and the unbind would reset the value to default).

--=20
Thanks,
Mina

