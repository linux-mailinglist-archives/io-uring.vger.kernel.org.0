Return-Path: <io-uring+bounces-6418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D75A34B11
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D23C21894AF3
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEED202C22;
	Thu, 13 Feb 2025 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLRk/idI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D41FF7D8;
	Thu, 13 Feb 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739465584; cv=none; b=H/DsahKBdM+IlYBJz02rZtEPPIzXYj2eNaUz3JO9dnsUhr7aO+jxfPvuABu/oeGu6LIGPW6sfpyleT2ksWu/JbtycP2E+tGmEjeBRcqqoWTaTcMxBFgrufZac2ZFnSLHrDWV1XWcyzgv3PBt24FhMHsxwlX6qjjtFwtSV8jrL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739465584; c=relaxed/simple;
	bh=polAQ9tilScC5JTW41zteF2nqddHdhQUuGsprL/RIBg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=A7iCcxNIqXV+XhY3iaiu+QNeJNwl8mAaS0pGrrZhft6niOWJFZoWzBKfEKighJ6rE7dIIqTEP/6KwFHOueEbbN/L2ykDYgD9hgEbUCXhDdVMFMob9O/nOO+zD73ap9KqeN6J3naERrIOAwvh0nhVwm+I7N0c9mbkq7JVzcbCm6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLRk/idI; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5de56ff9851so2030699a12.2;
        Thu, 13 Feb 2025 08:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739465581; x=1740070381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WlBA33B7yvNcgiv/bwff6o3v2gP6onb0YF3rR6KhJ14=;
        b=DLRk/idIyJ4GzvgGiNtGvqWoE/fAROdNgt25AGL6lXRwlyDg4JfYybTfXikAjLbhQ9
         yRuSw1I4WLYkk2uK6inrNZaLS7+Azb52sSONvTnw9bcYeGkG2JibzpiDcCbzCMC/2ZFW
         EFRlcAjJ75NnCn1tncDedi3IXu4PTUSHDBsA9YUlNbtc06IZ3KOh2p0zJuOUVvgcukil
         hFeJgtCpFBFDuHN6jFoGqRPqaG/pNhDok8Kw465FwEATmw4qo2j1/qUpeB6deabIlKqR
         NAAhd44QqulcuHn6eNCjYVz4CAvGQEZSE/JEkJB3tJuf/8GO2IAqnhHZQYqIqXsbkNKO
         P65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739465581; x=1740070381;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlBA33B7yvNcgiv/bwff6o3v2gP6onb0YF3rR6KhJ14=;
        b=uAj15LTF45ja84CfCUzlI7QBWFkvv0PEfewd9UwkwNI+61nnmSyta5/NyokspxN80v
         a1zm057EdodiTOx8H65NUHHZGyn2vlYxAJxShspcSRkckL1gZx1hUYS0zIx2yWENxQPY
         74RmhB5M0bO6pefwyNc8avLkN9t0JNd9ArWvJ2znrj4Ybt/cUL4spMe+RA/SRHWUTdOu
         u6Teb4e0Iy3Ma9crka91/KsbyXjKaKgpu4M2VLNHXJ8IJ3u1jUuzLLU8dpvJ2cd2o2hB
         pQCUM/uMPfTuN4hx4Sw5SqPeZJxVaGv7gs2rWsP/vMauK0GtPCKtpcjZwoQqSdyXjkoH
         WQNw==
X-Forwarded-Encrypted: i=1; AJvYcCVAB6mwqCE4KtLxsVhjvZjmtXCwE9Wys3yy5GymE5kRamJjSfoPT/BZ6a9CyXf7VdcnZ1YWmw6NLx28UPo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy87HwckCk7O2b80lhVttJfKcWvUkrAMT9tYC3EdVezpINds1NM
	l84/O76BUs0O969FuiNdEnbaRMlCb6S3ZryqCP55FeUbik6D5rsi
X-Gm-Gg: ASbGncsBDUMXbphrly8Fc8UHmgWhvWRBwDC43JV9/yZwwABT2cQ53kGEuqp1iZFZeN2
	RCeTBg0cJQ+69JnIoMD2NJoFVhu7RB4PrCqFxkjQEyWIPeHlxwvxQPn8A+5sIb6KCTGS/TM9gJs
	vP1thj4+qoTFl3CsglvZMOw0Pm5VsGs3FbNQJDnINaddFN++TtTB49Efno4pdbYP+TYr+1WV6l6
	LDs2VvwqZUBgq44evIRjFVhVLw9+6sf1SVqxq2MSlaZtyF6Y5NX9iZuu4ehQRYVKP4+IeIu3MBl
	ObB0DDavLMLBlHrZR3oMkM6cq3MwT5y/auEfBKUEJpyXRDge
X-Google-Smtp-Source: AGHT+IETK3I2giqsUZQTeB3pgG+6yZ3AuYcaLY4uRdtRY/WZgkgagbWjOofAOBcWUZP4aDVBIL5ZGQ==
X-Received: by 2002:a05:6402:518a:b0:5d0:b51c:8479 with SMTP id 4fb4d7f45d1cf-5deb08806bamr7087690a12.10.1739465580880;
        Thu, 13 Feb 2025 08:53:00 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1cb7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece270cbcsm1522889a12.49.2025.02.13.08.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 08:53:00 -0800 (PST)
Message-ID: <bdff3648-72cc-4dd1-95cf-f4a9bedbdb12@gmail.com>
Date: Thu, 13 Feb 2025 16:54:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: pass struct io_tw_state by value
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211214539.3378714-1-csander@purestorage.com>
Content-Language: en-US
In-Reply-To: <20250211214539.3378714-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 21:45, Caleb Sander Mateos wrote:
> 8e5b3b89ecaf ("io_uring: remove struct io_tw_state::locked") removed the
> only field of io_tw_state but kept it as a task work callback argument
> to "forc[e] users not to invoke them carelessly out of a wrong context".

The other unnamed reason was to limit the mess from io_uring wide
changes while it might still be used later on. It's always a pain
for backporting, so if we're doing that we might as well make it
easily convertible for future plans. Let's do

typedef struct io_tw_state iou_state_t;

Might be useful for leaking it to cmds as well.

> Passing the struct io_tw_state * argument adds a few instructions to all
> callers that can't inline the functions and see the argument is unused.
> 
> So pass struct io_tw_state by value instead. Since it's a 0-sized value,
> it can be passed without any instructions needed to initialize it.
> 
> Also add a comment to struct io_tw_state to explain its purpose.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>   include/linux/io_uring_types.h |  3 ++-
>   io_uring/futex.c               |  6 +++---
>   io_uring/io_uring.c            | 30 +++++++++++++++---------------
>   io_uring/io_uring.h            |  8 ++++----
>   io_uring/msg_ring.c            |  2 +-
>   io_uring/notif.c               |  2 +-
>   io_uring/poll.c                |  4 ++--
>   io_uring/poll.h                |  2 +-
>   io_uring/rw.c                  |  2 +-
>   io_uring/rw.h                  |  2 +-
>   io_uring/timeout.c             |  6 +++---
>   io_uring/uring_cmd.c           |  2 +-
>   io_uring/waitid.c              |  6 +++---
>   13 files changed, 38 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e2fef264ff8b..4abd0299fdfb 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -434,10 +434,11 @@ struct io_ring_ctx {
>   	struct io_mapped_region		ring_region;
>   	/* used for optimised request parameter and wait argument passing  */
>   	struct io_mapped_region		param_region;
>   };
>   
> +/* Token passed to task work callbacks to indicate ctx->uring_lock is held */

It indicates the current context not locking specifically, which is
why the chunk from waitid as below is not correct:

mutex_lock(uring_lock);
struct io_tw_state dummy;
io_uring_core_helper(&dummy);
mutex_unlock(uring_lock);


Probably something like "Token passed around to indicate the current
io_uring execution context". And it doesn't need to be more specific
as long as type system works for us. It might be a good idea to add
a note in bold that nobody outside of core io_uring is allowed
creating it, though it'll be ignored anyway.

>   struct io_tw_state {
>   };


-- 
Pavel Begunkov


