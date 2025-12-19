Return-Path: <io-uring+bounces-11230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 772D6CD076F
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 16:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58D5B30B0D83
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 15:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2508F33ADBC;
	Fri, 19 Dec 2025 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KI19ArTA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hh7RDHL5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b5aN+xiY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UlK0GM+L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D122833B6D5
	for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766157127; cv=none; b=RicY86PVz/xpMgg9K2/Dfw+fnX6/ugoQC2lVAYiRwcIJEX9loK7zsAoezNfIWmXLRooFhx2FXKgBL7xNLmiqWs6KS5AbbPbjG59uaL+T/n71gFcBmGy4u0CJGqF2/9fbTJ/L2Pzt+JTGM+WSxjRbnKrSiysv+VMybiecL3Iqsm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766157127; c=relaxed/simple;
	bh=khSk3JMEwC370gokxLVt2+V81u3kcMruZJtN2TvaSFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/y/BWvmIDVM6YIGkmYR15V5RW3Rz7WfRltOqgKSdNXnCYst4O8oJcOa/pB+oBz3jBJ+670dc2/WT5X9W5UBx6iZqhs0NG0nozfYQLVDqaT14PFPY9xlX4Ot33lL7r2YtxJ28fCZZbPFAmKvd+xTRovqthhz6P+HInk0DslTwNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KI19ArTA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hh7RDHL5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b5aN+xiY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UlK0GM+L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6B6233714;
	Fri, 19 Dec 2025 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766157122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nm9StvwwiQFX7seFXlICx2z9FzoyRX/N9SPzI43K0Zg=;
	b=KI19ArTADje7Ef3OPJV1hLzka/GGmcgxpQRR6RSJ7DHa8xN87n5DpWcUrEuP6zcbKNBkjh
	jdAHIcOy+pP1KDVylL7DduL0D9Z0djbZqkz/dqZTELixx8ReuUvdb+2z6i1Q55oDKPgAyN
	F2xzcn95MmmXstBZd5eceTZYnIWCjuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766157122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nm9StvwwiQFX7seFXlICx2z9FzoyRX/N9SPzI43K0Zg=;
	b=hh7RDHL5gn+xmIJE6BzwmatN//9gS67udthbyazRkh3JxbChFHIcaQzU79Hl2FV08I6i1R
	t44ziy3+n6cOEYBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b5aN+xiY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UlK0GM+L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766157121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nm9StvwwiQFX7seFXlICx2z9FzoyRX/N9SPzI43K0Zg=;
	b=b5aN+xiYhnhbNofq9pLwTKt0OjqkrkmlduPcJsiSUaIIrXwCK2Q9qj5x9rllOIHmzan7Gj
	lSZylngfV0Tizm6Cb6iQYT6I2X7cikiVJYghY1diH86XV0Tte9zOjItXeuIbMcOMIJ3Y8h
	+5KI8rTQVHeZlHCTIGuLbkdxU5sGFZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766157121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nm9StvwwiQFX7seFXlICx2z9FzoyRX/N9SPzI43K0Zg=;
	b=UlK0GM+LwMJgyv+MpnfOq7YkH6maQd48o4ODk32s9ZBPNqUpUWpQQ+PhTj8LW2gM7rc5Zn
	gNkmYnSNDyk1a8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9CC53EA63;
	Fri, 19 Dec 2025 15:12:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EXtULUFrRWmvQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 15:12:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 764A1A090B; Fri, 19 Dec 2025 16:12:01 +0100 (CET)
Date: Fri, 19 Dec 2025 16:12:01 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, io-uring@vger.kernel.org, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 08/10] fs: add support for non-blocking timestamp updates
Message-ID: <wynhubqgvknr3fl4umfst62xyacck3avmg6qnbp2na6w7ee3qf@odetcif4kozl>
References: <20251217061015.923954-1-hch@lst.de>
 <20251217061015.923954-9-hch@lst.de>
 <2hnq54zc4x2fpxkpuprnrutrwfp3yi5ojntu3e3xfcpeh6ztei@2fwwsemx4y5z>
 <20251218061900.GB2775@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218061900.GB2775@lst.de>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: C6B6233714
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Thu 18-12-25 07:19:00, Christoph Hellwig wrote:
> On Wed, Dec 17, 2025 at 01:42:20PM +0100, Jan Kara wrote:
> > > @@ -2110,12 +2110,26 @@ int inode_update_timestamps(struct inode *inode, int *flags)
> > >  		now = inode_set_ctime_current(inode);
> > >  		if (!timespec64_equal(&now, &ctime))
> > >  			updated |= S_CTIME;
> > > -		if (!timespec64_equal(&now, &mtime)) {
> > > -			inode_set_mtime_to_ts(inode, now);
> > > +		if (!timespec64_equal(&now, &mtime))
> > >  			updated |= S_MTIME;
> > > +
> > > +		if (IS_I_VERSION(inode)) {
> > > +			if (*flags & S_NOWAIT) {
> > > +				/*
> > > +				 * Error out if we'd need timestamp updates, as
> > > +				 * the generally requires blocking to dirty the
> > > +				 * inode in one form or another.
> > > +				 */
> > > +				if (updated && inode_iversion_need_inc(inode))
> > > +					goto bail;
> > 
> > I'm confused here. What the code does is that if S_NOWAIT is set and
> > i_version needs increment we bail. However the comment as well as the
> > changelog speaks about timestamps needing update and not about i_version.
> > And intuitively I agree that if any timestamp is updated, inode needs
> > dirtying and thus we should bail regardless of whether i_version is updated
> > as well or not. What am I missing?
> 
> With lazytime timestamp updates that don't require i_version updates
> are performed in-memory only, and we'll only reach this with S_NOWAIT
> set for those (later in the series, it can't be reached at all as
> of this patch).

Ah, I see now. Thanks for explanation. This interplay between filesystem's
.update_time() helper and inode_update_timestamps() is rather subtle.
Cannot we move the SB_LAZYTIME checking from .update_time() to
inode_update_timestamps() to have it all in one function? The hunk you're
adding to xfs_vn_update_time() later in the series looks like what the
other filesystems using it will want as well?

BTW, I've noticed that ovl_update_time() and fat_update_time() should be
safe wrt NOWAIT IO so perhaps you don't have to disable it in your patch
(or maybe reenable explicitly?).

And I don't really now what orangefs_update_time() is trying to do with its
__orangefs_setattr() call which just copies the zeroed-out timestamps from
iattr into the inode? Mike?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

