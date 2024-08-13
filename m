Return-Path: <io-uring+bounces-2733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B6694FAD8
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 02:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 854D0B21873
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 00:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004E94A23;
	Tue, 13 Aug 2024 00:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h5x2gRSH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2bLMXdZP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2a69kEvt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rDDgGzVW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04813D69;
	Tue, 13 Aug 2024 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723510190; cv=none; b=GMhV46uA7+lcM6fgonW0gDcUJ7FZRp5fArQmxWPHavxToqsB4f5QUYCLPUvjwaab6tDU+fZplLI6nxtmov89aXE82dCh4CetZUZvQLqo21BOTuhELhM9LM3MBLmHwdtf60CipolAV3KgTDxKU0t01mKT8/xR3m3LBk/1kLQ5eLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723510190; c=relaxed/simple;
	bh=szWjwUqHZIAcfPTehI1G6L2XpIfTQOWpVvev95c1ay8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mm0W+vKtyrofB7ARDLDJwuhDhgHKo+E1fW9ZqCJnzGhZbwyPbivNXzt1IODZfpPVN/s0pJ+1XumNF0QYwU6dd61Y7rJxmlsx/gslWdGPvg7uieNcztL38HQmfWftlJ5OaVFAr3nsSdE22E740Dtx5vtffJqZ+d0IKpmwKFQkLI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h5x2gRSH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2bLMXdZP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2a69kEvt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rDDgGzVW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D7BD1F444;
	Tue, 13 Aug 2024 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1723510186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkFD+SvOhV/khNKqznjzWOr3vknle2BXwJ31uj/bmMw=;
	b=h5x2gRSHVhszIS5fQQcohg5oa1wZKbT19SfGg093xXtMglSS71qQRASktInRWkt9UGtgfW
	/jfPA1VPK3GqJY8LgDKN75mFURJCp9Bz7czDapYurZhCUyZ+ajk+LUjysdYCSPXLSIa5A3
	rqAGaFXl7kvBoOCQjYaIuT4VcWDUg+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1723510186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkFD+SvOhV/khNKqznjzWOr3vknle2BXwJ31uj/bmMw=;
	b=2bLMXdZPLlLfW9DaawJB0JWFuXLb6lSEl5HpCLq7A0Hwx76hBZPTAoEqztNOJ29Q6+roJu
	tGC1O/rFb35T6BAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2a69kEvt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rDDgGzVW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1723510185;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkFD+SvOhV/khNKqznjzWOr3vknle2BXwJ31uj/bmMw=;
	b=2a69kEvt5IUF8VxHQsEtxc5s/GfLx7QkSlscalUdIPva3PrV5tJ3auAFVk0XoIWoYIq8kp
	VnzMHSIGEN9pr1u+krE1pjBEnaz+pZ+LXYnpEOpA5bGe9Mo3CdoJ85p1ym9SCYWXjCiphm
	oO1JxN/xvyuJF8iRSmqupUh3Pxtu5xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1723510185;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkFD+SvOhV/khNKqznjzWOr3vknle2BXwJ31uj/bmMw=;
	b=rDDgGzVWFAKWYoa35l+Xk+uPvbjF2r9QOmnK9Nm8V3aJZ/j5JHp8+NodR7kjgwl3xRNX/Z
	22Vznkab/6fS0YDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1297913983;
	Tue, 13 Aug 2024 00:49:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KzJJBKmtumYVOwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 13 Aug 2024 00:49:45 +0000
Date: Tue, 13 Aug 2024 02:49:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
Message-ID: <20240813004935.GM25962@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
 <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
 <20240812165816.GL25962@twin.jikos.cz>
 <8d8e24bf-95d2-418e-b305-42eec37341c7@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d8e24bf-95d2-418e-b305-42eec37341c7@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Rspamd-Queue-Id: 2D7BD1F444
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, Aug 12, 2024 at 08:17:43PM +0100, Pavel Begunkov wrote:
> On 8/12/24 17:58, David Sterba wrote:
> > On Mon, Aug 12, 2024 at 05:10:15PM +0100, Pavel Begunkov wrote:
> >> And the last point, I'm surprised there are two versions of
> >> btrfs_ioctl_encoded_io_args. Maybe, it's a good moment to fix it if
> >> we're creating a new interface.
> >>
> >> E.g. by adding a new structure defined right with u64 and such, use it
> >> in io_uring, and cast to it in the ioctl code when it's x64 (with
> >> a good set of BUILD_BUG_ON sprinkled) and convert structures otherwise?
> > 
> > If you mean the 32bit version of the ioctl struct
> > (btrfs_ioctl_encoded_io_args_32), I don't think we can fix it. It's been
> 
> Right, I meant btrfs_ioctl_encoded_io_args_32. And to clarify, nothing
> can be done for the ioctl(2) part, I only suggested to have a single
> structure when it comes to io_uring.
> 
> > there from the beginning and it's not a mistake. I don't remember the
> > details why and only vaguely remember that I'd asked why we need it.
> > Similar 64/32 struct is in the send ioctl but that was a mistake due to
> > a pointer being passed in the structure and that needs to be handled due
> > to different type width.
> 
> Would be interesting to learn why, maybe Omar remembers? Only two
> fields are not explicitly sized, both could've been just u64.
> The structure iov points to (struct iovec) would've had a compat
> flavour, but that doesn't require a separate
> btrfs_ioctl_encoded_io_args.

Found it:

"why don't we avoid the send 32bit workaround"
https://lore.kernel.org/linux-btrfs/20190828120650.GZ2752@twin.jikos.cz/

"because big-endian"
https://lore.kernel.org/linux-btrfs/20190903171458.GA7452@vader/

