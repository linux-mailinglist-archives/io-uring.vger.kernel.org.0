Return-Path: <io-uring+bounces-13098-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJC/CLGw52lZ/QEAu9opvQ
	(envelope-from <io-uring+bounces-13098-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:15:29 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A8A43DCDC
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98ED9308F759
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10761386561;
	Tue, 21 Apr 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OTFwGjaL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xwumNsgd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wYYdW55B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rpZ493o6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B173733F8B4
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791490; cv=none; b=J1sVoMg/v2644bZHWcOXUvWj/yV+cTUprURkBfa4M0ueGtF2fJ1Xbs04i13vQvd40Li394OlVSdmcY6nF3jGBjsvdm4IfcMSD6HAj6ry4fDsjgboP84VmobJZ5HpLlNtIgiQstS8xa+xWlXlo7r2+M3uI9VZ/qeMxUHB9b93Oco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791490; c=relaxed/simple;
	bh=iMvl7nfiOerLbss/ucpr5oj+t3g6dq+P95rjFwJhPGA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HaQOW1uN/0J3pmSSx8I+hQ/Q9iNXKsmghxl12bl2kj1VSgTPfNCXK0G+EheLAqDyTH07tjy74wfbBBy0DaQm0sU2MK2A3oQIYitBe1NAHipMfqN7M7+t1+98qrUyKQJY01lMP8Jrs0EZOFsrrxXenyloiintGFRQpMqwgQWkjS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OTFwGjaL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xwumNsgd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wYYdW55B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rpZ493o6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 186706A80E;
	Tue, 21 Apr 2026 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzQ0HpvKzE+qJEZMDUyKs7Bq7qGgxjeoNdn3dVumyPM=;
	b=OTFwGjaLyYAKCb4TSPh/7jAhzbjQ58gHF6Hlh4W7tKWlNq+rmAKcwEvHpR7Jl8QPnBuyoA
	48+4HD6K3dHY+9AXRnkQ7CNynMQIr7213ETP7CjacoDzWFzYmdmWBVCS7c+oO3iB7Xe6tx
	zH5v5hnjZu2x3G7b2lD5oRXiWI6xWik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzQ0HpvKzE+qJEZMDUyKs7Bq7qGgxjeoNdn3dVumyPM=;
	b=xwumNsgdtrbFACdauLlD9rar+J7yJgH+RnLxMER+8KAEKfmxMLyrJyHUTs2D6qMbJfsTBN
	F2zxtxKJ1vRsvTAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wYYdW55B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rpZ493o6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776791486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzQ0HpvKzE+qJEZMDUyKs7Bq7qGgxjeoNdn3dVumyPM=;
	b=wYYdW55BWo60SrNEYcWP398mnDcLSMeeQlO3u9Rg0i4RkTc6asfkOgGS290m1Bl8h2UA3O
	jGtKwuyv7ZqVUIxbQMbuN8y3HZRtBBcv+DV/j3+VyAqwIZF0mgYCgdrAUO1xyupv7Ifhva
	3EHQ+6wi6/28xKq7mGvB/f8WUYKG5AE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776791486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzQ0HpvKzE+qJEZMDUyKs7Bq7qGgxjeoNdn3dVumyPM=;
	b=rpZ493o6uWUFWBZ+yqzXXJPm8Y1eL5XienteFfWmCs5sDLaLm9ahcW5FlNnWEeKMwASGHB
	vSpRT6KbT6BaUKCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDDEE593AF;
	Tue, 21 Apr 2026 17:11:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JbUcK72v52n3aAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 21 Apr 2026 17:11:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 5/6] io_uring/futex: ensure partial wakes are
 appropriately dequeued
In-Reply-To: <20260421135626.581917-6-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 21 Apr 2026 07:51:42 -0600")
References: <20260421135626.581917-1-axboe@kernel.dk>
	<20260421135626.581917-6-axboe@kernel.dk>
Date: Tue, 21 Apr 2026 13:11:24 -0400
Message-ID: <87y0igp7b7.fsf@mailhost.krisman.be>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13098-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:dkim,suse.de:email,mailhost.krisman.be:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 89A8A43DCDC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Jens Axboe <axboe@kernel.dk> writes:

> If a FUTEX_WAITV vectored operation is only partially woken, we
> should call __futex_wake_mark() on the queue to account for that.
> If not, then a later wakeup will wake the same entry, rather than
> the next one in line.
>
> Fixes: 8f350194d5cfd ("io_uring: add support for vectored futex waits")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

> ---
>  io_uring/futex.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/futex.c b/io_uring/futex.c
> index fd503c24b428..9cc1788ef4c6 100644
> --- a/io_uring/futex.c
> +++ b/io_uring/futex.c
> @@ -159,8 +159,10 @@ static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
>  	struct io_kiocb *req = q->wake_data;
>  	struct io_futexv_data *ifd = req->async_data;
>  
> -	if (!io_futexv_claim(ifd))
> +	if (!io_futexv_claim(ifd)) {
> +		__futex_wake_mark(q);
>  		return;
> +	}
>  	if (unlikely(!__futex_wake_mark(q)))
>  		return;

-- 
Gabriel Krisman Bertazi

