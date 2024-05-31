Return-Path: <io-uring+bounces-2049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3966C8D6CA1
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 01:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69A591C253AB
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF0C495E5;
	Fri, 31 May 2024 23:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qm6IY79Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0SUj98z7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qm6IY79Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0SUj98z7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C31381BD;
	Fri, 31 May 2024 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717196493; cv=none; b=jYJgDE5CTubHRWRgyburbtlAUvqdlWdq85+D3uVHZWtBVhGlMTf91h7uKKFs8NnY6L1kcBtpjTGAJmR5pb5ylye3twuZg3PvLu0Xh6yiRfVN5inhdjDZOJj0vdpJ0WphwfhElPW8blpkSw3ceZBcIXUkSfrNld5ziVcjwLj+R68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717196493; c=relaxed/simple;
	bh=wDqs4ThFo52LoqQesR8irb9lFe2acozAAhyxyaiencg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JcWO8ZVccRQCF5nhSUAVJqyJfA4iuzW6mpWCIwYHklbZyhF4/fwiHDicHOEeREBTUHTjAQDGBmz/kSl5I1/Qs8/pvv7c9J724qILxcgI4o0Myh9uQKK4REt9o8lvbEEIPhfn3DFJWRCHf0XJm4Lcm/mWZ2DQB2Ai9u4X5jfrqEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qm6IY79Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0SUj98z7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qm6IY79Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0SUj98z7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3693A1FD43;
	Fri, 31 May 2024 23:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717196486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zRnZX4j0bdCwU01y30af9KqqKHUijWBPhrezGa/QZw=;
	b=Qm6IY79Y24m1+vFarlybDSi3Zy2CnIrWEgWbkiPx2INSaBmzEX0nPO+ZnL0A1LaJT9cIWC
	uzygQeeduVCSl4RDmM4nD6jmBmzBSBsjWYmPIN+cjKIgotoqf7bwoJa7mWDnpuk5EWLkyq
	9h39FfRVZ03KmJVTwMCGTN++XGQ/RbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717196486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zRnZX4j0bdCwU01y30af9KqqKHUijWBPhrezGa/QZw=;
	b=0SUj98z7t/iV7zYI5lTcPFuB+YPejbJcPkuZ27uf2BRq+RXA90FgPPYrVKq8U7aM7Pn9hy
	fWt/MsgrrsJRVABg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qm6IY79Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0SUj98z7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717196486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zRnZX4j0bdCwU01y30af9KqqKHUijWBPhrezGa/QZw=;
	b=Qm6IY79Y24m1+vFarlybDSi3Zy2CnIrWEgWbkiPx2INSaBmzEX0nPO+ZnL0A1LaJT9cIWC
	uzygQeeduVCSl4RDmM4nD6jmBmzBSBsjWYmPIN+cjKIgotoqf7bwoJa7mWDnpuk5EWLkyq
	9h39FfRVZ03KmJVTwMCGTN++XGQ/RbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717196486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zRnZX4j0bdCwU01y30af9KqqKHUijWBPhrezGa/QZw=;
	b=0SUj98z7t/iV7zYI5lTcPFuB+YPejbJcPkuZ27uf2BRq+RXA90FgPPYrVKq8U7aM7Pn9hy
	fWt/MsgrrsJRVABg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F19AC137C3;
	Fri, 31 May 2024 23:01:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8l/aNMVWWmaIBwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 23:01:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] io_uring: Fix leak of async data when connect prep
 fails
In-Reply-To: <d071a3f8-c4af-48ef-adae-385ea8705377@kernel.dk> (Jens Axboe's
	message of "Fri, 31 May 2024 15:30:19 -0600")
Organization: SUSE
References: <20240531211211.12628-1-krisman@suse.de>
	<20240531211211.12628-2-krisman@suse.de>
	<d071a3f8-c4af-48ef-adae-385ea8705377@kernel.dk>
Date: Fri, 31 May 2024 19:01:19 -0400
Message-ID: <87ttidmvr4.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3693A1FD43
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]

Jens Axboe <axboe@kernel.dk> writes:

> On 5/31/24 3:12 PM, Gabriel Krisman Bertazi wrote:
>> move_addr_to_kernel can fail, like if the user provides a bad sockaddr
>> pointer. In this case where the failure happens on ->prep() we don't
>> have a chance to clean the request later, so handle it here.
>
> Hmm, that should still get freed in the cleanup path? It'll eventually
> go on the compl_reqs list, and it has REQ_F_ASYNC_DATA set. Yes it'll
> be slower than the recycling it, but that should not matter as it's
> an erred request.

Hm right.  I actually managed to reproduce some kind of memory
exhaustion yesterday that I thought was fixed by this patch.  But I see
your point and I'm failing to trigger it today.

Please disregard this patch. I'll look further to figure out what I did
there.


-- 
Gabriel Krisman Bertazi

