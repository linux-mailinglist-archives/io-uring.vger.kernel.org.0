Return-Path: <io-uring+bounces-13166-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YE48JB308GnUbQEAu9opvQ
	(envelope-from <io-uring+bounces-13166-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 19:53:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 053EA48A3B8
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 19:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 87BF6305A4F1
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6864B4508E4;
	Tue, 28 Apr 2026 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DOBF/Xzo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3kkZsz8V";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DOBF/Xzo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3kkZsz8V"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F42745106F
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398797; cv=none; b=czzNB0g4h7uS4/ycj34QH2KXIk6gRRdqfDUY6tkdoQ3AQEp4uGtod94bVTha0ye/OKSl4jgRfsa13UpOpHE4DruGf22CSC06d7Sg57e93YtoMbwCxlo2WsFSiJijTUG+wFM5v0Vm+sgNfunjzRahWhRISIInSeH5lB34+NPTAz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398797; c=relaxed/simple;
	bh=eeFPn0M+w24/mqijYklGbQUNjB+65be9k1HfxTYLAj4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pJm1gIhpISm2HXH3EZvoaepSJty8KMKrlsTq3k+HDWaknPlwOLsV4W3AfRsT5V+aUJv1rNxgW1NyX/HjPE/hbGEtRm9iyIEtqqE7Pc2i+v0QkIwXNX4I+rF8lRyzmQHNshD/4iOPVgWfAF1Vvsq5eSkXjhOFyCeW9QVSO6AOilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DOBF/Xzo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3kkZsz8V; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DOBF/Xzo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3kkZsz8V; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EEBCC5BCE9;
	Tue, 28 Apr 2026 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777398793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3BhqwiahZQ6WzPwYjBbtqnM8IGngBp+MvpXddRz0B4=;
	b=DOBF/Xzotlfbyobb3hnxOx9bpGEGBD8COBy+WfVXU1W5savbkQI5Z2gkx8wcx66DgedUOV
	oX9cSs2ZMPB4xo2Y09oWkKI181GBBSfyk/tVDgZRbg7vfdkt8mkUYSrCfay5xZIl5vU75E
	27CNBCecsUkE44r/iKQJCoE7vHaYF9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777398793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3BhqwiahZQ6WzPwYjBbtqnM8IGngBp+MvpXddRz0B4=;
	b=3kkZsz8VwjzEBcgAEebMp37f5IKmYTF24lR0Xx7sQrh48efYMuP9qh4XIoPQXC3dxkBe3j
	sJtifG0uYAEboXCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DOBF/Xzo";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3kkZsz8V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777398793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3BhqwiahZQ6WzPwYjBbtqnM8IGngBp+MvpXddRz0B4=;
	b=DOBF/Xzotlfbyobb3hnxOx9bpGEGBD8COBy+WfVXU1W5savbkQI5Z2gkx8wcx66DgedUOV
	oX9cSs2ZMPB4xo2Y09oWkKI181GBBSfyk/tVDgZRbg7vfdkt8mkUYSrCfay5xZIl5vU75E
	27CNBCecsUkE44r/iKQJCoE7vHaYF9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777398793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3BhqwiahZQ6WzPwYjBbtqnM8IGngBp+MvpXddRz0B4=;
	b=3kkZsz8VwjzEBcgAEebMp37f5IKmYTF24lR0Xx7sQrh48efYMuP9qh4XIoPQXC3dxkBe3j
	sJtifG0uYAEboXCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DF24593B0;
	Tue, 28 Apr 2026 17:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LJ3XGgj08GmpdgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 28 Apr 2026 17:53:12 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  Martin Michaelis <code@mgjm.de>,
  stable@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/kbuf: support min length left for
 incremental buffers
In-Reply-To: <20260428154557.2150818-3-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 28 Apr 2026 09:44:50 -0600")
References: <20260428154557.2150818-1-axboe@kernel.dk>
	<20260428154557.2150818-3-axboe@kernel.dk>
Date: Tue, 28 Apr 2026 13:53:10 -0400
Message-ID: <87ik9bj7jt.fsf@mailhost.krisman.be>
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
X-Rspamd-Queue-Id: 053EA48A3B8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13166-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mgjm.de:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mailhost.krisman.be:mid,suse.de:dkim]

Jens Axboe <axboe@kernel.dk> writes:

> From: Martin Michaelis <code@mgjm.de>
>
> Incrementally consumed buffer rings are generally fully consumed, but
> it's quite possible that the application has a minimum size it needs to
> meet to avoid truncation. Currently that minimum limit is 1 byte, but
> this should be a setting that is the hands of the application. For
> recvmsg multishot, a prime use case for incrementally consumed buffers,
> the application may get spurious -EFAULT returned at the end of an
> incrementally consumed buffer, as less space is available than the
> headers need.
>
> Grab a u32 field in struct io_uring_buf_reg, which the application can
> use to inform the kernel of the minimum size that should be available
> in an incrementally consumed buffer. If less than that is available,
> the current buffer is fully processed and the next one will be picked.
>
> Cc: stable@vger.kernel.org
> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
> Link: https://github.com/axboe/liburing/issues/1433
> Signed-off-by: Martin Michaelis <code@mgjm.de>
> [axboe: write commit message, change io_buffer_list member name]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring.h | 3 ++-
>  io_uring/kbuf.c               | 8 +++++++-
>  io_uring/kbuf.h               | 7 +++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 17ac1b785440..909fb7aea638 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -905,7 +905,8 @@ struct io_uring_buf_reg {
>  	__u32	ring_entries;
>  	__u16	bgid;
>  	__u16	flags;
> -	__u64	resv[3];
> +	__u32	min_left;
> +	__u32	resv[5];

Honest question, isn't this a property of the specific operation and/or
fd being operated, instead of the buffer_reg?

>  };
>  
>  /* argument for IORING_REGISTER_PBUF_STATUS */
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 43e4f8615fe8..63061aa1cab9 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  		this_len = min_t(u32, len, buf_len);
>  		buf_len -= this_len;
>  		/* Stop looping for invalid buffer length of 0 */
> -		if (buf_len || !this_len) {
> +		if (buf_len > bl->min_left_sub_one || !this_len) {

Cosmetic, but perhaps store min_left_sub_one instead of min_left itself? the
buf_len must be >= min_left, and that is easier to read.  (buf_len &&
buf_len >= min_left || !this_len)

>  			WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
>  			WRITE_ONCE(buf->len, buf_len);
>  			return false;
> @@ -637,6 +637,10 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>  	if (reg.ring_entries >= 65536)
>  		return -EINVAL;
>  
> +	/* minimum left byte count is a property of incremental buffers */
> +	if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
> +		return -EINVAL;
> +
>  	bl = io_buffer_get_list(ctx, reg.bgid);
>  	if (bl) {
>  		/* if mapped buffer ring OR classic exists, don't allow */
> @@ -683,6 +687,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>  	bl->mask = reg.ring_entries - 1;
>  	bl->flags |= IOBL_BUF_RING;
>  	bl->buf_ring = br;
> +	if (reg.min_left)
> +		bl->min_left_sub_one = reg.min_left - 1;
>  	if (reg.flags & IOU_PBUF_RING_INC)
>  		bl->flags |= IOBL_INC;
>  	ret = io_buffer_add_list(ctx, bl, reg.bgid);
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index abf7052b556e..401773e1ef80 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -32,6 +32,13 @@ struct io_buffer_list {
>  
>  	__u16 flags;
>  
> +	/*
> +	 * minimum required amount to be left to reuse an incrementally
> +	 * consumed buffer. If less than this is left at consumption time,
> +	 * buffer is done and head is incremented to the next buffer.
> +	 */
> +	__u32 min_left_sub_one;
> +
>  	struct io_mapped_region region;
>  };

-- 
Gabriel Krisman Bertazi

