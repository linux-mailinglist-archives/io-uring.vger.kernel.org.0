Return-Path: <io-uring+bounces-2917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F72895CBDB
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 13:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0418A1F22B40
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 11:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A37187870;
	Fri, 23 Aug 2024 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zIqhtD1w"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E22518786D;
	Fri, 23 Aug 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724414355; cv=none; b=PIJQdhhsn1BF06UMSv/X4lRsCZSY4P/mm8SiAY0CythgXkdFiUfZQwb/8e/jIUe09BD3mdjfpklzLZe3+BxQ9KYDMPYK1G1ZUWcV8x+UF7S2KTf0I0tsbOgAgYfBHyAvx51+lnVzUFiwUlmduH16Og7QALihPSTZK1PW14aFrsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724414355; c=relaxed/simple;
	bh=c7waOoxEFxmNPp+X81D26VXenfNb5EykaZFHkHib2c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTDfggXFk1iwTi6Ez5bkyIXxvyZIzrLD/TnJSYpH4OWCYdkKzC7tjH2tU6srMyeXGxy6hOjQU5kHJ3FNukf44ytNBG7qG1G2EGjAcxRIE1PsTqAmhNiV3NkwV28jjPK8HtIy0MBOKdrY8/l9zuKMrbzYpsloTQt95/j0GTQeCNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zIqhtD1w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=MXxJTuEfTmUxd6qScc9KjmTA55na5LtJXZN9+i18IuU=; b=zIqhtD1whjn1MefVjKeXFaIJ9C
	DYkAQQrts0+YUEXxY7CtCXDicxh3HJFiSNw9O8g4enC89obYJhEKIuf8gKiuL1q7SIdsklbpbKe+q
	eMmU86bfUk0nJ6oUhQZvLrapCPhcZZvimd0+34tCqHcULnsdiAIC6iSYo6NC6EY3ldnfHFkZDdMff
	On9SGDsZRg8NLMmwKRUAOHZ5eyO6k1XRI1RAYkh6oqaJq86WJ32pCAy4mQVjwHOiOrKapcn23p/nT
	oQBrPj+8hsD01KYhjM0FOYeoqsEPJ5L0UcHigFglOIWqgW7DibNFeR/fi2UA0Je4bey+QGz6qfKGs
	8mxvzfSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shSwj-0000000GbyR-0QHj;
	Fri, 23 Aug 2024 11:59:13 +0000
Date: Fri, 23 Aug 2024 04:59:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	dchinner@redhat.com
Subject: Re: [PATCH v2 5/7] block: implement async discard as io_uring cmd
Message-ID: <Zsh5kZrcL-D7sjyB@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
 <Zsbe1mIYMd9uf8cq@infradead.org>
 <c39469f3-2b9c-493b-9cd6-94ae9a4994b8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c39469f3-2b9c-493b-9cd6-94ae9a4994b8@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 02:07:16PM +0100, Pavel Begunkov wrote:
> > > Note, unlike ioctl(BLKDISCARD) with stronger guarantees against races,
> > > we only do a best effort attempt to invalidate page cache, and it can
> > > race with any writes and reads and leave page cache stale. It's the
> > > same kind of races we allow to direct writes.
> > 
> > Can you please write up a man page for this that clear documents the
> > expecvted semantics?
> 
> Do we have it documented anywhere how O_DIRECT writes interact
> with page cache, so I can refer to it?

I can't find a good writeup.  Adding Dave as he tends to do long
emails on topic like this so he might have one hiding somewhere.

> > GFP_KERNEL can often will block.  You'll probably want a GFP_NOWAIT
> > allocation here for the nowait case.
> 
> I can change it for clarity, but I don't think it's much of a concern
> since the read/write path and pretty sure a bunch of other places never
> cared about it. It does the main thing, propagating it down e.g. for
> tag allocation.

True, we're only doing the nowait allocation for larger data
structures.  Which is a bit odd indeed.

> I'd rather avoid calling bio_discard_limit() an extra time, it does
> too much stuff inside, when the expected case is a single bio and
> for multi-bio that overhead would really matter.

Compared to a memory allocation it's not really doing all the much.
In the long run we really should move splitting discard bios down
the stack like we do for normal I/O anyway.

> Maybe I should uniline blk_alloc_discard_bio() and dedup it with

uniline?  I read that as unіnline, but as it's not inline I don't
understand what you mean either.

> > > +#define BLOCK_URING_CMD_DISCARD			0
> > 
> > Is fs.h the reight place for this?
> 
> Arguable, but I can move it to io_uring, makes things simpler
> for me.

I would have expected a uapi/linux/blkdev.h for it (and I'm kinda
surprised we don't have that yet).

> 
> > Curious:  how to we deal with conflicting uring cmds on different
> > device and how do we probe for them?  The NVMe uring_cmds
> > use the ioctl-style _IO* encoding which at least helps a bit with
> > that and which seem like a good idea.  Maybe someone needs to write
> > up a few lose rules on uring commands?
> 
> My concern is that we're sacrificing compiler optimisations
> (well, jump tables are disabled IIRC) for something that doesn't even
> guarantee uniqueness. I'd like to see some degree of reflection,
> like user querying a file class in terms of what operations it
> supports, but that's beyond the scope of the series.

We can't guaranteed uniqueness, but between the class, the direction,
and the argument size we get a pretty good one.  There is a reason
pretty much all ioctls added in the last 25 years are using this scheme.


