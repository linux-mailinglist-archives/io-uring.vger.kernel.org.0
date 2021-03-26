Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09E34B1F9
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhCZWLj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhCZWLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:11:21 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0DBC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:11:21 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id f9so7151304oiw.5
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FElZ2VXGIlmQ0NTD4L5D6TBJnr5Rk+0sYfGma5bvPWY=;
        b=p6Mt1ZfdiegWNcxkCRJVOy2iZ68VFga3d5Sj5nuSneCEzCgG1eTinUYaQxnQFap4KG
         DvVYaBJPwIs3kIx1FIWiRSFLHWcprIT+Y3Gw+07Kep/ND5AIc6ofy15ywCFHn1j8bSOd
         BJpXEQFAg3N/FxvqmUegjEvxovkuM864SFBrSjWhBkQsRG+tu/6yFG84DAsbkvqt2/bG
         OrJU5kzgjHCyEFWJbiFO9XkAtKyLR6ypbPdd6+diyrXPP5FS7Jug1P4TQNx5ISV41QCb
         ygjuB7jPJ98qv6GEQXxlxq2YSqc2ZwJW7fsP6XtF2l9tzgIbni9fQNm3Kt1/IrsvUc1O
         Gueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FElZ2VXGIlmQ0NTD4L5D6TBJnr5Rk+0sYfGma5bvPWY=;
        b=oUYy9qCx01yisOKrT8s1fk4D8V7LsUw/gszJrgVKmx76xIkwImY3fTOzo+DK+/jw4Z
         K64+vKdN4VsyDI4NERkESiOdIA8VJm9v1l6oBOFap6LcCaO0TZcuWTbaiIB1HfSRYrkl
         p5lRhgPjkmmsVEfMa4FCFJG5oZ1VJW447PPNH6c5xVIEaafNfzl3Hf10iR9lAsvtKU0G
         EBqYqcRXwhl2DfyEn1pTnjeCKkagVfNVsIlQ+6SYmYfl2O1osKkOk7YMljmArjD1ZJUj
         IgtTqVuJYg0YSYdqRNRnturNfk1SDxrn32ifHARNEGidZ3LqM8c1gGXutw8O7I25MAnj
         F1ow==
X-Gm-Message-State: AOAM530i0ddpQw9ZHIRtKXBzA85TrtlGWRuSL4uatiHxIwgCnw5SoamK
        bsdRSJ+hgq8ONE6S0SwVhLkU/+cOWGggiw==
X-Google-Smtp-Source: ABdhPJz34nyTVLufa0fa93v446YAV/mFi84VcKGJUJ4L5NscXVI2szHQLGmrIIbqYBwvRgfwuxYYRw==
X-Received: by 2002:aca:4d4e:: with SMTP id a75mr11142631oib.107.1616796680712;
        Fri, 26 Mar 2021 15:11:20 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id a6sm2338894otb.41.2021.03.26.15.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:11:19 -0700 (PDT)
Subject: Re: [PATCH 1/7] kernel: don't call do_exit() for PF_IO_WORKER threads
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-2-axboe@kernel.dk> <m14kgxy7b4.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <80915fd5-7cb1-167a-2c8a-01a0f8f21bd2@kernel.dk>
Date:   Fri, 26 Mar 2021 16:11:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m14kgxy7b4.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 2:43 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Right now we're never calling get_signal() from PF_IO_WORKER threads, but
>> in preparation for doing so, don't handle a fatal signal for them. The
>> workers have state they need to cleanup when exiting, and they don't do
>> coredumps, so just return instead of performing either a dump or calling
>> do_exit() on their behalf. The threads themselves will detect a fatal
>> signal and do proper shutdown.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  kernel/signal.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index f2a1b898da29..e3e1b8fbfe8a 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -2756,6 +2756,15 @@ bool get_signal(struct ksignal *ksig)
>>  		 */
>>  		current->flags |= PF_SIGNALED;
>>  
>> +		/*
>> +		 * PF_IO_WORKER threads will catch and exit on fatal signals
>> +		 * themselves. They have cleanup that must be performed, so
>> +		 * we cannot call do_exit() on their behalf. coredumps also
>> +		 * do not apply to them.
>> +		 */
>> +		if (current->flags & PF_IO_WORKER)
>> +			return false;
>> +
> 
> Returning false when get_signal needs the caller to handle a signal
> adds a very weird and awkward special case to how get_signal returns
> arguments.
> 
> Instead you should simply break and let get_signal return SIGKILL like
> any other signal that has a handler that the caller of get_signal needs
> to handle.
> 
> Something like:
>> +		/*
>> +		 * PF_IO_WORKER have cleanup that must be performed,
>> +		 * before calling do_exit().
>> +		 */
>> +		if (current->flags & PF_IO_WORKER)
>> +			break;
> 
> 
> As do_coredump does not call do_exit there is no reason to skip calling into
> the coredump handling either.   And allowing it will remove yet another
> special case from the io worker code.

Thanks, I'll turn it into a break, that does seem like a better idea in
general. Actually it wants to be a goto or similar, as a break will
assume that we have the sighand lock held. With the coredump being
irrelevant, I'll just it before the do_exit() call.

-- 
Jens Axboe

