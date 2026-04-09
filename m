Return-Path: <io-uring+bounces-13016-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cB5IGsTH12n6SwgAu9opvQ
	(envelope-from <io-uring+bounces-13016-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 17:37:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F13733CCD23
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 17:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1AF253049EDF
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 15:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ADA3E120F;
	Thu,  9 Apr 2026 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="iInCU276"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D43CF699
	for <io-uring@vger.kernel.org>; Thu,  9 Apr 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748568; cv=none; b=b9lh/KXfyBXg+Lql93YwAzmzwXomPQrhKwKBA2laY/SnBEwmR+iXsBgTrPZcePCnLWa5DCeUIi+7awp0++pzZ/ryE5c1Yrd75DJonbQ3ZUobS7wYpN9Ewr4AkVXwdZeXL/mWj/yRuK55kL2BcR4WYcuEsfAueKki7AWw2bHcuUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748568; c=relaxed/simple;
	bh=LiUYQcthfKDQonlmXVa8cOTHsUnIN+/m16sy3rxZJ8Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MlpXS/ZYEixF0LNmctp5fu/T6NQFpaDFQEwY1F4sBWqQ8qiTq6Lcf7FXMweCOaKo/NhaXXs8IUnP6vhqAjCKieR89vDwuw5Qau/iQuPiu+oKpE5W5FWKkVadHk1TZeZAm46zjthAbTDMk4B37PZocwsmYUrHmjyuxuHwvjghjmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=iInCU276; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-471618e20a5so524433b6e.1
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2026 08:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775748566; x=1776353366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e3/rBfbbOXK6R8Y1rzXrASo6oVt/zTdU4x8sWgKCIsI=;
        b=iInCU276g8g9F7HjuWTRm9ZD868QjbDQ3OILXTpwbCp+q+G5qrCHvjHn/KF21aHAGJ
         5KolkJrlqlFhFWWR73EVPJWoHVJagEV9Wbxfqn+EXGT6JMejHi1VNnYItfcHz5Yl5o2Z
         Gb5EIB6Idkx4RfyJlZbpq9Gphv3zLsB0Tjxn5vJR1xztumN3GVUZH+ie9Oqq+WqjHfAQ
         vfCbEUeQg460BzuePdIgibnyab7nmRHq4m5rlEL3Q0+d8QcV9BOuN9rpGXhi9TzZ/iKX
         mnA9EGcEAeUbOmgu04x6zobXZ2Sub4ZJofYsIFJg+l+lx07FXrLI+DfzEHYs4rYxTBYm
         UEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775748566; x=1776353366;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3/rBfbbOXK6R8Y1rzXrASo6oVt/zTdU4x8sWgKCIsI=;
        b=gcxXy5Co/qtzQOSBClSZ971GAHcicD7ALfYj7yE1p/97XKTgIYHErDk3WSHNoe6cHC
         orZB7vG3mslnvUOMUyhzjW5nyl/VdLW2Km8MBs4koLKLJZOCFkLL/3igCgphvquJJ3bd
         hgDVZWI1YenOhZVJMugq5z3HHtblntPjHvIQLh6oWuQVDu7kYsoyXoUW/SHMO5LwChWk
         byvgQgLC3iVvxjHEHUDjQmwC3JLIiu6W81ZDTGWLs8BFCnmnFBuA0Oc1fMHlHolvi0Lo
         LWI6PL8GlwV3Tyk6oK+8v5Yt/hL0PwtrmKqn95jJ9g2bFNrVP7xnhUyDNko0rju0o1mS
         uzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWkZ1qDb5x4mxBtXOLg/xhCiuY7hWic8DYvAVoE9BqjjEF8XV1THPPB1zzIaxYCAOYE1qAe+Ncmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwE7YVBPtqbsoSC0jtISlzaw6384EIvaARhaiXcavDuruYakMtK
	IzUwhAiIgCX9WF4AanTVtZI66RBMAfCNHPE44sgJhXJj4ywuChrBc+Wl7dddMyiaFxY=
X-Gm-Gg: AeBDieu+L6kaz0TXQyBlXJvg3/yPvRAdXq9lhUXCjh1drl5YalyJvCtY2lY/q/aT4sx
	C4uPjNC9+Y+rn/PvOquKR/3lvklzFohi+0WoP17RvUV4mrZn6nv9U8XuF3QFuZjeeRSamYA9vTS
	e80mf5AF26x2DvRNW3C6NYCpsoWgZXKBbdSZaf3q5ht9PTIL7qwmFo/3xj8ZfX619HAZAd6SIQp
	NN47mbVVU0ktDyKvE5k5epyHHcsnxoRpS+DsWs2vIpfFT/dir0ZmaFqpaEogX5UQEL0hsnA4mEH
	0E26E714MxKA8oIkKu+F2PMAsNF8YHPCoTnINAux0D6ZB71LYi9hf9G4KPox4GxzPNHoXWWsTRb
	SR6JFmKiUkHJu032fntApcCYhtETPoDXV7Nr1y6houdD3S96UEYqXI5m+vhquw6dDLK1krzB9bs
	Q+dni6N9hC4Muj9F2NtlPmbXJVyZPQjrLS3H1tfpagC+Fpdrvy7SLfInaJSpE8HeTMkm2NgxLMl
	D6N2xttSuD70Y04RpwM
X-Received: by 2002:a05:6808:1803:b0:46a:e0cd:2723 with SMTP id 5614622812f47-47722d81478mr2175362b6e.21.1775748565925;
        Thu, 09 Apr 2026 08:29:25 -0700 (PDT)
Received: from [10.21.14.152] ([65.132.165.41])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eaed6647sm19804891fac.2.2026.04.09.08.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 08:29:25 -0700 (PDT)
Message-ID: <37b606c2-8b76-4034-9a3e-a088ec4cf546@kernel.dk>
Date: Thu, 9 Apr 2026 09:29:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix null-ptr-deref in io_uring_poll
From: Jens Axboe <axboe@kernel.dk>
To: l1zao@zju.edu.cn, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260409145525.36194-1-l1zao@zju.edu.cn>
 <aae302b8-3f67-4331-8cf9-2784dcf25a91@kernel.dk>
Content-Language: en-US
In-Reply-To: <aae302b8-3f67-4331-8cf9-2784dcf25a91@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13016-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zju.edu.cn:email,kernel.dk:email,kernel.dk:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: F13733CCD23
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/9/26 9:28 AM, Jens Axboe wrote:
> On 4/9/26 8:55 AM, l1zao@zju.edu.cn wrote:
>> From: Haocheng Yu <l1zao@zju.edu.cn>
>>
>> A general protection fault in io_uring_poll is reported by a
>> modified Syzkaller-based kernel fuzzing tool we developed. The
>> crash occurs due to KASAN: null-ptr-deref.
>>
>> This issue is likely caused by a race condition between 
>> `io_uring_register` and `poll`. Specifically, in 
>> io_uring/register.c/io_register_resize_rings(), ctx->rings is 
>> set to NULL. Although this step is protected by a mutex lock 
>> and a spin lock, io_uring/io_uring.c/io_uring_poll() calls 
>> io_sqring_full and __io_cqring_events_user without holding the 
>> lock, in which ctx->rings is accessed.
>>
>> To fix this vulnerability, I moved the two function calls in
>> io_uring_poll() that might access ctx->rings under the protection
>> of spin_lock(&ctx->completion_lock).
> 
> Fixed a month ago, what tree are you running?
> 
>  commit 96189080265e6bb5dde3a4afbaf947af493e3f82
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Mar 9 14:21:37 2026 -0600
> 
>     io_uring: ensure ctx->rings is stable for task work flags manipulation

Actually the poll part is this one:

commit 61a11cf4812726aceaee17c96432e1c08f6ed6cb
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Mar 31 07:07:47 2026 -0600

    io_uring: protect remaining lockless ctx->rings accesses with RCU

which is also upstream.

-- 
Jens Axboe


