Return-Path: <io-uring+bounces-10549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D635C54766
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 21:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DB6F34F49ED
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 20:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB432C11F1;
	Wed, 12 Nov 2025 20:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SWM6oR4h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aGBVgf1Z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yec9KDRU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DznqdpZs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396372C11CA
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 20:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979170; cv=none; b=D1uln7D0zd3PLgAPShgwU0hEcEtM8hFw6h1zpGZ6ZpQbXS2IDcbWwzirwdEpvY5lkF15sblRTicq7P5UZPUzT5q2FKOEAGU10zzonW/UhUX68fwIPJHbx0itZe72w3CP+JuzqNri1Rc0tDVqUtIxQ/FLFkf7AI9tGzp/q11+Crg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979170; c=relaxed/simple;
	bh=v0SjqgH+YG1sZwa5Ba9D/5N785IsWxSnZX1SoUdFBt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBspEcy0tA9DdgpArDASqQIrl1Ssd1mF+xRw+SYA4x/CuHuV1tneaJeX2x4DHG8sxTc42UdEGr58d9xQCZWOVTDmzBBfOmODc6w6YB+ZT68Pmto7E76EboBTX2IMOkHQtdR1N8VLrt0GTb78ZWTfnpUASnoIPxZfemmRgN4M9ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SWM6oR4h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aGBVgf1Z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yec9KDRU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DznqdpZs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0EC121A92;
	Wed, 12 Nov 2025 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762979167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpekitoZ7m8MJi0nsXMgz3mH/y4dzIu7lcdTuhiD7lY=;
	b=SWM6oR4hgrZr2R3OORKUVgAdf+s+gFirgoqywGOMhcwMMkwmMudRcGQ1ZcCDg8O2P1UAUw
	uAWjKgctCLMA46+tK6vb44Ak+w/fdHFHGYLlnqq612d/+zmPLEsEyvSFurX4oRJHTbVD62
	2d448tJ/171d73xvgn3lWq2AGPeAja4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762979167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpekitoZ7m8MJi0nsXMgz3mH/y4dzIu7lcdTuhiD7lY=;
	b=aGBVgf1ZRjqxtPWVwXXp7cDBo29ZypYxozmaCN8KpYsXlymY9FYNNUuXw7T2IlSxLmPp6R
	nMPnlUP8SJFiXFBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yec9KDRU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DznqdpZs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762979166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpekitoZ7m8MJi0nsXMgz3mH/y4dzIu7lcdTuhiD7lY=;
	b=yec9KDRUiK3W8Xf7v6mu2j26/AnJmD+obOjGqpMvbom+vVt/fP0nrqc7R6LV6a5PwjX3Wr
	12s34mKqO3nOfAsDKHIFsyOt2jmrIJj59MV89scLdDRJ5uu6L+IsmDHQNN9MkeQr6TJNM8
	ouECsT7WpUpOdRlHs0KnK5mB0eSbu08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762979166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpekitoZ7m8MJi0nsXMgz3mH/y4dzIu7lcdTuhiD7lY=;
	b=DznqdpZsawoQbn5lI8+e3l+2vCod2Sv8nk3K1d0ESqERHzmkn2dXbiNyjqROz7nlLprWmk
	/1an6zKkG2GTjzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2F103EA61;
	Wed, 12 Nov 2025 20:26:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w+r/Nl7tFGn7EQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 12 Nov 2025 20:26:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7CE24A06F7; Wed, 12 Nov 2025 21:25:58 +0100 (CET)
Date: Wed, 12 Nov 2025 21:25:58 +0100
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
Message-ID: <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-5-hch@lst.de>
X-Rspamd-Queue-Id: F0EC121A92
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 12-11-25 08:21:28, Christoph Hellwig wrote:
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
...
> @@ -365,6 +374,16 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  			else
>  				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
>  		}
> +
> +		/*
> +		 * We can only do inline completion for pure overwrites that
> +		 * don't require additional I/O at completion time.
> +		 *
> +		 * This rules out writes that need zeroing or extent conversion,
> +		 * or extend the file size.
> +		 */
> +		if (!iomap_dio_is_overwrite(iomap))
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
>  	} else {
>  		bio_opf |= REQ_OP_READ;
>  	}

OK, now I see why you wrote iomap_dio_is_overwrite() the way you did. You
still want to keep completions inline for overwrites of possibly
uncommitted extents. But I have to admit it all seems somewhat fragile and
difficult to follow. Can't we just check for IOMAP_DIO_UNWRITTEN |
IOMAP_DIO_COW | IOMAP_DIO_NEED_SYNC in flags (plus the i_size check) and be
done with it?

								Honza

> @@ -669,6 +691,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
>  		}
>  
> +		/*
> +		 * Inode size updates must to happen from process context.
> +		 */
> +		if (iomi.pos + iomi.len > dio->i_size)
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +
>  		/*
>  		 * Try to invalidate cache pages for the range we are writing.
>  		 * If this invalidation fails, let the caller fall back to
> @@ -741,9 +769,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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

