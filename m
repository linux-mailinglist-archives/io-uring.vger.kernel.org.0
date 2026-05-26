Return-Path: <io-uring+bounces-13505-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDLDMe/EFWqxawcAu9opvQ
	(envelope-from <io-uring+bounces-13505-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:06:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8743C5D94A4
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 566063036481
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 15:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A4B391834;
	Tue, 26 May 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="OaEzKCoY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535E38D3F9
	for <io-uring@vger.kernel.org>; Tue, 26 May 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779811115; cv=none; b=BT7t/ciM1vw8sacPZRlH0WFYFL+UhhS+kjNUiiwll8K13XN464jjGk+lbE/4lfIL3Wu/dWdL1omKkpTKCR6sxtq+vonGvQr+xUIvK59cbV+YiX97wZeevxcOkg7frnxK/z33i7hkBdCRy5wabYloZ3A3EUHaXcIa6NwsQI5iWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779811115; c=relaxed/simple;
	bh=luCcXwP82NKzZTQdXDuXXpas0iy8/T2cK1g8ZZZMa+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Be68b45byFLbn3GXlgmYrc4fM/weIePPAy+kvNPgeQSLmSXbhM/GK6EZmXDTP6hm0zSwWWz3lZJYlWaJZsUV8N+81ZyCFNA4rHgOlr2jII/7lDyN3aEeP2gChVEfhdsnPfF5sqw2pbRRtonw0/2OMY0ofznwWqH7bHFUWlykw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OaEzKCoY; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-485621336easo1447827b6e.2
        for <io-uring@vger.kernel.org>; Tue, 26 May 2026 08:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779811113; x=1780415913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBREw0EFwsoyVbz1ezFdLWJUb0tEhym45QW/V9DqyOc=;
        b=OaEzKCoYTjDFupGXgDqHvA60tQHvH8uhQAJf0FF3+yd8Lp09r59r6JN0ReiOo5Sg/H
         R03Js4qy31KLSLJsCFDOMwOuWryqT8e3gV1RpxO38tDzlwDne7YJ31V+eveOUM8kd8yy
         pvMFMygUkXBGF0/DjasxuUwyERKQXO0nFTZYOu8KPjchCzA90V3w5+XFG4NrCDxM0sOS
         iNJsXY5R+e1Gl3paQi49m9A9fWg7n+v+xW/81ORc8TQppKvYD6psMNykD5jY6VKjwJv/
         l7N/yyb1s2SXYcKLb0vKuTmtV4LnWCaaHg2WWM9yoILbupaZL7vzq4pzzmGjTZGJXxIy
         WNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779811113; x=1780415913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBREw0EFwsoyVbz1ezFdLWJUb0tEhym45QW/V9DqyOc=;
        b=A6sv/1cYqo0EMiLvN2krrIWCAHbgfL4dCL0o3/X4329naU1UUWKvoAwWG4K3H1rwQL
         Jd3VVjjieTt/Cj9zRvJrwZbYiXAZF16nThxyvO4mex1kbLp5VGLG0yevtGw/6RXCZaTm
         Y++hqnXVhsRg0NrFyFcW1+BPflNwamoaw5a+Zukl58EHF1LXs21GPPwzeuMXXVmI0xgb
         pfGY3S2EU78f42MpQrY5dfd7/rYI8mHtQb3urDvFVwMOoF+DYiThRbKfS0hdcgFEFgj0
         s2+xoW5TQrQoGa1ePbgO0iB8Z7n5DAYfOFDmFUOShrN5CAtFXP9f9WRa+U8E3lfbox9W
         y5Vg==
X-Forwarded-Encrypted: i=1; AFNElJ9O4eQyouDdnvorDKGQJB6PWc22ayJ93D/Aalw53hzQcE4q9uDDgK/rsw9ou9KCXa2jGnOUifm+TA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQlh2skOA1870Qz97QUa9nS1BXWpt+N0dFw2MlBMDMD2OBPICO
	PAI0nio5WDIaXv8F+uxHG+08ngXsQrnjihp2mvh3VyjPKTcj+Z+s9LSgRwIXWP/LLes=
X-Gm-Gg: Acq92OGueQNmt+ujhfx+B9fvhQ6avUVKZrx7A5aDFYKrA+gG8ZRFfyK4y2iVM6xfb+a
	MqKbXOy2WkaDX/nIZXq7OiQTRBlKyU8uT4sMDHQihqmCnBb6pzEMLWPbVly34z1nVnC6zAPEv8c
	/tyxARvJaGRpd4R7eNAeGC2ha+l8OqJkzMMFw6LFyDl2dJVcIjfUi62DHf6ubFxUUtt2MCyybtd
	6RdhTiGfhMzdIOm6Elw2S+gTyg0DIGbmoJMcG/jRjwv+uW4PbNJhEedblDC0rMLJvBE9v0zUQdJ
	jad/vPhGd2OREFCPWD/ALDtp3v4mtAyi+Xv0/bsvla4fCdmlwgVXRcDehs/cCW9dQfsSNaOLc0m
	y1FuaNJFeJWYvH4WOvFNNvKu2HENs0o3rJOSv7xqx0MGp+90bMO2rkg5ePHGGQ1iuE3nWIpn/eN
	HWuQHMuLCACD1Q5LmAcOhTI520LoyQGHaSXm9DsUZMDJ/8MutAk6mY1TSVvm+hNBDlhc7q/m7pr
	Qj+BralOsjIHskt9s8=
X-Received: by 2002:a05:6808:1a1c:b0:479:e96e:65aa with SMTP id 5614622812f47-4854a2ab967mr10906128b6e.42.1779811112545;
        Tue, 26 May 2026 08:58:32 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485544e320csm6341688b6e.5.2026.05.26.08.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 08:58:31 -0700 (PDT)
Message-ID: <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
Date: Tue, 26 May 2026 09:58:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
To: Christoph Hellwig <hch@infradead.org>, demiobenour@gmail.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
 <toke@toke.dk>, linux-api@vger.kernel.org
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
 <ahQCZQNoyO8GQt3H@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ahQCZQNoyO8GQt3H@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13505-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 8743C5D94A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/25/26 2:03 AM, Christoph Hellwig wrote:
> On Sat, May 23, 2026 at 03:43:02PM -0400, Demi Marie Obenour via B4 Relay wrote:
>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>
>> The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
>> It can be removed entirely at the cost of only supporting synchronous
>> operations.  This doesn't break userspace, which will silently block
>> (for a bounded amount of time) in io_submit instead of operating
>> asynchronously.
>>
>> This also makes struct msghdr smaller, helping every other caller of
>> sendmsg().
> 
> So we just had a discussion at LLC about how networking needs to support
> AIO better for zero copy.
> 
> The current TCP zerocopy implementation provides completion notification
> through the socket error code, which is freaking weird and doesn't
> integrate well with either io_uring or in-kernel callers.

We already have that via io_uring, and without needing msg_kiocb or the
(very) weird socket error code retrieving.

-- 
Jens Axboe

