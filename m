Return-Path: <io-uring+bounces-11881-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CZoFHibcWmdKAAAu9opvQ
	(envelope-from <io-uring+bounces-11881-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 04:37:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B8B61614
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 04:37:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 489D84E2CE7
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 03:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0B23C00B6;
	Thu, 22 Jan 2026 03:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DZNmWiSb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D7378D8B
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769053037; cv=none; b=gDjeyw57sC6sq+eUthBeK1qQB29AYVRl3TDU/5xR9TB9f4RoWnB6bspgq5CjFWNz0Ezpu9495XFhGIfP+zLY+Tf7Au6TYkWF3TVyqveng5v4UxdVeAbHMwFHr/oFzbldyCvnkhrJ/3z+l1eSjnRKAGRDdvUdNvm4vGn/4CvEAXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769053037; c=relaxed/simple;
	bh=lXoh4xLa1KRQBdExhVIyA/7UaZAWFHPqQizcvAZoslk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UI9HRUjU4aHdPV0OLC8pwcH/fNkSFXw9co5+HenqrUt9htX7fhd+wsl+fFlsu8F0WCAWb4qSZrW86oj7Av8K1OHYHUITPrAi+sEMu/HAi8QDScTbg1+Ie90itY7mtpqIM2+pGbORRmRwJz3fE7/6y1Lbapg/USS34xQR/nOAYL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DZNmWiSb; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45c715116dbso348315b6e.3
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 19:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769053032; x=1769657832; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3oedXwopOgRiJOatSpWdTz0ALukMX1bRjvRnCCv/8QY=;
        b=DZNmWiSb5l+fEHIi85rl+uHB/4X7d3SNo1wgfC4R8nKAa7OP+eBFd/NsCLxgNDoz+T
         RFFJ+EfTjNcDfAFn//1aO6LX+dOBH4fpDSNDqDGqYWC5HAenbfgE35dxP3oom6pIbTXX
         BLjIgfDHa3OEOcGSYb3N9ch8X+d5i3JXRtGq2kZKF4NesQnLFRF3Q5/IAED8ryFATCXN
         7TpflccSMMNHcYybggeBI0rCR7C56VN/ups3bKBbk8ChjOCWZToP3MIQKF+N67gOeK6X
         7lhqVg514IqJhkg6saybBuETBTFiuQ1fxAIeU1OsrlyPqFLD6gjQNegQrhS5PeecIu12
         CU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769053032; x=1769657832;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oedXwopOgRiJOatSpWdTz0ALukMX1bRjvRnCCv/8QY=;
        b=IB9Fk7ONfQWZDdIoXdo8ZvC6P9uHyu9V6hPQjqgeuNNjbiA9iMw05yqQk84+xB2D+R
         bO/ILqrUKOFELl34fHr6LVzizZUnKP+6zT7+aoM74TpgWjVVngyLp2nxT9qor3yWPPev
         LLW5AAgPgop7Jm/3LNNI8EEHUQOOR6/3WzjugrBvjrPRXWDZMLTRgM7cMj0Byd2xX6bF
         QMR2eJ4V50JYH0dGZv5UG9v4RgNTYEEyAcE72z0AOuwDBgJUCXVXz1PgYOcoiDYCRFV0
         QlQViYMgAoXoLSOQ5252m6CxyCkh+q+H0VCYEgpTSxhAvBO26L+KIKB8txqkMHVW/Gyb
         29Jw==
X-Gm-Message-State: AOJu0Yw6XsSTD/G0yC3XV+rRFwDS4GkPA5NwXshhYLCY4VlXKfJUhpTJ
	fZS8Ozph2JnE3d7E4JSIUuiAguvWZgc7KrQjEw0fWyzZsDdGqwj1MOi6I98MqB/tLZv0+Vj7j9P
	YPGMzBmk=
X-Gm-Gg: AZuq6aJKwoi7BCQkVzrOH9aKUdlWy/fOTRsDwP9ZUK9AdxHzE8g92gCfwxXRiWQOZsR
	ut5V69tnF6BGCBLrT4TUemQBgki8ygPoEMoovthjEpOOmcuY3FcVTTozK5LJMHthQy2iEcXJFY/
	vXWqnvXd+Nu5zpD0TBPE0ae48p+2NohWxKpeKBkGl2iz7lOp3/dGcTRXl/HABT1cdR2WlUmt0gI
	N1gDOxz5NVy2i6GUWyALnjGC6NExx+wFyEigdKxbKSIQD/iejzVdb5lr6gVbmFx/iPd9oLDLAG1
	VtxW7j0Keg6NQtrgHb34vHr/WLLfeghwydEWbCp/rsn4rB2O0XWGCuRRKrdQVdK8pdRha9ytDCB
	BPrlLvLpERwBPyfCA8BQBtevRdaQs51imlbks9S6esGjAKZe4APfzaHwGDcRADnm0yIQFgT9w/j
	8UDjljyQPk4XchBqdQ2sHrVEJXJ+xz4yaNH7mf7PLs7yVCoSNo3ndE/Z94v8mmhVklY7MZXA==
X-Received: by 2002:a05:6808:3203:b0:45e:6cac:92c9 with SMTP id 5614622812f47-45e8a945c69mr3557632b6e.27.1769053032254;
        Wed, 21 Jan 2026 19:37:12 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044baf52f3sm12178657fac.2.2026.01.21.19.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 19:37:11 -0800 (PST)
Message-ID: <638f241a-6ffd-4827-b5a8-760550aea2a7@kernel.dk>
Date: Wed, 21 Jan 2026 20:37:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v6] Inherited restrictions and BPF filtering for
 io_uring
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org, jannh@google.com, kees@kernel.org,
 linux-kernel@vger.kernel.org
References: <20260119235456.1722452-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_FROM(0.00)[bounces-11881-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+]
X-Rspamd-Queue-Id: A8B8B61614
X-Rspamd-Action: no action

On 1/19/26 4:54 PM, Jens Axboe wrote:
> Hi,
> 
> Followup to v5 here:
> 
> https://lore.kernel.org/io-uring/20260118172328.1067592-1-axboe@kernel.dk/
> 
> Mostly just addressing a bit of feedback, feature wise this is all the
> same as before. For details on the patches, see the v5 posting linked
> above. For details on the changes, see the changes section below.
> 
> Kernel branch can be found here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions.3
> 
> and a liburing branch with support helpers, man page, and a fairly
> substantial test case can be found here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=bpf-restrictions
> 
> Feedback welcome!
> 
> Changes since v5:
> - Disallow setting or appending filters for no_new_privs, unless the
>   user is also CAP_SYS_ADMIN (Aleksa)
> - Add support for filtering of IORING_OP_OPENAT/OPENAT2, in terms of
>   being able to deny certain resolve or creation flags.
> - Change layout of io_uring_bpf_ctx slightly, for easier/faster clearing
>   of unused members.
> - Expand liburing test cases to cover both the no_new_privs situation,
>   and testing the OPENAT/OPENAT2 filters.
> 
>  include/linux/io_uring.h                 |  14 +-
>  include/linux/io_uring_types.h           |  13 +
>  include/linux/sched.h                    |   1 +
>  include/uapi/linux/io_uring.h            |  10 +
>  include/uapi/linux/io_uring/bpf_filter.h |  62 ++++
>  io_uring/Kconfig                         |   5 +
>  io_uring/Makefile                        |   1 +
>  io_uring/bpf_filter.c                    | 436 +++++++++++++++++++++++
>  io_uring/bpf_filter.h                    |  48 +++
>  io_uring/io_uring.c                      |  48 +++
>  io_uring/io_uring.h                      |   1 +
>  io_uring/net.c                           |   9 +
>  io_uring/net.h                           |   6 +
>  io_uring/openclose.c                     |   9 +
>  io_uring/openclose.h                     |   3 +
>  io_uring/register.c                      |  91 +++++
>  io_uring/tctx.c                          |  42 ++-
>  kernel/fork.c                            |   5 +
>  18 files changed, 794 insertions(+), 10 deletions(-)

Any comments on this one?

-- 
Jens Axboe


