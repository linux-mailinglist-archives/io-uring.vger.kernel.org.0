Return-Path: <io-uring+bounces-11148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D504FCC79DD
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8162330194C7
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 12:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEF431C56F;
	Wed, 17 Dec 2025 12:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="If/0ScIB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6k6j+GIM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SQv+2cat";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eHxNyqf3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A42561A2
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974628; cv=none; b=sVuLL+MV+b/5grEYSf13e/mumuKzudmyb7+zHLhBGkX3oTq3KygvLpMDz/K5nFDKYCCc+WxXJFOYBIUopnWFrP3h51nuQhQXPx8242hp2KICsR7QPDN6LTCaPCNWZcXi8lbtjru1cDJ5kWV0JEVsnQrVGLA2kkUj+m5+PfWKOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974628; c=relaxed/simple;
	bh=rc/OZnIfrpKFc9aOcZfe3w9Hjyrs0c4OOzVAIRSi47E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8BEHAzgWwQGbqCRY4jkTyDYdRP7a3hGXdknP7pw8nuz6VSF3nIvkT2pc6O8v4gHZaHX1PZPkaHUzHwr4EdeThip9RCjFMZwbFZhsN75XH0lmEtz9Nm6RCOP2bTC4RleD4HwXDi5mPYsm6E8hKelykLji2Y+E/1R17D8ujGGglA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=If/0ScIB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6k6j+GIM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SQv+2cat; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eHxNyqf3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7F255BCF6;
	Wed, 17 Dec 2025 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSf9spPIi1Qf/2K9X4gmxIrPuIqQb2l81Ji+pztCBkI=;
	b=If/0ScIBJTOcR0mlvXYPhmWw19jh3FlYB27VviwciIsxHGkKfOZE2PVvpEd6evZWn/igXQ
	uMdtXNSCN6viplx1nZNFLmFVBbPYzFjpIIeLdEA7Izm6XdEW2ZsGDlZxn2JlzbqDw80W4K
	Gw6NOndu2DFJNINDEOHJM2IFDoZxMs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSf9spPIi1Qf/2K9X4gmxIrPuIqQb2l81Ji+pztCBkI=;
	b=6k6j+GIModzpCK+q4SIEFCozl1jxg53PQuZXu3tTqCit5JPoCHdBRFAd0rdyigEP+pbogN
	urUVinppOBPG2kDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SQv+2cat;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eHxNyqf3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSf9spPIi1Qf/2K9X4gmxIrPuIqQb2l81Ji+pztCBkI=;
	b=SQv+2catA0Gtyh6nroPcclKZiXKeoL8nhL0CG39aEqTWTXoM6RXRnUYTnkvo6jZrrTC3rs
	cdLUHgT3q5IVbe9ZAGl4gwDClbE3MrHpRjKEXMlI011Rw/e6N/RGsoRn4JOsCdRCtEy4+8
	W0sFvlQvjZU9rX5I6cOjMNQEfpIvGS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSf9spPIi1Qf/2K9X4gmxIrPuIqQb2l81Ji+pztCBkI=;
	b=eHxNyqf3e/pzjyAWK1/B2E/g/j8E8482kxzz80g38Nodf/kpdIpXaPD8Zu1sLANN8zZTm3
	FOF7bn1TDMS0N5Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACDE53EA63;
	Wed, 17 Dec 2025 12:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LM8vKl+iQmlsGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 12:30:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F41CEA0927; Wed, 17 Dec 2025 13:30:18 +0100 (CET)
Date: Wed, 17 Dec 2025 13:30:18 +0100
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
Subject: Re: [PATCH 07/10] fs: add a ->sync_lazytime method
Message-ID: <ghtgokkzdo7owrkfkpittqlc6xvjhr5w4eprbq5gcszqpmy7z3@7m3ecvlqfrzu>
References: <20251217061015.923954-1-hch@lst.de>
 <20251217061015.923954-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217061015.923954-8-hch@lst.de>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[lst.de:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email,lst.de:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: C7F255BCF6
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Wed 17-12-25 07:09:40, Christoph Hellwig wrote:
> Allow the file system to explicitly implement lazytime syncing instead
> of pigging back on generic inode dirtying.  This allows to simplify
> the XFS implementation and prepares for non-blocking lazytime timestamp
> updates.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

...

>  	if (flags & I_DIRTY_INODE) {
> +		bool was_dirty_time =
> +			inode_state_read_once(inode) & I_DIRTY_TIME;
> +
>  		/*
>  		 * Inode timestamp update will piggback on this dirtying.
>  		 * We tell ->dirty_inode callback that timestamps need to
>  		 * be updated by setting I_DIRTY_TIME in flags.
>  		 */
> -		if (inode_state_read_once(inode) & I_DIRTY_TIME) {
> +		if (was_dirty_time) {
>  			spin_lock(&inode->i_lock);
>  			if (inode_state_read(inode) & I_DIRTY_TIME) {
>  				inode_state_clear(inode, I_DIRTY_TIME);
>  				flags |= I_DIRTY_TIME;
> +				was_dirty_time = true;

This looks bogus. was_dirty_time is already true here. What I think you
wanted here is to set it to false if locked I_DIRTY_TIME check failed.
Otherwise the patch looks good.

								Honza

>  			}
>  			spin_unlock(&inode->i_lock);
>  		}
> @@ -2591,9 +2598,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 * for just I_DIRTY_PAGES or I_DIRTY_TIME.
>  		 */
>  		trace_writeback_dirty_inode_start(inode, flags);
> -		if (sb->s_op->dirty_inode)
> +		if (sb->s_op->dirty_inode) {
>  			sb->s_op->dirty_inode(inode,
>  				flags & (I_DIRTY_INODE | I_DIRTY_TIME));
> +		} else if (was_dirty_time && inode->i_op->sync_lazytime) {
> +			inode->i_op->sync_lazytime(inode);
> +		}
>  		trace_writeback_dirty_inode(inode, flags);
>  
>  		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 75d5f38b08c9..255eb3b42d1d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2011,6 +2011,7 @@ struct inode_operations {
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
>  		      u64 len);
>  	int (*update_time)(struct inode *, int);
> +	void (*sync_lazytime)(struct inode *inode);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

