Return-Path: <io-uring+bounces-11122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 597DACC1021
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 06:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 395E5308BD9F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD798334C2A;
	Tue, 16 Dec 2025 05:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="KkyHTRR7"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0F335087;
	Tue, 16 Dec 2025 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765862581; cv=none; b=n2xUIA+Rz2pySkcgjeft1IjG9tjQTNwtyaMjn2quZE7RlOytCkCnQ6J+G6ePAsPRAxA0nSrv+Ka9n6jJ8qngmj4qLzCFGbar8ahMqAkYMysYXYmesgG5OAnEUH8QSNTOaZC3QM/boFtHnsemlj6CuHnAP+rx5igLuY+YzLpz/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765862581; c=relaxed/simple;
	bh=ANTiFC7CAQbX9HvT6WD6bVN8bSCuRsdBVrcj0kRllXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8I/xtFwOfiakwloqJHKzbJh2DV1jGBbJQjt4JhiiVdsb9Zin4wHG36tlyhCvKRFZDuh6mHeS54E/BTh42pW/ju9E5A7HwgTD6l+ud9xeSnCJKeIsRhm9S3ttl2Lq34zV4T8ipiGphh0KLTf3IAOCd3gp9GlPJEuGR6di4sJzvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=KkyHTRR7; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PyZUMQbKsz3hNPzX0ob+jNGLPe0VdOlESaTZlf2s0q0=; b=KkyHTRR7KIs2XrELB1q/tng+P1
	gvLrsk28fC+Ckbu9HgocDwPxJUL8H4q/I7ATLath8vN3MWA+Y2l9iKP9fx1nfcnA+/6BQI5WjNU8P
	blD8m0C2lfvCUHbaX9elJlFKNfVHbblIqPBnqVYwaxev/BSnOnoq4c2r5V/KN2KCXQFsHDybgcCjW
	HY94J59iutJXiIeyLZZQk2deS0cNlg+2x0SGd17Oi2e/vc2LhiTVX+VA/M5HQ/5Sdj8yHTciwDNjF
	/m42/jcY6w80EaqLdx3boJH1oYMZw5JV7CydPZ7bw0T3y7KUb6RsCdIizVit850A84qy4t4Iq//qy
	ZT04zjPw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVNWc-00000000UhW-1AVD;
	Tue, 16 Dec 2025 05:23:06 +0000
Date: Tue, 16 Dec 2025 05:23:06 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/59] struct filename work
Message-ID: <20251216052306.GO1712166@ZenIV>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
 <CAHk-=wi4j0+zDZPTr4-fyEE4qzHwNdVOwCSuPoJ4w0fpDZcDRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi4j0+zDZPTr4-fyEE4qzHwNdVOwCSuPoJ4w0fpDZcDRQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Dec 16, 2025 at 04:32:03PM +1200, Linus Torvalds wrote:
> So I like the whole series, but..
> 
> On Tue, 16 Dec 2025 at 15:56, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >   struct filename ->refcnt doesn't need to be atomic
> 
> Does ->refcnt need to exist _at_all_ if audit isn't enabled?
> 
> Are there any other users of it? Maybe I missed some?
> 
> Because I'm wondering if we could just encapsulate the thing entirely
> in some #ifdef CONFIG_AUDIT check.
> 
> Now, I think absolutely everybody does enable audit, so it's not
> because I'd try to save one word of memory and a few tests, it's more
> of a "could we make it very explicit that all that code is purely
> about the audit case"?

Umm...  Not exactly.  I mean, yes, at the moment we never increment the
refcount outside of kernel/auditsc.c, so it'll always be 1 if that thing
is disabled.

But if you mean to store it on caller's stack, that's another kettle of
fish - anything async with io_uring won't be able to do that, even we
ignore the stack footprint issues.  In configs without audit we end up
	1) allocating it and copying the pathname from userland on
request submission; pointer is stashed into request.
	2) picking it in processing thread and doing the operation
there By that point submitted might have not just left the kernel,
but overwritten the pathname contents in userland.
	3) either stashing it back into request or freeing it.

With audit (2) might become "... and have an extra ref stashed in audit
context" with (3) becoming "either stashing it back into request, if no
extra ref has appeared, or making a copy, stashing it back into request
and dropping the reference on the original"

So refcount may be audit-only thing, at least at the moment, but the
need to outlive the syscall where getname() had been called is very much
not audit-only.

And stack footprint is not trivial either, unless you limit embedded
case to something very short - even an extra hundred bytes (or two,
e.g. in case of rename()) is not something I'd be entirely comfortable
grabbing for pathname-related syscalls.

