Return-Path: <io-uring+bounces-3609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5251899ACF9
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 21:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C581C1F218D7
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8CF1D096A;
	Fri, 11 Oct 2024 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkYW/LNB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F141D0B97
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 19:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728675815; cv=none; b=HRslO+3Q3qBXaKPbJx0yBbg6ybnsGasGR+nJj/hyVfBKDtL+bOqTzYqFRr1BHheu1MYPZcUfjGCx/Uc6tsOtQMsTTLghwuqVRon9wigvVyCiuopQMeTMJiqxRLYihVK6UynjleDDLOwu3NExitxYqq673Sk5XglJqP8/lWdJ4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728675815; c=relaxed/simple;
	bh=mzmV0kIqsQSvgPiGmvkdjHt5MXHoDPX4WNUsHSIQc+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVfEIJtxuHS1wKZH/4HE7JUYtfM9sK3bE4q3JeQfIDxobcHwFYBXoPjOD5TwT8HWx6nNZ21lChPh8XOVhM1AlvJAqvopq1tQ+M/nQXofTdlSWz54Nxb6ds8k5Ve+13NT1zZr2nHqRJB1JSAp+i9QsorDlZkrJLO+2oMJfxF+X5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WkYW/LNB; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4601a471aecso36201cf.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 12:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728675813; x=1729280613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8aKmHCSS3L9XsKUJXszFzQRwAh0eCAqNpyEV0GDYtQ=;
        b=WkYW/LNBlmXosBS/1Jb2TXISUAK8foUdnP8Xau5hj7I1+Koxi5vBipFwyf0/Vjz1kS
         ndhAzSuDGn+6f9jMnr6UKJWRXAoAURHYmrE2WKyWV4N490tpDYrHO1Ew2qqqbAmzcBL3
         aaDDarj3dzRbB5G6Wf0b8PgaxOi+WStZJ38LrCgVr8j2vkHceWMkOTb1P3iFrN8gaDPf
         ExryHElHzQA3EDA7dX+UZOW7A2pFE7uNmdNGn1DohPmpuIR9GHt49QaRUUTzyyrUNoR/
         IgH3fqOrOAKuYG5kAtSXXVOdh29bHuULoGP90dI/tHN/2QxpqS4DkTUH+mzYNXf9r6ks
         RGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728675813; x=1729280613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8aKmHCSS3L9XsKUJXszFzQRwAh0eCAqNpyEV0GDYtQ=;
        b=XGKbFDBwUIRzINKciNSUX2jEBd4OL5GxUf7x1yE1bFGwGqIMDctokqjAjHSBZIZbed
         hgDIvet6CxEe7FU033w/Woy/hk6Qk+aY+I0xKt6U4CUfIAIB3l0MN/H3uD0OQVHGy5eB
         P0jtzoxm2hTmrX4/ylyOjU1x9GhOsxJqm0lGxn2FkOgljyOeKMm2gQIT3MexMlXqzcwy
         /A1CIwPqPWK2EMENbgw0H0Ty8J9H+0gTdw8Ge3lA2a9uUKBf+M763hsYKnt7lqJlFxqM
         9dUpFbCNWNDL9eTzgWLPeeBJp9E3CxouLa+GUj4gKLoXywhx4QfvVtvC4Hl6E76gwZWe
         I4Og==
X-Gm-Message-State: AOJu0Yy1+Ss29NBoIMVcskP2FTZ3CRDG6XMPLSPcLNzWtA3zJScGcq8I
	+NVeFLj5egck+8m28X1hAOUamkhn6sxwsqGcjOkfrOkxFOuAK9DvUeldWVOnJ7Icugajk7q219R
	8doBzOTH/OPcbfbmS9WQ46tCgx4tVIanKg21g
X-Google-Smtp-Source: AGHT+IHkuVvJu1ig47G8/afd61nNrRzRVVbfp3CneAZn3uG2ke3Tz6gYI2hMRS5aXwCgcUVCnwAHMDmhhjrnQELJFKo=
X-Received: by 2002:ac8:6312:0:b0:45e:fea6:a3b1 with SMTP id
 d75a77b69052e-460590471fbmr579901cf.19.1728675812770; Fri, 11 Oct 2024
 12:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <73637a66-e7f7-4ba6-a16e-c2ccb43735d6@davidwei.uk>
In-Reply-To: <73637a66-e7f7-4ba6-a16e-c2ccb43735d6@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 11 Oct 2024 12:43:20 -0700
Message-ID: <CAHS8izMDvL+A_1HUC1LXgMC5kK3uitaB_Ye=oMRDtV5C-skc3Q@mail.gmail.com>
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 5:29=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> On 2024-10-09 09:55, Mina Almasry wrote:
> > On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote=
:
> >>
> >> This patchset adds support for zero copy rx into userspace pages using
> >> io_uring, eliminating a kernel to user copy.
> >>
> >> We configure a page pool that a driver uses to fill a hw rx queue to
> >> hand out user pages instead of kernel pages. Any data that ends up
> >> hitting this hw rx queue will thus be dma'd into userspace memory
> >> directly, without needing to be bounced through kernel memory. 'Readin=
g'
> >> data out of a socket instead becomes a _notification_ mechanism, where
> >> the kernel tells userspace where the data is. The overall approach is
> >> similar to the devmem TCP proposal.
> >>
> >> This relies on hw header/data split, flow steering and RSS to ensure
> >> packet headers remain in kernel memory and only desired flows hit a hw
> >> rx queue configured for zero copy. Configuring this is outside of the
> >> scope of this patchset.
> >>
> >> We share netdev core infra with devmem TCP. The main difference is tha=
t
> >> io_uring is used for the uAPI and the lifetime of all objects are boun=
d
> >> to an io_uring instance.
> >
> > I've been thinking about this a bit, and I hope this feedback isn't
> > too late, but I think your work may be useful for users not using
> > io_uring. I.e. zero copy to host memory that is not dependent on page
> > aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.
> >
> > If we refactor things around a bit we should be able to have the
> > memory tied to the RX queue similar to what AF_XDP does, and then we
> > should be able to zero copy to the memory via regular sockets and via
> > io_uring. This will be useful for us and other applications that would
> > like to ZC similar to what you're doing here but not necessarily
> > through io_uring.
>
> Using io_uring and trying to move away from a socket based interface is
> an explicit longer term goal. I see your proposal of adding a
> traditional socket based API as orthogonal to what we're trying to do.
> If someone is motivated enough to see this exist then they can build it
> themselves.
>

Yes, that was what I was suggesting. I (or whoever interested) would
build it ourselves. Just calling out that your bits to bind umem to an
rx-queue and/or the memory provider could be reused if it is re-usable
(or can be made re-usable). From a quick look it seems fine, nothing
requested here from this series. Sorry I made it seem I was asking you
to implement a sockets extension :-)

> >
> >> Data is 'read' using a new io_uring request
> >> type. When done, data is returned via a new shared refill queue. A zer=
o
> >> copy page pool refills a hw rx queue from this refill queue directly. =
Of
> >> course, the lifetime of these data buffers are managed by io_uring
> >> rather than the networking stack, with different refcounting rules.
> >>
> >> This patchset is the first step adding basic zero copy support. We wil=
l
> >> extend this iteratively with new features e.g. dynamically allocated
> >> zero copy areas, THP support, dmabuf support, improved copy fallback,
> >> general optimisations and more.
> >>
> >> In terms of netdev support, we're first targeting Broadcom bnxt. Patch=
es
> >> aren't included since Taehee Yoo has already sent a more comprehensive
> >> patchset adding support in [1]. Google gve should already support this=
,
> >
> > This is an aside, but GVE supports this via the out-of-tree patches
> > I've been carrying on github. Uptsream we're working on adding the
> > prerequisite page_pool support.
> >
> >> and Mellanox mlx5 support is WIP pending driver changes.
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> Performance
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Test setup:
> >> * AMD EPYC 9454
> >> * Broadcom BCM957508 200G
> >> * Kernel v6.11 base [2]
> >> * liburing fork [3]
> >> * kperf fork [4]
> >> * 4K MTU
> >> * Single TCP flow
> >>
> >> With application thread + net rx softirq pinned to _different_ cores:
> >>
> >> epoll
> >> 82.2 Gbps
> >>
> >> io_uring
> >> 116.2 Gbps (+41%)
> >>
> >> Pinned to _same_ core:
> >>
> >> epoll
> >> 62.6 Gbps
> >>
> >> io_uring
> >> 80.9 Gbps (+29%)
> >>
> >
> > Is the 'epoll' results here and the 'io_uring' using TCP RX zerocopy
> > [1]  and io_uring zerocopy respectively?
> >
> > If not, I would like to see a comparison between TCP RX zerocopy and
> > this new io-uring zerocopy. For Google for example we use the TCP RX
> > zerocopy, I would like to see perf numbers possibly motivating us to
> > move to this new thing.
>
> No, it is comparing epoll without zero copy vs io_uring zero copy. Yes,
> that's a fair request. I will add epoll with TCP_ZEROCOPY_RECEIVE to
> kperf and compare.
>

Awesome to hear. For us, we do use TCP_ZEROCOPY_RECEIVE (with
sockets), so I'm unsure how much benefit we'll see if we use this.
Comparing against TCP_ZEROCOPY_RECEIVE will be more of an
apple-to-apple comparison and also motivate folks using the old thing
to switch to the new-thing.

--=20
Thanks,
Mina

