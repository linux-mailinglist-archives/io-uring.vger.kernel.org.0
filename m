Return-Path: <io-uring+bounces-5091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A4E9DAE89
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B84166721
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6E8202F6E;
	Wed, 27 Nov 2024 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UohZEOHF"
X-Original-To: io-uring@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD472010FA
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732739505; cv=none; b=VOGvtFNgBq3W2zeN1fPDvRAlTEfdW3OYvwqFdLEyd/KyGukFP+bVnFjI0JyTyai5Aw+bHQ0YeFh9dGaEsYog83dTwSksuG7ERw/3t9UDUr62luNVH2ejEYV7hVL8DQAgB1nxh8sa9TlFGs5g3rH3kxGMSlImAC9A+fL/fvvdrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732739505; c=relaxed/simple;
	bh=rvLd5onfQ7DDQ8Nf9yaM4f5vbkpvO4qNaW5Mlqy4cmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3p2UcBwgKE4qawIgmEGBOxyXYvEgkMQY7V3MHqJa8KPJwS6qTezi5Jaw9VbtMoKbI6qUVhcqHCnMZ2lSB5YyJ7gzi5ixFRpCW6mbgPkDYQDt2NN4QS64EgoL7fW8K0qNTGexaNOuQYjODTNu4elqE62+Wppc1T0/kIJKlNRQfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UohZEOHF; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Nov 2024 15:31:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732739500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P7M5ojNoGPW7ShBlkjPkmQcgRGWWiNlgP5enVALM/EM=;
	b=UohZEOHFvZ0b71DYERxk+CMte4r+Dpf2ePKZREciLLH4yIgY5GjnrNhEeaTnGOBYlgTUVP
	Y0kA5buOaEJ7DbOxZ23OddtAB0HcQt07S7FZv49iHjNZ0DcY0v2eFJwzwXSE8N23RlTaZ6
	iwIsKGQ6XSmGQO6Wpz3p1zXUnFSY7Zk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <mh4v6r2nxgc6xsjc6xvcnrsellqvblbk3622y5ifkrfvcnh5pj@5xuufyq4pcni>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
 <cd72e289-f671-4b8d-adb9-aebdf8a43afd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd72e289-f671-4b8d-adb9-aebdf8a43afd@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 01:01:31PM -0700, Jens Axboe wrote:
> On 11/27/24 12:43 PM, Jann Horn wrote:
> > On Wed, Nov 27, 2024 at 7:09?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 11/27/24 9:57 AM, Jann Horn wrote:
> >>> Hi!
> >>>
> >>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> >>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> >>> (without any kind of refcount increment), and used in
> >>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> >>> which are used to enable userspace memory access from kthread context.
> >>> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> >>> guarantees that the MM hasn't gone through exit_mmap() yet (normally
> >>> by holding an mmget() reference).
> >>>
> >>> If we reach this codepath via io_uring, do we have a guarantee that
> >>> the mm_struct that called bch2_direct_write() is still alive and
> >>> hasn't yet gone through exit_mmap() when it is accessed from
> >>> bch2_dio_write_continue()?
> >>>
> >>> I don't know the async direct I/O codepath particularly well, so I
> >>> cc'ed the uring maintainers, who probably know this better than me.
> >>
> >> I _think_ this is fine as-is, even if it does look dubious and bcachefs
> >> arguably should grab an mm ref for this just for safety to avoid future
> >> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> >> means that on the io_uring side it cannot do non-blocking issue of
> >> requests. This is slower as it always punts to an io-wq thread, which
> >> shares the same mm. Hence if the request is alive, there's always a
> >> thread with the same mm alive as well.
> >>
> >> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
> >> to dig a bit deeper to verify that would always be safe and there's not
> >> a of time today with a few days off in the US looming, so I'll defer
> >> that to next week. It certainly would be fine with an mm ref grabbed.
> > 
> > Ah, thanks for looking into it! I missed this implication of not
> > setting FMODE_NOWAIT.
> > 
> > Anyway, what you said sounds like it would be cleaner for bcachefs to
> > grab its own extra reference, maybe by initially grabbing an mm
> > reference with mmgrab() in bch2_direct_write(), and then use
> > mmget_not_zero() in bch2_dio_write_continue() to ensure the MM is
> > stable.
> 
> Yep I think that would definitely make it more sturdy, and also less
> headscratchy in terms of being able to verify it's actually safe.
> 
> > What do other file systems do for this? I think they normally grab
> > page references so that they don't need the MM anymore when
> > asynchronously fulfilling the request, right? Like in
> > iomap_dio_bio_iter(), which uses bio_iov_iter_get_pages() to grab
> > references to the pages corresponding to the userspace regions in
> > dio->submit.iter?
> 
> Not aware of anything else doing it like this, where it's punted to a
> kthread and then the mm used from there. The upfront page
> getting/mapping is the common approach, like you described. Which does
> seem like a much better choice, rather than needing to rely on the mm in
> a kworker.

More common, but not necessarily better: the "pin everything up front"
approach had the disadvantage that - well, you pinned everything up
front: if userspace requests a single multi-gigabyte IO, that is likely
not what you want.

The old dio code didn't pin everything up front for this reason (but
IIRC wasn't fully asynchronous, and also had a silly baked in 64 page
limit).

