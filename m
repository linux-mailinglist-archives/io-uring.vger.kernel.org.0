Return-Path: <io-uring+bounces-10548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB9BC54600
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 21:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60523AB795
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 20:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE67E1C84BC;
	Wed, 12 Nov 2025 20:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zLA86m9v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BgGUfkMh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zLA86m9v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BgGUfkMh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D227E040
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762978044; cv=none; b=o+wzOuG6C4LLXd4scoLVXl6nrxIxwpp2aEWb+4KYBaXwaYj7FT3iJA1xSabJBKcv5hCAk5exr1D4jgMbpABGH54RaD/ap3SuWtBiJHR4ofAjPAZNK8yZkk/pa7iPAvh9MuIcc3c98jbInGpTR4hi5u/KoM1lM+ywm06tkmZwi4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762978044; c=relaxed/simple;
	bh=OyELlum8rnqP+3OWIJjw1GtiA9eHW7s/L24OaJS7nxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvYfsuIlGkA192mQOBiqcXXCdtTFuria44+1IOpZ+HP8SzSXhWxh7y+eNgofHRklsXxN2XOk388T76YGcjJIntiPHQDKBLO1Y92kDe9x6T40jtJR0lJS88xFEXu5zTM8GhCQxRgwdx5YcWAVegdKHJLv9dsDaPtP8Xv+XYPnppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zLA86m9v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BgGUfkMh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zLA86m9v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BgGUfkMh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 246EC1F798;
	Wed, 12 Nov 2025 20:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762978041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtZw85MEtkqlQI5Jqgm3WsmuZxCe+UQOLkKFFKSJNHw=;
	b=zLA86m9vA+DqfF3fjr7WVhDUYklfGbcNvP9B699k8OGr+3A2Iy1QuoRrlwDB1Pi7uf2w3b
	0QNS1Arh8sHXf1PzFuxHGQHMewTZINw8eTXdoEuKuvhLrrpEEsHpPS1FJWyO7taVgFC/kt
	v7JM6TNGoNoEzzIVRzkgM7nJtMasOxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762978041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtZw85MEtkqlQI5Jqgm3WsmuZxCe+UQOLkKFFKSJNHw=;
	b=BgGUfkMh4Dk2tCUfEV4IfA8b6kH1xDx2y6LiF06j9VCWpNSDQwvAEf5Jmmj4vw2CMQD9px
	T5Nop1wGp3ZzbpCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762978041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtZw85MEtkqlQI5Jqgm3WsmuZxCe+UQOLkKFFKSJNHw=;
	b=zLA86m9vA+DqfF3fjr7WVhDUYklfGbcNvP9B699k8OGr+3A2Iy1QuoRrlwDB1Pi7uf2w3b
	0QNS1Arh8sHXf1PzFuxHGQHMewTZINw8eTXdoEuKuvhLrrpEEsHpPS1FJWyO7taVgFC/kt
	v7JM6TNGoNoEzzIVRzkgM7nJtMasOxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762978041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qtZw85MEtkqlQI5Jqgm3WsmuZxCe+UQOLkKFFKSJNHw=;
	b=BgGUfkMh4Dk2tCUfEV4IfA8b6kH1xDx2y6LiF06j9VCWpNSDQwvAEf5Jmmj4vw2CMQD9px
	T5Nop1wGp3ZzbpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 160D13EA61;
	Wed, 12 Nov 2025 20:07:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t8gdBfnoFGkCfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 12 Nov 2025 20:07:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C5F7BA06F7; Wed, 12 Nov 2025 21:07:20 +0100 (CET)
Date: Wed, 12 Nov 2025 21:07:20 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 3/5] iomap: rework REQ_FUA selection
Message-ID: <7ew6yrzcgv7v6ckhmw4oxw7bjx37n4dabzdlbbs6gpowcph2yk@4qaombbiigik>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-4-hch@lst.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,lst.de:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Wed 12-11-25 08:21:27, Christoph Hellwig wrote:
> The way how iomap_dio_can_use_fua and the caller is structured is
> a bit confusing, as the main guarding condition is hidden in the
> helper, and the secondary conditions are split between caller and
> callee.
> 
> Refactor the code, so that there is a main IOMAP_DIO_WRITE_THROUGH
> guard in iomap_dio_bio_iter, which is directly tied to clearing it
> when not supported, and a helper that just checks if the I/O is a
> pure overwrite.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One nit below but feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> -static inline bool iomap_dio_can_use_fua(const struct iomap *iomap,
> -		struct iomap_dio *dio)
> +static inline bool iomap_dio_is_overwrite(const struct iomap *iomap)
>  {
> -	if (iomap->flags & (IOMAP_F_SHARED | IOMAP_F_DIRTY))
> +	if (iomap->type != IOMAP_MAPPED)
>  		return false;
> -	if (!(dio->flags & IOMAP_DIO_WRITE_THROUGH))
> -		return false;
> -	return !bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev);
> +	return !(iomap->flags & (IOMAP_F_NEW | IOMAP_F_SHARED));
>  }

I'm a bit puzzled why did you leave IOMAP_F_DIRTY check in the caller.
Because that means we need metadata update to make the extent stable as the
comment before this function states...

								Honza

>  static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
> @@ -355,12 +349,22 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  
>  		if (iomap->flags & IOMAP_F_NEW)
>  			need_zeroout = true;
> -		else if (iomap->type == IOMAP_MAPPED &&
> -			 iomap_dio_can_use_fua(iomap, dio))
> -			bio_opf |= REQ_FUA;
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
> +			if (iomap_dio_is_overwrite(iomap) &&
> +			    !(iomap->flags & IOMAP_F_DIRTY) &&
> +			    (!bdev_write_cache(iomap->bdev) ||
> +			     bdev_fua(iomap->bdev)))
> +				bio_opf |= REQ_FUA;
> +			else
> +				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
> +		}
>  	} else {
>  		bio_opf |= REQ_OP_READ;
>  	}
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

