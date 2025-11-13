Return-Path: <io-uring+bounces-10602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C73C57576
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9EDA534430E
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EC834CFCE;
	Thu, 13 Nov 2025 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KivncAE3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C+jy3llA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KivncAE3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C+jy3llA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B3234AB09
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035793; cv=none; b=UprGkRbK6i0o/BGkXg6ibS9rskexjQQmum9MQdlzFOa6jTYRM+ME4RmkpDC8xwHalwmCUNrymG0NQKSM0Dg9IgWZ5dLVYw+2q4sskFxNGxmdzt2DEpiaQLWiO+2wCsbVV185IvhwnIs+FafAlZd7DBVtTk77uXy61OY2STcdGP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035793; c=relaxed/simple;
	bh=vnS5alNDilSOTFfRwEDdWzskFA9OhfS3UnnUAzOExcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJcEQwegeOyeux+AV0Hk2ofHIH1PugPOC7fgguTMH8yJlsarALEQUQIc8tuDjXkbkwNXATGQ7ssFmrY5Bh1AtoLeTj1v5whYcMWBZwhLgtmBBmwaFrGgjRDJc0t1KZmvKOe1eHv7KEljero4e1uO2VY2T2UQ9ztIrwwnd5jeW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KivncAE3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C+jy3llA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KivncAE3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C+jy3llA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9936221244;
	Thu, 13 Nov 2025 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763035789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHCpZkXa/VrMhpscylYUFvAzZJtXIi3fc6XVT5dMQS0=;
	b=KivncAE3Xxr9+7gllKkyAiDIJRo57GrL2NqKFe0W32Y4iTcW6PSWNOtaycehYCTCJnE865
	cJnMoA4I/8auGwQ4Y9eMOKEVOS+Jkt7cYTp4E8S/P0cIs/elqFCPokx87KRcfnBT9otCoq
	rg6LbpbB3JUarFvDTkkkJz3E0TxANaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763035789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHCpZkXa/VrMhpscylYUFvAzZJtXIi3fc6XVT5dMQS0=;
	b=C+jy3llADAkW5T+86cUfebzyyQj+96HwcFEahTr3pBVKCn743IytNj4CMmJx3s2PHV0Gsz
	aInE2QRiXneAugDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763035789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHCpZkXa/VrMhpscylYUFvAzZJtXIi3fc6XVT5dMQS0=;
	b=KivncAE3Xxr9+7gllKkyAiDIJRo57GrL2NqKFe0W32Y4iTcW6PSWNOtaycehYCTCJnE865
	cJnMoA4I/8auGwQ4Y9eMOKEVOS+Jkt7cYTp4E8S/P0cIs/elqFCPokx87KRcfnBT9otCoq
	rg6LbpbB3JUarFvDTkkkJz3E0TxANaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763035789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHCpZkXa/VrMhpscylYUFvAzZJtXIi3fc6XVT5dMQS0=;
	b=C+jy3llADAkW5T+86cUfebzyyQj+96HwcFEahTr3pBVKCn743IytNj4CMmJx3s2PHV0Gsz
	aInE2QRiXneAugDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BB873EA61;
	Thu, 13 Nov 2025 12:09:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lA0aIo3KFWmwFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 12:09:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 43BFAA0976; Thu, 13 Nov 2025 13:09:45 +0100 (CET)
Date: Thu, 13 Nov 2025 13:09:45 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 5/5] iomap: invert the polarity of IOMAP_DIO_INLINE_COMP
Message-ID: <twqkem75v5gotkt4jidhjvgrm7332chuwxh2zfh27obb2tqhmx@h4fqfffxdxg2>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-6-hch@lst.de>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Wed 12-11-25 08:21:29, Christoph Hellwig wrote:
> Replace IOMAP_DIO_INLINE_COMP with a flag to indicate that the
> completion should be offloaded.  This removes a tiny bit of boilerplate
> code, but more importantly just makes the code easier to follow as this
> new flag gets set most of the time and only cleared in one place, while
> it was the inverse for the old version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap/direct-io.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index df313232f422..80ec3ff4e5dd 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -17,7 +17,7 @@
>   * iomap.h:
>   */
>  #define IOMAP_DIO_NO_INVALIDATE	(1U << 26)
> -#define IOMAP_DIO_INLINE_COMP	(1U << 27)
> +#define IOMAP_DIO_COMP_WORK	(1U << 27)
>  #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1U << 29)
>  #define IOMAP_DIO_WRITE		(1U << 30)
> @@ -182,7 +182,7 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  	 * for error handling.
>  	 */
>  	if (dio->error)
> -		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +		dio->flags |= IOMAP_DIO_COMP_WORK;
>  
>  	/*
>  	 * Never invalidate pages from this context to avoid deadlocks with
> @@ -192,17 +192,14 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  	 * right between this check and the actual completion.
>  	 */
>  	if ((dio->flags & IOMAP_DIO_WRITE) &&
> -	    (dio->flags & IOMAP_DIO_INLINE_COMP)) {
> +	    !(dio->flags & IOMAP_DIO_COMP_WORK)) {
>  		if (dio->iocb->ki_filp->f_mapping->nrpages)
> -			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +			dio->flags |= IOMAP_DIO_COMP_WORK;
>  		else
>  			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
>  	}
>  
> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
> -		WRITE_ONCE(iocb->private, NULL);
> -		iomap_dio_complete_work(&dio->aio.work);
> -	} else {
> +	if (dio->flags & IOMAP_DIO_COMP_WORK) {
>  		struct inode *inode = file_inode(iocb->ki_filp);
>  
>  		/*
> @@ -213,7 +210,11 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  		 */
>  		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>  		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> +		return;
>  	}
> +
> +	WRITE_ONCE(iocb->private, NULL);
> +	iomap_dio_complete_work(&dio->aio.work);
>  }
>  
>  void iomap_dio_bio_end_io(struct bio *bio)
> @@ -251,7 +252,7 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
>  		 * that we are already called from the ioend completion
>  		 * workqueue.
>  		 */
> -		dio->flags |= IOMAP_DIO_INLINE_COMP;
> +		dio->flags &= ~IOMAP_DIO_COMP_WORK;
>  		iomap_dio_done(dio);
>  	}
>  
> @@ -383,7 +384,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  		 * or extend the file size.
>  		 */
>  		if (!iomap_dio_is_overwrite(iomap))
> -			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +			dio->flags |= IOMAP_DIO_COMP_WORK;
>  	} else {
>  		bio_opf |= REQ_OP_READ;
>  	}
> @@ -404,7 +405,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  	 * ones we set for inline and deferred completions. If none of those
>  	 * are available for this IO, clear the polled flag.
>  	 */
> -	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
> +	if (dio->flags & IOMAP_DIO_COMP_WORK)
>  		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>  
>  	if (need_zeroout) {
> @@ -643,12 +644,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
>  		dio->flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
>  
> -	/*
> -	 * Try to complete inline if we can.  For reads this is always possible,
> -	 * but for writes we'll end up clearing this more often than not.
> -	 */
> -	dio->flags |= IOMAP_DIO_INLINE_COMP;
> -
>  	if (iov_iter_rw(iter) == READ) {
>  		if (iomi.pos >= dio->i_size)
>  			goto out_free_dio;
> @@ -695,7 +690,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		 * Inode size updates must to happen from process context.
>  		 */
>  		if (iomi.pos + iomi.len > dio->i_size)
> -			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +			dio->flags |= IOMAP_DIO_COMP_WORK;
>  
>  		/*
>  		 * Try to invalidate cache pages for the range we are writing.
> @@ -776,7 +771,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
>  	else if (dio->flags & IOMAP_DIO_NEED_SYNC)
> -		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +		dio->flags |= IOMAP_DIO_COMP_WORK;
>  
>  	/*
>  	 * We are about to drop our additional submission reference, which
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

