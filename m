Return-Path: <io-uring+bounces-5101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AB49DAF24
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:58:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45DB32823E5
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB8F2036E8;
	Wed, 27 Nov 2024 21:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dn9sPrKK"
X-Original-To: io-uring@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D827191F75
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744713; cv=none; b=Bu2r9gz5++dNa2bMspmvIkD4kZVozNQmj1SIW28B6iDY/hIuFC2TBKoKOdCxnhRU3JFfdAVAMoGmYiMhKd0N27gXqY3u4C+5jD1L6bjJqozgtZXy6tTCvHhky61lJjDMlb9cNyvg7rr/AVm2iwoKqArTcn7N3e+vMsv74fjfTTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744713; c=relaxed/simple;
	bh=bClPv1mu2ovYRkv1B/aBZoP0QK+NelTmZlCGLKlBRD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/fp8YHDjOh9dTzvVqMx8bmq4DW5xd00vAGXKRQ51FHrEytSJ/vG75NwbfKgtp1SNVMunwvKypxjq/PsYUjzO1IHz+ySPWsfAxtzICGW9lB1gfzOWIWLvJN4xFA7WORXGTtcvZVqjOJe8mGkiyuF6RlZy8+8yaOLV8dBc+xCI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dn9sPrKK; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Nov 2024 16:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732744709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7AzoWilbJIHV7U6MNrHT9EvT5nzRzbnsGFkuZHlRxzc=;
	b=Dn9sPrKK0CJm8VXslucFbFgEKlONDzPDvInCT1GskRjasQYbGYztOCts+JHGmdVGRh6p4V
	sPemNtYGmHZEHImYVDCAuG84UxHcJTRvvn7pw+b5m2JiWnc3A/W+E5w/GxUwt7yVODJ3aS
	RmCe/NAn42im/E2UzSp1Il47aNWP33I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <hrx6kaqeyqdchmv24xivrooyimackqx5mxm6vlvj3y5gusxgno@gjsbtm76unrs>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
 <tt4mrwkwh74tc26nkkeaypci74pcmvupqcdljavlimefeitntc@6tit5kojq5ha>
 <3c24016e-a24c-4b7f-beca-990ef0d91bfe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c24016e-a24c-4b7f-beca-990ef0d91bfe@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 02:51:26PM -0700, Jens Axboe wrote:
> On Wed, Nov 27, 2024 at 2:27?PM Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Nov 27, 2024 at 02:16:24PM -0700, Jens Axboe wrote:
> > > I'd argue the fact that you are using an mm from a different process
> > > without grabbing a reference is the wrinkle. I just don't think it's a
> > > problem right now, but it could be... aio is tied to the mm because of
> > > how it does completions, potentially, and hence needs this exit_aio()
> > > hack because of that. aio also doesn't care, because it doesn't care
> > > about blocking - it'll happily block during issue.
> >
> > I'm not trying to debate who's bug it is, I'm just checking if I need to
> > backport a security fix.
> 
> Not trying to place blame.
> 
> > > > Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
> > > > very cursory glance leads me to suspect "no", it seems like this is a
> > > > bug if io_uring is allowed on bcachefs at all.
> > >
> > > I just looked at bcachefs dio writes, which look to be the only case of
> > > this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> > > always involved for the IO.
> >
> > Ok, sounds like we're in the clear. I already started writing the
> > patch, so it'll just be a "now we can turn on FMODE_NOWAIT" instead of
> > a bugfix.
> 
> That sounds good - and FMODE_NOWAIT will be a good addition. It'll make
> RWF_NOWAIT work, and things like io_uring will also work better as it
> won't need to needlessly punt to an io-wq worker to complete this IO.
> 
> > By the way, did the lifetime issue that was causing umount/remount to
> > fail ever get resolved? I've currently got no test coverage for
> > io_uring, would be nice to flip that back on.
> 
> Nope, I do have an updated branch since then, but it's still sitting
> waiting on getting a bit more love. I suspect it'll be done for 6.14.

Alright - if you want to ping me when that's ready, along with any other
knobs I should flip on for io_uring support, I'll flip io_uring back on
in my test infrastructure at that time.

