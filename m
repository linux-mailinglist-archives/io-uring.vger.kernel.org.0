Return-Path: <io-uring+bounces-10791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B8703C86A9B
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 19:37:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9CCD74E60AF
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 18:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2BD3321AA;
	Tue, 25 Nov 2025 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iGA6LscB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8ounlTRH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iGA6LscB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8ounlTRH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332C62D97A4
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 18:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095853; cv=none; b=N7KAXFGtpquoDjw2Y0G5J2Llj9qsVw0CiFOglYTV0Ko/5eqGAjj4fCGAmlLEb1/3mpqG3Hcqrm8mNHpwYqFN4U2/MuKkAbNVVtIfWcykb2/CVTlGib2p7VNQcHu5CIS3hY7KhbdRxexDDN60Q2e1bJlXr/8Bhs71K+dUas1M/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095853; c=relaxed/simple;
	bh=UD6VqYDlbach/7UrxFe4s8icPPzP2bPG5uzZUSKRTzY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IZSoumup4OMDotFIo0b2zFpg4BsHtzDptLcqxMgaCI3CEZGm2KkJiFTemC4TDNlmwtX6G63wDP4fFLZsXp8S6Kq6hKUSIZdX0qcb/cKXlxeGj6jVeo2az3x2Bepa2E3C7XeBhyKb7mitLjr7t3/h04CqgZiIfueMGt2bFz2Wo6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iGA6LscB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8ounlTRH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iGA6LscB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8ounlTRH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F3185BE1B;
	Tue, 25 Nov 2025 18:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764095850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ys75oXiV5yeKm6WL9VDM2GUYBUXOKxhgeSPtQerEL50=;
	b=iGA6LscBLW/V9gb3blZgPWVnm1xIqYkju7yu2GJMXO2isw5DSezA0SkSGAM3xDi++KG1LD
	ebrsNp6E5vuqams50NeTHDReNQ0EmJsfi3KnLe/uzKC1sladQk806f6T9fCpqFHDuTTt19
	ioQYA5JcydktfFTkrAyf+LcKx9c+ITQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764095850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ys75oXiV5yeKm6WL9VDM2GUYBUXOKxhgeSPtQerEL50=;
	b=8ounlTRHLTWvXbJoy1GPsQuGAddpbmRa69Fmor4ucNQZfRM3lIFIL+uCHNb96DOiOqZp05
	rs7Y8YMe3CVIHxDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iGA6LscB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8ounlTRH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764095850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ys75oXiV5yeKm6WL9VDM2GUYBUXOKxhgeSPtQerEL50=;
	b=iGA6LscBLW/V9gb3blZgPWVnm1xIqYkju7yu2GJMXO2isw5DSezA0SkSGAM3xDi++KG1LD
	ebrsNp6E5vuqams50NeTHDReNQ0EmJsfi3KnLe/uzKC1sladQk806f6T9fCpqFHDuTTt19
	ioQYA5JcydktfFTkrAyf+LcKx9c+ITQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764095850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ys75oXiV5yeKm6WL9VDM2GUYBUXOKxhgeSPtQerEL50=;
	b=8ounlTRHLTWvXbJoy1GPsQuGAddpbmRa69Fmor4ucNQZfRM3lIFIL+uCHNb96DOiOqZp05
	rs7Y8YMe3CVIHxDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2ACF3EA63;
	Tue, 25 Nov 2025 18:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dUf0L2n3JWlKWgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 18:37:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Stefan Metzmacher <metze@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>,  netdev@vger.kernel.org,
  io-uring@vger.kernel.org,  Jakub Kicinski <kuba@kernel.org>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,
  Kuniyuki Iwashima <kuniyu@google.com>,  Paolo Abeni <pabeni@redhat.com>,
  Willem de Bruijn <willemb@google.com>,  Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v3 3/3] io_uring: Introduce getsockname io_uring cmd
In-Reply-To: <dc97cb0e-628c-4a97-98ca-06ececf32e1e@samba.org> (Stefan
	Metzmacher's message of "Tue, 25 Nov 2025 13:36:26 +0100")
Organization: SUSE
References: <20251125002345.2130897-1-krisman@suse.de>
	<20251125002345.2130897-4-krisman@suse.de>
	<dc97cb0e-628c-4a97-98ca-06ececf32e1e@samba.org>
Date: Tue, 25 Nov 2025 13:37:27 -0500
Message-ID: <87y0nuhsbc.fsf@mailhost.krisman.be>
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
X-Rspamd-Queue-Id: 3F3185BE1B
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

Stefan Metzmacher <metze@samba.org> writes:

> Hi Gabriel,
>
>> +static int io_uring_cmd_getsockname(struct socket *sock,
>> +				    struct io_uring_cmd *cmd,
>> +				    unsigned int issue_flags)
>> +{
>> +	const struct io_uring_sqe *sqe = cmd->sqe;
>> +	struct sockaddr __user *uaddr;
>> +	unsigned int peer;
>> +	int __user *ulen;
>> +
>> +	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
>> +		return -EINVAL;
>> +
>> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	ulen = u64_to_user_ptr(sqe->addr3);
>> +	peer = READ_ONCE(sqe->optlen);
>> +	if (peer > 1)
>> +		return -EINVAL;
>> +	return do_getsockname(sock, 0, uaddr, ulen);
>
> I guess this should actually pass down 'peer' instead of '0'?

Thanks for the catch.  I guess two wrongs *do* make a right somethings.
The getpeername test was peeking at the wrong socket, effectively
testing the local port against itself, and it thus succeeded. Updated
the test and will send a v4.

-- 
Gabriel Krisman Bertazi

