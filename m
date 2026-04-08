Return-Path: <io-uring+bounces-12981-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPYPG6Yb1mluBAgAu9opvQ
	(envelope-from <io-uring+bounces-12981-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 11:11:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0702C3B9A74
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 11:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFF1E301724A
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 09:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD57C3AF65D;
	Wed,  8 Apr 2026 09:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="feoWZSg5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7593AE6F5
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775639184; cv=none; b=kmLIpFe4Zanf+0YN2+q/kWSSwebKmEmJ6fOZJtQDn2//CU22b5T7ake7Hw68C3mFCXXv/6YqWOk2TEauqofMDEI+J8xsNJhxuz4Psxb8mHmfEd5RXG/ggyUNLjiwLUE8mmsTUuvvgKoXsxNSk2/nvUIbvrigvBAZBzOR04ydvfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775639184; c=relaxed/simple;
	bh=mdm06uitMSIygZ2FFukfM08Ps+ox3D4Zv39fmrbxrNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i+opw3/l7geoMwlYVUCwE4qNlwsvV0b7Q4axX8ER1f6+ncdkUMSMx2Hy6M4hKqbmXNB/WlvexbMxE+fp9j5c/tNUEhZWosEja3+L8McVHuHX3GxNtDtmg8DEDY63yFPrnpw1zRl6ucU5wauKVsY5WnxvTr9TahNPJMxhkf2oeqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=feoWZSg5; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43cfd96354aso3682080f8f.1
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 02:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775639178; x=1776243978; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NIhuu56MjNTiGSChY1cvm3H2MZijRdRaDUQH6s036E4=;
        b=feoWZSg5P7kF6fv47qFKXPWQBO0DaaIXa0DCjqrqzw9KVM27JVjM7cHPTMTcFWpuUU
         iNGwJFRxRMOUV3gyZhNyV8qBzXB61duaqBegKxlsdh+LeUSfMaKik0HyxiPCx3CEus8s
         swh1/M0Q3BkAtyVp/4wH4knQe0sNB5qv4SZRqy2X9h64GHipaypAVd/YZn5oVjDoW6BN
         LzG6BEoI0oWsGqzIR3AbM7SYC5QqVNLkbmVR4TdXA3S2QJfcxunwUH6lQZ0s2nDf8x0d
         BrbpaD2svigGW7vHnpJkII3F4tz2ytDE13z1RU9Zo52suMdWNB3lsUwgeNLdSOuLCPoF
         Ih0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775639178; x=1776243978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NIhuu56MjNTiGSChY1cvm3H2MZijRdRaDUQH6s036E4=;
        b=WmGw/d+nsxUCw5Ok4eYdiCI1O1MOYHjQ4aFdJmpnW1q/sTuBFntQUAyb/w1Jbin4WL
         O15+52h2OoDDNgUMgJiocTtXs428NJX/JNyNW7ohamcljU9Hr3Hpw5pT3C7Y7nv+Tf3q
         KspL6moU12kh2GBnZHw3YTQ8unIXRBTi+eLLyk7rQWLysKaO3+TSMyPS4QuBUnJqFCWg
         vu9qKAO3y/mhvZS5W8N69kwWKYiMnX1LQbF0hL5LMx3VLdoYou9KF4xg/FqQI3UvBAyZ
         4rUA8YS0ZhKATtICBnuc8DIUyF5zcpVP37gJdijFsxtcVPLh4OPGiEeG7cDhHbIdtpgZ
         EOww==
X-Forwarded-Encrypted: i=1; AJvYcCXLrIUrrqqCFm1cNPPZbAENix4aLyLqKNeBvxXyT+DPpEBYstXzGgDHmEihlIG09aCDgqRFnv1ZMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+orckPd7T0k32LYIlZ09K4B1+8xrghtk4Gm+wJ8MsFfZdSJjb
	r7DvuGRA+vw+TzaqazvVaL9rT99+EpvmVC8vLBRkMG2Hds9eKc9Qw+ZR9ZJJJg==
X-Gm-Gg: AeBDiesnurLWBOQhWDVEdBNwtpSMEFfcfvBEPMu2UnsIsDs0+CC/rglTEXqyr4E0xms
	uW6iIViyFCKM48SicagHLfyoC2Gp8d5PpNOqqjL0+tyBJIX524z1s7plU2xFiX4kDcWie0JSJ1j
	7ORQqHRFBvCA5vBZoKeiYGZ/YYK0wnEEk4YRWWzDT+XkrZfNPzV0wf7Wu26jpzEys1Mh7hLQH9S
	kNuTrdNDJ4CHwQebaI4SnS6VsCD6GSd5AzwYIWF7iohbtFnzfGtkxoUVDAQryzntsPEZ6zqLVG3
	XU8mMxc6M4J5zH64oNH4OZ3SILHlc6tzsq1V3S3VSOEMOmVV8Uqi4X/uanRzFFx1J5iyIa0P5Yp
	Xm3W8pCt2Qo1srOrR7Zg8qpK/tPI5F1CbTKy2G2GzwyekiNDjL6zermM01bAJfmE+MutHD0qPjf
	ViHtKxmPSJqDqaZurGJCvNPjpLYsnMaH+0r7SWf7YqLpGtACzrt8tMGuDT5iWZI2z9wlbn9VSPd
	2Stb1wAy4CFE1HZ1O7qovSxghVhf0Rfa80OGTy+fKP9aucM8qSuLKOrN9s=
X-Received: by 2002:a05:600c:4f4e:b0:488:a98b:b891 with SMTP id 5b1f17b1804b1-488a98bbd04mr227789945e9.3.1775639178483;
        Wed, 08 Apr 2026 02:06:18 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:eaba])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488a952a03asm293928175e9.0.2026.04.08.02.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 02:06:17 -0700 (PDT)
Message-ID: <b340d088-a221-43db-b524-1f181152db3d@gmail.com>
Date: Wed, 8 Apr 2026 10:06:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/zcrx: fix resource leak and double-free
 hazard in io_import_umem
To: KobaK <kobak@nvidia.com>, Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260408065408.2017967-1-kobak@nvidia.com>
 <20260408065408.2017967-4-kobak@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260408065408.2017967-4-kobak@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12981-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0702C3B9A74
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/8/26 07:54, KobaK wrote:
> From: Koba Ko <kobak@nvidia.com>
> 
> io_import_umem() has two problems:
> 
> 1. When io_account_mem() fails, the function returns an error but leaves
>     live pinned pages and sg_table in the mem struct without cleaning them
>     up. The caller happens to handle this today via io_zcrx_free_area() ->
>     io_release_area_mem(), but the contract is fragile.

That was the intention for the caller to clean it up, but in either
case the function has already been rewritten. In general, it seems
you based your patches on top of an outdated tree.

> 2. io_release_area_mem() doesn't NULL out mem->pages after kvfree(),
>     making it unsafe to call twice. Since io_zcrx_free_area() always
>     calls it during teardown, any earlier cleanup call would cause a
>     double-free.
> 
> Fix both: populate mem fields before io_account_mem() so
> io_release_area_mem() can do a proper cleanup on failure, and add
> mem->pages = NULL in io_release_area_mem() to make it idempotent.
> 
> Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
> Signed-off-by: Koba Ko <kobak@nvidia.com>
> ---
...
>   
>   static void io_release_area_mem(struct io_zcrx_mem *mem)
> @@ -236,6 +242,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
>   		sg_free_table(mem->sgt);
>   		mem->sgt = NULL;
>   		kvfree(mem->pages);
> +		mem->pages = NULL;

The entire struct io_zcrx_mem / area is freed right after,
calling io_zcrx_free_area() multiple times for the same area
is not allowed.

-- 
Pavel Begunkov


