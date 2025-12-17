Return-Path: <io-uring+bounces-11147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB57CC79B6
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DDEC30A7A5E
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 12:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3918D337694;
	Wed, 17 Dec 2025 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x1a87Y4j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9OMR86TK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VQvTFX8T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yYQr/8ZG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85FB24B28
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974384; cv=none; b=fEnPpVnsUmweBOiK42QI2Hd1JAa7vx1rRSJpXdbg5uFJMi5kjT2/h3+++B1XdOTdVSccImVMhxYmzOuinfoVSppNc+jDqDyXM8qro9MZvrxLyFFFHLVd9bsx87Pqmd52C4UDaNHzifzJOV1D2sV4OLHOpD6kNIvMOQdYKGRAIX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974384; c=relaxed/simple;
	bh=N6FCDK5YOQId3cRcEpAC/iVZ4AVfHm3qzpefpkMU7ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYzGzq2jMUb34aU8TpF8iqc88DbfJNJcgznQpyq3zwTP9WGbLoMcJLPdIi5zjmgGWSXGf/rBJfrgcF1MYN08o9tNgYwEEC76Ejv956ZE7Ex/zQHuBFvpj8sZE6t9xdh9uV4ko6uBrdPbN8i9qW/3YQKsj0vWTDUvw4a6+ifhRf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x1a87Y4j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9OMR86TK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VQvTFX8T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yYQr/8ZG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9794C5BCF4;
	Wed, 17 Dec 2025 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qs9xr6mmXh79VYdcWbddHBgWQagTkTsBDQdsSumdZyQ=;
	b=x1a87Y4js/aX16ZBodGUl3i3r5/kAFf2s29afifYoCGCjsPnjgXhB9T56SQTrB8zAwuwr4
	/HNbUTbm6fBPmf42OFJLoATNYN+EAd+iC4bdqT4xOoozK7D14cVzfmIMtjechXHCYEdHnT
	xTkXR4a9mfrODRyADD1OUjvC5NpSQJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qs9xr6mmXh79VYdcWbddHBgWQagTkTsBDQdsSumdZyQ=;
	b=9OMR86TKCd75a3CH89DtszKgjaSBFvm6xJccfxy/lJ31ruEXmVBoJzHYxPtXgUsJpj4aNx
	iCvUE31mtbt+xgCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VQvTFX8T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="yYQr/8ZG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qs9xr6mmXh79VYdcWbddHBgWQagTkTsBDQdsSumdZyQ=;
	b=VQvTFX8TXiZ+TK1VxUXfHnc3CVeVxDj6s4LfIDopEXKmuOYxJbjCYpqHv/OeGcVNUqTjL2
	uHdBKfB0XzwCz41hatSttPq9X3y5Dp3oUMJWzmG/UBc1ncw28FRAN+OaTZ4PaLMZpQLnPG
	/vcwSladhyZ+/0QgqLgCV6M4oR0Vncw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qs9xr6mmXh79VYdcWbddHBgWQagTkTsBDQdsSumdZyQ=;
	b=yYQr/8ZGOSgz7U6HNXFYPDV9m/GzIgsuHj7go6nue3lfAqMcxS+REQEwt5f95LGXXUPEf1
	IqdSxw8P3YdpNxDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 876C33EA63;
	Wed, 17 Dec 2025 12:26:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9/8QIWOhQmnEFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 12:26:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0101A0927; Wed, 17 Dec 2025 13:26:10 +0100 (CET)
Date: Wed, 17 Dec 2025 13:26:10 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, io-uring@vger.kernel.org, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 06/10] fs: factor out a sync_lazytime helper
Message-ID: <ghtyup6znutbfgf6yi45frldntkh6vflyztia6xpndxz2xbux4@ex4ghikugyjp>
References: <20251217061015.923954-1-hch@lst.de>
 <20251217061015.923954-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217061015.923954-7-hch@lst.de>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,lst.de:email];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 9794C5BCF4
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Wed 17-12-25 07:09:39, Christoph Hellwig wrote:
> Centralize how we synchronize a lazytime update into the actual on-disk
> timestamp into a single helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c                | 22 +++++++++++++++-------
>  fs/inode.c                       |  5 +----
>  fs/internal.h                    |  3 ++-
>  fs/sync.c                        |  4 ++--
>  include/trace/events/writeback.h |  6 ------
>  5 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 7870c158e4a2..fa555e10d8b9 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1711,6 +1711,16 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
>  	}
>  }
>  
> +bool sync_lazytime(struct inode *inode)
> +{
> +	if (!(inode_state_read_once(inode) & I_DIRTY_TIME))
> +		return false;
> +
> +	trace_writeback_lazytime(inode);
> +	mark_inode_dirty_sync(inode);
> +	return true;
> +}
> +
>  /*
>   * Write out an inode and its dirty pages (or some of its dirty pages, depending
>   * on @wbc->nr_to_write), and clear the relevant dirty flags from i_state.
> @@ -1750,17 +1760,15 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	}
>  
>  	/*
> -	 * If the inode has dirty timestamps and we need to write them, call
> -	 * mark_inode_dirty_sync() to notify the filesystem about it and to
> -	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
> +	 * For data integrity writeback, or when the dirty interval expired,
> +	 * ask the file system to propagata lazy timestamp updates into real
> +	 * dirty state.
>  	 */
>  	if ((inode_state_read_once(inode) & I_DIRTY_TIME) &&
>  	    (wbc->sync_mode == WB_SYNC_ALL ||
>  	     time_after(jiffies, inode->dirtied_time_when +
> -			dirtytime_expire_interval * HZ))) {
> -		trace_writeback_lazytime(inode);
> -		mark_inode_dirty_sync(inode);
> -	}
> +			dirtytime_expire_interval * HZ)))
> +		sync_lazytime(inode);
>  
>  	/*
>  	 * Get and clear the dirty flags from i_state.  This needs to be done
> diff --git a/fs/inode.c b/fs/inode.c
> index 2c0d69f7fd01..f1c09fc0913d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1979,11 +1979,8 @@ void iput(struct inode *inode)
>  	if (atomic_add_unless(&inode->i_count, -1, 1))
>  		return;
>  
> -	if ((inode_state_read_once(inode) & I_DIRTY_TIME) && inode->i_nlink) {
> -		trace_writeback_lazytime_iput(inode);
> -		mark_inode_dirty_sync(inode);
> +	if (inode->i_nlink && sync_lazytime(inode))
>  		goto retry;
> -	}
>  
>  	spin_lock(&inode->i_lock);
>  	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink)) {
> diff --git a/fs/internal.h b/fs/internal.h
> index ab638d41ab81..18a062c1b5b0 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -214,7 +214,8 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
>  /*
>   * fs-writeback.c
>   */
> -extern long get_nr_dirty_inodes(void);
> +long get_nr_dirty_inodes(void);
> +bool sync_lazytime(struct inode *inode);
>  
>  /*
>   * dcache.c
> diff --git a/fs/sync.c b/fs/sync.c
> index 431fc5f5be06..4283af7119d1 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -183,8 +183,8 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  	if (!file->f_op->fsync)
>  		return -EINVAL;
> -	if (!datasync && (inode_state_read_once(inode) & I_DIRTY_TIME))
> -		mark_inode_dirty_sync(inode);
> +	if (!datasync)
> +		sync_lazytime(inode);
>  	return file->f_op->fsync(file, start, end, datasync);
>  }
>  EXPORT_SYMBOL(vfs_fsync_range);
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 311a341e6fe4..7162d03e69a5 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -856,12 +856,6 @@ DEFINE_EVENT(writeback_inode_template, writeback_lazytime,
>  	TP_ARGS(inode)
>  );
>  
> -DEFINE_EVENT(writeback_inode_template, writeback_lazytime_iput,
> -	TP_PROTO(struct inode *inode),
> -
> -	TP_ARGS(inode)
> -);
> -
>  DEFINE_EVENT(writeback_inode_template, writeback_dirty_inode_enqueue,
>  
>  	TP_PROTO(struct inode *inode),
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

