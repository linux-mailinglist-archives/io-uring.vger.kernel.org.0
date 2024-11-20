Return-Path: <io-uring+bounces-4882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 339AA9D41C6
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 19:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86131F23F4E
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 18:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8F21474A5;
	Wed, 20 Nov 2024 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="kP6se4X/"
X-Original-To: io-uring@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A1012FF69;
	Wed, 20 Nov 2024 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732125771; cv=none; b=bEgsAvpu03CUNaU3fuKlLHnkRxR/QLHE9qSPkgh1813SPAmFOA2SHmUfy2UCiAj3LlWDFwdw16OYCbknwZJKoIML+bCZ/aIHPc/gZDX9PtDBc4PeegE3ERuwn1SLb7wU+fmVykvq/5eOxJRX4/SS0ZoibA8VkOjo3ozQyfycGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732125771; c=relaxed/simple;
	bh=sdW1ywqzef0DiPcYn4D+cJXKXJdd8fJAVTgMxJQcrok=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rWdHfNCXv42ngtgEqYK6L3rjT2XNSArkW1G6AyvwNtXZ6M4BDkv+a2Y0oWj4E6aPwZemb7Nsvb1Q8UK+WcjW8FbulDXGlpjZwrv/8feCyxTR5H/SOCVbdow4ytBklBLDZFFV+OBFPB7qdno5/ZFlng6s030V1d5e9Mz5O2HOhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=kP6se4X/; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1732125047;
	bh=sdW1ywqzef0DiPcYn4D+cJXKXJdd8fJAVTgMxJQcrok=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=kP6se4X/MYCnWvDfI3TBNLuGUC0edJq/nYQAEvTwAxtQOOEXff8ECn4CNZ4tXvSDY
	 1e9yiTxjsq9nVY4YzrGh46I+1gi/MHw5FrC7LM4ZUxJzDPPX/Xz0q/iLRD844O3jc7
	 sNfWtNhYjQjhIMmav/JFtu13pDSeya9rbWlRgh2s=
Received: by gentwo.org (Postfix, from userid 1003)
	id 650B1401F3; Wed, 20 Nov 2024 09:50:47 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 62C9C401F0;
	Wed, 20 Nov 2024 09:50:47 -0800 (PST)
Date: Wed, 20 Nov 2024 09:50:47 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
    Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
    Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
    Christian Brauner <brauner@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
    Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
In-Reply-To: <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
Message-ID: <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org> <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 20 Nov 2024, Vlastimil Babka wrote:

> >
> > Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
> > Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Thanks, will add it to slab pull for 6.13.

Note that there are widespread assumptions in kernel code that the
alignment of scalars is the "natural alignment". Other portions of the
kernel may break. The compiler actually goes along with this??

How do you deal with torn reads/writes in such a scenario? Is this UP
only?


