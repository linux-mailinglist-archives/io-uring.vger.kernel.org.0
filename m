Return-Path: <io-uring+bounces-2709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B16F94F575
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F28FD1F21A81
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7FA187842;
	Mon, 12 Aug 2024 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EVr/7ebH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AHJCGf7l";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EVr/7ebH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AHJCGf7l"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82018754F;
	Mon, 12 Aug 2024 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723481901; cv=none; b=KWqmFHxtlm0ErL7sjicath+xD5x19zaurxTCDbXjTgVwcxK7wJ0lspKKFtGuWXJA82YTve3r2CKMxlBOH8pZii+jEWwS5G4EAuRW7+uR4trUXQWwQV77jW6KxkBu8zIZ7FDnbca4zsA+bMS3Z7KGDDQ+oMy/TkRTFG4ACYxpBkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723481901; c=relaxed/simple;
	bh=443q6LOjOjuF400eu9Qmc3JZsLFoZTc4Fv5YKRpGy/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jL74A+QGRrm8bac17HpXQwO2W0UMFP1q4LVkWkXJtafVmA/4ML4YV5OotUd5Y2nrox5Lt85SJiUgWsDNKJfAEhYxASedZRx3VOQ/Iu1jn8mQh3eI75NPVpSd4AVojZK3wOQ67drx81YEIGaBaYJ7J5bkCAkpbXytRlCDoA4oD50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EVr/7ebH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AHJCGf7l; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EVr/7ebH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AHJCGf7l; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE23B1FB91;
	Mon, 12 Aug 2024 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1723481897;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Um+voa6pXaS8Mx4m8dcda8iX6et8VBzOxl8Rc8AytZQ=;
	b=EVr/7ebH8FDvbGHS+5REICn4QBXLFf+fzKsqwHsnQtxSNEAQi7Fpf9we0XZy9P60JFHTS6
	98nvXUamu7fRtqGXVFIB3d6QP2yZNZ1NKw7ITvJy0XygM9UrZ69ampfLWbyPwQ+4VUzuVs
	0fszbS9b/ucKCy2Pomfj4XbR/Pv4blI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1723481897;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Um+voa6pXaS8Mx4m8dcda8iX6et8VBzOxl8Rc8AytZQ=;
	b=AHJCGf7lv4LIKBYIlt/VcK6zgKW6MgEvIt7Dq2ISnUpMMgNyd6u1lO6a88K33h8pmgQCja
	a5RwUzyhGbxMTVBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="EVr/7ebH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AHJCGf7l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1723481897;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Um+voa6pXaS8Mx4m8dcda8iX6et8VBzOxl8Rc8AytZQ=;
	b=EVr/7ebH8FDvbGHS+5REICn4QBXLFf+fzKsqwHsnQtxSNEAQi7Fpf9we0XZy9P60JFHTS6
	98nvXUamu7fRtqGXVFIB3d6QP2yZNZ1NKw7ITvJy0XygM9UrZ69ampfLWbyPwQ+4VUzuVs
	0fszbS9b/ucKCy2Pomfj4XbR/Pv4blI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1723481897;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Um+voa6pXaS8Mx4m8dcda8iX6et8VBzOxl8Rc8AytZQ=;
	b=AHJCGf7lv4LIKBYIlt/VcK6zgKW6MgEvIt7Dq2ISnUpMMgNyd6u1lO6a88K33h8pmgQCja
	a5RwUzyhGbxMTVBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A947313AD8;
	Mon, 12 Aug 2024 16:58:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hn0VKSk/umbMQQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 12 Aug 2024 16:58:17 +0000
Date: Mon, 12 Aug 2024 18:58:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
Message-ID: <20240812165816.GL25962@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
 <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Rspamd-Queue-Id: BE23B1FB91
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, Aug 12, 2024 at 05:10:15PM +0100, Pavel Begunkov wrote:
> And the last point, I'm surprised there are two versions of
> btrfs_ioctl_encoded_io_args. Maybe, it's a good moment to fix it if
> we're creating a new interface.
> 
> E.g. by adding a new structure defined right with u64 and such, use it
> in io_uring, and cast to it in the ioctl code when it's x64 (with
> a good set of BUILD_BUG_ON sprinkled) and convert structures otherwise?

If you mean the 32bit version of the ioctl struct
(btrfs_ioctl_encoded_io_args_32), I don't think we can fix it. It's been
there from the beginning and it's not a mistake. I don't remember the
details why and only vaguely remember that I'd asked why we need it.
Similar 64/32 struct is in the send ioctl but that was a mistake due to
a pointer being passed in the structure and that needs to be handled due
to different type width.

