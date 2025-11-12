Return-Path: <io-uring+bounces-10547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 130EBC5450A
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 21:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8DDE8345613
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 20:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF131C84BC;
	Wed, 12 Nov 2025 20:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cQ0HUPOE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6JJ2g3+g";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cQ0HUPOE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6JJ2g3+g"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF70B212FB9
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762977675; cv=none; b=BdUYQVBpeNHLGkM8thJzQn4l0mVsy7FzWOeEuY0ncFVJlGa8cOxGZEHnPiZXdk5o2VG//f8E9WldEQoh0JF0UA+j/AD9paWkAgtK3LxWTYP24SI3gksN6/JUqBoeAvoxYQIeWzdnk0Pvwq3ALoL6HTVAHriVwisqmvdsA/C1ZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762977675; c=relaxed/simple;
	bh=YtK1OyCwqDjMY90QSr67ySWnLA4nfv642DKX7fB/xSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RADF8G255oyckBJXvNNslqQNWhiY72DgU9v7HEeMX7t9VASwVIg+lVj06fFPAFTUhOGTDuYadzX1R3+XZJ6tYag600L1A0Wl/GcZziZd6VkX9RuR9WR+Z6nHT55YhVI8Iw3IiFjAhUBXiQvbzUsvtWRhe8IF+omrBhWlbDfNOCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cQ0HUPOE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6JJ2g3+g; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cQ0HUPOE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6JJ2g3+g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 970851F798;
	Wed, 12 Nov 2025 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762977671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+8XEn8cUPxIfpNjirevtHnURuFXv4ubUOeipd+Pkk=;
	b=cQ0HUPOEeHkdXeIcgF0drnoSyj+3Mlrgc2s0sHT+G5sYaBHTvFrseiTdzrMKXNZ0EZZeJY
	ieijHnwsTaZR9B2n1FGsKGcJ4B8MX15fm3I8lcGk1wlMrUd77992OQ1olr+Pa+yTu05Kug
	2TUXjTfGqAej8gpfCs6iT2Vc0blQf9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762977671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+8XEn8cUPxIfpNjirevtHnURuFXv4ubUOeipd+Pkk=;
	b=6JJ2g3+gNtyHXoLXrhkcOeFnHTuqxp8/vH67GR1LjHInDoX0WnOw6aSHc6CDCkdnb5gCA6
	DAKqDOvbFEBHocDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cQ0HUPOE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6JJ2g3+g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762977671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+8XEn8cUPxIfpNjirevtHnURuFXv4ubUOeipd+Pkk=;
	b=cQ0HUPOEeHkdXeIcgF0drnoSyj+3Mlrgc2s0sHT+G5sYaBHTvFrseiTdzrMKXNZ0EZZeJY
	ieijHnwsTaZR9B2n1FGsKGcJ4B8MX15fm3I8lcGk1wlMrUd77992OQ1olr+Pa+yTu05Kug
	2TUXjTfGqAej8gpfCs6iT2Vc0blQf9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762977671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+8XEn8cUPxIfpNjirevtHnURuFXv4ubUOeipd+Pkk=;
	b=6JJ2g3+gNtyHXoLXrhkcOeFnHTuqxp8/vH67GR1LjHInDoX0WnOw6aSHc6CDCkdnb5gCA6
	DAKqDOvbFEBHocDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BC953EA61;
	Wed, 12 Nov 2025 20:01:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eVweIofnFGl+eQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 12 Nov 2025 20:01:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 31084A06F7; Wed, 12 Nov 2025 21:01:11 +0100 (CET)
Date: Wed, 12 Nov 2025 21:01:11 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] iomap: always run error completions in user context
Message-ID: <hyya7rzf6aysxvjqooyjgjh4wuuxgtdwg4rz6ivv27ywedw4ws@4kpbdhq2varb>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-3-hch@lst.de>
X-Rspamd-Queue-Id: 970851F798
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,lst.de:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 12-11-25 08:21:26, Christoph Hellwig wrote:
> At least zonefs expects error completions to be able to sleep.  Because
> error completions aren't performance critical, just defer them to workqueue
> context unconditionally.
> 
> Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap/direct-io.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 7659db85083a..765ab6dd6637 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -173,7 +173,18 @@ static void iomap_dio_done(struct iomap_dio *dio)
>  
>  		WRITE_ONCE(dio->submit.waiter, NULL);
>  		blk_wake_io_task(waiter);
> -	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
> +		return;
> +	}
> +
> +	/*
> +	 * Always run error completions in user context.  These are not
> +	 * performance critical and some code relies on taking sleeping locks
> +	 * for error handling.
> +	 */
> +	if (dio->error)
> +		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +
> +	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
>  	} else {
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

