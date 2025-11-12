Return-Path: <io-uring+bounces-10546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DADC545B2
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 21:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 538894F006D
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 19:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F5D2882D3;
	Wed, 12 Nov 2025 19:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QtrQ90s5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JgBNdBzi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bOSzikSI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tkPWA0tN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9912A1AA
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 19:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762977578; cv=none; b=JHESxFwBzPPccNRFazny3IjjkxLc9ueWORncirfSQOahN02g94M92aTPLDw8YyyqH/6lE5hCYBWi335fTrVMh9+dee20LWNbYTFHxSX6tjMVo8tmWVQ/H4vvhGexUlo/3YA71iwcswfI9CsvSLB58kg24994KcWjcXXJTZdwuA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762977578; c=relaxed/simple;
	bh=QynmfP9FIAbaIZ93OL/3JG/Esdywx3SbRx209GY0CKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fmio0VxNnVq+fLbC6LQZPcw8ouNVk7cOA9fASTEDkbPSPI/6VzWVWoWyNXRshlMi5oQOUiiAWIZaB30Zo4NGJoPBVcMDb53+SYsQ27BmKU3lYVUcVy0ahW6C48ZYgVbzRGEEG6+OEMBgefA9RUYwzWwy6YavJFva9hO6evIcoSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QtrQ90s5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JgBNdBzi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bOSzikSI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tkPWA0tN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8497B1F7A1;
	Wed, 12 Nov 2025 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762977574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ8G1nEzJDMMzagnKS3P8TMGMkp8hDaJpUf5w/Flc6o=;
	b=QtrQ90s57LiREcAxaoit1+KY9zGlh1+qSh6bz+FeVE78aRAkgFlvgZYZH62xGDZ/ztlnCE
	fARw8/66+LFEkUYyQ6bTkAeqV/HF1xamba+YvQwL2vDtE5HQNpEbfVCnb28nWhwFiyBBIW
	3tMFNZxYVWEXWjLc1a5CNxMHIqNt3Nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762977574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ8G1nEzJDMMzagnKS3P8TMGMkp8hDaJpUf5w/Flc6o=;
	b=JgBNdBzizc6qWD5kIlsPmQND6ar7VZXyFr+hPb72Oclf6ZEVpMFv5f1HAeGgxCVe9ndQAn
	88tmivms6BfSqQAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bOSzikSI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tkPWA0tN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762977573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ8G1nEzJDMMzagnKS3P8TMGMkp8hDaJpUf5w/Flc6o=;
	b=bOSzikSIve3X3Sa3e6FlWchUWKocic+zqtVg3i1LmJVC3HzbOOeN7NeNwT0qHrc5bSSZnU
	3hN+A0fCV1LWY1C16j29Y+EXQPaJrYJ6Xe05Od6JU9fextunNKEU9l1J2h6Vn+112O9b3K
	lHDiJDaK+DXmamI8rR+tHE5kHw4hhPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762977573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ8G1nEzJDMMzagnKS3P8TMGMkp8hDaJpUf5w/Flc6o=;
	b=tkPWA0tNYwbfR3c9oDhMD4lIU8eqVDV+wZ7xlC+XlNV74gMKoyFqcISPgo0s1uNMaBrEET
	uTG9cHFG9jwW0HAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 466633EA61;
	Wed, 12 Nov 2025 19:59:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fBl+ECXnFGlwdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 12 Nov 2025 19:59:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B2CADA06F7; Wed, 12 Nov 2025 20:59:32 +0100 (CET)
Date: Wed, 12 Nov 2025 20:59:32 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
Message-ID: <x6ouwks5jnbu7bnxqwheeekwag35gzbwokd7qci4fomcrokadj@h2yzocuee354>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-2-hch@lst.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 8497B1F7A1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -4.01

On Wed 12-11-25 08:21:25, Christoph Hellwig wrote:
> This was added by commit 099ada2c8726 ("io_uring/rw: add write support
> for IOCB_DIO_CALLER_COMP") and disabled a little later by commit
> 838b35bb6a89 ("io_uring/rw: disable IOCB_DIO_CALLER_COMP") because it
> didn't work.  Remove all the related code that sat unused for 2 years.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I was wondering once where that flag can get set but then got distracted
and forgot about it :). The patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  .../filesystems/iomap/operations.rst          |  4 --
>  fs/backing-file.c                             |  6 --
>  fs/iomap/direct-io.c                          | 56 +------------------
>  include/linux/fs.h                            | 43 +++-----------
>  io_uring/rw.c                                 | 16 +-----
>  5 files changed, 13 insertions(+), 112 deletions(-)
> 
> diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
> index c88205132039..5558a44891bb 100644
> --- a/Documentation/filesystems/iomap/operations.rst
> +++ b/Documentation/filesystems/iomap/operations.rst
> @@ -488,10 +488,6 @@ These ``struct kiocb`` flags are significant for direct I/O with iomap:
>     Only meaningful for asynchronous I/O, and only if the entire I/O can
>     be issued as a single ``struct bio``.
>  
> - * ``IOCB_DIO_CALLER_COMP``: Try to run I/O completion from the caller's
> -   process context.
> -   See ``linux/fs.h`` for more details.
> -
>  Filesystems should call ``iomap_dio_rw`` from ``->read_iter`` and
>  ``->write_iter``, and set ``FMODE_CAN_ODIRECT`` in the ``->open``
>  function for the file.
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 15a7f8031084..2a86bb6fcd13 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -227,12 +227,6 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
>  	    !(file->f_mode & FMODE_CAN_ODIRECT))
>  		return -EINVAL;
>  
> -	/*
> -	 * Stacked filesystems don't support deferred completions, don't copy
> -	 * this property in case it is set by the issuer.
> -	 */
> -	flags &= ~IOCB_DIO_CALLER_COMP;
> -
>  	old_cred = override_creds(ctx->cred);
>  	if (is_sync_kiocb(iocb)) {
>  		rwf_t rwf = iocb_to_rw_flags(flags);
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b2f9fb89eb3..7659db85083a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -16,8 +16,7 @@
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> -#define IOMAP_DIO_NO_INVALIDATE	(1U << 25)
> -#define IOMAP_DIO_CALLER_COMP	(1U << 26)
> +#define IOMAP_DIO_NO_INVALIDATE	(1U << 26)
>  #define IOMAP_DIO_INLINE_COMP	(1U << 27)
>  #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1U << 29)
> @@ -140,11 +139,6 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_complete);
>  
> -static ssize_t iomap_dio_deferred_complete(void *data)
> -{
> -	return iomap_dio_complete(data);
> -}
> -
>  static void iomap_dio_complete_work(struct work_struct *work)
>  {
>  	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
> @@ -182,29 +176,6 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
> -	} else if (dio->flags & IOMAP_DIO_CALLER_COMP) {
> -		/*
> -		 * If this dio is flagged with IOMAP_DIO_CALLER_COMP, then
> -		 * schedule our completion that way to avoid an async punt to a
> -		 * workqueue.
> -		 */
> -		/* only polled IO cares about private cleared */
> -		iocb->private = dio;
> -		iocb->dio_complete = iomap_dio_deferred_complete;
> -
> -		/*
> -		 * Invoke ->ki_complete() directly. We've assigned our
> -		 * dio_complete callback handler, and since the issuer set
> -		 * IOCB_DIO_CALLER_COMP, we know their ki_complete handler will
> -		 * notice ->dio_complete being set and will defer calling that
> -		 * handler until it can be done from a safe task context.
> -		 *
> -		 * Note that the 'res' being passed in here is not important
> -		 * for this case. The actual completion value of the request
> -		 * will be gotten from dio_complete when that is run by the
> -		 * issuer.
> -		 */
> -		iocb->ki_complete(iocb, 0);
>  	} else {
>  		struct inode *inode = file_inode(iocb->ki_filp);
>  
> @@ -261,7 +232,6 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
>  			dio->flags |= IOMAP_DIO_INLINE_COMP;
>  			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
>  		}
> -		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>  		iomap_dio_done(dio);
>  	}
>  
> @@ -380,19 +350,6 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  
>  		if (!(bio_opf & REQ_FUA))
>  			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
> -
> -		/*
> -		 * We can only do deferred completion for pure overwrites that
> -		 * don't require additional I/O at completion time.
> -		 *
> -		 * This rules out writes that need zeroing or extent conversion,
> -		 * extend the file size, or issue metadata I/O or cache flushes
> -		 * during completion processing.
> -		 */
> -		if (need_zeroout || (pos >= i_size_read(inode)) ||
> -		    ((dio->flags & IOMAP_DIO_NEED_SYNC) &&
> -		     !(bio_opf & REQ_FUA)))
> -			dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>  	} else {
>  		bio_opf |= REQ_OP_READ;
>  	}
> @@ -413,7 +370,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  	 * ones we set for inline and deferred completions. If none of those
>  	 * are available for this IO, clear the polled flag.
>  	 */
> -	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
> +	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
>  		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>  
>  	if (need_zeroout) {
> @@ -669,15 +626,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		iomi.flags |= IOMAP_WRITE;
>  		dio->flags |= IOMAP_DIO_WRITE;
>  
> -		/*
> -		 * Flag as supporting deferred completions, if the issuer
> -		 * groks it. This can avoid a workqueue punt for writes.
> -		 * We may later clear this flag if we need to do other IO
> -		 * as part of this IO completion.
> -		 */
> -		if (iocb->ki_flags & IOCB_DIO_CALLER_COMP)
> -			dio->flags |= IOMAP_DIO_CALLER_COMP;
> -
>  		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
>  			ret = -EAGAIN;
>  			if (iomi.pos >= dio->i_size ||
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..e210d2d8af53 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -367,23 +367,9 @@ struct readahead_control;
>  #define IOCB_NOIO		(1 << 20)
>  /* can use bio alloc cache */
>  #define IOCB_ALLOC_CACHE	(1 << 21)
> -/*
> - * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
> - * iocb completion can be passed back to the owner for execution from a safe
> - * context rather than needing to be punted through a workqueue. If this
> - * flag is set, the bio completion handling may set iocb->dio_complete to a
> - * handler function and iocb->private to context information for that handler.
> - * The issuer should call the handler with that context information from task
> - * context to complete the processing of the iocb. Note that while this
> - * provides a task context for the dio_complete() callback, it should only be
> - * used on the completion side for non-IO generating completions. It's fine to
> - * call blocking functions from this callback, but they should not wait for
> - * unrelated IO (like cache flushing, new IO generation, etc).
> - */
> -#define IOCB_DIO_CALLER_COMP	(1 << 22)
>  /* kiocb is a read or write operation submitted by fs/aio.c. */
> -#define IOCB_AIO_RW		(1 << 23)
> -#define IOCB_HAS_METADATA	(1 << 24)
> +#define IOCB_AIO_RW		(1 << 22)
> +#define IOCB_HAS_METADATA	(1 << 23)
>  
>  /* for use in trace events */
>  #define TRACE_IOCB_STRINGS \
> @@ -400,7 +386,6 @@ struct readahead_control;
>  	{ IOCB_WAITQ,		"WAITQ" }, \
>  	{ IOCB_NOIO,		"NOIO" }, \
>  	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
> -	{ IOCB_DIO_CALLER_COMP,	"CALLER_COMP" }, \
>  	{ IOCB_AIO_RW,		"AIO_RW" }, \
>  	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
>  
> @@ -412,23 +397,13 @@ struct kiocb {
>  	int			ki_flags;
>  	u16			ki_ioprio; /* See linux/ioprio.h */
>  	u8			ki_write_stream;
> -	union {
> -		/*
> -		 * Only used for async buffered reads, where it denotes the
> -		 * page waitqueue associated with completing the read. Valid
> -		 * IFF IOCB_WAITQ is set.
> -		 */
> -		struct wait_page_queue	*ki_waitq;
> -		/*
> -		 * Can be used for O_DIRECT IO, where the completion handling
> -		 * is punted back to the issuer of the IO. May only be set
> -		 * if IOCB_DIO_CALLER_COMP is set by the issuer, and the issuer
> -		 * must then check for presence of this handler when ki_complete
> -		 * is invoked. The data passed in to this handler must be
> -		 * assigned to ->private when dio_complete is assigned.
> -		 */
> -		ssize_t (*dio_complete)(void *data);
> -	};
> +
> +	/*
> +	 * Only used for async buffered reads, where it denotes the page
> +	 * waitqueue associated with completing the read.
> +	 * Valid IFF IOCB_WAITQ is set.
> +	 */
> +	struct wait_page_queue	*ki_waitq;
>  };
>  
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 08882648d569..4d0ab8f50d14 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -277,7 +277,6 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	} else {
>  		rw->kiocb.ki_ioprio = get_current_ioprio();
>  	}
> -	rw->kiocb.dio_complete = NULL;
>  	rw->kiocb.ki_flags = 0;
>  	rw->kiocb.ki_write_stream = READ_ONCE(sqe->write_stream);
>  
> @@ -566,15 +565,6 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
>  
>  void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
>  {
> -	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> -	struct kiocb *kiocb = &rw->kiocb;
> -
> -	if ((kiocb->ki_flags & IOCB_DIO_CALLER_COMP) && kiocb->dio_complete) {
> -		long res = kiocb->dio_complete(rw->kiocb.private);
> -
> -		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
> -	}
> -
>  	io_req_io_end(req);
>  
>  	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
> @@ -589,10 +579,8 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>  	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
>  	struct io_kiocb *req = cmd_to_io_kiocb(rw);
>  
> -	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
> -		__io_complete_rw_common(req, res);
> -		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
> -	}
> +	__io_complete_rw_common(req, res);
> +	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
>  	req->io_task_work.func = io_req_rw_complete;
>  	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
>  }
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

