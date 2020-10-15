Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51A028F4CA
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgJOOdj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgJOOdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:33:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B66C0613D2
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:33:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so4655700ioc.12
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XOgG5mhAn69DYbnkby1OfMXUNhYU9SfwTkzz6HCQ+CA=;
        b=GCwfdwqumfwqe+c65BGUp/h3eJXia4upa7fM1vDfP1vrkxGKGGiOLwSbseeyigDfQd
         tBzpxN1SkyJ+jjMVJzhq8KFKEbg2fxDaSjKmt2Vrh7YN1rCISHMi9T5AoavQDTZTGeYN
         j5gLJMUdRSJ3r5BiLUL6WBIqZGXFr6zMZCZ6Z2WlH/5Rs3Wdv5atF4lHRSUeppA7ar+7
         wW5oDCCHFSutyJHriJAqzYaOp0/J3DbxYymfR57uO7VYx6x+xfx+4XMRlFlQh6JK3UoT
         3EJ6hLCcGj23bZToN3NvuZZi2NitCPp72RFcDsptaLZ5QNdLkFoV2AzlbVt98rtULj7d
         i/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XOgG5mhAn69DYbnkby1OfMXUNhYU9SfwTkzz6HCQ+CA=;
        b=ZCbZdbO8pJUNpAfuRAjMgbiYqjLfO4HbRLNZ5FPZsa0jdzhRrTPT5I4YRVbZ7m5mfU
         lY5aAGfk2TZs8aGMb7DBwm82eP6ZsbZvOd7E75PE5m3niNeoMTvY2g5YXFe++8pg4WMa
         WwtqCc9Y+F8zgCc0MCws1TqkzXk+9aJkCutb9r8zOgd9Q7zmIqOzV+Cf+R0bqnbCvfC0
         uCUx1OLOBKhZtEFQ4zZs2S098ReXzYyGdS2w8v876zS7fw5X2If25hnq/YfTax0eQqFx
         1U/MhTbIbeto5FHzNYeulqA6DqmDJr3fXlDpKnKD9Q+MwY4k8tnNEYTXZQJ8my/UY9q+
         qy8w==
X-Gm-Message-State: AOAM532RtVxwcpZJ7QunHR5mPvmSsVYnPBfhTLZRE/9pcp+qNKHyWc8y
        D+Zzk/TOjkl+fU2ozUJ3OGWqrg==
X-Google-Smtp-Source: ABdhPJz6HCRgxHE/VdHqY2c+6G/morl849JJpM7idNUx8P3Z+O1zmATZwYNE2M+6h4i/XBhMlcoV4g==
X-Received: by 2002:a02:a10f:: with SMTP id f15mr3731510jag.62.1602772419025;
        Thu, 15 Oct 2020 07:33:39 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m7sm2730534iop.13.2020.10.15.07.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 07:33:38 -0700 (PDT)
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk> <20201015143151.GB24156@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
Date:   Thu, 15 Oct 2020 08:33:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015143151.GB24156@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 8:31 AM, Oleg Nesterov wrote:
> On 10/15, Jens Axboe wrote:
>>
>>  static inline int signal_pending(struct task_struct *p)
>>  {
>> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
>> +	/*
>> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
>> +	 * behavior in terms of ensuring that we break out of wait loops
>> +	 * so that notify signal callbacks can be processed.
>> +	 */
>> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
>> +		return 1;
>> +#endif
>>  	return task_sigpending(p);
>>  }
> 
> I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
> 
> Afaics, it is very easy to change all the non-x86 arches to support
> TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
> kernel/entry/common.c ?

I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
the generic entry code? Because you are right, it's usually pretty
trivial to wire up the arch code, regardless of whether it uses the
generic entry handling or not.

-- 
Jens Axboe

