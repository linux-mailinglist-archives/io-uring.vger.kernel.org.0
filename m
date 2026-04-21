Return-Path: <io-uring+bounces-13095-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NOCKqCu52lZ/QEAu9opvQ
	(envelope-from <io-uring+bounces-13095-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:06:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BD343DB92
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1FAF3026F1D
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A38A21ADC7;
	Tue, 21 Apr 2026 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EF/j6KCE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="g67/dli5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EF/j6KCE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="g67/dli5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4645D2D97B7
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791163; cv=none; b=qMrFgoH5+CQZVfG/66ssh520dzIQzhN1iO/elPJstvm0ION/CeomFrM91ayo7G8si2VenYZf6X0vNBEbv00lAFnIqWjcl3HLo2gER7quQIiXE8N6PD8Ou+eGciYMqgASScZ416bIpyXhopvC3WATh08lqNVUCcE7+9Z7n2Qm4Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791163; c=relaxed/simple;
	bh=9J2hhG7hQyH4WjUzo15EElH1On4YxLDKBrP7h1hnius=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JrYuo+X16joEQInG/QQrY9kt1gVHvHwK4+SVSQcIrsO1XiscsCio3xkl0yAE+MThvSg8gs7MPkNmNJCW4VDtu3cbI5knmD8VqN/Ypx5tPfMbKurWJQMKH6rzzU4EAQrTRrfM0U9ZykLk5JWF/z9SNpPp0dDP2mRjN3H5OoK5iMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EF/j6KCE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=g67/dli5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EF/j6KCE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=g67/dli5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A4196A800;
	Tue, 21 Apr 2026 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/8XfR2fGigeSXwrRsos2Ar7zmITy/DxXvR2kYWRLMo=;
	b=EF/j6KCEBVJPSFEIajSFPn3yYxLZCobDByNekW0aXkdb3C67jfD2U2NQD8C5Q5iTkU8tXB
	A3P5CzGwaaFaqNaoRkzkJPAyoDcFiR/fXzSddU31ErtSMcx+rtrzLx/w/yJmMvAKKei7VP
	ZJYbOXvgTJmno11aLMW0KhtaVWGuLvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/8XfR2fGigeSXwrRsos2Ar7zmITy/DxXvR2kYWRLMo=;
	b=g67/dli5qBm+gbyK6IRbZVfFTWjStn/Fcr1shnRi+yzScuhCS+K4YQOg8KZccDRpWBiR8o
	8slWdQxHgxfasOBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="EF/j6KCE";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="g67/dli5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/8XfR2fGigeSXwrRsos2Ar7zmITy/DxXvR2kYWRLMo=;
	b=EF/j6KCEBVJPSFEIajSFPn3yYxLZCobDByNekW0aXkdb3C67jfD2U2NQD8C5Q5iTkU8tXB
	A3P5CzGwaaFaqNaoRkzkJPAyoDcFiR/fXzSddU31ErtSMcx+rtrzLx/w/yJmMvAKKei7VP
	ZJYbOXvgTJmno11aLMW0KhtaVWGuLvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/8XfR2fGigeSXwrRsos2Ar7zmITy/DxXvR2kYWRLMo=;
	b=g67/dli5qBm+gbyK6IRbZVfFTWjStn/Fcr1shnRi+yzScuhCS+K4YQOg8KZccDRpWBiR8o
	8slWdQxHgxfasOBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A9AD593AF;
	Tue, 21 Apr 2026 17:05:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C8wSMneu52nUYwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 21 Apr 2026 17:05:59 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] io_uring: fix spurious fput in registered ring path
In-Reply-To: <20260421135626.581917-2-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 21 Apr 2026 07:51:38 -0600")
References: <20260421135626.581917-1-axboe@kernel.dk>
	<20260421135626.581917-2-axboe@kernel.dk>
Date: Tue, 21 Apr 2026 13:05:53 -0400
Message-ID: <87bjfcqm4u.fsf@mailhost.krisman.be>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13095-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,suse.de:dkim,suse.de:email,mailhost.krisman.be:mid]
X-Rspamd-Queue-Id: 15BD343DB92
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Jens Axboe <axboe@kernel.dk> writes:

> Fix an issue with io_uring_ctx_get_file() not gating fput() on whether
> or not the file descriptor is a registered/direct one or not.
>
> Fixes: c5e9f6a96bf7 ("io_uring: unify getting ctx from passed in file descriptor")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Oh.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi

