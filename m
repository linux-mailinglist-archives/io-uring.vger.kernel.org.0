Return-Path: <io-uring+bounces-13550-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNO5KLJ1GGo8kQgAu9opvQ
	(envelope-from <io-uring+bounces-13550-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:04:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C49B5F560F
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 19:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A6262306623A
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 16:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1693F8899;
	Thu, 28 May 2026 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="axxvXFIh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF883F4DC5
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987371; cv=none; b=mB1EijSkHW2pxz8JA03aTdfEQ8WvLWnmPhR7dzpjolCNlAaPpaSNQKo83nnN1BXUVHDH3z01Z7FvS3lm4aKkHuov1USrwoQjNZ7jcjP2tsP2Thw32i3RaD2eP50HgZOn/PD1WSPVTmxMX+7dQ5Yls9YuvsXgVh7q7VhNSW+xwJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987371; c=relaxed/simple;
	bh=dRm6v9rJ98fryRZu+nDZ52gP6ZF+I/symBIWFqheIec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RX5lJs/+93ruxY1NIIpV2/jfs8CzjTWvdZbI8nfxAlqtEzi+a2TatPVyuZAz1sDbtwSUdkQazjDCoR9zj5uuyWYD3uPX4pZV+R/O858Jt/ei7KUpw4ZD6ydUPFPISitwcDUo0+BuGXB2xTqudNfc9Bic7ztPSb/GEM98qEwoX5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=axxvXFIh; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69d97689903so3848890eaf.0
        for <io-uring@vger.kernel.org>; Thu, 28 May 2026 09:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779987369; x=1780592169; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WDGJeqE4tTfg/YKUkoTVnPS7Lm5TeqY7Toc0BSTB4Ms=;
        b=axxvXFIhScPMwL1SYv1SB/8Twa6Qjpy4MHe4/Zy7f+oNlk8eF6vcpwSjMxUCgkdaZk
         H2r4dgPHHu3jnBszJQpKbqLgekX8xr5tOZIcZbJbYQQIZ8ojEJRLFWpfSn02Vdt590Lj
         +JdTIeluvDz8KhKs9IORim7N+sgGXktxRB1C70gXOxClZT7XoGhKqYzsUg9V7gQMK4UQ
         QlnyMKWM+ISgiaifbHgBHXkboi3nHAgNX4VdKx0gQ4c9QFzxb5Lc246wAjsS2DSZdHMs
         J0fMheyMpMNKb9nzBIxJBG9v1ZmNg2RAwLMqUUokGc6eK8QKKzP0eW7ObVslwpDeP5lb
         H+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779987369; x=1780592169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDGJeqE4tTfg/YKUkoTVnPS7Lm5TeqY7Toc0BSTB4Ms=;
        b=l9KUQKzHW0dK+xZTUuhQ+f/Eem0tsHIYu0fbGk/VYUMXIhXasXWQj31jqcEr++Ui5E
         oMNF67GNOxFid8DsHDcb2ymHXS4rbyTJhBuonP/jvxOFAFE573RjXbLWlsNm9wKMrc7v
         kNEYaYQIrbRcGKYjU3ci9nC9x9sQWMiYLEZMx0XumkUKavmizmKDDjt1qnyTPDRqX4pI
         3jyFLiBvylVbuOGmSHIukjjVsHIVKG2Ve3d3vjR2wyk27zaPPb1d5mTUHqlAOnk6LIPx
         FkkE0xYV7KQ5YyOnFOI7LGns2nItCde6VhHcX9G5dqHn6+hL4iO6uRcB6IwWPjibucrO
         uOhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/QXwMkxAF88lKLFcQNzY8YtGHkBIWRFUrlPkPgjGquitnE4snc2iwSZSuhCcqRE+XVdNQt69ZPfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyUsqqchdwk7uTyqtdZXWz5UvbiidVYBKC3c8LvYC/ZsMJsmYt
	i76Jl3iwWU1YCuZjG14+kvrZH7nRaKzrRyWT5DWBaataSrx9ZPgRaowXx9YYy4LXyuc=
X-Gm-Gg: Acq92OHcb9ZcMl28qpP/jH6+/40+GfUtNERNPAKDp7LnmYF9hqccRTz2G4vfkc2z3xn
	qAQc9qYLV2byG4ol4MMZDAGhIhmzQnivT0YWIj1MiHx/J+Fp37qdoNnndPcSe+Gy2qijMScULUd
	0lGu5Uhsk4XcKgCdJsfXHMWllfk48AeyBirMxJMzIs4VS+/ZECHFWBmAW+MbcjW9bz/8ABY6iiL
	+hjja6kMBohRW6Mw7fY+Sbi3o7EPd1fLpJoLCdayZm76JyYfnKX6VOpjXszbq10e9NOnlS0qoC9
	oOKACpy/2mjVXUDzjb+qRBC6Kh7mi6X7x84b8SnYyQ8ygZSTql48a3iojFGtfA2kldW5XFiIGuV
	8zq1usovslfrKa+yX4rXt8k1u6OUTBJKY891hJrPWvuIRo91L0nNOW82zdfuhHHR+Wk9zjmq322
	CRJN0yzp4edHUzDCBcRr858owvfXG21d95hwX2A0hSrKUJVZuO7HJ0ruNKZFNrhmYYbsjA4T7jk
	a25InL6g7llfpsS92w=
X-Received: by 2002:a05:6820:4c07:b0:69b:5fcb:1a69 with SMTP id 006d021491bc7-69d7ed105b6mr14873551eaf.59.1779987369074;
        Thu, 28 May 2026 09:56:09 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e010cd4casm152656eaf.7.2026.05.28.09.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 09:56:08 -0700 (PDT)
Message-ID: <2cfd6455-7b5b-4974-b8a1-4a0abca69768@kernel.dk>
Date: Thu, 28 May 2026 10:56:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
To: Christoph Hellwig <hch@infradead.org>
Cc: demiobenour@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org, =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?=
 <toke@toke.dk>, linux-api@vger.kernel.org,
 David Howells <dhowells@redhat.com>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
 <ahQCZQNoyO8GQt3H@infradead.org>
 <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
 <ahanjVfIDlCmeCUE@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ahanjVfIDlCmeCUE@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,gondor.apana.org.au,davemloft.net,google.com,redhat.com,kernel.org,infradead.org,arm.com,linux.intel.com,intel.com,linaro.org,lwn.net,linuxfoundation.org,vger.kernel.org,toke.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13550-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 6C49B5F560F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 2:13 AM, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 09:58:27AM -0600, Jens Axboe wrote:
>>> The current TCP zerocopy implementation provides completion notification
>>> through the socket error code, which is freaking weird and doesn't
>>> integrate well with either io_uring or in-kernel callers.
>>
>> We already have that via io_uring
> 
> Where?  And how do make that available to in-kernel users like
> storage protocols and network file system, which really suffer from
> the current MSG_SPLICE_PAGES semantics.

For zero copy, on both the receive and send side. Since we have a proper
notification channel, that's what we use rather than the hack that is
the error queue.

>> , and without needing msg_kiocb or the
> 
> What do you think is the downside of using a kiocb here like for
> everything else with async notifications?

Where would the notifications go? You'd end up inventing something new
to propagate them to userspace then. The io_uring side does not rely on
using msg_kiocb, and iirc that part was only ever used for the crypto
stuff and largely broken. Which is why I do agree with just yanking it
out.

-- 
Jens Axboe

