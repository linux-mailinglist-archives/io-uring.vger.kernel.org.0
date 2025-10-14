Return-Path: <io-uring+bounces-10014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3FBBDB1B9
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 21:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88863189E02E
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 19:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062BD2BDC3E;
	Tue, 14 Oct 2025 19:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="E5iNAU7o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9B27280E
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 19:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471194; cv=none; b=BFF9d9NOsJWv0NmmUvN5GvP9N0h+Wt8Su8fB6vkoo29tkIcbqKuTogntphofQfub0aYtogmLOUrNWNokEULwDn1Yyvwv6JIbqCLC6a0KA/LFNPrvmZ2eQMNw1u0iSp0yIqtUacKeUz9babGZqw0HKt0reo6b7PchImqDWo2s5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471194; c=relaxed/simple;
	bh=UlpDjOuIyerOLWuhlXg7Mn+RuK3HflnMsXIq0CnRb40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GOS1Cp/eKy3WiX1jV023nootkPycCHPSnnzlPDHhEdbNGBxyk4ZUyZHar7NO2PLLxIevxiETm8tcWGqw1wNBW83st/f16hTMVH3CeCSOklqn90mnjkFh++QnZZVOgsJh0HtFfg3TUHEtYhTZ/jyW+jqfFwwfgDPZ13v9EOmuDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=E5iNAU7o; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2698d47e6e7so10122695ad.2
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 12:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760471192; x=1761075992; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGYl1WR9acUUF4C0G0u/NEeb7FRkYvo0I6E8KUdRHUQ=;
        b=E5iNAU7o8gMlfcYfsE4GvMD2UXBaahEPzhAzLpdmUwnNnnx+HIGVbmX7QrG3fTlwSJ
         nfbx+pUo0fNHnFg/TSaNpQLduEWsOb77qVO97Q7I7JoyVBzJH6lYgarPqKngx3ESzaCa
         yGhIu8IKTHniSpaVa9AuObg5jHxFZxfwoDrgxWoZ6NI5FilioSEzkuxrPhYFIMSGgZYi
         CeUAxZIGEiAy68w5jbIllBbCR8vOndXEKTrSZvb07VHGapQ3quDDCMHs9F6WIql/Cz5D
         TWZwkLIErXqU5XyBl5mQ7ib2MkBpkwcygpvDS0Tff2vsH8hzGNHkzO2llPfibLxbUl9G
         8XSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760471192; x=1761075992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGYl1WR9acUUF4C0G0u/NEeb7FRkYvo0I6E8KUdRHUQ=;
        b=G/yOsBF1aqhfJXnruiD8eJmPdpeRVgcR/bawLYeAhx+YZzYG7C4jpl3SJO+9EAR9Q1
         gjbV9ZkzWF1Is6pwKSrnkrbiclCKspps36aPIqKDFi5qyVq2SRzHM16u38mZsXXHMIDY
         O0EJhnUktYrvfEihi2mDuml78vcnO7W1H6XH4uKkeS4xTc13ty4ZVVHe/kOV3BBHb0G8
         2pVz5K18GXFn0QvVXzz20lF/EOOXodoMzNOfz9mKFWeMDq4bnzKCq0sGcwKFeExZYCcI
         3mzMoI9EGfCRAlcDnftos/nTJQiQ6G2PZ/OKlBwyEIr0eTeu8bYPLCwpiqni6s8dmzBf
         coaA==
X-Gm-Message-State: AOJu0YwIoeR/YqcenUYYY1KLuLMXkhmNAm/9xzPegZ3g1eY4PQUoXkJE
	jwhIxMHGM92KhJ3nuEJYlcFcJCLCCOqbOFPWrbqFzXgT9RVDSZsV8k5DIAEpAH1oAeSQT9w5jQ+
	GxwYfXKg64e38ASrWo7LzAa5x9Pb3l9Rck0dUCHshnwkFQa8DL8Ipb/I=
X-Gm-Gg: ASbGncukVi3cq/UibxMyU/nHPVm4rfJ2PIKimmYAlI0AvMGmj17RUOY8XAbUxQ06efU
	nbp8eoc1MqaAXS8I+Eq9+huhx/aOqzS0KK6s1iO685Hdxjb8AgPLZleM7HA3eCHOnB5B3N5Fs7z
	3NMZNemWwgJtnm+33yn4imHTIml+q0zsJzNayDH5gTl49QvsuGCyUr4rWwtrE3tt8RCmv2noA/E
	jlihG2DfAvGRvl9DgUtIE3cMAPmk9rQ8H9EOOo06aB9YrXFiWCmnrD0nzzjDh3qpN/tzg==
X-Google-Smtp-Source: AGHT+IGyvBggw8ZgXJEVoWBnDirrgMRz+LHGJaSsUSi6KrqiIBw3DlP/HzEMmkywpp0HTSDKZogl50tPSwGf5F9Ge5c=
X-Received: by 2002:a17:902:c404:b0:277:c230:bfca with SMTP id
 d9443c01a7336-290273e17bfmr191524405ad.4.1760471192212; Tue, 14 Oct 2025
 12:46:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760438982.git.asml.silence@gmail.com> <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
 <CADUfDZqXmmG+_9ENc6tJ4RRQ5L4_UKhWxZd3O5YGQP7tNo2iHg@mail.gmail.com> <fdff4e0c-0d26-4e19-8671-1f98e1c526a6@gmail.com>
In-Reply-To: <fdff4e0c-0d26-4e19-8671-1f98e1c526a6@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 14 Oct 2025 12:46:20 -0700
X-Gm-Features: AS18NWBwmzPP-fKXV7KT8NeQWoBRLfvEze7JOaQdhN61saEbfI7gdsnAp9hBkTw
Message-ID: <CADUfDZqVG6sd-VChW3CxM+dgY7t7MRg3mqth038P0aYjjCsycA@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 12:25=E2=80=AFPM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 10/14/25 19:37, Caleb Sander Mateos wrote:
> > On Tue, Oct 14, 2025 at 3:57=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> ...>> + * SQEs always start at index 0 in the submission ring instead of =
using a
> >> + * wrap around indexing.
> >> + */
> >> +#define IORING_SETUP_SQ_REWIND         (1U << 19)
> >
> > Keith's mixed-SQE-size patch series is already planning to use this
> > flag: https://lore.kernel.org/io-uring/20251013180011.134131-3-kbusch@m=
eta.com/
>
> I'll rebase it as ususual if that gets merged before.
> >> -       /*
> >> -        * Ensure any loads from the SQEs are done at this point,
> >> -        * since once we write the new head, the application could
> >> -        * write new data to them.
> >> -        */
> >> -       smp_store_release(&rings->sq.head, ctx->cached_sq_head);
> >> +       if (ctx->flags & IORING_SETUP_SQ_REWIND) {
> >> +               ctx->cached_sq_head =3D 0;
> >
> > The only awkward thing about this interface seems to be if
> > io_submit_sqes() aborts early without submitting all the requested
> > SQEs. Does userspace then need to memmove() the remaining SQEs to the
> > start of the ring? It's certainly an unlikely case but something
> > userspace has to handle because io_alloc_req() can fail for reasons
> > outside its control. Seems like it might simplify the userspace side
> > if cached_sq_head wasn't rewound if not all SQEs were consumed.
> This kind of special rules is what usually makes interfaces a pain to
> work with. What if you want to abort all un-submitted requests
> instead? You can empty the queue, but then the next syscall will
> still start from the middle. Or what if the application wants to
> queue more requests before resubmitting previous ones? There are
> reasons b/c the kernel will need to handle it in a less elegant way
> than it potentially can otherwise. memmove sounds appropriate.

Maybe most convenient would be a way for userspace to pass both a head
and a nr/tail value to the syscall instead of assuming the head is
always 0. But it's probably difficult to modify the existing syscall
interface without an indirection to the head value, which seems to be
a main point of this series. So always resetting to 0 and requiring
userspace to memmove() the remaining SQEs in the rare case that
io_uring_enter() doesn't consume all of them seems like a reasonable
approach.

>
> >> @@ -3678,6 +3687,12 @@ static int io_uring_sanitise_params(struct io_u=
ring_params *p)
> >>   {
> >>          unsigned flags =3D p->flags;
> >>
> >> +       if (flags & IORING_SETUP_SQ_REWIND) {
> >> +               if ((flags & IORING_SETUP_SQPOLL) ||
> >> +                   !(flags & IORING_SETUP_NO_SQARRAY))
> >
> > Is there a reason IORING_SETUP_NO_SQARRAY is required? It seems like
> > the implementation would work just fine with the SQ indirection ring;
> > the rewind would just apply to the indirection ring instead of the SQE
> > array. The cache hit rate benefit would probably be smaller since many
> > more SQ indirection entries fit in a single cache line, but I don't
> > see a reason to explicitly forbid it.
>
> B/c I don't care about sqarray setups, they are on the way out for soft
> deprecation with liburing defaulting to NO_SQARRAY, and once you try
> to optimise the kernel IORING_SETUP_SQ_REWIND handling it might turn
> out that !NO_SQARRAY is in the way... or not, but you can always allow
> it later while limiting it would break uapi. In short, it's weighting
> chances of (micro) optimisations in the future vs supporting a case
> which is unlikely going to be used.

Fair point, tradeoffs either way.

Best,
Caleb

>
> --
> Pavel Begunkov
>

