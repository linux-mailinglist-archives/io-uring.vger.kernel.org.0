Return-Path: <io-uring+bounces-10753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B1DC80267
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 12:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256F53A8481
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 11:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2ED42FC861;
	Mon, 24 Nov 2025 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BIgO8ybw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="59jy6zak";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UW7hmsQX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="046gpcSC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DE2FC865
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 11:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763982703; cv=none; b=cz+z3ghDK+FI65A6mt4y0iVnF9hTugmJvbCPQfoGZ4ddbBc366aQP7JWdYTX/AZwLHkFjsykgpS3SNKywrX/Fmi5WFYDy8JbsM74XB/xkif7QXaQeRym3ppAbGcv54pBhOoZmEq98AIMquryRjs8D5dmBoy0x/57bj19MxX2w64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763982703; c=relaxed/simple;
	bh=nKhFYGjEe5LAxL6V7TZ6Vy3A70N4R3o7L+rDE+8a0Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBEDtLpckGPFl/Troq7fh5MxbnXZQET4/7LyQtPvtY3AeZTMTy7kd1ce/1eIcE8BEVJuUq7UZiUgJ0WIku/8KHYpJO08nTXpqf5XDQl0OuPnDif7Tp6aO3rUNB60JyfuNHEghuO1PTXa32LXvjvvdhpIPSZxRuUmXkfgn3i6T/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BIgO8ybw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=59jy6zak; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UW7hmsQX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=046gpcSC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C344B5BD92;
	Mon, 24 Nov 2025 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763982700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3LQ6Sj8MpIdewBBsiwImUBEp+Wwnp3+icgpFvuN6Qg=;
	b=BIgO8ybwtcA88okQmCENSTS/43Mqo1bedUwiMf3DWmJMC3k+EHdWs7Z96qzaude7qIVCxj
	jx3xk70LFT7Om8c1Bqo4AQ0Xknbd5mjSFcHai+WGczVNSp8vventPaSO8q5+ts5RZGu89u
	0OSySfgdjpm7u2hXR6js7lvaJ5jOOvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763982700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3LQ6Sj8MpIdewBBsiwImUBEp+Wwnp3+icgpFvuN6Qg=;
	b=59jy6zakNcsYVF9UxTeM/01QAXIIitgV/yjWyKpBVMZbsUueyKubdkmdaEXJg2DKVzCq2+
	G4zb7GvM4+QsUTDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763982699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3LQ6Sj8MpIdewBBsiwImUBEp+Wwnp3+icgpFvuN6Qg=;
	b=UW7hmsQXp5NZn1YcPQI4nOJtEGC2UsH35+Nn3ioQb7bCmhV2x8F4jmJgKirYyU+kYyTN7R
	o908jjADyt9rLpdMPQ4lpK0FmBXSFUW27zw3uObrkQFU7R8BAnsSJN4m/LDLGGVJzZ9XUL
	bgBpgQo+6qquhC7JqUtzd0zGMfqs2DA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763982699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3LQ6Sj8MpIdewBBsiwImUBEp+Wwnp3+icgpFvuN6Qg=;
	b=046gpcSCOGpqfUPRExjs0dixgG7PEbiLktSMHIyNbIvpQIgk1rsVCars9UZkZ4FVMMoa3I
	7N6rEg3qheRcEeDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B61A03EA61;
	Mon, 24 Nov 2025 11:11:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NBd0LGs9JGkLTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 11:11:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 59E5EA0A04; Mon, 24 Nov 2025 12:11:35 +0100 (CET)
Date: Mon, 24 Nov 2025 12:11:35 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 4/5] iomap: support write completions from interrupt
 context
Message-ID: <tzwbel3wcy674hh6e3gmcjqe3dipn34pwazftsme6atuhomh44@ckqgnxh4zrvk>
References: <20251113170633.1453259-1-hch@lst.de>
 <20251113170633.1453259-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113170633.1453259-5-hch@lst.de>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Thu 13-11-25 18:06:29, Christoph Hellwig wrote:
> Completions for pure overwrites don't need to be deferred to a workqueue
> as there is no work to be done, or at least no work that needs a user
> context.  Set the IOMAP_DIO_INLINE_COMP by default for writes like we
> already do for reads, and the clear it for all the cases that actually
> do need a user context for completions to update the inode size or
> record updates to the logical to physical mapping.
> 
> I've audited all users of the ->end_io callback, and they only require
> user context for I/O that involves unwritten extents, COW, size
> extensions, or error handling and all those are still run from workqueue
> context.
> 
> This restores the behavior of the old pre-iomap direct I/O code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap/direct-io.c | 59 +++++++++++++++++++++++++++++++++++---------
>  1 file changed, 48 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index fb2d83f640ef..60884c8cf8b7 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -184,6 +184,21 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  	if (dio->error)
>  		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
>  
> +	/*
> +	 * Never invalidate pages from this context to avoid deadlocks with
> +	 * buffered I/O completions when called from the ioend workqueue,
> +	 * or avoid sleeping when called directly from ->bi_end_io.
> +	 * Tough luck if you hit the tiny race with someone dirtying the range
> +	 * right between this check and the actual completion.
> +	 */
> +	if ((dio->flags & IOMAP_DIO_WRITE) &&
> +	    (dio->flags & IOMAP_DIO_INLINE_COMP)) {
> +		if (dio->iocb->ki_filp->f_mapping->nrpages)
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +		else
> +			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
> +	}
> +
>  	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
> @@ -234,15 +249,9 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
>  		/*
>  		 * Try to avoid another context switch for the completion given
>  		 * that we are already called from the ioend completion
> -		 * workqueue, but never invalidate pages from this thread to
> -		 * avoid deadlocks with buffered I/O completions.  Tough luck if
> -		 * you hit the tiny race with someone dirtying the range now
> -		 * between this check and the actual completion.
> +		 * workqueue.
>  		 */
> -		if (!dio->iocb->ki_filp->f_mapping->nrpages) {
> -			dio->flags |= IOMAP_DIO_INLINE_COMP;
> -			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
> -		}
> +		dio->flags |= IOMAP_DIO_INLINE_COMP;
>  		iomap_dio_done(dio);
>  	}
>  
> @@ -378,6 +387,20 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  			else
>  				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
>  		}
> +
> +		/*
> +		 * We can only do inline completion for pure overwrites that
> +		 * don't require additional I/O at completion time.
> +		 *
> +		 * This rules out writes that need zeroing or metdata updates to
> +		 * convert unwritten or shared extents.
> +		 *
> +		 * Writes that extend i_size are also not supported, but this is
> +		 * handled in __iomap_dio_rw().
> +		 */
> +		if (need_completion_work)
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +
>  		bio_opf |= REQ_OP_WRITE;
>  	} else {
>  		bio_opf |= REQ_OP_READ;
> @@ -638,10 +661,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
>  		dio->flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
>  
> -	if (iov_iter_rw(iter) == READ) {
> -		/* reads can always complete inline */
> -		dio->flags |= IOMAP_DIO_INLINE_COMP;
> +	/*
> +	 * Try to complete inline if we can.  For reads this is always possible,
> +	 * but for writes we'll end up clearing this more often than not.
> +	 */
> +	dio->flags |= IOMAP_DIO_INLINE_COMP;
>  
> +	if (iov_iter_rw(iter) == READ) {
>  		if (iomi.pos >= dio->i_size)
>  			goto out_free_dio;
>  
> @@ -683,6 +709,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
>  		}
>  
> +		/*
> +		 * i_size updates must to happen from process context.
> +		 */
> +		if (iomi.pos + iomi.len > dio->i_size)
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +
>  		/*
>  		 * Try to invalidate cache pages for the range we are writing.
>  		 * If this invalidation fails, let the caller fall back to
> @@ -755,9 +787,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	 * If all the writes we issued were already written through to the
>  	 * media, we don't need to flush the cache on IO completion. Clear the
>  	 * sync flag for this case.
> +	 *
> +	 * Otherwise clear the inline completion flag if any sync work is
> +	 * needed, as that needs to be performed from process context.
>  	 */
>  	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
> +	else if (dio->flags & IOMAP_DIO_NEED_SYNC)
> +		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
>  
>  	/*
>  	 * We are about to drop our additional submission reference, which
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

