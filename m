Return-Path: <io-uring+bounces-8559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67BACAEFD94
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 17:06:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE55D4E7AEB
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AF2DF49;
	Tue,  1 Jul 2025 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T1bcbpPg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yNpNY4nh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qeuZhVoQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="elSxLAnn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C122749FA
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751382071; cv=none; b=k2A410FGsQJtC+2V8+L4WEwu5CA7U1xS6vhPhBpN3BSRCqgymWTQFDcENQCypokxWeDRlU6H9TUFipxnlv2Suo7QmixIRkp2j7A58+bnMXiRVP0C9uGjHHLhy3BR0wI0rjFMblE9tSUzyHr8XjdeGtz37iKt1hNz3mDtMw2Lhv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751382071; c=relaxed/simple;
	bh=XanmgT4emsW2NMQRZpvM+8C/v1OSXlMO1Cx19rYH6Ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tc+qlIV0BttHMArL0TVIIrS7FEeuwXZLP5quuaYvUaPyRRmKY6+rrsQq4ieV59M+J+VxN4QxWekCe7yMsFw9K7k2/Hn5CJQ/l30J/UULcwL0mcCYkmWqOyqpwS89p/qj50XXvyunFH7uULRv/9ZKRMj3cBvFP4x1BtxohXjS6n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T1bcbpPg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yNpNY4nh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qeuZhVoQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=elSxLAnn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B78CB1F393;
	Tue,  1 Jul 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751382068;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrlBdP+Tjw8if4zoCMtG99E5Zyd2qYrN4g60rXZUKKA=;
	b=T1bcbpPgK1KnNsa8RMNe7aHibKuZIkzbHDPW7PJVbY5000ijHstdwd0zu5rcB4SsRDhJ3o
	iRnuRUZMGI6Y4/SLVCL3TEcejc2TrNNb46Y0GDroxkqCAWmtdPKWtyZzG5gfs9IN/VmoEa
	iKZ0gWCNCzgZXHLS6JBOXgE1pX1J47c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751382068;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrlBdP+Tjw8if4zoCMtG99E5Zyd2qYrN4g60rXZUKKA=;
	b=yNpNY4nh+6AscpZS9gXkPwkOzjEVJ9kKpV35mXfd+3qSH5zaD85VcZYnUQDaIFPD4QLdUF
	zO4Lpz2S0ypAyNBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qeuZhVoQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=elSxLAnn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751382066;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrlBdP+Tjw8if4zoCMtG99E5Zyd2qYrN4g60rXZUKKA=;
	b=qeuZhVoQu8lhHRnSxmWPwmVHP6xSwCYovqY4vZRV8/0rE7WJLl3Z2womW+ETdreWZeas8L
	RwUzA6xY3ZdR1rctP49iKVhNGPt7W3NcwAT8doJlDa5p6tfozJHsQiL8P6JQERwMqXkeAD
	gImyLc/H5uKDedRELd/8/Czy2WjkIQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751382066;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrlBdP+Tjw8if4zoCMtG99E5Zyd2qYrN4g60rXZUKKA=;
	b=elSxLAnnse1u9S0s2fgM5czRSZrh3C623hFwU+5C+gtMbNnyct4KXWuXWGYCF9yMyCStk4
	1SYtXo2cZLGfnsDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51F4113890;
	Tue,  1 Jul 2025 15:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VvuiEjL4Y2glGwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 01 Jul 2025 15:01:06 +0000
Date: Tue, 1 Jul 2025 17:01:05 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>, Mark Harmstone <maharmstone@fb.com>,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
Message-ID: <20250701150104.GT31241@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250620154743.GY4037@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620154743.GY4037@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [0.79 / 50.00];
	REPLYTO_EQ_TO_ADDR(5.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:replyto]
X-Spamd-Bar: /
X-Rspamd-Queue-Id: B78CB1F393
X-Spam-Score: 0.79
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, Jun 20, 2025 at 05:47:43PM +0200, David Sterba wrote:
> On Thu, Jun 19, 2025 at 01:27:44PM -0600, Caleb Sander Mateos wrote:
> > btrfs's ->uring_cmd() implementations are the only ones using io_uring_cmd_data
> > to store data that lasts for the lifetime of the uring_cmd. But all uring_cmds
> > have to pay the memory and CPU cost of initializing this field and freeing the
> > pointer if necessary when the uring_cmd ends. There is already a pdu field in
> > struct io_uring_cmd that ->uring_cmd() implementations can use for storage. The
> > only benefit of op_data seems to be that io_uring initializes it, so
> > ->uring_cmd() can read it to tell if there was a previous call to ->uring_cmd().
> > 
> > Introduce a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementations can
> > use to tell if this is the first call to ->uring_cmd() or a reissue of the
> > uring_cmd. Switch btrfs to use the pdu storage for its btrfs_uring_encoded_data.
> > If IORING_URING_CMD_REISSUE is unset, allocate a new btrfs_uring_encoded_data.
> > If it's set, use the existing one in op_data. Free the btrfs_uring_encoded_data
> > in the btrfs layer instead of relying on io_uring to free op_data. Finally,
> > remove io_uring_cmd_data since it's now unused.
> > 
> > Caleb Sander Mateos (4):
> >   btrfs/ioctl: don't skip accounting in early ENOTTY return
> >   io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
> >   btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
> >   io_uring/cmd: remove struct io_uring_cmd_data
> 
> The first patch is a fix so it can be put to a -rc queue.

I've picked the first patch to for-next.

> The rest change the io_uring logic, so it's not up to me, but regarding
> how to merge them either via btrfs or io_uring tree work for me.

This is still pending. I can take it but need an ack.

