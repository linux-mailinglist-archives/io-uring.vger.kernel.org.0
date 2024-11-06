Return-Path: <io-uring+bounces-4513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE729BF802
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 21:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46BCF1F22A42
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 20:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4271020C323;
	Wed,  6 Nov 2024 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2ngkrFBh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ln2yz0Ju";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M8D0XDvN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NkP59Kt7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1030520C320;
	Wed,  6 Nov 2024 20:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925180; cv=none; b=Zq7/YrYXG66tiu/nCvxRKjjAt4oFv4SD00sG7QJsMByU5EoQVx0Vx7HXxm7fbz0q6htAQbpcJxstiqFebwEsnu0Jkb3ZjQ6FnFWifRBNFJ8yMfPWWD95XtMT/ZldXhI3kUt93xfPFss+tN7oop6XZY3n75+mrYvw/E1gZF1T4NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925180; c=relaxed/simple;
	bh=8vuweRgVndOU+mcxvupTy/nXtrA26+rV7JyN0p10YX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NokGuVToRlBB+NF5zS5vmkDppSruP1hKo5Mn1kWQ3E0uZmT2hYtv9/esI+0y4B7l30yuFKL9VGAG5zkySsplxI9l2fm9pp5B4h1BynDfpm8gqY71cBvvEilmyL/9YbeX4CjWKUQxpi/KgBNXnVnQJFa9pR0sfzgb+QdgIp396To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2ngkrFBh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ln2yz0Ju; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M8D0XDvN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NkP59Kt7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E9D711FB72;
	Wed,  6 Nov 2024 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730925176;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYERkXE92GursQlosxrLZrZg3u44WgdVnVB6DcTAsGA=;
	b=2ngkrFBhkbFwW1bWCeWr8ddx5xT2PFSHexbM4jwXn66QWi6m8HDpapDi/n4Yq0vbP1/Ip7
	kYs/wHoIOrM5G1UwlnQS5M0FVvZs/Vp0c3eHEm1XibQA9D+aDNrXxgNSrLVnhRPkhanm4S
	3Q8Pbc2W8HxilWHLOsfptraXqOO6oSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730925176;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYERkXE92GursQlosxrLZrZg3u44WgdVnVB6DcTAsGA=;
	b=ln2yz0JurGY4P5DxldzL9S2F6K0JE9PbQ6vbX31Z5t6ae5psL9FRpzMaUEYfHoEuq5uwAy
	dd4ZdHKeX0dT4uDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M8D0XDvN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NkP59Kt7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730925175;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYERkXE92GursQlosxrLZrZg3u44WgdVnVB6DcTAsGA=;
	b=M8D0XDvNq6zLYU7vU00T8qubWpWC7CORMRwm30EjRKfYJMdvg5smLoB5JQKsFptb1XAL4H
	i9BafqzQ65Tsy+4mnQx6lJTxA3UgkcGH41YI+BQi0DJw55Nzl50J3nSe3JpnGfvKEarKw2
	aZneoFut4nJYxKTBCYIPz5STMV/xBiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730925175;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYERkXE92GursQlosxrLZrZg3u44WgdVnVB6DcTAsGA=;
	b=NkP59Kt7tTd6woObYX7unx7ipYM9ih/TGT5jrsQv+QyXdzK205AQY23uCZYVxXxEVPuYrU
	C0IkSiWjBITtMZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC417137C4;
	Wed,  6 Nov 2024 20:32:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +0FYMXfSK2fkJwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 06 Nov 2024 20:32:55 +0000
Date: Wed, 6 Nov 2024 21:32:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] btrfs: add struct io_btrfs_cmd as type for
 io_uring_cmd_to_pdu()
Message-ID: <20241106203254.GJ31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241031160400.3412499-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031160400.3412499-1-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: E9D711FB72
X-Spam-Score: -4.21
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, Oct 31, 2024 at 04:03:56PM +0000, Mark Harmstone wrote:
> Add struct io_btrfs_cmd as a wrapper type for io_uring_cmd_to_pdu(),
> rather than using a raw pointer.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>

Added to for-next to the other io_uring patches, thanks.

