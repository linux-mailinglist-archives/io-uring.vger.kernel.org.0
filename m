Return-Path: <io-uring+bounces-10766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E524BC80C5D
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B152D344328
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB02305E3E;
	Mon, 24 Nov 2025 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vRufgBFl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="stlPtU5z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vRufgBFl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="stlPtU5z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80582305976
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763991076; cv=none; b=l2rBqK7AINW8RbkIk1dI0OFOWcqe+fyVBoYgMJCa0DYGbPDQ8kiKwWu6QjR2XuLyjhvU7TvgWEiZbC2b78vJHAz14xgyUDgsn5dMtpVbbSlfbFbDrJyROGgNgSmnnbRGpSKBR35wHUQKUTGmg8wIk2UDEV7V5ocKsVIDUsAJ85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763991076; c=relaxed/simple;
	bh=1C1bavEQ9llDaXRgP4dA+WAkGX18i1kqB1BR8DvPEnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fi3L40ibNVfPl58OILcrPXjb/fFTAMO/2D/bmCkQoY8OyQzM64xn8YpnAe/n9hBeIgtCC+XsqqeIKz2APTmeMAzSU6iumeyZ9jUGcCe4toUqji4vFS9TSbHRu+8vIEa9UD6Vdcl/B1dJicHnVii2NIU+mx8zz5ekfXgGV+UquOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vRufgBFl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=stlPtU5z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vRufgBFl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=stlPtU5z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 698F822389;
	Mon, 24 Nov 2025 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763991071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mf2fLCJ+jeW81FuVPLBs9rqu8dErI3KF//hwSxw3Imc=;
	b=vRufgBFlaBhxgVGfhXTPC9H1e0YBN8wrCoZ9A7r8z1KFJq3nEkneIVhIKeTw5zDfxirmQc
	Ugxys06Yko6/NKvP2ZC5pnyLfUGQTaNhBTZBuiwHH+0cxoh0BnYCenbgbg6EdZPIf+/NKK
	Uo1pLM86/odX1QvwaKCE/DcUARsz+9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763991071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mf2fLCJ+jeW81FuVPLBs9rqu8dErI3KF//hwSxw3Imc=;
	b=stlPtU5zigKUXL5Qb6dtWRjcSQQfKulrzaSKJC0dlGKt98uFqgP0iiOk5olJTkYT/kXTSO
	L+p/jaqSmw1K0FCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vRufgBFl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=stlPtU5z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763991071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mf2fLCJ+jeW81FuVPLBs9rqu8dErI3KF//hwSxw3Imc=;
	b=vRufgBFlaBhxgVGfhXTPC9H1e0YBN8wrCoZ9A7r8z1KFJq3nEkneIVhIKeTw5zDfxirmQc
	Ugxys06Yko6/NKvP2ZC5pnyLfUGQTaNhBTZBuiwHH+0cxoh0BnYCenbgbg6EdZPIf+/NKK
	Uo1pLM86/odX1QvwaKCE/DcUARsz+9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763991071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mf2fLCJ+jeW81FuVPLBs9rqu8dErI3KF//hwSxw3Imc=;
	b=stlPtU5zigKUXL5Qb6dtWRjcSQQfKulrzaSKJC0dlGKt98uFqgP0iiOk5olJTkYT/kXTSO
	L+p/jaqSmw1K0FCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 597873EA63;
	Mon, 24 Nov 2025 13:31:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fFZ5FR9eJGnvWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 13:31:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C5EE0A0A04; Mon, 24 Nov 2025 14:31:02 +0100 (CET)
Date: Mon, 24 Nov 2025 14:31:02 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 10/14] fs: factor out a sync_lazytime helper
Message-ID: <vkobnnw3ij2n47bhhooawbw546dgwzii32nfqcx4bduoga5d7r@vdo5ryq4mffz>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-11-hch@lst.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 698F822389
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.01

On Fri 14-11-25 07:26:13, Christoph Hellwig wrote:
> Centralize how we synchronize a lazytime update into the actual on-disk
> timestamp into a single helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

>  	/*
> -	 * If the inode has dirty timestamps and we need to write them, call
> -	 * mark_inode_dirty_sync() to notify the filesystem about it and to
> -	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
> +	 * For data integrity writeback, or when the dirty interval expired,
> +	 * ask the file system to propagata lazy timestamp updates into real
> +	 * dirty state.
>  	 */
> -	if ((inode->i_state & I_DIRTY_TIME) &&
> -	    (wbc->sync_mode == WB_SYNC_ALL ||
> -	     time_after(jiffies, inode->dirtied_time_when +
> -			dirtytime_expire_interval * HZ))) {
> -		trace_writeback_lazytime(inode);
> -		mark_inode_dirty_sync(inode);
> -	}
> +	if (wbc->sync_mode == WB_SYNC_ALL ||
> +	    time_after(jiffies, inode->dirtied_time_when +
> +			dirtytime_expire_interval * HZ))
> +		sync_lazytime(inode);

The checking of inode->dirtied_time_when for inode potentially without
I_DIRTY_TIME set (and thus with unclear value of dirtied_time_when) is kind
of odd. It is harmless but IMO still not a good practice. Can't we keep
this condition as is and just call sync_lazytime()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

