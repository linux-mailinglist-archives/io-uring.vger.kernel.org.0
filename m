Return-Path: <io-uring+bounces-10554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8641FC56B73
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A39DC353CAD
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 09:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662B52DF6E9;
	Thu, 13 Nov 2025 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YU+3dbgA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZWphwib/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YU+3dbgA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZWphwib/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978732DECD4
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027698; cv=none; b=fAXcOnNUWwJL824AjrlL21TS7INuwDpuEVW9ys08nwD+2jL6Efn0e5Mec9eSBQCUGDZPlkrkf+C0AiwMF3OJFIjTku0ruNFCIB7D+dlMtc3aj09Ma7cpv71PIlnu/NHZr/86o27lSeK5YKEbCuCNQGo4IINYWG8TAn77vejN1eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027698; c=relaxed/simple;
	bh=J8zu5BD3Gqfvtlmg4kbY1p0szFWxei/uZmx4TBtI04Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FD0dyrtjoVJkXLeHY1tH7+ySAwQzj69sRPqEx4kAKuq3Q4IOSMB/O2O+nh7xS/Dy4XPYGIU9nr+awJW3b96ysoy/cI44jcaWa4wI9W+JUCDwbmIBcI90z2iiKzIDLF8oERkjySVvQ9PeKjM0r76GRCCFql8uJYqvYyhnpDqaTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YU+3dbgA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZWphwib/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YU+3dbgA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZWphwib/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C02D1F388;
	Thu, 13 Nov 2025 09:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763027694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+olTBDitpveQnWUK4qbX+9IyT+Tp+LGZmQMS/exxC8=;
	b=YU+3dbgA8m/nQ5byb2tUC1phZ5jHVweAt6qSltJSR72/4Fw+UQSWLSx1q3Z3/B+CSSeDHw
	AL14uIVSMI6UfwdRtPwEus8NboIsGrTSAei00J64y0wu+M0B2J74ZH+AaDAEO12p3+B73y
	cBaQMRvbpM0tAs9jAnZbYunBHXorPDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763027694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+olTBDitpveQnWUK4qbX+9IyT+Tp+LGZmQMS/exxC8=;
	b=ZWphwib/KfDW4aoG6Q0twby/My+2F7NxTm6oYJXsiltrgQoWoN5pR3loiXs+6rZLfEGFh7
	LEVwmpHuCPlzPJCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YU+3dbgA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZWphwib/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763027694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+olTBDitpveQnWUK4qbX+9IyT+Tp+LGZmQMS/exxC8=;
	b=YU+3dbgA8m/nQ5byb2tUC1phZ5jHVweAt6qSltJSR72/4Fw+UQSWLSx1q3Z3/B+CSSeDHw
	AL14uIVSMI6UfwdRtPwEus8NboIsGrTSAei00J64y0wu+M0B2J74ZH+AaDAEO12p3+B73y
	cBaQMRvbpM0tAs9jAnZbYunBHXorPDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763027694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+olTBDitpveQnWUK4qbX+9IyT+Tp+LGZmQMS/exxC8=;
	b=ZWphwib/KfDW4aoG6Q0twby/My+2F7NxTm6oYJXsiltrgQoWoN5pR3loiXs+6rZLfEGFh7
	LEVwmpHuCPlzPJCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DDD93EA61;
	Thu, 13 Nov 2025 09:54:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zN+3Hu6qFWnHDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 09:54:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11BCBA0976; Thu, 13 Nov 2025 10:54:46 +0100 (CET)
Date: Thu, 13 Nov 2025 10:54:46 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 4/5] iomap: support write completions from interrupt
 context
Message-ID: <x76swsaqkkyko6oyjch2imsbqh3q3dx3uqqofjnktzbzfdkbhe@jog777bckvu6>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-5-hch@lst.de>
 <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3>
 <20251113065055.GA29641@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113065055.GA29641@lst.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 8C02D1F388
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim]
X-Spam-Score: -4.01

On Thu 13-11-25 07:50:55, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 09:25:58PM +0100, Jan Kara wrote:
> > > +
> > > +		/*
> > > +		 * We can only do inline completion for pure overwrites that
> > > +		 * don't require additional I/O at completion time.
> > > +		 *
> > > +		 * This rules out writes that need zeroing or extent conversion,
> > > +		 * or extend the file size.
> > > +		 */
> > > +		if (!iomap_dio_is_overwrite(iomap))
> > > +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> > >  	} else {
> > >  		bio_opf |= REQ_OP_READ;
> > >  	}
> > 
> > OK, now I see why you wrote iomap_dio_is_overwrite() the way you did. You
> > still want to keep completions inline for overwrites of possibly
> > uncommitted extents.
> 
> Yes.
> 
> > But I have to admit it all seems somewhat fragile and
> > difficult to follow. Can't we just check for IOMAP_DIO_UNWRITTEN |
> > IOMAP_DIO_COW | IOMAP_DIO_NEED_SYNC in flags (plus the i_size check) and be
> > done with it?
> 
> You mean drop the common helper?  How would that be better and less
> fragile?   Note that I care strongly, but I don't really see the point.

Sorry I was a bit terse. What I meant is that the two users of
iomap_dio_is_overwrite() actually care about different things and that
results in that function having a bit odd semantics IMHO. The first user
wants to figure out whether calling generic_write_sync() is needed upon io
completion to make data persistent (crash safe). The second user cares
whether we need to do metadata modifications upon io completion to make data
visible at all.

So it would be IMO more understandable if we had one helper like
iomap_dio_extent_stable() for the first case (which would be the same as
current iomap_dio_is_overwrite() + IOMAP_F_DIRTY) and for the second case
we already gather that information from extents in DIO flags and
filesystems do the non-trivial work in their end_io handlers based on these
flags so just checking IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW |
IOMAP_DIO_NEED_SYNC in iomap_dio_complete() should be a reliable trigger
for offloading to a workqueue (plus the check for dio->error). That way the
handling of IOMAP_DIO_INLINE_COMP happens only before we start IO (i_size
check) and in iomap_dio_complete() which seems easier to follow to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

