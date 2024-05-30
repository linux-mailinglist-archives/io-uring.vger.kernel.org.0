Return-Path: <io-uring+bounces-2023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C3A8D52CD
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 22:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6319A28791F
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 20:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF654D8DA;
	Thu, 30 May 2024 20:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CFML5l7C"
X-Original-To: io-uring@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61804D8BF
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099522; cv=none; b=IWOny3Er31e5DVHOL/5VGHcUCiksv4NzUO6haJ/MYYdhNu019gtSr0Huh+vV02RdlXuKj/N7jVO9gT0n9ZFy+sgnfOoHKOsuCwWtSBRro2eJzggSvi7Tl2REVKO/XGgmxIYMflDK6p0v1+FTDLlLtNe//HS2Sixz3m9r7zSpO9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099522; c=relaxed/simple;
	bh=jfZjH7dPEZxsZkGq0Zc2HutaVqt4Wmi6QmjVBkp2ahw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9uWJyyDe/LJcs+vi3AURUoH+MOntZfTvVzcQGcgNHyPu7QZpCQFxxK63+2BMTfFA8GS4I/gnDHlWwkVd4Lo3C/1o2N2cseofy8zN1C1DLWdDo/vtki0BzlZ+tgJ9siUkOVdsizo0GoyfwWrhuzMfC5irShbBzRaGUtvPGU+d7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CFML5l7C; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: josef@toxicpanda.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717099516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YpFa3Bx0Tf5ODURqiaCwQwbuuk80x2jm9JeNzuE+FHQ=;
	b=CFML5l7CVOz1FXmbeETe96hrRrhe/PJtIKJsSTChVh39w4jduf8c/47tK1+T73RK0dv2wx
	SEgPlBbaXiqxTEoMNxn1LGta3shETyBcQHP5W8ke/pxY+c6XWvNgJE1sAmJPzG87v3hOZN
	KxS7ZI1aS1ORKvOITQKMETs+oHdI5yc=
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
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: ming.lei@redhat.com
X-Envelope-To: asml.silence@gmail.com
Date: Thu, 30 May 2024 16:05:12 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, 
	Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <xzg5nck7x3yv3tfabwcoht4rdab3i5ddjyo3ti7myihmw5b2yy@kus54abrdfm4>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
 <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
 <20240530190941.GA2210558@perftesting>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530190941.GA2210558@perftesting>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 03:09:41PM -0400, Josef Bacik wrote:
> On Thu, May 30, 2024 at 06:17:29PM +0200, Bernd Schubert wrote:
> > 
> > 
> > On 5/30/24 18:10, Kent Overstreet wrote:
> > > On Thu, May 30, 2024 at 06:02:21PM +0200, Bernd Schubert wrote:
> > >> Hmm, initially I had thought about writing my own ring buffer, but then 
> > >> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
> > >> need? From interface point of view, io-uring seems easy to use here, 
> > >> has everything we need and kind of the same thing is used for ublk - 
> > >> what speaks against io-uring? And what other suggestion do you have?
> > >>
> > >> I guess the same concern would also apply to ublk_drv. 
> > >>
> > >> Well, decoupling from io-uring might help to get for zero-copy, as there
> > >> doesn't seem to be an agreement with Mings approaches (sorry I'm only
> > >> silently following for now).
> > >>
> > >> From our side, a customer has pointed out security concerns for io-uring. 
> > >> My thinking so far was to implemented the required io-uring pieces into 
> > >> an module and access it with ioctls... Which would also allow to
> > >> backport it to RHEL8/RHEL9.
> > > 
> > > Well, I've been starting to sketch out a ringbuffer() syscall, which
> > > would work on any (supported) file descriptor and give you a ringbuffer
> > > for reading or writing (or call it twice for both).
> > > 
> > > That seems to be what fuse really wants, no? You're already using a file
> > > descriptor and your own RPC format, you just want a faster
> > > communications channel.
> > 
> > Fine with me, if you have something better/simpler with less security
> > concerns - why not. We just need a community agreement on that.
> > 
> > Do you have something I could look at?
> 
> FWIW I have no strong feelings between using iouring vs any other ringbuffer
> mechanism we come up with in the future.
> 
> That being said iouring is here now, is proven to work, and these are good
> performance improvements.  If in the future something else comes along that
> gives us better performance then absolutely we should explore adding that
> functionality.  But this solves the problem today, and I need the problem solved
> yesterday, so continuing with this patchset is very much a worthwhile
> investment, one that I'm very happy you're tackling Bernd instead of me ;).
> Thanks,

I suspect a ringbuffer syscall will actually be simpler than switching
to io_uring. Let me see if I can cook something up quickly - there's no
rocket science here and this all stuff we've done before so it shouldn't
take too long (famous last works...)

