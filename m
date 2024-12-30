Return-Path: <io-uring+bounces-5635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 642679FE8EB
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 17:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 302F51881F5D
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 16:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56A31A0BDB;
	Mon, 30 Dec 2024 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UAAWpUUr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WbDYMCTU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UAAWpUUr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WbDYMCTU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3719DFA2
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 16:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574943; cv=none; b=QDLr3cyThT/1wu0lOZ04vGaJ0o4QM15mY19LH9pVJXCBiQXJEQBm7xixYYDJqzy+v4i53qtVdkbl1cb6V+YLiI+3V11pGiNOoQ9ysxU7vVz9NToqTXhAB2MgdDGWIE6oND4sYINw48wpJoTWpg3exPKcV+TayLJZKYb75+Etk44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574943; c=relaxed/simple;
	bh=BG9uVi5Lr9LMQtZfAgXGsVh/NUT++6bLjjaA/lGQSSs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NFrZmnf6AwQgxaQgy1dK0x5LFTZV4gjGT7bpz5JQ/MTJZDefaxie5YFqZBcxz8Ory0LxXplaALvf41PbhMaCvzX1bqUSQFKscTKOo52J0uZ4/KKJZOUMpXoHN3E+M0DrW/kTG2nq1aBUYw8Bp+m55CHnHx1qlS28qZWVbrGgTm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UAAWpUUr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WbDYMCTU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UAAWpUUr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WbDYMCTU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8278B1F37C;
	Mon, 30 Dec 2024 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735574939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHy45/1or21zW0DsMVwqFJdbtR1DcRnLG09/E2BDmJI=;
	b=UAAWpUUrEc6CWnlYlbTsIoqBnkWxX45HGv+nSBLn+XR5BGGmeCyOD0XxvXGPumDSTcvTYa
	KqmT8x6CCvlx4VzaSA2t4dIKM6CyTljVjEFm5QGvRNRn8gK3B0fzekSuoz+3mLAEqduWJX
	j1ApRpFtYFJQdeHcbhczoInBWzTZ4m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735574939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHy45/1or21zW0DsMVwqFJdbtR1DcRnLG09/E2BDmJI=;
	b=WbDYMCTUW2nWcpDMw6CSqxoCa+0UKWltVS6zDLfF2h8/M0VmePdgTWcnhP+3AF8MKwd2PM
	Lm3NKp+d3UnQa/CQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735574939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHy45/1or21zW0DsMVwqFJdbtR1DcRnLG09/E2BDmJI=;
	b=UAAWpUUrEc6CWnlYlbTsIoqBnkWxX45HGv+nSBLn+XR5BGGmeCyOD0XxvXGPumDSTcvTYa
	KqmT8x6CCvlx4VzaSA2t4dIKM6CyTljVjEFm5QGvRNRn8gK3B0fzekSuoz+3mLAEqduWJX
	j1ApRpFtYFJQdeHcbhczoInBWzTZ4m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735574939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHy45/1or21zW0DsMVwqFJdbtR1DcRnLG09/E2BDmJI=;
	b=WbDYMCTUW2nWcpDMw6CSqxoCa+0UKWltVS6zDLfF2h8/M0VmePdgTWcnhP+3AF8MKwd2PM
	Lm3NKp+d3UnQa/CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A868F13A6C;
	Mon, 30 Dec 2024 16:08:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FVxRHprFcmdhMQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 30 Dec 2024 16:08:58 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: always clear ->bytes_done on io_async_rw
 setup
In-Reply-To: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk> (Jens Axboe's
	message of "Fri, 27 Dec 2024 09:53:43 -0700")
References: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk>
Date: Mon, 30 Dec 2024 11:08:56 -0500
Message-ID: <87wmfh6tlz.fsf@mailhost.krisman.be>
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
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> A previous commit mistakenly moved the clearing of the in-progress byte
> count into the section that's dependent on having a cached iovec or not,
> but it should be cleared for any IO. If not, then extra bytes may be
> added at IO completion time, causing potentially weird behavior like
> over-reporting the amount of IO done.

Hi Jens,

Sorry for the delay.  I went completely offline during the christmas
week.

Did this solve the sysbot report?  I'm failing to understand how it can
happen.  This could only be hit if the allocation returned a cached
object that doesn't have a free_iov, since any newly kmalloc'ed object
will have this field cleaned inside the io_rw_async_data_init callback.
But I don't understand where we can cache the rw object without having a
valid free_iov - it didn't seem possible to me before or now.

the iov is freed only by io_rw_iovec_free, which is called from

(1) io_rw_recycle, in the case where we don't cache.  we drop also
drop the CLEANUP flag, so we will just call kfree inside io_clean_op later.
(2) io_readv_writev_cleanup: where we also don't cache, since we are inside
    the io_clean_op, we'll just hit the kfree(req->async_data), and
(3) io_rw_cache_free:  where we are emptying the cache to shut down.

> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 75f70935ccf4..ca1b19d3d142 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -228,8 +228,8 @@ static int io_rw_alloc_async(struct io_kiocb *req)
>  		kasan_mempool_unpoison_object(rw->free_iovec,
>  					      rw->free_iov_nr * sizeof(struct iovec));
>  		req->flags |= REQ_F_NEED_CLEANUP;
> -		rw->bytes_done = 0;
>  	}
> +	rw->bytes_done = 0;
>  	return 0;
>  }

-- 
Gabriel Krisman Bertazi

