Return-Path: <io-uring+bounces-4149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4FC9B5503
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D33283456
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA2A206E61;
	Tue, 29 Oct 2024 21:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HQ4+d41X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O6FQsE9W";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HQ4+d41X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O6FQsE9W"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB061DC06B;
	Tue, 29 Oct 2024 21:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237384; cv=none; b=o1fRDlkSfCUJydbszhZYk9xMRquZ0wN9BOtEy0AjoXvoJWVEeTdsdbESmSKCmYjjr5FHAGnCAcc62zGu1DpJrPGRyoDhCYm80Kd+/1512/BWk9bMq6hALLDviIeULuQzVn73YUY/ALI9neCDRt3MWWT+VmW6WJ5INtg3HPApZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237384; c=relaxed/simple;
	bh=2Xpo/xjyT4K2VRDfNXLqJKkrGij7DAJfctnHuy9Hz9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B50roj/ZaaBmK8yJagHFEv1NVo5Dn2ppcdWx/sRGY7JG++sA2AUyuEtXrXaYbMxcD92woCp9mwuxdwIOBfyjv39swU0ueht30QnoScJGVE1f5ZNypJykaJOgDUVhTW39uKcuHrK6ASgJDou74mHmXwHouWt4V8R3BvJ3JczhvXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HQ4+d41X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O6FQsE9W; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HQ4+d41X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O6FQsE9W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20FF41F791;
	Tue, 29 Oct 2024 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730237375;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PF3e5S0uEBE0AOcwdeqMOm/5q9ps1DtoiQ5K6SZhjY=;
	b=HQ4+d41XLvz4gTzs150o4mH+Z7wvvfOyVLx4YgM5QV+0TGkYHexN3seSn6fAxRGlErN3Qf
	mmIXNdWcwqcSitOo8EEwixaKKp3qQJn/KVQ2oFdmpi03ONqfFzpq6Jhy2Q8wNezu4mNDX+
	Qy/atpeSFQ3h2jsjBxGcZyeXLS3Frak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730237375;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PF3e5S0uEBE0AOcwdeqMOm/5q9ps1DtoiQ5K6SZhjY=;
	b=O6FQsE9WML+EyIm1zKcJnghi62nT5Ry/pyNWwLPY4MoOuWSb/adECRKKDPa80iSLfog46J
	wzMBFEVeIP9PDvAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HQ4+d41X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O6FQsE9W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730237375;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PF3e5S0uEBE0AOcwdeqMOm/5q9ps1DtoiQ5K6SZhjY=;
	b=HQ4+d41XLvz4gTzs150o4mH+Z7wvvfOyVLx4YgM5QV+0TGkYHexN3seSn6fAxRGlErN3Qf
	mmIXNdWcwqcSitOo8EEwixaKKp3qQJn/KVQ2oFdmpi03ONqfFzpq6Jhy2Q8wNezu4mNDX+
	Qy/atpeSFQ3h2jsjBxGcZyeXLS3Frak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730237375;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PF3e5S0uEBE0AOcwdeqMOm/5q9ps1DtoiQ5K6SZhjY=;
	b=O6FQsE9WML+EyIm1zKcJnghi62nT5Ry/pyNWwLPY4MoOuWSb/adECRKKDPa80iSLfog46J
	wzMBFEVeIP9PDvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07FCF13503;
	Tue, 29 Oct 2024 21:29:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MER4Ab9TIWcNcwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 29 Oct 2024 21:29:35 +0000
Date: Tue, 29 Oct 2024 22:29:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Message-ID: <20241029212918.GS31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241022145024.1046883-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022145024.1046883-1-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: 20FF41F791
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
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, Oct 22, 2024 at 03:50:15PM +0100, Mark Harmstone wrote:
> This is version 4 of a patch series to add an io_uring interface for
> encoded reads. The principal use case for this is to eventually allow
> btrfs send and receive to operate asynchronously, the lack of io_uring
> encoded I/O being one of the main blockers for this.
> 
> I've written a test program for this, which demonstrates the ioctl and
> io_uring interface produce identical results: https://github.com/maharmstone/io_uring-encoded

We'll need a test utility for fstests too.

> Changelog:
> v4:
> * Rewritten to avoid taking function pointer
> * Removed nowait parameter, as this could be derived from iocb flags
> * Fixed structure not getting properly initialized
> * Followed ioctl by capping uncompressed reads at EOF
> * Rebased against btrfs/for-next
> * Formatting fixes
> * Rearranged structs to minimize holes
> * Published test program
> * Fixed potential data race with userspace
> * Changed to use io_uring_cmd_to_pdu helper function
> * Added comments for potentially confusing parts of the code

There are some more style issues and changelog updates but overall looks
ok to me. We're now in rc5 so we need to add it to for-next now or
postpone for next cycle (but I don't see a reason why).

I've noticed CONFIG_IO_URING is a config option, do we need some ifdef
protection or are the definitions provided unconditionally. We may also
need to ifdef out the ioctl code if io_uring is not built in.

