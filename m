Return-Path: <io-uring+bounces-1701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 326828B90DB
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 22:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55FC41C21DA8
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 20:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82410165FA5;
	Wed,  1 May 2024 20:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Krk3oecz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ROmaX73C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="arrltBac";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MWgX5hr4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65A11649A8
	for <io-uring@vger.kernel.org>; Wed,  1 May 2024 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714596481; cv=none; b=Awz52yjgFCbFofUJjUnW3WhoFHfZgPs/e+2l7vXB8puuX/F4Yej+4zX4n/4I1EcA+E5hYvKUAsvULgxi3QRRAMu7izOe9pVA3OWRWzQJt3/k5iwXk+Kc8NUTkuyg2htH9jXcDhMXqPLarJfpBVWzXa8xmIaYjTfRQSTrNfdSCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714596481; c=relaxed/simple;
	bh=SPvnVrg/4ijdQSOPfgboaUcdqbCQG3bq44rRcMZhoN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NpkapduYNSdWNMsyVuQiLdS9UrSCbzkGTs5lmGwyIvhB/IJEQdKrg/GOQNNHKeBY2GmHuJKSXhyTq6NpKbQdnvCu3bT6QbH0rKZoo6oArd4Jgd5yq7D6OGMX3Ozj9czOqYNrlbh470vCay5FBzgm2YsHrzkqXHdAELRd4IJLtqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Krk3oecz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ROmaX73C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=arrltBac; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MWgX5hr4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DA46B1F898;
	Wed,  1 May 2024 20:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714596478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQmmwt4H1xTfaABf3orZYJBwC6H+grpqLC8mXAUxr1g=;
	b=Krk3oeczy8oWxWZjcBNUoFGve4ACT7Fm+n+WOLEmr50YLz74HzwmLQ+LDC8o9uEQ/vUw6A
	uReyjxySp89zcbVAW1huLje7G3eHKCL0slTNh4THLPenNyoJD78VOxdEA889ppdLviwdAR
	hTw3fphi48PNmNBxOV8eSMIoEP7zi0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714596478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQmmwt4H1xTfaABf3orZYJBwC6H+grpqLC8mXAUxr1g=;
	b=ROmaX73CE5gclCYgPpnk5crPOoRFlKp87/31qK6wpsirEMPq9StdnDN5E6NQztt/j5osii
	SJ4MJhjLwn9TzNBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714596477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQmmwt4H1xTfaABf3orZYJBwC6H+grpqLC8mXAUxr1g=;
	b=arrltBacuyNe+v5BylP2vy6LXWPG/V8lGdxaxFUfhn3cMBiK08QW885zZorA97JxMa554J
	4/8iY2fkC3epLQB5Zw7b8LWQqKQwYjd2wgXBERz66xTToKAl4NSXo2SZFbyHEEVv04tCwl
	Oc8ZHb14wDU8y4VNFmhfctf0IrCmq0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714596477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EQmmwt4H1xTfaABf3orZYJBwC6H+grpqLC8mXAUxr1g=;
	b=MWgX5hr46yosAGV0vxjhxYKZANPeGCxOf8CW4qGWKN2Wto0pKrR9UgvHruIB6o4NiCvn6b
	bjKlJQveOXL87/DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D4E013942;
	Wed,  1 May 2024 20:47:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dqseIH2qMmarKgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 01 May 2024 20:47:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Require zeroed sqe->len on provided-buffers send
In-Reply-To: <909e44a9-c9e2-45aa-9eba-fcf10904e503@kernel.dk> (Jens Axboe's
	message of "Tue, 30 Apr 2024 07:02:01 -0600")
Organization: SUSE
References: <20240429181556.31828-1-krisman@suse.de>
	<909e44a9-c9e2-45aa-9eba-fcf10904e503@kernel.dk>
Date: Wed, 01 May 2024 16:47:52 -0400
Message-ID: <878r0tz2br.fsf@mailhost.krisman.be>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> On 4/29/24 12:15 PM, Gabriel Krisman Bertazi wrote:
>> When sending from a provided buffer, we set sr->len to be the smallest
>> between the actual buffer size and sqe->len.  But, now that we
>> disconnect the buffer from the submission request, we can get in a
>> situation where the buffers and requests mismatch, and only part of a
>> buffer gets sent.  Assume:
>> 
>> * buf[1]->len = 128; buf[2]->len = 256
>> * sqe[1]->len = 128; sqe[2]->len = 256
>> 
>> If sqe1 runs first, it picks buff[1] and it's all good. But, if sqe[2]
>> runs first, sqe[1] picks buff[2], and the last half of buff[2] is
>> never sent.
>> 
>> While arguably the use-case of different-length sends is questionable,
>> it has already raised confusion with potential users of this
>> feature. Let's make the interface less tricky by forcing the length to
>> only come from the buffer ring entry itself.
>> 
>> Fixes: ac5f71a3d9d7 ("io_uring/net: add provided buffer support for IORING_OP_SEND")
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
>> ---
>>  io_uring/net.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 51c41d771c50..ffe37dd77a74 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -423,6 +423,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  		sr->buf_group = req->buf_index;
>>  		req->buf_list = NULL;
>>  	}
>> +	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
>> +		return -EINVAL;
>>  
>>  #ifdef CONFIG_COMPAT
>>  	if (req->ctx->compat)
>
> Why not put it in io_send(), under io_do_buffer_select()? Then
> you can get rid of the:
>
> .max_len = min_not_zero(sr->len, INT_MAX),
>
> and just do
>
> .max_len = INT_MAX,
>

Mostly because I'd expect this kind of validation of userspace data to
be done early in ->prep, when we are consuming the sqe.  But more
importantly, if I read the code correctly, doing it under
io_do_buffer_select() in io_send() is more convoluted because we have
that backward jump in case we don't send the full set of buffers in the
bundle case, and we dirty sr->len with the actual returned buffer length.

since we already checked in prep, we can safely ignore it in the
io_do_buffer_select, anyway. What do you think of the below?

-- >8 --
Subject: [PATCH] io_uring: Require zeroed sqe->len on provided-buffers send

When sending from a provided buffer, we set sr->len to be the smallest
between the actual buffer size and sqe->len.  But, now that we
disconnect the buffer from the submission request, we can get in a
situation where the buffers and requests mismatch, and only part of a
buffer gets sent.  Assume:

* buf[1]->len = 128; buf[2]->len = 256
* sqe[1]->len = 128; sqe[2]->len = 256

If sqe1 runs first, it picks buff[1] and it's all good. But, if sqe[2]
runs first, sqe[1] picks buff[2], and the last half of buff[2] is
never sent.

While arguably the use-case of different-length sends is questionable,
it has already raised confusion with potential users of this
feature. Let's make the interface less tricky by forcing the length to
only come from the buffer ring entry itself.

Fixes: ac5f71a3d9d7 ("io_uring/net: add provided buffer support for IORING_OP_SEND")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
v2:
  - Disregard sr->len when selecting buffer in io_send()
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 51c41d771c50..cf43053a25b7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -423,6 +423,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
+	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
+		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -586,7 +588,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
-			.max_len = min_not_zero(sr->len, INT_MAX),
+			.max_len = INT_MAX,
 			.nr_iovs = 1,
 			.mode = KBUF_MODE_EXPAND,
 		};
-- 
2.44.0


