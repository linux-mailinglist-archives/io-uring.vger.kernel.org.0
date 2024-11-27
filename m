Return-Path: <io-uring+bounces-5089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B4A9DAE7F
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8220B163AD1
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5CF02CCC0;
	Wed, 27 Nov 2024 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gy34Dnyl"
X-Original-To: io-uring@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75D202F94
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 20:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732739052; cv=none; b=mR0Vh7swuuYIYSkIeVfnvw2prIMzVyHPAYefRqUT5e4O2y4IeDBJPjNohI9CCwpjQJEHPHcHhvxsnWhTQhgEDUYvGjm7pYE0Uusx5vMXu+YHWZLTj2EkQPWy+QcrH3VFMmDDJYkYcoZJDp78lhccc7JmOIxv8omNWJ0nUIOb4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732739052; c=relaxed/simple;
	bh=3kQAA6tjOG3i3hymlIKv4AqsvYPm+nWbOIv+s3MvJf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvqUkxN8yYIc4MS+xMZ58DafPmt/k4wk7CKE3Ud8qC+dXPh2FFBZ0cVW2JU8oAX2aRRfU8C7wacrm+++zcH4O3bRo9u0td4bd8i2J4I4hTkb06gLk3lypq60apHJWriwtZqSkGltOuAI6QGPFVFZmqBeS+d68LFzfA4y0XgQwYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gy34Dnyl; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Nov 2024 15:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732739044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69vJdznNDa6rQiLJ94o22HONq7hUB59zt/CYuIV9Hjs=;
	b=gy34Dnylj+PE4PxQOKTnRdL9hWmKcy0O4wPNqSjaZiq3l6itNtByxi1NMNbIfIBDRjyx8D
	P1QqRlmaH+Dv76oCfRzsBcWsGLHaF2PA1bNrGHji3I7zIEIfa+gQIwpZPoe44mcbkaw6j4
	UHrb7nlIxCmPwLrNyXMtA1ecFmiPGSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <5jvih6bn7pv5p4btf65bvuxnnt4hli7gf2zlibejyjswmnk5dg@xwfuf3womp5b>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 05:57:03PM +0100, Jann Horn wrote:
> Hi!
> 
> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> (without any kind of refcount increment), and used in
> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> which are used to enable userspace memory access from kthread context.
> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> guarantees that the MM hasn't gone through exit_mmap() yet (normally
> by holding an mmget() reference).
> 
> If we reach this codepath via io_uring, do we have a guarantee that
> the mm_struct that called bch2_direct_write() is still alive and
> hasn't yet gone through exit_mmap() when it is accessed from
> bch2_dio_write_continue()?
> 
> I don't know the async direct I/O codepath particularly well, so I
> cc'ed the uring maintainers, who probably know this better than me.

I don't know about io_uring but aio guarantees that outstanding kiocbs
are completed before exiting the mm_struct - I would expect some sort of
similar guarantee to hold, because otherwise where are we going to
deliver the completion?

