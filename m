Return-Path: <io-uring+bounces-3845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD149A69F1
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DC93280233
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 13:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CAE18E373;
	Mon, 21 Oct 2024 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k/a3Mo/S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8DsxXsRh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k/a3Mo/S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8DsxXsRh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B651E633C;
	Mon, 21 Oct 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729516918; cv=none; b=ccvEEiWidm90hvQFHqnWQVIM5a842aJOPMtTCrt3F/9DSiSW7r1AUTCF2f8zizuWaTjg+M2Y5dZ7B9bUnElDdvsQX3gKKTmNRwGPDYlPWldRkcLiiGd7xSM7Ec5RDaPP8UlFLbZG7niwr13Bc5/7NwUFp+1iaohVGtejm/0t+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729516918; c=relaxed/simple;
	bh=gHhDRNgJERw3V8HbyPTL9Af3Go1cL2efjlFfTYMYAUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCXaEvmIN3BOj+QfgNA5DJ139mVY6PaGBxYYwzqUKrdXR5aQNa6yR8SMyVgKbFGLKv5gK9tl0iqf4172qhU6xIruKmiS1weXCplhKgjufgBgYCmV1XElfrQRSjP2ZqBm27i2ukGjBZkt+xI/YmbbaqYOcPHEpt3ny8wcWgIZIs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k/a3Mo/S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8DsxXsRh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k/a3Mo/S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8DsxXsRh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1A9721B41;
	Mon, 21 Oct 2024 13:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729516913;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSJ3Whu7Jk2t7AN+/YOgPa0LEaNzM/iLyUsh2X00ZDw=;
	b=k/a3Mo/SE+viDPBqqhvo8Biz6iR4CNO1ofNUQd7JeNraCuFqWow2y625kYeZ9x8VQnZfX0
	VCYDhNhQHhc1fMenLC8fe5KSWJNlCAOH4nSI5mbIxKXn6+Nh8aMpCqjYyYaUOEsyadHePg
	Gwx95TAWf4SQszVbhf1x4LVF+UainCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729516913;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSJ3Whu7Jk2t7AN+/YOgPa0LEaNzM/iLyUsh2X00ZDw=;
	b=8DsxXsRhvQhdq6g3cx52NJ8d4jFbazqneQ/u32x0owAggSIcuby2tSahnBq+2C7w7u51J+
	g0yYzaYfX03IrvDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="k/a3Mo/S";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8DsxXsRh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729516913;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSJ3Whu7Jk2t7AN+/YOgPa0LEaNzM/iLyUsh2X00ZDw=;
	b=k/a3Mo/SE+viDPBqqhvo8Biz6iR4CNO1ofNUQd7JeNraCuFqWow2y625kYeZ9x8VQnZfX0
	VCYDhNhQHhc1fMenLC8fe5KSWJNlCAOH4nSI5mbIxKXn6+Nh8aMpCqjYyYaUOEsyadHePg
	Gwx95TAWf4SQszVbhf1x4LVF+UainCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729516913;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSJ3Whu7Jk2t7AN+/YOgPa0LEaNzM/iLyUsh2X00ZDw=;
	b=8DsxXsRhvQhdq6g3cx52NJ8d4jFbazqneQ/u32x0owAggSIcuby2tSahnBq+2C7w7u51J+
	g0yYzaYfX03IrvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D5F8136DC;
	Mon, 21 Oct 2024 13:21:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3j8xJnFVFmfhPwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Oct 2024 13:21:53 +0000
Date: Mon, 21 Oct 2024 15:21:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: change btrfs_encoded_read_regular_fill_pages
 to take a callback
Message-ID: <20241021132148.GB17835@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-3-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014171838.304953-3-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: B1A9721B41
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO

On Mon, Oct 14, 2024 at 06:18:24PM +0100, Mark Harmstone wrote:
> Change btrfs_encoded_read_regular_fill_pages so that it takes a callback
> rather than waiting, and add new helper function btrfs_encoded_read_wait_cb
> to match the existing behaviour.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>  fs/btrfs/btrfs_inode.h | 13 +++++++-
>  fs/btrfs/inode.c       | 70 ++++++++++++++++++++++++++++++++----------
>  fs/btrfs/send.c        | 15 ++++++++-
>  3 files changed, 79 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 3056c8aed8ef..6aea5bedc968 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -601,10 +601,21 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
>  int btrfs_writepage_cow_fixup(struct page *page);
>  int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
>  					     int compress_type);
> +typedef void (btrfs_encoded_read_cb_t)(void *, int);
> +
> +struct btrfs_encoded_read_wait_ctx {
> +	wait_queue_head_t wait;
> +	bool done;
> +	int err;

Please reorder that so it does not waste the bytes after 'done' to align
'err'

> +};
> +
> +void btrfs_encoded_read_wait_cb(void *ctx, int err);
>  int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>  					  u64 file_offset, u64 disk_bytenr,
>  					  u64 disk_io_size,
> -					  struct page **pages);
> +					  struct page **pages,
> +					  btrfs_encoded_read_cb_t cb,
> +					  void *cb_ctx);
>  ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>  			   struct btrfs_ioctl_encoded_io_args *encoded);
>  ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b024ebc3dcd6..b5abe98f3af4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9080,9 +9080,10 @@ static ssize_t btrfs_encoded_read_inline(
>  }
>  
>  struct btrfs_encoded_read_private {
> -	wait_queue_head_t wait;
>  	atomic_t pending;
>  	blk_status_t status;
> +	btrfs_encoded_read_cb_t *cb;
> +	void *cb_ctx;

Final version of this structure could be also reordered so it does not
leave unnecessary holes, I think status is u8 so it now fills the hole
after pending but I'm not sure now if other patches make more changes.

>  };
>  
>  static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
> @@ -9100,26 +9101,33 @@ static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
>  		 */
>  		WRITE_ONCE(priv->status, bbio->bio.bi_status);
>  	}
> -	if (!atomic_dec_return(&priv->pending))
> -		wake_up(&priv->wait);
> +	if (!atomic_dec_return(&priv->pending)) {

Though it's in the original code, please rewrite the condition so it
reads as an arithmetic condition, "== 0".

> +		priv->cb(priv->cb_ctx,
> +			 blk_status_to_errno(READ_ONCE(priv->status)));
> +		kfree(priv);
> +	}
>  	bio_put(&bbio->bio);
>  }

