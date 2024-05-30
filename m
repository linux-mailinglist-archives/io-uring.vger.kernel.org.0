Return-Path: <io-uring+bounces-2022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8EA8D5262
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 21:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B388285391
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 19:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2531914D428;
	Thu, 30 May 2024 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OYxNvUgI"
X-Original-To: io-uring@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DF158877
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717097749; cv=none; b=QaVoQgTf/COsdZqACtuyRyNKiiFkMkHNFitC2UyITHLS8TKtEN/ZKTvnwVaQnHDAEEo1enl/ZpoOCOtSb37WbUF9nsBSNobohh349y7rBFDO0kjQB6MzYe5E54ASBlZi2Xzm9ChR5fgNPkaxjZCCvPdu5VsSFVbCa4caPD/7phA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717097749; c=relaxed/simple;
	bh=3OLRtkb+uwDl1oju0D7uwb55ckX6jRsEmg9JaP5QubQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/24UfXJv6nf758kHBh2H5qgwE2bpb8+r7QdwHk586dPRRSy7QNB6LFEi+9oWrRsMrMwmdmywPdqwUbVi98uFXu7hv+WxPDSQi7tYI3VgxuXSGRHPAU95gq3nWdbsExik+fDbDOq3q2d8KRwMei1JvhA6/qO6Jr1xvQ5t5bsbcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OYxNvUgI; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717097743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwSoRwj+i1ys1qYKFAZm0YMwW90U0THOqLHd6j4P4aM=;
	b=OYxNvUgInD7JjgpI4T4kuuU93PehQSsJbEAmkqmwoq6FAGBjG9MIZbKd0/Ms3KPn2jpMH+
	UFKv7dYKyxxkycKxx4mqH9OXFrVH0i2OU2wOgNME8Q0rgtbUZiWnvafFkvRJHT+/L5ZkZo
	OLyWDD7XRa7wLGt+TGwu1CKJQePVhaM=
X-Envelope-To: bernd.schubert@fastmail.fm
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
X-Envelope-To: ming.lei@redhat.com
X-Envelope-To: asml.silence@gmail.com
X-Envelope-To: josef@toxicpanda.com
Date: Thu, 30 May 2024 15:35:38 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, 
	Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <q7amewjey3o7sntjsgn4caq4cr7eyhinmomo7gpt2rp6zdhnku@wctr6h3653at>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
 <tpdo6jfuhouew6stoy7y7sy5dvzphetqic2tzf74c47vr7s5qi@c5ttwxatvwbi>
 <360b1a11-252d-48d9-a680-eda879b676a5@kernel.dk>
 <ioqqlwed5pzaucsfwbnroun5rd2l3loqo53slmc5vos2ha5njm@5aqt6kglccx4>
 <ed8f667b-7aa3-41b8-bb98-3f52a674d765@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed8f667b-7aa3-41b8-bb98-3f52a674d765@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 12:48:56PM -0600, Jens Axboe wrote:
> On 5/30/24 11:58 AM, Kent Overstreet wrote:
> > On Thu, May 30, 2024 at 11:28:43AM -0600, Jens Axboe wrote:
> >> I have addressed it several times in the past. tldr is that yeah the
> >> initial history of io_uring wasn't great, due to some unfortunate
> >> initial design choices (mostly around async worker setup and
> >> identities).
> > 
> > Not to pick on you too much but the initial history looked pretty messy
> > to me - a lot of layering violations - it made aio.c look clean.
> 
> Oh I certainly agree, the initial code was in a much worse state than it
> is in now. Lots of things have happened there, like splitting things up
> and adding appropriate layering. That was more of a code hygiene kind of
> thing, to make it easier to understand, maintain, and develop.
> 
> Any new subsystem is going to see lots of initial churn, regardless of
> how long it's been developed before going into upstream. We certainly
> had lots of churn, where these days it's stabilized. I don't think
> that's unusual, particularly for something that attempts to do certain
> things very differently. I would've loved to start with our current
> state, but I don't think years of being out of tree would've completely
> solved that. Some things you just don't find until it's in tree,
> unfortunately.

Well, the main thing I would've liked is a bit more discussion in the
early days of io_uring; there are things we could've done differently
back then that could've got us something cleaner in the long run.

My main complaints were always
 - yet another special purpose ringbuffer, and
 - yet another parallel syscall interface.

We've got too many of those too (aio is another), and the API
fragmentation is a real problem for userspace that just wants to be able
to issue arbitrary syscalls asynchronously. IO uring could've just been
serializing syscall numbers and arguments - that would have worked fine.

Given the history of failed AIO replacements just wanting to shove in
something working was understandable, but I don't think those would have
been big asks.

> > I'd also really like to see some more standardized mechanisms for "I'm a
> > kernel thread doing work on behalf of some other user thread" - this
> > comes up elsewhere, I'm talking with David Howells right now about
> > fsconfig which is another place it is or will be coming up.
> 
> That does exist, and it came from the io_uring side of needing exactly
> that. This is why we have create_io_thread(). IMHO it's the only sane
> way to do it, trying to guesstimate what happens deep down in a random
> callstack, and setting things up appropriately, is impossible. This is
> where most of the earlier day io_uring issues came from, and what I
> referred to as a "poor initial design choice".

Thanks, I wasn't aware of that - that's worth highlighting. I may switch
thread_with_file to that, and the fsconfig work David and I are talking
about can probably use it as well.

We really should have something lighter weight that we can use for work
items though, that's our standard mechanism for deferred work, not
spinning up a whole kthread. We do have kthread_use_mm() - there's no
reason we couldn't do an expanded version of that for all the other
shared resources that need to be available.

This was also another blocker in the other aborted AIO replacements, so
reusing clone flags does seem like the most reasonable way to make
progress here, but I would wager there's other stuff in task_struct that
really should be shared and isn't. task_struct is up to 825 (!) lines
now, which means good luck on even finding that stuff - maybe at some
point we'll have to get a giant effort going to clean up and organize
task_struct, like willy's been doing with struct page.

> >> Those have since been rectified, and the code base is
> >> stable and solid these days.
> > 
> > good tests, code coverage analysis to verify, good syzbot coverage?
> 
> 3x yes. Obviously I'm always going to say that tests could be better,
> have better coverage, cover more things, because nothing is perfect (and
> if you think it is, you're fooling yourself) and as a maintainer I want
> perfect coverage. But we're pretty diligent these days about adding
> tests for everything. And any regression or bug report always gets test
> cases written.

*nod* that's encouraging. Looking forward to the umount issue being
fixed so I can re-enable it in my tests...

