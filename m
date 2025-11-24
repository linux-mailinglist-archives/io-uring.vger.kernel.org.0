Return-Path: <io-uring+bounces-10752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE57EC8014A
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 12:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E45E3A8136
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 11:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368E32FC887;
	Mon, 24 Nov 2025 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1ntrX0iG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yvgfZ7bU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1ntrX0iG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yvgfZ7bU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F7526ED5E
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763982323; cv=none; b=qo4tIAsAifnJ8sVfiteYaMaZccP2FOZiA+e5N7YcJJdu7c0m28x1xyfifWxbF3/FIBixElogeFLw6b/YAQdOrI2Y/3jKi9SA7lwok7zvM1XjjwfLIr4MuBKPdJWL8lBNCCS7GfcJJskpPWAfMdQXBjkWQOa+L1wyTWf2dhsz3Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763982323; c=relaxed/simple;
	bh=XJyeqKMfO7PvxWOB9KLoVnFlC5ukWtv8JvKs/92Fz7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsGGtM0WcP8AQP7AzkOA81Liq3E7sf8otkYqDLn9yy4CQWjZUya96dzWu4bgxOk9ThMibEQLvFJZ7GQ9RVwV8R9EN5QUNMid2ioQYNqm0xWCBRYLMNHc3EwfEOYHIhTuXHWfYVlzVZTopEmtKm/9Zz2Y1cfAMS+QcaNQUlA+y1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1ntrX0iG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yvgfZ7bU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1ntrX0iG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yvgfZ7bU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99887220E8;
	Mon, 24 Nov 2025 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763982318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTiFmNst004/hKep4SmkbhL1QIIT91eaNUaKbk4k4TQ=;
	b=1ntrX0iG0XhmSUsYVGtWMwqzFun938MPT3QwNJGRglK30Ys7/mb3uhXwEHVKTHiJ9L+cQk
	AilTY6HifZc2PuUDuDZrDi0HKOT3FFgaHOvpJXKzCIiP/7ahGBFK1B2Zs+OgF/NFOsxmH7
	TDfVg4mG03SwZ2CkP7Xo74FUBIZEIic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763982318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTiFmNst004/hKep4SmkbhL1QIIT91eaNUaKbk4k4TQ=;
	b=yvgfZ7bURf6lsqrWCg21sMEMG+jeUHpjhpnl6RUyVJuZWZrHJ3k2K6MMIwC6DhX4KvgkDM
	t1xl/BVP7HmieyAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763982318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTiFmNst004/hKep4SmkbhL1QIIT91eaNUaKbk4k4TQ=;
	b=1ntrX0iG0XhmSUsYVGtWMwqzFun938MPT3QwNJGRglK30Ys7/mb3uhXwEHVKTHiJ9L+cQk
	AilTY6HifZc2PuUDuDZrDi0HKOT3FFgaHOvpJXKzCIiP/7ahGBFK1B2Zs+OgF/NFOsxmH7
	TDfVg4mG03SwZ2CkP7Xo74FUBIZEIic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763982318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTiFmNst004/hKep4SmkbhL1QIIT91eaNUaKbk4k4TQ=;
	b=yvgfZ7bURf6lsqrWCg21sMEMG+jeUHpjhpnl6RUyVJuZWZrHJ3k2K6MMIwC6DhX4KvgkDM
	t1xl/BVP7HmieyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E0073EA61;
	Mon, 24 Nov 2025 11:05:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n0OpIu47JGl0SQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 11:05:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 14FC0A0A04; Mon, 24 Nov 2025 12:05:14 +0100 (CET)
Date: Mon, 24 Nov 2025 12:05:14 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 3/5] iomap: rework REQ_FUA selection
Message-ID: <saep4t5rujrszxabjiou5x5y5o26thwdyu3vr5wf6uvn6zxpf4@ybkwqxwl55d2>
References: <20251113170633.1453259-1-hch@lst.de>
 <20251113170633.1453259-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113170633.1453259-4-hch@lst.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu 13-11-25 18:06:28, Christoph Hellwig wrote:
> The way how iomap_dio_can_use_fua and the caller is structured is
> a bit confusing, as the main guarding condition is hidden in the
> helper, and the secondary conditions are split between caller and
> callee.
> 
> Refactor the code, so that iomap_dio_bio_iter itself tracks if a write
> might need metadata updates based on the iomap type and flags, and
> then have a condition based on that to use the FUA flag.
> 
> Note that this also moves the REQ_OP_WRITE assignment to the end of
> the branch to improve readability a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap/direct-io.c | 78 +++++++++++++++++++++++++++-----------------
>  1 file changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 765ab6dd6637..fb2d83f640ef 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -287,23 +287,6 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
>  	return 0;
>  }
>  
> -/*
> - * Use a FUA write if we need datasync semantics and this is a pure data I/O
> - * that doesn't require any metadata updates (including after I/O completion
> - * such as unwritten extent conversion) and the underlying device either
> - * doesn't have a volatile write cache or supports FUA.
> - * This allows us to avoid cache flushes on I/O completion.
> - */
> -static inline bool iomap_dio_can_use_fua(const struct iomap *iomap,
> -		struct iomap_dio *dio)
> -{
> -	if (iomap->flags & (IOMAP_F_SHARED | IOMAP_F_DIRTY))
> -		return false;
> -	if (!(dio->flags & IOMAP_DIO_WRITE_THROUGH))
> -		return false;
> -	return !bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev);
> -}
> -
>  static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  {
>  	const struct iomap *iomap = &iter->iomap;
> @@ -332,7 +315,24 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  		return -EINVAL;
>  
>  	if (dio->flags & IOMAP_DIO_WRITE) {
> -		bio_opf |= REQ_OP_WRITE;
> +		bool need_completion_work = true;
> +
> +		switch (iomap->type) {
> +		case IOMAP_MAPPED:
> +			/*
> +			 * Directly mapped I/O does not inherently need to do
> +			 * work at I/O completion time.  But there are various
> +			 * cases below where this will get set again.
> +			 */
> +			need_completion_work = false;
> +			break;
> +		case IOMAP_UNWRITTEN:
> +			dio->flags |= IOMAP_DIO_UNWRITTEN;
> +			need_zeroout = true;
> +			break;
> +		default:
> +			break;
> +		}
>  
>  		if (iomap->flags & IOMAP_F_ATOMIC_BIO) {
>  			/*
> @@ -345,22 +345,40 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  			bio_opf |= REQ_ATOMIC;
>  		}
>  
> -		if (iomap->type == IOMAP_UNWRITTEN) {
> -			dio->flags |= IOMAP_DIO_UNWRITTEN;
> -			need_zeroout = true;
> -		}
> -
> -		if (iomap->flags & IOMAP_F_SHARED)
> +		if (iomap->flags & IOMAP_F_SHARED) {
> +			/*
> +			 * Unsharing of needs to update metadata at I/O
> +			 * completion time.
> +			 */
> +			need_completion_work = true;
>  			dio->flags |= IOMAP_DIO_COW;
> +		}
>  
> -		if (iomap->flags & IOMAP_F_NEW)
> +		if (iomap->flags & IOMAP_F_NEW) {
> +			/*
> +			 * Newly allocated blocks might need recording in
> +			 * metadata at I/O completion time.
> +			 */
> +			need_completion_work = true;
>  			need_zeroout = true;
> -		else if (iomap->type == IOMAP_MAPPED &&
> -			 iomap_dio_can_use_fua(iomap, dio))
> -			bio_opf |= REQ_FUA;
> +		}
>  
> -		if (!(bio_opf & REQ_FUA))
> -			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
> +		/*
> +		 * Use a FUA write if we need datasync semantics and this is a
> +		 * pure overwrite that doesn't require any metadata updates.
> +		 *
> +		 * This allows us to avoid cache flushes on I/O completion.
> +		 */
> +		if (dio->flags & IOMAP_DIO_WRITE_THROUGH) {
> +			if (!need_completion_work &&
> +			    !(iomap->flags & IOMAP_F_DIRTY) &&
> +			    (!bdev_write_cache(iomap->bdev) ||
> +			     bdev_fua(iomap->bdev)))
> +				bio_opf |= REQ_FUA;
> +			else
> +				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
> +		}
> +		bio_opf |= REQ_OP_WRITE;
>  	} else {
>  		bio_opf |= REQ_OP_READ;
>  	}
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

