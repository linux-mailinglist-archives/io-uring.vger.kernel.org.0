Return-Path: <io-uring+bounces-11588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 205EAD13413
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60683300E148
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 14:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B237B1AF0BB;
	Mon, 12 Jan 2026 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WC9vtFFW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/hXNV+jS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WC9vtFFW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/hXNV+jS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695FC215055
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768228588; cv=none; b=W1waC4d3QP/+a206UYlfdfjnW7bfXLKMRnl2lpj/CE7A9mlc+4hlkRw5oP5r6X+t1KfSayEHYxZ39oDlf9sZMR+lJMmCmN1mjOb9rV6BYfh0gV5T8DUCMGFBi3TBI/EyCrouR31SqZgu9ZmWghbwZnMexasGtO+frUliisfpJ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768228588; c=relaxed/simple;
	bh=Fud1HhGFuTSdRNSNC1gSuB/6JOFDLeWpnrZgB7/m51k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jzVv3qjrBonePjvsKJMgYsg03fiyxxh7igJ2jeIhHXldIYJB5eBUErIjl9TN3dWqy3f98aZL4daRRHvP1ZyDVsKvIJvgrjtZ4pfHbVqiCvItlzhkDwQGwDFBrYFWfJ4xq5nd82RuJ/qXE8vJIHppn14PUt64mw9z6IDRjq5EaZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WC9vtFFW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/hXNV+jS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WC9vtFFW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/hXNV+jS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A917233682;
	Mon, 12 Jan 2026 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768228585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+Uw3NpYEH2+Sloru2OmJvlB/FnFTlvGQDRfi6nj0Jk=;
	b=WC9vtFFWAqCRia7vwj3lvbK86nVitE/1w9U6HQHeeK9sBecD5H0hna1W9bUys7BPKHw088
	zvkkDODqdv/PJUegXTlaYEovOsKqvAuPODXurkrHJ2S4taD5FSKzJwA17MQXQSds88xYjC
	ehsjEWj6Hy841S9aWJzsGgtlhruXItU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768228585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+Uw3NpYEH2+Sloru2OmJvlB/FnFTlvGQDRfi6nj0Jk=;
	b=/hXNV+jScEiMhJw+9aLiyjkXVJLyCQpFBAaJLyD/KpDOLfjXwoKpvQrGZzfRZlnC0yWijm
	EXN4TvzDLvVfRqCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WC9vtFFW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/hXNV+jS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768228585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+Uw3NpYEH2+Sloru2OmJvlB/FnFTlvGQDRfi6nj0Jk=;
	b=WC9vtFFWAqCRia7vwj3lvbK86nVitE/1w9U6HQHeeK9sBecD5H0hna1W9bUys7BPKHw088
	zvkkDODqdv/PJUegXTlaYEovOsKqvAuPODXurkrHJ2S4taD5FSKzJwA17MQXQSds88xYjC
	ehsjEWj6Hy841S9aWJzsGgtlhruXItU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768228585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z+Uw3NpYEH2+Sloru2OmJvlB/FnFTlvGQDRfi6nj0Jk=;
	b=/hXNV+jScEiMhJw+9aLiyjkXVJLyCQpFBAaJLyD/KpDOLfjXwoKpvQrGZzfRZlnC0yWijm
	EXN4TvzDLvVfRqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5935A3EA63;
	Mon, 12 Jan 2026 14:36:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Em8CC+kGZWklbQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 12 Jan 2026 14:36:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Breno Leitao <leitao@debian.org>
Cc: axboe@kernel.dk,  io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Trim out unused includes
In-Reply-To: <wuha2oln3kdumecdsmpttykdq2p5bwp6db3cfoyqoy5ftnedmg@ftlotbrnrev7>
	(Breno Leitao's message of "Mon, 12 Jan 2026 04:11:06 -0800")
Organization: SUSE
References: <20260105230932.3805619-1-krisman@suse.de>
	<wuha2oln3kdumecdsmpttykdq2p5bwp6db3cfoyqoy5ftnedmg@ftlotbrnrev7>
Date: Mon, 12 Jan 2026 09:36:23 -0500
Message-ID: <87ldi25254.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.50
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-2.99)[99.97%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A917233682
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Breno Leitao <leitao@debian.org> writes:

> Do you have a tool to detect those unused header? I am curious how is
> the process to discover unused headers in .c files.

No.  I noticed one that was obviously wrong and that caused me to
manually walk over the rest that looked suspicious.  I probably missed
some in the process.

I suppose LLMs, if you can stomach those, would help :)

-- 
Gabriel Krisman Bertazi

