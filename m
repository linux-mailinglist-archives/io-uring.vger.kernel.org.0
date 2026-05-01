Return-Path: <io-uring+bounces-13201-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGbNEqAv9WlaJQIAu9opvQ
	(envelope-from <io-uring+bounces-13201-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:56:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D104B01FD
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F2C4A300F18C
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 22:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5908A37C112;
	Fri,  1 May 2026 22:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bNiUm6zU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC5737B02E
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 22:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777676182; cv=none; b=r7QKTttIH3/18onw2G8f3Nq+6jwi1ZSjoR24+YKONy09SN8bPnKDezMnJKlqbo3pHWifbMG5IT7TKRL8Jxy5YNRIJJEm0GF9RRbzP7aG1WPgwDdNxPM7vqK4GXEu1rm84NrXK736M6Iqtcmu5xGX2z7b8li2Hg6F27VD9ZwUjkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777676182; c=relaxed/simple;
	bh=Owr5h3gzlY/Xiqy7mXJ2kR/F19ZgaYQwIpoq3SHk7jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F16a03n3fM3kfdiBhFuOxsMEEH5BFPjIbDnkx46cLd8Aaxc1RYTHvi4+xNg5wjhvX5gTTfeWrrZd/4RfAYahyr9pVTfdjaveHt5QduhaWEYOFSIt74iPH02S64y6F/C5aAKUaxWPBz9fc7dRdBti/vffSSUAXzTdFAkzmQN0jis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bNiUm6zU; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-479dc6d26e3so1404897b6e.0
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 15:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777676180; x=1778280980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Me/g3PMG3J7omC4T2W3PlajfSg9iKUkl73mok83FKA4=;
        b=bNiUm6zUENQ9yA0NmV31fpqNXsFLqkdVPUlaSq5EUZ7KsWLD+4+OFoaQr3F3Hlo/fu
         9HCFlHDhaNuKfFKtyFv2izAvmx2SlZV09MBY1mTTyMK8upLCET++PNiUTt5eUZihsK2Y
         KOIxfrETzrZhRlw48ziAQbdIsgMT9OP0pV2CY1qv4ALnGh2DORm/h7ujuNMBvjH4bQpv
         Gm0vUH6VpZIHNYVU0quOiAO80+m4Jn71JunTC1cvM7QTG9D0O6Y2JQQOKTk/6kpBVYO5
         j2AUwrOBAMcdEQAXfQem1zLkwf2U/Fo7QRHlXzR3Xk9CyaoH3RBaap/4jWPZ24hugsNL
         G62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777676180; x=1778280980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me/g3PMG3J7omC4T2W3PlajfSg9iKUkl73mok83FKA4=;
        b=SuFT8UC0xM0JVj8ZKZ8AGaIaPzh6/n6am5hwqcM2oFJz9nL5lmVq0P4QnHbY5VP5ic
         zemCAWixsX1ECYqiiYcP7tY2IJbTDbOq2q7xfLMirSDtyZbdciS9jJCbc6RzDol/Bfql
         8SlasmDghszJrxyvZt9byOQPo9uxvtT0BBo3s+CwrMX5psm8/XxTRZGZkjncus5Dyz+5
         gsOgDa1AvQZ7hKXM5F6MkHciNLMjLQClAT5yYF1uQCHBIf5+t4mx9GzDk7CuqiSy8ePO
         18xHtkzqBNRFnRnpi3U9O0Mw0S7r2a4GgPkgG47lV4fx9sp643/j1Y2HrxG+V2dEsSCQ
         BOiA==
X-Forwarded-Encrypted: i=1; AFNElJ8EQU44WfiAboulR0s7HuQbe+mq+nqCmdFPjjBTCHGdGTQMMBCvelFqMcJ/hErQbQL/+QJ6bBFv9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2A8tfcnW+ul4qB3HJ0gC7+tONKexzccg7GEL7bG3Tqgt2ooH2
	2cEtSWudGzywBUXEnlbmMSUGG30YtYEyepVUyaGye350bVtno9tshAVGUsNkErR1dTM=
X-Gm-Gg: AeBDiesYIO7MkMxPFKsizANsNNarkGVODkcjPo7tOujLMOoRzgakFuxiGrsJqi1UuNd
	B6H2ChdZibB+SHAgH2BvoZ9yHfE5Q7j3C5k0AeHDIdQdaUZdIuaOwk/b3pSe5gOmoRKQUGH0GrB
	bGB9bjZGGCU67kmKy0Z65sn7dswtB/q0G1wFQKFSYVEUaFmuTNu+pAJ2wLeF3FcpHpcJmTQl39z
	XktzewoLYiS6+pucfys/fIJhs3wHEASbNNdUQkavfjn2xSEcXk5zQ+kXByA3AJ+DSjCrMu1So8h
	u5cUmeZSEtvQzL8329JfDk9D09Ej4DGAZ6lNJKdtrNQDT3GT5YaK29o8ETlMN9JL3LUoMsfS/s1
	uX8YPnAM28N3vvI5whJ8oGQhl9hXtOVE/Y30Yx3ihQE93x5jKpQYYNaR5sW7oVjbwJhlSXzm9aH
	i1/UXAZ4Mu1c+hoNaTOt5O/hvS4JwErKV9hgFl3XA15+N8cItuStyICAntFGfqFNNJ6L0itS0Gd
	pJm17j0cnjU8OZzgdIvc3J8u7xaY24=
X-Received: by 2002:a05:6808:1787:b0:467:2a6e:adb3 with SMTP id 5614622812f47-47c892314ddmr754162b6e.23.1777676179890;
        Fri, 01 May 2026 15:56:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c763b2ef3sm2178246b6e.2.2026.05.01.15.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 15:56:19 -0700 (PDT)
Message-ID: <3f1b30e7-d6a4-4e77-a05c-6d041f93824e@kernel.dk>
Date: Fri, 1 May 2026 16:56:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable] io_uring/poll: ensure EPOLL_ONESHOT is propagated
 for EPOLL_URING_WAKE
To: Kai Aizen <kai.aizen.dev@gmail.com>, stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, io-uring@vger.kernel.org
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
 <20260501225250.90152-4-kai.aizen.dev@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260501225250.90152-4-kai.aizen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B4D104B01FD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13201-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On 5/1/26 4:51 PM, Kai Aizen wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit 1967f0b1cafdde37aa9e08e6021c14bcc484b7a5 ]
> 
> Commit aacf2f9f382c ("io_uring: fix req->apoll_events") addressed
> synchronization issues between poll->events and req->apoll_events.
> However, a subsequent commit failed to maintain this consistency in the
> EPOLL_URING_WAKE code path.
> 
> The patch ensures that when EPOLLONESHOT is set during regular
> EPOLL_URING_WAKE handling, it's applied to both poll->events and
> req->apoll_events. This prevents a condition where "IORING_CQE_F_MORE
> is set in the previous CQE, while no more CQEs will be generated for
> this request."
> 
> Backport notes:
>   This patch applies cleanly and identically to linux-6.18.y,
>   linux-6.12.y, linux-6.6.y, and linux-6.1.y.  The io_poll_wake()
>   EPOLL_URING_WAKE branch is byte-identical to the upstream pre-patch
>   state across all four trees.

OK with me, thanks.

-- 
Jens Axboe


