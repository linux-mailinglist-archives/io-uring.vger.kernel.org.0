Return-Path: <io-uring+bounces-4705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0AD9C938D
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 21:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E8661F215FA
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 20:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8EE1ABED9;
	Thu, 14 Nov 2024 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z+1GKWE8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E81ABEC6
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731617789; cv=none; b=MrOjwjktr5ENM6sF+L3V8A80tGwtc+29ufF+PeyR8IF0dNk7bvgh3Y+LorG9ePDuNdgF1BLdccNV2cSzPfq+ahoUUdg7E57Slq0EVxN7A8cggMUFqU796vnGFhrg1QnAetf5iRKpds8BdOYv+Gg8dKa+AGI65P+9VYGxk4CqBSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731617789; c=relaxed/simple;
	bh=gvaNuFGod3IE9HBoY5V/2n10VBY4eB7XY/0Px1Z9+/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cL//seh+6hsdoXUBQUvvAIu2OFdYgrkS6W1m3Ba9KC0/WoKDRjt2yxMsgJMhWmcqkPaA5jD0e7A9Wf7LkuZR+hvnLXPkuadbWdzXib+iQwkUt7m6MuWL/tJVZToodqwzYM84znxd4+zCS26DRr8ROcRo7m633hDwpkvdVGJQ7z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z+1GKWE8; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4608dddaa35so84031cf.0
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 12:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731617787; x=1732222587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvaNuFGod3IE9HBoY5V/2n10VBY4eB7XY/0Px1Z9+/0=;
        b=z+1GKWE8M1TJUJMEg7sZgUGrxiXTNGThRjZQC8Y9miGmAYsz+iI7MGMYLzUbyyKUjR
         GkZx0z9RYTnLlAkPQFrUODwm5BBxNuklvhhIWyeMtgA0clhzV2KTS8i8iT2SUhcfgOvU
         saSUDDFnTEnR1/HXsBA3ekjYye0PiZoXqXX/MIjXVid5ZJJTWeNlsHXUeQw8zT8JoGCL
         PPQzBUqyPoMivnRcrr6CtZ/WoE/c8IteD1b7OAeJf35/TmE26mmoNy6bhrJqWYcWvGX/
         4gMGjpZEb7yabUFcch4YUYyX8uR7xQ61iQrn7Ars4iYp7CiDqOPdp8c/J15BP0zwl3wH
         kMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731617787; x=1732222587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvaNuFGod3IE9HBoY5V/2n10VBY4eB7XY/0Px1Z9+/0=;
        b=IMjrf7BJSPXBtYk2np/spS7229OUFR4klM8sTB8uc0VlwmGmjuFkFPnhA4uSWGdvRi
         fwfbN35UkCpKZaYNwZDnkDK+r3PpCwPnA2DBQC+bUQZYpgIc5iJVqiSXTM+wl35lRZue
         sQTEwdvonTCiKvxzVzD+7VYnoq2PA8nhmes5m9+YMaVAULXCJUmnnR4tuf2/1rIr3mNF
         uvKCbtAgG+Xc616z9Aeoqw8lkar4OlrT9Z8d6Xn5bC00A7jvN951omI9wofoZ5jtbQLb
         tT2ZhHrFTr4FrtCJzR0etB2Ow17p9SuWgLVqY0CE/k4EskGIKokHPMNnyWXO22p61nJo
         Z2Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXz8VHczM+KSBuhDtMTTtYS5/brNd0lau1Tuh78sXy2G8fFsvOVUxoyicRVyo9Mp4hLyO+6mrW2PQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzebJIYV5hyfXIQkNhNOogkgDS26RTgngUplpoekEmtFGfnMybi
	J2rkdGCuemjTffSikRgaq6dQnGTvBNq7ARnXp9cp/2I3G27uHb/4G/4/KRORcfS6hNjCslciAxk
	gd0EK12RiddGsEZ9Mg98YLhT1ce31EZ8uoho0iUpQoFSYCUZcCw==
X-Gm-Gg: ASbGncs3Rwpftjti2wvD+3DsMadDesoMquGSo8y4NSmN/u50hUcXTPA7wpLwc9asRIv
	ANTJHYPlJp4DyoW+3gD90OBjrNYWJ6y8=
X-Google-Smtp-Source: AGHT+IEWJeK1a9RR60u3MigSTq7pa3Jl63a9sm3KA1A0xvKAJRFeVHzhVi8RC+EcouqTOMAKMeGk2+7U0GM0L6VOmM0=
X-Received: by 2002:a05:622a:452:b0:463:1934:f546 with SMTP id
 d75a77b69052e-463639372eamr484741cf.23.1731617786432; Thu, 14 Nov 2024
 12:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com> <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
 <9ed60db4-234c-4565-93d6-4dac6b4e4e15@davidwei.uk>
In-Reply-To: <9ed60db4-234c-4565-93d6-4dac6b4e4e15@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 14 Nov 2024 12:56:14 -0800
Message-ID: <CAHS8izND0V4LbTYrk2bZNkSuDDvm2gejAB07f=JYtCBKvSXROQ@mail.gmail.com>
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 1:15=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
> > Is it very complicated to napi_pp_put_page() niovs as the user puts
> > them in the refill queue without adding a new syscall? If so, is it
> > possible to do a niov equivalent of page_pool_put_page_bulk() of the
> > refill queue while/as you process the RX path?
> >
> > If you've tested the generic code paths to be performance deficient
> > and your recycling is indeed better, you could improve the page_pool
> > to pull netmems when it needs to like you're doing here, but in a
> > generic way that applies to the page allocator and other providers.
> > Not a one-off implementation that only applies to your provider.
> >
> > If you're absolutely set on ignoring the currently supported reffing
> > and implementing your own reffing and recycling for your use case,
> > sure, that could work, but please don't overload the
> > niov->pp_ref_count reserved for the generic use cases for this. Add
> > io_zcrx_area->io_uring_ref or something and do whatever you want with
> > it. Since it's not sharing the pp_ref_count with the generic code
> > paths I don't see them conflicting in the future.
>
> Why insist on this? Both page/niov and devmem/io_uring niov are mutually
> exclusive. There is no strong technical reason to not re-use
> pp_ref_count.
>

Conflict between devmem (specifically) and io_uring is not my concern.
My concern is possible future conflict between io_uring refcounting
and page/devmem refcounting.

Currently net_iov refcounting and page refcounting is unified (as much
as possible). net_iov->pp_ref_count is an exact mirror in usage of
page->pp_ref_count and the intention is for it to remain so. This
patch reuses net_iov->pp_ref_count in a way that doesn't really apply
to page->pp_ref_count and already some deviation in use case is
happening which may lead to conflicting requirements in the future
(and to be fair, may not).

But I've been bringing this up a lot in the past (and offering
alternatives that don't introduce this overloading) and I think this
conversation has run its course. I'm unsure about this approach and
this could use another pair of eyes. Jakub, sorry to bother you but
you probably are the one that reviewed the whole net_iov stuff most
closely. Any chance you would take a look and provide direction here?
Maybe my concern is overblown...

--
Thanks,
Mina

