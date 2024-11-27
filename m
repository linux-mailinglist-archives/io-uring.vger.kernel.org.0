Return-Path: <io-uring+bounces-5093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA5A9DAEC6
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED722B2151B
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C494D1FCFCC;
	Wed, 27 Nov 2024 21:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JhlglFa1"
X-Original-To: io-uring@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE192140E38
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732741698; cv=none; b=ENKIZq1vHN3pktKSg8OqR4i/Y46VjsHc28OYAS2vdZvTD8kbbXC0SwRVCED/6DeCgmMMwIcLxeWMHXnAOhWNAWbYrJX+w4untN6BFaZsSRsO5OanI/a1aTN5BqSfzvuY3bzxGe8Vj6noN1QMZVEPaPvXqWtXhh6K2yuHwNsTyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732741698; c=relaxed/simple;
	bh=eZqu9tuq6KopEQqkFdYH/s+JiEDP4YjDNp+PAm4Ys6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcfexlA5LAUW0M2UBCtB7tUwhZ8xCVpabY56nXFFGLkF6XG/FKrktOVEdv7IbrAYvRvR1uzmAb7TU4VekGmItju++/W4MmlSgkF7du5OXVd6ScEae+L/AGdhvsnI24LveUDLBcl4+3oecoio1lW2pbvrEKsP+tLDe+9RPOm+ez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JhlglFa1; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Nov 2024 16:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732741694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrUVBfzcKiGTjCiOIZhp46CdNer4aMzhIIs2ixjTfsE=;
	b=JhlglFa1kA1h6Z8KTGorjagipVCw5PRj/qpMla13bLHQoma86zNgKRwf7PwBxA10Cv/IUm
	0WheQEM4lxt86GrThSsXLgbt1rFhAq0Q7ozaG2vlyaPMl+DRRmXiihqZbC0/unwuQJ82Lz
	HAava2rZebKFUF1ObZW7+BJhZsOsPnA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 09:44:21PM +0100, Jann Horn wrote:
> On Wed, Nov 27, 2024 at 9:25 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> > > On 11/27/24 9:57 AM, Jann Horn wrote:
> > > > Hi!
> > > >
> > > > In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> > > > to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > > > (without any kind of refcount increment), and used in
> > > > bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> > > > which are used to enable userspace memory access from kthread context.
> > > > I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> > > > guarantees that the MM hasn't gone through exit_mmap() yet (normally
> > > > by holding an mmget() reference).
> > > >
> > > > If we reach this codepath via io_uring, do we have a guarantee that
> > > > the mm_struct that called bch2_direct_write() is still alive and
> > > > hasn't yet gone through exit_mmap() when it is accessed from
> > > > bch2_dio_write_continue()?
> > > >
> > > > I don't know the async direct I/O codepath particularly well, so I
> > > > cc'ed the uring maintainers, who probably know this better than me.
> > >
> > > I _think_ this is fine as-is, even if it does look dubious and bcachefs
> > > arguably should grab an mm ref for this just for safety to avoid future
> > > problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> > > means that on the io_uring side it cannot do non-blocking issue of
> > > requests. This is slower as it always punts to an io-wq thread, which
> > > shares the same mm. Hence if the request is alive, there's always a
> > > thread with the same mm alive as well.
> > >
> > > Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
> > > to dig a bit deeper to verify that would always be safe and there's not
> > > a of time today with a few days off in the US looming, so I'll defer
> > > that to next week. It certainly would be fine with an mm ref grabbed.
> >
> > Wouldn't delivery of completions be tied to an address space (not a
> > process) like it is for aio?
> 
> An io_uring instance is primarily exposed to userspace as a file
> descriptor, so AFAIK it is possible for the io_uring instance to live
> beyond when the last mmput() happens. io_uring initially only holds an
> mmgrab() reference on the MM (a comment above that explains: "This is
> just grabbed for accounting purposes"), which I think is not enough to
> make it stable enough for kthread_use_mm(); I think in io_uring, only
> the worker threads actually keep the MM fully alive (and AFAIK the
> uring worker threads can exit before the uring instance itself is torn
> down).
> 
> To receive io_uring completions, there are multiple ways, but they
> don't use a pointer from the io_uring instance to the MM to access
> userspace memory. Instead, you can have a VMA that points to the
> io_uring instance, created by calling mmap() on the io_uring fd; or
> alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring grab
> references to userspace-provided pages.
> 
> On top of that, I think it might currently be possible to use the
> io_uring file descriptor from another task to submit work. (That would
> probably be fairly nonsensical, but I think the kernel does not
> currently prevent it.)

Ok, that's a wrinkle.

Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
very cursory glance leads me to suspect "no", it seems like this is a
bug if io_uring is allowed on bcachefs at all.

