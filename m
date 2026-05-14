Return-Path: <io-uring+bounces-13341-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICeKMyHlBWoAdQIAu9opvQ
	(envelope-from <io-uring+bounces-13341-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 17:07:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 447AE543B93
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 17:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9568E3066301
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EC8279355;
	Thu, 14 May 2026 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A3XE2Klw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="29mOaSwI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A3XE2Klw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="29mOaSwI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348263DD85F
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770713; cv=none; b=MVBqCsW+cKDNWeuqR0/S6IicoPEswnHuHQ/Zi5VzaU/s6ZYo8EA+INTNoLMtropOJAB2FH3bfItndvoDUzKpLomuST8W2oDul0LHwEemEwYbDvdvrEBsYFlqc8/v21U66SSPWslaQ1nchp6Sw5gbLuIGZbRY04SJZ4M8fUf6bdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770713; c=relaxed/simple;
	bh=2hvIJa9D4FCtoQZgH9hc6Hps7U7Yf6kF5Dig3OghAAw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HAyvuvOERxsvDuP4Elcv0Wg956mC1SDN2khE18845Z9g70qToLbq0fHp7Wiaz6VHvLGEIz8si47DB8LGjc3y9z8BIUHe+LeAxA8sN4v0K6qnKJpGUu62QZL0sKEW50AEd9+9StExQgVKzHEqBOkWFs7keus2s0cFgDkoEF2PzAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A3XE2Klw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=29mOaSwI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A3XE2Klw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=29mOaSwI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 326D762C38;
	Thu, 14 May 2026 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778770710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fk744aACcqW2bZImFAJAKRFXEpvBuWo3Zx1yXPROzhg=;
	b=A3XE2Klwyc4ZG/zbQqMbeOnIsPdmvjYhhpXf3IZ6GANEtpf2boSW5AePttmsWna0INpN56
	PuljCMQ8Zwq0F0WUk6eRD8h/q30MnwzxRs5uiyy4AHegzjGYtPjW7KT00ljabgO9WcjOIP
	Car2441JtXcr2gPFwsj4eLO3tsUAWZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778770710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fk744aACcqW2bZImFAJAKRFXEpvBuWo3Zx1yXPROzhg=;
	b=29mOaSwIM2DpKNMgi33sSDSs47JeK9JYE6JsQElIPkPZV9oOPd0wreAWvhYzfzPOy8tPii
	dU5M+b2EUR+/SKCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778770710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fk744aACcqW2bZImFAJAKRFXEpvBuWo3Zx1yXPROzhg=;
	b=A3XE2Klwyc4ZG/zbQqMbeOnIsPdmvjYhhpXf3IZ6GANEtpf2boSW5AePttmsWna0INpN56
	PuljCMQ8Zwq0F0WUk6eRD8h/q30MnwzxRs5uiyy4AHegzjGYtPjW7KT00ljabgO9WcjOIP
	Car2441JtXcr2gPFwsj4eLO3tsUAWZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778770710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fk744aACcqW2bZImFAJAKRFXEpvBuWo3Zx1yXPROzhg=;
	b=29mOaSwIM2DpKNMgi33sSDSs47JeK9JYE6JsQElIPkPZV9oOPd0wreAWvhYzfzPOy8tPii
	dU5M+b2EUR+/SKCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAFE2593A9;
	Thu, 14 May 2026 14:58:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hfqwMhXjBWq3SAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 14 May 2026 14:58:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,  Yi Xie
 <xieyi@kylinos.cn>,  io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
In-Reply-To: <49a10373-f2d8-4813-b9d6-25cd2a0f2fe6@kernel.dk> (Jens Axboe's
	message of "Thu, 14 May 2026 08:25:21 -0600")
References: <20260514083443.203387-1-xieyi@kylinos.cn>
	<CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
	<49a10373-f2d8-4813-b9d6-25cd2a0f2fe6@kernel.dk>
Date: Thu, 14 May 2026 10:58:28 -0400
Message-ID: <87a4u2597v.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Rspamd-Queue-Id: 447AE543B93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13341-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:dkim,kernel.dk:email,mailhost.krisman.be:mid]
X-Rspamd-Action: no action

Jens Axboe <axboe@kernel.dk> writes:

>>>  /* Mapped buffer ring, return io_uring_buf from head */
>>> -#define io_ring_head_to_buf(br, head, mask)    &(br)->bufs[(head) & (mask)]
>>> +#define io_ring_head_to_buf(br, head, mask)    (&(br)->bufs[(head) & (mask)])
>> 
>> Is there a reason this can't just be an inline function?
>
> And generally I don't like cleanups like this, but this one
> at least made sense to me.

The annoying part, IMO, is that we/I look at every trivial fix
wondering if it really is just a parenthesis fix, or if it's the next
CopyFail/Fragnesia fix with an obfuscated commit message..

ty

-- 
Gabriel Krisman Bertazi

