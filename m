Return-Path: <io-uring+bounces-10555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2F5C56BC7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97B493AC961
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 09:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3AE2DFA2F;
	Thu, 13 Nov 2025 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WRM9yFWG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7lMNEnRC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nrl5Na2k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="STtK2/00"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875D2DF12C
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027884; cv=none; b=gvqcQunYgwpzjytrSd5ctvJKmB6Dwkl9NkEX1rftswrcbfFmdEwxFzIgaL+qAPUBZH9eulBXx0B2DsINM2nshoR1B0AxRK4g/1Er7NecsopbxPrRUmnY0mZyZ49/ISaq1PLEClvXDdg+X0xfCuZRCxX7Dn0QDBVDIwBxwicqw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027884; c=relaxed/simple;
	bh=5M8K1hjVFq/VmaFX7UkDnxDDQthyg4EzktgormkCXn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlLxeeUzLl0a9Z0tV0j7Y2v+rx2VV/EBJHBSXEEb3A0pWQ7SyPH3GNmQlt3IZOqlQSwa7ObkdTeZTelHHnFUz/qpfgR/4nxmFJQlnzpxeImAGKAUbbOnGC1XdY5O9e9Gd3LpUZjrYKtK0NdrPHnBEbfKf83vzMaJ02E2wmttx5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WRM9yFWG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7lMNEnRC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nrl5Na2k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=STtK2/00; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CCD931F388;
	Thu, 13 Nov 2025 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763027881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwM2D8GHgm8xO9hBR84443bUAyBi+o17vUk7MU3i4vA=;
	b=WRM9yFWGcNFFCkdXERRKIABiU7u4i0dlnkqkTat36iOwGciTqF3jQg3bYPfDZVt1+47ORW
	XihMnvSoNTCzyXbiPNmersLkIbEffeGNvRrV+m2NcIXKTXNZJ+C3nXQCyUpm5rvndtGpS/
	/oMNczhNLJS3JdRunDsBo21RMIcuR8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763027881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwM2D8GHgm8xO9hBR84443bUAyBi+o17vUk7MU3i4vA=;
	b=7lMNEnRC5tuIs1ijXHCl1tqvjbEhIfcDCwQb8rpnUhlY4NAVkmyCtUdoZo+CV0x5UvVg2+
	Sr0m+aQ3lBbTNnBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nrl5Na2k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="STtK2/00"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763027880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwM2D8GHgm8xO9hBR84443bUAyBi+o17vUk7MU3i4vA=;
	b=Nrl5Na2kc4psC6j4Y52LXdzL4CIM1L3gecl0t7yGZR+SmZjyUOUGCS4pqdmpbJIG1weTHI
	xWYmi1Yvyx25nZHfS90spy+OCtNtxBXTW8xcjFVCbROLQqPnEbS8mbMEQ8iY2McJhIjHE+
	FvGQF55YvZ89gS4HRUZHE+rJ5t/XxmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763027880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XwM2D8GHgm8xO9hBR84443bUAyBi+o17vUk7MU3i4vA=;
	b=STtK2/00Wx9nrBmnf9m71FHmPZ3iArrFbd0FAHZxZ7bpopDmgozcILd560fL/U1HSy7+7A
	FvMl2MF/r62kTsDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCDEF3EA61;
	Thu, 13 Nov 2025 09:58:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3WTILairFWnXEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 09:58:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5C1C0A0976; Thu, 13 Nov 2025 10:58:00 +0100 (CET)
Date: Thu, 13 Nov 2025 10:58:00 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: enable iomap dio write completions from interrupt context
Message-ID: <zqi5yb34w6zsqe7yiv7nryx7xl23txy5fmr5h7ydug7rjnby3l@leukbllawuv2>
References: <20251112072214.844816-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112072214.844816-1-hch@lst.de>
X-Rspamd-Queue-Id: CCD931F388
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Wed 12-11-25 08:21:24, Christoph Hellwig wrote:
> While doing this I've also found dead code which gets removed (patch 1)
> and an incorrect assumption in zonefs that read completions are called
> in user context, which it assumes for it's error handling.  Fix this by
> always calling error completions from user context (patch 2).

Speaking of zonefs, I how is the unconditional locking of
zi->i_truncate_mutex in zonefs_file_write_dio_end_io() compatible with
inline completions?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

