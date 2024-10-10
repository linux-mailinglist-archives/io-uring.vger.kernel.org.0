Return-Path: <io-uring+bounces-3575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEC499940B
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 22:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 953352875F7
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3481E2029;
	Thu, 10 Oct 2024 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ogSuu1Bz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F044A1CEABC
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593946; cv=none; b=t9t21tmNDkkneiJWjxy5hYEUwLy2mr6EMfe0PMqVkAZ45TR9omGg46eeY5OawjfZB8+RXmXkcEsp2B3a6ceoXwsAGUgTBXPmX0mKfHwqMezqTp9IB6UlTJ0bPTYfge37MlmDy9yphwxuyNT4P3zWt78BibKzfoxwgynX0mCpT5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593946; c=relaxed/simple;
	bh=s9pcdyZ9xEY3e8lQUS9MO4s8hNmOb2nddmzlpVdUfpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mZcNBztBoIMU7WnMvcf1X5v+zdsmyeqJQzbSTuUkv+NsK49iF5nmyGOr9H6E50SF0RvIn5qU0gWSgz/anA9TyRqfuPWxWleMEk/1cnnt3B/IQnmk9kvr69mdcboYjA5o8Kwe86n73C/4PNVnMHUmrzreJ5gs6S2mZKyCh8GsoN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ogSuu1Bz; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460395fb1acso88991cf.0
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 13:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728593944; x=1729198744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9pcdyZ9xEY3e8lQUS9MO4s8hNmOb2nddmzlpVdUfpc=;
        b=ogSuu1BzO7sBGw1pckLXoUqF01mgFejdQ1bmI8IBVoTfDLPNRaH4vCtEW4tsIbBRIZ
         HcJW13/HRFqcWURt0JHhD+PpJsxQ4lTbRJvUJedmNzYTRrP1+kSplkzuwGlHrdE/xA6H
         M7yMJko5jQhKgd6qgCaLAkRW70cgm41N+WKVybwFZxB1mvmHn/UnO1tWkzeVNVkZcAx0
         vOm4fLGoEVPeBVzlxqQoveNiOVZgQEoeNbkHwD55QBuZKaA9/2o//PxuFLaR46F+ugcg
         wZnlTLG3flmGCQ5UtcqWQ1D00yr7/EjP94Nm5Kk8PZwpeJRn4K9qCA5LVttaoa23h0v1
         RefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728593944; x=1729198744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s9pcdyZ9xEY3e8lQUS9MO4s8hNmOb2nddmzlpVdUfpc=;
        b=M2nBrQk+w4ocUB0T0e32QRhffhKCox2q6dRo9HXzaASeMR4FakxB/cvgIZ40zCQ3NK
         oDvKxlHkoLLT6qQxttHtTyX7Z+PILqXcwNe149AWYSAOPdsChJ12QHGw0YlAMJno2pux
         dvr0rB/d/CV3+pRDYk9KIi3vAYXAoJRB8br20heT5m06CMjWjNvT4GP4pwpu1r5amAW2
         MaHYo0DUQMbI9evzMaqiDRTCpctcpxTGHTeu/z8dP9w5Jiek1AK1XIce/0kT+qXkHwVV
         JJ7jSZzC7Dowa2jjGmkJPF3uIqM9Z8ib7V3gXj6JQPp//Zm468Tz+4Lh+3jvBaTkfyI0
         SN1w==
X-Forwarded-Encrypted: i=1; AJvYcCUX+nr9QzHjgqajB7Zf1Hf9reEu6hl7yxb/3ZTl8HYaw6ev4OaW3L3OqmdvyX/MAOFDVXv+O5hpnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMF1oZw9ESitzrsuGjs+lXs7GBJYkgMTbaOwVVYXHUyMcBjPqV
	wHQRORDY7D0WiatZcsKDmNv0ySjuUgDyYZ0Bn+CjWMp+sZijI3TvwPZMn7CAUmT/BezxcjEOakj
	LsI64tdEygkZbbJpIhIhp/noQA470exv/IbT/
X-Google-Smtp-Source: AGHT+IF3R8R7YB9BMwW4arLIAfEe5Ep1D8pL4yiCAr9TXamF4tK2/fqoDt20lODSTwvVl2Uxw3exUPgMpvOHmkQG6Ss=
X-Received: by 2002:a05:622a:8388:b0:458:1d2b:35f6 with SMTP id
 d75a77b69052e-4604af3a4bdmr1034811cf.24.1728593943606; Thu, 10 Oct 2024
 13:59:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
 <94a22079-0858-473c-b07f-89343d9ba845@gmail.com> <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
 <f89c65da-197a-42d9-b78a-507951484759@gmail.com> <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
In-Reply-To: <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 10 Oct 2024 13:58:46 -0700
Message-ID: <CAHS8izOCLrLz-XuDq13At+wcVAJRPszSvt+ijeqi8qzxAazEAw@mail.gmail.com>
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 1:53=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> > >>>>
> > >>>> Once the user is done with the buffer processing, it must return i=
t back
> > >>>> via the refill queue, from where our ->alloc_netmems implementatio=
n can
> > >>>> grab it, check references, put IO_ZC_RX_UREF, and recycle the buff=
er if
> > >>>> there are no more users left. As we place such buffers right back =
into
> > >>>> the page pools fast cache and they didn't go through the normal pp
> > >>>> release path, they are still considered "allocated" and no pp hold=
_cnt
> > >>>> is required.
> > >>>
> > >>> Why is this needed? In general the provider is to allocate free mem=
ory
> > >>
> > >> I don't get it, what "this"? If it's refill queue, that's because
> > >> I don't like actively returning buffers back via syscall / setsockop=
t
> > >> and trying to transfer them into the napi context (i.e.
> > >> napi_pp_put_page) hoping it works / cached well.
> > >>
> > >> If "this" is IO_ZC_RX_UREF, it's because we need to track when a
> > >> buffer is given to the userspace, and I don't think some kind of
> > >> map / xarray in the hot path is the best for performance solution.
> > >>
> > >
> > > Sorry I wasn't clear. By 'this' I'm referring to:
> > >
> > > "from where our ->alloc_netmems implementation can grab it, check
> > > references, put IO_ZC_RX_UREF, and recycle the buffer if there are no
> > > more users left"
> > >
> > > This is the part that I'm not able to stomach at the moment. Maybe if
> > > I look deeper it would make more sense, but my first feelings is that
> > > it's really not acceptable.
> > >
> > > alloc_netmems (and more generically page_pool_alloc_netmem), just
> > > allocates a netmem and gives it to the page_pool code to decide
> >
> > That how it works because that's how devmem needs it and you
> > tailored it, not the other way around. It could've pretty well
> > been a callback that fills the cache as an intermediate, from
> > where page pool can grab netmems and return back to the user,
> > and it would've been a pretty clean interface as well.
> >
>
> It could have been, but that would be a much worse design IMO. The
> whole point of memory proivders is that they provide memory to the
> page_pool and the page_pool does its things (among which is recycling)
> with that memory. In this patch you seem to have implemented a
> provider which, if the page is returned by io_uring, then it's not
> returned to the page_pool, it's returned directly to the provider. In
> other code paths the memory will be returned to the page_pool.
>
> I.e allocation is always:
> provider -> pp -> driver
>
> freeing from io_uring is:
> io_uring -> provider -> pp
>
> freeing from tcp stack or driver I'm guessing will be:
> tcp stack/driver -> pp -> provider
>
> I'm recommending that the model for memory providers must be in line
> with what we do for pages, devmem TCP, and Jakub's out of tree huge
> page provider (i.e. everything else using the page_pool). The model is
> the streamlined:
>
> allocation:
> provider -> pp -> driver
>
> freeing (always):
> tcp stack/io_uring/driver/whatever else -> pp -> driver
>

Should be:

> freeing (always):
> tcp stack/io_uring/driver/whatever else -> pp -> provider

I.e. the pp frees to the provider, not the driver.

--=20
Thanks,
Mina

