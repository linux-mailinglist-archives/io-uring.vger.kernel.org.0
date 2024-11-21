Return-Path: <io-uring+bounces-4939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2D69D51D4
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 18:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE1A8B23CCC
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8755317333A;
	Thu, 21 Nov 2024 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="AUZeXvlh"
X-Original-To: io-uring@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F94188907;
	Thu, 21 Nov 2024 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732210366; cv=none; b=Sjx4EV0AO6wogk6W3r/SoMXA5lf2fMQRGouQngRLkaCxmQmAN23ALYIzdk8Q4cXSAql0EFGRUYFP3X7XbX02SGPtfRzjCKC+t5SwBlrRyovyjVqh28xFuc7LnOAFPxUu2KKnsUGD2BwESPhyL1hdkzLUD38Q+0cPWuL+TCX3780=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732210366; c=relaxed/simple;
	bh=dGIvAVVhr1XQ+IBWwKJiytD8adIRDF3znbGFVaI1CE8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=apVXiSAF1WJu/gUMm3EeG/y1LLbn+RchCNEV1Bu+XWLGgX192h3xaQKUjZmpcIfD3h+/5zYnmIuAAOHefH/Ym0h68/K8pnjM7u1gGCsrT++gp1eWC5iuu6u5GwrEDMAkpZMu548Nw9/SkzePDORA4wjV/CLylG5QbvDsTh2BH+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=AUZeXvlh; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1732209808;
	bh=dGIvAVVhr1XQ+IBWwKJiytD8adIRDF3znbGFVaI1CE8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=AUZeXvlhRTQXOreYKQ5tM6otggSm6Vmlfpnt6jWROdE8oB9IViP6vwvSzWiBSxH3B
	 m+s13vkh7TkgT+a+wMGPI53H4oy4UB4eV3H+LH5QLoKAJvLaR/fxnklp+9E6qBAh5i
	 SHbp4BMgosdGgvJTZj/UC6b9OP4roggPYEssKGzs=
Received: by gentwo.org (Postfix, from userid 1003)
	id 8CC9B401F4; Thu, 21 Nov 2024 09:23:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 89830401EE;
	Thu, 21 Nov 2024 09:23:28 -0800 (PST)
Date: Thu, 21 Nov 2024 09:23:28 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
    Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
    Christian Brauner <brauner@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
    Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
In-Reply-To: <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
Message-ID: <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org> <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org> <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:

> Linux has supported m68k since last century.

Yeah I fondly remember the 80s where 68K systems were always out of reach
for me to have. The dream system that I never could get my hands on. The
creme de la creme du jour. I just had to be content with the 6800 and
6502 processors. Then IBM started the sick road down the 8088, 8086
that led from crap to more crap. Sigh.

> Any new such assumptions are fixed quickly (at least in the kernel).
> If you need a specific alignment, make sure to use __aligned and/or
> appropriate padding in structures.
> And yes, the compiler knows, and provides __alignof__.
>
> > How do you deal with torn reads/writes in such a scenario? Is this UP
> > only?
>
> Linux does not support (rate) SMP m68k machines.

Ah. Ok that explains it.

Do we really need to maintain support for a platform that has been
obsolete for decade and does not even support SMP?

