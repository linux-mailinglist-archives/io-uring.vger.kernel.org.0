Return-Path: <io-uring+bounces-4911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 623079D465D
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 04:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 269D5282376
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 03:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB903B796;
	Thu, 21 Nov 2024 03:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GD10U7Vw"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C010A3E;
	Thu, 21 Nov 2024 03:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732161103; cv=none; b=Tu5nZma1gs1fLPtjbcsS+iuIBNHCUT5UQdHIazFwxBwld1Sr6tUIgfkTxFjr++AeT7cVCZpsFvHJg6kuVd8SCM6h+FEgTq64NKbIPZq/7r7oOOaLd20CYz6l8fOpLtiAPdGdwEmpzrHPjDj1aYWaylW44ElvaoON5sBwpKLUTf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732161103; c=relaxed/simple;
	bh=d39CCmkZ8YwXDK3kbb4qQSnUGD/DQlAFdLdtmqLYmAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwVtU4BLNCCgI90xaboDzaCjRvCXJPHbdwdyFX7gFyXwVc8JMQfqW0/N3yCFkSjTFruR3ILRUH5qpTlNuXU1HxurcZojvh8ycIePN/SLTdAuPT0fX0wJCWkE42oLM7ECRYOzxNT2pc8W3whJ4HA9DbV4XKTFyXAw2rNzO5gjO2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GD10U7Vw; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2xeimqU1HjPVrZw0PVZ08j1Bp5dOdUnKVWuE8/Ca5ro=; b=GD10U7VwxZlnhtNSLarPjIxu1t
	sgKN8SqpaWbZ77NYf/JMIe0v+Xw7f2qAZeHMHwEn9SNc+uLJ3Z4HG/y0i29QojXPMOirErOjiFUd5
	VP+jMskl9qMqek6GOfAblAvzVw9OKLrpdzBqLHXT5WawqAmLPEmRGtc2wkI4gcfkdA6qSd5GTYDym
	zosyRM0PeH2fiIKx0IbAHl65oZX8f8XHy2+FmfP9Lg+sHV/GzHbUi4AcYuOUa0VtpKsxTD7laixsC
	b5UBcoBpcv1/Gh4wPEsV7UtA7YPwJ7y6Ll1eChn0kmKbZeM7D42aotv8OBgFVhoQB04Lpxt6Cvr+s
	Qiy4ZoIg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDyE8-00000005vhG-1rUX;
	Thu, 21 Nov 2024 03:51:32 +0000
Date: Thu, 21 Nov 2024 03:51:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <Zz6uRN_-mbo1CPzo@casper.infradead.org>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>

On Wed, Nov 20, 2024 at 09:50:47AM -0800, Christoph Lameter (Ampere) wrote:
> On Wed, 20 Nov 2024, Vlastimil Babka wrote:
> 
> > >
> > > Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
> > > Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Thanks, will add it to slab pull for 6.13.
> 
> Note that there are widespread assumptions in kernel code that the
> alignment of scalars is the "natural alignment". Other portions of the
> kernel may break. The compiler actually goes along with this??

u64s aren't aligned on x86-32.  it's caused some problems over the
years, but things work ok in general.

> How do you deal with torn reads/writes in such a scenario? Is this UP
> only?

there were never a lot of smp m68k.  not sure i can think of one, tbh.
sun3 and hp300/400 seem like the obvious people who might have done an
smp m68k, but neither did.

