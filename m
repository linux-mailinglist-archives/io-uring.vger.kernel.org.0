Return-Path: <io-uring+bounces-4510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5359BF5FD
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 20:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2847B282797
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 19:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980F0201106;
	Wed,  6 Nov 2024 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H3fKbZX1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nmMnvqs9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H3fKbZX1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nmMnvqs9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3791D5ADE;
	Wed,  6 Nov 2024 19:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730919858; cv=none; b=DOPjI96jLFOjidwSGAK6CN8TtarSVICuhGqPURvlUbDlauETGNlw68H6icjcy9uiCK2Im7fN053wgNr+TewH6IJdYdA28PWv1jjjno5G3G6uIOWzcO5f4+izRFx9JZEMKRX2DVUgqNfRtsNtmnkpCCGy9c98WoN99tULQL67A20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730919858; c=relaxed/simple;
	bh=haPbraGTs+adRmUFyDiXNgLDb383Z9874N35kxT+GoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEtlS54+PHm91YJuNaI3QvyzVms8MGkImk1HClE6dyTvvUwra72QTgIXgfAnBPgz1SMAylSGKeXT1bwx2d0ld8UJKF/L5RXelD9Ebbm9vYHYm1SE2287EMN+dZionrAC0mhqjsdPyflYa7wB0ueJBbYCv/hls/xEEV7Xu54hSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H3fKbZX1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nmMnvqs9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H3fKbZX1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nmMnvqs9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3380F1FB6A;
	Wed,  6 Nov 2024 19:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730919854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yhd7diviVJAQ5yP+UbM5p1XwCMEubdSyRCKtvCS18g=;
	b=H3fKbZX1l8KU9rxypHqJygEW5itAJp/FV+ExgbnEniNxJfakF91ZMH2PpIs3HA8xH1hW4p
	74A3cdHJYsMIpi9y47MMMNLLS9G9uDxAf1Gf5aUL3RTCQcR1dMh4aAT2AUir0KgiblnsD6
	4boxERx58T7MvNGorhgyy6fL9vWquDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730919854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yhd7diviVJAQ5yP+UbM5p1XwCMEubdSyRCKtvCS18g=;
	b=nmMnvqs9QPmkCkCTiXEp80EKwT8hdkdXZHnyZzg7etiIGg3MNTSEMk1jeQnzmdCv6VeuSq
	nYAg3MKOJbT4UfCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730919854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yhd7diviVJAQ5yP+UbM5p1XwCMEubdSyRCKtvCS18g=;
	b=H3fKbZX1l8KU9rxypHqJygEW5itAJp/FV+ExgbnEniNxJfakF91ZMH2PpIs3HA8xH1hW4p
	74A3cdHJYsMIpi9y47MMMNLLS9G9uDxAf1Gf5aUL3RTCQcR1dMh4aAT2AUir0KgiblnsD6
	4boxERx58T7MvNGorhgyy6fL9vWquDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730919854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yhd7diviVJAQ5yP+UbM5p1XwCMEubdSyRCKtvCS18g=;
	b=nmMnvqs9QPmkCkCTiXEp80EKwT8hdkdXZHnyZzg7etiIGg3MNTSEMk1jeQnzmdCv6VeuSq
	nYAg3MKOJbT4UfCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14F2C13736;
	Wed,  6 Nov 2024 19:04:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ut3uBK69K2fnEAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 06 Nov 2024 19:04:14 +0000
Date: Wed, 6 Nov 2024 20:04:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	maharmstone@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] io_uring/cmd: let cmds to know about dying task
Message-ID: <20241106190408.GI31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <55888b6a644b4fc490849832fd5c5e5bfed523ef.1730687879.git.asml.silence@gmail.com>
 <269a3887-070f-4faf-85d6-73e833f727ab@kernel.dk>
 <6c774395-6537-477d-a5a6-f58edb07f436@gmail.com>
 <421a29af-1bb8-4106-a875-5c382eed3d90@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <421a29af-1bb8-4106-a875-5c382eed3d90@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.50
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,fb.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, Nov 04, 2024 at 10:31:19AM -0700, Jens Axboe wrote:
> On 11/4/24 9:47 AM, Pavel Begunkov wrote:
> > On 11/4/24 16:15, Jens Axboe wrote:
> >> On 11/4/24 9:12 AM, Pavel Begunkov wrote:
> >>> When the taks that submitted a request is dying, a task work for that
> >>> request might get run by a kernel thread or even worse by a half
> >>> dismantled task. We can't just cancel the task work without running the
> >>> callback as the cmd might need to do some clean up, so pass a flag
> >>> instead. If set, it's not safe to access any task resources and the
> >>> callback is expected to cancel the cmd ASAP.
> >>>
> >>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>> ---
> >>>
> >>> Made a bit fancier to avoid conflicts. Mark, as before I'd suggest you
> >>> to take it and send together with the fix.
> >>
> >> That's fine, or we can just take it through the io_uring tree, it's not
> >> like this matters as both will land before -rc1.
> > 
> > There should be a btrfs patch that depends on it and I would hope
> > it gets squashed into the main patchset or at least goes into the
> > same pull and not delayed to rc2.
> 
> Right, all I'm saying is that both will land in -rc1 and it doesn't
> really matter. Even if it's -rc2 it's not like a potential breakage with
> this for certain exiting conditions is an issue. All that really matters
> is that the final release is fine.
> 
> But like I said, I don't really care - it can go through the btrfs tree
> as-is, or I can take it and it'll land in -rc1. If the latter, then I'd
> just modify it to use io_should_terminate_tw() fro the get-go, if it
> goes via the btrfs tree, then we can do a separate patch for that after
> the fact.
> 
> I just need to know what the btrfs people intend to do here, so I can
> plan accordingly.

I'll add it to btrfs tree, branch for-next and it will be in the main
merge window pull request.

