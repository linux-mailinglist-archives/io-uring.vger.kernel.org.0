Return-Path: <io-uring+bounces-2488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD35492D7CA
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B8321C2119F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 17:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A03B195383;
	Wed, 10 Jul 2024 17:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqWVF0VV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65151946C0;
	Wed, 10 Jul 2024 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720634131; cv=none; b=t/2D13ofV4eJOnlFr+klTNsJK5KY1wueZG4k22L2eT9ovIsxRd/oT+xFHk4dBxjFHrUD96+ob9165WVAQpUnkpdq/FZG8J7cGufKulsjOKGErZ/wHjXIolJLuuMTAoThGJokkaLwhYaS2sNYNUIEv+gzqHJeMs2tOZkAD+/9prY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720634131; c=relaxed/simple;
	bh=5ovONu/gt/l72H339C0fsJXZz0IcZrL9RE0zm1Ow/qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+4gX+wzoEccZcoW8rAZXD0qhffYfQDBk+aki4OaaOgWdxReq/OeHVEIya8gDwScfY+aLcL4uSWrxXxL2BIECTtArJgipFKopfBAEbDBSeNBmg6eP90F6ntm3ANWaogrrUt4BpYx9DnztOLgtzQxWBSzK86GGwH9WzZJDgrfzDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqWVF0VV; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so8384a12.3;
        Wed, 10 Jul 2024 10:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720634128; x=1721238928; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CoQdoHALlWjblrZ5nDXd5J1da25dw5aw8J0CxBkO4Tg=;
        b=NqWVF0VVFxWnkvZ3yF+DmS48Dqdq8okzTXjOOVy+Yw03BOjY4xcrRvMAOKzpM5tjDn
         wbBqLrHs8RjKSb7yffUbTqzC6H7q+ytNVRk4kiVYf3TtKqOOgpnynzcAjbdOF+Vpsk4x
         eqx1l4hwEk5ys6Fg3RvWeQupJBI97zUVVun6TKSYG18dE0qJIfGBaO3xGtudzuGAygvR
         mR9AMD/QTXRURfEC7M9QZWlIntIMm40SOEm0xMKaN9keQvj/5EeBSVDiL1FC0MlkSIJ0
         kNDAJqh8gtQ1WVnwWbGnV7wyJITJMpyIWDNvEWygtYRtDnkxiG6DwYtgkWIoWk7eII78
         e5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720634128; x=1721238928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CoQdoHALlWjblrZ5nDXd5J1da25dw5aw8J0CxBkO4Tg=;
        b=BklS4yN8/vTVFIYpvK5kb2LYG+KbzJnjmqTVrafJq1vXVI7KL+SP+8vphnkhoIOpRs
         tzPrkUcY+vuoZLgugmpm+ZmDJCECg8qu5zfE6uYT8bEHkVhWDcOB4PmDVD90h3wWJV+K
         p+bMRbagYhK5sFIfiilhKTLkR39/EN6IH8mFyiZWN9SMOOkLEb5yIoBTQ0tXgzDBhxQl
         UG/XBJZKUV9OrwZuls5x7m7nwsj2UBioBRkby/2rg3qPAqX+jBFIFXIKtqoVfANt0JQU
         AT3ZamRCUq/JiL3tTRxlt9vy2lLhrpDuiQOLrVfLsH9+9B7BsdDNPwBUvu6DwbsOwlpR
         hNYA==
X-Forwarded-Encrypted: i=1; AJvYcCU/0R+lb04crBLWeKEs7CRliTb5HWCzItCBqoZHvTMUt/SNpGhCroSqDPm6JdJhxn4OwzliiggWz6MYhCTj2i0drfJvSaCdGTToflDp
X-Gm-Message-State: AOJu0YxWneCpqvOOQnDR/4WUY37mHzwYJrXgn0PWNlMLDbeI3th+YeFL
	AMFRUPaimmf6/BoMPLJaMGkThezWLxbQu+7ShiCOnAzomombiyxhuGl1iQ==
X-Google-Smtp-Source: AGHT+IFUJFP7VzxS3QUnlobkd+6wp7pFozFHmvtAZSsyxk1IvKJhcNicPOZXDj+OKBRuHCoPs4KG4g==
X-Received: by 2002:a05:6402:2791:b0:58d:115c:f529 with SMTP id 4fb4d7f45d1cf-594ba997550mr4883987a12.7.1720634127958;
        Wed, 10 Jul 2024 10:55:27 -0700 (PDT)
Received: from [192.168.42.235] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bba54b07sm2455675a12.14.2024.07.10.10.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 10:55:27 -0700 (PDT)
Message-ID: <8cb29846-7e48-4308-ae4e-70b0e270dbb8@gmail.com>
Date: Wed, 10 Jul 2024 18:55:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Tejun Heo <tj@kernel.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Peter Zijlstra <peterz@infradead.org>
References: <cover.1720534425.git.asml.silence@gmail.com>
 <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>
 <Zo3cdEMZVOJcseWm@slm.duckdns.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zo3cdEMZVOJcseWm@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/24 01:57, Tejun Heo wrote:
> On Tue, Jul 09, 2024 at 03:27:19PM +0100, Pavel Begunkov wrote:
>> io_uring can asynchronously add a task_work while the task is getting
>> freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
>> do_freezer_trap(), and since the get_signal()'s relock loop doesn't
>> retry task_work, the task will spin there not being able to sleep
>> until the freezing is cancelled / the task is killed / etc.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/systemd/systemd/issues/33626
>> Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
>> Reported-by: Julian Orth <ju.orth@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> I haven't looked at the signal code for too long to be all that useful but
> the problem described and the patch does make sense to me. FWIW,
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Maybe note that this is structured specifically to ease backport and we need
> further cleanups? It's not great that this is special cased in

I'll add a couple of words

> do_freezer_trap() instead of being integrated into the outer loop.

v1 had it in the common loop, but might actually be good it's
limited to freezing, need more digging.

-- 
Pavel Begunkov

