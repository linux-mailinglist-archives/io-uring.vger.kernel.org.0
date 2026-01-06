Return-Path: <io-uring+bounces-11418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 724BACF825F
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 12:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DFA10300EB9E
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 11:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0D331D727;
	Tue,  6 Jan 2026 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EuFRxB0G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XXAALmfo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EuFRxB0G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XXAALmfo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CA731A561
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 11:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767700279; cv=none; b=H1RaK7hxl3m2n9jCfP9t1kI/yfS0dCccYqG+1ioY8hYiJE2Cif60wzOhoDjAUSDHyorpEUDJTwsQNd8zoYe+JbK6OhwXoJnxmPI+21U317kyxTJrz8PQ+t1LCSSbcunlpbDWKryb86MOwIBsM4dCxPUxTv5R0QgLc90auH0BaKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767700279; c=relaxed/simple;
	bh=yunabenn+M4muFILcVpCqeIMPO4izH+uSBXR+0AKHm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLyIb4VMHoCnRALnA/jh8U0Lt85cUgZ0WlNsgyjyGAQHVgg6sKVv8Up+xlD5JInVDBn/SZD48FzUxLimvaViO0XqmahyRd5PalWNJis5Kh+08IIUzxQ8YcdL1h8WdCsDfmx6lFwKFVT6o56UeIE92JJ8CWlzFFI9pBQFLlgmf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EuFRxB0G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XXAALmfo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EuFRxB0G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XXAALmfo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91521339E5;
	Tue,  6 Jan 2026 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r+KPeQENvV+O/84zcPgyGQayvwQOIDU8ipu7wxTPCxY=;
	b=EuFRxB0GBUUK/2ME9+pf5w/rKS4fGtRjcOEF5CfsS+nuBArE5Xg7veXeSQeEUfh4mjygKi
	uIWzlDgK8iC6bgLhv0RnCYwt1hXbCRlo1itouoYoCfk5goifKDdMXA+XAdf+lGEDL/XvUC
	7Tgvw/bftvZ1Ds1gnU3ZLy16qdbk2Mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r+KPeQENvV+O/84zcPgyGQayvwQOIDU8ipu7wxTPCxY=;
	b=XXAALmfoLa5a0x3HtN4Xc0A+EewD+8htszWLKg9qx2rcCs2uBbJDcqESKRnY4nd12f9uuG
	3aV/TTSmqx/NEfBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r+KPeQENvV+O/84zcPgyGQayvwQOIDU8ipu7wxTPCxY=;
	b=EuFRxB0GBUUK/2ME9+pf5w/rKS4fGtRjcOEF5CfsS+nuBArE5Xg7veXeSQeEUfh4mjygKi
	uIWzlDgK8iC6bgLhv0RnCYwt1hXbCRlo1itouoYoCfk5goifKDdMXA+XAdf+lGEDL/XvUC
	7Tgvw/bftvZ1Ds1gnU3ZLy16qdbk2Mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r+KPeQENvV+O/84zcPgyGQayvwQOIDU8ipu7wxTPCxY=;
	b=XXAALmfoLa5a0x3HtN4Xc0A+EewD+8htszWLKg9qx2rcCs2uBbJDcqESKRnY4nd12f9uuG
	3aV/TTSmqx/NEfBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 853D43EA63;
	Tue,  6 Jan 2026 11:51:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R7eDIDP3XGmnZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Jan 2026 11:51:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3EDBEA08E3; Tue,  6 Jan 2026 12:51:00 +0100 (CET)
Date: Tue, 6 Jan 2026 12:51:00 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 09/11] fs: refactor file_update_time_flags
Message-ID: <t3klyln4eejq7olm3bseuje2lao6jh3a26kpzkdqrnak5l2sdh@ehrk2o6mmxfw>
References: <20260106075008.1610195-1-hch@lst.de>
 <20260106075008.1610195-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075008.1610195-10-hch@lst.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,lst.de:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Tue 06-01-26 08:50:03, Christoph Hellwig wrote:
> Split all the inode timestamp flags into a helper.  This not only
> makes the code a bit more readable, but also optimizes away the
> further checks as soon as know we need an update.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 01e4f6b9b46e..d2bfe302e647 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2378,31 +2378,30 @@ struct timespec64 current_time(struct inode *inode)
>  }
>  EXPORT_SYMBOL(current_time);
>  
> +static inline bool need_cmtime_update(struct inode *inode)
> +{
> +	struct timespec64 now = current_time(inode), ts;
> +
> +	ts = inode_get_mtime(inode);
> +	if (!timespec64_equal(&ts, &now))
> +		return true;
> +	ts = inode_get_ctime(inode);
> +	if (!timespec64_equal(&ts, &now))
> +		return true;
> +	return IS_I_VERSION(inode) && inode_iversion_need_inc(inode);
> +}
> +
>  static int file_update_time_flags(struct file *file, unsigned int flags)
>  {
>  	struct inode *inode = file_inode(file);
> -	struct timespec64 now, ts;
> -	bool need_update = false;
> -	int ret = 0;
> +	int ret;
>  
>  	/* First try to exhaust all avenues to not sync */
>  	if (IS_NOCMTIME(inode))
>  		return 0;
>  	if (unlikely(file->f_mode & FMODE_NOCMTIME))
>  		return 0;
> -
> -	now = current_time(inode);
> -
> -	ts = inode_get_mtime(inode);
> -	if (!timespec64_equal(&ts, &now))
> -		need_update = true;
> -	ts = inode_get_ctime(inode);
> -	if (!timespec64_equal(&ts, &now))
> -		need_update = true;
> -	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
> -		need_update = true;
> -
> -	if (!need_update)
> +	if (!need_cmtime_update(inode))
>  		return 0;
>  
>  	flags &= IOCB_NOWAIT;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

