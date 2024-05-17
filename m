Return-Path: <io-uring+bounces-1925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C6B8C8E62
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 01:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0641F22BCB
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 23:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7582E40F;
	Fri, 17 May 2024 23:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E/TMdsn5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u6Pmkeun";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E/TMdsn5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u6Pmkeun"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8828DD5
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715987032; cv=none; b=e55ZepXlAqCc/klM0uu6xAqlix552XCiFb6vEC3fBgP5DQs5UZIFbesk53AojU0eZewVz6BFFzAZPXz8Lkgu4SKpfcrhco/tvxpKecMKI2N+3E+0dqnFyWFS3iTi12yrRDgz34ntbUp3zvkatKmEdK4n8VVlRRiRxsCDLapruh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715987032; c=relaxed/simple;
	bh=KFFSipyJNh6a3UTTTGGDCEJIUEbSR9QJGov42TdbfFE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VSxGtappY86M5Ez+p2anpgK4FJOP6+65SWXyqd9oyT5wLGLp8NcOuh3aS5/vUl9eot303v3UcopB10JZimjedsJUeWFaOlimOY0iHA2fE1xQLQeCqbYa/U3SgSDKuZKfyfS224jwuBhk8xrD9BHObu2oiybTHSLR1zkWE4COFjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E/TMdsn5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u6Pmkeun; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E/TMdsn5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u6Pmkeun; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6ACD7378F5;
	Fri, 17 May 2024 23:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715987023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwpqdDFM18tH4JA73Jpvhe9T4oMOakw07avLGdMLBwQ=;
	b=E/TMdsn5j7ApnuvXPhhGD2i67STy42i6nNzM0GoGAgvYAEraychPn6tDUNxiD0atVjXWTk
	LMhC6JTLr01a3yW8jjAWTTFc5MkeQkwS72Rf4kP88+KcX9WqNAp1Y7dc8NwL0X1h2Gk8s/
	B2BfnkSPYh+WPofdifBSZ7S64RsWQbc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715987023;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwpqdDFM18tH4JA73Jpvhe9T4oMOakw07avLGdMLBwQ=;
	b=u6PmkeunN4hE6x5GUtfJKFxue6nIQHvcMrDP4NBKPEAy2HJLATQ9Euym+BrQ5MgjnWe/ck
	AtDR89z4QEzVoHDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715987023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwpqdDFM18tH4JA73Jpvhe9T4oMOakw07avLGdMLBwQ=;
	b=E/TMdsn5j7ApnuvXPhhGD2i67STy42i6nNzM0GoGAgvYAEraychPn6tDUNxiD0atVjXWTk
	LMhC6JTLr01a3yW8jjAWTTFc5MkeQkwS72Rf4kP88+KcX9WqNAp1Y7dc8NwL0X1h2Gk8s/
	B2BfnkSPYh+WPofdifBSZ7S64RsWQbc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715987023;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwpqdDFM18tH4JA73Jpvhe9T4oMOakw07avLGdMLBwQ=;
	b=u6PmkeunN4hE6x5GUtfJKFxue6nIQHvcMrDP4NBKPEAy2HJLATQ9Euym+BrQ5MgjnWe/ck
	AtDR89z4QEzVoHDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28FDE13942;
	Fri, 17 May 2024 23:03:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLrVA0/iR2axTwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 17 May 2024 23:03:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Mathieu Masson <mathieu.kernel@proton.me>
Cc: Jens Axboe <axboe@kernel.dk>,  io-uring@vger.kernel.org
Subject: Re: [Announcement] io_uring Discord chat
In-Reply-To: <ZkfZIgwD3OgPSJ8d@cave.home> (Mathieu Masson's message of "Fri,
	17 May 2024 22:24:37 +0000")
Organization: SUSE
References: <8734qguv98.fsf@mailhost.krisman.be>
	<f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
	<ZkfZIgwD3OgPSJ8d@cave.home>
Date: Fri, 17 May 2024 19:03:36 -0400
Message-ID: <87ttiwt513.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-2.96)[99.81%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[3]
X-Spam-Score: -4.26
X-Spam-Flag: NO

Mathieu Masson <mathieu.kernel@proton.me> writes:

> On 17 mai 13:09, Jens Axboe wrote:

> Not to start any form of chat platform war, but the rust-for-linux community has
> been using Zulip for a while now. At some point they made the full message
> history live accessible without an account :
>
> https://rust-for-linux.zulipchat.com/
>
>
> It is even search-able apparently, which is quite appreciable as an outsider
> who just wants to follow a bit in a more informal way than the ML.

I have no objection to Zulip if that is deemed better by the community.
I have never used Discord until today either, and I chose it because I
had heard the name before and Jens mentioned he uses it.  It seems a quite
popular service nowadays, so I'd expect more people to already have an
account there than on Zulip.

But I agree that being searchable is essential.  For that, I was looking
into this:

  https://www.linen.dev/

which apparently turns discord channels into a read-only, Google-indexed
interface.

-- 
Gabriel Krisman Bertazi

