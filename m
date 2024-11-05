Return-Path: <io-uring+bounces-4467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D07839BD9C8
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 00:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD9E1F21B9A
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 23:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FC5216A29;
	Tue,  5 Nov 2024 23:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NxD6jaTR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CD6216A25
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 23:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730849707; cv=none; b=YUPXDRDQOCgdvo2671x7Yy9xV/7ty5RbaqCVwKiCtWZGzK+nAPEyHsi5wC/FLgaYDhdTYnK8cCBhRrOhqO70lTRpKccdf7JApU8qyCGZplVPlS5yaBgVHLw6izxHPiDA9NRATavmFBzQjmbH/tcXwpYdS0YZ9z+sjO9WPIxr2Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730849707; c=relaxed/simple;
	bh=YPV2zqIfO0KUsVG4Swj9gWwsaLWIUfQNhYXqN6D1kDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rEashr45VHre9xsc6EjDeLX1H+hCLsBPMAkTtKjbig2B9lwpNyuGqtc1Ug5JttQY0rGrMggV2p1tJ5LpnlaCncgBRKK5zlwuJJD6r1tYVFQXwwX/ppnhGJppwUkg0dLV+BmIBwI4mQYBm8GdGJ+bS5s3z/cawiY+5oEL/lcyK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NxD6jaTR; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-460b295b9eeso51931cf.1
        for <io-uring@vger.kernel.org>; Tue, 05 Nov 2024 15:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730849704; x=1731454504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdkKiFfjUh58uMELKuxiyeBM+nPzy1PB0oT4sk31ViA=;
        b=NxD6jaTRfDUZq9ElyBciTQqEtBrG/1rMpx1SNJwtzFtaA8FsBHhOKsIowPO9uLY2/M
         ZVyfsFhA0i8iurqgcdeUtbIL98M2+kqFkW1QiYn4LXzpFKe9rnys3hA3qzgck3OiThjw
         z5304FhIAmbKiH4coP6EieRhNxgnC7DsssSbB+hYmyLBLSsZezQGu87Quv6ih9CN+UK8
         bjVmqH2LmcNTeTIDe5R0Dx1q6l3V10U0033H6DJ8haHJW8m8v3OL5KGsCr01t+EuOrhA
         b19TPdMgcxXjyC9+fszBSJPfEBhV/GaCGXlnskD13FtHc0jQ7TW+VN4z4rSlSyx5FSPa
         G2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730849704; x=1731454504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdkKiFfjUh58uMELKuxiyeBM+nPzy1PB0oT4sk31ViA=;
        b=Dl+7iwXyU6OdAo8rrWcLCAqLWt73wJljUnnuKc3MiksJ+B+OrfXxraM+C0J4OjV206
         35qs2DE5l7Zc+rOm3AweBjYWhwX+NqfkVM3JM+RxiOlVGW1DC3/UAKzkVmiqZ7d8tBcf
         w44Z2euVKB9x3ICQTcHxACqbA2wIFFjn6XobvaZsij5H0F7HrLZTHiYzKa2+d7Re1c2Z
         PVRtVjgGPpxGyjOrUHUeZk110TmtQBIf5bdatFE164TWAm1B/esRIhE8apF2SFBKuufL
         y8Askapeq/ty2dPW4tzubaTRiFhVwheDHNafiKO1Y9maLvOKrzoGAHb88xjgUEHtPSU6
         uqfg==
X-Forwarded-Encrypted: i=1; AJvYcCUGGmrcEujztpSMO7oAFXdYqRWUD1N7A915tnw8KIz4OTh9i38UWo3KeEYqMw42Z0N0iy0rCf+SNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPnoqVqbEj59VvDXPY9F++gnKVg76KO5PP2eELKz6nLeFDKuXF
	RBZGBaO2Q2hWQ8gKpVfYLb+PBMbG9RsudkUU4+zAtLZTlfhyVa6NVuRqEQJ1jcCBl5/kw3Phm1u
	C846+/Y5K0YXn32xdvwMrzqckgboGcWVHNT2J
X-Gm-Gg: ASbGncvzQycAjHTW5SHRPKSh84oJtEdu7mcxOcGnBlyb4DabMqObOxEMl8RKNt8yGbx
	KRlC3OHPt9CWnT6JtC6PkLmduEMmrT1U=
X-Google-Smtp-Source: AGHT+IEC6hnUtd4L4GCI+OtP4rYAaDhekAq6BDTWOnnwKgZoKWHO16drMmP82vo1E7mgxI22HNzwwfAWcZ1EO1C1HKc=
X-Received: by 2002:ac8:570a:0:b0:460:48f1:5a49 with SMTP id
 d75a77b69052e-462f014b1b9mr1146061cf.14.1730849704182; Tue, 05 Nov 2024
 15:35:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-7-dw@davidwei.uk>
 <CAHS8izMkpisFO1Mx0z_qh0eeAkhsowbyCqKqvcV=JkzHV0Y2gQ@mail.gmail.com> <2928976c-d3ea-4595-803f-b975847e4402@gmail.com>
In-Reply-To: <2928976c-d3ea-4595-803f-b975847e4402@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 5 Nov 2024 15:34:51 -0800
Message-ID: <CAHS8izOuP6FDFNtEVOQeNnPmAXuqaYaokjkQCVX0SOzcwDM3xg@mail.gmail.com>
Subject: Re: [PATCH v7 06/15] net: page pool: add helper creating area from pages
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 11:16=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 11/1/24 17:33, Mina Almasry wrote:
> > On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrot=
e:
> >>
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> Add a helper that takes an array of pages and initialises passed in
> >> memory provider's area with them, where each net_iov takes one page.
> >> It's also responsible for setting up dma mappings.
> >>
> >> We keep it in page_pool.c not to leak netmem details to outside
> >> providers like io_uring, which don't have access to netmem_priv.h
> >> and other private helpers.
> >>
> >
> > I honestly prefer leaking netmem_priv.h details into the io_uring
> > rather than having io_uring provider specific code in page_pool.c.
>
> Even though Jakub didn't comment on this patch, but he definitely
> wasn't fond of giving all those headers to non net/ users. I guess
> I can't please everyone. One middle option is to make the page
> pool helper more granular, i.e. taking care of one netmem at
> a time, and moving the loop to io_uring, but I don't think it
> changes anything.
>

My issue is that these:

+int page_pool_mp_init_paged_area(struct page_pool *pool,
+                               struct net_iov_area *area,
+                               struct page **pages);
+void page_pool_mp_release_area(struct page_pool *pool,

Are masquerading as generic functions to be used by many mp but
they're really io_uring specific. dmabuf and the hugepage provider
would not use them AFAICT. Would have liked not to have code specific
to one mp in page_pool.c, and I was asked to move the dmabuf specific
functions to another file too IIRC.

These helpers depend on:

page_pool_set_pp_info: in netmem_priv.h
net_iov_to_netmem(niov): in netmem.h
page_pool_dma_map_page: can be put in page_pool/helpers.h?
page_pool_release_page_dma(pool, netmem):  can be put in page_pool/helpers.=
h?

I would prefer moving page_pool_set_pp_info (and the stuff it calls
into) to netmem.h and removing io_uring mp specific code from
page_pool.c.

> ...
> >>   #include <linux/dma-direction.h>
> >> @@ -459,7 +460,8 @@ page_pool_dma_sync_for_device(const struct page_po=
ol *pool,
> >>                  __page_pool_dma_sync_for_device(pool, netmem, dma_syn=
c_size);
> >>   }
> >>
> >> -static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netm=
em)
> >> +static bool page_pool_dma_map_page(struct page_pool *pool, netmem_ref=
 netmem,
> >> +                                  struct page *page)
> >
> > I have to say this is confusing for me. Passing in both the netmem and
> > the page is weird. The page is the one being mapped and the
> > netmem->dma_addr is the one being filled with the mapping.
>
> the page argument provides a mapping, the netmem gives the object
> where the mapping is set. netmem could be the same as the page
> argument, but I don't think it's inherently wrong, and it's an
> internal helper anyway. I can entirely copy paste the function, I
> don't think it's anyhow an improvement.
>
> > Netmem is meant to be an abstraction over page. Passing both makes
> > little sense to me. The reason you're doing this is because the
> > io_uring memory provider is in a bit of a weird design IMO where the
> > memory comes in pages but it doesn't want to use paged-backed-netmem.
>
> Mina, as explained it before, I view it rather as an abstraction
> that helps with finer grained control over memory and extending
> it this way, I don't think it's such a stretch, and it doesn't
> change much for the networking stack overall. Not fitting into
> devmem TCP category doesn't make it weird.
>
> > Instead it uses net_iov-backed-netmem and there is an out of band page
> > to be managed.
> >
> > I think it would make sense to use paged-backed-netmem for your use
> > case, or at least I don't see why it wouldn't work. Memory providers
>
> It's a user page, we can't make assumptions about it, we can't
> reuse space in struct page like for pp refcounting (unlike when
> it's allocated by the kernel), we can't use the normal page
> refcounting.
>

You actually can't reuse space in struct net_iov either for your own
refcounting, because niov->pp_ref_count is a mirror to
page->pp_ref_count and strictly follows the patterns of that. But
that's the issue to be discussed on the other patch...

> If that's the direction people prefer, we can roll back to v1 from
> a couple years ago, fill skbs fill user pages, attach ubuf_info to
> every skb, and whack-a-mole'ing all places where the page could be
> put down or such, pretty similarly what net_iov does. Honestly, I
> thought that reusing common infra so that the net stack doesn't
> need a different path per interface was a good idea.
>

The common infra does support page-backed-netmem actually.

> > were designed to handle the hugepage usecase where the memory
> > allocated by the provider is pages. Is there a reason that doesn't
> > work for you as well?
> >
> > If you really need to use net_iov-backed-netmem, can we put this
> > weirdness in the provider? I don't know that we want a generic-looking
> > dma_map function which is a bit confusing to take a netmem and a page.>
> ...
> >> +
> >> +static void page_pool_release_page_dma(struct page_pool *pool,
> >> +                                      netmem_ref netmem)
> >> +{
> >> +       __page_pool_release_page_dma(pool, netmem);
> >> +}
> >> +
> >
> > Is this wrapper necessary? Do you wanna rename the original function
> > to remove the __ instead of a adding a wrapper?
>
> I only added it here to cast away __always_inline since it's used in
> a slow / setup path. It shouldn't change the binary, but I'm not a huge
> fan of leaving the hint for the code where it's not needed.
>

Right, it probably makes sense to make the modifications you want on
the original function rather than create a no-op wrapper to remove the
__always_inline.


--
Thanks,
Mina

