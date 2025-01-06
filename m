Return-Path: <io-uring+bounces-5680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B598BA024A1
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 12:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389F33A298B
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 11:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBCD1D9337;
	Mon,  6 Jan 2025 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fDmAra6H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fGiqkg2V";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fDmAra6H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fGiqkg2V"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6247E1D8A0D;
	Mon,  6 Jan 2025 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736164719; cv=none; b=U3cf7I8fK3FCXNa8++VGLGTVbE6VD+xhsCemoGychcqambEerdxtiEaZU7Ay7ECfYMCtL7/bA4aAa0E61YVkd74/gxWoyXkONQxH8lBLA5v14Uso0AReg3vaOJJOl+d9OrL56LGVebzeZIbr2v0zNP6268Pg5DafZwETZDc8myk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736164719; c=relaxed/simple;
	bh=Z+E+/TvJ33AgvUPnE7qOOyLHsWR/g57BK0/UOmYx5h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lG6wKGy/6Iu+z4lcLEu09Nq8HgllZRLWTQzXAzM0bAjNOrZZ4rtAm6rIJGReY2Uvq8nFpN+Bg/eDYXTIfHlJonrEVbwaYpHnJlJfJXELIJRbxbVkNa6g+QBbyXIE5wPp9Wd2QTGRIW4xMPfDGU7hViPXW9BTCCebYc1E9gudhQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fDmAra6H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fGiqkg2V; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fDmAra6H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fGiqkg2V; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48AEE21157;
	Mon,  6 Jan 2025 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736164715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jzv7P5WeSwZQGmhqeuipjbWfOoot9/2iS9vqyIB1psg=;
	b=fDmAra6HX2q+8+fIf8QCohlSP7mKVfHw9q2OECFyuJn5hyfbUfPG4fM1TUKxS/tFdALdlP
	BQp6OiSBE3HWRWxJaEu9KPK+TRuXaM5v0c0H0HPIc2MqUHN1UhLMtETiuuP45thgN5cc/5
	w2qoyFU9gJNpUqcTUuSC7YbYXcr/T2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736164715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jzv7P5WeSwZQGmhqeuipjbWfOoot9/2iS9vqyIB1psg=;
	b=fGiqkg2VWZOU9QnAdj2Ov8ii66g+IxkmDzQ/ZZ4w5gYB/mPYNCm+SXqvSrrcsB+Wh7Gb36
	BfDp0WcG6bO1zTAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fDmAra6H;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fGiqkg2V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1736164715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jzv7P5WeSwZQGmhqeuipjbWfOoot9/2iS9vqyIB1psg=;
	b=fDmAra6HX2q+8+fIf8QCohlSP7mKVfHw9q2OECFyuJn5hyfbUfPG4fM1TUKxS/tFdALdlP
	BQp6OiSBE3HWRWxJaEu9KPK+TRuXaM5v0c0H0HPIc2MqUHN1UhLMtETiuuP45thgN5cc/5
	w2qoyFU9gJNpUqcTUuSC7YbYXcr/T2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1736164715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jzv7P5WeSwZQGmhqeuipjbWfOoot9/2iS9vqyIB1psg=;
	b=fGiqkg2VWZOU9QnAdj2Ov8ii66g+IxkmDzQ/ZZ4w5gYB/mPYNCm+SXqvSrrcsB+Wh7Gb36
	BfDp0WcG6bO1zTAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2935E137DA;
	Mon,  6 Jan 2025 11:58:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1dF2CWvFe2ffFQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 06 Jan 2025 11:58:35 +0000
Date: Mon, 6 Jan 2025 12:58:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/4] btrfs: fix reading from userspace in
 btrfs_uring_encoded_read()
Message-ID: <20250106115829.GU31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20250103150233.2340306-1-maharmstone@fb.com>
 <679a18ab-13ab-4a77-9274-7de4fd0d175e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <679a18ab-13ab-4a77-9274-7de4fd0d175e@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: 48AEE21157
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO

On Fri, Jan 03, 2025 at 10:55:42AM -0700, Jens Axboe wrote:
> On 1/3/25 8:02 AM, Mark Harmstone wrote:
> > Version 4 of mine and Jens' patches, to make sure that when our io_uring
> > function gets called a second time, it doesn't accidentally read
> > something from userspace that's gone out of scope or otherwise gotten
> > corrupted.
> > 
> > I sent a version 3 on December 17, but it looks like that got forgotten
> > about over Christmas (unsurprisingly). Version 4 fixes a problem that I
> > noticed, namely that we weren't taking a copy of the iovs, which also
> > necessitated creating a struct to store these things in. This does
> > simplify things by removing the need for the kmemdup, however.
> > 
> > I also have a patch for io_uring encoded writes ready to go, but it's
> > waiting on some of the stuff introduced here.
> 
> Looks fine to me, and we really should get this into 6.13. The encoded
> reads are somewhat broken without it, violating the usual expectations
> on how persistent passed in data should be.

Ok, I'll add the to the queue for the next RC.

