Return-Path: <io-uring+bounces-1623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD018B2159
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 14:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 545BF28B4E7
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 12:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B605912B156;
	Thu, 25 Apr 2024 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BaUApwGb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qxERu/C9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BaUApwGb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qxERu/C9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD1012C492
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 12:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046721; cv=none; b=E/bwNgxSgXL2XKV33sTvNrYwuJoCKWFi3Vv0TSRDm4Gu8A3ETEoZ1LZuJfmvUVWj7CPSBve/MyNZfpWi9IcdsNknSB3B+jRBd3wf+BTkgndhiZwIE/pGpaxIiGpHyiSvOsNtq+mqgMHSCq+a03tIkovuX/u1U6dWB2PsnILohkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046721; c=relaxed/simple;
	bh=jpkYDiiPuH0WYtGXrVTt0Dt225R2aZLif6aXtjESQFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=g1BKeDLtyAQzSfsYNtkj4oTZ5Hip+sv1IJBBBVOyNdiHBL3HT9gZUvGmfDAw8CGsSvIhZuMvmuH+E2m07z41e07XGuxhL8Z5U0fqbqW927ut0lc88I5Ou65MNXQWIjlDY4aW3XGcvNdDnXiOjkyKG72FzYbmLkNTmjNrMsHiOm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BaUApwGb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qxERu/C9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BaUApwGb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qxERu/C9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F815339C3;
	Thu, 25 Apr 2024 11:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714046202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Go9XoR1skexcYqYoph9VW7WOGz9kQScO6IBz/KVaMcM=;
	b=BaUApwGbVMUT40JL5DFctsr42ww/kCW+2JJW4R8d4rI0dID6auu5A/DVP4YPt66eoQQIyn
	05/wnuQ3xjVU2N921cFJ95SIxWK3LFqZXD69A3M+qlxC3fPkyJMmJEv11iZx2rl+uLeipo
	P63Okb+BQTq9eSoS1imxXeS0CUDgf1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714046202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Go9XoR1skexcYqYoph9VW7WOGz9kQScO6IBz/KVaMcM=;
	b=qxERu/C9pyqHHkyKAp4R2WL3pXNW+ol2gc3hqirZWoPZg4Rs3GLGzCBc1y8oe/+QAoMDzM
	UcffsawVDoX61SBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714046202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Go9XoR1skexcYqYoph9VW7WOGz9kQScO6IBz/KVaMcM=;
	b=BaUApwGbVMUT40JL5DFctsr42ww/kCW+2JJW4R8d4rI0dID6auu5A/DVP4YPt66eoQQIyn
	05/wnuQ3xjVU2N921cFJ95SIxWK3LFqZXD69A3M+qlxC3fPkyJMmJEv11iZx2rl+uLeipo
	P63Okb+BQTq9eSoS1imxXeS0CUDgf1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714046202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Go9XoR1skexcYqYoph9VW7WOGz9kQScO6IBz/KVaMcM=;
	b=qxERu/C9pyqHHkyKAp4R2WL3pXNW+ol2gc3hqirZWoPZg4Rs3GLGzCBc1y8oe/+QAoMDzM
	UcffsawVDoX61SBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3494D13991;
	Thu, 25 Apr 2024 11:56:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7S/RDPpEKmZ/VwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 25 Apr 2024 11:56:42 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] io_uring/net: add provided buffer support for
 IORING_OP_SEND
In-Reply-To: <20240420133233.500590-4-axboe@kernel.dk> (Jens Axboe's message
	of "Sat, 20 Apr 2024 07:29:44 -0600")
References: <20240420133233.500590-2-axboe@kernel.dk>
	<20240420133233.500590-4-axboe@kernel.dk>
Date: Thu, 25 Apr 2024 13:56:40 +0200
Message-ID: <878r11zmdj.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> It's pretty trivial to wire up provided buffer support for the send
> side, just like how it's done the receive side. This enables setting up
> a buffer ring that an application can use to push pending sends to,
> and then have a send pick a buffer from that ring.
>
> One of the challenges with async IO and networking sends is that you
> can get into reordering conditions if you have more than one inflight
> at the same time. Consider the following scenario where everything is
> fine:
>
> 1) App queues sendA for socket1
> 2) App queues sendB for socket1
> 3) App does io_uring_submit()
> 4) sendA is issued, completes successfully, posts CQE
> 5) sendB is issued, completes successfully, posts CQE
>
> All is fine. Requests are always issued in-order, and both complete
> inline as most sends do.






>
> However, if we're flooding socket1 with sends, the following could
> also result from the same sequence:
>
> 1) App queues sendA for socket1
> 2) App queues sendB for socket1
> 3) App does io_uring_submit()
> 4) sendA is issued, socket1 is full, poll is armed for retry
> 5) Space frees up in socket1, this triggers sendA retry via task_work
> 6) sendB is issued, completes successfully, posts CQE
> 7) sendA is retried, completes successfully, posts CQE
>
> Now we've sent sendB before sendA, which can make things unhappy. If
> both sendA and sendB had been using provided buffers, then it would look
> as follows instead:
>
> 1) App queues dataA for sendA, queues sendA for socket1
> 2) App queues dataB for sendB queues sendB for socket1
> 3) App does io_uring_submit()
> 4) sendA is issued, socket1 is full, poll is armed for retry
> 5) Space frees up in socket1, this triggers sendA retry via task_work
> 6) sendB is issued, picks first buffer (dataA), completes successfully,
>    posts CQE (which says "I sent dataA")
> 7) sendA is retried, picks first buffer (dataB), completes successfully,
>    posts CQE (which says "I sent dataB")

Hi Jens,

If I understand correctly, when sending a buffer, we set sr->len to be
the smallest between the buffer size and what was requested in sqe->len.
But, when we disconnect the buffer from the request, we can get in a
situation where the buffers and requests mismatch,  and only one buffer
gets sent.

Say we are sending two buffers through non-bundle sends with different
sizes to the same socket in this order:

 buff[1]->len = 128
 buff[2]->len = 256

And SQEs like this:

 sqe[1]->len = 128
 sqe[2]->len = 256

If sqe1 picks buff1 it is all good. But, if sqe[2] runs first, then
sqe[1] picks buff2, and it will only send the first 128, won't it?
Looking at the patch I don't see how you avoid this condition, but
perhaps I'm missing something?

One suggestion would be requiring sqe->len to be 0 when using send with
provided buffers, so we simply use the entire buffer in
the ring.  wdyt?

Thanks,

-- 
Gabriel Krisman Bertazi

