Return-Path: <io-uring+bounces-10774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D48C81EE7
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 18:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B71A13ABA58
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 17:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A13823C516;
	Mon, 24 Nov 2025 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pAANx02d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4c/b4Sor";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pAANx02d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4c/b4Sor"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F004284671
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005799; cv=none; b=Ajyo5A2wt/3ful/pemkXj/3+bLkg4n6CPR5gMTOoaC71BT3DohgcrS5m/d4kOs/01M7V4WhJKnNynKLyDlIKS5QiZzH40pyrVzfiRxa9+FWI9iHbYIUp3E3Q/7t/2OR26BU29LHPXXG+gMVvP3PAGQJ6fyJ90SDZPf98FPgKQL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005799; c=relaxed/simple;
	bh=G0LQ82Mldli948S1XVknyxbrkZD+BoCECMs/OrXffn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjjZzgHYnsUGT6osXTYCTn1BWurYhmHwnWLkqNKqGmiwttceZqI+F4W+riZJzTgahOl9pRYp95xvII8zR+RpaCaQmrdudnoZH4Z3p3wUXurkFMzmdjWFvaAUXMxgMfQH46sDgDMkZSD5MYtdd9SN7Kir4r64/Abw+yc8rGO0u7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pAANx02d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4c/b4Sor; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pAANx02d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4c/b4Sor; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B46B75BCC2;
	Mon, 24 Nov 2025 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764005795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b2IZs/iJywacdojXMvk6M27OfFIstOkeVS4WvVUZksU=;
	b=pAANx02dXtFmVRv/b9/4fjYVaw9bU37MXsjfLUgb9Cm1odeC+dn7vCZi8K1qqa4bAB6Pl+
	PqBFI/lIRYgRfEawFwH+UMghvcc/L7DAPq9DWBLx6yzeut/8sx8X1cpY1I9UXgigltupUu
	JnReC0hSGKvh/HAxZhite2NOXbb5sSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764005795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b2IZs/iJywacdojXMvk6M27OfFIstOkeVS4WvVUZksU=;
	b=4c/b4Sor5YE0OMWOxhE09AyRQJZAtjf+C7NRbXkGiEImIBGvtmrqI9n3KIFLTNyYlFmvYX
	CoxaZK82MJuNcOBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pAANx02d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4c/b4Sor"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764005795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b2IZs/iJywacdojXMvk6M27OfFIstOkeVS4WvVUZksU=;
	b=pAANx02dXtFmVRv/b9/4fjYVaw9bU37MXsjfLUgb9Cm1odeC+dn7vCZi8K1qqa4bAB6Pl+
	PqBFI/lIRYgRfEawFwH+UMghvcc/L7DAPq9DWBLx6yzeut/8sx8X1cpY1I9UXgigltupUu
	JnReC0hSGKvh/HAxZhite2NOXbb5sSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764005795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b2IZs/iJywacdojXMvk6M27OfFIstOkeVS4WvVUZksU=;
	b=4c/b4Sor5YE0OMWOxhE09AyRQJZAtjf+C7NRbXkGiEImIBGvtmrqI9n3KIFLTNyYlFmvYX
	CoxaZK82MJuNcOBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 943783EA66;
	Mon, 24 Nov 2025 17:36:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VZwpJKOXJGmzRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 17:36:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0CB0CA0A04; Mon, 24 Nov 2025 18:36:31 +0100 (CET)
Date: Mon, 24 Nov 2025 18:36:31 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 10/14] fs: factor out a sync_lazytime helper
Message-ID: <zxcwflyr4gjglqmpjnr6vgcb6iv3zu5iub4yf35i2kdhn37ox5@rudbrvydeev5>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-11-hch@lst.de>
 <vkobnnw3ij2n47bhhooawbw546dgwzii32nfqcx4bduoga5d7r@vdo5ryq4mffz>
 <20251124140924.GB14417@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124140924.GB14417@lst.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: B46B75BCC2
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.01

On Mon 24-11-25 15:09:24, Christoph Hellwig wrote:
> On Mon, Nov 24, 2025 at 02:31:02PM +0100, Jan Kara wrote:
> > > +	if (wbc->sync_mode == WB_SYNC_ALL ||
> > > +	    time_after(jiffies, inode->dirtied_time_when +
> > > +			dirtytime_expire_interval * HZ))
> > > +		sync_lazytime(inode);
> > 
> > The checking of inode->dirtied_time_when for inode potentially without
> > I_DIRTY_TIME set (and thus with unclear value of dirtied_time_when) is kind
> > of odd. It is harmless but IMO still not a good practice. Can't we keep
> > this condition as is and just call sync_lazytime()?
> 
> As in keeping the I_DIRTY_TIME in the caller?  Sure, I could do that.

Yes, keeping I_DIRTY_TIME check at this call site.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

