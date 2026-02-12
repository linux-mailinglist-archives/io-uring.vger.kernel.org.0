Return-Path: <io-uring+bounces-12181-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJsfH3zBjWlt6gAAu9opvQ
	(envelope-from <io-uring+bounces-12181-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 13:03:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 697B812D3EF
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 13:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A455830093A4
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 12:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB12234AAF9;
	Thu, 12 Feb 2026 12:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mCIj9T1M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609B31A04E
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897782; cv=none; b=W8+ZU7xkskfaJy510CCkyYx0ys7cA5M7Aac+AUKKv5sH5otQG/4pvQcO2OQPGQP7RH5b4xlqWuJ4D1x/1sXGL8+mDcSNJNgbxppICFDvYr2IrvuHqCFKJhBH5JA6yjXxsvnmcmLRifOv+kX0DjnfXJGWZ+QghwploOcprE/hphE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897782; c=relaxed/simple;
	bh=etPO5rAF/iZNTMhRsXxVZC5DQsNDTwpHKQZKVhoz2Wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koyduMYGRCSpEDtIN9s7wlRYxK0TvNd178NiEzPtkjMpuUEr40e+S1zP6JsipxR52MMyi1cUVcCBpQlsiqpvj6Zwf2mReGj9aXKaOWnPUXmhwmvBVGNcCLW3KFoUbjyYDFLo+G5DpGJPgOopMm3MlKNjUKfXDVogBy0Atyn0W7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mCIj9T1M; arc=none smtp.client-ip=209.85.160.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-409521ba360so1879757fac.2
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 04:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770897779; x=1771502579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9yZyoI1MedJ91neH42mRt3C3fl0JTlkoE+1s2Qiphs=;
        b=mCIj9T1MOQwCITwMODWOhTMeIAmufBplHFyzCwKBFuGzjC3qINMzRPEoXzPabvNpsI
         YCqcWZqQtazzIPJfGp6oWTDjbRMTxDfKCy9g9xtyB70zzYdqIqROsRRLr+4dMoH1Scpw
         bciNH24F9mE6tdvYK5vPJpz2rIMVyzEIdOFcwhaCjJGmoVtNdMAaIiCi/nREpSGbxUGI
         RBET0mtWZleDKbfo09hVwL8u3u42KHNFpFEcX4NBkQY2nx1ncaEIiwezIobLn14EDy70
         30ACF9LiYik9Ggm7hOoRmmilYhkjbBxEVdTI8RAP/95jJn/5x9jE13WXNCryDWgbhRjz
         silg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770897779; x=1771502579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9yZyoI1MedJ91neH42mRt3C3fl0JTlkoE+1s2Qiphs=;
        b=dayuDuSgcNp0RV+BP9BtA6yLKp8iEQAbRO8VWTXaztbpbnRrJrSNmA4NHJ/1473A0B
         fWWA4FKxTmLZNjaJLgG+hXZ/yXQZdKuSqWNg/eKOnMlqCsHzdjRbcP8ThlmkfXkarNXd
         7lJWp695x3Q0ZAIw5FgUT7PoxHIv/LksFGH08NgM7SF0vL3b/OTA6e6AApo6gwYB6l1i
         uE+lkxXKpf+fNyBfpNToneei8YMrhJVdiSPy8FyJpyuQ4EgD26in94omj/p3yfs8e0sE
         a+0Bdbl32SwOOlwOfe5/tvUXxAyNnkwGZEfOW0FBZz22PgWl/8F57zeldVry9Yz+Y8I/
         SMqA==
X-Gm-Message-State: AOJu0YxZd/1oPdb0nLCUCxxoXB4/asi/H47tgbTvZauyAoAWnhtMd1t1
	pWpxYh4UbhXH130EDyJS0K6i/D1fxbdgnCqzMxNVmiL6hUIPo0QfFpVJcnHx2UVzx1s=
X-Gm-Gg: AZuq6aLlRE5hZ1VkwT7OZRU57S9W+rvtGUtbAGBadeXgJRwXuE0ag0OMCmbkTQQzMwo
	Puj9G11ysqrxmG+3aFPAQjhqQWRBSZBrc/VFUw5WN3jikXFS3Zw5kWNin3Twhsx6fqV5Z8AQ976
	ncwNZQgwvHuo5vq1Fo/whaEWLhiyB2VQZLoKwa5WHl9cphA8Pz6v2IF15KEl8fA8WhooivMQCQo
	kRFESHbqvA9HPllDrLfRAoPMM0qUnffOsbT/SBP+LDang1w0bKFsSrcWhOVjK6EoBNCDF3ZqmAh
	cyAEGuORMNcwYo3mo7xRS/d87kULPRBKzc0kcGO4scaS4jYfpzAAaDDVlmQT4r3vTG13s+J5llG
	HiwGZcdYQeBYuRQu2X/n1UZfDv4BIIy2UTjOWkFfqcqLD+39XIWcliRvSU4UnQcC/ixRDKid5U0
	b+6tvLiVlHXPnyC0MG9Tvj6EeNHfld9QueExXvwcr7GwFDdQHVqvsmvOt1IcXLlb6d5+xcx6Zui
	mA/pJRQhg==
X-Received: by 2002:a05:687c:409b:b0:3e8:44ec:3416 with SMTP id 586e51a60fabf-40eca29f54dmr1061066fac.46.1770897778961;
        Thu, 12 Feb 2026 04:02:58 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf103ac3sm3493170fac.11.2026.02.12.04.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 04:02:58 -0800 (PST)
Message-ID: <ddb783d5-f69d-45da-ae76-96578ababe03@kernel.dk>
Date: Thu, 12 Feb 2026 05:02:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix list corruption race in io_pollfree_wake()
To: Soham Kute <officialsohamkute@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
References: <20260212115458.9149-1-officialsohamkute@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260212115458.9149-1-officialsohamkute@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12181-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,ab12f0c08dd7ab8d057c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,appspotmail.com:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 697B812D3EF
X-Rspamd-Action: no action

On 2/12/26 4:54 AM, Soham Kute wrote:
> io_pollfree_wake() removes the poll wait entry without holding
> the waitqueue head lock. Other removal paths take the head lock,
> so this can race and lead to list corruption detected by list_debug.
> 
> Acquire the waitqueue lock before calling io_poll_remove_waitq(),
> matching the locking used in io_poll_remove_entry().
> 
> Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
> Signed-off-by: Soham Kute <officialsohamkute@gmail.com>
> ---
>  io_uring/poll.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index aac4b3b88..006154355 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -383,10 +383,17 @@ static void io_poll_cancel_req(struct io_kiocb *req)
>  
>  static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
>  {
> +	struct wait_queue_head *head;
>  	io_poll_mark_cancelled(req);
>  	/* we have to kick tw in case it's not already */
>  	io_poll_execute(req, 0);
> -	io_poll_remove_waitq(poll);
> +	/* Pairs with smp_store_release() in io_poll_remove_waitq() */
> +	head = smp_load_acquire(&poll->head);
> +	if (head) {
> +		spin_lock_irq(&head->lock);
> +		io_poll_remove_waitq(poll);
> +		spin_unlock_irq(&head->lock);
> +	}
>  	return 1;
>  }

The callpath is io_poll_wake() -> io_pollfree_wake(), where the former
where much holds &head->lock already. How did you come to this
conclusion? Your patch would instantly deadlock.

Additionally, if you follow the replies off your syzbot link:

Closes: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c

you'll see I already debugged this issue, it's a media bug, and there's
no POLLFREE involved at all. And it looks like I'm not even the first
one to debug it, I subsequently found that someone else sent in a
different patch for this last year, but solving the same root cause in
media.

-- 
Jens Axboe

