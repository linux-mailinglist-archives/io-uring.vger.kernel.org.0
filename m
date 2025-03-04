Return-Path: <io-uring+bounces-6950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FFFA4ED2A
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 20:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0691B7A19CA
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 19:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C91259C97;
	Tue,  4 Mar 2025 19:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moeQmHQZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC199204874;
	Tue,  4 Mar 2025 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741116126; cv=none; b=qM3gp17H+bwCziMLFJokNsh9B/NGqpOeWVjHNyK7wIu/A7SUQNsrxD/WI21GEjMidMXwCofbXL5hiA0dCUa9md10wJhjSorpNoO+lwu6PPytvU34w0NeU+x7+XIkQ9KvREnQ9gmJk4Jtk50PqF0lD0stA2OPKyJsJ4Jb5o5W7kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741116126; c=relaxed/simple;
	bh=LWKGyUQ/VIvtyY8+wP/e6ebURMy+Laxrg66Z+DZYuwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdNMlHuyJslxWHPKnOIOHeJBEZTM8KPeueDlrBTYiBfQYgxXetSKH2nYpA2scUQT62Sq4J381KKZPhr3/zGp1rqyrOSp4FYzkUvJReN5hyqrdC/9FeiTkv986doyLwl23XOUP3GziSlZnoh4bQ0NOm8nsGiwGxK/8zfSFpbWLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moeQmHQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319B8C4CEE5;
	Tue,  4 Mar 2025 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741116126;
	bh=LWKGyUQ/VIvtyY8+wP/e6ebURMy+Laxrg66Z+DZYuwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=moeQmHQZmLuhcOjj57HUsZ2K/jXDjPgMl5/mjZzuKQGQ9bx/CqADxKNf1BKPcn+FN
	 NfhtvpDHP0NiYmuU7dgqnZS6SrzvDZGXNzQONKRxgKvyEAykLx7PqUZtaQboCGGjmY
	 g8sVbS6T7KZAX26N+8se3CBj3PWM0yuPqQkMn7IwCQz3vrCKNpsGWPeiG5lvRvoncb
	 /N53PoWEczrohykK0wMEsaCeWwxsPanJ9wTOD3ggLY80Z3COFxVEq5U6vLok1hiJt4
	 u8PuDddoH+EIGX+UXPY6lrS1QN0XnJT+9KCA+vcWvjynOAjt2Ee7mHUwmMgDgZ1blf
	 L3fv4NzKqVkMQ==
Date: Tue, 4 Mar 2025 11:22:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <20250304192205.GD2803749@frogsfrogsfrogs>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>

On Tue, Mar 04, 2025 at 04:41:40PM +0000, Pavel Begunkov wrote:
> On 3/4/25 16:07, Christoph Hellwig wrote:
> > On Tue, Mar 04, 2025 at 12:18:07PM +0000, Pavel Begunkov wrote:
> > >   	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
> > > -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> > > +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
> > >   		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
> > > +		if (!is_sync_kiocb(dio->iocb) &&
> > > +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
> > > +			return -EAGAIN;
> > 
> > Black magic without comments explaining it.
> 
> I can copy the comment from below if you wish.
> 
> > > +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
> > > +		/*
> > > +		 * This is nonblocking IO, and we might need to allocate
> > > +		 * multiple bios. In this case, as we cannot guarantee that
> > > +		 * one of the sub bios will not fail getting issued FOR NOWAIT
> > > +		 * and as error results are coalesced across all of them, ask
> > > +		 * for a retry of this from blocking context.
> > > +		 */
> > > +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
> > > +					  BIO_MAX_VECS)
> > 
> > This is not very accurate in times of multi-page bvecs and large order
> > folios all over.
> 
> bio_iov_vecs_to_alloc() can overestimate, i.e. the check might return
> -EAGAIN in more cases than required but not the other way around,
> that should be enough for a fix such as this patch. Or did I maybe
> misunderstood you?
> 
> > I think you really need to byte the bullet and support for early returns
> > from the non-blocking bio submission path.
> 
> Assuming you're suggesting to implement that, I can't say I'm excited by
> the idea of reworking a non trivial chunk of block layer to fix a problem
> and then porting it up to some 5.x, especially since it was already
> attempted before by someone and ultimately got reverted.

[I'm going to ignore the sarcasm downthread because I don't like it and
will not participate in prolonging that.]

So don't.  XFS LTS generally doesn't pull large chunks of new code into
old kernels, we just tell people they need to keep moving forward if
they want new code, or even bug fixes that get really involved.  You
want an XFS that doesn't allocate xfs_bufs from reclaim?  Well, you have
to move to 6.12, we're not going to backport a ton of super invasive
changes to 6.6, let alone 5.x.

We don't let old kernel source dictate changes to new kernels.

--D

> -- 
> Pavel Begunkov
> 
> 

