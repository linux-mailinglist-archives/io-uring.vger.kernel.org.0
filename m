Return-Path: <io-uring+bounces-13015-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HtAJT/H12n6SwgAu9opvQ
	(envelope-from <io-uring+bounces-13015-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 17:35:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B78803CCC5F
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 17:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 54BD2306ECB1
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 15:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077383DA5D8;
	Thu,  9 Apr 2026 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="WZFzMhJf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2A93BD63D
	for <io-uring@vger.kernel.org>; Thu,  9 Apr 2026 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748497; cv=none; b=Zy3qZYrSmpaInu6zTU9WmVZVLWopYPGlVxXxZDzX9kERhgjIiHqrwyfwEIPWNh4iXPe/nM+xuhKOIczTIZTCohQCo/pjmcxFFSVo5hKTJlJAOMvzWcKJjiL/I0r0Hqdk2yHLwLAR2NZNb7pJIzgab+47l5dxrPyDpXy/dGHVU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748497; c=relaxed/simple;
	bh=5YEaSmY8unY1Fmy0wRi20aCnsCHSnS5xE/HbmAyT62E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=emZtBvX2xE2h4qsPhwlcvLX/1pB2CsFhnB+rgg/KKmMAVZ80AEPfUomV7MY8v7Lwx7fjwu+q9R6Zi0Tzkuv/OBdpWoS4dSIjvBms6dd9Ip5aGsqmQq6IovwTb8hP5Nb5oJrvcy1BO0FKbHmrjaYBuli/qGm0EWtHIdMNv9W6neo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=WZFzMhJf; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4779b2497b4so403414b6e.3
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2026 08:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775748494; x=1776353294; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOp8ak3FTEDXUJLajTWVJy0e9bkw0VrTeICwr/8Uur4=;
        b=WZFzMhJfk0j4TTalnUg3l0TqsEy9xK9aGulImpJD4Z+gCntaW4sQeAS9MlQlZXZGKZ
         nUOJ78uyOKqqbVnnAfwYGbNbT2Pu8EmemwXN14NfIwo+O8LVBB6yOljgolWxcU73kyrZ
         mjzxxKKKyJpLnyLTmuo/pWOyU1gSFGSD7esnyJ+NHA4MJ1C6cYbiFpZoaI3gE/YGzYbN
         3nTIJVmb7Zfpq+WkEn9yeTp3QZ7gyiaQa3ccHZGPsYmGrAe4FF66aJswBmua6GCIj83l
         rKSz/HL0aEh/FPA/0oNDyms8Oodd8uj/xorKO8m7wDlnKHo6OqBrtYLJFYaUEWcXl6p7
         NBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775748494; x=1776353294;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YOp8ak3FTEDXUJLajTWVJy0e9bkw0VrTeICwr/8Uur4=;
        b=T9lprCorsPuIHYDy9OvrTV6u+BrXKDrYZmbcpOI0iVQEWheKr5iBaPHVmm4sIx1J1+
         GkpjNmKmsfktAWQfRqgd2+1D7Y4dRTEm4HoUp+OUgkz7CYid2dlVQQJDd/vqJoZiMicP
         rgtm/SamXU59O6j2GqRTqf8/uAkpvpozC4mAonJJ1na3NLKoN6/bzfJHzf8u38/smxtF
         AvkjplEbgmAwQ9KQguznMCU8l/QpptiZB7dOei1S/6AvW1dyQd2eLplSC/2AmyuCGhuK
         Qf29jKHr2/8wpveEqMRR7t1IBMzKKS3fhTxZncGMxsjwv6MrSdrS1aMGeO1CmVRtq6mF
         Y9Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXo1TnQBF1X5F9aycTSSkBzydfxjJWH5SY5Au7S4YNbKIEfPM+wsF2PfJ/U/+/zrN6ZGvHPOT76Pw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6qA8VxMC912TvyWhhE0vjrEQYL/m5guE9pd3OGMO62XAdapsc
	vY3yylV3yw05PVTQampa29afytVzKWdW1eRWeBfc1VQ50oWzDnHC8F0TRT+2rnwNeUmSwiJHXKU
	vpQt6
X-Gm-Gg: AeBDievkw5psCbh4hnGtxw+WLrR3ME0Zw2aEHQV0FHWIfsdQikhZWHttU0yJUVpju6m
	vbZkC+fFCS/nyQCcPC1cP0fv3lKVRR08jQSpBKMRKbNkcevWetvAVs3BYkGsj6zrYRilMPw8I0E
	niV7aE554yMuoe5+hkBihflzNwpSkp4j+MPlc03Pj4nsnMKwtXS5x6EEJmtKKjlgwpvAOTCh1lE
	wPwME6rPY0mKiPvvG3P6/q5eCLV+1eOPfCC15q4K3P+GQo2ABBP5Zga/oI2DgY1+pvtrYaBbp78
	W16PbrrrmekwKHyjgS9fCsqRdeSnMql8nA/MM6WQpJtyadEVNh2XbM9LpMQPTwBiSSv2PpSw+oL
	GMQgRCYFW845O4e2h2YldzLzHhFCLm4HdB1mwWIoxqTYpYEWj3/Rrp1J8qmYSx+pcV0DnCL+c0R
	mFN36ndYtJPO10avHoTXCxN49rb731yG8g4bvzsesJx49PY7OCwhbCErrWKLFbRUq6GxEMqaSoj
	HnttlUojg==
X-Received: by 2002:a05:6808:6718:b0:467:272e:87d with SMTP id 5614622812f47-46ef60f5440mr13320054b6e.14.1775748494136;
        Thu, 09 Apr 2026 08:28:14 -0700 (PDT)
Received: from [10.21.14.152] ([65.132.165.41])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25ad44sm18302216fac.12.2026.04.09.08.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 08:28:13 -0700 (PDT)
Message-ID: <aae302b8-3f67-4331-8cf9-2784dcf25a91@kernel.dk>
Date: Thu, 9 Apr 2026 09:28:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix null-ptr-deref in io_uring_poll
To: l1zao@zju.edu.cn, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260409145525.36194-1-l1zao@zju.edu.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260409145525.36194-1-l1zao@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13015-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zju.edu.cn:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: B78803CCC5F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/9/26 8:55 AM, l1zao@zju.edu.cn wrote:
> From: Haocheng Yu <l1zao@zju.edu.cn>
> 
> A general protection fault in io_uring_poll is reported by a
> modified Syzkaller-based kernel fuzzing tool we developed. The
> crash occurs due to KASAN: null-ptr-deref.
> 
> This issue is likely caused by a race condition between 
> `io_uring_register` and `poll`. Specifically, in 
> io_uring/register.c/io_register_resize_rings(), ctx->rings is 
> set to NULL. Although this step is protected by a mutex lock 
> and a spin lock, io_uring/io_uring.c/io_uring_poll() calls 
> io_sqring_full and __io_cqring_events_user without holding the 
> lock, in which ctx->rings is accessed.
> 
> To fix this vulnerability, I moved the two function calls in
> io_uring_poll() that might access ctx->rings under the protection
> of spin_lock(&ctx->completion_lock).

Fixed a month ago, what tree are you running?

 commit 96189080265e6bb5dde3a4afbaf947af493e3f82
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Mar 9 14:21:37 2026 -0600

    io_uring: ensure ctx->rings is stable for task work flags manipulation

-- 
Jens Axboe

