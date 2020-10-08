Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741AC287548
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgJHNgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgJHNgv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 09:36:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C4AC0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 06:36:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o9so1169683ilo.0
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 06:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TWTwXIj0L8xa+FBpCmwxg7lRe37fpsWn0tjf6Fq15Bs=;
        b=YPQlOXH4+pkKlBbCaiM6TOTeJ4u+Lblv/2JzZp7G4ZSiKCus/RpHWmPPcTlPlCePiQ
         RzAYVlamHKqTTjrSPviKh+W+pfpr7ahFIOrbIj+DiTEoAz2atmIl4lmJBgzwRQ5mjxLh
         /CeHRisrYL3l7qBs19QD9diJDp18TKCuDqwSGmQOvZJqbGVoOEha1RwOx4nuJItqICGy
         2ZsHuTgbw/sDDfsaV74If+mw4ITK1jDK2SqAUSGm60sSyvPRWQFgZuDUXDBNDkQyU+Ju
         ZUybUI5xE4jDAfpuGzm/mt3SwSeYG0W53fq2TGl1eqR624m1saZdfZPLJ1lItEsJfsrb
         BehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TWTwXIj0L8xa+FBpCmwxg7lRe37fpsWn0tjf6Fq15Bs=;
        b=gQrv0n/5Td3oYpZCJ+r5QN76OfEhXLO+iweypNeh37PwlZEVEZBXN9XoZecYhNDkgd
         uEyYOxw1ljFqAH4f/rqZlfxJMngLiHOfl0W+1inoO4hBKhootZcYhMltceTZqvYh91uN
         zrtF5iCsNGBYfCbbmcu9VVll5+oWf4P72srx0KxIvU+ody02zSfNOfwLZsR6Cnd4temK
         r+1sS2aOwhjDCICRWkb3BPReNugeOFh0AMuOvjGWBLNmUwyiFRnjE9/5BjUySrMwpr06
         LxPiHxHpSF/8ooAigBG7t0Yp4au052SZCCaWO5jhfV4HrxGUtthfN1T9JUXnqMY+IKSP
         mNXw==
X-Gm-Message-State: AOAM532j7NKQQTukuKTPWyzh3fzqNH17h2YXyUlBVY2FYiDrUFEpId6y
        MIh9NglnR1zS3cPdoI5V78mb0Q==
X-Google-Smtp-Source: ABdhPJx8GiD/1HstA6TIV4JLcm0JBF26DB5TPoP8Q5r4GOol2R0QZJZnqlGtGj2jrtSGBRb7WT33ZQ==
X-Received: by 2002:a92:1bd6:: with SMTP id f83mr6366869ill.274.1602164210620;
        Thu, 08 Oct 2020 06:36:50 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s13sm2606630ilq.16.2020.10.08.06.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 06:36:49 -0700 (PDT)
Subject: Re: [PATCH 2/6] kernel: add task_sigpending() helper
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-3-axboe@kernel.dk> <20201008125831.GE9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e92cd34-c58c-ec5e-3ba0-9d8d87fbebef@kernel.dk>
Date:   Thu, 8 Oct 2020 07:36:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008125831.GE9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 6:58 AM, Oleg Nesterov wrote:
> On 10/05, Jens Axboe wrote:
>>
>>  static inline int signal_pending_state(long state, struct task_struct *p)
>>  {
>>  	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
>>  		return 0;
>> -	if (!signal_pending(p))
>> +	if (!task_sigpending(p))
>>  		return 0;
> 
> This looks obviously wrong. Say, schedule() in TASK_INTERRUPTIBLE should
> not block if TIF_NOTIFY_SIGNAL is set.
> 
> With this change set_notify_signal() will not force the task to return
> from wait_event_interruptible, mutex_lock_interruptible, etc.

True, not sure why I made the distinction there. I'll fix that one up.

> 
>>  	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
>> @@ -389,7 +394,7 @@ static inline bool fault_signal_pending(vm_fault_t fault_flags,
>>  {
>>  	return unlikely((fault_flags & VM_FAULT_RETRY) &&
>>  			(fatal_signal_pending(current) ||
>> -			 (user_mode(regs) && signal_pending(current))));
>> +			 (user_mode(regs) && task_sigpending(current))));
> 
> This looks unnecessary,

Dropped

>> @@ -773,7 +773,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
>>  		data += sizeof(siginfo_t);
>>  		i++;
>>  
>> -		if (signal_pending(current))
>> +		if (task_sigpending(current))
> 
> This too.
> 
> IMO, this patch should do s/signal_pending/task_sigpending/ only if it is
> strictly needed for correctness.

Agree, I'll kill the ones you identified.

-- 
Jens Axboe

