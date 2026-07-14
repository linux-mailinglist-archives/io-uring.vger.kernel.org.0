Return-Path: <io-uring+bounces-14008-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id +dzcHRJ8VmpP7AAAu9opvQ
	(envelope-from <io-uring+bounces-14008-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 20:12:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE442757C32
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 20:12:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=sKj7+uCt;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14008-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14008-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D0F0F301DD92
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215103CF204;
	Tue, 14 Jul 2026 18:12:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386D3C8717
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 18:12:27 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052752; cv=none; b=Zx11QAzdiyI0NS0VY6l9P8QlCRI5hf1taQCMG2uEkkoKFrPBKnSeIXdxcpf4r4PAi0LCvbIluiu0mInSuWFZp/TB+lBsqQ50ktJMxw+aeONPjtk6QYIJyWB7aE5JGmk8HT4QBCGmPBcHyS886Y1qpMsESbpHEoA0nmkneaUcYUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052752; c=relaxed/simple;
	bh=OmzPNLP26tbGifMrCuq3Z6m3xkkZ1hxuLR3nZucJItw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9T+slypV7swkaUk1701VqGU1HCmmTpLC10ZREAJQZHyiUHyGWxuicCGjx0JlPMA0kBU65xUkiFAYbjK0HYI8kST8cIZgorPQSfKX0UVCAxKiK/GvIALk3KDibKZBskUrAY9Gdb6J1wodyWbAhJC89hhp+Dqidscpn4rNlARhzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sKj7+uCt; arc=none smtp.client-ip=209.85.210.41
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7ebd88be784so644050a34.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 11:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1784052746; x=1784657546; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3D2pM45k27nuy7ZPkAAwVvHStxmCG9QP15BT6xmTtZI=;
        b=sKj7+uCtARm+mXBaIddpIthPZclsHmaee2pT7NCRjjWcRJR4KH75zLIYHvprpJygrR
         8KZopcF8VJqZdZRp0xbbu0X8enw8+wHxs+kF/y2AQw8P0OEYqXY+B3FM3rF9OspbOAK/
         w6cOfH2GNXYlYGdYP+cFB/kfVOhKm52hWtAh1uZeLBBSu62ZNnFdHP0T4DjlVPX/ofDh
         b+V2ZsI/+9VlE3EwGoAGrGaaPF1zJM6Oma3ltzREPi7EfFkPtkj78qjq3aLEKY/n4gt/
         7NbibWCKFRWsNhHBmW4u2TfL/M8IrW5Bdsz2G+3kO+rU/Lxo1bO/rmXSePDbdGUYvOdd
         VIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784052746; x=1784657546;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3D2pM45k27nuy7ZPkAAwVvHStxmCG9QP15BT6xmTtZI=;
        b=jroZtBxdy8zoErNdU6j3requyIoG+dEOTypW7hFPmj29uxnvqLsQdPCf4huivcDywc
         ReSX54IjUfzRVUI4ABtyF75ASeosnyanRGTNVWmBJMRSNOM2gMzsaDzl97drp4fAvS9z
         wcN072DEj3a2vwDRH3QSCZOQyOG0cJIOxMVeeba9ZkJu98AQ0U/ZEGx7dYcy72vb2LRw
         R9re5OdTazDUaYvZJMZVE+dbrtdd2ncsT9quBx5ErZmdv1lXVTS+zbw99n0Du3e9ynbY
         c/p0LCoIRr0cZ2ih8iaqGDTw+lAB+Lwomh0HT830vFucdfSgVxRW2Kg45jHEoZ4je/J9
         XF9Q==
X-Forwarded-Encrypted: i=1; AFNElJ++Q75LwEj1NxcQ/PfMySHVPVVdxUfLAGrH/POmtYftPzSVBpZ4nVSOFsL2YykKjF9RdgnbwUPhHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YynsRfBjExZKhAl84xeN+I9jB/J7NUtjuixpm2ytd9irAAoZaZQ
	1Zwbqk9JXFW4PYJN9Xhx0MCwcaE6sOJi/3jKveeOMPzzwjcyqgoTiKciGuV9BckwsXJ2waIBxM9
	B+Kh0+OQ=
X-Gm-Gg: AfdE7ckhD4d9MPCp/LJwZgHPsfCMS0snqwYMsMoL+iLVIeSndKuOUILqVkRAYHGE4/B
	4OPUH7x44ZyDNl+ukGvaN13GouSum5/b0N8CPHJ0ue8zH9/d1Zu53GOjk9Cr5/ClzcByRyitt+u
	n+Jyakwk3Drqk2dAF+7ojIrW/njdKq+72UHRkOuP8sdQtwL121lrly8k+DpdSQKev1yDLYPFhak
	XWBNqWI89S6l2maYekW76qlvhJ0aMudtbwg915TuZd79y61lNBzy6IgsCh+uL+EbJlpskJQlbMb
	EozBVqRDe9fInzmqD6hAt8qDI4HmOuNMJpmywqSymAZex9ori4Vk+GhdY+7KOXG6dn0Ye6oI4hb
	7eFnmUN0PYuFU916h9oU/bz0HyZK6wTTVbghqHZCRVZPW3bY350sMTxfq6NErBiB6M3goM6SA8b
	U/67qVKVESOoflIcAzed+HJY9LgbsQfBVhBsXfqFV7uw5gXrMfA1Ow//15T84tWBEUzsCPOk0=
X-Received: by 2002:a05:6820:4d0b:b0:6a3:74fd:a877 with SMTP id 006d021491bc7-6a39a55e32bmr8326630eaf.11.1784052746524;
        Tue, 14 Jul 2026 11:12:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a36a5eee0fsm14728632eaf.5.2026.07.14.11.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 11:12:25 -0700 (PDT)
Message-ID: <8be1df21-f3e6-42ae-bf92-6694449cf527@kernel.dk>
Date: Tue, 14 Jul 2026 12:12:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] test/timeout-swallow: verify -ETIME is not
 swallowed
To: Prateek <kprateek283@gmail.com>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20260714165702.237136-1-kprateek283@gmail.com>
 <20260714165702.237136-2-kprateek283@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260714165702.237136-2-kprateek283@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14008-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:kprateek283@gmail.com,m:io-uring@vger.kernel.org,m:krisman@suse.de,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:from_mime,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,suse.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CE442757C32

On 7/14/26 10:57 AM, Prateek wrote:
> Signed-off-by: Prateek <kprateek283@gmail.com>
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
> Signed-off-by: Prateek <kprateek283@gmail.com>

Similar for both, don't add 2 signed-off-by lines.

> diff --git a/test/timeout-swallow.c b/test/timeout-swallow.c
> new file mode 100644
> index 00000000..d08365da
> --- /dev/null
> +++ b/test/timeout-swallow.c
> @@ -0,0 +1,117 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: tests that io_uring_wait_cqes() and variants do not swallow 
> + *              -ETIME when loop-fetching CQEs if some SQEs were submitted.
> + */
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <sys/time.h>
> +#include "liburing.h"
> +#include "helpers.h"
> +
> +/*
> + * Test the normal -ETIME swallow path.
> + */
> +static int test_timeout(struct io_uring *ring)
> +{
> +    struct io_uring_sqe *sqe;
> +    struct io_uring_cqe *cqe;
> +    struct __kernel_timespec long_ts = { .tv_sec = 10, .tv_nsec = 0 };
> +    struct __kernel_timespec zero_ts = { .tv_sec = 0, .tv_nsec = 0 };
> +    int ret;

Bad style in this file, all over. Tabs are tabs, not some random amount
of spaces. Follow the style of code around you rather than just use your
own. And watch for trailing whitespace, you have a that in
multiple spots.

> +    /* Long timeout, won't complete immediately */
> +    io_uring_prep_timeout(sqe, &long_ts, 1, 0);
> +    

Like the line below the prep here, trailing whitespace.

-- 
Jens Axboe

