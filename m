Return-Path: <io-uring+bounces-5090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E7D9DAE82
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5B22162EA4
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D91202F84;
	Wed, 27 Nov 2024 20:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N4fOrYUQ"
X-Original-To: io-uring@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A52CCC0
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 20:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732739146; cv=none; b=BvK5fFf2gxnEviieHU2CojUi2gnnEb5nWZKjHfiLel3ZcnLeqITti+EAJ2vdlifwuNK02FEuRleZ+qdyWQEiml8ymwq6gZe35Dx0YsmekE5nZWQOjuibP+gdalzcYgjrl/Sr/JYSS/8sWZ7BbWhPWMShGgGIkXcgFDlXFDu+GUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732739146; c=relaxed/simple;
	bh=eDlqeY888v429bWEPT3Fi6aBbu+iw9MzRiOWp7sVA5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fy1ELPsJdkA7t2S4WczX7b5Qr/PFUOvucMIsBwG0hCkBe8LXzg5ry0C0bbRI6VCCpybjEOqS1+KZvQ2RTleqIpEqVwWjVcRLfBQ6so2n4fcoOhyfO08U3+BHqcywXnEYl+z3bLIF1yoeo5zaEhg3yBltgRzmfJFuLshzI+VQ4BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N4fOrYUQ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Nov 2024 15:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732739143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=skcgUuoiBBxN7x6FTZw8AkaFvSWZd1lygoGn1Se8VZE=;
	b=N4fOrYUQx0faVhPRb1Oa7gTV7sUsuqju0ZEy6iiQFBsKHKryzKbb0V4vVhgOPVObJBFA6a
	KZZdMW/wxIgJTfi6yycPtaSUEcG5mI+6nRJr2QhIVuokizKVc+2NHO6vIdXeU5c/hu5GUQ
	bD5WGWu6GIGRXi1lyi/h1Sv1DpDfM0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> On 11/27/24 9:57 AM, Jann Horn wrote:
> > Hi!
> > 
> > In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> > to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > (without any kind of refcount increment), and used in
> > bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> > which are used to enable userspace memory access from kthread context.
> > I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> > guarantees that the MM hasn't gone through exit_mmap() yet (normally
> > by holding an mmget() reference).
> > 
> > If we reach this codepath via io_uring, do we have a guarantee that
> > the mm_struct that called bch2_direct_write() is still alive and
> > hasn't yet gone through exit_mmap() when it is accessed from
> > bch2_dio_write_continue()?
> > 
> > I don't know the async direct I/O codepath particularly well, so I
> > cc'ed the uring maintainers, who probably know this better than me.
> 
> I _think_ this is fine as-is, even if it does look dubious and bcachefs
> arguably should grab an mm ref for this just for safety to avoid future
> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> means that on the io_uring side it cannot do non-blocking issue of
> requests. This is slower as it always punts to an io-wq thread, which
> shares the same mm. Hence if the request is alive, there's always a
> thread with the same mm alive as well.
> 
> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
> to dig a bit deeper to verify that would always be safe and there's not
> a of time today with a few days off in the US looming, so I'll defer
> that to next week. It certainly would be fine with an mm ref grabbed.

Wouldn't delivery of completions be tied to an address space (not a
process) like it is for aio?

